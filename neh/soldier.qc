
void () army_stand1 = [ 0, army_stand2 ]
{
	ai_stand ();
};

void () army_stand2 = [ 1, army_stand3 ]
{
	ai_stand ();
	ai_emnity ("monster_qguy", 2000, 0);
};

void () army_stand3 = [ 2, army_stand4 ]
{
	ai_stand ();
};

void () army_stand4 = [ 3, army_stand5 ]
{
	ai_stand ();
};

void () army_stand5 = [ 4, army_stand6 ]
{
	ai_stand ();
};

void () army_stand6 = [ 5, army_stand7 ]
{
	ai_stand ();
};

void () army_stand7 = [ 6, army_stand8 ]
{
	ai_stand ();
};

void () army_stand8 =
{
	if ((self.impulse == 10))
	{
		self.cnt = 0;
		state [ 7, army_lleft1 ];
		ai_stand ();
		return;
	}
	self.cnt = (self.cnt + 1);
	if ((self.cnt > 5))
	{
		if ((random () < 0.2))
		{
			self.cnt = 0;
			if ((random () < 0.5))
			{
				state [ 7, army_lleft1 ];
				ai_stand ();
				return;
			}
			state [ 7, army_lright1 ];
			ai_stand ();
			return;
		}
	}
	state [ 7, army_stand1 ];
	ai_stand ();
};

void () army_lleft1 = [ 128, army_lleft2 ]
{
	ai_stand ();
};

void () army_lleft2 = [ 129, army_lleft3 ]
{
	ai_stand ();
};

void () army_lleft3 = [ 130, army_lleft4 ]
{
	ai_stand ();
};

void () army_lleft4 = [ 129, army_lleft5 ]
{
	ai_stand ();
};

void () army_lleft5 =
{
	if ((self.impulse == 10))
	{
		state [ 128, army_lright1 ];
		ai_stand ();
		return;
	}
	state [ 128, army_stand1 ];
	ai_stand ();
};

void () army_lright1 = [ 131, army_lright2 ]
{
	ai_stand ();
};

void () army_lright2 = [ 132, army_lright3 ]
{
	ai_stand ();
};

void () army_lright3 = [ 133, army_lright4 ]
{
	ai_stand ();
};

void () army_lright4 = [ 132, army_lright5 ]
{
	ai_stand ();
};

void () army_lright5 =
{
	if ((self.impulse == 10))
	{
		self.cnt = (self.cnt + 1);
		if ((self.cnt < 3))
		{
			state [ 131, army_lleft1 ];
			ai_stand ();
			return;
		}
	}
	self.cnt = 0;
	self.impulse = 0;
	state [ 131, army_stand1 ];
	ai_stand ();
	return;
};

void () army_walk1 =
{
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
	}
	if ((self.objekt && (self.objekt.classname == "player")))
	{
		if (ai_checkobjdist (300))
		{
			self.walkframe = 0;
			army_boogie ();
			return;
		}
	}
	state [ 90, army_walk2 ];
	ai_walk (1);
};

void () army_walk2 = [ 91, army_walk3 ]
{
	ai_walk (1);
};

void () army_walk3 = [ 92, army_walk4 ]
{
	ai_walk (1);
};

void () army_walk4 = [ 93, army_walk5 ]
{
	ai_walk (1);
};

void () army_walk5 = [ 94, army_walk6 ]
{
	ai_walk (FL_SWIM);
};

void () army_walk6 = [ 95, army_walk7 ]
{
	ai_walk (MOVETYPE_WALK);
};

void () army_walk7 = [ 96, army_walk8 ]
{
	ai_walk (MOVETYPE_STEP);
	ai_emnity ("monster_qguy", 2000, 0);
};

void () army_walk8 = [ 97, army_walk9 ]
{
	ai_walk (MOVETYPE_STEP);
};

void () army_walk9 = [ 98, army_walk10 ]
{
	ai_walk (FL_SWIM);
};

void () army_walk10 = [ 99, army_walk11 ]
{
	ai_walk (FL_SWIM);
};

void () army_walk11 = [ 100, army_walk12 ]
{
	ai_walk (FL_SWIM);
};

void () army_walk12 = [ 101, army_walk13 ]
{
	ai_walk (1);
};

void () army_walk13 = [ 102, army_walk14 ]
{
	ai_walk (0);
};

void () army_walk14 = [ 103, army_walk15 ]
{
	ai_walk (1);
};

void () army_walk15 = [ 104, army_walk16 ]
{
	ai_walk (1);
};

void () army_walk16 = [ 105, army_walk17 ]
{
	ai_walk (1);
};

void () army_walk17 = [ 106, army_walk18 ]
{
	ai_walk (MOVETYPE_WALK);
};

void () army_walk18 = [ 107, army_walk19 ]
{
	ai_walk (MOVETYPE_WALK);
};

void () army_walk19 = [ 108, army_walk20 ]
{
	ai_walk (MOVETYPE_WALK);
};

void () army_walk20 = [ 109, army_walk21 ]
{
	ai_walk (MOVETYPE_WALK);
};

void () army_walk21 = [ 110, army_walk22 ]
{
	ai_walk (FL_SWIM);
};

void () army_walk22 = [ 111, army_walk23 ]
{
	ai_walk (1);
};

void () army_walk23 = [ 112, army_walk24 ]
{
	ai_walk (1);
};

void () army_walk24 = [ 113, army_walk1 ]
{
	ai_walk (1);
};

void () army_onground1 = [ 114, army_onground2 ]
{
	self.cnt = (self.cnt + 1);
};

void () army_onground2 =
{
	if ((self.cnt > 10))
	{
		self.cnt = 0;
		self.th_pain = army_pain;
		self.th_die = army_die;
		self.th_run = army_run1;
		state [ 114, army_painb7 ];
		return;
	}
	if ((random () > 0.9))
	{
		state [ 115, army_ongdie ];
		return;
	}
	state [ 115, army_onground1 ];
};

void () army_ongdie =
{
	if ((self.health < -35))
	{
		army_die ();
		return;
	}
	self.health = 0;
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
	}
	self.solid = SOLID_NOT;
	if (((random () < 0.5) || (self.health > 0)))
	{
		state [ 115, army_flop1 ];
	}
	else
	{
		state [ 115, army_deth ];
	}
};

void () army_flop1 = [ 116, army_flop2 ]
{
	army_dropbackpack ();
};

void () army_flop2 = [ 117, army_flop3 ]
{
};

void () army_flop3 = [ 118, army_flop4 ]
{
};

void () army_flop4 = [ 119, army_flop5 ]
{
};

void () army_flop5 = [ 120, army_flop6 ]
{
};

void () army_flop6 = [ 121, army_flop7 ]
{
};

void () army_flop7 = [ 122, army_flop8 ]
{
};

void () army_flop8 = [ 123, army_flop9 ]
{
};

void () army_flop9 = [ 124, army_flop10 ]
{
};

void () army_flop10 = [ 124, army_flop11 ]
{
};

void () army_flop11 = [ 124, corpse_think ]
{
};

void () army_deth = [ 125, army_deth2 ]
{
	army_dropbackpack ();
};

void () army_deth2 = [ 126, army_deth3 ]
{
};

void () army_deth3 = [ 127, corpse_think ]
{
};

void () army_run1 =
{
	if (borkfactor1 ())
	{
		return;
	}
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
	}
	if ((self.classname != "monster_army3"))
	{
		if (visible (self.enemy))
		{
			if ((random () < 0.7))
			{
				self.attack_finished = (time + 0.8);
				army_runshot1 ();
				return;
			}
		}
	}
	state [ 73, army_run2 ];
	ai3_run (MOVETYPE_BOUNCEMISSILE);
};

void () army_run2 = [ 74, army_run3 ]
{
	ai3_run (15);
};

void () army_run3 = [ 75, army_run4 ]
{
	ai3_run (MOVETYPE_BOUNCE);
};

void () army_run4 = [ 76, army_run5 ]
{
	ai3_run (MOVETYPE_BOUNCE);
};

void () army_run5 = [ 77, army_run6 ]
{
	ai3_run (FL_CLIENT);
};

void () army_run6 = [ 78, army_run7 ]
{
	ai3_run (15);
};

void () army_run7 = [ 79, army_run8 ]
{
	ai3_run (MOVETYPE_BOUNCE);
};

void () army_run8 = [ 80, army_run1 ]
{
	ai3_run (FL_CLIENT);
};

void () army_boogie =
{
	if ((self.walkframe >= 8))
	{
		self.walkframe = 0;
		if (self.objekt)
		{
			if (!ai_checkobjdist (200))
			{
				state [ 73, army_walk1 ];
				return;
			}
		}
	}
	state [ 73, army_boogie ];
	self.frame = (73 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	if ((self.walkframe == 5))
	{
		ai_objledge ();
	}
	if ((random () < 0.5))
	{
		ai_walk (12);
	}
	else
	{
		ai_walk (17);
	}
};

void () army_atk1 =
{
	local vector megadeth;
	local float diff;

	if (borkfactor1 ())
	{
		return;
	}
	state [ 81, army_atk2 ];
	ai_face ();
	ai_threats ();
	megadeth = self.enemy.origin - self.origin;
	if ((vlen (megadeth) > 120))
	{
		self.impulse = 11;
	}
};

void () army_atk2 = [ 82, army_atk3 ]
{
	local float diff;

	ai_face ();
	if ((self.impulse == 11))
	{
		if ((self.classname != "monster_army2"))
		{
			return;
		}
		diff = self.enemy.origin_z - self.origin_z;
		if ((self.origin_z < self.enemy.origin_z))
		{
			if ((self.flags & FL_ONGROUND))
			{
				self.origin_z = (self.origin_z + 1);
				self.velocity_z = 300;
				self.velocity = (v_forward * -350);
				self.flags = (self.flags - FL_ONGROUND);
				return;
			}
		}
		else
		{
			if (((self.flags & FL_ONGROUND) && (diff < 120)))
			{
				self.flags = (self.flags - FL_ONGROUND);
				self.origin_z = (self.origin_z + 1);
				self.velocity_z = 300;
			}
		}
	}
};

void () army_atk3 =
{
	if ((self.impulse == 11))
	{
		if (((self.classname == "monster_army2") || (self.classname == "monster_army4")))
		{
			if ((Mons_consider () || Mons_proxim ()))
			{
				if ((random () < 0.2))
				{
					state [ 80, army_run1 ];
					ai_face ();
					return;
				}
			}
		}
	}
	state [ 83, army_atk4 ];
	ai_face ();
};

void () army_atk4 =
{
	ai_threats ();
	state [ 84, army_atk5 ];
	ai_face ();
	self.cnt = 0;
};

void () army_atk5 =
{
	local float hmm;

	if ((self.enemy.health < 1))
	{
		self.enemy = world;
		self.goalentity = world;
		self.th_stand ();
		return;
	}
	ai_threats ();
	if ((self.enemy.origin_z > self.origin_z))
	{
		hmm = self.enemy.origin_z - self.origin_z;
		if ((hmm > 250))
		{
			state [ 134, army_shootup1 ];
			ai_face ();
			return;
		}
	}
	state [ 85, army_atk6 ];
	ai_face ();
	army_fire ();
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () army_atk6 =
{
	if ((self.classname == "monster_army3"))
	{
		self.cnt = (self.cnt + 1);
		if ((self.cnt < 10))
		{
			if ((random () > 0.1))
			{
				state [ 84, army_atk5 ];
				ai_threats ();
				return;
			}
		}
	}
	state [ 86, army_atk7 ];
	ai_face ();
};

void () army_atk7 = [ 87, army_atk8 ]
{
	ai_face ();
	SUB_CheckRefire (army_atk1);
};

void () army_atk8 =
{
	ai_threats ();
	state [ 88, army_atk9 ];
	ai_face ();
};

void () army_atk9 = [ 89, army_run1 ]
{
	ai_face ();
	ai_emnity ("monster_qguy", 2000, 0);
};

void () army_shootup1 = [ 135, army_shootup2 ]
{
	ai_face ();
	army_fire ();
	ai_threats ();
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () army_shootup2 =
{
	if ((self.classname == "monster_army3"))
	{
		self.cnt = (self.cnt + 1);
		if ((self.cnt < 10))
		{
			if ((random () > 0.1))
			{
				state [ 134, army_shootup1 ];
				ai_threats ();
				return;
			}
		}
	}
	state [ 136, army_shootup3 ];
	ai_face ();
};

void () army_shootup3 = [ 80, army_run1 ]
{
	ai3_run (15);
};

void () army_pain1 = [ 40, army_pain2 ]
{
};

void () army_pain2 = [ 41, army_pain3 ]
{
};

void () army_pain3 = [ 42, army_pain4 ]
{
};

void () army_pain4 = [ 43, army_pain5 ]
{
};

void () army_pain5 = [ 44, army_pain6 ]
{
};

void () army_pain6 = [ 45, army_run1 ]
{
	ai_pain (1);
};

void () army_painb1 = [ 46, army_painb2 ]
{
};

void () army_painb2 = [ 47, army_painb3 ]
{
	ai_painforward (13);
};

void () army_painb3 = [ 48, army_painb4 ]
{
	ai_painforward (MOVETYPE_FLYMISSILE);
};

void () army_painb4 = [ 49, army_painb5 ]
{
};

void () army_painb5 = [ 50, army_painb6 ]
{
};

void () army_painb6 = [ 51, army_painb7 ]
{
};

void () army_painb7 =
{
	if ((self.health < 10))
	{
		self.th_pain = army_painb8;
		self.th_die = army_ongdie;
		self.th_run = army_onground1;
		self.cnt = 0;
		state [ 52, army_onground1 ];
		return;
	}
	state [ 52, army_painb8 ];
};

void () army_painb8 = [ 53, army_painb9 ]
{
};

void () army_painb9 = [ 54, army_painb10 ]
{
};

void () army_painb10 = [ 55, army_painb11 ]
{
};

void () army_painb11 = [ 56, army_painb12 ]
{
};

void () army_painb12 = [ 57, army_painb13 ]
{
	ai_pain (FL_SWIM);
};

void () army_painb13 = [ 58, army_painb14 ]
{
};

void () army_painb14 =
{
	if ((self.th_pain == army_painb8))
	{
		self.th_run = army_run1;
		self.th_pain = army_pain;
		self.th_die = army_die;
	}
	state [ 59, army_run1 ];
};

void () army_painc1 = [ 60, army_painc2 ]
{
};

void () army_painc2 = [ 61, army_painc3 ]
{
	ai_pain (1);
};

void () army_painc3 = [ 62, army_painc4 ]
{
};

void () army_painc4 = [ 63, army_painc5 ]
{
};

void () army_painc5 = [ 64, army_painc6 ]
{
	ai_painforward (1);
};

void () army_painc6 = [ 65, army_painc7 ]
{
	ai_painforward (1);
};

void () army_painc7 = [ 66, army_painc8 ]
{
};

void () army_painc8 = [ 67, army_painc9 ]
{
	ai_pain (1);
};

void () army_painc9 = [ 68, army_painc10 ]
{
	ai_painforward (MOVETYPE_STEP);
};

void () army_painc10 = [ 69, army_painc11 ]
{
	ai_painforward (MOVETYPE_WALK);
};

void () army_painc11 = [ 70, army_painc12 ]
{
	ai_painforward (MOVETYPE_TOSS);
};

void () army_painc12 = [ 71, army_painc13 ]
{
	ai_painforward (FL_CLIENT);
};

void () army_painc13 = [ 72, army_run1 ]
{
};

void (entity attacker, float damage) army_pain =
{
	local float r;

	if ((self.pain_finished > time))
	{
		return;
	}
	r = random ();
	if ((r < 0.2))
	{
		self.pain_finished = (time + 0.6);
		army_pain1 ();
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	else
	{
		if ((r < 0.6))
		{
			self.pain_finished = (time + 1.1);
			army_painb1 ();
			sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
		}
		else
		{
			self.pain_finished = (time + 1.1);
			army_painc1 ();
			sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
		}
	}
};

void () army_fire =
{
	local vector dir;
	local entity en;
	local vector megadeth;

	megadeth = self.enemy.origin - self.origin;
	if ((self.impulse == 11))
	{
		if ((self.classname == "monster_army4"))
		{
			if ((self.origin_z > self.enemy.origin_z))
			{
				Mons_fire_grenade ();
				ai2_jumpsplash (-200, '0 0 200');
			}
			else
			{
				Mons_fire_rocket ();
				ai2_jumpsplash (-200, '0 0 200');
			}
			return;
		}
		if ((self.classname == "monster_army2"))
		{
			Mons_fire_rocket ();
			ai2_jumpsplash (-200, '0 0 200');
			return;
		}
		if ((self.classname == "monster_army5"))
		{
			Mons_fire_sprocket ();
			ai2_jumpsplash (-200, '0 0 200');
			return;
		}
	}
	if ((self.classname == "monster_army3"))
	{
		Mons_fire_nails ();
		ai2_jumpsplash (-200, '0 0 200');
	}
	else
	{
		if ((skill == 3))
		{
			Mons_fire_shotgun ();
			return;
		}
		ai_face ();
		sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);
		en = self.enemy;
		dir = en.origin - (en.velocity * 0.2);
		dir = normalize ((dir - self.origin));
		FireBullets (3, dir, '0.1 0.1 0');
	}
};

void () army_die1 = [ 8, army_die2 ]
{
};

void () army_die2 = [ 9, army_die3 ]
{
};

void () army_die3 = [ 10, army_die4 ]
{
	army_dropbackpack ();
	self.solid = SOLID_NOT;
};

void () army_die4 = [ 11, army_die5 ]
{
};

void () army_die5 = [ 12, army_die6 ]
{
};

void () army_die6 = [ 13, army_die7 ]
{
};

void () army_die7 = [ 14, army_die8 ]
{
};

void () army_die8 = [ 15, army_die9 ]
{
};

void () army_die9 = [ 16, army_die10 ]
{
};

void () army_die10 = [ 17, corpse_think ]
{
};

void () army_cdie1 = [ 18, army_cdie2 ]
{
};

void () army_cdie2 = [ 19, army_cdie3 ]
{
	ai_back (MOVETYPE_FLY);
};

void () army_cdie3 = [ 20, army_cdie4 ]
{
	self.solid = SOLID_NOT;
	ai_back (MOVETYPE_STEP);
	army_dropbackpack ();
};

void () army_cdie4 = [ 21, army_cdie5 ]
{
	ai_back (13);
};

void () army_cdie5 = [ 22, army_cdie6 ]
{
	ai_back (MOVETYPE_WALK);
};

void () army_cdie6 = [ 23, army_cdie7 ]
{
	ai_back (MOVETYPE_STEP);
};

void () army_cdie7 = [ 24, army_cdie8 ]
{
};

void () army_cdie8 = [ 25, army_cdie9 ]
{
};

void () army_cdie9 = [ 26, army_cdie10 ]
{
};

void () army_cdie10 = [ 27, army_cdie11 ]
{
};

void () army_cdie11 = [ 28, corpse_think ]
{
};

void () army_die =
{
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
	}
	if ((self.health < -35))
	{
		if ((skill == 0))
		{
			army_dropbackpack ();
		}
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_guard.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
	dead_stay_dead ();
	if ((random () < 0.5))
	{
		army_die1 ();
	}
	else
	{
		army_cdie1 ();
	}
};

void () army_begin =
{
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	if ((self.goalentity != world))
	{
		state [ 0, army_walk1 ];
	}
	else
	{
		state [ 0, army_stand1 ];
	}
};

void () army_wait =
{
	self.use = army_begin;
	if ((self.walkframe >= 8))
	{
		self.walkframe = 0;
	}
	state [ 64, army_wait ];
	self.frame = (0 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
};

void () monster_army2 =
{
	monster_army ();
};

void () monster_army3 =
{
	monster_army ();
	self.skin = 0;
};

void () monster_army4 =
{
	monster_army ();
};

void () monster_army5 =
{
	monster_army ();
};

void () army_blahblah =
{
	setsize (self, VEC_HULL_MIN, '16 16 40');
};

void () monster_army =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	total_monsters = total_monsters + 1;
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");
	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");
	precache_sound ("player/udeath.wav");
	self.impulse = 0;
	self.cnt = 0;
	if ((self.spawnflags & FL_GODMODE))
	{
		self.th_stand = army_cidle1;
		self.th_walk = army_walk1;
		self.th_run = army_crun;
		self.th_pain = army_ouch;
		self.th_missile = army_atk1;
		self.th_die = army_die;
		carnify_soldier ();
		return;
	}
	if (((((self.targetname == "actor4") || (self.targetname == "actor5")) || (self.targetname == "actor6")) || (self.targetname == "actor7")))
	{
		self.th_stand = army_wait;
		self.th_walk = army_wait;
	}
	else
	{
		self.th_stand = army_stand1;
		self.th_walk = army_walk1;
	}
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_runfire = army_runshot1;
	if ((self.brain & TRIGGER_SPAWN))
	{
		self.use = soldier_startt;
		return;
	}
	carnify_soldier ();
};

void () soldier_startt =
{
	trigger_spawnmonster ();
	carnify_soldier ();
};

void () carnify_soldier =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/soldier.mdl");
	setsize (self, VEC_HULL_MIN, '16 16 40');
	if (!self.health)
	{
		self.health = 42;
	}
	walkmonster_start ();
};

void () army_2normal =
{
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
};

void (entity attacker, float damage) army_ouch =
{
	army_2normal ();
	army_pain (attacker, damage);
};

void () army_crun =
{
	army_2normal ();
	army_run1 ();
};

void () army_cidle1 = [ 137, army_cidle2 ]
{
	ai_stand ();
};

void () army_cidle2 = [ 138, army_cidle3 ]
{
	ai_stand ();
};

void () army_cidle3 = [ 139, army_cidle4 ]
{
	ai_stand ();
};

void () army_cidle4 = [ 140, army_cidle5 ]
{
	ai_stand ();
};

void () army_cidle5 = [ 141, army_cidle6 ]
{
	ai_stand ();
};

void () army_cidle6 =
{
	if ((random () < 0.4))
	{
		if ((random () < 0.5))
		{
			state [ 142, army_look ];
		}
		else
		{
			state [ 142, army_con1 ];
		}
		return;
	}
	state [ 142, army_cidle1 ];
	ai_stand ();
};

void () army_con1 =
{
	if ((self.walkframe >= 7))
	{
		self.walkframe = 0;
		army_con2 ();
		return;
	}
	state [ 143, army_con1 ];
	self.frame = (143 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () army_con2 =
{
	if ((self.walkframe >= 7))
	{
		self.walkframe = 0;
		army_cidle1 ();
		return;
	}
	state [ 143, army_con2 ];
	self.frame = (149 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () army_look =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		army_look2 ();
		return;
	}
	state [ 150, army_look ];
	self.frame = (150 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () army_look2 =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		army_look3 ();
		return;
	}
	state [ 150, army_look2 ];
	self.frame = (155 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () army_look3 =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		army_look4 ();
		return;
	}
	state [ 150, army_look3 ];
	self.frame = (156 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () army_look4 =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		army_cidle1 ();
		return;
	}
	state [ 150, army_look4 ];
	self.frame = (161 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () army_dropbackpack =
{
	if ((self.classname != "monster_army3"))
	{
		self.ammo_shells = MOVETYPE_FLY;
	}
	else
	{
		self.ammo_nails = MOVETYPE_NOCLIP;
	}
	if (((self.classname == "monster_army2") || (self.classname == "monster_army4")))
	{
		self.ammo_rockets = MOVETYPE_WALK;
	}
	DropBackpack ();
};

void () army_runshot1 =
{
	if (borkfactor1 ())
	{
		return;
	}
	state [ 164, army_runshot2 ];
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
	}
	if (!ai_threats ())
	{
		ai_run_slide (10);
	}
	ai_face ();
};

void () army_runshot2 = [ 165, army_runshot3 ]
{
	if (!ai_threats ())
	{
		ai_run_slide (9);
	}
	ai_face ();
};

void () army_runshot3 = [ 166, army_runshot4 ]
{
	if (!ai_threats ())
	{
		ai_run_slide (8);
	}
	ai_face ();
};

void () army_runshot4 = [ 167, army_runshot5 ]
{
	if (!ai_threats ())
	{
		ai_run_slide (8);
	}
	ai_face ();
};

void () army_runshot5 = [ 168, army_runshot6 ]
{
	if (!ai_threats ())
	{
		ai_run_slide (9);
	}
	army_fire ();
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () army_runshot6 = [ 169, army_runshot7 ]
{
	if (!ai_threats ())
	{
		ai_run_slide (10);
	}
	ai_face ();
};

void () army_runshot7 = [ 170, army_runshot8 ]
{
	if (!ai_threats ())
	{
		ai_run_slide (9);
	}
	ai_face ();
};

void () army_runshot8 =
{
	if ((self.enemy.health < 1))
	{
		self.th_stand ();
		return;
	}
	if (ai_threats ())
	{
		state [ 171, army_runshot1 ];
		ai_face ();
		return;
	}
	state [ 171, army_run1 ];
	self.tactic = 0;
	ai_run_slide (9);
	ai_face ();
};
