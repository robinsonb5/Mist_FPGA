#include <stdio.h>

#include "timer.h"
#include "config.h"
#include "interrupts.h"
#include "romimg.h"
#include "configstring.h"
#include "spi.h"
#include "user_io.h"
#include "statusword.h"
#include "menu.h"

static char arckeys[]={0x16,0x1e,0x26,0x25,0x2e,0x36,0x3d,0x3e}; /* PS/2 codes for keys 1 through 8 */

extern int menu_buttons;

void sendarcadekeys()
{
	static unsigned int prev=0x000;
	unsigned int d=menu_buttons ^ prev;
	unsigned int s=prev;
	unsigned int i;
	DisableInterrupts();
	for(i=0;i<8;++i)
	{
		if(d&0x10)
		{
			EnableIO();
			SPI(UIO_KEYBOARD);
			if(s&0x10)
				SPI(0xf0); /* Key up event */
			SPI(arckeys[i]); /* Key code */
			DisableIO();
		}
		d>>=1;
		s>>=1;
	}
	EnableInterrupts();
	prev=menu_buttons;
}

int loadimage(char *filename,int unit)
{
	int result=0;
	int timestamp;
	if(filename)
	{
		result=LoadROM(filename);
		statusword_cycle(0,1,2); /* Toggle reset */
		statusword_cycle(0,1,2);
	}
	return(result);
}

extern unsigned char romtype;
char *autoboot()
{
	romtype=CONFIGSTRING_INDEX_ARC;
	if(!loadimage(ROM_FILENAME,0))
	{
		romtype=CONFIGSTRING_INDEX_ARC;
		loadimage("LODERU~1ARC",0);
	}
	return(0);
}

void mainloop()
{
	while(1)
	{
		Menu_Run();
		sendarcadekeys();
		/* Read arcade buttons and send key events. */
	}
}

