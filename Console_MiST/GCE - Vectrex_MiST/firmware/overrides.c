#include "keyboard.h"

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

int analogue[4];

void Menu_Joystick(int port,int joymap)
{
	int *a=&analogue[2*port];
	user_io_digital_joystick_ext(port, joymap);
	Menu_JoystickToAnalogue(a,joymap);
	Menu_JoystickToAnalogue(a+1,joymap>>2);
	user_io_analogue_joystick(port,a);
}

/* Initial ROM */
const char *bootrom_name="AUTOBOOTSMS";

