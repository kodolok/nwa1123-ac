/*
 * Copyright (c) 2010 Atheros Communications, Inc.
 * All rights reserved.
 *
 * $Id: //depot/sw/releases/Aquila_9.2.0_U10/apps/busybox-1.01/miscutils/ethdebug.c#1 $
 */

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <getopt.h>
#include <errno.h>
#include <err.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <net/if.h>
#include "ethdebug.h"

#define SIOCDEVPRIVATE   0x89F0  /* to 89FF */
#define S26_RD_PHY       (SIOCDEVPRIVATE | 0x1)
#define S26_WR_PHY       (SIOCDEVPRIVATE | 0x2)
#define S26_FORCE_PHY    (SIOCDEVPRIVATE | 0x3)
#define S26_DBG_CONFIG   (SIOCDEVPRIVATE | 0x4)
#define S26_DBG_RESTART  (SIOCDEVPRIVATE | 0x5)
#define S26_DBG_STATS    (SIOCDEVPRIVATE | 0x6)
#define S26_DBG_ENABLE   (SIOCDEVPRIVATE | 0x7)

void dumpdbgconfig(void);
int  loadconfig(void);
static void usage(void);

struct ifreq ifrequest;
struct eth_dbg_params eth_vi_dbg_params;
int sockfd;
const char *prog;
char filename[40];


void dumpdbgconfig(void)
{
   int i=i,j=0;
   printf("\n Rxseqnumber offset : %04x and size: %d bytes", eth_vi_dbg_params.vi_dbg.rxseq_offset, eth_vi_dbg_params.vi_dbg.rxseq_num_bytes);
   printf("\n Numbers of streams: %d", eth_vi_dbg_params.vi_num_streams);
   printf("\n Numbers of markers: %d", eth_vi_dbg_params.vi_num_markers);
   for (i=0;i<eth_vi_dbg_params.vi_num_streams;i++)	
   {
     printf("\n -- Stream %d configuration -- ", i+1);  
     for (j=0;j<eth_vi_dbg_params.vi_num_markers;j++)	
       printf("\nmarker%d: Offset: %04x Size: %d Match: %08x",  j+1, eth_vi_dbg_params.vi_dbg.markers[i][j].offset, eth_vi_dbg_params.vi_dbg.markers[i][j].num_bytes
                                                             , eth_vi_dbg_params.vi_dbg.markers[i][j].match);
   }
   printf("\n Max Seq number: %08x", eth_vi_dbg_params.vi_rx_seq_max);
   printf("\n Debug cfg: %d \n", eth_vi_dbg_params.vi_dbg_cfg);
}

int loadconfig(void)
{
   int ch;
   char line[100];
   FILE *fp;
   unsigned int temp=0, offset, num_bytes, match;
   int markers=0, streams=0, i, j;
   fp = fopen (filename, "rt");
   if (fp == NULL)
   {
       fprintf(stderr, "File Not Found !!!\n");
       return -1;
   }

   do
   {
     ch = fgetc(fp);
   } while(('$'!=ch) && (EOF != ch));

   if (EOF ==fscanf(fp,"%x",&temp))
       return -1;
   fgets(line,100,fp);
   eth_vi_dbg_params.vi_rxseq_offset_size = temp;
   eth_vi_dbg_params.vi_dbg.rxseq_num_bytes =temp & 0x0000FFFF;
   eth_vi_dbg_params.vi_dbg.rxseq_offset =(temp >> 16);


   if (EOF == fscanf(fp,"%d",&streams))
       return -1;
   fgets(line,100,fp);
   eth_vi_dbg_params.vi_num_streams = streams;

   if (EOF == fscanf(fp,"%d",&markers))
       return -1;
   fgets(line,100,fp);    
   eth_vi_dbg_params.vi_num_markers = markers;


   for(i=0;i<streams;i++) 
   {
      for(j=0;j<markers;j++)		
      {

	   if (EOF == fscanf(fp,"%x",&temp))
           return -1;
   	   fgets(line,100,fp);
	   offset = temp >> 16;
	   num_bytes = temp & 0x0000FFFF;
	   if (EOF == fscanf(fp,"%x",&temp))
           return -1;
   	   fgets(line,100,fp);
	   match = temp;

	   eth_vi_dbg_params.vi_dbg.markers[i][j].offset    = offset;
       eth_vi_dbg_params.vi_dbg.markers[i][j].num_bytes = num_bytes;
	   eth_vi_dbg_params.vi_dbg.markers[i][j].match     = match;


      }
   }

   if(EOF == fscanf(fp,"%x",&temp))
       return -1;
   fgets(line,100,fp);
   eth_vi_dbg_params.vi_rx_seq_max = temp;

   eth_vi_dbg_params.vi_dbg_cfg = 0;
   dumpdbgconfig();
   fclose(fp);
   return 0;
}

static void
usage(void)
{
	fprintf(stderr, "usage: %s [-x configfilename] \n", prog);
	fprintf(stderr, "usage: %s [-e <value>] enable/disable\n", prog);
	fprintf(stderr, "usage: %s [-r]to restart debug \n", prog);
	fprintf(stderr, "usage: %s [-s]to get eth rx drop stats \n", prog);
	exit(-1);
}

int
ethdebug_main(int argc, char *argv[])
{
	const char *ifname = "eth0";
    char *fname=NULL;
	int c,do_dbg=0,do_stats=0,do_restart=0,do_enable=0,enable=0;
    unsigned long drops=0;
	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sockfd < 0)
		err(1, "socket");

	prog = argv[0];

	while ((c = getopt(argc, argv, "irsx:e:")) != -1) { 
	    switch (c) {
		case 'i':
			ifname = optarg;
			break;
        case 'r':
			do_restart = 1;
            break;
        case 's':
			do_stats = 1;
            break;
        case 'e':
			do_enable = 1;
            enable = atoi(optarg);
            break;
        case 'x':
            fname = optarg;
            strcpy(filename, fname);
			do_dbg=1;
			break;
		
        default:
			usage();
			/*NOTREACHED*/
		}
    }

    if (do_enable)
    {
        printf("Enable Debug ...\n");
     	strncpy(ifrequest.ifr_name, ifname, IFNAMSIZ);
        ifrequest.ifr_data = (void *) &enable;
		if (ioctl(sockfd, S26_DBG_ENABLE, &ifrequest) < 0)
			err(1, "Error in ioctl");
        return 0;
    }

    if(do_stats)
    {
     	strncpy(ifrequest.ifr_name, ifname, IFNAMSIZ);
        ifrequest.ifr_data = (void *) &drops;
		if (ioctl(sockfd, S26_DBG_STATS, &ifrequest) < 0)
			err(1, "Error in ioctl");
        printf("Drops from Application : %d \n", drops);
        return 0;
    }

    if(do_restart)
    {
        printf("Restarting Debug ...\n");
     	strncpy(ifrequest.ifr_name, ifname, IFNAMSIZ);
		if (ioctl(sockfd, S26_DBG_RESTART, &ifrequest) < 0)
			err(1, "Error in ioctl");
        return 0;
    }

	if (do_dbg)        
	{
		//add debug configuration here
	    strncpy(ifrequest.ifr_name, ifname, IFNAMSIZ);
        if (-1 == loadconfig())
        {
           fprintf(stderr, "Error in configuration\n");
           return -1;
        }
        ifrequest.ifr_data = (void *) &eth_vi_dbg_params;
		if (ioctl(sockfd, S26_DBG_CONFIG, &ifrequest) < 0)
			err(1, "Error in ioctl");
        return 0;

	}
    return 0;
}
