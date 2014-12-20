// pause_for.cpp : Defines the entry point for the console application.
//

#include "pause_for.h"

// These two value should come from the CMakeLists.txt file
#ifndef VERSION
#define VERSION "1.0.1"
#endif
#ifndef VER_DATE
#define VER_DATE "20141220"
#endif

static double secs_to_wait = 10;
static int verbose = 0;

// Pauses for a specified number of milliseconds.
// CLOCKS_PER_SEC 
int sleep( clock_t wait )
{
   clock_t goal;
   goal = wait + clock();
   int i = 0;
   while( goal > clock() ) {
       i++;
   }
   return i;
}



int check_key_available( void )
{
   int chr = _kbhit();
   if(chr)
      chr = _getch();
   return chr;
}


int   kbd_sleep( double secs )
{
    int cnt = 0;
    int ms_used = 0;
    int ms_wait = (int)(secs * 1000.0);
    int max_ms = 100;   // never 'sleep' more than this (ms)
    int chr = check_key_available();
    if (chr)    // got keyboard - all done
        return chr;
    clock_t wait_ms;
    while (ms_wait) {
        // set the next wait count (ms)
        if (ms_wait < max_ms)
            wait_ms = ms_wait;
        else
            wait_ms = max_ms;
        sleep(wait_ms);
        chr = check_key_available();
        if(chr)
            return chr;
        ms_wait -= wait_ms; // subtract ms waited...
    }
    return chr;
}

void show_help()
{
    printf("pause_for version %s, of %s\n", VERSION, VER_DATE);
    printf("pause_for [-v[v[v...]]] seconds\n");
    printf(" --help (-h or -?) = This help and exit(0)\n");
    printf(" -verbosity   (-v) = Bump the verbosity (def=%d)\n", verbose);
    printf("\n");
    printf("Program will PAUSE for the number of seconds (a double) before exit.\n");
    printf("but will also exit on ANY keyboard input\n");
}


int main(int argc, char *argv[])
{
    int i;
    if (argc < 2) {
        show_help();
        printf("ERROR: No command given!\n");
        return 1;
    }
    for (i = 1; i < argc; i++)
    {
        char * arg = argv[i];
        int off = 0;
        char c = toupper(arg[off]);
        if ( c == '-' ) {
            while (c == '-') {
                off++;
                c = toupper(arg[off]);
            }
            if (( c == 'H' ) || ( c == '?' )) {
                show_help();
                return 0;
            } else if ( c == 'V' ) {
                do {
                    verbose++;
                    off++;
                    c = toupper(arg[off]);
                } while (c == 'V');
            } else {
                show_help();
                printf("Error: Unknown command '%s'!\n", arg );
                return 1;
            }
        } else {
            secs_to_wait = atof(arg);
        }
    }
    if (verbose) {
        printf("Waiting %.3lf seconds, or until a keyboard input... : ", secs_to_wait);
        fflush(stdout);
    }
    fflush(stdin);
    kbd_sleep(secs_to_wait);
	return 0;
}

// eof - pause_for.cpp
