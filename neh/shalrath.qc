
void () shal_stand =
{
	local float num;

	if ((self.walkframe >= 12))
	{
		self.walkframe = 0;
		num = random ();
		if ((num < 0.1))
		{
			self.cnt = 0;
			shal_arms ();
			return;
		}
		if ((num < 0.3))
		{
			self.cnt = 0;
			shal_look ();
			return;
		}
	}
	state [ 35, shal_stand ];
	self.frame = (35 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
	if (((self.walkframe == 4) || (self.walkframe == 8)))
	{
		ai_emnity ("monster_qguy", 1700, 0);
	}
};

void () shal_arms =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		self.cnt = (self.cnt + 1);
		if ((self.cnt > 1))
		{
			shal_stand ();
			return;
		}
	}
	state [ 59, shal_arms ];
	if ((self.cnt == 1))
	{
		self.frame = (64 - self.walkframe);
	}
	else
	{
		self.frame = (59 + self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
};

void () shal_look =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		self.cnt = (self.cnt + 1);
		if ((self.cnt > 1))
		{
			self.cnt = 0;
			shal_look2 ();
			return;
		}
	}
	state [ 47, shal_look ];
	if ((self.cnt == 1))
	{
		self.frame = (52 - self.walkframe);
	}
	else
	{
		self.frame = (47 + self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
	if ((self.walkframe == 3))
	{
		ai_emnity ("monster_qguy", 1700, 0);
	}
};

void () shal_look2 =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		self.cnt = (self.cnt + 1);
		if ((self.cnt > 1))
		{
			shal_stand ();
			return;
		}
	}
	state [ 53, shal_look2 ];
	if ((self.cnt == 1))
	{
		self.frame = (58 - self.walkframe);
	}
	else
	{
		self.frame = (53 + self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	ai_stand ();
	if ((self.walkframe == 3))
	{
		ai_emnity ("monster_qguy", 1700, 0);
	}
};

void () shal_walk1 = [ 24, shal_walk2 ]
{
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
	}
	ai_walk (MOVETYPE_TOSS);
};

void () shal_walk2 = [ 25, shal_walk3 ]
{
	ai_walk (MOVETYPE_STEP);
};

void () shal_walk3 = [ 26, shal_walk4 ]
{
	ai_walk (0);
	ai_emnity ("monster_qguy", 1700, 0);
};

void () shal_walk4 = [ 27, shal_walk5 ]
{
	ai_walk (0);
};

void () shal_walk5 = [ 28, shal_walk6 ]
{
	ai_walk (0);
	ai_emnity ("monster_qguy", 1700, 0);
};

void () shal_walk6 = [ 29, shal_walk7 ]
{
	ai_walk (0);
};

void () shal_walk7 = [ 30, shal_walk8 ]
{
	ai_walk (MOVETYPE_FLY);
};

void () shal_walk8 = [ 31, shal_walk9 ]
{
	ai_walk (MOVETYPE_TOSS);
	ai_emnity ("monster_qguy", 1700, 0);
};

void () shal_walk9 = [ 32, shal_walk10 ]
{
	ai_walk (MOVETYPE_FLY);
};

void () shal_walk10 = [ 33, shal_walk11 ]
{
	ai_walk (0);
	ai_emnity ("monster_qguy", 1700, 0);
};

void () shal_walk11 = [ 34, shal_walk12 ]
{
	ai_walk (MOVETYPE_STEP);
};

void () shal_walk12 = [ 23, shal_walk1 ]
{
	ai_walk (MOVETYPE_FLY);
	ai_emnity ("monster_qguy", 1700, 0);
};

void () shal_run1 =
{
	local entity head;

	if ((visible (self.enemy) && (random () < 0.6)))
	{
		head = findentity (world, owner, self);
		if (((head != world) && (self.nojump < 1)))
		{
			if (shal_clearance ())
			{
				shal_bounce ();
				return;
			}
		}
	}
	state [ 24, shal_run2 ];
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
	}
	ai_run (MOVETYPE_TOSS);
};

void () shal_run2 = [ 25, shal_run3 ]
{
	ai_run (MOVETYPE_STEP);
	if ((random () < 0.2))
	{
		sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
	}
};

void () shal_run3 = [ 26, shal_run4 ]
{
	ai_run (0);
};

void () shal_run4 = [ 27, shal_run5 ]
{
	ai_run (0);
};

void () shal_run5 = [ 28, shal_run6 ]
{
	ai_run (0);
};

void () shal_run6 = [ 29, shal_run7 ]
{
	ai_run (0);
};

void () shal_run7 = [ 30, shal_run8 ]
{
	ai_run (MOVETYPE_FLY);
};

void () shal_run8 = [ 31, shal_run9 ]
{
	ai_run (MOVETYPE_TOSS);
};

void () shal_run9 = [ 32, shal_run10 ]
{
	ai_run (MOVETYPE_FLY);
};

void () shal_run10 = [ 33, shal_run11 ]
{
	ai_run (0);
};

void () shal_run11 = [ 34, shal_run12 ]
{
	ai_run (MOVETYPE_STEP);
};

void () shal_run12 = [ 23, shal_run1 ]
{
	ai_run (MOVETYPE_FLY);
};

void () shal_bounce = [ 70, shal_bounce2 ]
{
	ai_face ();
};

void () shal_bounce2 = [ 71, shal_bounce3 ]
{
	ai_face ();
};

void () shal_bounce3 = [ 72, shal_bounce4 ]
{
	ai_face ();
};

void () shal_bounce4 = [ 73, shal_bounce5 ]
{
	ai_face ();
};

void () shal_bounce5 = [ 74, shal_bounce6 ]
{
	ai_face ();
};

void () shal_bounce6 = [ 70, shal_bounce7 ]
{
	ai_face ();
};

void () shal_bounce7 = [ 71, shal_bounce8 ]
{
	ai_face ();
};

void () shal_bounce8 =
{
	self.walkframe = 0;
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
		self.origin_z = (self.origin_z + 1);
		self.velocity_z = 700;
	}
	if ((random () < 0.4))
	{
		if (shal_checkroof ())
		{
			self.touch = shal_grabroof;
			self.origin_z = (self.origin_z + 1);
			shal_flipup ();
			return;
		}
	}
	state [ 72, shal_jump ];
	ai_face ();
};

void () shal_jump =
{
	if ((self.walkframe >= 10))
	{
		self.walkframe = 0;
		if (visible (self.enemy))
		{
			shal_attack1 ();
			return;
		}
		shal_run1 ();
		return;
	}
	state [ 75, shal_jump ];
	self.frame = (75 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_face ();
	if ((self.walkframe == 4))
	{
		sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
	}
	if ((self.walkframe == 8))
	{
		ShalMissile ();
	}
};

void () shal_flipup =
{
	if ((self.walkframe >= 6))
	{
		self.walkframe = 0;
		shal_reaching ();
		return;
	}
	state [ 85, shal_flipup ];
	self.frame = (85 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_face ();
	self.velocity_z = 650;
	if ((self.walkframe == 4))
	{
		sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
	}
	if ((self.walkframe == 7))
	{
		ShalMissile ();
	}
};

void () shal_upidle =
{
	if (self.enemy)
	{
		if (visible (self.enemy))
		{
			shal_upatt ();
			return;
		}
	}
	else
	{
		ai_stand ();
	}
	if (shal_nosky ())
	{
		shal_flipdown ();
		dprint ("VORE: no skylatching\n");
		return;
	}
	state [ 95, shal_upidle ];
	if ((self.flags & FL_ONGROUND))
	{
		self.origin_z = (self.origin_z + 1);
		self.flags = (self.flags - FL_ONGROUND);
	}
	self.velocity_z = 500;
	if ((self.th_stand != shal_flipdown))
	{
		self.th_stand = shal_flipdown;
		self.th_walk = shal_flipdown;
	}
};

void () shal_upatt =
{
	if ((self.walkframe >= 12))
	{
		self.walkframe = 0;
	}
	if ((self.enemy.health < 1))
	{
		self.enemy = world;
		self.th_stand ();
		return;
	}
	if (!visible (self.enemy))
	{
		state [ 95, shal_upidle ];
		return;
	}
	state [ 95, shal_upatt ];
	self.frame = (95 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
	ai_face ();
	self.velocity_z = 500;
	if ((self.enemy == world))
	{
		shal_flipdown ();
		return;
	}
	if (visible (self.enemy))
	{
		if ((self.walkframe == 4))
		{
			sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
		}
		if ((self.walkframe == 7))
		{
			ShalMissile ();
		}
	}
};

void () shal_grabroof =
{
//	local vector spot;

	if ((other.takedamage || other.health))
	{
		return;
	}
	self.nojump = -1;
	self.touch = SUB_Null;
};

void () shal_reaching =
{
	if ((self.nojump == -1))
	{
		self.th_stand = shal_flipdown;
		self.th_walk = shal_flipdown;
		self.th_pain = shal_flipdown;
		self.th_run = shal_upatt;
		self.th_missile = shal_upatt;
		self.th_die = shal_updie;
		shal_upatt ();
		return;
	}
	if ((self.velocity_z < 100))
	{
		shal_flipdown ();
		return;
	}
	state [ 94, shal_reaching ];
	ai_face ();
};

void () shal_flipdown =
{
	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;
	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	state [ 94, shal_flipdown2 ];
};

void () shal_flipdown2 = [ 93, shal_flipdown3 ]
{
};

void () shal_flipdown3 = [ 92, shal_flipdown4 ]
{
};

void () shal_flipdown4 = [ 91, shal_flipdown5 ]
{
};

void () shal_flipdown5 = [ 90, shal_flipdown6 ]
{
};

void () shal_flipdown6 = [ 88, shal_flipdown7 ]
{
};

void () shal_flipdown7 = [ 87, shal_flipdown8 ]
{
};

void () shal_flipdown8 = [ 86, shal_flipdown9 ]
{
};

void () shal_flipdown9 =
{
	if ((self.enemy != world))
	{
		shal_run1 ();
		return;
	}
	shal_stand ();
};

void () shal_attack1 = [ 0, shal_attack2 ]
{
	sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
	ai_face ();
};

void () shal_attack2 = [ 1, shal_attack3 ]
{
	ai_face ();
};

void () shal_attack3 = [ 2, shal_attack4 ]
{
	ai_face ();
};

void () shal_attack4 = [ 3, shal_attack5 ]
{
	ai_face ();
	if ((random () < 0.4))
	{
		ai2_jumpsplash (-300, '0 0 400');
	}
	else
	{
		ai2_jumpsplash (-220, '0 0 500');
	}
};

void () shal_attack5 = [ 4, shal_attack6 ]
{
	ai_face ();
};

void () shal_attack6 = [ 5, shal_attack7 ]
{
	ai_face ();
};

void () shal_attack7 = [ 6, shal_attack8 ]
{
	ai_face ();
};

void () shal_attack8 = [ 7, shal_attack9 ]
{
	ai_face ();
};

void () shal_attack9 = [ 8, shal_attack10 ]
{
	ShalMissile ();
};

void () shal_attack10 = [ 9, shal_attack11 ]
{
	ai_face ();
};

void () shal_attack11 = [ 10, shal_run1 ]
{
};

void () shal_pain1 = [ 11, shal_pain2 ]
{
};

void () shal_pain2 = [ 12, shal_pain3 ]
{
};

void () shal_pain3 = [ 13, shal_pain4 ]
{
};

void () shal_pain4 = [ 14, shal_pain5 ]
{
};

void () shal_pain5 = [ 15, shal_run1 ]
{
};

void () shal_death1 = [ 16, shal_death2 ]
{
};

void () shal_death2 = [ 17, shal_death3 ]
{
};

void () shal_death3 = [ 18, shal_death4 ]
{
};

void () shal_death4 = [ 19, shal_death5 ]
{
};

void () shal_death5 = [ 20, shal_death6 ]
{
};

void () shal_death6 = [ 21, shal_death7 ]
{
};

void () shal_death7 = [ 22, corpse_think ]
{
};

void () shalrath_pain =
{
	if ((self.pain_finished > time))
	{
		return;
	}
	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	shal_pain1 ();
	self.pain_finished = (time + MOVETYPE_WALK);
};

void () shal_updie =
{
	self.movetype = MOVETYPE_STEP;
	if ((self.health < -90))
	{
//		shalrath_die ();
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_shal.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
	state [ 107, shal_updie2 ];
	self.solid = SOLID_NOT;
};

void () shal_updie2 = [ 108, shal_updie3 ]
{
};

void () shal_updie3 = [ 109, shal_updie4 ]
{
};

void () shal_updie4 = [ 110, shal_updie5 ]
{
};

void () shal_updie5 = [ 111, shal_updie6 ]
{
};

void () shal_updie6 = [ 112, shal_updie7 ]
{
};

void () shal_updie7 = [ 113, shal_updie7 ]
{
};

void () shalrath_die =
{
	if ((self.health < -90))
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_shal.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
	shal_death1 ();
	self.solid = SOLID_NOT;
};

void () ShalMissile =
{
	local entity missile;
	local vector dir;
	local float dist;
	local float flytime;

	dir = normalize (((self.enemy.origin + '0 0 10') - self.origin));
	dist = vlen ((self.enemy.origin - self.origin));
	flytime = dist * 0.002;
	if ((flytime < 0.1))
	{
		flytime = 0.1;
	}
	self.effects = (self.effects | EF_MUZZLEFLASH);
	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);
	missile = spawn ();
	missile.owner = self;
	missile.event = "mthret";
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/v_spike.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	missile.origin = (self.origin + '0 0 10');
	missile.velocity = (dir * 400);
	missile.avelocity = '300 300 300';
	missile.nextthink = (flytime + time);
	missile.think = ShalHome;
	missile.enemy = self.enemy;
	missile.touch = ShalMissileTouch;
};

void () ShalHome =
{
	local vector dir;
	local vector vtemp;

	vtemp = self.enemy.origin + '0 0 10';
	if ((self.enemy.health < 1))
	{
		remove (self);
		return;
	}
	dir = normalize ((vtemp - self.origin));
	if ((skill == MOVETYPE_WALK))
	{
		self.velocity = (dir * 350);
	}
	else
	{
		self.velocity = (dir * 250);
	}
	self.nextthink = (time + 0.2);
	self.think = ShalHome;
};

void () ShalMissileTouch =
{
	if ((other == self.owner))
	{
		return;
	}
	if ((other.classname == "monster_zombie"))
	{
		T_Damage (other, self, self, 110);
	}
	T_RadiusDamage (self, self.owner, 40, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	if ((self.nojump == 60606))
	{
		self.velocity = VEC_ORIGIN;
		self.touch = SUB_Null;
		self.solid = SOLID_NOT;
		BecomeExplosion ();
	}
	else
	{
		remove (self);
	}
};

void () monster_shalrath =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	total_monsters = total_monsters + 1;
	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");
	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");
	if (!(self.brain & NAVLOGIC))
	{
		self.brain = (self.brain | NAVLOGIC);
	}
	if ((self.spawnflags & FL_GODMODE))
	{
		self.th_stand = shal_upidle;
		self.th_walk = shal_flipdown;
		self.th_pain = shal_flipdown;
		self.th_run = shal_upatt;
		self.th_missile = shal_upatt;
		self.th_die = shal_updie;
	}
	else
	{
		self.th_stand = shal_stand;
		self.th_walk = shal_walk1;
		self.th_run = shal_run1;
		self.th_die = shalrath_die;
		self.th_pain = shalrath_pain;
		self.th_missile = shal_attack1;
	}
	if ((self.brain & TRIGGER_SPAWN))
	{
		self.use = shalrath_start;
		return;
	}
	carnify_shalrath ();
};

void () shalrath_start =
{
	trigger_spawnmonster ();
	carnify_shalrath ();
};

void () carnify_shalrath =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (!self.health)
	{
		self.health = 400;
	}
	walkmonster_start ();
};

float () shal_nosky =
{
	local vector end;

	end = self.origin + '0 0 200';
	traceline (self.origin, end, TRUE, self);
	if ((pointcontents (trace_endpos) == CONTENT_SKY))
	{
		return (1);
	}
	else
	{
		return (0);
	}
};

float () shal_clearance =
{
	local vector end;

	end = self.origin + '0 0 250';
	traceline (self.origin, end, TRUE, self);
	if ((trace_fraction == 1))
	{
		return (1);
	}
	else
	{
		dprint ("\n");
		return (0);
	}
};

float () shal_checkroof =
{
	local vector end;
	local float contents;
	local float num;

	end = self.origin + '0 0 1000';
	traceline (self.origin, end, TRUE, self);
	contents = pointcontents (trace_endpos);
	end = trace_endpos;
	num = end_z - self.origin_z;
	if ((num < 300))
	{
		return (0);
	}
	if ((contents == CONTENT_SKY))
	{
		return (0);
	}
	if ((trace_fraction == 1))
	{
		return (0);
	}
	else
	{
		return (1);
	}
};
