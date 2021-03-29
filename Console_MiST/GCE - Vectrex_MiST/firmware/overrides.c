#include "keyboard.h"
#include "userio.h"
#include "spi.h"

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
	KEY_ENTER,
	KEY_RSHIFT,
	KEY_RCTRL,
	KEY_ALTGR,
	KEY_UPARROW,
	KEY_DOWNARROW,
	KEY_LEFTARROW,
	KEY_RIGHTARROW,
};

/* Override menu_joystick to emulate analogue sticks */

extern int analoguesensitivity;
int analogue[4];

void Menu_Joystick(int port,int joymap)
{
	int *a=&analogue[2*port];
	if(TestKey(KEY_F1))
		analoguesensitivity=0x20;
	if(TestKey(KEY_F2))
		analoguesensitivity=0x10;
	if(TestKey(KEY_F3))
		analoguesensitivity=0x0c;
	if(TestKey(KEY_F4))
		analoguesensitivity=0x08;
	user_io_digital_joystick_ext(port, joymap);
	Menu_JoystickToAnalogue(a,joymap);
	Menu_JoystickToAnalogue(a+1,joymap>>2);
	user_io_analogue_joystick(port,a);
}

/* Initial ROM */
const char *bootrom_name="AUTOBOOTVEC";

extern int romtype;

char *autoboot()
{
	int i;
	romtype=-1;

	SPI(0xff);
	SPI_ENABLE(HW_SPI_CONF);
	SPI(UIO_SET_STATUS2); // Read conf string command
	SPI(1);
	SPI_DISABLE(HW_SPI_CONF);

	i=LoadROM("VECTREX BIN");

	SPI(0xff);
	SPI_ENABLE(HW_SPI_CONF);
	SPI(UIO_SET_STATUS2); // Read conf string command
	SPI(0);
	SPI_DISABLE(HW_SPI_CONF);

	if(!i)
		return("VECTREX.BIN not found!");
	return(0);
}


