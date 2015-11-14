/*
==============================================================================

WIZARD

==============================================================================
*/

$cd id1/models/a_wizard
$origin 0 0 24
$base wizbase	
$skin wizbase

$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14

$frame magatt1 magatt2 magatt3 magatt4 magatt5 magatt6 magatt7
$frame magatt8 magatt9 magatt10 magatt11 magatt12 magatt13

$frame pain1 pain2 pain3 pain4

$frame death1 death2 death3 death4 death5 death6 death7 death8


void(entity missile, float mspeed, float accuracy) Wiz_LaunchMissile;
float()	WizCheckAttack;
void() Wiz_AttackFinished;
void() wiz_fastfire;
void() wiz_startfast;
void() wiz_idle;
void() wiz_active;


void()	wiz_stand1	=[	$hover1,	wiz_stand2	] {wiz_idle();ai_stand();};
void()	wiz_stand2	=[	$hover2,	wiz_stand3	] {ai_stand();};
void()	wiz_stand3	=[	$hover3,	wiz_stand4	] {ai_stand();};
void()	wiz_stand4	=[	$hover4,	wiz_stand5	] {ai_stand();};
void()	wiz_stand5	=[	$hover5,	wiz_stand6	] {ai_stand();};
void()	wiz_stand6	=[	$hover6,	wiz_stand7	] {ai_stand();};
void()	wiz_stand7	=[	$hover7,	wiz_stand8	] {ai_stand();};
void()	wiz_stand8	=[	$hover8,	wiz_stand1	] {ai_stand();};


void()	wiz_walk1	=[	$hover1,	wiz_walk2	] {wiz_idle();ai_walk(8);};
void()	wiz_walk2	=[	$hover2,	wiz_walk3	] {ai_walk(8);};
void()	wiz_walk3	=[	$hover3,	wiz_walk4	] {ai_walk(8);};
void()	wiz_walk4	=[	$hover4,	wiz_walk5	] {ai_walk(8);};
void()	wiz_walk5	=[	$hover5,	wiz_walk6	] {ai_walk(8);};
void()	wiz_walk6	=[	$hover6,	wiz_walk7	] {ai_walk(8);};
void()	wiz_walk7	=[	$hover7,	wiz_walk8	] {ai_walk(8);};
void()	wiz_walk8	=[	$hover8,	wiz_walk1	] {ai_walk(8);};


void()	wiz_side1	=[	$hover1,	wiz_side2	] {wiz_active();ai_run(8);};
void()	wiz_side2	=[	$hover2,	wiz_side3	] {ai_run(8);};
void()	wiz_side3	=[	$hover3,	wiz_side4	] {ai_run(8);};
void()	wiz_side4	=[	$hover4,	wiz_side5	] {ai_run(8);};
void()	wiz_side5	=[	$hover5,	wiz_side6	] {ai_run(8);};
void()	wiz_side6	=[	$hover6,	wiz_side7	] {ai_run(8);};
void()	wiz_side7	=[	$hover7,	wiz_side8	] {ai_run(8);};
void()	wiz_side8	=[	$hover8,	wiz_side1	] {ai_run(8);};


void()	wiz_run1	=[	$fly1,		wiz_run2	] {wiz_active();ai_run(16);};
void()	wiz_run2	=[	$fly2,		wiz_run3	] {ai_run(16);};
void()	wiz_run3	=[	$fly3,		wiz_run4	] {ai_run(16);};
void()	wiz_run4	=[	$fly4,		wiz_run5	] {ai_run(16);};
void()	wiz_run5	=[	$fly5,		wiz_run6	] {ai_run(16);};
void()	wiz_run6	=[	$fly6,		wiz_run7	] {ai_run(16);};
void()	wiz_run7	=[	$fly7,		wiz_run8	] {ai_run(16);};
void()	wiz_run8	=[	$fly8,		wiz_run9	] {ai_run(16);};
void()	wiz_run9	=[	$fly9,		wiz_run10	] {ai_run(16);};
void()	wiz_run10	=[	$fly10,		wiz_run11	] {ai_run(16);};
void()	wiz_run11	=[	$fly11,		wiz_run12	] {ai_run(16);};
void()	wiz_run12	=[	$fly12,		wiz_run13	] {ai_run(16);};
void()	wiz_run13	=[	$fly13,		wiz_run14	] {ai_run(16);};
void()	wiz_run14	=[	$fly14,		wiz_run1	] {ai_run(16);};


void()	wiz_fast1	=[	$magatt1,	wiz_fast2	] {ai_face();wiz_startfast();};
void()	wiz_fast2	=[	$magatt2,	wiz_fast3	] {ai_face();};
void()	wiz_fast3	=[	$magatt3,	wiz_fast4	] {ai_face();};
void()	wiz_fast4	=[	$magatt4,	wiz_fast5	] {ai_face();};
void()	wiz_fast5	=[	$magatt5,	wiz_fast6	] {ai_face();};
void()	wiz_fast6	=[	$magatt6,	wiz_fast7	] {ai_face();};
void()	wiz_fast7	=[	$magatt5,	wiz_fast8	] {ai_face();};
void()	wiz_fast8	=[	$magatt4,	wiz_fast9	] {ai_face();};
void()	wiz_fast9	=[	$magatt3,	wiz_fast10	] {ai_face();};
void()	wiz_fast10	=[	$magatt2,	wiz_run1	] {ai_face();SUB_AttackFinished(2);Wiz_AttackFinished();};


void()	wiz_pain1	=[	$pain1,		wiz_pain2	] {};
void()	wiz_pain2	=[	$pain2,		wiz_pain3	] {};
void()	wiz_pain3	=[	$pain3,		wiz_pain4	] {};
void()	wiz_pain4	=[	$pain4,		wiz_run1	] {};


void()	wiz_death1	=[	$death1,	wiz_death2	]
{
	body_solid('-16 -16 -24', '16 16 32');
	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 100 + 100*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};
void()	wiz_death2	=[	$death2,	wiz_death3	] {body_solid('-16 -16 -24', '16 16 32');};
void()	wiz_death3	=[	$death3,	wiz_death4	] {body_solid('-16 -16 -24', '16 16 32');};
void()	wiz_death4	=[	$death4,	wiz_death5	] {body_solid('-16 -16 -24', '16 16 21');};
void()	wiz_death5	=[	$death5,	wiz_death6	] {body_nonsolid('-16 -16 -24', '16 16  5');};
void()	wiz_death6	=[	$death6,	wiz_death7	] {body_nonsolid('-16 -16 -24', '16 16 -5');};
void()	wiz_death7	=[	$death7,	wiz_death8	] {body_nonsolid('-16 -16 -24', '16 16 -5');};
void()	wiz_death8	=[	$death8,	wiz_death8	] {body_nonsolid('-16 -16 -24', '16 16 -10');MonsterDead();};

/*
==============================================================================

WIZARD

If the player moves behind cover before the missile is launched, launch it
at the last visible spot with no velocity leading, in hopes that the player
will duck back out and catch it.
==============================================================================
*/

/*
=============
LaunchMissile

Sets the given entities velocity and angles so that it will hit self.enemy
if self.enemy maintains it's current velocity
0.1 is moderately accurate, 0.0 is totally accurate
=============
*/

void(entity missile, float mspeed, float accuracy) Wiz_LaunchMissile =
{
	local	vector	vec, move;
	local	float	fly, rnum1, rnum2;

	makevectors (self.angles);
		
// set missile speed
	vec = self.enemy.origin + self.enemy.mins + self.enemy.size * 0.7 - missile.origin;

// calc aproximate time for missile to reach vec
	fly = vlen (vec) / mspeed;
	
// get the entities xy velocity
	move = self.enemy.velocity;
	move_z = 0;

// project the target forward in time
	vec = vec + move * fly;
	
	vec = normalize(vec);

	rnum1 = random();
	rnum2 = random();
	vec = vec + accuracy*v_up*(rnum1 - 0.5) + accuracy*v_right*(rnum2 - 0.5);
	
	missile.velocity = vec * mspeed;

	missile.angles = '0 0 0';
	missile.angles_y = vectoyaw(missile.velocity);

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;	
};


/*
=================
WizardCheckAttack
=================
*/
float()	WizCheckAttack =
{
	local 	vector	spot1, spot2;	
	local 	entity	targ;
	local 	float	chance, rnum;

	if (time < self.attack_finished)
		return FALSE;

	if (!self.enemy_vis)
		return FALSE;

	if (self.enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_run1 ();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_run1 ();
		}
		return FALSE;
	}
			
	if (self.enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (self.enemy_range == RANGE_NEAR)
		chance = 0.6;
	else if (self.enemy_range == RANGE_MID)
		chance = 0.2;
	else
		chance = 0;

	rnum = random();
	if (rnum < chance)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (self.enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_run1 ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			wiz_side1 ();
		}
	}
	
	return FALSE;
};


/*
=================
WizardAttackFinished
=================
*/
void()	Wiz_AttackFinished =
{
	if ((self.enemy_range >= RANGE_MID) || (!self.enemy_vis))
	{
		self.attack_state = AS_STRAIGHT;
		self.think = wiz_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = wiz_side1;
	}
};

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

void() wiz_fastfire =
{
	local	vector	vec;
	local	vector	dst;

	if (!(self.owner.flags & FL_CORPSE))
	if (self.owner.health > 0)
	{
//		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;

		makevectors (self.enemy.angles);	
		dst = self.enemy.origin - 13*self.movedir;
	
		vec = normalize(dst - self.origin);
		sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
		launch_spike (self.origin, vec);
		newmis.classname = "wizspike";
		newmis.velocity = vec*600;
		newmis.owner = self.owner;
		setmodel (newmis, "progs/w_spike.mdl");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	}

	remove (self);
};


void() wiz_startfast =
{
	local	entity	missile;
	
	if (self.health < 1)
		return;

	sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors (self.angles);

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right*14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	missile.think = wiz_fastfire;
	missile.movedir = v_right;

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 1;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right* -14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.3;
	missile.think = wiz_fastfire;
	missile.movedir = VEC_ORIGIN - v_right;
};


void() wiz_missile =
{
	wiz_fast1();
};


//==============================================================================

void() wiz_sight =
{
	sound (self, CHAN_AUTO, "wizard/wsight.wav", 1, ATTN_NORM);
};

void() wiz_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	if (self.waitmin < time)
	{
	 	self.waitmin = time + 2;
		r = random();
	 	if (r > 0.9) 
	 		sound (self, CHAN_VOICE, "wizard/widle1.wav", 1,  ATTN_IDLE);
	 	if (r < 0.3)
	 		sound (self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE);
	}
};

void() wiz_active =
{
	local float r;
	r = random();
 	if (r > 0.9) 
 		sound (self, CHAN_VOICE, "wizard/widle1.wav", 1,  ATTN_IDLE);
 	if (r < 0.3)
 		sound (self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE);
};

void() wiz_die =
{
	sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
	MonsterBubbles(15,30);
	monster_corpse(wiz_death1);
};

void(entity attacker, float damage) wiz_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

	MonsterBubbles(1,3);
	sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
	self.pain_finished = time + 1;

	r = 70*random();

	if (r > damage)
		return;		// didn't flinch

	wiz_pain1();
};


void() monster_wizard_precache =
{
	precache_model ("progs/wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("wizard/wattack.wav");
	precache_sound ("wizard/wdeath.wav");
	precache_sound ("wizard/widle1.wav");
	precache_sound ("wizard/widle2.wav");
	precache_sound ("wizard/wpain.wav");
	precache_sound ("wizard/wsight.wav");
};

void() monster_wizard_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/wizard.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	self.max_health = 80;
	self.corpsehealth = 100;
	self.gib = GIB_HUMANOID;
	self.headname = "progs/h_wizard.mdl";
	self.gibhealth = -40;
	self.mass = 50;

	self.flags = self.flags | FL_NOSLIMEDMG;

	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = wiz_missile;
	self.th_pain = wiz_pain;
	self.th_die = wiz_die;
	self.th_gib = monster_gib;
	self.th_sight = wiz_sight;
		
	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		flymonster_start_go();
	else
		flymonster_start();
};

/*QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_wizard =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_wizard_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_wizard_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, '-16 -16 -24', '16 16 40');
		self.spawnfactory = monster_wizard_spawn;
	}
	else
	{
		monster_wizard_spawn();
		total_monsters = total_monsters + 1;
	}
};
