
void () demon1_stand1 = [ 0, demon1_stand2 ]
{
	ai_stand ();
	ai_emnity ("monster_qguy", 1000, 0);
};

void () demon1_stand2 =
{
	if ((random () < 0.1))
	{
		state [ 1, demon1_look ];
		ai_stand ();
		return;
	}
	state [ 1, demon1_stand3 ];
	ai_stand ();
};

void () demon1_stand3 = [ 2, demon1_stand4 ]
{
	ai_stand ();
};

void () demon1_stand4 =
{
	if (ai_emnity ("monster_jagger", 2000, 0))
	{
		demon1_run1 ();
		return;
	}
	state [ 3, demon1_stand5 ];
	ai_stand ();
};

void () demon1_stand5 = [ 4, demon1_stand6 ]
{
	ai_stand ();
	ai_emnity ("monster_qguy", 1000, 0);
};

void () demon1_stand6 = [ 5, demon1_stand7 ]
{
	ai_stand ();
};

void () demon1_stand7 = [ 6, demon1_stand8 ]
{
	ai_stand ();
};

void () demon1_stand8 = [ 7, demon1_stand9 ]
{
	ai_stand ();
};

void () demon1_stand9 = [ 8, demon1_stand10 ]
{
	ai_stand ();
	ai_emnity ("monster_qguy", 1000, 0);
};

void () demon1_stand10 = [ 9, demon1_stand11 ]
{
	ai_stand ();
};

void () demon1_stand11 = [ 10, demon1_stand12 ]
{
	ai_stand ();
};

void () demon1_stand12 =
{
	if ((random () < 0.2))
	{
		state [ 11, demon1_look ];
		ai_stand ();
		return;
	}
	state [ 11, demon1_stand13 ];
	ai_stand ();
};

void () demon1_stand13 =
{
	if ((random () > 0.9))
	{
		state [ 69, demon1_itch2 ];
		return;
	}
	state [ 12, demon1_stand1 ];
	ai_stand ();
};

void () demon_wins =
{
	if ((random () < 0.3))
	{
		demon1_nod ();
		return;
	}
	demon1_stand1 ();
};

void () demon1_walk1 =
{
	if ((self.objekt && (self.objekt.classname == "player")))
	{
		if (ai_checkobjdist (300))
		{
			self.walkframe = 0;
			demon1_boogie ();
			return;
		}
	}
	state [ 13, demon1_walk2 ];
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
	}
	ai_walk (FL_CLIENT);
};

void () demon1_walk2 = [ 14, demon1_walk3 ]
{
	ai_walk (MOVETYPE_TOSS);
	ai_emnity ("monster_qguy", 1000, 0);
};

void () demon1_walk3 = [ 15, demon1_walk4 ]
{
	ai_walk (MOVETYPE_TOSS);
};

void () demon1_walk4 = [ 16, demon1_walk5 ]
{
	ai_walk (MOVETYPE_PUSH);
};

void () demon1_walk5 = [ 17, demon1_walk6 ]
{
	ai_walk (MOVETYPE_STEP);
};

void () demon1_walk6 = [ 18, demon1_walk7 ]
{
	ai_walk (MOVETYPE_TOSS);
	ai_emnity ("monster_qguy", 1000, 0);
};

void () demon1_walk7 = [ 19, demon1_walk8 ]
{
	ai_walk (MOVETYPE_BOUNCE);
};

void () demon1_walk8 =
{
	ai_walk (MOVETYPE_BOUNCE);
	ai_emnity ("monster_qguy", 1000, 0);
	if ((random () > 0.9))
	{
		state [ 20, demon1_search ];
	}
	else
	{
		state [ 20, demon1_walk1 ];
	}
};

void () demon1_run1 =
{
	if (borkfactor1 ())
	{
		return;
	}
	state [ 21, demon1_run2 ];
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
	}
	ai_run (20);
};

void () demon1_run2 = [ 22, demon1_run3 ]
{
	ai_run (15);
};

void () demon1_run3 = [ 23, demon1_run4 ]
{
	ai_run (36);
};

void () demon1_run4 = [ 24, demon1_run5 ]
{
	ai_run (20);
};

void () demon1_run5 = [ 25, demon1_run6 ]
{
	ai_run (15);
};

void () demon1_run6 = [ 26, demon1_run1 ]
{
	ai_run (36);
};

void () demon1_boogie =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		if (self.objekt)
		{
			if (!ai_checkobjdist (300))
			{
				state [ 24, demon1_walk1 ];
				return;
			}
		}
	}
	state [ 21, demon1_boogie ];
	self.frame = (21 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.walkframe == 3))
	{
		ai_objledge ();
	}
	if ((random () < 0.5))
	{
		ai_walk (19);
	}
	else
	{
		ai_walk (30);
	}
};

void () demon1_back =
{
	if ((self.walkframe >= 26))
	{
		self.walkframe = 0;
		self.touch = objekt_touch;
		demon1_stand1 ();
		return;
	}
	state [ 21, demon1_back ];
	self.frame = (26 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_back (10);
};

void () demon1_jump1 =
{
	if ((self.enemy.classname == "monster_jagger"))
	{
		if ((random () < 0.3))
		{
			self.walkframe = 0;
			demon1_jback ();
			return;
		}
	}
	state [ 27, demon1_jump2 ];
	ai_charge (1);
};

void () demon1_jump2 = [ 28, demon1_jump3 ]
{
	ai_charge (1);
};

void () demon1_jump3 = [ 29, demon1_jump4 ]
{
	ai_charge (1);
};

void () demon1_jump4 =
{
//	local vector megadeth;
//	local vector dave;
//	local vector vec;
//	local float num;
//	local float case;

	if (ai2_tracetoss (self.angles, 600, '0 0 250'))
	{
		state [ 30, demon1_jump5 ];
		ai_face ();
		self.origin_z = (self.origin_z + 1);
		self.velocity = ((v_forward * 600) + '0 0 250');
		self.touch = Demon_JumpTouch;
		if ((self.flags & FL_ONGROUND))
		{
			self.flags = (self.flags - FL_ONGROUND);
		}
	}
	else
	{
		state [ 28, demon1_run1 ];
		ai_face ();
	}
};

void () demon1_jump5 = [ 31, demon1_jump6 ]
{
};

void () demon1_jump6 = [ 32, demon1_jump7 ]
{
};

void () demon1_jump7 = [ 33, demon1_jump8 ]
{
};

void () demon1_jump8 = [ 34, demon1_jump9 ]
{
};

void () demon1_jump9 = [ 35, demon1_jump10 ]
{
};

void () demon1_jump10 = [ 36, demon1_jump1 ]
{
	self.nextthink = (time + MOVETYPE_WALK);
};

void () demon1_jump11 = [ 37, demon1_jump12 ]
{
};

void () demon1_jump12 = [ 38, demon1_run1 ]
{
};

void () dalpha_atta1 = [ 126, dalpha_atta2 ]
{
	ai_charge (MOVETYPE_STEP);
};

void () dalpha_atta2 = [ 127, dalpha_atta3 ]
{
	ai_charge (1);
};

void () dalpha_atta3 = [ 128, dalpha_atta4 ]
{
	ai_charge (2);
};

void () dalpha_atta4 = [ 129, dalpha_atta5 ]
{
	ai_charge (5);
};

void () dalpha_atta5 = [ 130, dalpha_atta6 ]
{
	ai_charge (MOVETYPE_STEP);
	Demon_Melee (300);
};

void () dalpha_atta6 = [ 131, dalpha_atta7 ]
{
	ai_charge (FL_SWIM);
};

void () dalpha_atta7 = [ 132, dalpha_atta8 ]
{
	ai_charge (FL_CLIENT);
};

void () dalpha_atta8 = [ 133, dalpha_atta9 ]
{
};

void () dalpha_atta9 = [ 134, demon1_run1 ]
{
	ai_face ();
	Demon_Melee (-200);
};

void () demon1_atta1 = [ 54, demon1_atta2 ]
{
	ai_charge (MOVETYPE_STEP);
};

void () demon1_atta2 = [ 55, demon1_atta3 ]
{
	ai_charge (2);
};

void () demon1_atta3 = [ 56, demon1_atta4 ]
{
	ai_charge (1);
};

void () demon1_atta4 = [ 57, demon1_atta5 ]
{
	ai_charge (1);
};

void () demon1_atta5 = [ 58, demon1_atta6 ]
{
	ai_charge (FL_SWIM);
	Demon_Melee (200);
};

void () demon1_atta6 = [ 59, demon1_atta7 ]
{
	ai_charge (1);
};

void () demon1_atta7 = [ 60, demon1_atta8 ]
{
	ai_charge (MOVETYPE_TOSS);
};

void () demon1_atta8 = [ 61, demon1_atta9 ]
{
	ai_charge (FL_CLIENT);
};

void () demon1_atta9 = [ 62, demon1_atta10 ]
{
	ai_charge (MOVETYPE_STEP);
};

void () demon1_atta10 = [ 63, demon1_atta11 ]
{
	ai_charge (FL_SWIM);
};

void () demon1_atta11 = [ 64, demon1_atta12 ]
{
	Demon_Melee (-200);
};

void () demon1_atta12 = [ 65, demon1_atta13 ]
{
	ai_charge (MOVETYPE_FLY);
};

void () demon1_atta13 = [ 66, demon1_atta14 ]
{
	ai_charge (FL_CLIENT);
};

void () demon1_atta14 =
{
	if ((self.enemy.classname == "monster_jagger"))
	{
		if ((random () < 0.2))
		{
			self.walkframe = 0;
			demon1_jback ();
			return;
		}
	}
	state [ 67, demon1_atta15 ];
	ai_charge (MOVETYPE_STEP);
};

void () demon1_atta15 = [ 68, demon1_run1 ]
{
	ai_charge (MOVETYPE_STEP);
};

void () demon1_itch2 = [ 70, demon1_itch3 ]
{
};

void () demon1_itch3 = [ 71, demon1_itch4 ]
{
	ai_stand ();
};

void () demon1_itch4 = [ 72, demon1_itch5 ]
{
};

void () demon1_itch5 = [ 73, demon1_itch6 ]
{
	ai_stand ();
};

void () demon1_itch6 = [ 74, demon1_itch7 ]
{
	ai_stand ();
};

void () demon1_itch7 = [ 75, demon1_itch8 ]
{
	ai_stand ();
};

void () demon1_itch8 =
{
	if ((random () < 0.7))
	{
		state [ 76, demon1_itch7 ];
	}
	else
	{
		state [ 76, demon1_itch9 ];
	}
};

void () demon1_itch9 = [ 75, demon1_itch10 ]
{
	ai_stand ();
};

void () demon1_itch10 = [ 74, demon1_itch11 ]
{
};

void () demon1_itch11 = [ 72, demon1_itch12 ]
{
	ai_stand ();
};

void () demon1_itch12 = [ 71, demon1_itch13 ]
{
	ai_stand ();
};

void () demon1_itch13 = [ 70, demon1_itch14 ]
{
	ai_stand ();
};

void () demon1_itch14 = [ 69, demon1_stand1 ]
{
	ai_stand ();
};

void () demon1_jback =
{
	if ((self.walkframe >= 12))
	{
		self.walkframe = 0;
		demon1_run1 ();
		return;
	}
	state [ 27, demon1_jback ];
	self.frame = (38 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_face ();
	if ((self.walkframe != 3))
	{
		return;
	}
	makevectors (self.angles);
	self.origin_z = (self.origin_z + 1);
	self.velocity = ((v_forward * -600) + '0 0 250');
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
	}
};

void () demon1_look =
{
	if ((self.walkframe >= 13))
	{
		self.walkframe = 0;
		demon1_stand1 ();
		return;
	}
	state [ 77, demon1_look ];
	self.frame = (77 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () demon1_search =
{
	if ((self.walkframe >= 16))
	{
		self.walkframe = 0;
		demon1_walk1 ();
		return;
	}
	state [ 90, demon1_search ];
	self.frame = (90 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_walk (MOVETYPE_FLY);
	if ((self.walkframe == 5))
	{
		ai_emnity ("monster_jagger", 300, 1);
	}
};

void () demon1_nod =
{
	if ((self.walkframe >= 10))
	{
		self.walkframe = 0;
		demon1_stand1 ();
		return;
	}
	state [ 106, demon1_nod ];
	self.frame = (106 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
	if ((self.objekt != world))
	{
		ai_face_objekt ();
		if ((self.walkframe == 5))
		{
			if ((self.objekt.enemy == self))
			{
				self.objekt.enemy = world;
				self.enemy = self.objekt;
				self.th_missile ();
				return;
			}
		}
	}
	else
	{
		if ((self.goalentity != world))
		{
			ai_face_goal ();
		}
	}
};

void () dalpha_walk =
{
	if ((self.walkframe >= 11))
	{
		self.walkframe = 0;
	}
	state [ 116, dalpha_walk ];
	self.frame = (116 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_walk (MOVETYPE_TOSS);
};

void () dalpha_stand =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
	}
	state [ 136, dalpha_stand ];
	self.frame = (136 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () demon1_pain1 = [ 39, demon1_pain2 ]
{
};

void () demon1_pain2 = [ 40, demon1_pain3 ]
{
};

void () demon1_pain3 = [ 41, demon1_pain4 ]
{
};

void () demon1_pain4 = [ 42, demon1_pain5 ]
{
};

void () demon1_pain5 = [ 43, demon1_pain6 ]
{
};

void () demon1_pain6 = [ 44, demon1_run1 ]
{
};

void (entity attacker, float damage) demon1_pain =
{
	if ((self.touch == Demon_JumpTouch))
	{
		return;
	}
	if ((self.pain_finished > time))
	{
		return;
	}
	self.pain_finished = (time + 1);
	sound (self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM);
	if (((random () * 200) > damage))
	{
		return;
	}
	demon1_pain1 ();
};

void () demon1_die1 = [ 45, demon1_die2 ]
{
	sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
};

void () demon1_die2 = [ 46, demon1_die3 ]
{
};

void () demon1_die3 = [ 47, demon1_die4 ]
{
};

void () demon1_die4 = [ 48, demon1_die5 ]
{
};

void () demon1_die5 = [ 49, demon1_die6 ]
{
};

void () demon1_die6 = [ 50, demon1_die7 ]
{
	self.solid = SOLID_NOT;
};

void () demon1_die7 = [ 51, demon1_die8 ]
{
};

void () demon1_die8 = [ 52, demon1_die9 ]
{
};

void () demon1_die9 = [ 53, corpse_think ]
{
};

void () demon_die =
{
	if ((self.health < -80))
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_demon.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		return;
	}
	demon1_die1 ();
};

void () Demon_MeleeAttack =
{
	if ((self.spawnflags & FL_SWIM))
	{
		if ((random () < 0.4))
		{
			dalpha_atta1 ();
			return;
		}
	}
	demon1_atta1 ();
};

void () monster_demon1 =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	total_monsters = total_monsters + 1;
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");
	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
	if ((self.spawnflags & FL_SWIM))
	{
		self.th_stand = dalpha_stand;
		self.th_walk = dalpha_walk;
		if (!self.health)
		{
			self.health = 375;
		}
	}
	else
	{
		self.th_stand = demon1_stand1;
		self.th_walk = demon1_walk1;
		if (!self.health)
		{
			self.health = 300;
		}
	}
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_wins = demon_wins;
	self.th_melee = Demon_MeleeAttack;
	self.th_missile = demon1_jump1;
	self.th_pain = demon1_pain;
	if ((self.relations > 2))
	{
		self.th_back = demon1_back;
	}
	if ((self.brain & TRIGGER_SPAWN))
	{
		self.use = demon1_start;
		return;
	}
	carnify_demon ();
};

void () demon1_start =
{
	trigger_spawnmonster ();
	carnify_demon ();
};

void () carnify_demon =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/demon.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	walkmonster_start ();
};

float () CheckDemonMelee =
{
	if ((enemy_range == RANGE_MELEE))
	{
		self.attack_state = AS_MELEE;
		return (1);
	}
	return (0);
};

float () CheckDemonJump =
{
	local vector dist;
	local float d;

	if (((self.origin_z + self.mins_z) > ((self.enemy.origin_z + self.enemy.mins_z) + (0.75 * self.enemy.size_z))))
	{
		return (0);
	}
	if (((self.origin_z + self.maxs_z) < ((self.enemy.origin_z + self.enemy.mins_z) + (0.25 * self.enemy.size_z))))
	{
		return (0);
	}
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	d = vlen (dist);
	if ((d < 100))
	{
		return (0);
	}
	if ((d > 200))
	{
		if ((random () < 0.9))
		{
			return (0);
		}
	}
	return (1);
};

float () DemonCheckAttack =
{
//	local vector vec;

	if (CheckDemonMelee ())
	{
		self.attack_state = AS_MELEE;
		return (1);
	}
	if (CheckDemonJump ())
	{
		if (ai2_tracetoss (self.angles, 600, '0 0 250'))
		{
			self.attack_state = AS_MISSILE;
			sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);
			return (1);
		}
	}
	return (0);
};

void (float side) Demon_Melee =
{
	local float ldmg;
	local vector delta;

	ai_face ();
	walkmove (self.ideal_yaw, 12);
	delta = self.enemy.origin - self.origin;
	if ((vlen (delta) > 100))
	{
		return;
	}
	if (!CanDamage (self.enemy, self))
	{
		return;
	}
	if ((self.classname == "monster_baron"))
	{
		sound (self, CHAN_WEAPON, "baron/smash.wav", 1, ATTN_NORM);
		ldmg = MOVETYPE_BOUNCE + (MOVETYPE_BOUNCEMISSILE * random ());
		SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)), ((side * -1) * v_right));
	}
	else
	{
		sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
		ldmg = MOVETYPE_BOUNCE + (MOVETYPE_FLY * random ());
	}
	ldmg = MOVETYPE_BOUNCE + (MOVETYPE_FLY * random ());
	T_Damage (self.enemy, self, self, ldmg);
	makevectors (self.angles);
	SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)), (side * v_right));
};

void () Demon_JumpTouch =
{
	local float ldmg;

	if ((self.health <= 0))
	{
		return;
	}
	if ((other.classname == self.classname))
	{
		return;
	}
	if (other.takedamage)
	{
		if ((vlen (self.velocity) > 400))
		{
			ldmg = 40 + (MOVETYPE_BOUNCE * random ());
			T_Damage (other, self, self, ldmg);
		}
	}
	if (!checkbottom (self))
	{
		if ((self.flags & FL_ONGROUND))
		{
			self.touch = SUB_Null;
			self.think = demon1_jump1;
			self.nextthink = (time + 0.1);
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = demon1_jump11;
	self.nextthink = (time + 0.1);
};
