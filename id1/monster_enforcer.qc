/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/enforcer
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

void(vector org, vector vec) LaunchLaser;
void() Laser_Touch;
void() enforcer_fire;
void() enforcer_backpack;
void() enforcer_sight;
void() enforcer_idle;
void() enforcer_active;

void()	enf_stand1	=[	$stand1,	enf_stand2	] {enforcer_idle();ai_stand();};
void()	enf_stand2	=[	$stand2,	enf_stand3	] {ai_stand();};
void()	enf_stand3	=[	$stand3,	enf_stand4	] {ai_stand();};
void()	enf_stand4	=[	$stand4,	enf_stand5	] {ai_stand();};
void()	enf_stand5	=[	$stand5,	enf_stand6	] {ai_stand();};
void()	enf_stand6	=[	$stand6,	enf_stand7	] {ai_stand();};
void()	enf_stand7	=[	$stand7,	enf_stand1	] {ai_stand();};

void()	enf_walk1	=[	$walk1,		enf_walk2	] {enforcer_idle();ai_walk(2);};
void()	enf_walk2	=[	$walk2,		enf_walk3	] {ai_walk(4);};
void()	enf_walk3	=[	$walk3,		enf_walk4	] {ai_walk(4);};
void()	enf_walk4	=[	$walk4,		enf_walk5	] {ai_walk(3);};
void()	enf_walk5	=[	$walk5,		enf_walk6	] {ai_walk(1);};
void()	enf_walk6	=[	$walk6,		enf_walk7	] {ai_walk(2);};
void()	enf_walk7	=[	$walk7,		enf_walk8	] {ai_walk(2);};
void()	enf_walk8	=[	$walk8,		enf_walk9	] {ai_walk(1);};
void()	enf_walk9	=[	$walk9,		enf_walk10	] {ai_walk(2);};
void()	enf_walk10	=[	$walk10,	enf_walk11	] {ai_walk(4);};
void()	enf_walk11	=[	$walk11,	enf_walk12	] {ai_walk(4);};
void()	enf_walk12	=[	$walk12,	enf_walk13	] {ai_walk(1);};
void()	enf_walk13	=[	$walk13,	enf_walk14	] {ai_walk(2);};
void()	enf_walk14	=[	$walk14,	enf_walk15	] {ai_walk(3);};
void()	enf_walk15	=[	$walk15,	enf_walk16	] {ai_walk(4);};
void()	enf_walk16	=[	$walk16,	enf_walk1	] {ai_walk(2);};

void()	enf_run1	=[	$run1,		enf_run2	] {enforcer_active();ai_run(18);};
void()	enf_run2	=[	$run2,		enf_run3	] {ai_run(14);};
void()	enf_run3	=[	$run3,		enf_run4	] {ai_run(7);};
void()	enf_run4	=[	$run4,		enf_run5	] {ai_run(12);};
void()	enf_run5	=[	$run5,		enf_run6	] {ai_run(14);};
void()	enf_run6	=[	$run6,		enf_run7	] {ai_run(14);};
void()	enf_run7	=[	$run7,		enf_run8	] {ai_run(7);};
void()	enf_run8	=[	$run8,		enf_run1	] {ai_run(11);};

void()	enf_atk1	=[	$attack1,	enf_atk2	] {ai_face();};
void()	enf_atk2	=[	$attack2,	enf_atk3	] {ai_face();};
void()	enf_atk3	=[	$attack3,	enf_atk4	] {ai_face();};
void()	enf_atk4	=[	$attack4,	enf_atk5	] {ai_face();};
void()	enf_atk5	=[	$attack5,	enf_atk6	] {ai_face();};
void()	enf_atk6	=[	$attack6,	enf_atk7	] {enforcer_fire();};
void()	enf_atk7	=[	$attack7,	enf_atk8	] {ai_face();};
void()	enf_atk8	=[	$attack8,	enf_atk9	] {ai_face();};
void()	enf_atk9	=[	$attack5,	enf_atk10	] {ai_face();};
void()	enf_atk10	=[	$attack6,	enf_atk11	] {enforcer_fire();};
void()	enf_atk11	=[	$attack7,	enf_atk12	] {ai_face();};
void()	enf_atk12	=[	$attack8,	enf_atk13	] {ai_face();};
void()	enf_atk13	=[	$attack9,	enf_atk14	] {ai_face();};
void()	enf_atk14	=[	$attack10,	enf_run1	] {ai_face();SUB_CheckRefire(enf_atk1);};

void()	enf_paina1	=[	$paina1,	enf_paina2	] {};
void()	enf_paina2	=[	$paina2,	enf_paina3	] {};
void()	enf_paina3	=[	$paina3,	enf_paina4	] {};
void()	enf_paina4	=[	$paina4,	enf_run1	] {};

void()	enf_painb1	=[	$painb1,	enf_painb2	] {};
void()	enf_painb2	=[	$painb2,	enf_painb3	] {};
void()	enf_painb3	=[	$painb3,	enf_painb4	] {};
void()	enf_painb4	=[	$painb4,	enf_painb5	] {};
void()	enf_painb5	=[	$painb5,	enf_run1	] {};

void()	enf_painc1	=[	$painc1,	enf_painc2	] {};
void()	enf_painc2	=[	$painc2,	enf_painc3	] {};
void()	enf_painc3	=[	$painc3,	enf_painc4	] {};
void()	enf_painc4	=[	$painc4,	enf_painc5	] {};
void()	enf_painc5	=[	$painc5,	enf_painc6	] {};
void()	enf_painc6	=[	$painc6,	enf_painc7	] {};
void()	enf_painc7	=[	$painc7,	enf_painc8	] {};
void()	enf_painc8	=[	$painc8,	enf_run1	] {};

void()	enf_paind1	=[	$paind1,	enf_paind2	] {};
void()	enf_paind2	=[	$paind2,	enf_paind3	] {};
void()	enf_paind3	=[	$paind3,	enf_paind4	] {};
void()	enf_paind4	=[	$paind4,	enf_paind5	] {ai_painforward(2);};
void()	enf_paind5	=[	$paind5,	enf_paind6	] {ai_painforward(1);};
void()	enf_paind6	=[	$paind6,	enf_paind7	] {};
void()	enf_paind7	=[	$paind7,	enf_paind8	] {};
void()	enf_paind8	=[	$paind8,	enf_paind9	] {};
void()	enf_paind9	=[	$paind9,	enf_paind10	] {};
void()	enf_paind10	=[	$paind10,	enf_paind11	] {};
void()	enf_paind11	=[	$paind11,	enf_paind12	] {ai_painforward(1);};
void()	enf_paind12	=[	$paind12,	enf_paind13	] {ai_painforward(1);};
void()	enf_paind13	=[	$paind13,	enf_paind14	] {ai_painforward(1);};
void()	enf_paind14	=[	$paind14,	enf_paind15	] {};
void()	enf_paind15	=[	$paind15,	enf_paind16	] {};
void()	enf_paind16	=[	$paind16,	enf_paind17	] {ai_pain(1);};
void()	enf_paind17	=[	$paind17,	enf_paind18	] {ai_pain(1);};
void()	enf_paind18	=[	$paind18,	enf_paind19	] {};
void()	enf_paind19	=[	$paind19,	enf_run1	] {};

void()	enf_die1	=[	$death1,	enf_die2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	enf_die2	=[	$death2,	enf_die3	] {body_solid('-16 -16 -24', '16 16 23');};
void()	enf_die3	=[	$death3,	enf_die4	] {body_solid('-16 -16 -24', '16 16 22');enforcer_backpack();};
void()	enf_die4	=[	$death4,	enf_die5	] {body_solid('-16 -16 -24', '16 16 22');ai_forward(14);};
void()	enf_die5	=[	$death5,	enf_die6	] {body_solid('-16 -16 -24', '16 16 22');ai_forward(2);};
void()	enf_die6	=[	$death6,	enf_die7	] {body_solid('-16 -16 -24', '16 16 22');};
void()	enf_die7	=[	$death7,	enf_die8	] {body_solid('-16 -16 -24', '16 16 22');};
void()	enf_die8	=[	$death8,	enf_die9	] {body_solid('-16 -16 -24', '16 16 22');};
void()	enf_die9	=[	$death9,	enf_die10	] {body_solid('-16 -16 -24', '16 16 17');ai_forward(3);};
void()	enf_die10	=[	$death10,	enf_die11	] {body_nonsolid('-16 -16 -24', '16 16  7');ai_forward(5);};
void()	enf_die11	=[	$death11,	enf_die12	] {body_nonsolid('-16 -16 -24', '16 16 -2');ai_forward(5);};
void()	enf_die12	=[	$death12,	enf_die13	] {body_nonsolid('-16 -16 -24', '16 16 -2');ai_forward(5);};
void()	enf_die13	=[	$death13,	enf_die14	] {body_nonsolid('-16 -16 -24', '16 16 -3');};
void()	enf_die14	=[	$death14,	enf_die14	] {body_nonsolid('-16 -16 -24', '16 16 -10');MonsterDead();};

void()	enf_fdie1	=[	$fdeath1,	enf_fdie2	] {body_solid('-16 -16 -24', '16 16 24');};
void()	enf_fdie2	=[	$fdeath2,	enf_fdie3	] {body_solid('-16 -16 -24', '16 16 24');};
void()	enf_fdie3	=[	$fdeath3,	enf_fdie4	] {body_solid('-16 -16 -24', '16 16 24');enforcer_backpack();};
void()	enf_fdie4	=[	$fdeath4,	enf_fdie5	] {body_solid('-16 -16 -24', '16 16 20');};
void()	enf_fdie5	=[	$fdeath5,	enf_fdie6	] {body_solid('-16 -16 -24', '16 16 10');};
void()	enf_fdie6	=[	$fdeath6,	enf_fdie7	] {body_solid('-16 -16 -24', '16 16  3');};
void()	enf_fdie7	=[	$fdeath7,	enf_fdie8	] {body_solid('-16 -16 -24', '16 16 -2');};
void()	enf_fdie8	=[	$fdeath8,	enf_fdie9	] {body_nonsolid('-16 -16 -24', '16 16 -6');};
void()	enf_fdie9	=[	$fdeath9,	enf_fdie10	] {body_nonsolid('-16 -16 -24', '16 16 -8');};
void()	enf_fdie10	=[	$fdeath10,	enf_fdie11	] {body_nonsolid('-16 -16 -24', '16 16 -8');};
void()	enf_fdie11	=[	$fdeath11,	enf_fdie11	] {body_nonsolid('-16 -16 -24', '16 16 -10');MonsterDead();};

//=============================================================================

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() EnfCheckAttack =
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

//	if (self.enemy_range == RANGE_MELEE)
//	{	// melee attack
//		if (self.th_melee)
//		{
//			self.th_melee ();
//			return TRUE;
//		}
//	}
	
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

//============================================================================

void() enforcer_sight =
{
	local float rsnd;

	rsnd = rint(random()*3);
			
	if (rsnd == 1)
		sound (self, CHAN_AUTO, "enforcer/sight1.wav", 1, ATTN_NORM);
	else if (rsnd == 2)
		sound (self, CHAN_AUTO, "enforcer/sight2.wav", 1, ATTN_NORM);
	else if (rsnd == 0)
		sound (self, CHAN_AUTO, "enforcer/sight3.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_AUTO, "enforcer/sight4.wav", 1, ATTN_NORM);
};

void() enforcer_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();

	if (r < 0.2)
		sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
};

void() enforcer_active =
{
	local float r;
	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
};

void() enforcer_die =
{
	local float rnum;

	sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);

//	MonsterBubbles(15,30);		//breathing apparatus

	rnum = random();

	if (rnum < 0.5)
		monster_corpse(enf_die1);
	else
		monster_corpse(enf_fdie1);
};


void(entity attacker, float damage) enforcer_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

//	MonsterBubbles(1,3);		//breathing apparatus

	r = random ();

	if (r < 0.5)
		sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);

	r = random ();

	if (r < 0.2)
	{
		self.pain_finished = time + 1;
		enf_paina1 ();
	}
	else if (r < 0.4)
	{
		self.pain_finished = time + 1;
		enf_painb1 ();
	}
	else if (r < 0.7)
	{
		self.pain_finished = time + 1;
		enf_painc1 ();
	}
	else
	{
		self.pain_finished = time + 2;
		enf_paind1 ();
	}
};

//============================================================================

void() enforcer_muzzleflash =
{
	local entity o;
	self.nextthink = 1; // ASAP

	if (self.owner.health < 1)
	{
		remove(self);
		return;
	}

	o = self.owner;

	if (o.frame >= $attack5 && o.frame <= $attack7)
	{
		if (o.frame == $attack5) {
			self.glow_color = 239;
			self.glow_size = 20;
			self.view_ofs = '25.2 -9 15';
		} else if (o.frame == $attack6) {
			self.glow_color = 252;
			self.glow_size = 50;
			self.view_ofs = '26 -8.6 16';
		} else {
			self.glow_color = 237;
			self.glow_size = 20;
			self.view_ofs = '15 -9 9.5';
		}
	} else
	{
		self.glow_size = 0;
	}
};

void() enforcer_spawnmuzzleflash =
{
	if (self.health < 1)
		return;

	newmis = spawn();
	newmis.think = enforcer_muzzleflash;
	newmis.nextthink = 1; // ASAP
	newmis.aiment = newmis.owner = self;
	newmis.movetype = MOVETYPE_FOLLOW;
};

void() enforcer_fire =
{
	local vector org, ofs;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);
	
	ofs = v_forward * 27 + v_right * 8.5 + v_up * 15;	//'26 -8.6 16'		//8.5 + '0 0 16';	//30 12 10
	org = self.origin + ofs;

//	enforcer_spawnmuzzleflash('20 -10 9');
//	te_customflash(org, 50, 0.5, '1.0 0.95 0.58');

	LaunchLaser(org, self.enemy.origin - self.origin);
};


void() enforcer_backpack =
{
	self.ammo_cells = 5;
	DropBackpack();
};

//============================================================================

void() monster_enforcer_precache =
{
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
};
//============================================================================
void() monster_enforcer_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/enforcer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	self.max_health = 80;
	self.corpsehealth = 60;
	self.gib = GIB_HUMANOID;
	self.headname = "progs/h_mega.mdl";
	self.gibhealth = -35;
	self.mass = 120;
	self.flags = self.flags | FL_NOBREATH | FL_NOSLIMEDMG;

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enforcer_pain;
	self.th_die = enforcer_die;
	self.th_missile = enf_atk1;
	self.th_gib = monster_gib;
	self.th_sight = enforcer_sight;

	enforcer_spawnmuzzleflash();	

	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();
};

/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/
void() monster_enforcer =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}
	
	monster_enforcer_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_enforcer_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, '-16 -16 -24', '16 16 40');
		self.spawnfactory = monster_enforcer_spawn;
	}
	else
	{
		monster_enforcer_spawn();
		total_monsters = total_monsters + 1;
	}	
};
