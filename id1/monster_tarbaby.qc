/*
==============================================================================

BLOB

==============================================================================
*/

$cd id1/models/tarbaby
$origin 0 0 24
$base base		

$skin skin

$frame walk1 walk2 walk3 walk4  walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25

$frame run1 run2 run3 run4 run5 run6  run7 run8 run9 run10 run11 run12 run13
$frame run14 run15 run16 run17 run18 run19 run20 run21 run22 run23
$frame run24 run25

$frame jump1 jump2 jump3 jump4 jump5 jump6

$frame fly1 fly2 fly3 fly4

$frame exp

void() Tar_JumpTouch;
void() Tar_Leap;
void() Tar_Fly;
void() Tar_Explode;
void() tbaby_sight;
void() tbaby_standb1;

//void()	tbaby_stand1	=[	$walk1,		tbaby_stand1	] {ai_stand();};

void()	tbaby_standa1	=[	$walk1,		tbaby_standa2	] {ai_stand();};
void()	tbaby_standa2	=[	$walk2,		tbaby_standa3	] {ai_stand();};
void()	tbaby_standa3	=[	$walk3,		tbaby_standa4	] {ai_stand();};
void()	tbaby_standa4	=[	$walk4,		tbaby_standa5	] {ai_stand();};
void()	tbaby_standa5	=[	$walk5,		tbaby_standa6	] {ai_stand();};
void()	tbaby_standa6	=[	$walk6,		tbaby_standa7	] {ai_stand();};
void()	tbaby_standa7	=[	$walk5,		tbaby_standa8	] {ai_stand();};
void()	tbaby_standa8	=[	$walk4,		tbaby_standa9	] {ai_stand();};
void()	tbaby_standa9	=[	$walk3,		tbaby_standa10	] {ai_stand();};
void()	tbaby_standa10	=[	$walk2,		tbaby_standa1	] 
{
	ai_stand();
	if (random() > 0.5)
		self.think = tbaby_standb1;
};

void()	tbaby_standb1	=[	$run1,		tbaby_standb2	] {ai_stand();};
void()	tbaby_standb2	=[	$run2,		tbaby_standb3	] {ai_stand();};
void()	tbaby_standb3	=[	$run3,		tbaby_standb4	] {ai_stand();};
void()	tbaby_standb4	=[	$run4,		tbaby_standb5	] {ai_stand();};
void()	tbaby_standb5	=[	$run5,		tbaby_standb6	] {ai_stand();};
void()	tbaby_standb6	=[	$run4,		tbaby_standb7	] {ai_stand();};
void()	tbaby_standb7	=[	$run3,		tbaby_standb8	] {ai_stand();};
void()	tbaby_standb8	=[	$run2,		tbaby_standb1	] 
{
	ai_stand();
	if (random() > 0.5)
		self.think = tbaby_standa1;
};

void()	tbaby_hang1	=[	$walk1,		tbaby_hang1	] {ai_stand();};

void()	tbaby_walk1	=[	$walk1,		tbaby_walk2	] {ai_turn();};
void()	tbaby_walk2	=[	$walk2,		tbaby_walk3	] {ai_turn();};
void()	tbaby_walk3	=[	$walk3,		tbaby_walk4	] {ai_turn();};
void()	tbaby_walk4	=[	$walk4,		tbaby_walk5	] {ai_turn();};
void()	tbaby_walk5	=[	$walk5,		tbaby_walk6	] {ai_turn();};
void()	tbaby_walk6	=[	$walk6,		tbaby_walk7	] {ai_turn();};
void()	tbaby_walk7	=[	$walk7,		tbaby_walk8	] {ai_turn();};
void()	tbaby_walk8	=[	$walk8,		tbaby_walk9	] {ai_turn();};
void()	tbaby_walk9	=[	$walk9,		tbaby_walk10	] {ai_turn();};
void()	tbaby_walk10	=[	$walk10,	tbaby_walk11	] {ai_turn();};
void()	tbaby_walk11	=[	$walk11,	tbaby_walk12	] {ai_walk(2);};
void()	tbaby_walk12	=[	$walk12,	tbaby_walk13	] {ai_walk(2);};
void()	tbaby_walk13	=[	$walk13,	tbaby_walk14	] {ai_walk(2);};
void()	tbaby_walk14	=[	$walk14,	tbaby_walk15	] {ai_walk(2);};
void()	tbaby_walk15	=[	$walk15,	tbaby_walk16	] {ai_walk(2);};
void()	tbaby_walk16	=[	$walk16,	tbaby_walk17	] {ai_walk(2);};
void()	tbaby_walk17	=[	$walk17,	tbaby_walk18	] {ai_walk(2);};
void()	tbaby_walk18	=[	$walk18,	tbaby_walk19	] {ai_walk(2);};
void()	tbaby_walk19	=[	$walk19,	tbaby_walk20	] {ai_walk(2);};
void()	tbaby_walk20	=[	$walk20,	tbaby_walk21	] {ai_walk(2);};
void()	tbaby_walk21	=[	$walk21,	tbaby_walk22	] {ai_walk(2);};
void()	tbaby_walk22	=[	$walk22,	tbaby_walk23	] {ai_walk(2);};
void()	tbaby_walk23	=[	$walk23,	tbaby_walk24	] {ai_walk(2);};
void()	tbaby_walk24	=[	$walk24,	tbaby_walk25	] {ai_walk(2);};
void()	tbaby_walk25	=[	$walk25,	tbaby_walk1	] {ai_walk(2);};


void()	tbaby_run1	=[	$run1,		tbaby_run2	] {ai_face();};
void()	tbaby_run2	=[	$run2,		tbaby_run3	] {ai_face();};
void()	tbaby_run3	=[	$run3,		tbaby_run4	] {ai_face();};
void()	tbaby_run4	=[	$run4,		tbaby_run5	] {ai_face();};
void()	tbaby_run5	=[	$run5,		tbaby_run6	] {ai_face();};
void()	tbaby_run6	=[	$run6,		tbaby_run7	] {ai_face();};
void()	tbaby_run7	=[	$run7,		tbaby_run8	] {ai_face();};
void()	tbaby_run8	=[	$run8,		tbaby_run9	] {ai_face();};
void()	tbaby_run9	=[	$run9,		tbaby_run10	] {ai_face();};
void()	tbaby_run10	=[	$run10,		tbaby_run11	] {ai_face();};
void()	tbaby_run11	=[	$run11,		tbaby_run12	] {ai_run(3);};
void()	tbaby_run12	=[	$run12,		tbaby_run13	] {ai_run(3);};
void()	tbaby_run13	=[	$run13,		tbaby_run14	] {ai_run(3);};
void()	tbaby_run14	=[	$run14,		tbaby_run15	] {ai_run(3);};
void()	tbaby_run15	=[	$run15,		tbaby_run16	] {ai_run(3);};
void()	tbaby_run16	=[	$run16,		tbaby_run17	] {ai_run(3);};
void()	tbaby_run17	=[	$run17,		tbaby_run18	] {ai_run(3);};
void()	tbaby_run18	=[	$run18,		tbaby_run19	] {ai_run(3);};
void()	tbaby_run19	=[	$run19,		tbaby_run20	] {ai_run(3);};
void()	tbaby_run20	=[	$run20,		tbaby_run21	] {ai_run(3);};
void()	tbaby_run21	=[	$run21,		tbaby_run22	] {ai_run(3);};
void()	tbaby_run22	=[	$run22,		tbaby_run23	] {ai_run(3);};
void()	tbaby_run23	=[	$run23,		tbaby_run24	] {ai_run(3);};
void()	tbaby_run24	=[	$run24,		tbaby_run25	] {ai_run(3);};
void()	tbaby_run25	=[	$run25,		tbaby_run1	] {ai_run(3);};


void()	tbaby_fly1	=[	$fly1,		tbaby_fly2	] {};
void()	tbaby_fly2	=[	$fly2,		tbaby_fly3	] {};
void()	tbaby_fly3	=[	$fly3,		tbaby_fly4	] {};
void()	tbaby_fly4	=[	$fly4,		tbaby_fly1	] {Tar_Fly();};


void()	tbaby_jump1	=[	$jump1,		tbaby_jump2	] {ai_face();};
void()	tbaby_jump2	=[	$jump2,		tbaby_jump3	] {ai_face();};
void()	tbaby_jump3	=[	$jump3,		tbaby_jump4	] {ai_face();};
void()	tbaby_jump4	=[	$jump4,		tbaby_jump5	] {ai_face();};
void()	tbaby_jump5	=[	$jump5,		tbaby_jump6	] {Tar_Leap();};
void()	tbaby_jump6	=[	$jump6,		tbaby_fly1	] {};


void(entity killer, float damage)	tbaby_die1	=[	$exp,		tbaby_die2	] 
{
	if (random() < 0.3)
		self.enemy = killer;	// track who exploded the tarbaby so we can use them as the attacker
	else
		self.enemy = self;

	self.velocity = VEC_0;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
};
void()	tbaby_die2	=[	$exp,		SUB_Null	] {Tar_Explode();};

//=============================================================================

void() tbaby_sight =
{
	sound (self, CHAN_AUTO, "blob/sight1.wav", 1, ATTN_NORM);
};

//=============================================================================

float() Tar_CheckBottom =
{
	tracebox(self.origin, self.mins, self.maxs, self.origin + '0 0 -2', FALSE, self);
//	tracebox(self.origin, self.mins + '-1 -1 -1', self.maxs + '1 1 1', self.origin, FALSE, self);

	if (trace_fraction == 1)
		return FALSE;
	else
		return TRUE;
};

void() Tar_Fly =
{
	self.cnt = self.cnt + 1;

	if (self.cnt == 4)
	{
//		dprint ("spawn hop\n");
		tbaby_jump5 ();
	}
};


void() Tar_Leap =
{	
	// check if there is room for a jump
	tracebox(self.origin, '-32 -32 -8', '32 32 48', self.origin + '0 0 1', FALSE, self);

	if (trace_fraction != 1)	// abort jump and run around for a while
	{
//		print("aborting jump\n");
//		setsize (self, '-16 -16 -24', '16 16 40');
		self.movetype = MOVETYPE_STEP;
		self.think = tbaby_run1;	//demon1_run1;
		self.attack_finished = time + 0.01;
		return;
	}

	self.movetype = MOVETYPE_BOUNCE;
	self.touch = Tar_JumpTouch;

	setorigin(self, self.origin + '0 0 1');
//	setsize (self, '-20 -20 -8', '20 20 48');

	makevectors (self.angles);
	self.velocity = v_forward * 600 + '0 0 200';
	self.velocity_z = self.velocity_z + random()*150;

	self.flags = self.flags - (self.flags & FL_ONGROUND);	

	self.cnt = 0;
};


void()	Tar_JumpTouch =
{
	local float ldmg, rnum;

	if (self.health < 1)
		return;

	if (other.takedamage)
	{
		if (other.classname != self.classname)
		if (vlen(self.velocity) > 400)
		{
			rnum = random();
			ldmg = 10 + 10*rnum;
			T_Damage (other, self, self, ldmg, "");	
		}
		sound (self, CHAN_WEAPON, "blob/hit1.wav", 1, ATTN_NORM);
	}
	else
		sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);


	if (!Tar_CheckBottom() || (other.absmax_z < self.absmin_z + 2 && other.solid == SOLID_SLIDEBOX))
	{
		if (self.flags & FL_ONGROUND || (other.absmax_z < self.absmin_z + 2 && other.solid == SOLID_SLIDEBOX))
		{	// jump randomly to not get hung up
//			dprint ("popjump\n");
//			setsize (self, '-16 -16 -24', '16 16 40');
			self.touch = SUB_Null;
			self.think = tbaby_run1;	//tbaby_run1;
			self.movetype = MOVETYPE_STEP;
			self.nextthink = time + 0.01;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}

		return;	// not on ground yet
	}

//	setsize (self, '-16 -16 -24', '16 16 40');
	self.touch = SUB_Null;
	self.think = tbaby_jump1;
	self.nextthink = time + 0.01;
};


void() Tar_Explode =
{
	local float r, damg;

	r = 5 + floor(random()*5);
	
	while (r > 0)
	{
		r--;
		damg = 100 + 20*random();
		ThrowGib ("progs/tar_gib.mdl", self.health - damg, VEC_0);
	}

	T_RadiusDamage (self, self.enemy, 120, world, "tar_explosion");
	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	te_tarexplosion(self.origin);

	BecomeExplosion ();
};

//============================================================================

void() monster_tarbaby_precache =
{
	precache_model2 ("progs/tar_gib.mdl");
	precache_model2 ("progs/tarbaby.mdl");

	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
};

//=============================================================================

void() monster_tarbaby_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/tarbaby.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');
//	setsize (self, '-20 -20 -8', '16 16 48');

	self.max_health = 80;
	self.corpsehealth = EXTRA_HIGH;
	self.gibhealth = EXTRA_LOW;
	self.gib = GIB_NOGIB;
	self.headname = "";
	self.mass = 100;

	self.flags = self.flags | FL_NOBREATH | FL_NOSLIMEDMG; // | FL_NOBLOOD 	// allow them to travel through slime

	self.th_stand = tbaby_standa1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_missile = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_die = tbaby_die1;
	self.th_sight = tbaby_sight;
	self.th_gib = SUB_Null;
	self.th_pain = SUB_Null;
	
	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();
};

/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_tarbaby =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_tarbaby_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_tarbaby_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, '-16 -16 -24', '16 16 40');
		self.spawnfactory = monster_tarbaby_spawn;
	}
	else
	{
		monster_tarbaby_spawn();
		total_monsters = total_monsters + 1;
	}
};

