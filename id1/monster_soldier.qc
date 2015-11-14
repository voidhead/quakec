/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/
void() army_fire;
void() army_idle;
void() army_sight;
void() army_active;
void() army_backpack;


void() army_stand1 	=[	$stand1,	army_stand2	] {army_idle(); ai_stand();};
void() army_stand2 	=[	$stand2, 	army_stand3	] {ai_stand();};
void() army_stand3 	=[	$stand3, 	army_stand4	] {ai_stand();};
void() army_stand4 	=[	$stand4, 	army_stand5	] {ai_stand();};
void() army_stand5 	=[	$stand5, 	army_stand6	] {ai_stand();};
void() army_stand6 	=[	$stand6, 	army_stand7	] {ai_stand();};
void() army_stand7 	=[	$stand7, 	army_stand8	] {ai_stand();};
void() army_stand8 	=[	$stand8, 	army_stand1	] {ai_stand();};


void() army_walk1  	=[	$prowl_1,  	army_walk2	] {army_idle(); ai_walk(1);};
void() army_walk2  	=[	$prowl_2,  	army_walk3 	] {ai_walk(1);};
void() army_walk3  	=[	$prowl_3,  	army_walk4 	] {ai_walk(1);};
void() army_walk4  	=[	$prowl_4,  	army_walk5 	] {ai_walk(1);};
void() army_walk5  	=[	$prowl_5,  	army_walk6 	] {ai_walk(2);};
void() army_walk6  	=[	$prowl_6,  	army_walk7 	] {ai_walk(3);};
void() army_walk7  	=[	$prowl_7,  	army_walk8 	] {ai_walk(4);};
void() army_walk8  	=[	$prowl_8,  	army_walk9 	] {ai_walk(4);};
void() army_walk9  	=[	$prowl_9,  	army_walk10	] {ai_walk(2);};
void() army_walk10 	=[	$prowl_10, 	army_walk11	] {ai_walk(2);};
void() army_walk11 	=[	$prowl_11, 	army_walk12	] {ai_walk(2);};
void() army_walk12 	=[	$prowl_12, 	army_walk13	] {ai_walk(1);};
void() army_walk13 	=[	$prowl_13, 	army_walk14	] {ai_walk(0);};
void() army_walk14 	=[	$prowl_14, 	army_walk15	] {ai_walk(1);};
void() army_walk15 	=[	$prowl_15, 	army_walk16	] {ai_walk(1);};
void() army_walk16 	=[	$prowl_16, 	army_walk17	] {ai_walk(1);};
void() army_walk17 	=[	$prowl_17, 	army_walk18	] {ai_walk(3);};
void() army_walk18 	=[	$prowl_18, 	army_walk19	] {ai_walk(3);};
void() army_walk19 	=[	$prowl_19, 	army_walk20	] {ai_walk(3);};
void() army_walk20 	=[	$prowl_20, 	army_walk21	] {ai_walk(3);};
void() army_walk21 	=[	$prowl_21, 	army_walk22	] {ai_walk(2);};
void() army_walk22 	=[	$prowl_22, 	army_walk23	] {ai_walk(1);};
void() army_walk23 	=[	$prowl_23, 	army_walk24	] {ai_walk(1);};
void() army_walk24 	=[	$prowl_24, 	army_walk1 	] {ai_walk(1);};


void() army_run1 	=[	$run1, 		army_run2	] {army_active(); ai_run(11);};
void() army_run2 	=[	$run2, 		army_run3	] {ai_run(15);};
void() army_run3 	=[	$run3, 		army_run4	] {ai_run(10);};
void() army_run4 	=[	$run4, 		army_run5	] {ai_run(10);};
void() army_run5 	=[	$run5, 		army_run6	] {ai_run(8);};
void() army_run6 	=[	$run6, 		army_run7	] {ai_run(15);};
void() army_run7 	=[	$run7, 		army_run8	] {ai_run(10);};
void() army_run8 	=[	$run8, 		army_run1	] {ai_run(8);};


void() army_atk1 	=[	$shoot1, 	army_atk2	] {ai_face();};
void() army_atk2 	=[	$shoot2, 	army_atk3	] {ai_face();};
void() army_atk3 	=[	$shoot3, 	army_atk4	] {ai_face();};
void() army_atk4 	=[	$shoot4, 	army_atk5	] {ai_face();};
void() army_atk5 	=[	$shoot5, 	army_atk6	] {ai_face(); army_fire();};
void() army_atk6 	=[	$shoot6,	army_atk7	] 
{
	local vector org, ang;

	ai_face();

//	ang = vectoangles(dir);
//	ejectcasing(shotorg + v_forward * -5, v_right * 100 + v_up * 40, 30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '0 250 0', 100, 1);

	makevectors(self.angles);

	org = self.origin -10*v_forward + 9*v_right + 9*v_up;
	ang = 80*v_right + 30*v_up;

	ejectcasing(org, ang, 30, '-1 0 0'*self.angles_x + '0 1 0'*self.angles_y, '30 -150 0', 80);
};
void() army_atk7 	=[	$shoot7, 	army_atk8	] {ai_face(); SUB_CheckRefire(army_atk1);};
void() army_atk8 	=[	$shoot8, 	army_atk9	] {ai_face();};
void() army_atk9 	=[	$shoot9, 	army_run1	] {ai_face();};


void() army_pain1 	=[	$pain1, 	army_pain2	] {};
void() army_pain2 	=[	$pain2, 	army_pain3	] {};
void() army_pain3 	=[	$pain3, 	army_pain4	] {};
void() army_pain4 	=[	$pain4, 	army_pain5	] {};
void() army_pain5 	=[	$pain5, 	army_pain6	] {};
void() army_pain6 	=[	$pain6, 	army_run1	] {ai_pain(1);};


void() army_painb1  	=[	$painb1,  	army_painb2 	] {};
void() army_painb2  	=[	$painb2,  	army_painb3 	] {ai_painforward(13);};
void() army_painb3  	=[	$painb3,  	army_painb4 	] {ai_painforward(9);};
void() army_painb4  	=[	$painb4,  	army_painb5 	] {};
void() army_painb5  	=[	$painb5,  	army_painb6 	] {};
void() army_painb6  	=[	$painb6,  	army_painb7 	] {};
void() army_painb7  	=[	$painb7,  	army_painb8 	] {};
void() army_painb8  	=[	$painb8,  	army_painb9 	] {};
void() army_painb9  	=[	$painb9,  	army_painb10	] {};
void() army_painb10 	=[	$painb10, 	army_painb11	] {};
void() army_painb11 	=[	$painb11, 	army_painb12	] {};
void() army_painb12 	=[	$painb12, 	army_painb13	] {ai_pain(2);};
void() army_painb13 	=[	$painb13, 	army_painb14	] {};
void() army_painb14 	=[	$painb14, 	army_run1   	] {};


void() army_painc1  	=[	$painc1,  	army_painc2 	] {};
void() army_painc2  	=[	$painc2,  	army_painc3 	] {ai_pain(1);};
void() army_painc3 	=[	$painc3,  	army_painc4 	] {};
void() army_painc4  	=[	$painc4,  	army_painc5 	] {};
void() army_painc5  	=[	$painc5,  	army_painc6 	] {ai_painforward(1);};
void() army_painc6  	=[	$painc6,  	army_painc7 	] {ai_painforward(1);};
void() army_painc7  	=[	$painc7,  	army_painc8 	] {};
void() army_painc8  	=[	$painc8,  	army_painc9 	] {ai_pain(1);};
void() army_painc9  	=[	$painc9,  	army_painc10	] {ai_painforward(4);};
void() army_painc10 	=[	$painc10, 	army_painc11	] {ai_painforward(3);};
void() army_painc11 	=[	$painc11, 	army_painc12	] {ai_painforward(6);};
void() army_painc12 	=[	$painc12, 	army_painc13	] {ai_painforward(8);};
void() army_painc13 	=[	$painc13, 	army_run1   	] {};


void() army_die1  	=[	$death1,  	army_die2 	] {body_solid('-16 -16 -24', '16 16 32');};
void() army_die2  	=[	$death2,  	army_die3 	] {body_solid('-16 -16 -24', '16 16 32');};
void() army_die3  	=[	$death3,  	army_die4 	] {body_solid('-16 -16 -24', '16 16 32');};
void() army_die4  	=[	$death4, 	army_die5 	] {body_solid('-16 -16 -24', '16 16 23');army_backpack();};
void() army_die5  	=[	$death5, 	army_die6 	] {body_nonsolid('-16 -16 -24', '16 16 10');};
void() army_die6  	=[	$death6, 	army_die7 	] {body_nonsolid('-16 -16 -24', '16 16 2');};
void() army_die7  	=[	$death7, 	army_die8 	] {body_nonsolid('-16 -16 -24', '16 16 -1');};
void() army_die8  	=[	$death8, 	army_die9 	] {body_nonsolid('-16 -16 -24', '16 16 -5');};
void() army_die9  	=[	$death9, 	army_die10	] {body_nonsolid('-16 -16 -24', '16 16 -12');};
void() army_die10 	=[	$death10, 	army_die10	] {body_nonsolid('-16 -16 -24', '16 16 -13');MonsterDead();};


void() army_cdie1  	=[	$deathc1, 	army_cdie2 	] {body_solid('-16 -16 -24', '16 16 32');};
void() army_cdie2  	=[	$deathc2, 	army_cdie3 	] {body_solid('-16 -16 -24', '16 16 30');ai_back(5);};
void() army_cdie3  	=[	$deathc3, 	army_cdie4 	] {body_solid('-16 -16 -24', '16 16 26');ai_back(4);};
void() army_cdie4  	=[	$deathc4, 	army_cdie5 	] {body_solid('-16 -16 -24', '16 16 23');ai_back(13);army_backpack();};
void() army_cdie5  	=[	$deathc5, 	army_cdie6 	] {body_nonsolid('-16 -16 -24', '16 16 12');ai_back(3);};
void() army_cdie6  	=[	$deathc6, 	army_cdie7 	] {body_nonsolid('-16 -16 -24', '16 16 9');ai_back(4);};
void() army_cdie7  	=[	$deathc7, 	army_cdie8 	] {body_nonsolid('-16 -16 -24', '16 16 -3');};
void() army_cdie8  	=[	$deathc8, 	army_cdie9 	] {body_nonsolid('-16 -16 -24', '16 16 -9');};
void() army_cdie9  	=[	$deathc9, 	army_cdie10	] {body_nonsolid('-16 -16 -24', '16 16 -11');};
void() army_cdie10 	=[	$deathc10, 	army_cdie11	] {body_nonsolid('-16 -16 -24', '16 16 -12');};
void() army_cdie11 	=[	$deathc11, 	army_cdie11	] {body_nonsolid('-16 -16 -24', '16 16 -13');MonsterDead();};

//=============================================================================

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() SoldierCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

//	if (trace_inopen && trace_inwater)
//		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot
			
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (self.enemy_range == RANGE_FAR)
		return FALSE;
		
	if (self.enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (self.enemy_range == RANGE_NEAR)
		chance = 0.4;
	else if (self.enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (1 + random());
		if (random() < 0.3)
			self.lefty = !self.lefty;

		return TRUE;
	}

	return FALSE;
};

void() army_fire =
{
	local	vector	dir;
	local	entity	en;

	self.effects = self.effects | EF_MUZZLEFLASH;	
	ai_face();
	
	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);	

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - self.origin);

//	org = self.origin + '0 0 12';
//	ang = vectoangles(dir);
//	ejectcasing (org, '0 0 0', 50, ang, '0 0 0', 150);

	FireBullets (4, dir, '0.1 0.1 0');
};


void(entity attacker, float damage) army_pain =
{
	local float r;
	
	if (self.pain_finished > time)
		return;

	MonsterBubbles(1,3);

	r = random();
	if (r < 0.4)
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);

	r = random();
	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		army_pain1 ();
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		army_painb1 ();
	}
	else
	{
		self.pain_finished = time + 1.1;
		army_painc1 ();
	}
};

void() army_sight =
{
	sound (self, CHAN_AUTO, "soldier/sight1.wav", 1, ATTN_NORM);
};

void() army_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
};

void() army_active =
{
	local float r;
	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
};

void() army_die =
{
	local float rnum;
	rnum = random();

	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);

	MonsterBubbles(15,30);

	if (rnum < 0.5)
		monster_corpse(army_die1);
	else
		monster_corpse(army_cdie1);
};


void() army_backpack =
{
	self.ammo_shells = 5;
	DropBackpack();
};


void() monster_army_precache =
{
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");
	precache_sound ("player/udeath.wav");		// gib death
};

void() monster_army_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');

	self.max_health = 30;
	self.corpsehealth = 50;	//50;
	self.gib = GIB_HUMANOID;
	self.headname = "progs/h_guard.mdl";
	self.gibhealth = -35;
	self.mass = 100;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_gib = monster_gib;
	self.th_sight = army_sight;

	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();
};

/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_army =
{	
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_army_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_army_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, '-16 -16 -24', '16 16 40');
		self.spawnfactory = monster_army_spawn;
	}
	else
	{
		monster_army_spawn();
		total_monsters = total_monsters + 1;
	}
};
