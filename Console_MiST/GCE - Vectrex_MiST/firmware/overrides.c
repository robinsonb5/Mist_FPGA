#include "menu.h"
#include "keyboard.h"
#include "user_io.h"
#include "spi.h"
#include "statusword.h"
#include "config.h"

/* Key -> gamepad mapping.  We override this to swap buttons A and B for NES. */

unsigned char joy_keymap[]=
{
	KEY_CAPSLOCK,
	KEY_LSHIFT,
	KEY_LCTRL,
	KEY_ALT,
	KEY_W,
	KEY_S,
	KEY_A,
	KEY_D,
	KEY_RSHIFT,
	KEY_SLASH,
	KEY_PERIOD,
	KEY_COMMA,
	KEY_UPARROW,
	KEY_DOWNARROW,
	KEY_LEFTARROW,
	KEY_RIGHTARROW,
};

/* Override menu_joystick to emulate analogue sticks */

int analoguesensitivity=0x80;
int analogue[4];

int Menu_JoystickToAnalogue(int a,int joy, int sensitivity);

void Menu_Joystick(int port,int joymap)
{
	int buttons=HW_JOY(REG_JOY_EXTRA);
	int *a=&analogue[0];
	if(TestKey(KEY_F1) || (buttons&0x2))
		analoguesensitivity=0x80;
	if(TestKey(KEY_F2) || (buttons&0x4))
		analoguesensitivity=0x30;
	if(TestKey(KEY_F3) || (buttons&0x8))
		analoguesensitivity=0x0c;
	if(TestKey(KEY_F4) || (buttons&0x10))
		analoguesensitivity=0x08;
	user_io_digital_joystick_ext(port, joymap);
	analogue[2*port+0]=Menu_JoystickToAnalogue(analogue[2*port+0],joymap,analoguesensitivity);
	analogue[2*port+1]=Menu_JoystickToAnalogue(analogue[2*port+1],joymap>>2,analoguesensitivity);
	user_io_analogue_joystick(port,a);
}

__weak int rom_minsize;

/* Initial ROM */

extern unsigned char romtype;

char *autoboot()
{
	int i;
	romtype=0;
	rom_minsize=8192;
	statusword|=1;
	sendstatus();

	i=LoadROM(ROM_FILENAME);

	statusword&=~1;
	sendstatus();

	if(!i)
		return("VECTREX.BIN not found!");

	statusword|=1;
	sendstatus();

	rom_minsize=1;
	romtype=1;
	i=LoadROM("AUTOBOOTVEC");
	statusword&=~1;
	sendstatus();

	return(0);
}


