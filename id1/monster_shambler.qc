/*
==============================================================================

SHAMBLER

==============================================================================
*/

$cd id1/models/shams
$origin 0 0 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12

$frame run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 death11

void(float side) sham_claw;
void() sham_smack;
void(vector offs) sham_lightning;
void() sham_idle;
void() sham_sight;
void() sham_active;

void() sham_stand1	=[	$stand1,	sham_stand2	] {sham_idle();ai_stand();};
void() sham_stand2	=[	$stand2,	sham_stand3	] {ai_stand();};
void() sham_stand3	=[	$stand3,	sham_stand4	] {ai_stand();};
void() sham_stand4	=[	$stand4,	sham_stand5	] {ai_stand();};
void() sham_stand5	=[	$stand5,	sham_stand6	] {ai_stand();};
void() sham_stand6	=[	$stand6,	sham_stand7	] {ai_stand();};
void() sham_stand7	=[	$stand7,	sham_stand8	] {ai_stand();};
void() sham_stand8	=[	$stand8,	sham_stand9	] {ai_stand();};
void() sham_stand9	=[	$stand9,	sham_stand10	] {ai_stand();};
void() sham_stand10	=[	$stand10,	sham_stand11	] {ai_stand();};
void() sham_stand11	=[	$stand11,	sham_stand12	] {ai_stand();};
void() sham_stand12	=[	$stand12,	sham_stand13	] {ai_stand();};
void() sham_stand13	=[	$stand13,	sham_stand14	] {ai_stand();};
void() sham_stand14	=[	$stand14,	sham_stand15	] {ai_stand();};
void() sham_stand15	=[	$stand15,	sham_stand16	] {ai_stand();};
void() sham_stand16	=[	$stand16,	sham_stand17	] {ai_stand();};
void() sham_stand17	=[	$stand17,	sham_stand1	] {ai_stand();};


void() sham_walk1	=[	$walk1,		sham_walk2 	] {sham_idle();ai_walk(10);};
void() sham_walk2	=[	$walk2,		sham_walk3 	] {ai_walk(9);};
void() sham_walk3	=[	$walk3,		sham_walk4 	] {ai_walk(9);};
void() sham_walk4	=[	$walk4,		sham_walk5	] {ai_walk(5);};
void() sham_walk5	=[	$walk5,		sham_walk6 	] {ai_walk(6);};
void() sham_walk6	=[	$walk6,		sham_walk7 	] {ai_walk(12);};
void() sham_walk7	=[	$walk7,		sham_walk8 	] {ai_walk(8);};
void() sham_walk8	=[	$walk8,		sham_walk9 	] {ai_walk(3);};
void() sham_walk9	=[	$walk9,		sham_walk10	] {ai_walk(13);};
void() sham_walk10	=[	$walk10,	sham_walk11	] {ai_walk(9);};
void() sham_walk11	=[	$walk11,	sham_walk12	] {ai_walk(7);};
void() sham_walk12	=[	$walk12,	sham_walk1 	] {ai_walk(7);};


void() sham_run1	=[	$run1,		sham_run2	] {sham_active();ai_run(20);};
void() sham_run2	=[	$run2,		sham_run3	] {ai_run(24);};
void() sham_run3	=[	$run3,		sham_run4	] {ai_run(20);};
void() sham_run4	=[	$run4,		sham_run5	] {ai_run(20);};
void() sham_run5	=[	$run5,		sham_run6	] {ai_run(24);};
void() sham_run6	=[	$run6,		sham_run1	] {ai_run(20);};


void() sham_smash1	=[	$smash1,	sham_smash2	]
{
	sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
	ai_charge(2);
};
void() sham_smash2	=[	$smash2,	sham_smash3	] {ai_charge(6);};
void() sham_smash3	=[	$smash3,	sham_smash4	] {ai_charge(6);};
void() sham_smash4	=[	$smash4,	sham_smash5	] {ai_charge(5);};
void() sham_smash5	=[	$smash5,	sham_smash6	] {ai_charge(4);};
void() sham_smash6	=[	$smash6,	sham_smash7	] {ai_charge(1);};
void() sham_smash7	=[	$smash7,	sham_smash8	] {ai_charge(0);};
void() sham_smash8	=[	$smash8,	sham_smash9	] {ai_charge(0);};
void() sham_smash9	=[	$smash9,	sham_smash10	] {ai_charge(0);};
void() sham_smash10	=[	$smash10,	sham_smash11	] {ai_charge(0);sham_smack();};
void() sham_smash11	=[	$smash11,	sham_smash12	] {ai_charge(5);};
void() sham_smash12	=[	$smash12,	sham_run1	] {ai_charge(4);};


void() sham_swingl1	=[	$swingl1,	sham_swingl2	]
{
	sound (self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM);
	ai_charge(5);
};
void() sham_swingl2	=[	$swingl2,	sham_swingl3	] {ai_charge(3);};
void() sham_swingl3	=[	$swingl3,	sham_swingl4	] {ai_charge(7);};
void() sham_swingl4	=[	$swingl4,	sham_swingl5	] {ai_charge(3);};
void() sham_swingl5	=[	$swingl5,	sham_swingl6	] {ai_charge(7);};
void() sham_swingl6	=[	$swingl6,	sham_swingl7	] {ai_charge(9);};
void() sham_swingl7	=[	$swingl7,	sham_swingl8	] {ai_charge(5); sham_claw(250);};
void() sham_swingl8	=[	$swingl8,	sham_swingl9	] {ai_charge(4);};
void() sham_swingl9	=[	$swingl9,	sham_run1	]
{
	ai_charge(8);
	if (random() < 0.5)
		self.think = sham_swingr1;
};


void() sham_swingr1	=[	$swingr1,	sham_swingr2	]
{
	sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
	ai_charge(1);
};
void() sham_swingr2	=[	$swingr2,	sham_swingr3	] {ai_charge(8);};
void() sham_swingr3	=[	$swingr3,	sham_swingr4	] {ai_charge(14);};
void() sham_swingr4	=[	$swingr4,	sham_swingr5	] {ai_charge(7);};
void() sham_swingr5	=[	$swingr5,	sham_swingr6	] {ai_charge(3);};
void() sham_swingr6	=[	$swingr6,	sham_swingr7	] {ai_charge(6);};
void() sham_swingr7	=[	$swingr7,	sham_swingr8	] {ai_charge(6); sham_claw(-250);};
void() sham_swingr8	=[	$swingr8,	sham_swingr9	] {ai_charge(3);};
void() sham_swingr9	=[	$swingr9,	sham_run1	]
{
	ai_charge(10);
	if (random() < 0.5)
		self.think = sham_swingl1;
};

//============================================================================

void() sham_magic1	=[	$magic1,	sham_magic2	]
{
	ai_face();
	sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
};
void() sham_magic2	=[	$magic2,	sham_magic3	] {ai_face();};
void() sham_magic3	=[	$magic3,	sham_magic4	]
{
	local entity o;

	ai_face();
	self.nextthink = time + 0.2;
	self.effects = self.effects | EF_MUZZLEFLASH;

	o = spawn();
	o.classname = "sham_arc";
	o.aiment = self;
	self.aiment = o;
	o.movetype = MOVETYPE_FOLLOW;

	setmodel (o, "progs/s_light.mdl");
	setorigin (o, self.origin);

	o.angles = self.angles;
	o.nextthink = time + 0.7;
	o.think = SUB_Remove;
};
void() sham_magic4	=[	$magic4,	sham_magic5	]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.aiment.frame = 1;
};
void() sham_magic5	=[	$magic5,	sham_magic6	]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.aiment.frame = 2;
};
void() sham_magic6	=[	$magic6,	sham_magic9	]
{
	remove (self.aiment);
	sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
	sham_lightning('28 8.5 37');	//'30 7 35'
};
void() sham_magic9	=[	$magic9,	sham_magic10	] {sham_lightning('24.5 7.5 44');};	//'27 6 42'
void() sham_magic10	=[	$magic10,	sham_magic11	] {sham_lightning('-25.5 5 49.5');};	//'-22 4 49'
void() sham_magic11	=[	$magic11,	sham_magic12	]
{
	if (skill == SKILL_NIGHTMARE)
		sham_lightning('-21.5 0.5 51');	//'-19 0 50'
};
void() sham_magic12	=[	$magic12,	sham_run1	] {};

//============================================================================

void() sham_pain1	=[	$pain1,		sham_pain2	] {};
void() sham_pain2	=[	$pain2,		sham_pain3	] {};
void() sham_pain3	=[	$pain3,		sham_pain4	] {};
void() sham_pain4	=[	$pain4,		sham_pain5	] {};
void() sham_pain5	=[	$pain5,		sham_pain6	] {};
void() sham_pain6	=[	$pain6,		sham_run1	] {};


void() sham_death1	=[	$death1,	sham_death2	] {body_solid('-32 -32 -24', '32 32 64');};
void() sham_death2	=[	$death2,	sham_death3	] {body_solid('-32 -32 -24', '32 32 64');};
void() sham_death3	=[	$death3,	sham_death4	] {body_solid('-32 -32 -24', '32 32 64');};
void() sham_death4	=[	$death4,	sham_death5	] {body_solid('-32 -32 -24', '32 32 64');};
void() sham_death5	=[	$death5,	sham_death6	] {body_solid('-32 -32 -24', '32 32 58');};
void() sham_death6	=[	$death6,	sham_death7	] {body_solid('-32 -32 -24', '32 32 44');};
void() sham_death7	=[	$death7,	sham_death8	] {body_solid('-32 -32 -24', '32 32 28');};
void() sham_death8	=[	$death8,	sham_death9	] {body_solid('-36 -36 -24', '36 36 17');};
void() sham_death9	=[	$death9,	sham_death10	] {body_nonsolid('-40 -40 -24', '40 40 7');};
void() sham_death10	=[	$death10,	sham_death11	] {body_nonsolid('-40 -40 -24', '40 40 6');};
void() sham_death11	=[	$death11,	sham_death11	] {body_nonsolid('-40 -40 -24', '40 40 -8');MonsterDead();};

//============================================================================

void() sham_smack = 
{
	local vector delta;
	local float ldmg, rnum1, rnum2, rnum3;

	if (!self.enemy)
		return;

	if (self.enemy.flags & FL_CORPSE)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	if (!CanDamage (self.enemy, self))
		return;

	rnum1 = random();
	rnum2 = random();
	rnum3 = random();
	ldmg = (rnum1 + rnum2 + rnum3) * 40;

	T_Damage (self.enemy, self, self, ldmg, "shambler_melee1");

	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 108 * v_right);
	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 95 * v_right);

	rnum1 = random();
	if (rnum1 > 0.5)
	{
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 92 * v_right);
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 86 * v_right);
	}
	if (rnum1 > 0.8)
	{
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 104 * v_right);
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 79 * v_right);
	}

};


void(float side) sham_claw =
{
	local vector delta;
	local float ldmg, rnum1, rnum2, rnum3;

	if (!self.enemy)
		return;

	if (self.enemy.flags & FL_CORPSE)
		return;

	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

	rnum1 = random();
	rnum2 = random();
	rnum3 = random();
	ldmg = (rnum1 + rnum2 + rnum3) * 20;

	T_Damage (self.enemy, self, self, ldmg, "shambler_melee2");

	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	if (side)
	{
		makevectors (self.angles);
		rnum1 = random();
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
		SpawnMeatSpray (self.origin + v_forward*14, side * v_right);
		if (rnum1 > 0.5)
			SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
		if (rnum1 > 0.7)
			SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};


void() sham_melee =
{
	local float chance;
	
	chance = random();

	if ((chance > 0.6) || (self.health > 500))
		sham_smash1 ();

	else if (chance > 0.3)
		sham_swingr1 ();

	else
		sham_swingl1 ();
};

//=============================================================================

/*
===========
ShamCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ShamCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
//	local float	chance;
//	local float	enemy_yaw;

	if (self.enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;
	
	if (!self.enemy_vis)
		return FALSE;
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) > 600)
		return FALSE;

	traceline (spot1, spot2, FALSE, self);

//	if (trace_inopen && trace_inwater)
//		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}
			
// missile attack
	if (self.enemy_range == RANGE_FAR)
		return FALSE;
		
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
	return TRUE;
};

void(vector offs) sham_lightning =
{
	local	vector	org, dir;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	ai_face ();

	makevectors(self.angles);

//	org = self.origin + '0 0 40';
//	org = self.origin - 5*v_forward + 45*v_up;

	org = self.origin + offs_x*v_forward - offs_y*v_right + offs_z*v_up;

	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);

	traceline (org, self.origin + dir*600, TRUE, self);

	te_lightning1(self, org, trace_endpos);

	LightningDamage (org, trace_endpos, self, 10);	//10
};


//============================================================================

void() sham_glowingclawleft =
{
	local entity o;
	self.nextthink = 1; // ASAP

//	if (self.owner.health < 1)
	if (self.owner.flags & FL_CORPSE)
	{
		remove(self);
		return;
	}

	o = self.owner;

	if (o.frame >= $magic2 && o.frame <= $magic8)
	{
		self.glow_size = 200;
		// Thanks to SSJ4-Death (in #qc) for getting the shambler claw locations
//		if 	(o.frame == $magic1) 	self.view_ofs = '42.44 35.15 26.76';
//		else 
		if 	(o.frame == $magic2) 	self.view_ofs = '30.55 3.3 73.36';
		else if (o.frame == $magic3) 	self.view_ofs = '19.91 -3.63 80.49';
		else if (o.frame == $magic4) 	self.view_ofs = '15.53 -4.32 81.58';
		else if (o.frame == $magic5) 	self.view_ofs = '26.8 8.14 82.68';
		else if (o.frame == $magic6) 	self.view_ofs = '-23.9 67 19.63';
		else if (o.frame == $magic7) 	self.view_ofs = '-24.52 66.31 20.18';
		else if (o.frame == $magic8) 	self.view_ofs = '-25.15 66.31 18.53';
		else if (o.frame == $magic9) 	self.view_ofs = '-25.78 63.54 15.79';
		else if (o.frame == $magic10) 	self.view_ofs = '9.9 63.54 26.21';
		else if (o.frame == $magic11) 	self.view_ofs = '25.54 35.84 33.34';
		else				self.view_ofs = '36.81 22.68 34.43';
	}
	else
	{
		self.glow_size = 0;
	}
};

void() sham_glowingclawright =
{
	local entity o;
	self.nextthink = 1; // ASAP

//	if (self.owner.health < 1)
	if (self.owner.flags & FL_CORPSE)
	{
		remove(self);
		return;
	}

	o = self.owner;

	if (o.frame >= $magic2 && o.frame <= $magic8)
	{
		self.glow_size = 200;
		// Thanks to SSJ4-Death (in #qc) for getting the shambler claw locations
//		if 	(o.frame == $magic1) 	self.view_ofs = '28.67 -43.79 13.6';
//		else 
		if (o.frame == $magic2) 	self.view_ofs = '11.15 -41.71 60.75';
		else if (o.frame == $magic3) 	self.view_ofs = '-1.37 -37.56 70.62';
		else if (o.frame == $magic4) 	self.view_ofs = '-9.5 -24.09 75';
		else if (o.frame == $magic5) 	self.view_ofs = '10.52 -23.02 87.62';
		else if (o.frame == $magic6) 	self.view_ofs = '-37.67 -37.56 30.05';
		else if (o.frame == $magic7) 	self.view_ofs = '-35.16 -38.94 30.59';
		else if (o.frame == $magic8) 	self.view_ofs = '-36.42 -36.86 27.85';
		else if (o.frame == $magic9) 	self.view_ofs = '-32.03 -43.1 19.63';
		else if (o.frame == $magic10) 	self.view_ofs = '-28.91 -43.79 5.92';
		else if (o.frame == $magic11) 	self.view_ofs = '-12.01 -50.02 21.27';
		else				self.view_ofs = '25.54 -36.17 27.85';
	}
	else
	{
		self.glow_size = 0;
	}
}

void() sham_spawnglowingclaws =
{
	newmis = spawn();
	newmis.think = sham_glowingclawleft;
	newmis.nextthink = 1; // ASAP
	newmis.aiment = newmis.owner = self;
	newmis.movetype = MOVETYPE_FOLLOW;
	newmis.glow_color = 245;

	newmis = spawn();
	newmis.think = sham_glowingclawright;
	newmis.nextthink = 1; // ASAP
	newmis.aiment = newmis.owner = self;
	newmis.movetype = MOVETYPE_FOLLOW;
	newmis.glow_color = 245;
};

//============================================================================

void() sham_sight =
{
	sound (self, CHAN_AUTO, "shambler/ssight.wav", 1, ATTN_NORM);
};

void() sham_idle =
{
	local float r;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();
	if (r > 0.8)
		sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);
};

void() sham_active =
{
	local float r;
	r = random();
	if (r > 0.8)
		sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);
};

void(entity attacker, float damage) sham_pain =
{
	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (self.pain_finished > time)
		return;

	if (self.aiment)
	if (self.aiment.classname == "sham_arc")
		remove(self.aiment);

	MonsterBubbles(3,6);

	sound (self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM);

	self.pain_finished = time + 1;

	if (random()*400 > damage)
		return;		// didn't flinch
		
	sham_pain1 ();
};

void() sham_die =
{
	if (self.aiment)
	if (self.aiment.classname == "sham_arc")
		remove(self.aiment);

	sound (self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM);
	MonsterBubbles(20,40);
	monster_corpse(sham_death1);
};

void() sham_gib =
{
	if (self.aiment)
	if (self.aiment.classname == "sham_arc")
		remove(self.aiment);

	monster_gib(self.headname, self.health, self.gib);
};

void() monster_shambler_precache = 
{
	precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	
	precache_sound ("shambler/sattck1.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("shambler/sdeath.wav");
	precache_sound ("shambler/shurt2.wav");
	precache_sound ("shambler/sidle.wav");
	precache_sound ("shambler/ssight.wav");
	precache_sound ("shambler/melee1.wav");
	precache_sound ("shambler/melee2.wav");
	precache_sound ("shambler/smack.wav");
};

void() monster_shambler_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/shambler.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	self.max_health = 600;	//600;
	self.corpsehealth = 250;
	self.gib = GIB_LARGE;
	self.headname = "progs/h_shams.mdl";
	self.gibhealth = -60;
	self.mass = 600;	//600;

	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	self.th_run = sham_run1;
	self.th_die = sham_die;
	self.th_melee = sham_melee;
	self.th_missile = sham_magic1;
	self.th_pain = sham_pain;
	self.th_gib = sham_gib;
	self.th_sight = sham_sight;
	
	sham_spawnglowingclaws();

	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();	
};

/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_shambler =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_shambler_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_shambler_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.spawnfactory = monster_shambler_spawn;
	}
	else
	{
		monster_shambler_spawn();
		total_monsters = total_monsters + 1;
	}
};
