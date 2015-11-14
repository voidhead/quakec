/*
==============================================================================

DEMON

==============================================================================
*/

$cd id1/models/demon3
$scale	0.8
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

//============================================================================

float() Demon_CheckBottom;
void() Demon_Jump;
void() Demon_JumpTouch;
void() Demon_JumpCheckGround;
void() demon1_idle;
void() demon1_active;
void() demon_swing;
void() demon1_jump11;


void()	demon1_stand1	=[	$stand1,	demon1_stand2	] {demon1_idle();ai_stand();};
void()	demon1_stand2	=[	$stand2,	demon1_stand3	] {ai_stand();};
void()	demon1_stand3	=[	$stand3,	demon1_stand4	] {ai_stand();};
void()	demon1_stand4	=[	$stand4,	demon1_stand5	] {ai_stand();};
void()	demon1_stand5	=[	$stand5,	demon1_stand6	] {ai_stand();};
void()	demon1_stand6	=[	$stand6,	demon1_stand7	] {ai_stand();};
void()	demon1_stand7	=[	$stand7,	demon1_stand8	] {ai_stand();};
void()	demon1_stand8	=[	$stand8,	demon1_stand9	] {ai_stand();};
void()	demon1_stand9	=[	$stand9,	demon1_stand10	] {ai_stand();};
void()	demon1_stand10	=[	$stand10,	demon1_stand11	] {ai_stand();};
void()	demon1_stand11	=[	$stand11,	demon1_stand12	] {ai_stand();};
void()	demon1_stand12	=[	$stand12,	demon1_stand13	] {ai_stand();};
void()	demon1_stand13	=[	$stand13,	demon1_stand1	] {ai_stand();};

void()	demon1_walk1	=[	$walk1,		demon1_walk2	] {demon1_idle();ai_walk(8);};
void()	demon1_walk2	=[	$walk2,		demon1_walk3	] {ai_walk(6);};
void()	demon1_walk3	=[	$walk3,		demon1_walk4	] {ai_walk(6);};
void()	demon1_walk4	=[	$walk4,		demon1_walk5	] {ai_walk(7);};
void()	demon1_walk5	=[	$walk5,		demon1_walk6	] {ai_walk(4);};
void()	demon1_walk6	=[	$walk6,		demon1_walk7	] {ai_walk(6);};
void()	demon1_walk7	=[	$walk7,		demon1_walk8	] {ai_walk(10);};
void()	demon1_walk8	=[	$walk8,		demon1_walk1	] {ai_walk(10);};

void()	demon1_run1	=[	$run1,		demon1_run2	] {demon1_active(); ai_run(20);};
void()	demon1_run2	=[	$run2,		demon1_run3	] {ai_run(15);};
void()	demon1_run3	=[	$run3,		demon1_run4	] {ai_run(36);};
void()	demon1_run4	=[	$run4,		demon1_run5	] {ai_run(20);};
void()	demon1_run5	=[	$run5,		demon1_run6	] {ai_run(15);};
void()	demon1_run6	=[	$run6,		demon1_run1	] {ai_run(36);};

void()	demon1_jump1	=[	$leap1,		demon1_jump2	] {ai_face();};
void()	demon1_jump2	=[	$leap2,		demon1_jump3	] {ai_face();};
void()	demon1_jump3	=[	$leap3,		demon1_jump4	] {ai_face();};
void()	demon1_jump4	=[	$leap4,		demon1_jump5	] {Demon_Jump();};

void()	demon1_jump5	=[	$leap5,		demon1_jump6	] {Demon_JumpCheckGround();};
void()	demon1_jump6	=[	$leap6,		demon1_jump7	] {Demon_JumpCheckGround();};
void()	demon1_jump7	=[	$leap7,		demon1_jump8	] {Demon_JumpCheckGround();};
void()	demon1_jump8	=[ 	$leap8,		demon1_jump9	] {Demon_JumpCheckGround();};
void()	demon1_jump9	=[ 	$leap9,		demon1_jump10	] {Demon_JumpCheckGround();};
void()	demon1_jump10	=[ 	$leap10,	demon1_jump10	] {Demon_JumpCheckGround();};
void()	demon1_jump11	=[ 	$leap11,	demon1_jump12	] {};
void()	demon1_jump12	=[ 	$leap12,	demon1_run1	] {};

void()	demon1_atta1	=[	$attacka1,	demon1_atta2	] {ai_charge(4);};
void()	demon1_atta2	=[	$attacka2,	demon1_atta3	] {ai_charge(0);};
void()	demon1_atta3	=[	$attacka3,	demon1_atta4	] {ai_charge(0);};
void()	demon1_atta4	=[	$attacka4,	demon1_atta5	] {ai_charge(1);};
void()	demon1_atta5	=[	$attacka5,	demon1_atta6	] {demon_swing();Demon_Melee(200);};	//ai_charge(2);
void()	demon1_atta6	=[	$attacka6,	demon1_atta7	] {ai_charge(1);};
void()	demon1_atta7	=[	$attacka7,	demon1_atta8	] {ai_charge(6);};
void()	demon1_atta8	=[	$attacka8,	demon1_atta9	] {ai_charge(8);};
void()	demon1_atta9	=[	$attacka9,	demon1_atta10	] {ai_charge(4);};
void()	demon1_atta10	=[	$attacka10,	demon1_atta11	] {ai_charge(2);};
void()	demon1_atta11	=[	$attacka11,	demon1_atta12	] {demon_swing();Demon_Melee(-200);};
void()	demon1_atta12	=[	$attacka12,	demon1_atta13	] {ai_charge(5);};
void()	demon1_atta13	=[	$attacka13,	demon1_atta14	] {ai_charge(8);};
void()	demon1_atta14	=[	$attacka14,	demon1_atta15	] {ai_charge(4);};
void()	demon1_atta15	=[	$attacka15,	demon1_run1	] {ai_charge(4);};

void()	demon1_pain1	=[	$pain1,		demon1_pain2	] {};
void()	demon1_pain2	=[	$pain2,		demon1_pain3	] {};
void()	demon1_pain3	=[	$pain3,		demon1_pain4	] {};
void()	demon1_pain4	=[	$pain4,		demon1_pain5	] {};
void()	demon1_pain5	=[	$pain5,		demon1_pain6	] {};
void()	demon1_pain6	=[	$pain6,		demon1_run1	] {};

void()	demon1_die1	=[	$death1,	demon1_die2	] {body_solid('-32 -32 -24', '32 32 24');};
void()	demon1_die2	=[	$death2,	demon1_die3	] {body_solid('-32 -32 -24', '32 32 24');};
void()	demon1_die3	=[	$death3,	demon1_die4	] {body_solid('-32 -32 -24', '32 32 24');};
void()	demon1_die4	=[	$death4,	demon1_die5	] {body_solid('-32 -32 -24', '32 32 21');};
void()	demon1_die5	=[	$death5,	demon1_die6	] {body_solid('-32 -32 -24', '32 32 10');};
void()	demon1_die6	=[	$death6,	demon1_die7	] {body_nonsolid('-32 -32 -24', '32 32  2');};
void()	demon1_die7	=[	$death7,	demon1_die8	] {body_nonsolid('-32 -32 -24', '32 32  0');};
void()	demon1_die8	=[	$death8,	demon1_die9	] {body_nonsolid('-32 -32 -24', '32 32 -4');};
void()	demon1_die9	=[	$death9,	demon1_die9	] {body_nonsolid('-32 -32 -24', '32 32 -12');MonsterDead();};

void() demon1_melee =
{
	demon1_atta1 ();
};

/*
==============
CheckDemonMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckDemonMelee =
{
	if (self.enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_finished = 0;
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

void() Demon_Jump =
{
	ai_face();

	// check if there is room for a jump
	tracebox(self.origin, '-32 -32 -24', '32 32 64', self.origin + '0 0 1', FALSE, self);

	if (trace_fraction != 1)	// abort jump and run around for a while
	{
		self.think = demon1_jump11;	//demon1_run1;
		self.nextthink = time + 0.01;
		self.attack_finished = time + 1;
		return;
	}

	self.touch = Demon_JumpTouch;
	setorigin(self, self.origin + '0 0 1');
	setsize(self, '-32 -32 -16', '32 32 56');

	makevectors (self.angles);
	self.velocity = v_forward*600 + '0 0 250';

	self.flags = self.flags - (self.flags & FL_ONGROUND);	
};

/*
==============
CheckDemonJump

==============
*/
float()	CheckDemonJump =
{
	local	vector	dist;
	local	float	d, rnum;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75*self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25*self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 100)
		return FALSE;
		
	if (d > 200)
	{
		rnum = random();
		if (rnum < 0.9)
			return FALSE;
	}
		
	return TRUE;
};


float()	DemonCheckAttack =
{
//	local	vector	vec;

	if (self.enemy.flags & FL_CORPSE)	
		return FALSE;

	if (self.attack_finished > time)
		return FALSE;

//	if (!self.enemy_vis)
//		return FALSE;

// if close enough for slashing, go for it
	if (CheckDemonMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDemonJump ())
	{
		self.attack_state = AS_MISSILE;
		sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);
		return TRUE;
	}
	
	return FALSE;
};


void(float side) Demon_Melee =
{
	local	float	ldmg, rnum;
	local 	vector	delta;
	
	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
	sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);

	rnum = random();
	ldmg = 10 + 5*rnum;
	T_Damage (self.enemy, self, self, ldmg, "");	

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side*v_right);

	rnum = random();
	if (rnum > 0.4)
		SpawnMeatSpray (self.origin + rnum*v_forward*16, rnum*side*v_right);
	if (rnum > 0.6)
		SpawnMeatSpray (self.origin + rnum*v_forward*16, rnum*side*v_right);

};

float() Demon_CheckBottom =
{
	tracebox(self.origin, self.mins, self.maxs, self.origin + '0 0 -2', FALSE, self);

	if (trace_fraction == 1)
		return FALSE;
	else
		return TRUE;
};

void() Demon_JumpCheckGround =
{
	if (!Demon_CheckBottom())
		return;

	self.touch = SUB_Null;

	if (self.flags & FL_CORPSE)
		return;

	setsize(self, '-32 -32 -24', '32 32 32');
	self.think = demon1_jump11;
	self.nextthink = time + 0.01;
};

void()	Demon_JumpTouch =
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

		if (vel > 400)
		if (angdelta < 80)
		{
			rnum = random();

			if (self.flags & FL_CORPSE)
			{
				ldmg = 20 + 10*rnum;
				sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
				T_Damage (other, self, self, ldmg, "");
			}
			else
			{
				ldmg = 40 + 10*rnum;
//				makevectors(self.angles);
//				SpawnBlood(self.origin + 16*v_forward, VEC_0, ldmg);

				traceline (self.origin, other.origin, MOVE_NORMAL, self);
//				SpawnBlood (trace_ent, trace_endpos, ldmg*'0 0 1', ldmg);

				te_bloodshower(trace_endpos + '-8 -8 -8', trace_endpos + '8 8 8', 128, ldmg*0.5);
				T_Damage (other, self, self, ldmg, "");	
			}
		}
	}

	if (self.flags & FL_CORPSE)
	{
		self.touch = SUB_Null;
		return;
	}

	if (!Demon_CheckBottom() || (other.absmax_z < self.absmin_z + 2 && other.solid == SOLID_SLIDEBOX))
	{
		if (self.flags & FL_ONGROUND || (other.absmax_z < self.absmin_z + 2 && other.solid == SOLID_SLIDEBOX))
		{	// jump randomly to not get hung up
//			print ("popjump\n");
			setsize(self, '-32 -32 -24', '32 32 32');
			self.touch = SUB_Null;
			self.think = demon1_jump1;
			self.nextthink = time + 0.01;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}

		return;	// not on ground yet
	}

	setsize(self, '-32 -32 -24', '32 32 32');
	self.touch = SUB_Null;
	self.think = demon1_jump11;
	self.nextthink = time + 0.01;
};

//===========================================================================

void() demon_swing =
{
	sound (self, CHAN_WEAPON, "demon/miss.wav", 0.7, ATTN_NORM);	
};

void() demon1_sight =
{
	sound (self, CHAN_AUTO, "demon/sight2.wav", 1, ATTN_NORM);
};

void() demon1_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
};

void() demon1_active =
{
	local float r;
	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
};

void(entity attacker, float damage) demon1_pain =
{
	local float rnum;

	if (self.health < 1)
		return;

	if (self.touch == Demon_JumpTouch)
		return;

	if (self.pain_finished > time)
		return;

	MonsterBubbles(1,5);
   	sound (self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM);
	self.pain_finished = time + 1;
	
	rnum = 200*random();
	if (rnum > damage)
		return;		// didn't flinch
		
	demon1_pain1 ();
};


void() demon1_die =
{
	sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
	MonsterBubbles(10,20);
	monster_corpse(demon1_die1);
};

void() monster_demon1_precache = 
{
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
	precache_sound ("demon/miss.wav");

	precache_sound ("zombie/z_hit.wav");
};

void() monster_demon1_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/demon.mdl");
	setsize (self, '-32 -32 -24', '32 32 32');

	self.max_health = 300;
	self.gibhealth = -80;
	self.corpsehealth = 150;
	self.gib = GIB_LARGE;
	self.headname = "progs/h_demon.mdl";
	self.mass = 400;

	self.th_stand = demon1_stand1;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon1_die;
	self.th_melee = demon1_melee;		// one of two attacks
	self.th_missile = demon1_jump1;		// jump attack
	self.th_pain = demon1_pain;
	self.th_gib = monster_gib;
	self.th_sight = demon1_sight;

	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();
};

/*QUAKED monster_demon1 (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_demon1 =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_demon1_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_demon1_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, '-32 -32 -24', '32 32 32');
		self.spawnfactory = monster_demon1_spawn;
	}
	else
	{
		monster_demon1_spawn();
		total_monsters = total_monsters + 1;
	}
};
