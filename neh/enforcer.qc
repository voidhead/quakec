
void () Laser_Touch =
{
	local vector org;

	if ((other == self.owner))
	{
		return;
	}
	if ((self.owner.flags & FL_MONSTER))
	{
		if (((self.owner.enemy != other) || (pointcontents (self.origin) == CONTENT_SKY)))
		{
			remove (self);
			return;
		}
	}
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - (FL_CLIENT * normalize (self.velocity));
	if (other.health)
	{
		SpawnBlood (org, (self.velocity * 0.2), 10);
		T_Damage (other, self, self.owner, 10);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	remove (self);
};

void (vector org, vector vec) LaunchLaser =
{
	if ((self.classname == "monster_enforcer"))
	{
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
	}
	vec = normalize (vec);
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.alpha = 0.8;
	newmis.effects = EF_DIMLIGHT;
	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	newmis.velocity = (vec * 600);
	newmis.angles = vectoangles (newmis.velocity);
	newmis.nextthink = (time + MOVETYPE_FLY);
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};

void () enforcer_fire =
{
	local vector org;

	self.effects = (self.effects | EF_MUZZLEFLASH);
	makevectors (self.angles);
	org = ((self.origin + (v_forward * SVC_INTERMISSION)) + (v_right * 8.5)) + '0 0 16';
	LaunchLaser (org, (self.enemy.origin - self.origin));
};

void () enf_stand1 = [ 0, enf_stand2 ]
{
	ai_stand ();
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_stand2 = [ 1, enf_stand3 ]
{
	ai_stand ();
};

void () enf_stand3 = [ 2, enf_stand4 ]
{
	ai_stand ();
};

void () enf_stand4 = [ 3, enf_stand5 ]
{
	ai_stand ();
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_stand5 = [ 4, enf_stand6 ]
{
	ai_stand ();
};

void () enf_stand6 = [ 5, enf_stand7 ]
{
	ai_stand ();
};

void () enf_stand7 = [ 6, enf_stand1 ]
{
	ai_stand ();
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_walk1 = [ 7, enf_walk2 ]
{
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
	}
	ai_walk (FL_SWIM);
};

void () enf_walk2 = [ 8, enf_walk3 ]
{
	ai_walk (MOVETYPE_STEP);
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_walk3 = [ 9, enf_walk4 ]
{
	ai_walk (MOVETYPE_STEP);
};

void () enf_walk4 = [ 10, enf_walk5 ]
{
	ai_walk (MOVETYPE_WALK);
};

void () enf_walk5 = [ 11, enf_walk6 ]
{
	ai_walk (1);
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_walk6 = [ 12, enf_walk7 ]
{
	ai_walk (FL_SWIM);
};

void () enf_walk7 = [ 13, enf_walk8 ]
{
	ai_walk (FL_SWIM);
};

void () enf_walk8 = [ 14, enf_walk9 ]
{
	ai_walk (1);
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_walk9 = [ 15, enf_walk10 ]
{
	ai_walk (FL_SWIM);
};

void () enf_walk10 = [ 16, enf_walk11 ]
{
	ai_walk (MOVETYPE_STEP);
};

void () enf_walk11 = [ 17, enf_walk12 ]
{
	ai_walk (MOVETYPE_STEP);
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_walk12 = [ 18, enf_walk13 ]
{
	ai_walk (1);
};

void () enf_walk13 = [ 19, enf_walk14 ]
{
	ai_walk (FL_SWIM);
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_walk14 = [ 20, enf_walk15 ]
{
	ai_walk (MOVETYPE_WALK);
};

void () enf_walk15 = [ 21, enf_walk16 ]
{
	ai_walk (MOVETYPE_STEP);
	ai_emnity ("monster_qguy", 1500, 0);
};

void () enf_walk16 = [ 22, enf_walk1 ]
{
	ai_walk (FL_SWIM);
};

void () enf_run1 =
{
	if (borkfactor1 ())
	{
		return;
	}
	state [ 23, enf_run2 ];
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
	}
	ai3_run (18);
};

void () enf_run2 =
{
	if (visible (self.enemy))
	{
		state [ 24, enf_runatt1 ];
		ai3_run (14);
		return;
	}
	state [ 24, enf_run3 ];
	ai3_run (14);
};

void () enf_run3 = [ 25, enf_run4 ]
{
	ai3_run (MOVETYPE_PUSH);
};

void () enf_run4 = [ 26, enf_run5 ]
{
	ai3_run (12);
};

void () enf_run5 = [ 27, enf_run6 ]
{
	ai3_run (14);
};

void () enf_run6 = [ 28, enf_run7 ]
{
	ai3_run (14);
};

void () enf_run7 = [ 29, enf_run8 ]
{
	ai3_run (MOVETYPE_PUSH);
};

void () enf_run8 = [ 30, enf_run1 ]
{
	ai3_run (MOVETYPE_BOUNCEMISSILE);
};

void () enf_atk1 = [ 31, enf_atk2 ]
{
	ai_face ();
};

void () enf_atk2 = [ 32, enf_atk3 ]
{
	ai_face ();
};

void () enf_atk3 = [ 33, enf_atk4 ]
{
	ai_face ();
	self.th_missile = enf_runfire1;
};

void () enf_atk4 = [ 34, enf_atk5 ]
{
	ai_face ();
};

void () enf_atk5 = [ 35, enf_atk6 ]
{
	ai_face ();
};

void () enf_atk6 = [ 36, enf_atk7 ]
{
	enforcer_fire ();
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () enf_atk7 =
{
	if (ai_threats ())
	{
		state [ 37, enf_runfire1 ];
		ai_face ();
		return;
	}
	state [ 37, enf_atk8 ];
	ai_face ();
};

void () enf_atk8 = [ 38, enf_atk9 ]
{
	ai_face ();
};

void () enf_atk9 = [ 35, enf_atk10 ]
{
	ai_face ();
};

void () enf_atk10 = [ 36, enf_atk11 ]
{
	enforcer_fire ();
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () enf_atk11 = [ 37, enf_atk12 ]
{
	ai_face ();
};

void () enf_atk12 = [ 38, enf_atk13 ]
{
	ai_face ();
};

void () enf_atk13 = [ 39, enf_atk14 ]
{
	ai_face ();
};

void () enf_atk14 = [ 40, enf_run1 ]
{
	ai_face ();
	SUB_CheckRefire (enf_atk1);
};

void () enf_paina1 = [ 66, enf_paina2 ]
{
};

void () enf_paina2 = [ 67, enf_paina3 ]
{
};

void () enf_paina3 = [ 68, enf_paina4 ]
{
};

void () enf_paina4 = [ 69, enf_run1 ]
{
};

void () enf_painb1 = [ 70, enf_painb2 ]
{
};

void () enf_painb2 = [ 71, enf_painb3 ]
{
};

void () enf_painb3 = [ 72, enf_painb4 ]
{
};

void () enf_painb4 = [ 73, enf_painb5 ]
{
};

void () enf_painb5 = [ 74, enf_run1 ]
{
};

void () enf_painc1 = [ 75, enf_painc2 ]
{
};

void () enf_painc2 = [ 76, enf_painc3 ]
{
};

void () enf_painc3 = [ 77, enf_painc4 ]
{
};

void () enf_painc4 = [ 78, enf_painc5 ]
{
};

void () enf_painc5 = [ 79, enf_painc6 ]
{
};

void () enf_painc6 = [ 80, enf_painc7 ]
{
};

void () enf_painc7 = [ 81, enf_painc8 ]
{
};

void () enf_painc8 = [ 82, enf_run1 ]
{
};

void () enf_paind1 = [ 83, enf_paind2 ]
{
};

void () enf_paind2 = [ 84, enf_paind3 ]
{
};

void () enf_paind3 = [ 85, enf_paind4 ]
{
};

void () enf_paind4 = [ 86, enf_paind5 ]
{
	ai_painforward (FL_SWIM);
};

void () enf_paind5 = [ 87, enf_paind6 ]
{
	ai_painforward (1);
};

void () enf_paind6 = [ 88, enf_paind7 ]
{
};

void () enf_paind7 = [ 89, enf_paind8 ]
{
};

void () enf_paind8 = [ 90, enf_paind9 ]
{
};

void () enf_paind9 = [ 91, enf_paind10 ]
{
};

void () enf_paind10 = [ 92, enf_paind11 ]
{
};

void () enf_paind11 = [ 93, enf_paind12 ]
{
	ai_painforward (1);
};

void () enf_paind12 = [ 94, enf_paind13 ]
{
	ai_painforward (1);
};

void () enf_paind13 = [ 95, enf_paind14 ]
{
	ai_painforward (1);
};

void () enf_paind14 = [ 96, enf_paind15 ]
{
};

void () enf_paind15 = [ 97, enf_paind16 ]
{
};

void () enf_paind16 = [ 98, enf_paind17 ]
{
	ai_pain (1);
};

void () enf_paind17 = [ 99, enf_paind18 ]
{
	ai_pain (1);
};

void () enf_paind18 = [ 100, enf_paind19 ]
{
};

void () enf_paind19 = [ 101, enf_run1 ]
{
};

void (entity attacker, float damage) enf_pain =
{
	local float r;

	r = random ();
	if ((self.pain_finished > time))
	{
		return;
	}
	if ((r < 0.5))
	{
		sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
	}
	else
	{
		sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
	}
	if ((r < 0.2))
	{
		self.pain_finished = (time + 1);
		enf_paina1 ();
	}
	else
	{
		if ((r < 0.4))
		{
			self.pain_finished = (time + 1);
			enf_painb1 ();
		}
		else
		{
			if ((r < 0.7))
			{
				self.pain_finished = (time + 1);
				enf_painc1 ();
			}
			else
			{
				self.pain_finished = (time + FL_SWIM);
				enf_paind1 ();
			}
		}
	}
};

void () enf_die1 =
{
	dead_stay_dead ();
	state [ 41, enf_die2 ];
};

void () enf_die2 = [ 42, enf_die3 ]
{
};

void () enf_die3 = [ 43, enf_die4 ]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = MOVETYPE_FLY;
	DropBackpack ();
};

void () enf_die4 = [ 44, enf_die5 ]
{
	ai_forward (14);
};

void () enf_die5 = [ 45, enf_die6 ]
{
	ai_forward (FL_SWIM);
};

void () enf_die6 = [ 46, enf_die7 ]
{
};

void () enf_die7 = [ 47, enf_die8 ]
{
};

void () enf_die8 = [ 48, enf_die9 ]
{
};

void () enf_die9 = [ 49, enf_die10 ]
{
	ai_forward (MOVETYPE_WALK);
};

void () enf_die10 = [ 50, enf_die11 ]
{
	ai_forward (MOVETYPE_FLY);
};

void () enf_die11 = [ 51, enf_die12 ]
{
	ai_forward (MOVETYPE_FLY);
};

void () enf_die12 = [ 52, enf_die13 ]
{
	ai_forward (MOVETYPE_FLY);
};

void () enf_die13 = [ 53, enf_die14 ]
{
};

void () enf_die14 = [ 54, corpse_think ]
{
};

void () enf_fdie1 =
{
	dead_stay_dead ();
	state [ 55, enf_fdie2 ];
};

void () enf_fdie2 = [ 56, enf_fdie3 ]
{
};

void () enf_fdie3 = [ 57, enf_fdie4 ]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = MOVETYPE_FLY;
	DropBackpack ();
};

void () enf_fdie4 = [ 58, enf_fdie5 ]
{
};

void () enf_fdie5 = [ 59, enf_fdie6 ]
{
};

void () enf_fdie6 = [ 60, enf_fdie7 ]
{
};

void () enf_fdie7 = [ 61, enf_fdie8 ]
{
};

void () enf_fdie8 = [ 62, enf_fdie9 ]
{
};

void () enf_fdie9 = [ 63, enf_fdie10 ]
{
};

void () enf_fdie10 = [ 64, enf_fdie11 ]
{
};

void () enf_fdie11 = [ 65, corpse_think ]
{
};

void () enf_die =
{
	if ((self.health < -35))
	{
		if ((skill == 0))
		{
			self.ammo_cells = MOVETYPE_FLY;
			DropBackpack ();
		}
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_mega.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
	}
	sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
	if ((random () > 0.5))
	{
		enf_die1 ();
	}
	else
	{
		enf_fdie1 ();
	}
};

void () enf_runatt1 =
{
	if (borkfactor1 ())
	{
		return;
	}
	state [ 125, enf_runatt2 ];
	ai4_run (18);
	ai_face ();
};

void () enf_runatt2 = [ 126, enf_runatt3 ]
{
	ai4_run (14);
	ai_face ();
};

void () enf_runatt3 = [ 127, enf_runatt4 ]
{
	ai4_run (13);
	ai_face ();
};

void () enf_runatt4 =
{
	if (((self.enemy.health > 0) && visible (self.enemy)))
	{
		enf_runfire1 ();
		return;
	}
	state [ 128, enf_runatt5 ];
	ai4_run (14);
	ai_face ();
};

void () enf_runatt5 = [ 129, enf_runatt6 ]
{
	ai4_run (14);
	ai_face ();
};

void () enf_runatt6 = [ 130, enf_runatt7 ]
{
	ai4_run (10);
	ai_face ();
};

void () enf_runatt7 =
{
	if ((self.enemy.health < 1))
	{
		self.th_stand ();
		return;
	}
	state [ 131, enf_runatt8 ];
	ai4_run (11);
	ai_face ();
};

void () enf_runatt8 =
{
	if (visible (self.enemy))
	{
		state [ 132, enf_runatt1 ];
		ai4_run (18);
		ai_face ();
		return;
	}
	state [ 132, enf_run1 ];
};

void () enf_runfire1 =
{
	if (borkfactor1 ())
	{
		return;
	}
	state [ 133, enf_runfire2 ];
	ai_face ();
	if (ai_threats ())
	{
		return;
	}
	ai_run_slide (10);
};

void () enf_runfire2 =
{
	if ((self.enemy.health < 1))
	{
		self.th_stand ();
		return;
	}
	state [ 134, enf_runfire3 ];
	ai_face ();
	enforcer_fire ();
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if (ai_threats ())
	{
		return;
	}
	ai_run_slide (10);
};

void () enf_runfire3 = [ 135, enf_runfire4 ]
{
	ai_face ();
	if (ai_threats ())
	{
		return;
	}
	ai_run_slide (10);
};

void () enf_runfire4 =
{
	ai_face ();
	if (ai_threats ())
	{
		if (visible (self.enemy))
		{
			state [ 136, enf_runfire1 ];
			return;
		}
	}
	state [ 136, enf_runatt6 ];
	self.tactic = 0;
	ai_run_slide (10);
};

void () monster_enforcer =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	total_monsters = total_monsters + 1;
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
	if (!(self.brain & NAVLOGIC))
	{
		self.brain = (self.brain | NAVLOGIC);
	}
	if ((self.spawnflags & FL_GODMODE))
	{
		self.th_stand = enforcer_cidle1;
		self.th_walk = enf_walk1;
		self.th_run = enforcer_crun;
		self.th_missile = enf_atk1;
		self.th_die = enf_die;
		walkmonster_start ();
		return;
	}
	if (((self.targetname == "actor13") || (self.targetname == "actor14")))
	{
		self.th_stand = enforcer_wait;
		self.th_walk = enforcer_wait;
	}
	else
	{
		self.th_stand = enf_stand1;
		self.th_walk = enf_walk1;
	}
	self.th_run = enf_run1;
	self.th_runfire = enf_runfire1;
	self.th_melee = SUB_Null;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	if ((random () < 0.4))
	{
		self.th_missile = enf_atk1;
	}
	else
	{
		self.th_missile = enf_runatt1;
	}
	if ((self.brain & TRIGGER_SPAWN))
	{
		self.use = enforcer_start;
		return;
	}
	carnify_enforcer ();
};

void () enforcer_start =
{
	trigger_spawnmonster ();
	carnify_enforcer ();
};

void () carnify_enforcer =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/enforcer.mdl");
	setsize (self, VEC_HULL_MIN, '16 16 40');
	if (!self.health)
	{
		self.health = 90;
	}
	walkmonster_start ();
};

void () enforcer_begin =
{
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	if ((self.goalentity != world))
	{
		state [ 0, enf_walk1 ];
	}
	else
	{
		state [ 0, enf_stand1 ];
	}
};

void () enforcer_wait =
{
	self.use = enforcer_begin;
	if ((self.walkframe >= 8))
	{
		self.walkframe = 0;
	}
	state [ 64, enforcer_wait ];
	self.frame = (0 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
};

void () enforcer_2norm =
{
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
};

void () enforcer_2ouch =
{
	enforcer_2norm ();
	enf_pain (world, 0);
};

void () enforcer_crun =
{
	enforcer_2norm ();
	enf_run1 ();
};

void () enforcer_cidle1 =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		if ((random () < 0.5))
		{
			state [ 123, enforcer_con ];
			return;
		}
	}
	state [ 119, enforcer_cidle1 ];
	self.frame = (119 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () enforcer_con = [ 102, enforcer_con2 ]
{
	ai_stand ();
};

void () enforcer_con2 = [ 103, enforcer_con3 ]
{
	ai_stand ();
};

void () enforcer_con3 = [ 104, enforcer_con4 ]
{
	ai_stand ();
};

void () enforcer_con4 = [ 105, enforcer_con5 ]
{
	ai_stand ();
};

void () enforcer_con5 =
{
	local float num;

	num = random ();
	self.walkframe = 0;
	if ((num < 0.3))
	{
		state [ 106, enforcer_con6 ];
		return;
	}
	if ((num < 0.7))
	{
		state [ 111, enforcer_left ];
		return;
	}
	state [ 115, enforcer_right ];
};

void () enforcer_con6 = [ 107, enforcer_con7 ]
{
	ai_stand ();
};

void () enforcer_con7 = [ 108, enforcer_con8 ]
{
	ai_stand ();
};

void () enforcer_con8 = [ 109, enforcer_con9 ]
{
	ai_stand ();
};

void () enforcer_con9 =
{
	if ((self.walkframe >= 9))
	{
		self.walkframe = 0;
		enforcer_cidle1 ();
		return;
	}
	state [ 102, enforcer_con9 ];
	self.frame = (110 - self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () enforcer_left =
{
//	local float num;

	if ((self.walkframe >= 8))
	{
		self.walkframe = 4;
		enforcer_con9 ();
		return;
	}
	state [ 111, enforcer_left ];
	if ((self.walkframe < 5))
	{
		self.frame = (111 + self.walkframe);
	}
	else
	{
		self.frame = (118 - self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () enforcer_right =
{
//	local float num;

	if ((self.walkframe >= 8))
	{
		self.walkframe = 4;
		enforcer_con9 ();
		return;
	}
	state [ 115, enforcer_right ];
	if ((self.walkframe < 5))
	{
		self.frame = (115 + self.walkframe);
	}
	else
	{
		self.frame = (122 - self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};
