/*   ____  __  _ _____ ____     _ _            _   
**  / ___||  \/ |_   _|  _ \___| (_) ___ _ __ | |_ 
**  \___ \| |\/| || | | |_)/ __| | |/ _ \ '_ \| __|
**   ___) | |  | || | |  _| (__| | |  __/ | | | |_ 
**  |____/|_|  |_||_| |_|  \___|_|_|\___|_| |_|\__|
**   
**  SMTPclient -- simple SMTP client
**
**  This program is a minimal SMTP client that takes an email
**  message body and passes it on to a SMTP server (default is the
**  MTA on the local host). Since it is completely self-supporting,
**  it is especially suitable for use in restricted environments.
**
**  ======================================================================
**
**  Copyright (c) 1997 Ralf S. Engelschall, All rights reserved.
**
**  This program is free software; it may be redistributed and/or modified
**  only under the terms of either the Artistic License or the GNU General
**  Public License, which may be found in the SMTP source distribution.
**  Look at the file COPYING. 
**
**  This program is distributed in the hope that it will be useful, but
**  WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU General Public License for more details.
**
**  ======================================================================
**
**  smtpclient_main.c -- program source
**
**  Based on smtp.c as of August 11, 1995 from
**      W.Z. Venema,
**      Eindhoven University of Technology,
**      Department of Mathematics and Computer Science,
**      Den Dolech 2, P.O. Box 513, 5600 MB Eindhoven, The Netherlands.
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <syslog.h>
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <ctype.h>
#include <pwd.h>
#include <time.h>

#include "smtpclient_getopt.h"
#include "smtpclient_errno.h"
#include "smtpclient_vers.h"

static char *cc_addr    = 0;
static char *err_addr   = 0;
static char *from_addr  = NULL;
static char *mailhost   = NULL;
static int   mailport   = 25;
static char *reply_addr = 0;
static char *subject    = 0;
static char *username   = NULL;
static char *password   = NULL;
static int   mime_style = 0;
static int   verbose    = 0;
static int   usesyslog  = 0;

static FILE *sfp;
static FILE *rfp;

#define dprintf  if (verbose) printf
#define dvprintf if (verbose) vprintf

static char base64chars[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

/* hack for Ultrix */
#ifndef LOG_DAEMON
#define LOG_DAEMON 0
#endif

/*
**  logging support
*/
void log(char *str, ...)
{
    va_list ap;
    char buf[1024];

    va_start(ap, str);
    vsprintf(buf, str, ap);
    if (usesyslog)
        syslog(LOG_ERR, "SMTPclient: %s", buf);
    else
        fprintf(stderr, "SMTPclient: %s\n", buf);
    va_end(ap);
    return;
}

/*
**  usage page
*/
void usage(void)
{
    fprintf(stderr, "Usage: smtp [options] recipients ...\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "Message Header Options:\n");
    fprintf(stderr, "  -s, --subject=STR      subject line of message\n");
    fprintf(stderr, "  -f, --from=ADDR        address of the sender\n");
    fprintf(stderr, "  -r, --reply-to=ADDR    address of the sender for replies\n");
    fprintf(stderr, "  -e, --errors-to=ADDR   address to send delivery errors to\n");
    fprintf(stderr, "  -c, --carbon-copy=ADDR address to send copy of message to\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "Processing Options:\n");
    fprintf(stderr, "  -S, --smtp-host=HOST   host where MTA can be contacted via SMTP\n");
    fprintf(stderr, "  -p, --smtp-port=NUM    port where MTA can be contacted via SMTP\n");
    fprintf(stderr, "  -M, --mime-encode      use MIME-style translation to quoted-printable\n");
    fprintf(stderr, "  -L, --use-syslog       log errors to syslog facility instead of stderr\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "Giving Feedback:\n");
    fprintf(stderr, "  -v, --verbose          enable verbose logging messages\n");
    fprintf(stderr, "  -V, --version          display version string\n");
    fprintf(stderr, "  -h, --help             display this page\n");
    fprintf(stderr, "\n");
    return;
}

/*
**  version page
*/
void version(void)
{
    fprintf(stdout, "%s\n", SMTPclient_Hello);
    fprintf(stdout, "\n");
    fprintf(stdout, "Copyright (c) 1997 Ralf S. Engelschall, All rights reserved.\n");
    fprintf(stdout, "\n");
    fprintf(stdout, "This program is distributed in the hope that it will be useful,\n");
    fprintf(stdout, "but WITHOUT ANY WARRANTY; without even the implied warranty of\n");
    fprintf(stdout, "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n");
    fprintf(stdout, "the GNU General Public License for more details.\n");
    fprintf(stdout, "\n");
    return;
}

void base64encode(char *from, char *to, int len)
{
        char c1,c2,c3;
        int i;
        int lenDiv=len/3;
        int lenMod=len%3;

        for (i=0;i<lenDiv;i++)
        {
                c1=*from++;
                c2=*from++;
                c3=*from++;

                *to=base64chars[c1>>2];
                *to++=base64chars[c1>>2];
                *to++=base64chars[((c1<<4) | (c2 >> 4)) & 0x3f];
                *to++=base64chars[((c2<<2) | (c3 >> 6)) & 0x3f];
                *to++=base64chars[c3 & 0x3f];
        }
        if (lenMod == 1){
                c1=*from++;
                *to++=base64chars[(c1 & 0xfc) >> 2];
                *to++=base64chars[(c1 & 0x03) << 4];
                *to++='=';
                *to++='=';
        }
        if (lenMod == 2){
                c1=*from++;
                c2=*from++;
                *to++=base64chars[(c1 &0xfc) >>2];
                *to++=base64chars[((c1 &0x03) <<4) | ((c2 &0xf0) >>4)];
                *to++=base64chars[((c2 &0x0f) <<2)];
                *to++='=';
        }
        *to++='\0';

}

/*
**  examine message from server 
*/
void get_response(void)
{
    char buf[BUFSIZ];

    while (fgets(buf, sizeof(buf), rfp)) {
        buf[strlen(buf)-1] = 0;
        dprintf("%s --> %s\n", mailhost, buf);
        if (!isdigit(buf[0]) || buf[0] > '3') {
            log("unexpected reply: %s", buf);
            exit(1);
        }
        if (buf[3] != '-')
            break;
    }
    return;
}

int get_response_auth(void)
{
    char buf[BUFSIZ];

    while (fgets(buf, sizeof(buf), rfp)) {
        buf[strlen(buf)-1] = 0;
        dprintf("%s --> %s\n", mailhost, buf);
    printf("buf[0]=[%c],buf[1]=[%c],buf[2]=[%c]\n",buf[0],buf[1],buf[2]);
        if (!isdigit(buf[0])) {
            exit(1);
        }
    if (buf[0] == '3' && buf[1] == '3' && buf[2] == '4')
    {
        return 1;
    }
        if (buf[3] != '-')
            break;
    }
    return 0;
}

int get_response_esmtp(void)
{
    char buf[BUFSIZ];
    int ret = 0;

    while (fgets(buf, sizeof(buf), rfp)) {
    buf[strlen(buf)-1] = 0;
    dprintf("%s --> %s\n", mailhost, buf);
    if (!isdigit(buf[0]) || buf[0] > '3') {
        log("unexpected reply: %s", buf);
        exit(1);
    }
    if (buf[0] == '2' && buf[1] == '2' && buf[2] == '0' && strstr(buf, " ESMTP"))
        ret = 1;
    if (buf[3] != '-')
        break;
    }
    return ret;
}

void get_response_esmtp_250(void)
{
    char buf[BUFSIZ];

    while (fgets(buf, sizeof(buf), rfp)) {
    buf[strlen(buf)-1] = 0;
    dprintf("%s --> %s\n", mailhost, buf);
    if (!isdigit(buf[0]) || buf[0] > '3') {
        log("unexpected reply: %s", buf);
        exit(1);
    }
    if (buf[0] == '2' && buf[1] == '5' && buf[2] == '0' && buf[3] == '-')
        continue;
    else
        break;
    }
    return;
}

/*
**  say something to server and check the response
*/
void chat(char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(sfp, fmt, ap);
    va_end(ap);
  
    va_start(ap, fmt);
    dprintf("%s <-- ", mailhost);
    dvprintf(fmt, ap);
    va_end(ap);

    fflush(sfp);
    get_response();
}

void chat_auth(char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(sfp, fmt, ap);
    va_end(ap);

    va_start(ap, fmt);
    dprintf("%s <-- ", mailhost);
    dvprintf(fmt, ap);
    va_end(ap);

    fflush(sfp);
}

void chat_esmtp(char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(sfp, fmt, ap);
    va_end(ap);

    va_start(ap, fmt);
    dprintf("%s <-- ", mailhost);
    dvprintf(fmt, ap);
    va_end(ap);

    fflush(sfp);
    get_response_esmtp_250();
}

/*
**  transform to MIME-style quoted printable
**
**  Extracted from the METAMAIL version 2.7 source code (codes.c)
**  and modified to emit \r\n at line boundaries.
*/

static char basis_hex[] = "0123456789ABCDEF";

void toqp(FILE *infile, FILE *outfile)
{
    int c;
    int ct = 0;
    int prevc = 255;

    while ((c = getc(infile)) != EOF) {
        if (   (c < 32 && (c != '\n' && c != '\t'))
            || (c == '=')
            || (c >= 127)
            || (ct == 0 && c == '.')               ) {
        putc('=', outfile);
        putc(basis_hex[c >> 4], outfile);
        putc(basis_hex[c & 0xF], outfile);
        ct += 3;
        prevc = 'A'; /* close enough */
    }
    else if (c == '\n') {
        if (prevc == ' ' || prevc == '\t') {
        putc('=', outfile);  /* soft & hard lines */
        putc(c, outfile);
        }
        putc(c, outfile);
        ct = 0;
        prevc = c;
    } 
    else {
        if (c == 'F' && prevc == '\n') {
        /*
         * HORRIBLE but clever hack suggested by MTR for
         * sendmail-avoidance
         */
        c = getc(infile);
        if (c == 'r') {
            c = getc(infile);
            if (c == 'o') {
            c = getc(infile);
            if (c == 'm') {
                c = getc(infile);
                if (c == ' ') {
                /* This is the case we are looking for */
                fputs("=46rom", outfile);
                ct += 6;
                } else {
                fputs("From", outfile);
                ct += 4;
                }
            } else {
                fputs("Fro", outfile);
                ct += 3;
            }
            } 
            else {
            fputs("Fr", outfile);
            ct += 2;
            }
        }
        else {
            putc('F', outfile);
            ++ct;
        }
        ungetc(c, infile);
        prevc = 'x'; /* close enough -- printable */
        } 
        else { 
        putc(c, outfile);
        ++ct;
        prevc = c;
        }
    }
    if (ct > 72) {
        putc('=', outfile);
        putc('\r', outfile); 
        putc('\n', outfile);
        ct = 0;
        prevc = '\n';
    }
    }
    if (ct) {
    putc('=', outfile);
    putc('\r', outfile); 
    putc('\n', outfile);
    }
    return;
}


/*
**  main procedure
*/

struct option options[] = {
    { "subject",      1, NULL, 's' },
    { "from",         1, NULL, 'f' },
    { "replay-to",    1, NULL, 'r' },
    { "errors-to",    1, NULL, 'e' },
    { "carbon-copy",  1, NULL, 'c' },
    { "smtp-host",    1, NULL, 'h' },
    { "smtp-port",    1, NULL, 'p' },
    { "mime-encode",  0, NULL, 'M' },
    { "use-syslog",   0, NULL, 'L' },
    { "verbose",      0, NULL, 'v' },
    { "version",      0, NULL, 'V' },
    { "help",         0, NULL, 'h' }
};

int main(int argc, char **argv)
{
    char buf[BUFSIZ];
    char my_name[BUFSIZ];
    char encodeusername[128];
    char encodepassword[128];
    struct sockaddr_in sin;
    struct hostent *hp;
    struct servent *sp;
    int c;
    int s;
    int r;
    int i;
    int usernamelen,passwordlen;
    struct passwd *pwd;
    char *cp;

    /* 
     *  Go away when something gets stuck.
     */
    alarm(60);

    /*
     *  Parse options
     */
    while ((c = getopt_long(argc, argv, ":s:f:r:e:c:S:p:MLvVhU:P:", options, NULL)) != EOF) {
        switch (c) {
            case 's':
                subject = optarg;
                break;
            case 'f':
                from_addr = optarg;
                break;
            case 'r':
                reply_addr = optarg;
                break;
            case 'e':
                err_addr = optarg;
                break;
            case 'c':
                cc_addr = optarg;
                break;
            case 'S':
                mailhost = optarg;
                break;
            case 'p':
                mailport = atoi(optarg);
                break;
            case 'M':
                mime_style = 1;
                break;
            case 'L':
                usesyslog = 1;
                break;
            case 'v':
                verbose = 1;
                break;
            case 'V':
                version();
                exit(0);
            case 'h':
                usage();
                exit(0);
        case 'U':
        username = optarg;
        break;
        case 'P':
        password = optarg;
        break;
            default:
                fprintf(stderr, "SMTP: invalid option `%c'\n", optopt);
                fprintf(stderr, "Try `%s --help' for more information.\n", argv[0]);
                exit(1);
        }
    }
    if (argc == optind) {
        fprintf(stderr, "SMTP: wrong number of arguments\n");
        fprintf(stderr, "Try `%s --help' for more information.\n", argv[0]);
        exit(1);
    }

    /*  
     *  Open Syslog facility
     */
    if (usesyslog)
        openlog(argv[0], LOG_PID, LOG_DAEMON);

    gethostname(my_name,sizeof(my_name));
#if 0
    /*
     *  Determine SMTP server
     */
    if (mailhost == NULL) {
        if ((cp = getenv("SMTPSERVER")) != NULL)
            mailhost = cp;
        else
            mailhost = "localhost";
    }
    /*
     *  Find out my own host name for HELO; 
     *  if possible, get the FQDN.
     */
    if (gethostname(my_name, sizeof(my_name) - 1) < 0) {
        log("gethostname: %s", errorstr(errno));
        exit(1);
    }
    if ((hp = gethostbyname(my_name)) == NULL) {
        log("%s: unknown host 2\n", my_name);
        exit(1);
    }
    strcpy(my_name, hp->h_name);

    /*
     *  Determine from address.
     */
    if (from_addr == NULL) {
        if ((pwd = getpwuid(getuid())) == 0) {
            sprintf(buf, "userid-%d@%s", getuid(), my_name);
        } else {
            sprintf(buf, "%s@%s", pwd->pw_name, my_name);
        }
        from_addr = strdup(buf);
    }
#endif
    /*
     *  Connect to smtp daemon on mailhost.
     */
     printf("mailhost:%s\r\n",mailhost);
    if ((hp = gethostbyname(mailhost)) == NULL) {
//    if ((hp = xgethostbyname(mailhost)) == NULL) {
        log("%s: unknown host 1\n", mailhost);
        exit(1);
    }
    if (hp->h_addrtype != AF_INET) {
        log("unknown address family: %d", hp->h_addrtype);
        exit(1);
    }
    memset((char *)&sin, 0, sizeof(sin));
    memcpy((char *)&sin.sin_addr, hp->h_addr, hp->h_length);
    sin.sin_family = hp->h_addrtype;
    sin.sin_port = htons(mailport);
    if ((s = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        log("socket: %s", errorstr(errno));
        exit(1);
    }
    if (connect(s, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
        log("connect: %s", errorstr(errno));
        exit(1);
    }
    if ((r = dup(s)) < 0) {
        log("dup: %s", errorstr(errno));
        exit(1);
    }
    if ((sfp = fdopen(s, "w")) == 0) {
        log("fdopen: %s", errorstr(errno));
        exit(1);
    }
    if ((rfp = fdopen(r, "r")) == 0) {
        log("fdopen: %s", errorstr(errno));
        exit(1);
    }

    /* 
     *  Give out SMTP headers.
     */
    if (!username) {
    get_response(); /* banner */
    chat("HELO %s\r\n", my_name);
    } else {
    if (get_response_esmtp())
        chat_esmtp("EHLO %s\r\n", my_name);
    else
        chat("HELO %s\r\n", my_name);

    chat_auth("AUTH LOGIN\r\n");
    if (get_response_auth()){
        usernamelen=strlen(username);
        passwordlen=strlen(password);
        base64encode(username,encodeusername,usernamelen);
        base64encode(password,encodepassword,passwordlen);
        chat("%s\r\n",encodeusername);
        chat("%s\r\n",encodepassword);
    }
    }

    chat("MAIL FROM: <%s>\r\n", from_addr);
    for (i = optind; i < argc; i++)
        chat("RCPT TO: <%s>\r\n", argv[i]);
    if (cc_addr)
        chat("RCPT TO: <%s>\r\n", cc_addr);
    chat("DATA\r\n");

    /* 
     *  Give out Message header. 
     */
    char time_buf[128];
    time_t now;
    struct tm *tm;
    FILE *fp;

    if( (fp = fopen("/tmp/configs/time_zone", "r")) != NULL) {
    fgets(time_buf, sizeof(time_buf), fp);
    setenv("TZ", time_buf, 1);
    fclose(fp);
    }

    time(&now);
    tm = localtime(&now);
    strftime(time_buf, sizeof(time_buf), "%a, %d %b %Y %T %z", tm);
    
    if ((pwd = getpwuid(getuid())) == 0) {
        fprintf(sfp, "From: %s\r\n", from_addr);
    } else {
        fprintf(sfp, "From: %s@%s <%s>\r\n", pwd->pw_name, my_name ,from_addr);
    }

    if (subject)
        fprintf(sfp, "Subject: %s\r\n", subject);

    fprintf(sfp, "DATE: %s\r\n", time_buf);
    if (reply_addr)
        fprintf(sfp, "Reply-To: %s\r\n", reply_addr);
    if (err_addr)
        fprintf(sfp, "Errors-To: %s\r\n", err_addr);
    if ((pwd = getpwuid(getuid())) == 0) {
        fprintf(sfp, "Sender: userid-%d@%s\r\n", getuid(), my_name);
    } else {
        fprintf(sfp, "Sender: %s@%s\r\n", pwd->pw_name, my_name);
    }

    fprintf(sfp, "To: %s", argv[optind]);
    for (i = optind + 1; i < argc; i++)
        fprintf(sfp, ",%s", argv[i]);
    fprintf(sfp, "\r\n");
    if (cc_addr)
        fprintf(sfp, "Cc: %s\r\n", cc_addr);

    if (mime_style) {
        fprintf(sfp, "MIME-Version: 1.0\r\n");
        fprintf(sfp, "Content-Type: text/plain; charset=ISO-8859-1\r\n");
        fprintf(sfp, "Content-Transfer-Encoding: quoted-printable\r\n");
    }

    fprintf(sfp, "\r\n");

    /* 
     *  Give out Message body.
     */
    if (mime_style) {
        toqp(stdin, sfp);
    } else {
        while (fgets(buf, sizeof(buf), stdin)) {
            buf[strlen(buf)-1] = 0;
            if (strcmp(buf, ".") == 0) { /* quote alone dots */
                fprintf(sfp, "..\r\n");
            } else { /* pass thru mode */
                fprintf(sfp, "%s\r\n", buf);
            }
        }
    }

    /* 
     *  Give out SMTP end.
     */
    chat(".\r\n");
    chat("QUIT\r\n");

    /* 
     *  Die gracefully ...
     */
    exit(0);
}

/*EOF*/
