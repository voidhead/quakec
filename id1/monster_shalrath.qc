/*
==============================================================================

SHAL-RATH

==============================================================================
*/
$cd id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5 

$frame death1 death2 death3 death4 death5 death6 death7

$frame	walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame	walk11 walk12

void() ShalMissile;
void() shal_idle;
void() shal_sight;
void() shal_active;


void() shal_stand	=[	$walk1,		shal_stand	] {if (random() < 0.1) shal_idle();ai_stand();};


void() shal_walk1	=[	$walk2,		shal_walk2	] {shal_idle();ai_walk(6);};
void() shal_walk2	=[	$walk3,		shal_walk3	] {ai_walk(4);};
void() shal_walk3	=[	$walk4,		shal_walk4	] {ai_walk(0);};
void() shal_walk4	=[	$walk5,		shal_walk5	] {ai_walk(0);};
void() shal_walk5	=[	$walk6,		shal_walk6	] {ai_walk(0);};
void() shal_walk6	=[	$walk7,		shal_walk7	] {ai_walk(0);};
void() shal_walk7	=[	$walk8,		shal_walk8	] {ai_walk(5);};
void() shal_walk8	=[	$walk9,		shal_walk9	] {ai_walk(6);};
void() shal_walk9	=[	$walk10,	shal_walk10	] {ai_walk(5);};
void() shal_walk10	=[	$walk11,	shal_walk11	] {ai_walk(0);};
void() shal_walk11	=[	$walk12,	shal_walk12	] {ai_walk(4);};
void() shal_walk12	=[	$walk1,		shal_walk1	] {ai_walk(5);};


void() shal_run1	=[	$walk2,		shal_run2	] {shal_active();ai_run(6);};
void() shal_run2	=[	$walk3,		shal_run3	] {ai_run(4);};
void() shal_run3	=[	$walk4,		shal_run4	] {ai_run(0);};
void() shal_run4	=[	$walk5,		shal_run5	] {ai_run(0);};
void() shal_run5	=[	$walk6,		shal_run6	] {ai_run(0);};
void() shal_run6	=[	$walk7,		shal_run7	] {ai_run(0);};
void() shal_run7	=[	$walk8,		shal_run8	] {ai_run(5);};
void() shal_run8	=[	$walk9,		shal_run9	] {ai_run(6);};
void() shal_run9	=[	$walk10,	shal_run10	] {ai_run(5);};
void() shal_run10	=[	$walk11,	shal_run11	] {ai_run(0);};
void() shal_run11	=[	$walk12,	shal_run12	] {ai_run(4);};
void() shal_run12	=[	$walk1,		shal_run1	] {ai_run(5);};


void() shal_attack1	=[	$attack1,	shal_attack2	]
{
	sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
	ai_face();
};
void() shal_attack2	=[	$attack2,	shal_attack3	] {ai_face();};
void() shal_attack3	=[	$attack3,	shal_attack4	] {ai_face();};
void() shal_attack4	=[	$attack4,	shal_attack5	] {ai_face();};
void() shal_attack5	=[	$attack5,	shal_attack6	] {ai_face();};
void() shal_attack6	=[	$attack6,	shal_attack7	] {ai_face();};
void() shal_attack7	=[	$attack7,	shal_attack8	] {ai_face();};
void() shal_attack8	=[	$attack8,	shal_attack9	] {ai_face();};
void() shal_attack9	=[	$attack9,	shal_attack10	] {ShalMissile();};
void() shal_attack10	=[	$attack10,	shal_attack11	] {ai_face();};
void() shal_attack11	=[	$attack11,	shal_run1	] {};


void() shal_pain1	=[	$pain1,		shal_pain2	] {};
void() shal_pain2	=[	$pain2,		shal_pain3	] {};
void() shal_pain3	=[	$pain3,		shal_pain4	] {};
void() shal_pain4	=[	$pain4,		shal_pain5	] {};
void() shal_pain5	=[	$pain5,		shal_run1	] {};


void() shal_death1	=[	$death1,	shal_death2	] {body_solid('-32 -32 -24', '32 32 32');};
void() shal_death2	=[	$death2,	shal_death3	] {body_solid('-32 -32 -24', '32 32 20');};
void() shal_death3	=[	$death3,	shal_death4	] {body_solid('-32 -32 -24', '32 32  6');};
void() shal_death4	=[	$death4,	shal_death5	] {body_solid('-32 -32 -24', '32 32 -1');};
void() shal_death5	=[	$death5,	shal_death6	] {body_nonsolid('-32 -32 -24', '32 32 -3');};
void() shal_death6	=[	$death6,	shal_death7	] {body_nonsolid('-32 -32 -24', '32 32 -4');};
void() shal_death7	=[	$death7,	shal_death7	] {body_nonsolid('-32 -32 -24', '32 32 -12');MonsterDead();};

//=============================================================================

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ShalCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float	chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
//	if (trace_inopen && trace_inwater)
//		return FALSE;			// sight line crossed contents

	if (self.enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{
			self.th_melee ();
			return TRUE;
		}
	}
	
// missile attack
	if (!self.th_missile)
		return FALSE;
		
	if (time < self.attack_finished)
		return FALSE;
		
	if (self.enemy_range == RANGE_FAR)
		return FALSE;
		
	if (self.enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (self.enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			chance = 0.2;
		else
			chance = 0.4;
	}
	else if (self.enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			chance = 0.05;
		else
			chance = 0.1;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (2*random());
		return TRUE;
	}

	return FALSE;
};

/*
================
ShalMissile
================
*/
void() ShalMissileTouch;
void() ShalHome;
void() ShalMissile =
{
	local	entity 	missile;
	local	vector	dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/v_spike.mdl");

	setsize (missile, '0 0 0', '0 0 0');		

	missile.classname = "vorespike";
	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = ShalHome;
	missile.enemy = self.enemy;
	missile.touch = ShalMissileTouch;
};


void() ShalHome =
{
	local	vector	dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';

	if (self.enemy.health < 1 || self.enemy.flags & FL_CORPSE)
	{
		self.nextthink = time + 5;
		self.think = SUB_Remove;
		return;
	}

	dir = normalize(vtemp - self.origin);

	if (skill == SKILL_NIGHTMARE)
		self.velocity = dir * 350;
	else
		self.velocity = dir * 250;

	self.nextthink = time + 0.2;
	self.think = ShalHome;	
};


void() ShalMissileTouch =
{
	local float damg;
//	local vector vel;

	if (other == self.owner)
		return;		// don't explode on owner

	damg = 40;

	if (other.classname == "monster_zombie")
		T_Damage (other, self, self, 110, "shal_missile");

	else if (other.health > 0)
	{
		if (other.classname == "monster_shambler")
			damg = damg*0.5;	// mostly immune

		T_Damage (other, self, self.owner, damg, "shal_missile");

		SpawnBlood_Expl(other, self.velocity, damg);
	}

	T_RadiusDamage (self, self.owner, 40, other, "shal_missile");

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	te_explosion(self.origin);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

//=================================================================

void() shal_sight =
{
	sound (self, CHAN_AUTO, "shalrath/sight.wav", 1, ATTN_NORM);
};

void() shal_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
};

void() shal_active =
{
	local float r;
	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
};

void() shal_pain =
{
	if (self.pain_finished > time)
		return;

	MonsterBubbles(1,3);
	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	self.pain_finished = time + 3;
	shal_pain1();
};


void() shal_die =
{
	sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
	MonsterBubbles(15,30);
	monster_corpse(shal_death1);
};


void() monster_shalrath_precache =
{
	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");
	
	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");
};

void() monster_shalrath_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	self.max_health = 400;
	self.corpsehealth = 150;
	self.gib = GIB_LARGE;
	self.headname = "progs/h_shal.mdl";
	self.gibhealth = -90;
	self.mass = 400;

	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shal_die;
	self.th_pain = shal_pain;
	self.th_missile = shal_attack1;
	self.th_gib = monster_gib;
	self.th_sight = shal_sight;

	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();	
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/
void() monster_shalrath =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}
	
	monster_shalrath_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_shalrath_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.spawnfactory = monster_shalrath_spawn;
	}
	else
	{
		monster_shalrath_spawn();
		total_monsters = total_monsters + 1;
	}
};
