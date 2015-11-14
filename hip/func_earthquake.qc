/* Earthquake QuickC program
   By Jim Dose'  9/13/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/
//JIM

void() StopEarthQuake =
{
	earthquake = 0;
};

void(float value) EarthQuakeTime =
{
	value = value + time;

	if (value > earthquake)
		earthquake = value;
};

void() earthquake_prethink =
{
//	if (lastearthquake)
//	{
//		self.view_ofs_z = self.savedz;
//		lastearthquake = 0;
//	}
};

void() earthquake_postthink =
{
	if (earthquake > time)
	{
		if (quakeactive == FALSE)
		{
			sound (self, CHAN_VOICE, "misc/quake.wav", 1, ATTN_NONE);
			quakeactive = TRUE;
		}

//		lastearthquake = 1;
//		self.savedz = self.view_ofs_z;

		if (self.flags & FL_ONGROUND)
		{
//			self.view_ofs_z = self.view_ofs_z - 5 + random() * 10;
			self.velocity = self.velocity + random()*'0 0 150';
		}
	}
	else
	{
		if (quakeactive == TRUE)
		{
			sound (self, CHAN_VOICE, "misc/quakeend.wav", 1, ATTN_NONE);
			quakeactive = FALSE;
		}
	}
};

void() earthquake_use =
{
	EarthQuakeTime(self.dmg);
};

/*QUAKED func_earthquake (0 0 0.5) (0 0 0) (32 32 32)
Causes an earthquake.  Triggers targets.

"dmg" is the duration of the earthquake.  Default is 0.8 seconds.
*/
void() func_earthquake =
{
	precache_sound("misc/quake.wav");
	precache_sound("misc/quakeend.wav");

	quakeactive = TRUE;
	self.classname = "earthquake";
	self.use = earthquake_use;
	self.think = SUB_Null;

	if (!self.dmg)
		   self.dmg = 0.8;
};
