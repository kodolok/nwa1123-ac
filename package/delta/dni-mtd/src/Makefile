# $Id$

all: mtd webupload imgextract

%.o: %.c
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) -c -o $@ $^

mtd: mtd.o 
	$(CC) -o $@ $^

webupload: webupload.o
	$(CC) -o $@ $^

imgextract: imgextract.o
	$(CC) -o $@ $^
clean:
	rm -f *.o mtd webupload imgextract 
