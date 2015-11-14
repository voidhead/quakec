/*
==============================================================================

DOG

==============================================================================
*/
$cd id1/models/dog
$origin 0 0 24
$base base
$skin skin

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8


void() dog_idle;
void() dog_sight;
void() dog_active;
void() dog_bite;
void() Dog_JumpTouch;
float() Dog_CheckBottom;
void() Dog_JumpCheckGround;
void() Dog_Leap;


void() dog_stand1	=[	$stand1,	dog_stand2	] {dog_idle(); ai_stand();};
void() dog_stand2	=[	$stand2,	dog_stand3	] {ai_stand();};
void() dog_stand3	=[	$stand3,	dog_stand4	] {ai_stand();};
void() dog_stand4	=[	$stand4,	dog_stand5	] {ai_stand();};
void() dog_stand5	=[	$stand5,	dog_stand6	] {ai_stand();};
void() dog_stand6	=[	$stand6,	dog_stand7	] {ai_stand();};
void() dog_stand7	=[	$stand7,	dog_stand8	] {ai_stand();};
void() dog_stand8	=[	$stand8,	dog_stand9	] {ai_stand();};
void() dog_stand9	=[	$stand9,	dog_stand1	] {ai_stand();};


void() dog_walk1	=[	$walk1,		dog_walk2	] {dog_idle(); ai_walk(8);};
void() dog_walk2	=[	$walk2,		dog_walk3	] {ai_walk(8);};
void() dog_walk3	=[	$walk3,		dog_walk4	] {ai_walk(8);};
void() dog_walk4	=[	$walk4,		dog_walk5	] {ai_walk(8);};
void() dog_walk5	=[	$walk5,		dog_walk6	] {ai_walk(8);};
void() dog_walk6	=[	$walk6,		dog_walk7	] {ai_walk(8);};
void() dog_walk7	=[	$walk7,		dog_walk8	] {ai_walk(8);};
void() dog_walk8	=[	$walk8,		dog_walk1	] {ai_walk(8);};


void() dog_run1		=[	$run1,		dog_run2	] {dog_active(); ai_run(16);};
void() dog_run2		=[	$run2,		dog_run3	] {ai_run(32);};
void() dog_run3		=[	$run3,		dog_run4	] {ai_run(32);};
void() dog_run4		=[	$run4,		dog_run5	] {ai_run(20);};
void() dog_run5		=[	$run5,		dog_run6	] {ai_run(64);};
void() dog_run6		=[	$run6,		dog_run7	] {ai_run(32);};
void() dog_run7		=[	$run7,		dog_run8	] {ai_run(16);};
void() dog_run8		=[	$run8,		dog_run9	] {ai_run(32);};
void() dog_run9		=[	$run9,		dog_run10	] {ai_run(32);};
void() dog_run10	=[	$run10,		dog_run11	] {ai_run(20);};
void() dog_run11	=[	$run11,		dog_run12	] {ai_run(64);};
void() dog_run12	=[	$run12,		dog_run1	] {ai_run(32);};


void() dog_atta1	=[	$attack1,	dog_atta2	] {ai_charge(10);};
void() dog_atta2	=[	$attack2,	dog_atta3	] {ai_charge(10);};
void() dog_atta3	=[	$attack3,	dog_atta4	] {ai_charge(10);};
void() dog_atta4	=[	$attack4,	dog_atta5	] {dog_bite();};
void() dog_atta5	=[	$attack5,	dog_atta6	] {ai_charge(10);};
void() dog_atta6	=[	$attack6,	dog_atta7	] {ai_charge(10);};
void() dog_atta7	=[	$attack7,	dog_atta8	] {ai_charge(10);};
void() dog_atta8	=[	$attack8,	dog_run1	] {ai_charge(10);};


void() dog_leap1	=[	$leap1,		dog_leap2	] {ai_face();};
void() dog_leap2	=[	$leap2,		dog_leap3	] {Dog_Leap();};
void() dog_leap3	=[	$leap3,		dog_leap4	] {Dog_JumpCheckGround();};
void() dog_leap4	=[	$leap4,		dog_leap5	] {Dog_JumpCheckGround();};
void() dog_leap5	=[	$leap5,		dog_leap5	] {Dog_JumpCheckGround();};
void() dog_leap6	=[	$leap6,		dog_leap7	] {};
void() dog_leap7	=[	$leap7,		dog_leap8	] {};
void() dog_leap8	=[	$leap8,		dog_leap9	] {};
void() dog_leap9	=[	$leap9,		dog_run1	] {};


void() dog_pain1	=[	$pain1,		dog_pain2	] {};
void() dog_pain2	=[	$pain2,		dog_pain3	] {};
void() dog_pain3	=[	$pain3,		dog_pain4	] {};
void() dog_pain4	=[	$pain4,		dog_pain5	] {};
void() dog_pain5	=[	$pain5,		dog_pain6	] {};
void() dog_pain6	=[	$pain6,		dog_run1	] {};


void() dog_painb1	=[	$painb1,	dog_painb2	] {};
void() dog_painb2	=[	$painb2,	dog_painb3	] {};
void() dog_painb3	=[	$painb3,	dog_painb4	] {ai_pain(4);};
void() dog_painb4	=[	$painb4,	dog_painb5	] {ai_pain(12);};
void() dog_painb5	=[	$painb5,	dog_painb6	] {ai_pain(12);};
void() dog_painb6	=[	$painb6,	dog_painb7	] {ai_pain(2);};
void() dog_painb7	=[	$painb7,	dog_painb8	] {};
void() dog_painb8	=[	$painb8,	dog_painb9	] {ai_pain(4);};
void() dog_painb9	=[	$painb9,	dog_painb10	] {};
void() dog_painb10	=[	$painb10,	dog_painb11	] {ai_pain(10);};
void() dog_painb11	=[	$painb11,	dog_painb12	] {};
void() dog_painb12	=[	$painb12,	dog_painb13	] {};
void() dog_painb13	=[	$painb13,	dog_painb14	] {};
void() dog_painb14	=[	$painb14,	dog_painb15	] {};
void() dog_painb15	=[	$painb15,	dog_painb16	] {};
void() dog_painb16	=[	$painb16,	dog_run1	] {};


void() dog_die1		=[	$death1,	dog_die2	] {body_solid('-16 -16 -24', '16 16 12');};
void() dog_die2		=[	$death2,	dog_die3	] {body_solid('-16 -16 -24', '16 16 12');};
void() dog_die3		=[	$death3,	dog_die4	] {body_solid('-16 -16 -24', '16 16 12');};
void() dog_die4		=[	$death4,	dog_die5	] {body_solid('-16 -16 -24', '16 16  9');};
void() dog_die5		=[	$death5,	dog_die6	] {body_solid('-16 -16 -24', '16 16  6');};
void() dog_die6		=[	$death6,	dog_die7	] {body_nonsolid('-16 -16 -24', '16 16 -1');};
void() dog_die7		=[	$death7,	dog_die8	] {body_nonsolid('-16 -16 -24', '16 16 -6');};
void() dog_die8		=[	$death8,	dog_die9	] {body_nonsolid('-16 -16 -24', '16 16 -6');};
void() dog_die9		=[	$death9,	dog_die9	] {body_nonsolid('-16 -16 -24', '16 16 -8');MonsterDead();};


void() dog_dieb1	=[	$deathb1,	dog_dieb2	] {body_solid('-16 -16 -24', '16 16 12');};
void() dog_dieb2	=[	$deathb2,	dog_dieb3	] {body_solid('-16 -16 -24', '16 16 12');};
void() dog_dieb3	=[	$deathb3,	dog_dieb4	] {body_solid('-16 -16 -24', '16 16 12');};
void() dog_dieb4	=[	$deathb4,	dog_dieb5	] {body_solid('-16 -16 -24', '16 16 11');};
void() dog_dieb5	=[	$deathb5,	dog_dieb6	] {body_solid('-16 -16 -24', '16 16  3');};
void() dog_dieb6	=[	$deathb6,	dog_dieb7	] {body_nonsolid('-16 -16 -24', '16 16 -3');};
void() dog_dieb7	=[	$deathb7,	dog_dieb8	] {body_nonsolid('-16 -16 -24', '16 16 -7');};
void() dog_dieb8	=[	$deathb8,	dog_dieb9	] {body_nonsolid('-16 -16 -24', '16 16 -9');};
void() dog_dieb9	=[	$deathb9,	dog_dieb9	] {body_nonsolid('-16 -16 -24', '16 16 -9');MonsterDead();};

/*
================
dog_bite

================
*/
void() dog_bite =
{
	local 	vector	delta;
	local 	float 	ldmg, rnum1, rnum2, rnum3;

	sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);

	if (!self.enemy)
		return;

	ai_charge(10);

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	rnum1 = random();
	rnum2 = random();
	rnum3 = random();
	ldmg = (rnum1 + rnum2 + rnum3)*8;
	T_Damage (self.enemy, self, self, ldmg, "");

	traceline (self.origin, self.enemy.origin, MOVE_NORMAL, self);
	SpawnBlood (trace_ent, trace_endpos, ldmg*'0 0 1', ldmg);
};


float() Dog_CheckBottom =
{
	tracebox(self.origin, self.mins, self.maxs, self.origin + '0 0 -2', FALSE, self);

	if (trace_fraction == 1)
		return FALSE;
	else
		return TRUE;
};

void() Dog_JumpCheckGround =
{
	if (!Dog_CheckBottom())
		return;

	self.touch = SUB_Null;

	if (self.flags & FL_CORPSE)
		return;

	setsize (self, '-32 -32 -24', '32 32 25');
	self.think = dog_leap6;
	self.nextthink = time + 0.01;
};

void() Dog_Leap =
{
	ai_face();

	// check if there is room for a jump
	tracebox(self.origin, '-32 -32 -24', '32 32 36', self.origin + '0 0 1', FALSE, self);

	if (trace_fraction != 1)	// abort jump and run around for a while
	{
		self.think = dog_leap6;
		self.nextthink = time + 0.01;
		self.attack_finished = time + 1;
		return;
	}
	
	self.touch = Dog_JumpTouch;
	setorigin(self, self.origin + '0 0 1');
	setsize (self, '-32 -32 -16', '32 32 32');

	makevectors (self.angles);
	self.velocity = v_forward*300 + '0 0 200';

	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void()	Dog_JumpTouch =
{
	local	float	ldmg, rnum, vel, ang, angtarg, angdelta;
	local	vector	targdir;
		
	if (other.takedamage)
	{
		targdir = normalize(other.origin - self.origin);
		angtarg = '0 1 0'*vectoangles(targdir);
		ang = anglemod(self.angles_y);
		angdelta = fabs(angtarg - ang);

		vel = vlen(self.velocity);

		if (vel > 300)
		if (angdelta < 60)
		{
			if (self.flags & FL_CORPSE)
			{
				ldmg = 5 + 5*rnum;
				sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
				T_Damage (other, self, self, ldmg, "");	
			}
			else
			{
				ldmg = 10 + 10*rnum;
				traceline (self.origin, other.origin, MOVE_NORMAL, self);
				SpawnBlood (trace_ent, trace_endpos, ldmg*'0 0 1', ldmg);
				T_Damage (other, self, self, ldmg, "");	
			}

		}
	}

	if (self.flags & FL_CORPSE)
	{
		self.touch = SUB_Null;
		return;
	}

	if (!Dog_CheckBottom() || (other.absmax_z < self.absmin_z + 2 && other.solid == SOLID_SLIDEBOX))
	{
		if (self.flags & FL_ONGROUND || (other.absmax_z < self.absmin_z + 2 && other.solid == SOLID_SLIDEBOX))
		{	// jump randomly to not get hung up
//			dprint ("popjump\n");
			setsize (self, '-32 -32 -24', '32 32 25');
			self.touch = SUB_Null;
			self.think = dog_leap1;
			self.nextthink = time + 0.01;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}

		return;	// not on ground yet
	}

	setsize (self, '-32 -32 -24', '32 32 25');
	self.touch = SUB_Null;
	self.think = dog_leap6;
	self.nextthink = time + 0.01;
};


/*
==============
CheckDogMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckDogMelee =
{
	if (self.enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
//		self.attack_finished = 0;
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDogJump

==============
*/
float()	CheckDogJump =
{
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75*self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25*self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 80)
		return FALSE;
		
	if (d > 150)
		return FALSE;
		
	return TRUE;
};

float()	DogCheckAttack =
{
//	local	vector	vec;
	
// if close enough for slashing, go for it
	if (CheckDogMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDogJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};


//===========================================================================

void() dog_sight =
{
	sound (self, CHAN_AUTO, "dog/dsight.wav", 1, ATTN_NORM);
};

void() dog_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
};

void() dog_active =
{
	local float r;
	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
};

void() dog_die =
{
	local float rnum;
	rnum = random();

	sound (self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM);

	MonsterBubbles(10,20);

	if (rnum > 0.5)
		monster_corpse(dog_die1);
	else
		monster_corpse(dog_dieb1);
};

void() dog_pain =
{
	local float rnum;

	if (self.health < 1)
		return;

	if (self.pain_finished > time)
		return;

	MonsterBubbles(1,2);

	sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);

	rnum = random();
	if (rnum > 0.5)
		dog_pain1();
	else
		dog_painb1();

	self.pain_finished = time + 1;
};

//===========================================================================

void() monster_dog_precache =
{
	precache_model ("progs/h_dog.mdl");
	precache_model ("progs/dog.mdl");

	precache_sound ("dog/dattack1.wav");
	precache_sound ("dog/ddeath.wav");
	precache_sound ("dog/dpain1.wav");
	precache_sound ("dog/dsight.wav");
	precache_sound ("dog/idle.wav");

	precache_sound ("zombie/z_hit.wav");
};

void() monster_dog_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/dog.mdl");

//	setsize (self, '-32 -32 -24', '32 32 40');
	setsize (self, '-32 -32 -24', '32 32 25');

	self.max_health = 25;
	self.corpsehealth = 40;
	self.gib = GIB_SMALL;
	self.headname = "progs/h_dog.mdl";
	self.gibhealth = -35;
	self.mass = 70;

	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;
	self.th_gib = monster_gib;
	self.th_sight = dog_sight;

	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();
	
};

/*QUAKED monster_dog (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void() monster_dog =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}
	
	monster_dog_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_dog_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, '-32 -32 -24', '32 32 25');
		self.spawnfactory = monster_dog_spawn;
	}
	else
	{
		monster_dog_spawn();
		total_monsters = total_monsters + 1;
	}
	
};
