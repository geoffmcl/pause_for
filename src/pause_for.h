// pause_for.h
#ifndef _pause_for_h_
#define _pause_for_h_

#ifndef _WIN32_WINNT		// Allow use of features specific to Windows XP or later.                   
#define _WIN32_WINNT 0x0501	// Change this to the appropriate value to target other versions of Windows.
#endif						

#include <windows.h>    // for sleep(ms)
#include <stdio.h>
#include <tchar.h>
#include <conio.h>  // for _getch and _kbhit()
#include <time.h>   // for clock_t


#endif // #ifndef _pause_for_h_
// eof - pause_for.h

