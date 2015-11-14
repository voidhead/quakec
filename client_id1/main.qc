/*

client/main.qc

Code entry points for CSQC

*/

//-----------------------------------------------------------------------------
// Init
//-----------------------------------------------------------------------------
void() CSQC_Init =
{
	maxclients = 0;
	while (maxclients < 1024 && getplayerkeyvalue(maxclients, "viewentity"))
		maxclients = maxclients + 1;

	registercmd("slot1");
	registercmd("slot2");
	registercmd("slot3");
	registercmd("slot4");
	registercmd("slot5");
	InitWeaponSlots();

	registercmd("volup");
	registercmd("voldn");
	registercmd("sfxtoggle");
	registercmd("bgmtoggle");
//	registercvar("volume", autocvar_volume);
};

//-----------------------------------------------------------------------------
// Shutdown
// called on level shutdown (disconnect, level change, quit, loading a saved game, etc)
//-----------------------------------------------------------------------------
void() CSQC_Shutdown =
{
};

//-----------------------------------------------------------------------------
// UpdateView
// the most important function in CSQC...
//-----------------------------------------------------------------------------
void(float width, float height) CSQC_UpdateView =
{
	local vector vf_size;
	local vector vf_min;
	local vector fovvec;

	vf_size = getpropertyvec(VF_SIZE);
	vf_min = getpropertyvec(VF_MIN);
	fovvec = getpropertyvec(VF_FOV); // note this is a vector (x and y are independent)

	vid_width = width;
	vid_height = height;
	vid_conwidth = autocvar_vid_conwidth;
	vid_conheight = autocvar_vid_conheight;
	vid_pixelheight = autocvar_vid_pixelheight;

// do any manipulation we want on fov here (weapon zoom, respawn zoom, etc)

// clear the scene information (entities, polygons, etc)
	clearscene();

// set up the scene parameters
	setproperty(VF_SIZE, vf_size);
	setproperty(VF_MIN, vf_min);
	setproperty(VF_FOV, fovvec);

	setproperty(VF_DRAWWORLD, TRUE);
	setproperty(VF_DRAWCROSSHAIR, TRUE);
	setproperty(VF_DRAWENGINESBAR, TRUE);

// add clientside entities (MASK_NORMAL)
// add engine networked entities (MASK_ENGINE)
// and engine viewmodel and engine networked entities with the viewdemol flag (MASK_ENGINEVIEWMODELS)
	addentities(MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS);

	AdjustChasecam();

// add any polygons we want here

// draw the main view
	renderscene();

	Sbar_DrawPowerupTimers();
	Sbar_DrawVolumeControls();
};

//-----------------------------------------------------------------------------
// ConsoleCommand
// called on all console commands, but be sure to registercmd() first so the tab completion works!
// return FALSE to let engine process command, TRUE to eat command
//-----------------------------------------------------------------------------
float(string cmd) CSQC_ConsoleCommand =
{
	//clientcommand(client, cmd);

	float result;
	float slot;

	if(strstrofs(cmd, "slot", 0) >= 0)
	{
		slot = stof(substring(cmd, 4, 2));
	
		if (slot < 1 || slot > 5)
			return FALSE;
	
		result = ChangeWeaponSlot(slot);
	
		if (result == WC_NOWEAPON)
			print("^1no weapon.\n");
		else if (result == WC_NOAMMO)
			print("^1no ammo.\n");
		else if (result == WC_LOWAMMO)
			print("^3not enough ammo.\n");
	//	else if (result == WC_NOCHANGE)
	//		print("^3no change\n");
	
		return TRUE;
	}

	else if (cmd == "volup")
	{
		VC_IncreaseVolume();
		return TRUE;
	}
	else if (cmd == "voldn")
	{
		VC_DecreaseVolume();
		return TRUE;
	}
	else if (cmd == "sfxtoggle")
	{
		VC_ToggleSFX();
		return TRUE;
	}
	else if (cmd == "bgmtoggle")
	{
		VC_ToggleBGM();
		return TRUE;
	}

	return FALSE;	
};

//-----------------------------------------------------------------------------
// StuffCmd
// if string is interesting, deal with it, otherwise pass it to localcmd() and let engine parse it
// (note: will not be executed immediately)
//-----------------------------------------------------------------------------
void(string cmd) CSQC_Parse_StuffCmd =
{
//	if(isdemo())
//		return;

	localcmd(cmd);
};

//-----------------------------------------------------------------------------
// Print
// if string is interesting, deal with it, otherwise pass it to print() to invoke the engine code.
//-----------------------------------------------------------------------------
void(string msg) CSQC_Parse_Print =
{
	print(msg);
};

//-----------------------------------------------------------------------------
// CenterPrint
// if string is interesting, deal with it, otherwise pass it to centerprint() to invoke the engine code.
//-----------------------------------------------------------------------------
void(string msg) CSQC_Parse_CenterPrint =
{
	centerprint(msg);

	if (autocvar_con_log_centerprint)
	{
		local float tokens;
		local float i;
	
		tokens = tokenizebyseparator(msg, "\n");
		//print("\n");
		for (i=0; i<tokens; i=i+1)
		{
			if (strlen(argv(i)))
				print("^8", argv(i), "\n");
		//print("\n");
		}
	}
};

//-----------------------------------------------------------------------------
// InputEvent
// event 0 = keydown (keysym, unicode character but this may be zero) or typed input (-1, unicode character)
// event 1 = keyup (keysym, may have unicode character but generally not)
// event 2 = mousemove (x, y) if inputmode is off
// event 3 = mousepos (x, y) if inputmode is on
// return TRUE if you want to eat this event or FALSE if you want to pass it along to the engine code
//-----------------------------------------------------------------------------
float(float event, float sym, float parama, float paramb) CSQC_InputEvent =
{
	if (vc_active)
	if (event == INPUT_KEYDOWN)
	{
//		print(ftos(sym), "\n");

		switch (sym)
		{
			case K_ESCAPE:			//esc
				localcmd("play misc/menu2.wav");
				vc_active = FALSE;
				break;
			
			case K_UPARROW:			//up
				vc_pos = !vc_pos;			
				break;

			case K_DOWNARROW:		//down
				vc_pos = !vc_pos;			
				break;

			case K_LEFTARROW:		//left
				VC_DecreaseVolume();			
				break;

			case K_RIGHTARROW:		//right
				VC_IncreaseVolume();
				break;
			case 0x5b:			//[
				VC_DecreaseVolume();
				break;
			case 0x5d:			//]
				VC_IncreaseVolume();
				break;
			case 0x6d:			//m
				VC_Mute();				
			default:
				return FALSE;				
		}
		return TRUE;
	}

	return FALSE;
};

//-----------------------------------------------------------------------------
// ParseTempEntity
// parse tempentity if it suits your fancy, return TRUE to tell engine you have finished parsing the tempentity,
// return FALSE to tell engine to parse tempentity itself (it will reset parse position automatically)
//-----------------------------------------------------------------------------
float() CSQC_Parse_TempEntity =
{
	return FALSE;
};

//-----------------------------------------------------------------------------
// Event_Sound
// return TRUE if you wish to eat this sound, return FALSE to let engine handle it.
//-----------------------------------------------------------------------------
float(entity ent, float channel, string soundname, float volume, float attenuation, vector pos, float speed100, float sflags) CSQC_Event_Sound =
{
	return FALSE;
};

//-----------------------------------------------------------------------------
// Event
// return TRUE if you want to eat this event, otherwise return FALSE to let engine handle it.
// NOT USED IN DARKPLACES
//-----------------------------------------------------------------------------
float(float event) CSQC_Event =
{
	return FALSE;
};

/*
//-----------------------------------------------------------------------------
// Ent_Spawn
// called when a network slot was previously empty, before parsing begins
// this basically lets you do extra work before returning the result of spawn()
// OPTIONAL, probably should be deprecated as well
//-----------------------------------------------------------------------------
entity(float entnum) CSQC_Ent_Spawn =
{
	return spawn();
};
*/

//-----------------------------------------------------------------------------
// Ent_Update
// parse a network update, isnew indicates this network slot was previously empty
// if you wish to do interpolation, be sure to make use the proper time variables:
// time is previous packet time, servertime is new packet time, so the tick time between packets
// is servertime - time and the interpolation should begin the new move at servertime and end at
// servertime + (servertime - time)
//-----------------------------------------------------------------------------
void(float isnew) CSQC_Ent_Update =
{
};

//-----------------------------------------------------------------------------
// Ent_Remove
// called when a network slot is emptied, you may choose to remove(self) or not
//-----------------------------------------------------------------------------
void() CSQC_Ent_Remove =
{
	if (self.t_remove)
		if (self.t_remove())
			remove(self);
};

//-----------------------------------------------------------------------------
// GameCommand
// called when cl_cmd is used in the console (much like menu_cmd and sv_cmd for menu.dat and progs.dat),
// can perform special logic or useful functionality (like bestweapon)
//-----------------------------------------------------------------------------
void(string msg) GameCommand =
{
};
