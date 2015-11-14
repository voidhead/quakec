/*
==============================================================================

OGRE

==============================================================================
*/

$cd id1/models/ogre_c
$origin 0 0 24
$base base		
$skin base

$frame	stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame swing1 swing2 swing3 swing4 swing5 swing6 swing7
$frame swing8 swing9 swing10 swing11 swing12 swing13 swing14

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7
$frame smash8 smash9 smash10 smash11 smash12 smash13 smash14

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6

$frame pain1 pain2 pain3 pain4 pain5

$frame painb1 painb2 painb3

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13 paind14 paind15 paind16

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15

$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9 death10 death11 death12
$frame death13 death14

$frame bdeath1 bdeath2 bdeath3 bdeath4 bdeath5 bdeath6
$frame bdeath7 bdeath8 bdeath9 bdeath10

$frame pull1 pull2 pull3 pull4 pull5 pull6 pull7 pull8 pull9 pull10 pull11

//float(float ang, vector dest) OgreIterateElevation;
void(float elevation) ogre_grenade;
//void() ogre_grenade;
void(float side) ogre_chainsaw;
void() ogre_melee;
void() ogre_idle;
void() ogre_active;
void() ogre_drag;
void() ogre_saw;
void() ogre_backpack;

void(vector atpos, vector targpos) OgreCalcAngle;
void() OgreAim;
float() OgreDecideAttack;
void() ogre_nail8;

void() 	ogre_stand1	=[	$stand1,	ogre_stand2	] {ogre_idle();ai_stand();};
void() 	ogre_stand2	=[	$stand2,	ogre_stand3	] {ai_stand();};
void() 	ogre_stand3	=[	$stand3,	ogre_stand4	] {ai_stand();};
void() 	ogre_stand4	=[	$stand4,	ogre_stand5	] {ai_stand();};
void() 	ogre_stand5	=[	$stand5,	ogre_stand6	] {ai_stand();};
void() 	ogre_stand6	=[	$stand6,	ogre_stand7	] {ai_stand();};
void() 	ogre_stand7	=[	$stand7,	ogre_stand8	] {ai_stand();};
void() 	ogre_stand8	=[	$stand8,	ogre_stand9	] {ai_stand();};
void() 	ogre_stand9	=[	$stand9,	ogre_stand1	] {ai_stand();};


void() 	ogre_pull1	=[	$pull1,		ogre_pull2	] {};
void() 	ogre_pull2	=[	$pull2,		ogre_pull3	] {};
void() 	ogre_pull3	=[	$pull3,		ogre_pull4	] {if (random() < 0.2) ogre_saw();};
void() 	ogre_pull4	=[	$pull4,		ogre_pull5	] {ai_face();};
void() 	ogre_pull5	=[	$pull5,		ogre_pull6	] {ai_face();};
void() 	ogre_pull6	=[	$pull6,		ogre_pull12	] {ai_face();ogre_sight();};
void() 	ogre_pull7	=[	$pull7,		ogre_pull8	] {};
void() 	ogre_pull8	=[	$pull8,		ogre_pull9	] {};
void() 	ogre_pull9	=[	$pull9,		ogre_pull10	] {ai_face();};
void() 	ogre_pull10	=[	$pull10,	ogre_pull11	] {ai_face();};
void() 	ogre_pull11	=[	$pull11,	ogre_run1	] {ai_face();HuntTarget();};
void() 	ogre_pull12	=[	$pull5,		ogre_pull13	] {};
void() 	ogre_pull13	=[	$pull6,		ogre_pull14	] {};
void() 	ogre_pull14	=[	$pull5,		ogre_pull7	] {};


void() 	ogre_walk1	=[	$walk1,		ogre_walk2	] {ogre_idle();ai_walk(3);};
void() 	ogre_walk2	=[	$walk2,		ogre_walk3	] {ai_walk(2);};
void() 	ogre_walk3	=[	$walk3,		ogre_walk4	] {ai_walk(2);};
void() 	ogre_walk4	=[	$walk4,		ogre_walk5	] {ai_walk(2);};
void() 	ogre_walk5	=[	$walk5,		ogre_walk6	] {ai_walk(2);};
void() 	ogre_walk6	=[	$walk6,		ogre_walk7	] {ai_walk(5);ogre_drag();};
void() 	ogre_walk7	=[	$walk7,		ogre_walk8	] {ai_walk(3);};
void() 	ogre_walk8	=[	$walk8,		ogre_walk9	] {ai_walk(2);};
void() 	ogre_walk9	=[	$walk9,		ogre_walk10	] {ai_walk(3);};
void() 	ogre_walk10	=[	$walk10,	ogre_walk11	] {ai_walk(1);};
void() 	ogre_walk11	=[	$walk11,	ogre_walk12	] {ai_walk(2);};
void() 	ogre_walk12	=[	$walk12,	ogre_walk13	] {ai_walk(3);};
void() 	ogre_walk13	=[	$walk13,	ogre_walk14	] {ai_walk(3);};
void() 	ogre_walk14	=[	$walk14,	ogre_walk15	] {ai_walk(3);};
void() 	ogre_walk15	=[	$walk15,	ogre_walk16	] {ai_walk(3);};
void() 	ogre_walk16	=[	$walk16,	ogre_walk1	] {ai_walk(4);};


void() 	ogre_run1	=[	$run1,		ogre_run2	] {ogre_active();ai_run(9);};
void() 	ogre_run2	=[	$run2,		ogre_run3	] {ai_run(12);};
void() 	ogre_run3	=[	$run3,		ogre_run4	] {ai_run(8);};
void() 	ogre_run4	=[	$run4,		ogre_run5	] {ai_run(22);};
void() 	ogre_run5	=[	$run5,		ogre_run6	] {ai_run(16);};
void() 	ogre_run6	=[	$run6,		ogre_run7	] {ai_run(4);};
void() 	ogre_run7	=[	$run7,		ogre_run8	] {ai_run(13);};
void() 	ogre_run8	=[	$run8,		ogre_run1	] {ai_run(24);};


void() 	ogre_swing1	=[	$swing1,	ogre_swing2	] {ai_charge(11);ogre_saw();};
void() 	ogre_swing2	=[	$swing2,	ogre_swing3	] {ai_charge(1);};
void() 	ogre_swing3	=[	$swing3,	ogre_swing4	] {ai_charge(4);};
void() 	ogre_swing4	=[	$swing4,	ogre_swing5	] {ai_charge(13);};
void() 	ogre_swing5	=[	$swing5,	ogre_swing6	] {ai_charge(9);ogre_chainsaw(0);self.angles_y = self.angles_y + random()*25;};
void() 	ogre_swing6	=[	$swing6,	ogre_swing7	] {ogre_chainsaw(200);self.angles_y = self.angles_y + random()* 25;};
void() 	ogre_swing7	=[	$swing7,	ogre_swing8	] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() 	ogre_swing8	=[	$swing8,	ogre_swing9	] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() 	ogre_swing9	=[	$swing9,	ogre_swing10 	] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() 	ogre_swing10	=[	$swing10,	ogre_swing11 	] {ogre_chainsaw(-200);self.angles_y = self.angles_y + random()* 25;};
void() 	ogre_swing11	=[	$swing11,	ogre_swing12 	] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() 	ogre_swing12	=[	$swing12,	ogre_swing13 	] {ai_charge(3);};
void() 	ogre_swing13	=[	$swing13,	ogre_swing14 	] {ai_charge(8);};
void() 	ogre_swing14	=[	$swing14,	ogre_run1	] {ai_charge(9);};


void() 	ogre_smash1	=[	$smash1,	ogre_smash2	] {ai_charge(6);ogre_saw();};
void() 	ogre_smash2	=[	$smash2,	ogre_smash3	] {ai_charge(0);};
void() 	ogre_smash3	=[	$smash3,	ogre_smash4	] {ai_charge(0);};
void() 	ogre_smash4	=[	$smash4,	ogre_smash5	] {ai_charge(1);};
void() 	ogre_smash5	=[	$smash5,	ogre_smash6	] {ai_charge(4);};
void() 	ogre_smash6	=[	$smash6,	ogre_smash7	] {ai_charge(4);ogre_chainsaw(0);};
void() 	ogre_smash7	=[	$smash7,	ogre_smash8	] {ai_charge(4);ogre_chainsaw(0);};
void() 	ogre_smash8	=[	$smash8,	ogre_smash9	] {ai_charge(10);ogre_chainsaw(0);};
void() 	ogre_smash9	=[	$smash9,	ogre_smash10 	] {ai_charge(13);ogre_chainsaw(0);};
void() 	ogre_smash10	=[	$smash10,	ogre_smash11 	] {ogre_chainsaw(1);};
void() 	ogre_smash11	=[	$smash11,	ogre_smash12 	] {ai_charge(2);ogre_chainsaw(0);
	self.nextthink = time + 0.1 + random()*0.2;	// slight variation
};
void() 	ogre_smash12	=[	$smash12,	ogre_smash13 	] {ai_charge(1);};
void() 	ogre_smash13	=[	$smash13,	ogre_smash14 	] {ai_charge(4);};
void() 	ogre_smash14	=[	$smash14,	ogre_run1	] {ai_charge(12);};


void() 	ogre_nail1	=[	$shoot1,	ogre_nail2	]
{
	ai_face();
//	print("attack start\n\n");

	self.cnt = 0;
	self.mangle = VEC_0;
	self.mangle_z = OGRE_ATTACK_BAD;

	OgreAim();

	if (self.mangle_z < OGRE_ATTACK_GOOD)
	if (random() < 0.3)
	{
//		print("unreachable - aborting\n");
//		self.attack_finished = time + 0.5;
		self.attack_state = FALSE;
		ogre_run1();
		return;
	}
};
void() 	ogre_nail2	=[	$shoot2,	ogre_nail3	]
{
	ai_face();
	OgreAim();
};
void() 	ogre_nail3	=[	$shoot2,	ogre_nail4	]
{
	ai_face();
	OgreAim();
};
void() 	ogre_nail4	=[	$shoot3,	ogre_nail5	]
{
	local float ang;

	ai_face();

//	print("disc=", ftos(self.cnt), " mangle=", vtos(self.mangle), "\n");

	if (self.mangle_z == OGRE_ATTACK_BAD)
	{
//		print("attack aborted\n\n");
		ogre_nail8();
		return;
	}

	ang = OgreDecideAttack();

	if (self.mangle_z == OGRE_ATTACK_FUTILE)
	{
		if (ang > 85)
		{
//			print("attack aborted - might hit self\n\n");
			ogre_nail8();
			return;
		}
		
//		else
//			ang += 3*crandom();

//		print("unreachable, but launching anyway\n");
	}

//	print("disc=", ftos(self.cnt), " mangle=", vtos(self.mangle), "\n");

//	print("launching attack with ang=", ftos(ang), "\n\n");

	ogre_grenade(ang);
//	print("attack end\n\n");
};
void() 	ogre_nail5	=[	$shoot4,	ogre_nail6	] {ai_face();};
void() 	ogre_nail6	=[	$shoot5,	ogre_nail7	] {ai_face();};
void() 	ogre_nail7	=[	$shoot6,	ogre_run1	] {ai_face();};
void() 	ogre_nail8	=[	$shoot2,	ogre_nail9	] 
{
	ai_face();
	if (random() < 0.6)
		sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
};
void() 	ogre_nail9	=[	$shoot2,	ogre_nail10	] {ai_face();};
void() 	ogre_nail10	=[	$shoot2,	ogre_run1	] {ai_face();};


void()	ogre_pain1	=[	$pain1,		ogre_pain2	] {};
void()	ogre_pain2	=[	$pain2,		ogre_pain3	] {};
void()	ogre_pain3	=[	$pain3,		ogre_pain4	] {};
void()	ogre_pain4	=[	$pain4,		ogre_pain5	] {};
void()	ogre_pain5	=[	$pain5,		ogre_run1	] {};


void()	ogre_painb1	=[	$painb1,	ogre_painb2	] {};
void()	ogre_painb2	=[	$painb2,	ogre_painb3	] {};
void()	ogre_painb3	=[	$painb3,	ogre_run1	] {};


void()	ogre_painc1	=[	$painc1,	ogre_painc2	] {};
void()	ogre_painc2	=[	$painc2,	ogre_painc3	] {};
void()	ogre_painc3	=[	$painc3,	ogre_painc4	] {};
void()	ogre_painc4	=[	$painc4,	ogre_painc5	] {};
void()	ogre_painc5	=[	$painc5,	ogre_painc6	] {};
void()	ogre_painc6	=[	$painc6,	ogre_run1	] {};


void()	ogre_paind1	=[	$paind1,	ogre_paind2	] {};
void()	ogre_paind2	=[	$paind2,	ogre_paind3	] {ai_pain(10);};
void()	ogre_paind3	=[	$paind3,	ogre_paind4	] {ai_pain(9);};
void()	ogre_paind4	=[	$paind4,	ogre_paind5	] {ai_pain(4);};
void()	ogre_paind5	=[	$paind5,	ogre_paind6	] {};
void()	ogre_paind6	=[	$paind6,	ogre_paind7	] {};
void()	ogre_paind7	=[	$paind7,	ogre_paind8	] {};
void()	ogre_paind8	=[	$paind8,	ogre_paind9	] {};
void()	ogre_paind9	=[	$paind9,	ogre_paind10	] {};
void()	ogre_paind10	=[	$paind10,	ogre_paind11	] {};
void()	ogre_paind11	=[	$paind11,	ogre_paind12	] {};
void()	ogre_paind12	=[	$paind12,	ogre_paind13	] {};
void()	ogre_paind13	=[	$paind13,	ogre_paind14	] {};
void()	ogre_paind14	=[	$paind14,	ogre_paind15	] {};
void()	ogre_paind15	=[	$paind15,	ogre_paind16	] {};
void()	ogre_paind16	=[	$paind16,	ogre_run1	] {};

void()	ogre_paine1	=[	$paine1,	ogre_paine2	] {};
void()	ogre_paine2	=[	$paine2,	ogre_paine3	] {ai_pain(10);};
void()	ogre_paine3	=[	$paine3,	ogre_paine4	] {ai_pain(9);};
void()	ogre_paine4	=[	$paine4,	ogre_paine5	] {ai_pain(4);};
void()	ogre_paine5	=[	$paine5,	ogre_paine6	] {};
void()	ogre_paine6	=[	$paine6,	ogre_paine7	] {};
void()	ogre_paine7	=[	$paine7,	ogre_paine8	] {};
void()	ogre_paine8	=[	$paine8,	ogre_paine9	] {};
void()	ogre_paine9	=[	$paine9,	ogre_paine10	] {};
void()	ogre_paine10	=[	$paine10,	ogre_paine11	] {};
void()	ogre_paine11	=[	$paine11,	ogre_paine12	] {};
void()	ogre_paine12	=[	$paine12,	ogre_paine13	] {};
void()	ogre_paine13	=[	$paine13,	ogre_paine14	] {};
void()	ogre_paine14	=[	$paine14,	ogre_paine15	] {};
void()	ogre_paine15	=[	$paine15,	ogre_run1	] {};


void()	ogre_die1	=[	$death1,	ogre_die2	] {body_solid('-32 -32 -24', '32 32 32');};
void()	ogre_die2	=[	$death2,	ogre_die3	] {body_solid('-32 -32 -24', '32 32 32');};
void()	ogre_die3	=[	$death3,	ogre_die4	] {body_solid('-32 -32 -24', '32 32 32');ogre_backpack();};
void()	ogre_die4	=[	$death4,	ogre_die5	] {body_solid('-32 -32 -24', '32 32 32');};
void()	ogre_die5	=[	$death5,	ogre_die6	] {body_solid('-32 -32 -24', '32 32 32');};
void()	ogre_die6	=[	$death6,	ogre_die7	] {body_solid('-32 -32 -24', '32 32 28');};
void()	ogre_die7	=[	$death7,	ogre_die8	] {body_solid('-32 -32 -24', '32 32 24');};
void()	ogre_die8	=[	$death8,	ogre_die9	] {body_solid('-32 -32 -24', '32 32 19');};
void()	ogre_die9	=[	$death9,	ogre_die10	] {body_nonsolid('-32 -32 -24', '32 32 17');};
void()	ogre_die10	=[	$death10,	ogre_die11	] {body_nonsolid('-32 -32 -24', '32 32 11');};
void()	ogre_die11	=[	$death11,	ogre_die12	] {body_nonsolid('-32 -32 -24', '32 32  3');};
void()	ogre_die12	=[	$death12,	ogre_die13	] {body_nonsolid('-32 -32 -24', '32 32 -6');};
void()	ogre_die13	=[	$death13,	ogre_die14	] {body_nonsolid('-32 -32 -24', '32 32 -6');};
void()	ogre_die14	=[	$death14,	ogre_die14	] {body_nonsolid('-32 -32 -24', '32 32 -12');MonsterDead();};


void()	ogre_bdie1	=[	$bdeath1,	ogre_bdie2	] {body_solid('-32 -32 -24', '32 32  32');};
void()	ogre_bdie2	=[	$bdeath2,	ogre_bdie3	] {body_solid('-32 -32 -24', '32 32  32');ai_forward(5);};
void()	ogre_bdie3	=[	$bdeath3,	ogre_bdie4	] {body_solid('-32 -32 -24', '32 32  32');ogre_backpack();};
void()	ogre_bdie4	=[	$bdeath4,	ogre_bdie5	] {body_solid('-32 -32 -24', '32 32  32');ai_forward(1);};
void()	ogre_bdie5	=[	$bdeath5,	ogre_bdie6	] {body_solid('-32 -32 -24', '32 32  32');ai_forward(3);};
void()	ogre_bdie6	=[	$bdeath6,	ogre_bdie7	] {body_nonsolid('-32 -32 -24', '32 32  27');ai_forward(7);};
void()	ogre_bdie7	=[	$bdeath7,	ogre_bdie8	] {body_nonsolid('-32 -32 -24', '32 32  -1');ai_forward(25);};
void()	ogre_bdie8	=[	$bdeath8,	ogre_bdie9	] {body_nonsolid('-32 -32 -24', '32 32  -2');};
void()	ogre_bdie9	=[	$bdeath9,	ogre_bdie10	] {body_nonsolid('-32 -32 -24', '32 32  -9');};
void()	ogre_bdie10	=[	$bdeath10,	ogre_bdie10	] {body_nonsolid('-32 -32 -24', '32 32 -12');MonsterDead();};

//============================================================================

/*
===========
OgreCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() OgreCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float	chance;

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

	traceline (spot1, spot2, FALSE, self);

//	if (trace_inopen && trace_inwater)
//		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}

//	OgreCalcAngle(self.origin + self.view_ofs, targ.origin);
//	if (self.cnt < 0)
//		return FALSE;
			
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (self.enemy_range == RANGE_FAR)
		return FALSE;
		
	else if (self.enemy_range == RANGE_NEAR)
		chance = 0.10;
	else if (self.enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + 2*random());
	return TRUE;
};


//=============================================================================

void() OgreGrenadeExplode =
{
	local float damg;
//	local vector vel;

	damg = 40;

	if (other.classname == "monster_zombie")
		T_Damage (other, self, self.owner, 60, "ogre_grenade");		//30

	else if (other.health > 0)
	{
		if (other.classname == "monster_shambler")
			damg = damg*0.5;	// mostly immune

		T_Damage (other, self, self.owner, damg, "ogre_grenade");

		SpawnBlood_Expl(other, self.velocity, damg);
	}

	T_RadiusDamage (self, self.owner, 40, other, "ogre_grenade");

//	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);

	te_explosion(self.origin);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};


void() OgreGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (other.takedamage == DAMAGE_AIM)
	{
		OgreGrenadeExplode();
		return;
	}

	sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound

	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void() OgreGrenadeThink = 
{
	local float fltime;
	fltime = time - self.ltime;

	if (fltime > 2.5)
	{
		OgreGrenadeExplode();
		return;
	}

	self.nextthink = time + 0.01;

	if (vlen(self.velocity) < 100)
	{
		self.avelocity_x = 0;
		self.idealpitch = anglemod_ground(self.angles_x);
		changepitch(self);
	}

#ifdef HIPNOTIC
	if (CheckQuad(self.owner))
	{
		self.glow_color = 244;
		self.glow_size = 100;
		self.glow_trail = FALSE;
	}
	else
		self.glow_size = 0;	
#endif
};

/*
================
OgreFireGrenade
================
*/

void(vector atpos, vector targpos) OgreCalcAngle =
{
	local float a, b, c, disc;	// constants in the equation to be solved
	local vector diff;
	local float horz, vert;
	local float grav;

	diff = targpos - atpos;
	vert = diff_z;
	diff_z = 0;
	horz = vlen(diff);

	if (self.gravity <= 0)
		self.gravity = 1.0;

	grav = sv_gravity*self.gravity;

	a = 0.5*grav*pow(horz,2)/pow(OGRE_GRENADE_VELOCITY, 2);
	b = 0 - horz;
	c = a + vert;

	disc = pow(b,2) - 4*a*c;

	self.cnt = disc;

//	self.mangle = VEC_0;
//	self.mangle_z = OGRE_ATTACK_BAD;

	if (disc < 0)
	{
		return;
	}

	else if (disc == 0)
	{
		self.mangle_x = self.mangle_y = RAD2DEG*atan(0 - b/2*a);
		return;
	}
	else
	{
		self.mangle_x = RAD2DEG*atan(0.5*(0 - b + sqrt(disc))/a);
		self.mangle_y = RAD2DEG*atan(0.5*(0 - b - sqrt(disc))/a);
		return;
	}
};


void() OgreAim =
{
	local vector start, end, start2, end2, dif, angle_bak, angle_bak2; 
//	local float attack_angle;	//, r;

//	print("disc=", ftos(self.cnt), " mangle=", vtos(self.mangle), "\n");

	angle_bak = self.mangle;

	start = self.origin + self.view_ofs;
	end = self.enemy.origin;

//	r = random();

//	self.mangle_z = OGRE_ATTACK_BAD;

//	print("attempt start\n");

// try ordinary hit
//	print("trying direct\n");

	OgreCalcAngle(start, end);

	if (self.cnt >= 0)
	{
		self.mangle_z = OGRE_ATTACK_GOOD;
		angle_bak2 = self.mangle;
		if (random() < 0.80)
			return;
	}

// try to hit the feet
//	print("trying feet\n");
	dif_z = self.enemy.mins_z + 1;
	OgreCalcAngle(start, end + dif);

	if (self.cnt >= 0)
	{
		self.mangle_z = OGRE_ATTACK_GOOD;
		angle_bak2 = self.mangle;
		if (random() < 0.5)
			return;
	}

// try to hit the head
//	print("trying head\n");
	dif_z = self.enemy.maxs_z - 1;
	OgreCalcAngle(start, end + dif);

	if (self.cnt >= 0)
	{
		self.mangle_z = OGRE_ATTACK_GOOD;
		angle_bak2 = self.mangle;
		if (random() < 0.6)
			return;
	}

// try to bounce the grenade
//	print("trying bounce\n");

	dif = end - start;
	dif_z = 0;
	dif = normalize(dif);

	start2 = end;
	start2_z = end_z + self.enemy.mins_z;
	end2 = start2;

	
	do
	{
		end2 = end2 - 8*dif;	// + '0 0 -1';

		traceline(start2, end2, MOVE_NORMAL, world);

		if (trace_fraction == 1)
		{
			traceline(end2, end2 + '0 0 -16', MOVE_NORMAL, world);

			if (trace_fraction != 1)
			{
				OgreCalcAngle(start, end2);

				if (self.cnt >= 0)
				{
					self.mangle_z = OGRE_ATTACK_GOOD;
					return;
				}
			}
		}

	} while (vlen(end2 - start2) < 64);


//ensure that we don't lose a good result
	if (angle_bak2_z == OGRE_ATTACK_GOOD)
	{
		self.mangle = angle_bak2;
		self.cnt = 1;
		return;
	}

// last futile attempt

	if (random() > 0.3)
	{
//		print("trying general direction\n");

		dif = end - start;
		dif = normalize(dif);

		start2 = end2 = end;

		do
		{
			end2 = end2 - 32*dif;

			traceline(start2, end2, MOVE_NORMAL, world);

			if (trace_fraction == 1)
			{
					OgreCalcAngle(start, end2);

					if (self.cnt >= 0)
					{
						self.mangle_z = OGRE_ATTACK_FUTILE;
						return;
					}
			}
	
		} while (vlen(end2 - start2) < 384);

	}

// if everything failed, remember previous angle
	if (self.cnt < 0)
	{
//		print("attempt failed\n");
		self.mangle = angle_bak;
		self.mangle_z = OGRE_ATTACK_BAD;
	}
};

float() OgreDecideAttack =
{
	local vector diff;
	local float horz, vert, ang;

	if (self.cnt == 0)
		ang = self.mangle_x;

	else
	{
		diff = self.enemy.origin - self.origin;
		vert = diff_z;
		diff_z = 0;
		horz = vlen(diff);

//		print("horz=", ftos(horz), " vert=", ftos(vert), "\n");

		ang = min(self.mangle_x, self.mangle_y);

		if (random() < 0.03)		
		{
			ang = getrandom2(self.mangle_x, self.mangle_y);
		}

		if ((self.enemy_range > RANGE_MID && random() < 0.4) || (vert > 256 && random() < 0.7) || self.mangle_z == OGRE_ATTACK_FUTILE)
		{
			return max(self.mangle_x, self.mangle_y);
		}

		if (vert > 0 && ang < 5 && random() < 0.3)		
		{
			return getrandom2(self.mangle_x, self.mangle_y);
		}


/*		if (vert > horz)
		{
			if (vert > 64)
				ang = max(self.mangle_x, self.mangle_y);
			else
				ang = min(self.mangle_x, self.mangle_y);
		}

		else if (vert < 0)
		{
			ang = min(self.mangle_x, self.mangle_y);
		}

		else
		{
			ang = max(self.mangle_x, self.mangle_y);

			if (ang > 75)		
				ang = min(self.mangle_x, self.mangle_y);

			if (ang < 5 || random() < 0.1)		
			{
				if (random() > 0.5)
					ang = max(self.mangle_x, self.mangle_y);
				else
					ang = min(self.mangle_x, self.mangle_y);
			}
		}
*/

	}

	return ang;
};


void(float elevation) ogre_grenade =
//void() ogre_grenade =
{
	local entity missile;
	local vector ang, pos;
//	local vector distancedelta; 
//	local vector nozdistancedelta; 
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// set missile speed

/*	makevectors (self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
*/	
	makevectors (self.angles);
	pos = self.origin - 2*v_right + 45*v_forward + 20*v_up;	

	ang = self.angles;
	ang_z = 0;
	ang_x = 0 - elevation;
	ang_x += 4*crandom();
	ang_y += 6*crandom();

	makevectors(ang);
	missile.velocity = v_forward*OGRE_GRENADE_VELOCITY;

/*
// new up-down aware code 
	distancedelta = self.enemy.origin - self.origin - self.view_ofs; 	//work out distance vector  
	nozdistancedelta = distancedelta;  			//copy to no height distance vector 
	
	nozdistancedelta_z = 0;  				//remove height 
	
	missile.velocity = normalize(distancedelta); 		//set the velocity to the distance
	missile.velocity = missile.velocity*600;   		//give it more power 
	
	missile.velocity_z += vlen(nozdistancedelta)*0.70; 	//add extra height for extra distance
// end new up-down aware code
*/

	missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '300 300 300';
	missile.pitch_speed = 10;
	
	missile.touch = OgreGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 0.01;	//2.5;
	missile.think = OgreGrenadeThink;	//OgreGrenadeExplode;
	missile.ltime = time;
	missile.classname = "ogrenade";
	
	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 -4', '0 0 4'); 	//'0 0 0', '0 0 0');	
	setorigin (missile, pos);		//self.origin + self.view_ofs);
};


/*
float(float theta) ogre_tan =
{
	local vector ang; //temporary used to calculate trig values
	ang = '0 0 0';
	ang_y = theta; //assign theta to the yaw to simplify reasoning
	makevectors(ang);
	return v_forward_y / v_forward_x;
};
 
float(float y, float x) ogre_atan2 =
{
	local vector ang; //temporary used to calculate trig values
	ang = '0 0 0';
	ang_x = x;
	ang_y = y;
	return vectoyaw(ang);
};


float(float ang, vector enemy_dest) OgreIterateElevation =
{
	local float a, b, c;	// constants in the equation to be solved
	local vector ofs;	// displacement we wish the projectile to travel
	local float y, z, grav;	// horizontal and vertical components of ofs
	local float ang_tan;	// trig values of the angle theta

	print("angle start: ", ftos(ang), "\n");

//calculate how far we are firing
	ofs = enemy_dest - (self.origin + self.view_ofs);
	z = ofs_z;
	ofs_z = 0;
	y = vlen(ofs);

	if (self.gravity <= 0)
		self.gravity = 1.0;

	grav = sv_gravity*self.gravity;

//	print("gravity: ", ftos(grav), "\n");

//find the coefficients of the quadratic in tan(theta)
	a = 0.5*grav*y*y/(OGRE_GRENADE_VELOCITY*OGRE_GRENADE_VELOCITY);
	b = 0 - y;
	c = a + z;
	
//check if the destination is too far to reach
	if (b*b < 4*a*c)
	{
		print("angle end: default\n");
		return OGRE_DEFAULT_ELEVATION;
	}

//calculate the tan value of the given theta
	ang_tan = ogre_tan(ang);	//tan(DEG2RAD*ang);
	
//reuse ang to create the improved firing direction
	ang = ogre_atan2(a*ang_tan*ang_tan - c, 2*a*ang_tan + b);	//RAD2DEG*atan2(2*a*ang_tan + b, a*ang_tan*ang_tan - c);
	
//constrain the values to stop anything too mad happening
	while (ang > 90)
		ang = ang - 180;

	print("angle end: ", ftos(ang), "\n");

	return ang;
};
*/

/*
================
chainsaw

FIXME
================
*/
void(float side) ogre_chainsaw =
{
	local vector delta;
	local float ldmg, rnum1, rnum2, rnum3;

	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	
	rnum1 = random();
	rnum2 = random();
	rnum3 = random();
	
	ldmg = (rnum1 + rnum2 + rnum3)*4;

	T_Damage (self.enemy, self, self, ldmg, "ogre_melee");
	
	if (side)
	{
		makevectors (self.angles);
		if (side == 1) {
			SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
			rnum1 = random();
			if (rnum1 > 0.6)
				SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
		} else {
			SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
			rnum1 = random();
			if (rnum1 > 0.6)
				SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
		}
	}
};

void() ogre_melee =
{
	local float rnum;
	rnum = random();
	if (rnum > 0.5)
		ogre_smash1 ();
	else
		ogre_swing1 ();
};

//=============================================================================

void() ogre_saw =
{
	sound (self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM);	
};

void() ogre_pull =
{
	if (self.pain_finished <= time)
	{
		ogre_pull1();
		return;
	}

	else if (random() > 0.8)
	{
		ogre_pull1();
		return;
	}

	else	
	{
		ogre_sight();
		HuntTarget();
	}
};

void() ogre_sight =
{
	sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM);
};

void() ogre_drag =
{
	local float r;
	r = random();
	if (r < 0.1)
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);
};

void() ogre_idle =
{
	local float r;

	if (getsoundtime(self, CHAN_VOICE) != -1)
		return;

// ambushing monsters must stay silent
	if (self.spawnflags & SPAWNFLAG_AMBUSH)
		return;

	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
};

void() ogre_active =
{
	if (getsoundtime(self, CHAN_VOICE) != -1)
		return;

	local float r;
	r = random();
	if (r < 0.2)
		sound (self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE);
};

void(entity attacker, float damage) ogre_pain =
{
	local float r;

// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;

	MonsterBubbles(2,4);

	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);	//stop saw sound
	sound (self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM);		

	r = random();
	if (r < 0.25)
	{
		ogre_pain1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.5)
	{
		ogre_painb1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.75)
	{
		ogre_painc1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.88)
	{
		ogre_paind1 ();
		self.pain_finished = time + 2;
	}
	else
	{
		ogre_paine1 ();
		self.pain_finished = time + 2;
	}
};


void() ogre_die =
{
	local float rnum;
	rnum = random();

	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);	//stop saw sound

	MonsterBubbles(20,40);

	sound (self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM);

	if (rnum < 0.5)
		monster_corpse(ogre_die1);
	else
		monster_corpse(ogre_bdie1);
};

void() ogre_backpack =
{
	self.ammo_rockets = 2;
	DropBackpack();
};

void() monster_ogre_precache = 
{
	precache_model ("progs/ogre.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/grenade.mdl");

	precache_sound ("ogre/ogdrag.wav");
	precache_sound ("ogre/ogdth.wav");
	precache_sound ("ogre/ogidle.wav");
	precache_sound ("ogre/ogidle2.wav");
	precache_sound ("ogre/ogpain1.wav");
	precache_sound ("ogre/ogsawatk.wav");
	precache_sound ("ogre/ogwake.wav");
	precache_sound ("misc/null.wav");
};

void() monster_ogre_spawn =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/ogre.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	
	self.max_health = 200;		//200;
	self.corpsehealth = 180;
	self.gib = GIB_LARGE;
	self.headname = "progs/h_ogre.mdl";
	self.gibhealth = -80;
	self.mass = 300;

	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_pain = ogre_pain;
	self.th_gib = monster_gib;
	self.th_sight = ogre_sight;
	
	if (self.spawnflags & (SPAWNFLAG_TRIGGERABLE | SPAWNFLAG_MONSTERFACTORY))
		walkmonster_start_go();
	else
		walkmonster_start();
};

/*QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_ogre =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_ogre_precache();

	if (self.spawnflags & SPAWNFLAG_TRIGGERABLE)
	{
		self.use = monster_ogre_spawn;
		total_monsters = total_monsters + 1;
	}
	else if (self.spawnflags & SPAWNFLAG_MONSTERFACTORY)
	{
		qonquer_set_default_waves();
		self.flags = self.flags | FL_MONSTERFACTORY;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.spawnfactory = monster_ogre_spawn;
	}
	else
	{
		monster_ogre_spawn();
		total_monsters = total_monsters + 1;
	}
};

void() monster_ogre_marksman =
{
	monster_ogre ();
};


