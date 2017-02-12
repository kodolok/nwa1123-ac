
/*
 * Cone NAT target for IP connection.
 * Copyright (c) 2010, Atheros Communications Inc.
 *
 * Revison History:
 *  8/11/2010, initial version for ap99, by yingming.yu@atheros.com
 */

#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <xtables.h>
#include "../../../../linux/net-2.6.31/netfilter_ipv4/ipt_NATTYPE.h"

/* Function which prints out usage message. */
static void
help(void)
{
    printf(
"NATTYPE v%s options:\n"
" --mode \n"
"    dnat (PREROUTING)\n"
"    forward_in (FORWARD)\n"
"    forward_out (FORWARD)\n"
" --type \n"
"    %d -- Endpoint Independent\n"
"    %d -- Address Restricted\n",
IPTABLES_VERSION, TYPE_ENDPOINT_INDEPEND, TYPE_ADDRESS_RESTRICT);
}

static struct option opts[] = {
    {"mode", 1, 0, '1'},
    { "type", 1, 0, '2' },
    { 0 }
};

/* Initialize the target. */
static void
init(struct xt_entry_target *t, unsigned int *nfcache)
{
}


/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct xt_entry_target **target)
{
    int portok;
    struct ipt_nattype_info *info = (struct ipt_nattype_info *)(*target)->data;

    switch (c) {
    
        case '1':
            if (!strcasecmp(optarg, "dnat")) {
                printf("iptables: dnat\n");
                info->mode= MODE_DNAT;
            } else if (!strcasecmp(optarg, "forward_in")){
                printf("iptables: forward in\n");
                info->mode= MODE_FORWARD_IN;
            } else if (!strcasecmp(optarg, "forward_out")){
                printf("iptables: forward out\n");
                info->mode= MODE_FORWARD_OUT;
            }
            return 1;
            
        case '2':
            info->type = atoi(optarg);
            printf("iptables: nat type: %d\n", info->type);
            return 1;
            
        default:
            return 0;
    }
}

/* Final check; don't care. */
static void final_check(unsigned int flags)
{
}

void print_mode(u_int16_t mode)
{
    printf("--mode:");
    if( mode == MODE_DNAT)
        printf("dnat ");
    else if( mode == MODE_FORWARD_IN)
        printf("forward_in ");
    else if( mode == MODE_FORWARD_OUT)
        printf("forward_out ");
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct xt_entry_target *target,
      int numeric)
{
    struct ipt_nattype_info *info = (struct ipt_nattype_info *)(target)->data;
    print_mode(info->mode);
    if( info->type !=0)
        printf("--type: %d", info->type);
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct xt_entry_target *target)
{
    struct ipt_nattype_info *info = (struct ipt_nattype_info *)(target)->data;
    print_mode(info->mode);
    if( info->type !=0)
        printf("--type: %d", info->type);
}

static struct xtables_target nattype = { 
    .name       = "NATTYPE",
    .version    = XTABLES_VERSION,
    .size       = XT_ALIGN(sizeof(struct ipt_nattype_info)),
    .userspacesize  = XT_ALIGN(sizeof(struct ipt_nattype_info)),
    .help       = &help,
    .init       = &init,
    .parse      = &parse,
    .final_check    = &final_check,
    .print      = &print,
    .save       = &save,
    .extra_opts = opts
};

void _init(void)
{
    xtables_register_target(&nattype);
}
