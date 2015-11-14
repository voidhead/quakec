/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight
$origin 0 0 24
$base base
$skin badass3

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame run1 run2 run3 run4 run5 run6 run7 run8

//$frame runb1 runb2 runb3 runb4 runb5 runb6 runb7 runb8
//frame runc1 runc2 runc3 runc4 runc5 runc6

$frame runattack1 runattack2 runattack3 runattack4 runattack5 runattack6
$frame runattack7 runattack8 runattack9 runattack10 runattack11

$frame pain1 pain2 pain3

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9
$frame painb10 painb11

//frame attack1 attack2 attack3 attack4 attack5 attack6 attack7
//frame attack8 attack9 attack10 attack11

//$frame attackb1 attackb1 attackb2 attackb3 attackb4 attackb5
//$frame attackb6 attackb7 attackb8 attackb9 attackb10

$frame attackx1

$frame attackb1 attackb2 attackb3 attackb4 attackb5
$frame attackb6 attackb7 attackb8 attackb9 attackb10

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14

$frame kneel1 kneel2 kneel3 kneel4 kneel5

$frame standing1 standing2 standing3 standing4

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11


void() knight_idle;
void() knight_sight;
void() knight_active;
void() knight_swing;
void() knight_slice;
void() knight_melee;
void() knight_melee_side;


void()	knight_stand1	=[	$stand1,	knight_stand2	] {knight_idle();ai_stand();};
void()	knight_stand2	=[	$stand2,	knight_stand3	] {ai_stand();};
void()	knight_stand3	=[	$stand3,	knight_stand4	] {ai_stand();};
void()	knight_stand4	=[	$stand4,	knight_stand5	] {ai_stand();};
void()	knight_stand5	=[	$stand5,	knight_stand6	] {ai_stand();};
void()	knight_stand6	=[	$stand6,	knight_stand7	] {ai_stand();};
void()	knight_stand7	=[	$stand7,	knight_stand8	] {ai_stand();};
void()	knight_stand8	=[	$stand8,	knight_stand9	] {ai_stand();};
void()	knight_stand9	=[	$stand9,	knight_stand1	] {ai_stand();};


void()	knight_walk1	=[	$walk1,		knight_walk2	] {knight_idle();ai_walk(3);};
void()	knight_walk2	=[	$walk2,		knight_walk3	] {ai_walk(2);};
void()	knight_walk3	=[	$walk3,		knight_walk4	] {ai_walk(3);};
void()	knight_walk4	=[	$walk4,		knight_walk5	] {ai_walk(4);};
void()	knight_walk5	=[	$walk5,		knight_walk6	] {ai_walk(3);};
void()	knight_walk6	=[	$walk6,		knight_walk7	] {ai_walk(3);};
void()	knight_walk7	=[	$walk7,		knight_walk8	] {ai_walk(3);};
void()	knight_walk8	=[	$walk8,		knight_walk9	] {ai_walk(4);};
void()	knight_walk9	=[	$walk9,		knight_walk10	] {ai_walk(3);};
void()	knight_walk10	=[	$walk10,	knight_walk11	] {ai_walk(3);};
void()	knight_walk11	=[	$walk11,	knight_walk12	] {ai_walk(2);};
void()	knight_walk12	=[	$walk12,	knight_walk13	] {ai_walk(3);};
void()	knight_walk13	=[	$walk13,	knight_walk14	] {ai_walk(4);};
void()	knight_walk14	=[	$walk14,	knight_walk1	] {ai_walk(3);};


void()	knight_run1	=[	$run1,		knight_run2	] {knight_active();ai_run(16);};
void()	knight_run2	=[	$run2,		knight_run3	] {ai_run(20);};
void()	knight_run3	=[	$run3,		knight_run4	] {ai_run(13);};
void()	knight_run4	=[	$run4,		knight_run5	] {ai_run(7);};
void()	knight_run5	=[	$run5,		knight_run6	] {ai_run(16);};
void()	knight_run6	=[	$run6,		knight_run7	] {ai_run(20);};
void()	knight_run7	=[	$run7,		knight_run8	] {ai_run(14);};
void()	knight_run8	=[	$run8,		knight_run1	] {ai_run(6);};


void()	knight_runatk1	=[	$runattack1,	knight_runatk2	] {knight_swing();ai_charge(20);};
void()	knight_runatk2	=[	$runattack2,	knight_runatk3	] {ai_charge_side();};
void()	knight_runatk3	=[	$runattack3,	knight_runatk4	] {ai_charge_side();};
void()	knight_runatk4	=[	$runattack4,	knight_runatk5	] {ai_charge_side();};
void()	knight_runatk5	=[	$runattack5,	knight_runatk6	] {knight_melee_side();};		//knight_hit();ai_melee_side();
void()	knight_runatk6	=[	$runattack6,	knight_runatk7	] {knight_melee_side();};
void()	knight_runatk7	=[	$runattack7,	knight_runatk8	] {knight_melee_side();};
void()	knight_runatk8	=[	$runattack8,	knight_runatk9	] {knight_melee_side();};
void()	knight_runatk9	=[	$runattack9,	knight_runatk10	] {knight_melee_side();};
void()	knight_runatk10	=[	$runattack10,	knight_runatk11	] {ai_charge_side();};
void()	knight_runatk11	=[	$runattack11,	knight_run1	] {ai_charge(10);};


void()	knight_atk1	=[	$attackb1,	knight_atk2	] {ai_charge(0);};
void()	knight_atk2	=[	$attackb2,	knight_atk3	] {knight_swing();ai_charge(7);};
void()	knight_atk3	=[	$attackb3,	knight_atk4	] {ai_charge(4);};
void()	knight_atk4	=[	$attackb4,	knight_atk5	] {ai_charge(0);};
void()	knight_atk5	=[	$attackb5,	knight_atk6	] {ai_charge(3);};
void()	knight_atk6	=[	$attackb6,	knight_atk7	] {ai_charge(4);knight_melee();};	//knight_hit();ai_charge(4);ai_melee();
void()	knight_atk7	=[	$attackb7,	knight_atk8	] {ai_charge(1);knight_melee();};
void()	knight_atk8	=[	$attackb8,	knight_atk9	] {ai_charge(3);knight_melee();};
void()	knight_atk9	=[	$attackb9,	knight_atk10	] {ai_charge(1);};
void()	knight_atk10	=[	$attackb10,	knight_run1	] {ai_charge(5);};
//void()	knight_atk9	=[	$attack9,	knight_atk10	] {};
//void()	knight_atk10	=[	$attack10,	knight_atk11	] {};
//void()	knight_atk11	=[	$attack11,	knight_run1	] {};

//===========================================================================

void()	knight_bow1	=[	$kneel1,	knight_bow2	] {ai_turn();};
void()	knight_bow2	=[	$kneel2,	knight_bow3	] {ai_turn();};
void()	knight_bow3	=[	$kneel3,	knight_bow4	] {ai_turn();};
void()	knight_bow4	=[	$kneel4,	knight_bow5	] {ai_turn();};
void()	knight_bow5	=[	$kneel5,	knight_bow5	] {ai_turn();};
void()	knight_bow6	=[	$kneel4,	knight_bow7	] {ai_turn();};
void()	knight_bow7	=[	$kneel3,	knight_bow8	] {ai_turn();};
void()	knight_bow8	=[	$kneel2,	knight_bow9	] {ai_turn();};
void()	knight_bow9	=[	$kneel1,	knight_bow10	] {ai_turn();};
void()	knight_bow10	=[	$walk1,		knight_walk1	] {ai_turn();};


void()	knight_pain1	=[	$pain1,		knight_pain2	] {};
void()	knight_pain2	=[	$pain2,		knight_pain3	] {};
void()	knight_pain3	=[	$pain3,		knight_run1	] {};


void()	knight_painb1	=[	$painb1,	knight_painb2	] {ai_painforward(0);};
void()	knight_painb2	=[	$painb2,	knight_painb3	] {ai_painforward(3);};
void()	knight_painb3	=[	$painb3,	knight_painb4	] {};
void()	knight_painb4	=[	$painb4,	knight_painb5	] {};
void()	knight_painb5	=[	$painb5,	knight_painb6	] {ai_painforward(2);};
void()	knight_painb6	=[	$painb6,	knight_painb7	] {ai_painforward(4);};
void()	knight_painb7	=[	$painb7,	knight_painb8	] {ai_painforward(2);};
void()	knight_painb8	=[	$painb8,	knight_painb9	] {ai_painforward(5);};
void()	knight_painb9	=[	$painb9,	knight_painb10	] {ai_painforward(5);};
void()	knight_painb10	=[	$painb10,	knight_painb11	] {ai_painforward(0);};
void()	knight_painb11	=[	$painb11,	knight_run1	] {};


void()	knight_die1	=[	$death1,	knight_die2	] {body_solid('-16 -16 -24', '16 16  24');};
void()	knight_die2	=[	$death2,	knight_die3	] {body_solid('-16 -16 -24', '16 16  19');};
void()	knight_die3	=[	$death3,	knight_die4	] {body_solid('-16 -16 -24', '16 16  13');};
void()	knight_die4	=[	$death4,	knight_die5	] {body_solid('-16 -16 -24', '16 16   7');};
void()	knight_die5	=[	$death5,	knight_die6	] {body_nonsolid('-16 -16 -24', '16 16   2');};
void()	knight_die6	=[	$death6,	knight_die7	] {body_nonsolid('-16 -16 -24', '16 16  -1');};
void()	knight_die7	=[	$death7,	knight_die8	] {body_nonsolid('-16 -16 -24', '16 16  -5');};
void()	knight_die8	=[	$death8,	knight_die9	] {body_nonsolid('-16 -16 -24', '16 16  -9');};
void()	knight_die9	=[	$death9,	knight_die10	] {body_nonsolid('-16 -16 -24', '16 16 -10');};
void()	knight_die10	=[	$death10,	knight_die10	] {body_nonsolid('-16 -16 -24', '16 16 -12');MonsterDead();};


void()	knight_dieb1	=[	$deathb1,	knight_dieb2	] {body_solid('-16 -16 -24', '16 16  24');};
void()	knight_dieb2	=[	$deathb2,	knight_dieb3	] {body_solid('-16 -16 -24', '16 16  24');};
void()	knight_dieb3	=[	$deathb3,	knight_dieb4	] {body_solid('-16 -16 -24', '16 16  17');};
void()	knight_dieb4	=[	$deathb4,	knight_dieb5	] {body_solid('-16 -16 -24', '16 16  17');};
void()	knight_dieb5	=[	$deathb5,	knight_dieb6	] {body_solid('-16 -16 -24', '16 16  16');};
void()	knight_dieb6	=[	$deathb6,	knight_dieb7	] {body_nonsolid('-16 -16 -24', '16 16  13');};
void()	knight_dieb7	=[	$deathb7,	knight_dieb8	] {body_nonsolid('-16 -16 -24', '16 16  10');};
void()	knight_dieb8	=[	$deathb8,	knight_dieb9	] {body_nonsolid('-16 -16 -24', '16 16  -3');};
void()	knight_dieb9	=[	$deathb9,	knight_dieb10	] {body_nonsolid('-16 -16 -24', '16 16  -7');};
void()	knight_dieb10	=[	$deathb10,	knight_dieb11	] {body_nonsolid('-16 -16 -24', '16 16 -10');};
void()	knight_dieb11	=[	$deathb11,	knight_dieb11	] {body_nonsolid('-16 -16 -24', '16 16 -14');MonsterDead();};

//===========================================================================

void() knight_attack =
{
	local float len;
	
// decide if now is a good swing time
	len = vlen(self.enemy.origin + self.enemy.view_ofs - (self.origin + self.view_ofs));
	
	if (len < 80)
		knight_atk1 ();
	else
		knight_runatk1 ();
};

void() knight_swing =
{
	local float r;

	r = random();
	if (r > 0.5)
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

void() knight_slice =
{
	local float r, t;

	t = getsoundtime(self, CHAN_WEAPON);
	if (t > 0)
	if (t < 0.5)
		return;

	r = random();
	if (r > 0.5)
		sound (self, CHAN_WEAPON, "knight/slice1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "knight/slice2.wav", 1, ATTN_NORM);
};

void() knight_melee  =
{
	if (ai_melee())
		knight_slice();	
};

void() knight_melee_side  =
{
	if (ai_melee_side())
		knight_slice();	
};

void(entity attacker, float damage) knight_pain =
{
	local float r;
	
	if (self.pain_finished > time)
		return;

	MonsterBubbles(1,3);

	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);	//stop sword sound
	sound (self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);

	r = random();
	if (r < 0.85)
		knight_pain1 ();
	else
		knight_painb1 ();

	self.pain_finished = time + 1;	
};

void() knight_sight =
{
	sound (self, CHAN_AUTO, "knight/ksight.wav", 1, ATTN_NORM);
};

void() knight_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
};

void() knight_active =
{
	local float r;
	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
};

void() knight_die =
{
	local float rnum;

	rnum = random();

	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);	//stop sword sound
	sound (self, CHAN_VOICE, "knight/kdeath.wav", 1, ATTN_NORM);

	MonsterBubbles(15,30);

	if (rnum < 0.5)
		monster_corpse(knight_die1);
	else
		monster_corpse(knight_dieb1);
};

//===========================================================================

void() monster_knight_precache =
{
	precache_model ("progs/knight.mdl");
	precache_model ("progs/h_knight.mdl");

	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/idle.wav");

	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/slice1.wav");
	precache_sound ("knight/slice2.wav");

	precache_sound ("misc/null.wav");
};

void() monster_knight_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/knight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	self.max_health = 75;
	self.corpsehealth = 80;
	self.gib = GIB_HUMANOID;
	self.headname = "progs/h_knight.mdl";
	self.gibhealth = -40;
	self.mass = 120;

	self.th_stand = knight_stand1;
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_pain = knight_pain;
	self.th_die = knight_die;
	self.th_gib = monster_gib;
	self.th_sight = knight_sight;
	
	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();	
};

/*QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_knight =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_knight_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_knight_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, '-16 -16 -24', '16 16 40');
		self.spawnfactory = monster_knight_spawn;
	}
	else
	{
		monster_knight_spawn();
		total_monsters = total_monsters + 1;
	}
};
