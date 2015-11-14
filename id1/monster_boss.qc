/*
==============================================================================

BOSS-ONE

==============================================================================
*/
$cd id1/models/boss1
$origin 0 0 -15
$base base
$skin skin
$scale 5
$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23

$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10 

$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6

$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8 
$frame shockc9 shockc10


void(vector p) boss_missile;
void() boss_face;
void() boss_face2;
float() boss_findtargetidle;  
float() boss_findtarget;
void(entity attacker, float damage) boss_head_pain;
void() boss_throwhead;
void() ChthonMissileTouch;

void() boss_rise1	=[	$rise1,  	boss_rise2 	] {sound (self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);};
void() boss_rise2	=[	$rise2,  	boss_rise3 	] {sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);};
void() boss_rise3	=[	$rise3,  	boss_rise4 	] {};
void() boss_rise4	=[	$rise4,  	boss_rise5 	] {};
void() boss_rise5	=[	$rise5,  	boss_rise6 	] {};
void() boss_rise6	=[	$rise6,  	boss_rise7 	] {};
void() boss_rise7	=[	$rise7,  	boss_rise8 	] {};
void() boss_rise8	=[	$rise8,  	boss_rise9 	] {};
void() boss_rise9	=[	$rise9,  	boss_rise10 	] {};
void() boss_rise10	=[	$rise10, 	boss_rise11 	] {};
void() boss_rise11	=[	$rise11, 	boss_rise12 	] {};
void() boss_rise12	=[	$rise12, 	boss_rise13	] {};
void() boss_rise13	=[	$rise13, 	boss_rise14 	] {};
void() boss_rise14	=[	$rise14, 	boss_rise15 	] {};
void() boss_rise15	=[	$rise15, 	boss_rise16 	] {};
void() boss_rise16	=[	$rise16, 	boss_rise17 	] {};
void() boss_rise17	=[	$rise17, 	boss_missile1 	] {};


void() boss_idle1	=[	$walk1,  	boss_idle2 	] {};
void() boss_idle2	=[	$walk2,  	boss_idle3 	] {boss_face();};
void() boss_idle3	=[	$walk3,  	boss_idle4 	] {boss_face2();};
void() boss_idle4	=[	$walk4,  	boss_idle5 	] {boss_face();};
void() boss_idle5	=[	$walk5,  	boss_idle6 	] {boss_face2();};
void() boss_idle6	=[	$walk6,  	boss_idle7 	] {boss_face();};
void() boss_idle7	=[	$walk7,  	boss_idle8 	] {boss_face2();};
void() boss_idle8	=[	$walk8,  	boss_idle9 	] {boss_face();};
void() boss_idle9	=[	$walk9,  	boss_idle10 	] {boss_face2();};
void() boss_idle10	=[	$walk10, 	boss_idle11 	] {boss_face();};
void() boss_idle11	=[	$walk11, 	boss_idle12 	] {boss_face2();};
void() boss_idle12	=[	$walk12, 	boss_idle13 	] {boss_face();};
void() boss_idle13	=[	$walk13, 	boss_idle14 	] {boss_face2();};
void() boss_idle14	=[	$walk14, 	boss_idle15 	] {boss_face();};
void() boss_idle15	=[	$walk15, 	boss_idle16 	] {boss_face2();};
void() boss_idle16	=[	$walk16, 	boss_idle17 	] {boss_face();};
void() boss_idle17	=[	$walk17, 	boss_idle18 	] {boss_face2();};
void() boss_idle18	=[	$walk18, 	boss_idle19 	] {boss_face();};
void() boss_idle19	=[	$walk19, 	boss_idle20 	] {boss_face2();};
void() boss_idle20	=[	$walk20, 	boss_idle21 	] {boss_face();};
void() boss_idle21	=[	$walk21, 	boss_idle22 	] {boss_face2();};
void() boss_idle22	=[	$walk22, 	boss_idle23 	] {boss_face();};
void() boss_idle23	=[	$walk23, 	boss_idle24 	] {boss_face2();};
void() boss_idle24	=[	$walk24, 	boss_idle25 	] {boss_face();};
void() boss_idle25	=[	$walk25, 	boss_idle26 	] {boss_face2();};
void() boss_idle26	=[	$walk26, 	boss_idle27 	] {boss_face();};
void() boss_idle27	=[	$walk27, 	boss_idle28 	] {boss_face2();};
void() boss_idle28	=[	$walk28, 	boss_idle29 	] {boss_face();};
void() boss_idle29	=[	$walk29, 	boss_idle30 	] {boss_face2();};
void() boss_idle30	=[	$walk30, 	boss_idle31 	] {boss_face();};
void() boss_idle31	=[	$walk31, 	boss_idle1 	] {boss_face2();};


void() boss_missile1	=[	$attack1,  	boss_missile2  	] {boss_face();};
void() boss_missile2	=[	$attack2,  	boss_missile3  	] {boss_face();};
void() boss_missile3	=[	$attack3,  	boss_missile4  	] {boss_face();};
void() boss_missile4	=[	$attack4,  	boss_missile5  	] {boss_face();};
void() boss_missile5	=[	$attack5,  	boss_missile6  	] {boss_face();};
void() boss_missile6	=[	$attack6,  	boss_missile7  	] {boss_face();};
void() boss_missile7	=[	$attack7,  	boss_missile8  	] {boss_face();};
void() boss_missile8	=[	$attack8,  	boss_missile9  	] {boss_face();};
void() boss_missile9	=[	$attack9,  	boss_missile10 	] {boss_missile('100 100 200');};
void() boss_missile10	=[	$attack10, 	boss_missile11 	] {boss_face();};
void() boss_missile11	=[	$attack11, 	boss_missile12 	] {boss_face();};
void() boss_missile12	=[	$attack12, 	boss_missile13 	] {boss_face();};
void() boss_missile13	=[	$attack13, 	boss_missile14 	] {boss_face();};
void() boss_missile14	=[	$attack14, 	boss_missile15 	] {boss_face();};
void() boss_missile15	=[	$attack15, 	boss_missile16 	] {boss_face();};
void() boss_missile16	=[	$attack16, 	boss_missile17 	] {boss_face();};
void() boss_missile17	=[	$attack17, 	boss_missile18 	] {boss_face();};
void() boss_missile18	=[	$attack18, 	boss_missile19 	] {boss_face();};
void() boss_missile19	=[	$attack19, 	boss_missile20 	] {boss_face();};
void() boss_missile20	=[	$attack20, 	boss_missile21 	] {boss_missile('100 -100 200');};
void() boss_missile21	=[	$attack21, 	boss_missile22 	] {boss_face();};
void() boss_missile22	=[	$attack22, 	boss_missile23 	] {boss_face();};
void() boss_missile23	=[	$attack23, 	boss_missile1  	] {boss_face();};


void() boss_shocka1 	=[	$shocka1,  	boss_shocka2  	] {};
void() boss_shocka2 	=[	$shocka2,  	boss_shocka3  	] {};
void() boss_shocka3 	=[	$shocka3,  	boss_shocka4  	] {};
void() boss_shocka4 	=[	$shocka4,  	boss_shocka5  	] {};
void() boss_shocka5 	=[	$shocka5,  	boss_shocka6  	] {};
void() boss_shocka6 	=[	$shocka6, 	boss_shocka7  	] {};
void() boss_shocka7 	=[	$shocka7, 	boss_shocka8  	] {};
void() boss_shocka8 	=[	$shocka8,  	boss_shocka9  	] {};
void() boss_shocka9 	=[	$shocka9,  	boss_shocka10 	] {};
void() boss_shocka10 	=[	$shocka10, 	boss_missile1 	] {};


void() boss_shockb1 	=[	$shockb1, 	boss_shockb2 	] {};
void() boss_shockb2 	=[	$shockb2, 	boss_shockb3 	] {};
void() boss_shockb3	=[	$shockb3, 	boss_shockb4 	] {};
void() boss_shockb4 	=[	$shockb4, 	boss_shockb5 	] {};
void() boss_shockb5 	=[	$shockb5, 	boss_shockb6 	] {};
void() boss_shockb6 	=[	$shockb6, 	boss_shockb7 	] {};
void() boss_shockb7 	=[	$shockb1, 	boss_shockb8 	] {};
void() boss_shockb8 	=[	$shockb2, 	boss_shockb9 	] {};
void() boss_shockb9 	=[	$shockb3, 	boss_shockb10 	] {};
void() boss_shockb10 	=[	$shockb4, 	boss_missile1 	] {};


void() boss_shockc1 	=[	$shockc1,  	boss_shockc2  	] {};
void() boss_shockc2 	=[	$shockc2,  	boss_shockc3  	] {};
void() boss_shockc3 	=[	$shockc3,  	boss_shockc4  	] {};
void() boss_shockc4 	=[	$shockc4,  	boss_shockc5  	] {};
void() boss_shockc5 	=[	$shockc5,  	boss_shockc6  	] {};
void() boss_shockc6 	=[	$shockc6,  	boss_shockc7  	] {};
void() boss_shockc7 	=[	$shockc7,  	boss_shockc8  	] {};
void() boss_shockc8 	=[	$shockc8,  	boss_shockc9  	] {};
void() boss_shockc9 	=[	$shockc9,  	boss_shockc10 	] {};
void() boss_shockc10 	=[	$shockc10, 	boss_death1	] {};


void() boss_flinch1 	=[ 	$shockc1, 	boss_flinch2 	] {};
void() boss_flinch2 	=[ 	$shockc2, 	boss_flinch3 	] {};
void() boss_flinch3 	=[ 	$shockc3, 	boss_flinch4 	] {};
void() boss_flinch4 	=[ 	$shockc4, 	boss_missile1 	] {};


void() boss_death1 	=[	$death1, 	boss_death2	] {};
void() boss_death2 	=[	$death2, 	boss_death3	] {};
void() boss_death3 	=[	$death3, 	boss_death4	] {};
void() boss_death4 	=[	$death4, 	boss_death5	] {};
void() boss_death5 	=[	$death5, 	boss_death6	] {};
void() boss_death6 	=[	$death6, 	boss_death7	] {};
void() boss_death7 	=[	$death7, 	boss_death8	] {};
void() boss_death8 	=[	$death8, 	boss_death9	] {};
void() boss_death9 	=[	$death9, 	boss_death10	]
{
	sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
	te_lavasplash(self.origin);
};
void() boss_death10 	=[	$death9, 	boss_death10	]
{
	killed_monsters = killed_monsters + 1;
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER);		// FIXME: reliable broadcast
	SUB_UseTargets ();
	remove (self);
};

//===========================================================================

void() boss_face =
{
	local float r;
// go for another player if multiplayer
	if (coop)
	{
		r = random();
		if ((self.enemy.health <= 0) || (self.enemy.flags & FL_CORPSE) || (r < 0.01))
		{
			self.enemy = find(self.enemy, classname, "player");
			if (!self.enemy)
				self.enemy = find(self.enemy, classname, "player");
		}
	}
		ai_face();
};


void() boss_face2 =    // for idle Boss
{
	if(self.enemy != world)
		boss_missile1();
	else
		boss_findtargetidle();  //fixes animation problems
};

//=============================================================================

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() BossCheckAttack =
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

void(vector p) boss_missile =
{
	local	vector	offang;
	local	vector	org, vec, d;
	local	float	t;

	offang = vectoangles (self.enemy.origin - self.origin);	
	makevectors (offang);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	
// lead the player on hard mode
	if (skill > SKILL_NORMAL)
	{
		t = vlen(self.enemy.origin - org) / 300;
		vec = self.enemy.velocity;
		vec_z = 0;
		d = self.enemy.origin + t * vec;		
	}
	else
	{
		d = self.enemy.origin;
	}
	
	vec = normalize (d - org);

	launch_spike (org, vec);
	setmodel (newmis, "progs/lavaball.mdl");
	newmis.classname = "boss_spike";
	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*300;
	newmis.touch = ChthonMissileTouch; // rocket explosion
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

// check for dead enemy
	if (self.enemy.health <= 0 || self.enemy.flags & FL_CORPSE)
		boss_findtarget ();   // look around
};

void() ChthonMissileTouch =
{
	local float damg;
//	local vector vel;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100 + random()*20;
	
	if (other.health > 0)
	{
		if (other.classname == "monster_shambler")
			damg = damg*0.5;	// mostly immune

		T_Damage (other, self, self.owner, damg, "chthon_ball");

		SpawnBlood_Expl(other, self.velocity, damg);
	}

	T_RadiusDamage (self, self.owner, 120, other, "chthon_splash");

	self.origin = self.origin - 8*normalize(self.velocity);

	te_explosion(self.origin);		

	BecomeExplosion ();
};


void() boss_awake =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_AIM;
	self.mass = EXTRA_HIGH;
	self.flags = self.flags | FL_NOBREATH | FL_NOSLIMEDMG | FL_NOLAVADMG;
	
	setmodel (self, "progs/boss.mdl");
	setsize (self, '-128 -128 -24', '128 128 256');

	if (skill == SKILL_EASY)
		self.health = 2500;	// 1
	else
		self.health = 7500;	// 3

	self.gibhealth = -80;
	self.max_health = self.health;

	self.enemy = activator;

	te_lavasplash(self.origin);

	self.yaw_speed = 20;
	boss_rise1 ();
};

//===========================================================================

void(entity attacker, float damage) boss_pain =
{
	local float r;

// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;

	r = random();
	
	if (r < 0.15 && attacker.classname != "monster_boss")
	{
		sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
		self.pain_finished = time + 5;
//		ThrowGib ("progs/gib1.mdl", -200*random(), VEC_0);
//		ThrowGib ("progs/gib2.mdl", -200*random(), VEC_0);
//		ThrowGib ("progs/gib3.mdl", -200*random(), VEC_0);
		boss_flinch1 ();
		self.enemy = attacker;
	}
	else
	{
		self.enemy = attacker;  			// pissed off at who hurt him

		if (self.enemy.classname == "monster_boss")	// don't get mad at self
			boss_findtarget();  			// leave nothing within radius alive!

		if (self.enemy == world)
			boss_missile1();
	}
};

void() boss_head_twitch =
{
	local vector org, org2, ang;

	if (self.health <= 0)
		return;

	ang = 10*crandom()*randomvec();
	
	org2 = self.origin;
	org = self.origin + 1*crandom()*randomvec();
	org_z = org2_z;

	self.origin = org;	
	self.angles = ang;

	self.nextthink = time + 0.1*random();
};

void(entity attacker, float damage) boss_head_pain =
{
	local vector v;
	local float r, dm;

//	x = '1 0 0';
//	y = '0 1 0';
//	v = x*(50 - 100*random()) + y*(50 - 100*random());

	v = '100 0 0'*crandom() + '0 100 0'*crandom() + '0 0 100'*crandom();
	dm = 2*damage;
	r = random();

	if (r < 0.8)                 
	   SpawnMeatSpray(self.origin + '0 0 32', v);
	else if (r < 0.3)
		ThrowGib("progs/gib1.mdl", dm, v);
	else if (r < 0.5)
		ThrowGib("progs/gib2.mdl", dm, v);
	else 
		ThrowGib("progs/gib3.mdl", dm, v);

	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);
	self.pain_finished = time + 1.5;
};      

void() boss_head_explode =
{
	self.think = SUB_Null;
	self.nextthink = -1;

	self.takedamage = DAMAGE_NO;
	T_RadiusDamage (self, self, 160, world, "chthon_splash");

//	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
//	particle (self.origin, '0 0 0', 75, 255);
	te_explosion(self.origin);

	BecomeExplosion ();
};


void() boss_head_die =
{
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	local float c;

	setorigin(self, self.origin);
	setmodel(self, "");
	self.origin_z = self.origin_z + 50;

	c = 1;               
	while (c < 6)
	{
		ThrowGib ("progs/gib1.mdl", self.health - 100*random(), VEC_0);
		ThrowGib ("progs/gib2.mdl", self.health - 100*random(), VEC_0);
		ThrowGib ("progs/gib3.mdl", self.health - 100*random(), VEC_0);
		c= c + 1;
	}

	self.nextthink = time + 0.1;
	self.think = boss_head_explode;

};

void(string headgib, float damage, float gibtype) boss_behead =
{
	local float c;
	
	sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);

	self.origin_z = self.origin_z + 50;

	// reduce while if edicts error occurs
	c = 1;
	while (c < 15)
	{
		ThrowGib("progs/gib1.mdl", 2*damage, self.dest);
		ThrowGib("progs/gib2.mdl", 2*damage, self.dest);
		ThrowGib("progs/gib3.mdl", 2*damage, self.dest);
		c= c + 1;
	}

	boss_throwhead ();

	killed_monsters = killed_monsters + 1;
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER); // FIXME: reliable broadcast
	SUB_UseTargets ();

};

void() boss_throwhead =
{
	setmodel(self, "progs/h_boss.mdl");
	setsize (self, '-40 -40 0', '40 40 80');
//	setsize (self, '-48 -48 0', '48 48 100');
	setorigin(self, self.origin);

//	self.origin_z = self.origin_z + 50;

	self.velocity = VelocityForDamage(2*self.health, self.dest);
	self.avelocity = crandom()* '0 600 0';
	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_AIM; 

	if (skill == SKILL_EASY)
		self.health = 500;
	else
		self.health = 1500;	//185;

	self.gibhealth = EXTRA_LOW;
	self.mass = 5000;

	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_pain = boss_head_pain;
	self.th_die = boss_head_die;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_gib = SUB_Null;
	self.touch = SUB_Null;	
	self.think = boss_head_twitch;
	self.nextthink = time + 0.1;
//	self.think = SUB_Null;
//	self.nextthink = -1;

	self.frame = 0;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};


void() boss_die =
{
//	local float c;

// regular death
/*	c = 1;
	while (c < 3)
	{
		ThrowGib ("progs/gib1.mdl", -180, VEC_0);
		ThrowGib ("progs/gib2.mdl", -180, VEC_0);
		ThrowGib ("progs/gib3.mdl", -180, VEC_0);
		c = c + 1;
	}
*/
	sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);

	boss_death1 ();
};


float() boss_findtarget =   	//"Borrowed" from BPlayer Bot
{
	local entity head, selected;
	local float dist;
	dist = 1000;    	// awareness radius of boss 
	selected = world;

	head = findradius(self.origin, dist);
	while(head)
	{
		if ((head.health > 0) && (head != self))
			selected = head;
		head = head.chain;
	}
	self.enemy = selected;
		
	if (self.enemy == world)
		boss_idle1();   //Just hang out
	else
	{
		sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
		boss_face();    //Look at your opponent
		return TRUE;
	}
};

float() boss_findtargetidle =   
{
	local entity head, selected;
	local float dist;
	dist = 1000;    	// awareness radius of boss 
	selected = world;

	head = findradius(self.origin, dist);
	while(head)
	{
		if ((head.health > 0) && (head != self))
			selected = head;
		head = head.chain;
	}
	self.enemy = selected;
		
	if (self.enemy == world)
		return FALSE;
	else
	{
		sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
		boss_face();    //Look at your opponent
		return TRUE;
	}
};


void() boss_stand =
{
	if (boss_findtarget ())
		return;
      
	self.th_stand ();
};


//=============================================================

void() monster_boss_precache =
{
	precache_model ("progs/boss.mdl");
	precache_model ("progs/lavaball.mdl");
	precache_model ("progs/h_boss.mdl");

	precache_sound ("player/udeath.wav");
	precache_sound ("weapons/rocket1i.wav");
	precache_sound ("boss1/out1.wav");
	precache_sound ("boss1/sight1.wav");
	precache_sound ("misc/power.wav");
	precache_sound ("boss1/throw.wav");
	precache_sound ("boss1/pain.wav");
	precache_sound ("boss1/death.wav");
};


/*QUAKED monster_boss (1 0 0) (-128 -128 -24) (128 128 256)
*/
void() monster_boss =
{
	if (deathmatch || cvar("nomonsters"))
	{
		remove(self);
		return;
	}

	monster_boss_precache();

	total_monsters = total_monsters + 1;

	self.use = boss_awake;
	self.th_die = boss_die;
	self.th_pain = boss_pain;
	self.th_stand = boss_stand;
	self.th_gib = boss_behead;
};

//===========================================================================

void() lightning_fire =
{
	local vector p1, p2;
	
	if (time >= lightning_end)
	{	// done here, put the terminals back up
		self = le1;
		door_go_down ();
		self = le2;
		door_go_down ();
		return;
	}
	
	p1 = (le1.mins + le1.maxs) * 0.5;
	p1_z = le1.absmin_z - 16;
	
	p2 = (le2.mins + le2.maxs) * 0.5;
	p2_z = le2.absmin_z - 16;
	
	// compensate for length of bolt
	p2 = p2 - normalize(p2-p1)*100;

	self.nextthink = time + 0.1;
	self.think = lightning_fire;

 	te_lightning3(world, p1, p2);
};

void() lightning_use =
{
	if (lightning_end >= time + 1)
		return;

	le1 = find(world, target, "lightning");
	le2 = find(le1, target, "lightning");

	if (!le1 || !le2)
	{
		dprint ("missing lightning targets\n");
		return;
	}
	
	if (
	     	(le1.state != STATE_TOP && le1.state != STATE_BOTTOM) || 
	     	(le2.state != STATE_TOP && le2.state != STATE_BOTTOM) ||
		(le1.state != le2.state)
	   )
	{
//		dprint ("not aligned\n");
		return;
	}

// don't let the electrodes go back up until the bolt is done
	le1.nextthink = -1;
	le2.nextthink = -1;
	lightning_end = time + 1;

	sound (self, CHAN_VOICE, "misc/power.wav", 1, ATTN_NORM);
	lightning_fire ();		

// advance the boss pain if down
	self = find (world, classname, "monster_boss");

	if (!self)
		return;
	self.enemy = activator;

	if (le1.state == STATE_TOP && self.health > 0)
	{
		sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);
		T_Damage (self, world, activator, (1/3)*self.max_health + 1, "");
//		self.health = self.health - 2500;				// -1

		if (self.model == "progs/h_boss.mdl")	//gibbed already
			return;
		else if (self.health >= ((2/3)*self.max_health + 1))		// >= 2
			boss_shocka1();
		else if (self.health >= ((1/3)*self.max_health + 1))		// == 1
			boss_shockb1();
		else if (self.health >= 0)
			boss_shockc1();
	}	
};


/*QUAKED event_lightning (0 1 1) (-16 -16 -16) (16 16 16)
Just for boss level.
*/
void() event_lightning =
{
	self.use = lightning_use;
};
