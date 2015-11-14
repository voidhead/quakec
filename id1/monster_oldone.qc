/*
==============================================================================

OLD ONE

==============================================================================
*/
$cd id1/models/old_one
$origin 0 0 24
$base base
$skin skin
$scale 1

$frame old1 old2 old3 old4 old5 old6 old7 old8 old9 
$frame old10 old11 old12 old13 old14 old15 old16 old17 old18 old19 
$frame old20 old21 old22 old23 old24 old25 old26 old27 old28 old29 
$frame old30 old31 old32 old33 old34 old35 old36 old37 old38 old39 
$frame old40 old41 old42 old43 old44 old45 old46 

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8
$frame shake9 shake10 shake11 shake12 shake13 shake14
$frame shake15 shake16 shake17 shake18 shake19 shake20
//$frame shake9 shake10 shake11 shake12 shake12 shake13 shake14

void() finale_1;
void() finale_2;
void() finale_3;
void() finale_4;
void() massacre;


//void() old_stand     	=[      $old1,       	old_stand    	] {};

void() old_idle1        =[      $old1,		old_idle2       ] {};
void() old_idle2        =[      $old2,		old_idle3       ] {};
void() old_idle3        =[      $old3,  	old_idle4       ] {};
void() old_idle4        =[      $old4,  	old_idle5       ] {};
void() old_idle5        =[      $old5,  	old_idle6       ] {};
void() old_idle6        =[      $old6,  	old_idle7       ] {};
void() old_idle7        =[      $old7,  	old_idle8       ] {};
void() old_idle8        =[      $old8,  	old_idle9       ] {};
void() old_idle9        =[      $old9,  	old_idle10      ] {};
void() old_idle10       =[      $old10, 	old_idle11      ] {};
void() old_idle11       =[      $old11, 	old_idle12      ] {};
void() old_idle12       =[      $old12, 	old_idle13      ] {};
void() old_idle13       =[      $old13, 	old_idle14      ] {};
void() old_idle14       =[      $old14, 	old_idle15      ] {};
void() old_idle15       =[      $old15, 	old_idle16      ] {};
void() old_idle16       =[      $old16, 	old_idle17      ] {};
void() old_idle17       =[      $old17, 	old_idle18      ] {};
void() old_idle18       =[      $old18, 	old_idle19      ] {};
void() old_idle19       =[      $old19, 	old_idle20      ] {};
void() old_idle20       =[      $old20, 	old_idle21      ] {};
void() old_idle21       =[      $old21, 	old_idle22      ] {};
void() old_idle22       =[      $old22, 	old_idle23      ] {};
void() old_idle23       =[      $old23, 	old_idle24      ] {};
void() old_idle24       =[      $old24, 	old_idle25      ] {};
void() old_idle25       =[      $old25, 	old_idle26      ] {};
void() old_idle26       =[      $old26, 	old_idle27      ] {};
void() old_idle27       =[      $old27, 	old_idle28      ] {};
void() old_idle28       =[      $old28, 	old_idle29      ] {};
void() old_idle29       =[      $old29, 	old_idle30      ] {};
void() old_idle30       =[      $old30, 	old_idle31      ] {};
void() old_idle31       =[      $old31, 	old_idle32      ] {};
void() old_idle32       =[      $old32, 	old_idle33      ] {};
void() old_idle33       =[      $old33, 	old_idle34      ] {};
void() old_idle34       =[      $old34, 	old_idle35      ] {};
void() old_idle35       =[      $old35, 	old_idle36      ] {};
void() old_idle36       =[      $old36, 	old_idle37      ] {};
void() old_idle37       =[      $old37, 	old_idle38      ] {};
void() old_idle38       =[      $old38, 	old_idle39      ] {};
void() old_idle39       =[      $old39, 	old_idle40      ] {};
void() old_idle40       =[      $old40, 	old_idle41      ] {};
void() old_idle41       =[      $old41, 	old_idle42      ] {};
void() old_idle42       =[      $old42, 	old_idle43      ] {};
void() old_idle43       =[      $old43, 	old_idle44      ] {};
void() old_idle44       =[      $old44, 	old_idle45      ] {};
void() old_idle45       =[      $old45, 	old_idle46      ] {};
void() old_idle46       =[      $old46, 	old_idle1       ] {};


void() old_thrash1	=[ 	$shake1,  	old_thrash2	] {lightstyle(0, "m");};
void() old_thrash2	=[      $shake2,  	old_thrash3	] {lightstyle(0, "k");};
void() old_thrash3	=[      $shake3,  	old_thrash4	] {lightstyle(0, "k");};
void() old_thrash4	=[      $shake4,  	old_thrash5	] {lightstyle(0, "i");};
void() old_thrash5	=[      $shake5, 	old_thrash6	] {lightstyle(0, "g");};
void() old_thrash6	=[      $shake6,  	old_thrash7	] {lightstyle(0, "e");};
void() old_thrash7	=[      $shake7,  	old_thrash8	] {lightstyle(0, "c");};
void() old_thrash8	=[      $shake8,  	old_thrash9	] {lightstyle(0, "a");};
void() old_thrash9	=[      $shake9,  	old_thrash10	] {lightstyle(0, "c");};
void() old_thrash10	=[      $shake10, 	old_thrash11	] {lightstyle(0, "e");};
void() old_thrash11	=[      $shake11, 	old_thrash12	] {lightstyle(0, "g");};
void() old_thrash12	=[      $shake12, 	old_thrash13	] {lightstyle(0, "i");};
void() old_thrash13	=[      $shake13, 	old_thrash14	] {lightstyle(0, "k");};
void() old_thrash14	=[      $shake14, 	old_thrash15	] {lightstyle(0, "m");};
void() old_thrash15	=[      $shake15, 	old_thrash16	] 
{
	lightstyle(0, "m");
	self.cnt = self.cnt + 1;
	if (self.cnt != 3)
		self.think = old_thrash1;
};
void() old_thrash16	=[      $shake16,	old_thrash17	] {lightstyle(0, "g");};
void() old_thrash17	=[      $shake17,	old_thrash18	] {lightstyle(0, "c");};
void() old_thrash18	=[      $shake18,	old_thrash19	] {lightstyle(0, "b");};
void() old_thrash19	=[      $shake19,	old_thrash20	] {lightstyle(0, "a");};
void() old_thrash20	=[      $shake20,	old_thrash20	] {finale_4();};

//============================================================================

// Delay moving and reorienting the player so that the CSQC can catch up
void() player_finale_look =
{
	local entity pl, pos;

	pl = self;
	pos = self.movetarget;

	pl.view_ofs = VEC_0;
	pl.angles = pos.mangle;
	pl.v_angle = pos.mangle;
	pl.fixangle = TRUE;	// turn this way immediately

	pl.think = SUB_Null;	// 1999-09-24 Firing during intermission fix by Athos
	pl.nextthink = 1;

	pl.takedamage = DAMAGE_NO;
	pl.solid = SOLID_NOT;
	pl.movetype = MOVETYPE_NONE;
	pl.modelindex = 0;

	setorigin (pl, pos.origin);

	pl.items = pl.items - (pl.items & IT_INVISIBILITY);
	pl.items = pl.items - (pl.items & IT_INVULNERABILITY);
	pl.items = pl.items - (pl.items & IT_QUAD);
	pl.items = pl.items - (pl.items & IT_SUIT);
	pl.invisible_finished = 0;
	pl.invincible_finished = 0;
	pl.super_damage_finished = 0;
	pl.radsuit_finished = 0;
	pl.glow_size = 0;
};

void(entity pl) player_put_standin =
{
	local entity e;

	e = spawn();
	setmodel (e, pl.model);
	setorigin (e, pl.origin);

	e.angles = pl.angles;
	e.frame = pl.frame;
	e.weapon = pl.weapon;
	e.colormap = pl.colormap;
	e.skin = pl.skin;
	e.netname = pl.netname;

	e.think = player_stand1;
	e.nextthink = time + 0.1;

//	print("created standin ", etos(e), "\n");
};

void() finale_1 =
{
	local	entity	pos, pl;
	local	entity	timer;

	intermission_exittime = time + EXTRA_HIGH;	// never allow exit
	intermission_running = TRUE;

	// find the intermission spot
	pos = find (world, classname, "info_intermission");
	if (!pos)
		error ("no info_intermission");

	pl = find (world, classname, "misc_teleporttrain");
	if (!pl)
		error ("no teleporttrain");

	remove (pl);

	WriteByte (MSG_ALL, SVC_FINALE);
	WriteString (MSG_ALL, "");

	// make fake versions of all players as standins, and move the real
	// players to the intermission spot
	pl = find (world, classname, "player");
	while (pl != world)
	{
		// workaround for changing the player's v_angle
		pl.map = self.map;
		pl.movetarget = pos;
		pl.think = player_finale_look;
		pl.nextthink = time + 0.1;

		if (pl != shub_killer)
			player_put_standin(pl);

		pl = find (pl, classname, "player");
	}	
	
	// wait for 1 second
	timer = spawn();
	timer.nextthink = time + 1;
	timer.think = finale_2;	
};

void() finale_2 =
{
	local vector o;

	// start a teleport splash inside shub
	o = shub.origin - '0 100 0';

	te_teleport(o);
	sound (shub, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
	
	self.nextthink = time + 2;
	self.think = finale_3;
};

void() finale_3 =
{
// start shub thrashing wildly
	shub.think = old_thrash1;

	sound (shub, CHAN_VOICE, "boss2/death.wav", 1, ATTN_NORM);
	lightstyle(0, "abcdefghijklmlkjihgfedcb");

	self.nextthink = time + 4.9;	//4.8;
	self.think = massacre;
};

void() massacre =
{
	local entity n;
	n = nextent(world);

//	dprint(ftos(killed_monsters));
//	dprint(" massacre begin");
//	dprint("\n");

	while (n != world)
	{
		if (n.takedamage)
		if (n.flags & FL_MONSTER || n.flags & FL_CORPSE)
		{
//			dprint(ftos(killed_monsters));
//			dprint(" stomping ");
//			dprint(n.classname);
//			dprint("\n");
			T_Damage (n, world, n, 50000, "");
		}
		n = nextent(n);
	}
	remove(self);

//	dprint(ftos(killed_monsters));
//	dprint(" massacre end");
//	dprint("\n");

};


void() finale_4 =
{
	// throw tons of meat chunks	
	local	vector	oldo;
	local	float	x, y, z;
	local	float	r;
	local	entity	n;

	oldo = self.origin;

	killed_monsters = killed_monsters + 1;
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER);		// FIXME: reliable broadcast

	sound (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NORM);
	
	self.velocity = '0 0 0'; // so the gibs don't fly in any particular direction

//	te_bloodshower(shub.origin + 2*shub.mins, shub.origin + 2*shub.maxs, 500, 512);

	te_bloodshower(shub.absmin + '-16 -16 118', shub.absmax + '16 16 16', 1024, 2048);

//	te_bloodshower(shub.origin + shub.mins + '0 0 512', shub.origin + shub.maxs + '0 0 512', 1024, 2048);

	z = 16;
	while (z <= 144)
	{
		x = -60;
		while (x <= 60)
		{
			y = -60;
			while (y <= 60)
			{
				self.origin_x = oldo_x + x;
				self.origin_y = oldo_y + y;
				self.origin_z = oldo_z + z;
//				self.dest_x = self.origin_x - shub.origin_x ;
//				self.dest_y = self.origin_y - shub.origin_y ;
//				self.dest_z = shub.origin_z;
				self.dest_x = x;
				self.dest_y = y;
				self.dest_z = z;

				r = random();
				if (r < 0.3)				
					ThrowGib ("progs/gib1.mdl", -999, self.dest);
				else if (r < 0.6)
					ThrowGib ("progs/gib2.mdl", -999, self.dest);
				else
					ThrowGib ("progs/gib3.mdl", -999, self.dest);
				y = y + 15;
			}
			x = x + 15;
		}
		z = z + 64;
	}

// start the end text
	WriteByte (MSG_ALL, SVC_FINALE);
	WriteString (MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. id Software salutes you.");

// put a player model down
	n = spawn();
	setmodel (n, "progs/player.mdl");
	oldo = oldo - '32 264 0';
	setorigin (n, oldo);
	n.angles = '0 290 0';
	n.frame = 18;		//18 .. 29
	n.weapon = IT_AXE;

	if (shub_killer)
		n.colormap = shub_killer.colormap;

	n.think = player_stand1;		//dummyplayer_stand;	//dummyplayerthink;
	n.nextthink = time + 0.1;
	remove (self);

// switch cd track
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, SVC_UPDATESTAT);
	lightstyle(0, "m");	
};

//============================================================================

void () nopain =
{
	self.health = 10;	//40000;
};

//============================================================================

void() monster_oldone_precache =
{
	precache_model2 ("progs/oldone.mdl");

	precache_sound2 ("boss2/death.wav");
	precache_sound2 ("boss2/idle.wav");
	precache_sound2 ("boss2/sight.wav");
	precache_sound2 ("boss2/pop2.wav");
};

//============================================================================

/*QUAKED monster_oldone (1 0 0) (-16 -16 -24) (16 16 32)
*/
void() monster_oldone =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_oldone_precache();

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	
	setmodel (self, "progs/oldone.mdl");
	setsize (self, '-160 -128 -24', '160 128 256');

	self.takedamage = DAMAGE_AIM;
	self.health = 40000;		// kill by telefrag
	self.gibhealth = EXTRA_LOW;
	self.mass = EXTRA_HIGH;
	self.flags = self.flags | FL_NOBREATH | FL_NOLAVADMG | FL_NOSLIMEDMG;

	self.think = old_idle1;
	self.nextthink = time + 0.1;	

	self.th_pain = nopain;
	self.th_die = finale_1;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_gib = SUB_Null;

	total_monsters = total_monsters + 1;
	
	shub = self;
};

