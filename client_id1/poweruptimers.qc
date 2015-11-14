// align stuff to the bottom middle
/*vector(vector v) Sbar_Align =
{
	// SB_BOTTOM - the default
	//v_x = v_x + (vid_width / 2);
	//v_y = vid_height - v_y;
	return v;

		
	//v_x = vid_size_x*0.050 - hud_width*0.050;
	//v_y = vid_size_y*0.83 - hud_height*0.83;

	//return v;
	
}; */

void(vector pos, string pic, vector rgb, float alph, float scl) Sbar_DrawPic =
{
	local vector picsize;
	picsize = drawgetimagesize(pic)*scl;
	drawpic(pos, pic, picsize, rgb, alph, DRAWFLAG_NORMAL);
};

float(float ind) PowerupQue = 
{
	float i, qmin, current, place;

	current = drawque[ind];
	place = 0;
	qmin = EXTRA_HIGH;
	
	for (i=0; i<=DRAWQUE_SIZE-1; i=i+1)
	{
		if (i == ind)
		{
			qmin = EXTRA_HIGH;
		}
		else
			qmin = drawque[i];

		if (current >= qmin)
			place++; 
	}

	return place;
};

void(vector pos, float type, vector rgb) DrawPowerupTime =
{
	string pic, s, digit;
	float i, ind, len, digits, powtime, powend, place;
	vector v;

	powend = getstatf(type);
	powtime = powend - time;
	ind = type - 32;

	if ((powtime <= 0) || (powtime > 99))
	{
		drawque[ind] = EXTRA_HIGH; 
		return;

	}
	else if (powtime >= 1)
		s = ftos(rint(powtime));
	else 
		s = substring(ftos(powtime), 1, 2);

	drawque[ind] = powtime;
	place = PowerupQue(ind);
	pos += place * '0 -24 0';

	len = strlen(s);
	digits = 2;

	for (i=1; i<=len; i=i+1)
	{
		digit = substring(s, len - i, 1);

		if (digit == ".")
		{
			digit = "COMMA";
			v = pos + ('36 0 0' + '24 0 0' * (digits - i - 1));
		}
		else
			v = pos + ('24 0 0' * (digits - i));

		pic = strcat("gfx/GNUM_", digit);

		if ( 
			   (powtime > 3.5)
		     	|| ((powtime < 3) && (powtime > 2.5))
		     	|| ((powtime < 2) && (powtime > 1.5))
		     	|| (powtime < 1) 
		   )
			Sbar_DrawPic(v, pic, rgb, 1, 1);
	}
};