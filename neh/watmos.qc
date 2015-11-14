
void () func_earthquake =
{
	precache_sound ("quake/inv3.wav");
	precache_sound ("quake/inv2.wav");
	InitTrigger ();
	self.speed = 0;
	self.frags = 0;
	if ((self.cnt < 1))
	{
		self.cnt = 30;
	}
	self.touch = initiate_quake;
};

void () initiate_quake =
{
	local entity e;
	local entity head;

	if ((other.classname != "player"))
	{
		return;
	}
	head = spawn ();
	setorigin (head, other.origin);
	head.think = quakenoise;
	head.event = "earthq";
	head.nextthink = time;
	e = find (world, classname, "player");
	sound (self, CHAN_ITEM, "quake/inv3.wav", 1, ATTN_IDLE);
	while (e)
	{
		if (!(e.flags & FL_FLEE))
		{
			e.flags = (e.flags | FL_FLEE);
		}
		e = find (e, classname, "player");
	}
	self.touch = SUB_Null;
	self.think = quake_n_shake;
	self.nextthink = time;
};

void () quakenoise =
{
	Seekoutwall ();
	sound (self, CHAN_ITEM, "quake/inv3.wav", 1, ATTN_IDLE);
	self.think = quakenoise;
	self.nextthink = (time + 2.8);
};

void () quake_n_shake =
{
	local entity e;
	local entity head;

	self.speed = (self.speed + 1);
	if ((self.speed > 1))
	{
		e = find (world, classname, "player");
		while (e)
		{
			if ((e.flags & FL_FLEE))
			{
				e.flags = (e.flags - FL_FLEE);
			}
			e = find (e, classname, "player");
		}
		head = find (world, event, "earthq");
		if ((head != world))
		{
			remove (head);
		}
		remove (self);
		return;
	}
	self.think = quake_n_shake;
	self.nextthink = (time + self.cnt);
};

void () efx_lightning =
{
	precache_sound ("weapons/lstart.wav");
	self.classname = "efx_lightning";
	if (self.targetname)
	{
		self.use = efx1_Attack;
	}
	else
	{
		self.nextthink = (time + RandomRange (FL_SWIM, MOVETYPE_FLY));
		self.think = efx1_Attack;
	}
};

void () efx1_Attack =
{
	local vector org;
	local vector targ;
	local vector org2;
	local entity BudLite;

	sound (self, CHAN_VOICE, "weapons/lstart.wav", 1, ATTN_NORM);
	org = self.origin;
	targ = self.origin - '0 0 128';
	targ_x = targ_x + RandomRange (-32, FL_MONSTER);
	targ_y = targ_y + RandomRange (-32, FL_MONSTER);
	self.nextthink = (time + RandomRange (FL_SWIM, MOVETYPE_FLY));
	self.think = efx1_Attack;
	LightningDamage (org, targ, self, MOVETYPE_BOUNCE);
	self.effects = (self.effects | EF_MUZZLEFLASH);
	WriteByte (MSG_ALL, SVC_TEMPENTITY);
	WriteByte (MSG_ALL, TE_LIGHTNING2);
	WriteEntity (MSG_ALL, world);
	WriteCoord (MSG_ALL, org_x);
	WriteCoord (MSG_ALL, org_y);
	WriteCoord (MSG_ALL, org_z);
	WriteCoord (MSG_ALL, targ_x);
	WriteCoord (MSG_ALL, targ_y);
	WriteCoord (MSG_ALL, targ_z);
};

void () efx_snow =
{
	self.classname = "efx_snow";
	self.nextthink = 0.1;
	self.think = efx3_spawn;
};

void () efx3_spawn =
{
	local float n;
	local vector snoworg;

	n = 0;
	while ((n < MOVETYPE_PUSH))
	{
		snoworg = self.origin;
		snoworg_x = snoworg_x + RandomRange (-128, FL_NOTARGET);
		snoworg_y = snoworg_y + RandomRange (-128, FL_NOTARGET);
		snoworg_z = snoworg_z + RandomRange (0, FL_GODMODE);
		MakeFlake (snoworg);
		n = n + 1;
	}
	self.nextthink = ((time + 0.3) + RandomRange (1.5, FL_SWIM));
	self.think = efx3_spawn;
};

void (vector FlakeOrg) MakeFlake =
{
	local entity Flake;

	Flake = spawn ();
	setmodel (Flake, "progs/s_bubble.spr");
	setorigin (Flake, FlakeOrg);
	Flake.movetype = MOVETYPE_NOCLIP;
	Flake.solid = SOLID_NOT;
	Flake.classname = "SnowFlake";
	Flake.frame = 1;
	Flake.cnt = 0;
	Flake.velocity_z = -64;
	Flake.think = FlakeFloat;
	Flake.touch = SUB_Remove;
	Flake.nextthink = (time + 0.5);
	Flake.cnt = 0;
	setsize (Flake, '-8 -8 -8', '8 8 8');
};

void () FlakeFloat =
{
	local float rnd1;
	local float rnd2;

	self.cnt = (self.cnt + 1);
	if ((self.cnt == SVC_INTERMISSION))
	{
		remove (self);
	}
	rnd1 = self.velocity_x + (-10 + (random () * 20));
	rnd2 = self.velocity_y + (-10 + (random () * 20));
	if ((rnd1 > MOVETYPE_BOUNCE))
	{
		rnd1 = MOVETYPE_FLY;
	}
	if ((rnd1 < -10))
	{
		rnd1 = CONTENT_LAVA;
	}
	if ((rnd2 > MOVETYPE_BOUNCE))
	{
		rnd2 = MOVETYPE_FLY;
	}
	if ((rnd2 < -10))
	{
		rnd2 = CONTENT_LAVA;
	}
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.cnt = (self.cnt + 1);
	if ((self.cnt > 30))
	{
		remove (self);
	}
	self.nextthink = (time + 0.7);
	self.think = FlakeFloat;
};

float (float min, float max) RandomRange =
{
	local float width;
	local float offset;
	local float result;

	width = max - min;
	offset = random () * width;
	result = offset + min;
	return (result);
};

void () bobbing_think =
{
	local vector ang;

	self.count = (self.count + (self.speed * (time - self.ltime)));
	if ((self.count > 360))
	{
		self.count = (self.count - 360);
	}
	ang_x = self.count;
	ang_y = 0;
	ang_z = 0;
	makevectors (ang);
	self.origin_z = (v_forward_z * self.cnt);
	setorigin (self, self.origin);
	self.ltime = time;
	self.nextthink = (time + 0.02);
};

void () func_bobbingwater =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_STEP;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	self.think = bobbing_think;
	self.count = 0;
	self.cnt = (self.size_z / 2);
	if (!self.speed)
	{
		self.speed = 4;
	}
	self.speed = (360 / self.speed);
	self.nextthink = (time + 0.02);
	self.ltime = time;
};

void () rain_touch =
{
	remove (self);
};

void () rain_think =
{
//	local float temp1;
//	local float temp2;
	local vector rain_org;
	local vector rain_vel;
	local entity drop;

	rain_org = self.origin;
	drop = spawn ();
	setorigin (drop, rain_org);
	setmodel (drop, "progs/rain.mdl");
	drop.fullbright = 1;
	drop.skin = self.cnt;
	drop.angles_y = rint ((359 * random ()));
	drop.classname = "raindrop";
	drop.movetype = MOVETYPE_TOSS;
	drop.solid = SOLID_BBOX;
	setsize (drop, VEC_ORIGIN, VEC_ORIGIN);
	rain_vel = VEC_ORIGIN;
	rain_vel_z = -20 * random ();
	drop.touch = rain_touch;
	drop.velocity_z = -850;
	drop.think = check4liquid;
	drop.nextthink = time;
	self.nextthink = (time + 0.2);
	self.think = rain_think;
};

void () check4liquid =
{
	if ((pointcontents (self.origin) < CONTENT_SOLID))
	{
		remove (self);
	}
	self.think = check4liquid;
	self.nextthink = time;
};

void () func_raining =
{
//	local vector spot;

	precache_model ("progs/rain.mdl");
	setorigin (self, self.origin);
	self.model = string_null;
	if (((self.cnt < 0) || (self.cnt > 4)))
	{
		self.cnt = 0;
	}
	if (self.targetname)
	{
		self.use = begin_rain;
	}
	else
	{
		self.think = rain_think;
		self.nextthink = ((time + 0.3) + random ());
	}
};

void () begin_rain =
{
	self.use = SUB_Remove;
	self.think = rain_think;
	self.nextthink = ((time + 0.3) + random ());
};

void () func_floating =
{
	func_drift ();
	setsize (self, self.mins, self.maxs);
};

void () func_drift =
{
	if ((world.model == "maps/neh1m9.bsp"))
	{
		if ((coop || deathmatch))
		{
			func_wall ();
			return;
		}
	}
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_FLYMISSILE;
	self.solid = SOLID_SLIDEBOX;
	setmodel (self, self.model);
	if (self.targetname)
	{
		self.use = drift_trigger;
		return;
	}
	drift_trigger ();
};

void () drift_trigger =
{
	self.use = SUB_Null;
	self.touch = experiment_push;
	self.think = brush_drift;
	self.nextthink = (time + 0.1);
};

void () brush_drift =
{
//	local vector spot;
//	local vector spot2;
//	local vector dave;
	local float vel1;
	local float vel2;

	vel1 = rint ((5 * random ()));
	vel2 = rint ((5 * random ()));
	if ((random () < 0.5))
	{
		vel1 = vel1 * -1;
	}
	else
	{
		vel2 = vel2 * -1;
	}
	self.velocity_x = (self.velocity_x + vel1);
	self.velocity_y = (self.velocity_y + vel2);
	if ((self.velocity_z != 0))
	{
		self.velocity_z = 0;
	}
	self.think = brush_drift;
	self.nextthink = (time + 0.1);
};
