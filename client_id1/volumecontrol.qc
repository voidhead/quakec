/*
#define	SLIDER_RANGE	10
#define bound(min,num,max) ((num) >= (min) ? ((num) < (max) ? (num) : (max)) : (min))

static void M_ItemPrint(float cx, float cy, const char *str, int unghosted)
{
	if (unghosted)
		DrawQ_String(menu_x + cx, menu_y + cy, str, 0, 8, 8, 1, 1, 1, 1, 0, NULL, true, FONT_MENU);
	else
		DrawQ_String(menu_x + cx, menu_y + cy, str, 0, 8, 8, 0.4, 0.4, 0.4, 1, 0, NULL, true, FONT_MENU);
}

	  float DrawQ_String(float startx, float starty, const char *text, size_t maxlen, float w, float h, float basered, float basegreen, float baseblue, float basealpha, int flags, int *outcolor, qboolean ignorecolorcodes, const dp_font_t *fnt)

static void M_DrawSlider (int x, int y, float num, float rangemin, float rangemax)
{
	char text[16];
	int i;
	float range;
	range = bound(0, (num - rangemin) / (rangemax - rangemin), 1);
	M_DrawCharacter (x-8, y, 128);
	for (i = 0;i < SLIDER_RANGE;i++)
		M_DrawCharacter (x + i*8, y, 129);
	M_DrawCharacter (x+i*8, y, 130);
	M_DrawCharacter (x + (SLIDER_RANGE-1)*8 * range, y, 131);
	if (fabs((int)num - num) < 0.01)
		dpsnprintf(text, sizeof(text), "%i", (int)num);
	else
		dpsnprintf(text, sizeof(text), "%.3f", num);
	M_Print(x + (SLIDER_RANGE+2) * 8, y, text);
}

static void M_Options_PrintSlider(const char *s, int enabled, float value, float minvalue, float maxvalue)
{
	if (opty >= 32)
	{
		if (optnum == optcursor)
			DrawQ_Fill(menu_x + 48, menu_y + opty, 320, 8, optnum == optcursor ? (0.5 + 0.2 * sin(realtime * M_PI)) : 0, 0, 0, 0.5, 0);
		M_ItemPrint(0 + 48, opty, s, enabled);
		M_DrawSlider(0 + 48 + (int)strlen(s) * 8 + 8, opty, value, minvalue, maxvalue);
	}
	opty += 8;
	optnum++;
}


	M_Options_PrintSlider(  "          Sound Volume", snd_initialized.integer, volume.value, 0, 1);
	M_Options_PrintSlider(  "          Music Volume", cdaudioinitialized.integer, bgmvolume.value, 0, 1);

	print(chr2str(0x80));
	print(chr2str(0x81, 0x81, 0x81, 0x81, 0x81));
	print(chr2str(0x83));
	print(chr2str(0x81, 0x81, 0x81, 0x81, 0x81));
	print(chr2str(0x82));
	print("\n");
*/

void(float x, float y, float char, vector rgb, float alph, float scl) Sbar_DrawChar =
{
	local vector charsize, pos;

	charsize = '8 8 0'*scl;
	pos_x = x;
	pos_y = y;
	drawcharacter(pos, char, charsize, rgb, alph, DRAWFLAG_NORMAL);

//	drawpic(pos, pic, picsize, rgb, alph, DRAWFLAG_NORMAL);
//	drawstring(pos, char, '9 9 0', '1 1 1', 1.0, DRAWFLAG_NORMAL);
};

void(float x, float y, string str, vector rgb, float alph, float scl) Sbar_DrawString =
{
	local vector charsize, pos;
	charsize = '8 8 0'*scl;
	pos_x = x;
	pos_y = y;
	drawstring(pos, str, charsize, rgb, alph, DRAWFLAG_NORMAL);
};

void(vector pos, vector sz, float alph) Sbar_Drawfill =
{
	local vector rgb; 

	rgb_x = 0.5 + 0.2*sin(time*M_PI);

	drawfill(pos, sz, rgb, alph, DRAWFLAG_NORMAL);
	
//	DrawQ_Fill(menu_x + 48, menu_y + opty, 320, 8, optnum == optcursor ? (0.5 + 0.2 * sin(time * M_PI)) : 0, 0, 0, 0.5, 0);

};

void(float x, float y, float num, float rangemin, float rangemax) Sbar_DrawSlider =
{
	local string text;
	local float i, range, stchar;
	local vector clr;

	stchar = 0x80;

//	if (num == 0)
//		stchar -= 0x7f;	// grey

	range = bound(0, (num - rangemin)/(rangemax - rangemin), 1);

//	M_DrawCharacter (x-8, y, 128);
	Sbar_DrawChar(x - 8, y, stchar, '1 1 1', 1, 1);

	for (i = 0; i < SLIDER_RANGE; i++)
//		M_DrawCharacter (x + i*8, y, 129);
		Sbar_DrawChar(x + i*8, y, stchar + 1, '1 1 1', 1, 1);

//	M_DrawCharacter (x+i*8, y, 130);
	Sbar_DrawChar(x + i*8, y, stchar + 2, '1 1 1', 1, 1);

//	M_DrawCharacter (x + (SLIDER_RANGE-1)*8 * range, y, 131);
	Sbar_DrawChar(x + (SLIDER_RANGE-1)*8*range, y, stchar + 3, '1 1 1', 1, 1);

	if (fabs(rint(num) - num) < 0.001)
		text = sprintf("%d", rint(num));
	else
		text = sprintf("%.3f", num);

//	M_Print(x + (SLIDER_RANGE+2) * 8, y, text);

	clr_x = bound(0, (2*range), 1);		//R
	clr_y = bound(0, (-2*range + 2), 1);	//G

	Sbar_DrawString(x + (SLIDER_RANGE + 2)*8, y, text, clr, 1, 1);
};

void(vector pos, string caption, float enabled, float value, float minvalue, float maxvalue) Sbar_PrintSlider = 
{
//	local vector clr;
//	local float x, y;

//	if (opty >= 32)
//	{
//		if (optnum == optcursor)
//			DrawQ_Fill(menu_x + 48, menu_y + opty, 320, 8, optnum == optcursor ? (0.5 + 0.2 * sin(realtime * M_PI)) : 0, 0, 0, 0.5, 0);
//		M_ItemPrint(0 + 48, opty, s, enabled);
	if (enabled)
		Sbar_DrawString(pos_x, pos_y, caption, MENU_COLOR_NORMAL, 1, 1);
	else
		Sbar_DrawString(pos_x, pos_y, caption, MENU_COLOR_DISABLED, 1, 1);

		Sbar_DrawSlider(pos_x + strlen(caption)*8 + 8, pos_y, value, minvalue, maxvalue);
//	}
//	opty += 8;
//	optnum++;
}

void() Sbar_DrawVolumeControls =
{
	local vector vc_org;
//	local float sndinit, cdinit, sndvol, bgmvol;

	if (!vc_active)
		return;

	if (time - vc_active > autocvar_scr_centertime)
	{
		vc_active = FALSE;
		vc_pos = 0;
		return;
	}

	vc_org_x = vid_conwidth/2 - 16*8 + 4;
	vc_org_y = vid_conheight/2 + 8*8;	//168

//	sndinit = autocvar_snd_initialized;
//	cdinit = autocvar_cdaudioinitialized;

	Sbar_Drawfill(vc_org + '8 0 0' + '0 8 0'*vc_pos, '240 8 0', 0.5);

	Sbar_PrintSlider(vc_org, " Sound Volume", autocvar_snd_initialized, autocvar_volume, 0, 1); 
	Sbar_PrintSlider(vc_org + '0 8 0', " Music Volume", autocvar_cdaudioinitialized, autocvar_bgmvolume, 0, 1);
};


void() VC_IncreaseVolume =
{
	local float vol;

	localcmd("play misc/menu3.wav");

	if (!vc_active)
	{
		vc_active = time;
		vc_pos = 0;
		return;
	}

	if (vc_pos == 0)
	{
		vol = bound(0, (autocvar_volume + VOLUME_INCREMENT), 1);
		cvar_set("volume", ftos(vol));
	}
	else
	{
		vol = bound(0, (autocvar_bgmvolume + VOLUME_INCREMENT), 1);
		cvar_set("bgmvolume", ftos(vol));	
	}

	vc_active = time;
};

void() VC_DecreaseVolume =
{
	local float vol;

	localcmd("play misc/menu3.wav");

	if (!vc_active)
	{
		vc_active = time;
		vc_pos = 0;
		return;
	}

	if (vc_pos == 0)
	{
		vol = bound(0, (autocvar_volume - VOLUME_INCREMENT), 1);
		cvar_set("volume", ftos(vol));
	}
	else
	{
		vol = bound(0, (autocvar_bgmvolume - VOLUME_INCREMENT), 1);
		cvar_set("bgmvolume", ftos(vol));	
	}

	vc_active = time;
};

void() VC_ToggleSFX =
{
	if (autocvar_volume > 0)
	{
		vc_sfx_vol_bak = autocvar_volume;
		cvar_set("volume", "0");		
	}
	else
	{
		cvar_set("volume", ftos(vc_sfx_vol_bak));		
	}
};

void() VC_ToggleBGM =
{
	if (autocvar_bgmvolume > 0)
	{
		vc_bgm_vol_bak = autocvar_bgmvolume;
		cvar_set("bgmvolume", "0");		
	}
	else
	{
		cvar_set("bgmvolume", ftos(vc_bgm_vol_bak));		
	}
};

void() VC_Mute =
{
	localcmd("play misc/menu1.wav");

	if (vc_pos == 0)
		VC_ToggleSFX();
	else
		VC_ToggleBGM();

	vc_active = time;
};
