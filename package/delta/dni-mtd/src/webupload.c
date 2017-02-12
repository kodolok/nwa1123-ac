/* 
 * the following command
 * 
 *   $  webupload [file_name] 
 *
 * will return the offset of the start and truncate the http garbages
 * at the end of [file_name].
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

#define BUFFER_SIZE 80
#define LOCAL_BUF_SIZE 128
#define ERROR_FILE "upload_error.html"
#define READY_FILE "upload_complete.html"

//#define DEBUG

static int print_file(char* filename)
{
    char f_name[255];
    FILE* in_file;
    char line[(BUFFER_SIZE*2) + 1];
    char* doc_root;
    
    doc_root = getenv("DOCUMENT_ROOT");
    if (!doc_root) {
        doc_root = "/var/www";
    }
    
    strcpy(f_name, doc_root);
    strcat(f_name, "/");
    strcat(f_name, filename);

    in_file = fopen(f_name, "r");
    if( in_file == NULL ) {
        return -1;
    }

    while( fgets(line, BUFFER_SIZE*2, in_file) != NULL ) {
        printf("%s", line);
    }

    fclose(in_file);
    return 0;
}

void usage ()
{
	fprintf(stderr, "Usage : webupload [file_name]\n");
 	fprintf(stderr, "Function : return the offsets of the start and truncate the http garbages at the end of [file_name].\n");
}

int main(int argc, char * argv[])
{
    char *in_file_name;
    FILE *in_file;
    long int start_offset;
    char buffer[BUFFER_SIZE];
    char mime_tag[BUFFER_SIZE+2];
    int mime_tag_length;
    int total_matched;

    int read_p;
    int write_p;
    int fd;
    int c;
    long no_bytes;

    if (argc != 2) {
        usage();
        return (-1);
    }
    in_file_name = argv[1];
    in_file = fopen(argv[1], "r+"); /* for both reading and writing */
    if (in_file == NULL)
    {
        fprintf(stderr, "Error opening input file.\n");
        exit(1);
    }

    /* Read mime_tag line and store it */
    if (fgets(buffer, BUFFER_SIZE - 1 , in_file) == NULL) {
        print_file(ERROR_FILE);
		fprintf(stderr, "Upload failed, couldn't read mime-tag\n");
        exit(1);
    }

    /* cut trailing end-of-lines */
    while ( (strlen(buffer) > 0) && 
			((buffer[strlen(buffer)-1] == 0x0D) || (buffer[strlen(buffer)-1] == 0x0A)) )
	{
        buffer[strlen(buffer)-1] = 0x00;
    }

    sprintf(mime_tag, "%c%c", 13, 10);
    strcat(mime_tag, buffer);

    mime_tag_length = strlen(mime_tag);

    /*
     * Read lines until we find the 'name="filename"' somewhere. This indicates
     * the start of the upload file
     */
    while(strstr(buffer, "name=\"filename\"") == NULL) {
        if (fgets(buffer, BUFFER_SIZE-1, in_file) == NULL) {
            print_file(ERROR_FILE);
            fprintf(stderr, "Upload failed, name=\"filename\" not found\n");
            exit(1);
        }
    }

    /* Read until we find HEX 0D0A0D0A */

    /* The first two bytes of the sequence could already be in 'buffer' */
    if ((buffer[strlen(buffer)-2] == 0x0D) && (buffer[strlen(buffer)-1] == 0x0A)) {
    	total_matched = 2;
    }
    else {
    	total_matched = 0;
    }

    while( (total_matched < 4 ) && ((c = getc(in_file)) != EOF) ) {
        switch(c) {
        case 0x0D:
            switch(total_matched) {
                case 0:
                case 2:
                    total_matched++;
                    break;
                case 1:
                    /* found 0D0D */
                    break;
                case 3:
                    /* found 0D0A0D0D */
                    total_matched = 1;
                    break;
                default:
                    fprintf(stderr, "Internal error in 'webupload'\n");
                    break;
            }
            break;
        case 0x0A:
            switch(total_matched) {
                case 0:
                    /* found 0A without 0D in front of it */
                case 1:
                case 3:
                    total_matched++;
                    break;
                case 2:
                    /* found 0D0A0A */
                    total_matched=0;
                    break;
                default:
                    fprintf(stderr, "Internal error in 'webupload'\n");
                    break;
            }
            break;
        default:
            total_matched = 0;
            break;
        }
    }

    if (total_matched != 4) {
        print_file(ERROR_FILE);
		fprintf(stderr, "ERROR !!, didn't find 0D0A0D0A\n");
		exit(1);
    }

    start_offset = ftell(in_file);

    /* Let the fun begin */
    read_p = 0;
    write_p = 0;
    total_matched = 0;
    no_bytes = 0;

    while( (c = getc(in_file)) != EOF) {

        /* store byte */
        buffer[read_p] = c;

        /* Try to match with mime_tag */
        if ( buffer[read_p] == mime_tag[total_matched] ) {

            total_matched++;

            if (total_matched == mime_tag_length) {
                /* OK, we're finished */
                break; /* while */
            }
        }
        else {
            if (total_matched > 0) {
                /* The current read byte doesn't match with mime_tag, write out
                 * first byte of buffer and look if there is anything left to
                 * match in the buffer
                 */
                int match_p;

                /* reset total_matched */
                total_matched = 0;

                while ( (write_p != read_p) && (total_matched == 0) ) {
		    		no_bytes++;
                                //putc(buffer[write_p], out_file);
                    write_p = (write_p + 1) % BUFFER_SIZE;

                    match_p = write_p;

                    while( (buffer[match_p] == mime_tag[total_matched])
                            && (match_p <= read_p) ) {

                        total_matched++;

                        match_p = (match_p+1) % BUFFER_SIZE;

                    }

                    if ( match_p <= read_p ) {
                        /* matched failed, reset total_matched */
                        total_matched=0;
                    }
                }

            }
        }

        read_p = (read_p + 1) % BUFFER_SIZE;

        if (total_matched == 0) {
            /* no match of (part of) mime_tag, write bytes to destination file */
            while ( write_p != read_p ) {
                no_bytes++;
                //putc(buffer[write_p], out_file);
                write_p = (write_p + 1) % BUFFER_SIZE;
            }
        }
    }

    if (no_bytes == 0) {
        /* no file received */

        print_file(ERROR_FILE);
        fprintf(stderr, "Upload failed, empty or non-existing file uploaded.\n");
        exit(1);
    }
		  
    /* Truncate the output file */
    if (ftruncate(fileno(in_file), start_offset + no_bytes) == -1) {
        print_file(ERROR_FILE);
        fprintf(stderr, "Error, couldn't truncate file, error: %s\n", strerror(errno));
        exit(1);
    };
    
    printf("%d\n", start_offset);
    exit(0);
}
