void(float c1) pr1 =
{
	WriteChar(msg_mode, c1 | red);
};

void(float c1, float c2) pr2 =
{
	WriteChar(msg_mode, c1 | red);
	WriteChar(msg_mode, c2 | red);
};

void(float c1, float c2, float c3) pr3 =
{
	WriteChar(msg_mode, c1 | red);
	WriteChar(msg_mode, c2 | red);
	WriteChar(msg_mode, c3 | red);
};

void(float c1, float c2, float c3, float c4) pr4 =
{
	WriteChar(msg_mode, c1 | red);
	WriteChar(msg_mode, c2 | red);
	WriteChar(msg_mode, c3 | red);
	WriteChar(msg_mode, c4 | red);
};

void(float c1, float c2, float c3, float c4, float c5) pr5 =
{
	WriteChar(msg_mode, c1 | red);
	WriteChar(msg_mode, c2 | red);
	WriteChar(msg_mode, c3 | red);
	WriteChar(msg_mode, c4 | red);
	WriteChar(msg_mode, c5 | red);
};

void(float c1, float c2, float c3, float c4, float c5, float c6) pr6 =
{
	WriteChar(msg_mode, c1 | red);
	WriteChar(msg_mode, c2 | red);
	WriteChar(msg_mode, c3 | red);
	WriteChar(msg_mode, c4 | red);
	WriteChar(msg_mode, c5 | red);
	WriteChar(msg_mode, c6 | red);
};

void(float c1, float c2, float c3, float c4, float c5, float c6, float c7) pr7 =
{
	WriteChar(msg_mode, c1 | red);
	WriteChar(msg_mode, c2 | red);
	WriteChar(msg_mode, c3 | red);
	WriteChar(msg_mode, c4 | red);
	WriteChar(msg_mode, c5 | red);
	WriteChar(msg_mode, c6 | red);
	WriteChar(msg_mode, c7 | red);
};

void(float c1, float c2, float c3, float c4, float c5, float c6, float c7, float c8) pr8 =
{
	WriteChar(msg_mode, c1 | red);
	WriteChar(msg_mode, c2 | red);
	WriteChar(msg_mode, c3 | red);
	WriteChar(msg_mode, c4 | red);
	WriteChar(msg_mode, c5 | red);
	WriteChar(msg_mode, c6 | red);
	WriteChar(msg_mode, c7 | red);
	WriteChar(msg_mode, c8 | red);
};

void(float InMsgMode, float InTarget) prstart =
{
	red = RED_OFF;
	msg_mode = InMsgMode;
	
	WriteChar(msg_mode, InTarget);
};

void() prend =
{
	WriteChar(msg_mode, 0);
};

void() pr_newline =
{
	WriteChar(msg_mode, 10);
};

void(float n) prnum =
{
	local float f, char;

	if (n < 0)
	{
		WriteChar(msg_mode, red + 45);
		n = 0 - n;
	}

	f = floor(n / 10);
	n = n - (f * 10);

	if (f)
		prnum(f);
		
	char = 48 + red;
	WriteChar(msg_mode, char + n);

	return;
};

void() qonquer_stats =
{
	local entity player;
	local float monsters_killed;
	local float playtime, hrs, mns, secs, msecs;

	// Customize the screen to what Qonquer needs to be showing
	
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, 2);
	WriteByte(MSG_ALL, 3);
	
	prstart(MSG_ALL, SVC_FINALE);
	
	// [Qonquer]
	pr1(16);
	red = RED_ON;
	pr7(81,111,110,113,117,101,114);
	red = RED_OFF;
	pr1(17);
	pr1(10);
	pr1(10);
	pr1(10);
	
	// You survived for 
	pr8(89,111,117,32,115,117,114,118);
	pr8(105,118,101,100,32,102,111,114);
	pr1(32);

	// # waves
	red = RED_ON;
	prnum(qonquer.currentwave);
	red = RED_OFF;
	
	//  wave
	pr5(32,119,97,118,101);
	
	if(!qonquer.currentwave || qonquer.currentwave > 1)
		pr1(115);
	
	pr1(10);
	
	// and killed 
	pr8(97,110,100,32,107,105,108,108);
	pr3(101,100,32);	
	
	monsters_killed = qonquer.stat_soldierkills + qonquer.stat_dogkills + qonquer.stat_demonkills + 
			  qonquer.stat_enforcerkills + qonquer.stat_fishkills + qonquer.stat_hellknightkills + 
			  qonquer.stat_knightkills + qonquer.stat_shalrathkills + qonquer.stat_shamblerkills + 
			  qonquer.stat_tarbabykills + qonquer.stat_wizardkills + qonquer.stat_zombiekills + qonquer.stat_ogrekills;
	
	// # monsters killed
	red = RED_ON;
	prnum(monsters_killed);
	red = RED_OFF;
	
	// monsters.
	pr8(32,109,111,110,115,116,101,114);
	
	if (!monsters_killed || monsters_killed > 1)
		pr1(115);
	
	pr1(46);
	
	if(qonquer.stat_minionskilled > 0)
	{
		pr1(10);
		pr1(10);
		
		// # minions killed
		red = RED_ON;
		prnum(qonquer.stat_minionskilled);
		red = RED_OFF;
	
		//  minion(s) died on your behalf.
		pr7(32,109,105,110,105,111,110);

		if(qonquer.stat_minionskilled > 1)
			pr1(115);

		pr8(32,100,105,101,100,32,111,110);
		pr8(32,121,111,117,114,32,98,101);
		pr5(104,97,108,102,46);
		pr1(10);
	}

	pr1(10);
	pr1(10);

	// time played: h:mm:ss.s
	pr8(84,105,109,101,32,112,108,97);
	pr5(121,101,100,58,32);

	playtime = time - qonquer.ltime;

	secs = floor(playtime);
	msecs = floor(10*(playtime - secs));

	hrs = mod(secs, 3600);
	mns = mod(secs, 60) - 60*hrs;
	secs = rem(secs, 60);

/*
	if(hrs)
		print(ftos(hrs), ":");
	if (mns < 10)
		print("0");
	print(ftos(mns), ":");
	if (secs < 10)
		print("0");
	print(ftos(secs), ".", ftos(msecs), "\n");
*/

	red = RED_ON;

	if(hrs)
	{
		prnum(hrs);
		pr1(58);
	}

	if (hrs && mns < 10)
		prnum(0);

	prnum(mns);
	pr1(58);

	if (secs < 10)
		prnum(0);

	prnum(secs);
	pr1(46);

	if (msecs)
		prnum(msecs);

	red = RED_OFF;
	pr1(10);

	pr1(10);
	pr1(10);
	pr1(10);

/*	
	// -- qonquer stats --
	pr8 (45,45,32,113,111,110,113,117);
	pr8(101,114,32,115,116,97,116,115);
	pr3(32,45,45);
	pr1(10);
	pr1(10);
*/

	// -- kill counts --
	pr8 (45,45,32,107,105,108,108,32);
	pr8(99,111,117,110,116,115,32,45);
	pr1(45);
	pr1(10);
	pr1(10);

	if (!monsters_killed)
	{
		// 0
		red = RED_ON;
		pr1(48);
		red = RED_OFF;
	
		// monsters killed
		pr8 (32,109,111,110,115,116,101,114);
		pr8 (115,32,107,105,108,108,101,100);
		pr1(10);
	}
	
	if(qonquer.stat_soldierkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_soldierkills);
		red = RED_OFF;
		
		//  grunt
		pr6(32,103,114,117,110,116);
		
		if(qonquer.stat_soldierkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_dogkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_dogkills);
		red = RED_OFF;
	
		//  rottweiler
		pr8(32,114,111,116,116,119,101,105);
		pr3(108,101,114);
		
		if(qonquer.stat_dogkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_demonkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_demonkills);
		red = RED_OFF;
	
		//  fiend
		pr6(32,102,105,101,110,100);
		
		if(qonquer.stat_demonkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_enforcerkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_enforcerkills);
		red = RED_OFF;
	
		//  enforcer
		pr8(32,101,110,102,111,114,99,101);
		pr1(114);
		
		if(qonquer.stat_enforcerkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_fishkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_fishkills);
		red = RED_OFF;
			
		//  rotfish
		pr8(32,114,111,116,102,105,115,104);
		
		pr1(10);
	}
	
	if(qonquer.stat_hellknightkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_hellknightkills);
		red = RED_OFF;
	
		//  death knight
		pr8(32,100,101,97,116,104,32,107);
		pr5(110,105,103,104,116);
		
		if(qonquer.stat_hellknightkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_knightkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_knightkills);
		red = RED_OFF;
	
		//  knight
		pr7(32,107,110,105,103,104,116);
		
		if(qonquer.stat_knightkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_shalrathkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_shalrathkills);
		red = RED_OFF;
	
		//  vore
		pr5(32,118,111,114,101);
		
		if(qonquer.stat_shalrathkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_shamblerkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_shamblerkills);
		red = RED_OFF;
	
		//  shambler
		pr8(32,115,104,97,109,98,108,101);
		pr1(114);
		
		if(qonquer.stat_shamblerkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_tarbabykills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_tarbabykills);
		red = RED_OFF;
	
		//  spawn
		pr6(32,115,112,97,119,110);
			
		pr1(10);
	}
	
	if(qonquer.stat_wizardkills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_wizardkills);
		red = RED_OFF;
	
		//  scrag
		pr6(32,115,99,114,97,103);
		
		if(qonquer.stat_wizardkills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_zombiekills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_zombiekills);
		red = RED_OFF;
	
		//  zombie
		pr7(32,122,111,109,98,105,101);
		
		if(qonquer.stat_zombiekills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	if(qonquer.stat_ogrekills > 0)
	{
		red = RED_ON;
		prnum(qonquer.stat_ogrekills);
		red = RED_OFF;
	
		//  ogre
		pr5(32,111,103,114,101);
		
		if(qonquer.stat_ogrekills > 1)
			pr1(115);
			
		pr1(10);
	}
	
	pr1(10);
	pr1(10);

	// press fire to play again!
	red = RED_ON;
	pr8(112,114,101,115,115,32,102,105);
	pr8(114,101,32,116,111,32,112,108);
	pr8(97,121,32,97,103,97,105,110);
	pr1(33);
	red = RED_OFF;
	
	prend();

	// Reset the player
	player = find (world, classname, "player");

	while (player != world)
	{
		player.items = IT_SHOTGUN | IT_AXE;
		player.health = MAX_PL_HEALTH;
		player.armorvalue = 0;
		player.ammo_shells = 25;
		player.ammo_nails = 0;
		player.ammo_rockets = 0;
		player.ammo_cells = 0;
		player.weapon = 0;
		player.armortype = 0;
		player = find (player, classname, "player");
	}
};