/* 
 *	$ imgextract [src_file] [skip_bytes] [out_bytes]
 * 
 * the above command will
 * 
 * 1. extract [src_file] from the [skip_bytes]+1 byte to [skip_bytes]+[out_bytes] byte .
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>

void usage ()
{
	fprintf(stderr, "USAGE : imgextract [src_file] [skip_bytes] [out_bytes]\n");
}

int main(int argc, char * argv[])
{
	char *src_file_name;
    int src_file_size, skip_bytes, out_bytes;
	struct stat src_file_stat;
    FILE *src_file;
	
    int digit, digit_count;
	
	if (argc != 4) {
		usage();
		return (-1);
	}
	src_file_name = argv[1];
	skip_bytes = atol(argv[2]);
	out_bytes = atol(argv[3]);
	
	if ( stat(src_file_name, &src_file_stat) != 0 ) {
		fprintf(stderr, "stat(%s) failed.\n", src_file_name);
		exit(-1);
	}
    src_file_size = src_file_stat.st_size;
	if ( src_file_size < skip_bytes + out_bytes ) {
		fprintf(stderr, "size of %s is %d < %d + %d \n", src_file_name, src_file_size, skip_bytes, out_bytes);
		exit(-1);
	}
		
    src_file = fopen( src_file_name, "r" );
    if ( fseek( src_file, skip_bytes, SEEK_SET) == 0 ) {
        for ( digit_count = 0; digit_count < out_bytes; digit_count++ ) {
                digit = fgetc(src_file);
                fputc(digit, stdout);
        }
    }
    fclose(src_file);

    exit(0);
}
