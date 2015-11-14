
void() bubble_bob;

/*
==============================================================================

PLAYER

==============================================================================
*/

$cd id1/models/player_4
$origin 0 -6 24
$base base		
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6


/*
==============================================================================
PLAYER
==============================================================================
*/

void() player_run;
void() GibPlayer;
void() CreateDeathCam;
void(vector ofs, vector vel, float randomvel, vector avel, float randomavel) player_ejectcasing;


void()	player_stand1 =[	$axstnd1,	player_stand1	]
{
	self.weaponframe = 0;
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe = 0;
		player_run();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe >= 12)
			self.walkframe = 0;
		self.frame = $axstnd1 + self.walkframe;
	}
#ifdef HIPNOTIC
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.walkframe >= 12)
			self.walkframe = 0;
		self.frame = 6 + self.walkframe;
	}
#endif
	else
	{
		if (self.walkframe >= 5)
			self.walkframe = 0;
		self.frame = $stand1 + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;	
};

void()	player_run =[	$rockrun1,	player_run	]
{
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.weaponframe = 0;
	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe = 0;
		player_stand1();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe >= 6)
			self.walkframe = 0;
		self.frame = $axrun1 + self.walkframe;
	}
#ifdef HIPNOTIC
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.walkframe >= 6)
			self.walkframe = 0;
		self.frame = self.walkframe;
	}
#endif
	else
	{
		if (self.walkframe >= 6)
			self.walkframe = 0;
		self.frame = self.frame + self.walkframe;
	}


//	if (footsteps == 1)
//	{
/*
	self.spawnsilent = self.spawnsilent + vlen(self.origin - self.old_velocity);
	self.old_velocity = self.origin;
	if ((self.flags & FL_ONGROUND) && (self.waterlevel < LEVEL_WAIST))
	{
		if (self.spawnsilent > 95)
		{
	    		local float r;
	    		if (self.spawnsilent > 190)
	       			self.spawnsilent = 0;
	    		else
	       			self.spawnsilent = 0.5*(self.spawnsilent - 95);
	    		r = random();
			if (r < 0.14)
				sound (self, CHAN_VOICE, "player/foot1.wav", 0.5, ATTN_NORM);
			else if (r < 0.29)
				sound (self, CHAN_VOICE, "player/foot2.wav", 0.5, ATTN_NORM);
			else if (r < 0.43)
				sound (self, CHAN_VOICE, "player/foot3.wav", 0.5, ATTN_NORM);
			else if (r < 0.58)
				sound (self, CHAN_VOICE, "player/foot4.wav", 0.5, ATTN_NORM);
			else if (r < 0.72)
				sound (self, CHAN_VOICE, "player/foot5.wav", 0.5, ATTN_NORM);
			else if (r < 0.86)
				sound (self, CHAN_VOICE, "player/foot6.wav", 0.5, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "player/foot7.wav", 0.5, ATTN_NORM);
		}
	}
//	}
*/
	self.walkframe = self.walkframe + 1;
};


void()	player_shot1 =	[$shotatt1, 	player_shot2	] {self.weaponframe = 1;self.effects = self.effects | EF_MUZZLEFLASH;};
void()	player_shot2 =	[$shotatt2, 	player_shot3	] {self.weaponframe = 2;};
void()	player_shot3 =	[$shotatt3, 	player_shot4	] 
{
//	ejectcasing(org + -5*v_forward, v_right*120 + v_up*30, 40, self.v_angle_x*'-1 0 0' + self.v_angle_y*'0 1 0', '30 -200 0', 50);
//	ejectcasing(org -8*v_forward - v_right, v_right* -120 + v_up*50, 30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '30 200 0', 80);
//	ejectcasing(org -8*v_forward + v_right, v_right*120 + v_up*50, 30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '30 -200 0', 80);

	if (self.weapon == IT_SHOTGUN)
		player_ejectcasing('-5 0 0', '0 120 30', 40, '30 -200 0', 50);

	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_ejectcasing('-7 -1 0', '0 -100 30', 40, '20 150 0', 50);
	
		if (self.ammo_shells > 0)
			player_ejectcasing('-7 1 0', '0 100 30', 40, '20 -150 0', 50);
	}

	self.weaponframe = 3;
};
void()	player_shot4 =	[$shotatt4, 	player_shot5	] {self.weaponframe = 4;};
void()	player_shot5 =	[$shotatt5, 	player_shot6	] {self.weaponframe = 5;};
void()	player_shot6 =	[$shotatt6, 	player_run	] {self.weaponframe = 6;};

void()	player_axe1 =	[$axatt1, 	player_axe2	] {self.weaponframe++;};
void()	player_axe2 =	[$axatt2, 	player_axe3	] {self.weaponframe++;};
void()	player_axe3 =	[$axatt3, 	player_axe4	] {self.weaponframe++;W_FireAxe();};
void()	player_axe4 =	[$axatt4, 	player_run	] {self.weaponframe++;};

void()	player_axeb1 =	[$axattb1, 	player_axeb2	] {self.weaponframe++;};
void()	player_axeb2 =	[$axattb2, 	player_axeb3	] {self.weaponframe++;};
void()	player_axeb3 =	[$axattb3, 	player_axeb4	] {self.weaponframe++;W_FireAxe();};
void()	player_axeb4 =	[$axattb4, 	player_run	] {self.weaponframe++;};

void()	player_axec1 =	[$axattc1, 	player_axec2	] {self.weaponframe++;};
void()	player_axec2 =	[$axattc2, 	player_axec3	] {self.weaponframe++;};
void()	player_axec3 =	[$axattc3, 	player_axec4	] {self.weaponframe++;W_FireAxe();};
void()	player_axec4 =	[$axattc4, 	player_run	] {self.weaponframe++;};

void()	player_axed1 =	[$axattd1, 	player_axed2	] {self.weaponframe++;};
void()	player_axed2 =	[$axattd2, 	player_axed3	] {self.weaponframe++;};
void()	player_axed3 =	[$axattd3, 	player_axed4	] {self.weaponframe++;W_FireAxe();};
void()	player_axed4 =	[$axattd4, 	player_run	] {self.weaponframe++;};


//============================================================================

void() player_nail1  =	[$nailatt1, 	player_nail2  	] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
	{
		player_run ();
		return;
	}

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (2);	//4

//	if (self.weapon == IT_SUPER_NAILGUN)
//		self.attack_finished = time + 0.05;
//	else
		self.attack_finished = time + 0.2;

};
void() player_nail2  =	[$nailatt2, 	player_nail1  	]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (-2);	//-4

//	if (self.weapon == IT_SUPER_NAILGUN)
//		self.attack_finished = time + 0.05;
//	else
		self.attack_finished = time + 0.2;
};

//============================================================================

void() player_light1  =	[$light1, 	player_light2  	] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
	{
		player_run ();
		return;
	}

	self.weaponframe = self.weaponframe + 1 + 2*rint(random());

	if (self.weaponframe > 7)	//5
		self.weaponframe = 1;

	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;	//0.2;
};
void() player_light2  =	[$light2, 	player_light1  	]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
	{
		player_run ();
		return;
	}

	self.weaponframe = self.weaponframe + 1 + 2*rint(random());

	if (self.weaponframe > 7)	//5
		self.weaponframe = 1;

	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;	//0.2;
};

//============================================================================

void() player_rocket1  = [$rockatt1, 	player_rocket2  ] {self.weaponframe=1;self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_rocket2  = [$rockatt2, 	player_rocket3  ] {self.weaponframe=2;};
void() player_rocket3  = [$rockatt3, 	player_rocket4  ] {self.weaponframe=3;};
void() player_rocket4  = [$rockatt4, 	player_rocket5  ] {self.weaponframe=4;};
void() player_rocket5  = [$rockatt5, 	player_rocket6  ] {self.weaponframe=5;};
void() player_rocket6  = [$rockatt6, 	player_run  	] {self.weaponframe=6;};

#ifdef HIPNOTIC
// HIPWEAPONS
//============================================================================
void() HIP_FireMjolnir;
void(float stat) HIP_FireLaser;

void() player_hammer1  =  [32, 		player_hammer2  ] {self.weaponframe=1;};
void() player_hammer2  =  [33, 		player_hammer3  ] {self.weaponframe=2;};
void() player_hammer3  =  [34, 		player_hammer4  ] {self.weaponframe=3;};
void() player_hammer4  =  [35, 		player_hammer5  ] {self.weaponframe=4;HIP_FireMjolnir();};
void() player_hammer5  =  [36, 		player_hammer6  ] {self.weaponframe=4;};
void() player_hammer6  =  [37, 		player_run	] {self.weaponframe=4;};

void() player_mjolnir1  = [38, 		player_mjolnir2 ] {self.weaponframe=1;};
void() player_mjolnir2  = [39, 		player_mjolnir3 ] {self.weaponframe=2;};
void() player_mjolnir3  = [40, 		player_mjolnir4 ] {self.weaponframe=3;};
void() player_mjolnir4  = [41, 		player_mjolnir5 ] {self.weaponframe=4;HIP_FireMjolnir();};
void() player_mjolnir5  = [42, 		player_mjolnir6 ] {self.weaponframe=4;};
void() player_mjolnir6  = [43, 		player_run	] {self.weaponframe=4;};


void() player_laser1	= [$nailatt1,	player_laser3	] {self.attack_finished = time + 0.1;self.weaponframe=1;self.nextthink = time + 0.1;HIP_FireLaser(0);};
void() player_laser2	= [$nailatt2,	player_laser3	] {self.attack_finished = time + 0.1;self.weaponframe=2;self.nextthink = time + 0.1;};
void() player_laser3	= [$nailatt2,	player_laser1	] {self.attack_finished = time + 0.1;self.weaponframe=4;self.nextthink = time + 0.1;HIP_FireLaser(1);};
void() player_laser4	= [$nailatt1,	player_laser1	] {self.attack_finished = time + 0.1;self.weaponframe=5;self.nextthink = time + 0.1;};
//============================================================================
#endif

/*
void () player_jump	= [ 85,		player_jump1 ] {};
void () player_jump1	= [ 86,		player_jump2 ] {};
void () player_jump2	= [ 62,		player_jump3 ] {};
void () player_jump3	= [ 63,		player_jump4 ] {setsize (self, VEC_HULL_MIN, (VEC_HULL_MAX - '1 0 24'));};
void () player_jump4	= [ 64,		player_jump5 ] {};
void () player_jump5	= [ 65,		player_jump6 ] {setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);};
void () player_jump6	= [ 87,		player_jump7 ] {};
void () player_jump7	= [ 86,		player_run   ] {};
*/

void () player_jump	= [ 85,		player_jump1 ] {};
void () player_jump1	= [ 86,		player_jump2 ] {};
void () player_jump2	= [ 62,		player_jump3 ] {};
void () player_jump3	= [ 64,		player_jump4 ] {setsize (self, VEC_HULL_MIN + '0 0 8', VEC_HULL_MAX + '0 0 -8');};
void () player_jump4	= [ 65,		player_jump5 ] {};
void () player_jump5	= [ 87,		player_jump6 ] {setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);};
void () player_jump6	= [ 86,		player_run   ] {};

void(float num_bubbles) DeathBubbles;

void() PainSound =
{
	local	float	rs, rb;

	if (self.health < 1)
		return;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

// bubbles
	if (self.watertype == CONTENT_WATER || self.watertype == CONTENT_SLIME)
	if (self.waterlevel == LEVEL_EYES)
	{
		rb = 1 + 2*random();
		DeathBubbles(rb);
	}

	rs = random();
// water pain sounds
	if (self.watertype == CONTENT_WATER)
	if (self.waterlevel == LEVEL_EYES)
	{
		if (rs > 0.5)
			sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		return;
	}
	
// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
		if (rs > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (rs > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
	{
		self.axhitme = FALSE;
		return;
	}

	self.pain_finished = time + 0.5;

// ax pain sound
	if (self.axhitme == TRUE)
	{
		self.axhitme = FALSE;
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}

	rs = rint((random() * 5) + 1);

	self.noise = "";
	if (rs == 1)
		self.noise = "player/pain1.wav";
	else if (rs == 2)
		self.noise = "player/pain2.wav";
	else if (rs == 3)
		self.noise = "player/pain3.wav";
	else if (rs == 4)
		self.noise = "player/pain4.wav";
	else if (rs == 5)
		self.noise = "player/pain5.wav";
	else
		self.noise = "player/pain6.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void()	player_pain1  =	[$pain1,	player_pain2	] {PainSound();self.weaponframe=0;};
void()	player_pain2  =	[$pain2,	player_pain3	] {};
void()	player_pain3  =	[$pain3,	player_pain4	] {};
void()	player_pain4  =	[$pain4,	player_pain5	] {};
void()	player_pain5  =	[$pain5,	player_pain6	] {};
void()	player_pain6  =	[$pain6,	player_run	] {self.inpain = FALSE;};

void()	player_axpain1 = [$axpain1,	player_axpain2	] {PainSound();self.weaponframe=0;};
void()	player_axpain2 = [$axpain2,	player_axpain3	] {};
void()	player_axpain3 = [$axpain3,	player_axpain4	] {};
void()	player_axpain4 = [$axpain4,	player_axpain5	] {};
void()	player_axpain5 = [$axpain5,	player_axpain6	] {};
void()	player_axpain6 = [$axpain6,	player_run	] {self.inpain = FALSE;};

#ifdef HIPNOTIC
void()	player_hampain1 = [18,		player_hampain2 ] {PainSound();self.weaponframe=0;};
void()	player_hampain2 = [19,		player_hampain3 ] {};
void()	player_hampain3 = [20,		player_hampain4 ] {};
void()	player_hampain4 = [21,		player_hampain5 ] {};
void()	player_hampain5 = [22,		player_hampain6 ] {};
void()	player_hampain6 = [23,		player_run	] {self.inpain = FALSE;};
#endif


void() player_pain =
{
	if (time < self.inpain)
	if (random() > 0.3)
		return;

	if (self.weaponframe)
		return;

	if (self.invisible_finished > time)
		return;		// eyes don't have pain frames

	self.inpain = time + 0.3;

	if (self.weapon == IT_AXE)
		player_axpain1 ();
#ifdef HIPNOTIC
	else if (self.weapon == IT_MJOLNIR)
		player_hampain1 ();
#endif
	else
	{
		player_pain1 ();
	}
};

void() player_diea1;
void() player_dieb1;
void() player_diec1;
void() player_died1;
void() player_diee1;
void() player_die_ax1;
#ifdef HIPNOTIC
void() player_die_ham1;
#endif

void() DeathSound =
{
	local float rs, rb;

// water death sounds
	if (self.waterlevel == LEVEL_EYES) 
		if (self.watertype != CONTENT_LAVA)
		{
			rb = 15 + 15*random();
			DeathBubbles(rb);
			sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
			return;
		}
	
	rs = rint ((random() * 4) + 1);
	if (rs == 1)
		self.noise = "player/death1.wav";
	if (rs == 2)
		self.noise = "player/death2.wav";
	if (rs == 3)
		self.noise = "player/death3.wav";
	if (rs == 4)
		self.noise = "player/death4.wav";
	if (rs == 5)
		self.noise = "player/death5.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};


void() PlayerDie =
{
	local	float	i;
	
	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.items = self.items - (self.items & IT_INVULNERABILITY);
	self.items = self.items - (self.items & IT_QUAD);
	self.items = self.items - (self.items & IT_SUIT);
#ifdef HIPNOTIC
	self.items2 = self.items2 - (self.items2 & HIP_IT_EMPATHY_SHIELDS);
#endif

	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
#ifdef HIPNOTIC
	self.wetsuit_finished = 0;
	self.empathy_finished = 0;
#endif

	self.flags = self.flags | FL_NOBREATH;

	self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	self.glow_size = 0;

	self.modelindex = modelindex_player;	// don't use eyes

	if (self.invisweapon)
		invisweapon_remove();

	if (deathmatch || coop)
		DropBackpack();
	
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;

	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;

	DeathSound();
	
	self.angles_x = 0;
	self.angles_z = 0;
	
	if (self.weapon == IT_AXE)
	{
		player_die_ax1 ();		
		return;
	}

#ifdef HIPNOTIC
	else if (self.weapon == IT_MJOLNIR)
	{
		self.modelindex = modelindex_hammer; // use hammer model
		player_die_ham1();
		return;
	}
#endif
	i = cvar("temp1");

	if (!i)
		i = 1 + floor(random()*6);
	if (i == 1)
		player_diea1();
	else if (i == 2)
		player_dieb1();
	else if (i == 3)
		player_diec1();
	else if (i == 4)
		player_died1();
	else
		player_diee1();

};


// used by kill command and diconnect command
void() set_suicide_frame =
{
	local float i;

	if (self.model != "progs/player.mdl")	// allready gibbed
		return;

	if (self.weapon == IT_AXE)
		self.frame = $axdeth9;

#ifdef HIPNOTIC
	else if (self.weapon == IT_MJOLNIR)
		self.frame = 31;
#endif
	
	else 
	{
		i = 1 + floor(random()*6);

		if (i == 1)
			self.frame = $deatha11;
	
		else if (i == 2)
			self.frame = $deathb9;
	
		else if (i == 3)
			self.frame = $deathc15;
	
		else if (i == 4)
			self.frame = $deathd9;
	
		else
			self.frame = $deathe9;
	}

	self.health = 0;	
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;

	self.angles_x = 0;
	self.angles_z = 0;

	CopyToBodyQue(self);

	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;

};


//called by corpse in the last anim frame
void() PlayerDead =
{
	self.nextthink = -1;

// allow respawn after a certain time
	self.aiment.deadflag = DEAD_DEAD;

//	if (!self.ishuman)	//frikbot
//		return;

	if (self.aiment.model != "progs/h_player.mdl")	//if not already gibbed
		self.aiment.nextthink = -1;

// so the player doesn't move upon respawn
	self.aiment.velocity = '0 0 0';
	self.aiment.avelocity = '0 0 0';

// unlink client from their corpse
//	self.aiment = self;
};


void(vector bmins, vector bmaxs) body_solid;
void(vector bmins, vector bmaxs) body_nonsolid;

void()	player_diea1	=	[	$deatha1,	player_diea2	] {CreateDeathCam(); body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea2	=	[	$deatha2,	player_diea3	] {self.takedamage = DAMAGE_YES; body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea3	=	[	$deatha3,	player_diea4	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea4	=	[	$deatha4,	player_diea5	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea5	=	[	$deatha5,	player_diea6	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diea6	=	[	$deatha6,	player_diea7	] {body_solid('-16 -16 -24', '16 16 21');};
void()	player_diea7	=	[	$deatha7,	player_diea8	] {body_solid('-16 -16 -24', '16 16 12');};
void()	player_diea8	=	[	$deatha8,	player_diea9	] {body_nonsolid('-16 -16 -24', '16 16 1');};
void()	player_diea9	=	[	$deatha9,	player_diea10	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diea10	=	[	$deatha10,	player_diea11	] {body_nonsolid('-16 -16 -24', '16 16 0'); PlayerDead();};
void()	player_diea11	=	[	$deatha11,	player_diea11	] {body_nonsolid('-16 -16 -24', '16 16 -6');};

void()	player_dieb1	=	[	$deathb1,	player_dieb2	] {CreateDeathCam(); body_solid('-16 -16 -24', '16 16 24');};
void()	player_dieb2	=	[	$deathb2,	player_dieb3	] {self.takedamage = DAMAGE_YES; body_solid('-16 -16 -24', '16 16 24');};
void()	player_dieb3	=	[	$deathb3,	player_dieb4	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_dieb4	=	[	$deathb4,	player_dieb5	] {body_solid('-16 -16 -24', '16 16 21');};
void()	player_dieb5	=	[	$deathb5,	player_dieb6	] {body_solid('-16 -16 -24', '16 16 12');};
void()	player_dieb6	=	[	$deathb6,	player_dieb7	] {body_solid('-16 -16 -24', '16 16 7');};
void()	player_dieb7	=	[	$deathb7,	player_dieb8	] {body_solid('-16 -16 -24', '16 16 5');};
void()	player_dieb8	=	[	$deathb8,	player_dieb9	] {body_nonsolid('-16 -16 -24', '16 16 0'); PlayerDead();};
void()	player_dieb9	=	[	$deathb9,	player_dieb9	] {body_nonsolid('-16 -16 -24', '16 16 0');};

void()	player_diec1	=	[	$deathc1,	player_diec2	] {CreateDeathCam(); body_solid('-16 -16 -24', '16 16 24');};
void()	player_diec2	=	[	$deathc2,	player_diec3	] {self.takedamage = DAMAGE_YES; body_solid('-16 -16 -24', '16 16 24');};
void()	player_diec3	=	[	$deathc3,	player_diec4	] {body_solid('-16 -16 -24', '16 16 24');};
void()	player_diec4	=	[	$deathc4,	player_diec5	] {body_solid('-16 -16 -24', '16 16 23');};
void()	player_diec5	=	[	$deathc5,	player_diec6	] {body_solid('-16 -16 -24', '16 16 12');};
void()	player_diec6	=	[	$deathc6,	player_diec7	] {body_nonsolid('-16 -16 -24', '16 16 2');};
void()	player_diec7	=	[	$deathc7,	player_diec8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec8	=	[	$deathc8,	player_diec9	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec9	=	[	$deathc9,	player_diec10	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec10	=	[	$deathc10,	player_diec11	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec11	=	[	$deathc11,	player_diec12	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec12	=	[	$deathc12,	player_diec13	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec13	=	[	$deathc13,	player_diec14	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diec14	=	[	$deathc14,	player_diec15	] {body_nonsolid('-16 -16 -24', '16 16 0'); PlayerDead();};
void()	player_diec15	=	[	$deathc15,	player_diec15	] {body_nonsolid('-16 -16 -24', '16 16 -6');};

void()	player_died1	=	[	$deathd1,	player_died2	] {CreateDeathCam(); body_solid('-16 -16 -24', '16 16 24');};
void()	player_died2	=	[	$deathd2,	player_died3	] {self.takedamage = DAMAGE_YES; body_solid('-16 -16 -24', '16 16 24');};
void()	player_died3	=	[	$deathd3,	player_died4	] {body_solid('-16 -16 -24', '16 16 22');};
void()	player_died4	=	[	$deathd4,	player_died5	] {body_solid('-16 -16 -24', '16 16 18');};
void()	player_died5	=	[	$deathd5,	player_died6	] {body_solid('-16 -16 -24', '16 16 13');};
void()	player_died6	=	[	$deathd6,	player_died7	] {body_nonsolid('-16 -16 -24', '16 16 3');};
void()	player_died7	=	[	$deathd7,	player_died8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_died8	=	[	$deathd8,	player_died9	] {body_nonsolid('-16 -16 -24', '16 16 0'); PlayerDead();};
void()	player_died9	=	[	$deathd9,	player_died9	] {body_nonsolid('-16 -16 -24', '16 16 -6');};

void()	player_diee1	=	[	$deathe1,	player_diee2	] {CreateDeathCam(); body_solid('-16 -16 -24', '16 16 24');};
void()	player_diee2	=	[	$deathe2,	player_diee3	] {self.takedamage = DAMAGE_YES; body_solid('-16 -16 -24', '16 16 22');};
void()	player_diee3	=	[	$deathe3,	player_diee4	] {body_solid('-16 -16 -24', '16 16 13');};
void()	player_diee4	=	[	$deathe4,	player_diee5	] {body_solid('-16 -16 -24', '16 16 7');};
void()	player_diee5	=	[	$deathe5,	player_diee6	] {body_nonsolid('-16 -16 -24', '16 16 3');};
void()	player_diee6	=	[	$deathe6,	player_diee7	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diee7	=	[	$deathe7,	player_diee8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_diee8	=	[	$deathe8,	player_diee9	] {body_nonsolid('-16 -16 -24', '16 16 0'); PlayerDead();};
void()	player_diee9	=	[	$deathe9,	player_diee9	] {body_nonsolid('-16 -16 -24', '16 16 -6');};

void()	player_die_ax1	=	[	$axdeth1,	player_die_ax2	] {CreateDeathCam(); body_solid('-16 -16 -24', '16 16 24');};
void()	player_die_ax2	=	[	$axdeth2,	player_die_ax3	] {self.takedamage = DAMAGE_YES; body_solid('-16 -16 -24', '16 16 24');};
void()	player_die_ax3	=	[	$axdeth3,	player_die_ax4	] {body_solid('-16 -16 -24', '16 16 21');};
void()	player_die_ax4	=	[	$axdeth4,	player_die_ax5	] {body_solid('-16 -16 -24', '16 16 15');};
void()	player_die_ax5	=	[	$axdeth5,	player_die_ax6	] {body_solid('-16 -16 -24', '16 16 3');};
void()	player_die_ax6	=	[	$axdeth6,	player_die_ax7	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_die_ax7	=	[	$axdeth7,	player_die_ax8	] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_die_ax8	=	[	$axdeth8,	player_die_ax9	] {body_nonsolid('-16 -16 -24', '16 16 0'); PlayerDead();};
void()	player_die_ax9	=	[	$axdeth9,	player_die_ax9	] {body_nonsolid('-16 -16 -24', '16 16 -6');};

#ifdef HIPNOTIC
void()	player_die_ham1 =	[	24,		player_die_ham2 ] {CreateDeathCam(); body_solid('-16 -16 -24', '16 16 24');};
void()	player_die_ham2 =	[	25,		player_die_ham3 ] {self.takedamage = DAMAGE_YES; body_solid('-16 -16 -24', '16 16 24');};
void()	player_die_ham3 =	[	26,		player_die_ham4 ] {body_solid('-16 -16 -24', '16 16 21');};
void()	player_die_ham4 =	[	27,		player_die_ham5 ] {body_solid('-16 -16 -24', '16 16 15');};
void()	player_die_ham5 =	[	28,		player_die_ham6 ] {body_solid('-16 -16 -24', '16 16 3');};
void()	player_die_ham6 =	[	29,		player_die_ham7 ] {body_nonsolid('-16 -16 -24', '16 16 0');};
void()	player_die_ham7 =	[	30,		player_die_ham8 ] {body_nonsolid('-16 -16 -24', '16 16 0');PlayerDead();};
void()	player_die_ham8 =	[	31,		player_die_ham8 ] {body_nonsolid('-16 -16 -24', '16 16 -6');};
#endif