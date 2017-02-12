/*
 * mtd - simple memory technology device manipulation tool
 *
 * Copyright (C) 2005 Waldemar Brodkorb <wbx@dass-it.de>,
 *	                  Felix Fietkau <nbd@openwrt.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: mtd.c 3991 2006-06-18 18:03:31Z nico $
 *
 * The code is based on the linux-mtd examples.
 */

#include <limits.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <errno.h>
#include <error.h>
#include <time.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/reboot.h>
#include <string.h>

#include <getopt.h>

#include "mtd.h"
#include "crc32.h"

#define DEV_CHECKSUM "/dev/mtd/6"
#define DEV_KRENEL "/dev/mtd/4"
#define DEV_ROOTFS "/dev/mtd/2"
#define KERNEL_LENGTH 786432
#define ROOTFS_LENGTH 1024*64*16*2
#define HEAD_LEN 128
#define TRX_MAGIC       0x30524448      /* "HDR0" */
#define BUFSIZE (16 * 1024)
#define MAX_ARGS 8

#define DEBUG

#define SYSTYPE_UNKNOWN     0
#define SYSTYPE_BROADCOM    1
/* to be continued */

#define	MIN(a,b) (((a)<(b))?(a):(b))
#define	MAX(a,b) (((a)>(b))?(a):(b))

struct trx_header
{
	uint32_t magic;		/* "HDR0" */
	uint32_t len;		/* Length of file including header */
	uint32_t crc32;		/* 32-bit CRC from flag_version to end of file */
	uint32_t flag_version;	/* 0:15 flags, 16:31 version */
	uint32_t offsets[3];	/* Offsets of partitions from start of header */
};

char buf[BUFSIZE];
int buflen;
int upgrade_flag = 0;


static int my_mtd_write(int imagefd,unsigned int imgOffset , const char *mtd,  size_t imgSize , int quiet, int check );
#if ROOTFS_CHECKSUM
//extern unsigned long crc32(unsigned long ,const unsigned char *, unsigned int);
static mycount = 0;
static int crc_table_empty = 1;
static unsigned long crc_table[256];
static void init_crc_table()
{
	static const unsigned char p[] = {0,1,2,4,5,7,8,10,11,12,16,22,23,26};
	unsigned long c, poly;
	int n, k;
	poly = 0L;
	for (n = 0; n < sizeof(p)/sizeof(unsigned char); n++)
		poly |= 1L << (31 - p[n]);
	for (n = 0; n < 256; n++)
	{
		c = (unsigned long )n;
		for (k = 0; k < 8; k++)
			c = c & 1 ? poly ^ (c >> 1):c >> 1;
		crc_table[n] = c;
	}

	crc_table_empty = 0;
}

static unsigned long crc;



#endif
int
image_check_bcom(int imagefd, const char *mtd)
{
	struct trx_header *trx = (struct trx_header *) buf;
#if (BOARD == rtl8196b)
	unsigned long block_size;
#else
	struct mtd_info_user mtdInfo;
#endif
	int fd;

	buflen = read(imagefd, buf, 32);
	if (buflen < 32)
	{
		fprintf(stdout, "Could not get image header, file too small (%ld bytes)\n", buflen);
		return 0;
	}

	switch (trx->magic)
	{
	case 0x47343557: /* W54G */
	case 0x53343557: /* W54S */
	case 0x73343557: /* W54s */
	case 0x46343557: /* W54F */
	case 0x55343557: /* W54U */
		/* ignore the first 32 bytes */
		buflen = read(imagefd, buf, sizeof(struct trx_header));
		break;
	}

	if (trx->magic != TRX_MAGIC || trx->len < sizeof(struct trx_header))
	{
		fprintf(stderr, "Bad trx header\n");
		fprintf(stderr, "If this is a firmware in bin format, like some of the\n"
				"original firmware files are, use following command to convert to trx:\n"
				"dd if=firmware.bin of=firmware.trx bs=32 skip=1\n");
		return 0;
	}

	/* check if image fits to mtd device */
	fd = mtd_open(mtd, O_RDWR | O_SYNC);
	if (fd < 0)
	{
		fprintf(stderr, "Could not open mtd device: %s\n", mtd);
		exit(1);
	}
#if (BOARD == rtl8196b)
	if( ioctl(fd, BLKGETSIZE, &block_size) < 0 ) {
		fprintf(stderr, "Could not get block size from %s\n", mtd);
		exit(1);
	}
#else
	if (ioctl(fd, MEMGETINFO, &mtdInfo))
	{
		fprintf(stderr, "Could not get MTD device info from %s\n", mtd);
		exit(1);
	}
#endif
	if (block_size*512 < trx->len)
	{
		fprintf(stderr, "Image too big for partition: %s\n", mtd);
		close(fd);
		return 0;
	}
	close(fd);
	return 1;
}

int
image_check(int imagefd, const char *mtd)
{
	int  systype;

	systype = SYSTYPE_UNKNOWN;
	switch (systype)
	{
	case SYSTYPE_BROADCOM:
		return image_check_bcom(imagefd, mtd);
	default:
		return 1;
	}
}

int mtd_check(char *mtd)
{
	struct mtd_info_user mtdInfo;
	int fd;

	fd = mtd_open(mtd, O_RDWR | O_SYNC);
	if (fd < 0)
	{
		fprintf(stderr, "Could not open mtd device: %s\n", mtd);
		return 0;
	}
#if (BOARD != rtl8196b) 
	if (ioctl(fd, MEMGETINFO, &mtdInfo))
	{
		fprintf(stderr, "Could not get MTD device info from %s\n", mtd);
		close(fd);
		return 0;
	}
#endif
	close(fd);
	return 1;
}

int
mtd_unlock(const char *mtd)
{
	int fd;
	struct mtd_info_user mtdInfo;
	struct erase_info_user mtdLockInfo;

	fd = mtd_open(mtd, O_RDWR | O_SYNC);
	if (fd < 0)
	{
		fprintf(stderr, "Could not open mtd device: %s\n", mtd);
		exit(1);
	}
#if (BOARD != rtl8196b)
	if (ioctl(fd, MEMGETINFO, &mtdInfo))
	{
		fprintf(stderr, "Could not get MTD device info from %s\n", mtd);
		close(fd);
		exit(1);
	}

	mtdLockInfo.start = 0;
	mtdLockInfo.length = mtdInfo.size;
	if (ioctl(fd, MEMUNLOCK, &mtdLockInfo))
	{
		close(fd);
		return 0;
	}
#endif
	close(fd);
	return 0;
}

int
mtd_open(const char *mtd, int flags)
{
	FILE *fp;
	char dev[PATH_MAX];
	int i;

	if ((fp = fopen("/proc/mtd", "r")))
	{
		while (fgets(dev, sizeof(dev), fp))
		{
			if (sscanf(dev, "mtd%d:", &i) && strstr(dev, mtd))
			{
				snprintf(dev, sizeof(dev), "/dev/mtd%d", i);
				fclose(fp);
				return open(dev, flags);
			}
		}
		fclose(fp);
	}

	return open(mtd, flags);
}

int
mtd_erase(const char *mtd)
{
	int fd;
	struct mtd_info_user mtdInfo;
	struct erase_info_user mtdEraseInfo;

	fd = mtd_open(mtd, O_RDWR | O_SYNC);
	if (fd < 0)
	{
		fprintf(stderr, "Could not open mtd device: %s\n", mtd);
		exit(1);
	}

	if (ioctl(fd, MEMGETINFO, &mtdInfo))
	{
		fprintf(stderr, "Could not get MTD device info from %s\n", mtd);
		close(fd);
		exit(1);
	}

	mtdEraseInfo.length = mtdInfo.erasesize;

	for (mtdEraseInfo.start = 0;
		mtdEraseInfo.start < mtdInfo.size;
		mtdEraseInfo.start += mtdInfo.erasesize)
	{

		ioctl(fd, MEMUNLOCK, &mtdEraseInfo);
		if (ioctl(fd, MEMERASE, &mtdEraseInfo))
		{
			fprintf(stderr, "Could not erase MTD device: %s\n", mtd);
			close(fd);
			exit(1);
		}
	}       

	close(fd);
	return 0;

}

int
mtd_write(int imagefd, const char *mtd, int quiet)
{
	int fd, i, result;
	size_t r, w, e;
	struct mtd_info_user mtdInfo;
	struct erase_info_user mtdEraseInfo;
	int ret = 0;

	fd = mtd_open(mtd, O_RDWR | O_SYNC);
	if (fd < 0)
	{
		fprintf(stderr, "Could not open mtd device: %s\n", mtd);
		exit(1);
	}

	if (ioctl(fd, MEMGETINFO, &mtdInfo))
	{
		fprintf(stderr, "Could not get MTD device info from %s\n", mtd);
		close(fd);
		exit(1);
	}

	r = w = e = 0;
	if (!quiet)
		fprintf(stderr, " [ ]");

	for (;;)
	{
		/* buffer may contain data already (from trx check) */
		r = buflen;
		r += read(imagefd, buf + buflen, BUFSIZE - buflen);
		w += r;

		/* EOF */
		if (r <= 0)	break;

		/* need to erase the next block before writing data to it */
		while (w > e)
		{
			mtdEraseInfo.start = e;
			mtdEraseInfo.length = mtdInfo.erasesize;

			if (!quiet)
				fprintf(stderr, "\b\b\b[e]");
			/* erase the chunk */
			if (ioctl (fd,MEMERASE,&mtdEraseInfo) < 0)
			{
				fprintf(stderr, "Erasing mtd failed: %s\n", mtd);
				exit(1);
			}
			e += mtdInfo.erasesize;
		}

		if (!quiet)
			fprintf(stderr, "\b\b\b[w]");

		r = BUFSIZE;
		if ((result = write(fd, buf, r)) < r)
		{
			if (result < 0)
			{
				fprintf(stderr, "Error writing image.\n");
				exit(1);
			} else
			{
				fprintf(stderr, "Insufficient space.\n");
				exit(1);
			}
		}

		buflen = 0;
	}
	if (!quiet)
		fprintf(stderr, "\b\b\b\b");

	close(fd);
	return 0;
}

static int mtd_upgrade(int imagefd, uint32_t koffset, const char *kMtdName,size_t ksize
					   , uint32_t roffset, const char *rMtdName, size_t rsize, const char *cMtdName, int quiet)
//static int mtd_upgrade(int imagefd, const char *mtd_kernel, int quiet, unsigned offset)
{

	unsigned char *mybuf;   
	unsigned long mychecksum;
	size_t writebytes;


//fprintf(stderr,"\n  %s:%d:%s() ++ imagefd=%d ,\n", __FILE__, __LINE__, __FUNCTION__   ,imagefd  ) ;
//fprintf(stderr,"\n  %s:%d:%s() ++ koffset=%d kMtdName=%s \n", __FILE__, __LINE__, __FUNCTION__   ,koffset ,kMtdName ) ;
//fprintf(stderr,"\n  %s:%d:%s() ++ roffset=%d rMtdName=%s \n", __FILE__, __LINE__, __FUNCTION__   ,roffset ,rMtdName ) ;
//fprintf(stderr,"\n  %s:%d:%s() ++ cMtdName=%s \n", __FILE__, __LINE__, __FUNCTION__    ,cMtdName ) ;




	mtd_unlock(kMtdName);

	my_mtd_write(imagefd, koffset,kMtdName,ksize, quiet,0);

	mtd_unlock(rMtdName);

	//add by franky to test led

	//if((mybuf = (unsigned char *)malloc(1024*64*16*2)) == -1){

	//	fprintf(stderr,"malloc error\n");
	//	exit(1);
//	}

//	if(read(imagefd, mybuf,ROOTFS_LENGTH)== -1){
//		fprintf(stderr,"read error\n");
//		exit(1);

//	}

//	mychecksum = crc32(0,mybuf,ROOTFS_LENGTH);

	//just test
	//fprintf(stderr,"\nkernel write done!\n");

//	my_mtd_writecheck(mychecksum,DEV_CHECKSUM, quiet);

//	free(mybuf);

//	lseek(imagefd,offset+KERNEL_LENGTH,SEEK_SET);
//fprintf(stderr,"\n  %s:%d:%s() ++ \n", __FILE__, __LINE__, __FUNCTION__    ) ;  
	//add write rootfschecksum by franky
	crc = 0xFFFFFFFF;
	my_mtd_write(imagefd, roffset,rMtdName , rsize, quiet,1);
//fprintf(stderr,"\n  %s:%d:%s() ++ \n", __FILE__, __LINE__, __FUNCTION__    ) ;
	crc = crc ^ 0xFFFFFFFF;
#if (BOARD != rtl8196b) 
	if (cMtdName)
	{
		fprintf(stderr,"\nWriting CRC = 0x%08x \n" , crc );
		my_mtd_writecheck(crc, cMtdName, quiet);
	}
#endif
}


static int my_mtd_writecheck(unsigned long mychecksum, const char *mtd,int quiet)
{
	int fd,i,result;

	size_t r,w,e;
	struct mtd_info_user mtdInfo;
	struct erase_info_user mtdEraseInfo;
	int ret = 0;

	fd = mtd_open(mtd ,O_RDWR|O_SYNC);
	if (fd < 0)
	{
		fprintf(stderr, "Could not open mtd device: %s\n", mtd);
		exit(1);

	}
#if (BOARD != rtl8196b)
	if (ioctl(fd, MEMGETINFO, &mtdInfo))
	{
		fprintf(stderr, "Could not get MTD device info from %s\n", mtd);
		close(fd);
		exit(1);
	}
	r = w = e = 0;

	if (!quiet)
		fprintf(stderr, " [ ]");



	// need to erase the next block before writing date to it

	mtdEraseInfo.start = e;
	mtdEraseInfo.length = mtdInfo.erasesize;

	if (!quiet)
		fprintf(stderr,"\b\b\b\[e]");
	//begin to erase	      
	if (ioctl(fd,MEMERASE,&mtdEraseInfo) < 0)
	{
		fprintf(stderr ,"Erasing mtd failed : %s \n",mtd);
		exit(1);
	}
#endif

	if (( result = write(fd,&mychecksum,sizeof(unsigned long))) <0 )
	{
		fprintf(stderr, "write error \n");
		exit(1);
	}

	fprintf(stderr,"write rootfschecksum\n");
	close(fd);
	return 0;    
}



static int
my_mtd_write(int imagefd,unsigned int imgOffset , const char *mtd,  size_t imgSize , int quiet, int check )
{
	int fd, i, bytesWritten;
	size_t bytesInBuffer, w, e;
#if (BOARD == rtl8196b)
	unsigned long block_size;
#else
	struct mtd_info_user mtdInfo;
#endif
	struct erase_info_user mtdEraseInfo;
	int ret = 0;
	unsigned int byteRead=0;
	int count=0,led_status=0;

	if( imgOffset >=0)
	{
		lseek(imagefd , imgOffset, SEEK_SET);
	}
	

	fd = mtd_open(mtd, O_RDWR | O_SYNC);
	if (fd < 0)
	{
		fprintf(stderr, "Could not open mtd device: %s\n", mtd);
		exit(1);
	}

#if (BOARD == rtl8196b)
	if( ioctl(fd, BLKGETSIZE, &block_size) < 0 ) {
		fprintf(stderr, "Could not get block size from %s\n", mtd);
		exit(1);
	}
#else
	if (ioctl(fd, MEMGETINFO, &mtdInfo))
	{
		fprintf(stderr, "Could not get MTD device info from %s\n", mtd);
		close(fd);
		exit(1);
	}
#endif
	bytesInBuffer = w = e = 0;
	if (!quiet)
		fprintf(stderr, " [ ]");

	for (;imgSize>0;)
	{
		/* buffer may contain data already (from trx check) */

		byteRead =MIN( imgSize , (BUFSIZE - bytesInBuffer) );
		byteRead =read(imagefd, buf + bytesInBuffer, byteRead );

		imgSize-= byteRead;

		/* EOF */
		

		//add crc checusum by franky
		if ( check && byteRead>0  )
		{
			if (crc_table_empty)
				init_crc_table();


			for (i = bytesInBuffer; i < (bytesInBuffer + byteRead); i++)
			{
				mycount ++;
					crc = crc_table[((int)crc ^ (buf[i])) & 0xFF] ^ (crc >> 8);
			}
		}

		if (byteRead < 0)
		{
			fprintf(stderr,"\n  %s:%d:%s() ++ byteRead=%d . Read Error \n", __FILE__, __LINE__, __FUNCTION__   ,byteRead ) ; 
			byteRead=0;
		}

		bytesInBuffer += byteRead;
		w += bytesInBuffer;
		fprintf(stderr, "w: %d\n", w);

		if( bytesInBuffer<=0)
		{
			fprintf(stderr,"\n  %s:%d:%s() ++ Bufer empty. exit \n", __FILE__, __LINE__, __FUNCTION__   ) ; 
			break;

		}
#if (BOARD != rtl8196b)
		/* need to erase the next block before writing data to it */
		while (w > e)
		{
			mtdEraseInfo.start = e;
			mtdEraseInfo.length = mtdInfo.erasesize;

			if (!quiet)
				fprintf(stderr, "\b\b\b[e]");
			/* erase the chunk */
			if (ioctl (fd,MEMERASE,&mtdEraseInfo) < 0)
			{
				fprintf(stderr, "Erasing mtd failed: %s\n", mtd);
				exit(1);
			}
			e += mtdInfo.erasesize;
		}
#endif
		if (!quiet)
			fprintf(stderr, "\b\b\b[w]");

		if ((bytesWritten = write(fd, buf, bytesInBuffer)) < bytesInBuffer)
		{
			if (bytesWritten < 0)
			{
				fprintf(stderr, "Error writing image.\n");
				exit(1);
			} else if (w > block_size*512)
			{

				return 0;
			} else
			{
				fprintf(stderr, "Insufficient space.\n");
				exit(1);
			}
		}

		memmove( buf , buf + bytesWritten , (bytesInBuffer-bytesWritten) );

		bytesInBuffer -= bytesWritten ;


		if (w >= block_size*512)
		{
			system("/sbin/ledcontrol -n power -c green -s blink");	
			return 0;
		}
	
		if ((count++ % 4) == 0) {
			if (led_status == 0) {
				system("/sbin/ledcontrol -n power -c green -s on");				
				led_status=1;
			}
			else {
				system("/sbin/ledcontrol -n power -c green -s off");				
				led_status=0;
			}
		}		

	}

	if (!quiet)
		fprintf(stderr, "\b\b\b\b");

	close(fd);
	return 0;
}

void usage(void)
{
	fprintf(stderr, "Usage: mtd [<options> ...] <command> [<arguments> ...] <device>\n\n"
			"The device is in the format of mtdX (eg: mtd4) or its label.\n"
			"mtd recognizes these commands:\n"
			"        unlock                  unlock the device\n"
			"        erase                   erase all data on device\n"
			"        write <imagefile>|-     write <imagefile> (use - for stdin) to device\n"
			"        upgrade <imagefile>|-     write <imagefile> (use - for stdin) to device and /dev/mtd3\n"
			"        upgrade <imagefile> kernel_mtd koffset  rootfs_mtd roffset check_mtd "
			"Following options are available:\n"
			"        -q                      quiet mode (once: no [w] on writing,\n"
			"                                           twice: no status messages)\n"
			"        -r                      reboot after successful command\n"
			"        -f                      force write without trx checks\n"
			"        -e <device>             erase <device> before executing the command\n"
			"        -o <offset>             write device begin at the <offset> of <imagefile>\n\n"
			"Example: To write linux.trx to mtd4 labeled as linux and reboot afterwards\n"
			"         mtd -r write linux.trx linux\n\n");
	exit(1);
}


const char* const short_options = "frqe:o:i:p:s:t:k:m:n:";

const struct option long_options[] ={
	{"image",1,NULL,'i'}, /* Input image file name*/
	{"koffset",1,NULL,'o'},	/* offset to start of kernel in input image*/
	{"roffset",1,NULL,'p'},/* offset to start of rootfs in input image*/
	{"ksize",1,NULL,'s'}, /* checksum mtd */
	{"rsize",1,NULL,'t'}, /* checksum mtd */
	{"kmtd",1,NULL,'k'}, /* kerne mtd */
	{"rmtd",1,NULL,'m'}, /* rootfs mtd*/
	{"cmtd",1,NULL,'n'}, /* checksum mtd */


	{NULL,0,NULL,NULL}
};



int main (int argc, char **argv)
{
	int ch, i, boot, unlock, imagefd, force, quiet, unlocked;
	char *erase[MAX_ARGS], *device;
	char  *imageFileName=NULL;
	char  *kMtdName=NULL;
	char  *rMtdName=NULL;
	char  *cMtdName=NULL;
	uint32_t  koffset = 0;
	uint32_t roffset = 0;
	size_t ksize=0;
	size_t rsize=0;

	enum
	{
		CMD_ERASE,
		CMD_WRITE,
		CMD_UNLOCK,
		CMD_UPGRADE
	} cmd;

	erase[0] = NULL;
	boot = 0;
	force = 0;
	buflen = 0;
	quiet = 0;

	//while ((ch = getopt(argc, argv, )) != -1)
	while (  (   ch = getopt_long(argc,argv, short_options , long_options ,NULL)   )  != -1)
	{
		switch (ch)
		{
		case 'f':
			force = 1;
			break;
		case 'r':
			boot = 1;
			break;
		case 'q':
			quiet++;
			break;
		case 'e':
			i = 0;
			while ((erase[i] != NULL) && ((i + 1) < MAX_ARGS))
				i++;

			erase[i++] = optarg;
			erase[i] = NULL;
			break;
		case 'o': /* koffset */
			//= atoi(optarg);
			koffset = strtoul(optarg, &optarg, 0);
			break;
		case 'i': /* image name*/
			imageFileName=optarg;
			break;
		case 'p': /* roffset */
			roffset = strtoul(optarg, &optarg, 0);
			break;
		case 'k': /* kernel mtd*/
			kMtdName= optarg;
			break;
		case 'm': /* rootfs mtd*/
			rMtdName= optarg;
			break;
		case 'n': /* CRC checksum mtd*/
			cMtdName= optarg;
			break;
		case 's': /* ksize*/
			ksize=strtoul(optarg, &optarg, 0);
			break;
		case 't': /* rsize*/
			rsize=strtoul(optarg, &optarg, 0);
			break;

		case '?':
		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;

//	fprintf(stderr, "argc =%d  \n" ,argc );

	if (argc < 2)
	{
		fprintf(stderr, "argc < 2 \n");
		usage();
	}

//	fprintf(stderr, "argv[0]=%s  \n" ,argv[0] );

	if ((strcmp(argv[0], "unlock") == 0) && (argc == 2))
	{
		cmd = CMD_UNLOCK;
		device = argv[1];
	} else if ((strcmp(argv[0], "erase") == 0) && (argc == 2))
	{
		cmd = CMD_ERASE;
		device = argv[1];
	} else if ((strcmp(argv[0], "write") == 0) && (argc == 3))
	{
		cmd = CMD_WRITE;
		device = argv[2];

		if (strcmp(argv[1], "-") == 0)
		{
			imageFileName = "<stdin>";
			imagefd = 0;
		} else
		{
			imageFileName = argv[1];
			if ((imagefd = open(argv[1], O_RDONLY)) < 0)
			{
				fprintf(stderr, "Couldn't open image file: %s!\n", imageFileName);
				exit(1);
			}
		}

		// go forward offset byte
		if (koffset != 0)
			lseek(imagefd, koffset, SEEK_CUR);

		/* check trx file before erasing or writing anything */
		if (!image_check(imagefd, device))
		{
			if ((quiet < 2) || !force)
				fprintf(stderr, "TRX check failed!\n");
			if (!force)
				exit(1);
		} else
		{
			if (!mtd_check(device))
			{
				fprintf(stderr, "Can't open device for writing!\n");
				exit(1);
			}
		}
	} else if (strcmp(argv[0], "upgrade") == 0 )
	{
		cmd = CMD_UPGRADE;
		upgrade_flag = 1;
		//device = argv[2]; /* kernel partition*/


		if ( kMtdName==NULL || rMtdName==NULL)
		{
			fprintf(stderr, "Missing mtd name \n");
		}

		if (  NULL== imageFileName)
		{
			imageFileName = "<stdin>";
			imagefd = 0;
		} else
		{
			if ((imagefd = open(imageFileName, O_RDONLY)) < 0)
			{
				fprintf(stderr, "Couldn't open image file: %s!\n", imageFileName);
				exit(1);
			}
		}

		// go forward offset byte
		if (koffset != 0)
			lseek(imagefd, koffset, SEEK_CUR);

		/* check trx file before erasing or writing anything */
		if (!image_check(imagefd, kMtdName))
		{
			if ((quiet < 2) || !force)
				fprintf(stderr, "TRX check failed!\n");
			if (!force)
				exit(1);
		} else
		{
			if (!mtd_check(kMtdName))
			{
				fprintf(stderr, "Can't open %s for writing!\n",kMtdName);
				exit(1);
			}
			if (!mtd_check(rMtdName))
			{
				fprintf(stderr, "Can't open %s device for writing!\n",rMtdName);
				exit(1);
			}
		}
	} else
	{
				fprintf(stderr, "argv[0] = %s \n",argv[0] );
		usage();
	}

	sync();

	i = 0;
	unlocked = 0;
	while (erase[i] != NULL)
	{
		if (quiet < 2)
			fprintf(stderr, "Unlocking %s ...\n", erase[i]);
		mtd_unlock(erase[i]);
		if (quiet < 2)
			fprintf(stderr, "Erasing %s ...\n", erase[i]);
		mtd_erase(erase[i]);
		if (strcmp(erase[i], device) == 0)
			unlocked = 1;
		i++;
	}

	if (cmd != CMD_UPGRADE)
	{
		if (!unlocked)
		{
			if (quiet < 2)
				fprintf(stderr, "Unlocking %s ...\n", device);
			mtd_unlock(device);
		}
	}

	switch (cmd)
	{
	case CMD_UNLOCK:
		break;
	case CMD_ERASE:
		if (quiet < 2)
			fprintf(stderr, "Erasing %s ...\n", device);
		mtd_erase(device);
		break;
	case CMD_WRITE:
		if (quiet < 2)
			fprintf(stderr, "Writing from %s to %s ... ", imageFileName, device);
		mtd_write(imagefd, device, quiet);
		if (quiet < 2)
			fprintf(stderr, "\n");
		break;
	case CMD_UPGRADE:
		if (quiet < 2)
		{
			fprintf(stderr, "Writing from %s to kMtdName:%s ... ", imageFileName, kMtdName);
		}
		mtd_upgrade(imagefd, koffset,kMtdName,ksize, roffset,rMtdName, rsize,cMtdName,quiet);
		if (quiet < 2)
			fprintf(stderr, "done!\n");
		break;
	}

	sync();

	if (boot)
		kill(1, 15); // send SIGTERM to init for reboot

	return 0;
}


