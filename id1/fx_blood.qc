/*
================
SpawnBlood
================
*/
void(entity ent, vector org, vector vel, float damage) SpawnBlood =
{
	local float r;

	if (ent.flags & FL_GODMODE)
		return;

	if (ent.flags & FL_CORPSE)
		damage = damage/2;

	if (ent.flags & FL_NOBLOOD)
	{
		if (trace_ent.solid != SOLID_BSP)
			pointparticles(particleeffectnum("TE_SPARK"), org, '0 0 0', damage);
		return;
	}

	if (ent.takedamage)
	if (ent.solid == SOLID_BSP || ent.classname == "trigger_multiple" || ent.classname == "trigger_once")
	{
		pointparticles(particleeffectnum("EF_SECRET"), org, '0 0 0', damage);
		return;
	}

	if ((ent.classname == "monster_hell_knight") || (ent.classname == "monster_knight")
#ifdef HIPNOTIC
	 || (ent.classname == "monster_scourge")
#endif
	   )
	{
		r = random();
		if (r < 0.4)
		{
			pointparticles(particleeffectnum("TE_SPARK"), org, '0 0 0', damage);
			te_blood(org, vel, damage);
		}
		else
			te_blood(org, vel, damage*2);
		return;
	}

	if (ent.classname == "monster_tarbaby")
	{
		pointparticles(particleeffectnum("TE_TARBLOOD"), org, vel, damage*2);
		return;
	}

	if (ent.classname == "monster_wizard")
	{
		pointparticles(particleeffectnum("TE_WIZBLOOD"), org, vel, damage*2);
		return;
	}

//	particle (org, vel*0.1, 73, damage*2);
	te_blood(org, vel, damage*2);
};

void(entity ent, vector dir, float damage) SpawnBlood_Expl =
{
	local vector org, vel;
	local float effectnum;
//	local entity missile;

	if (ent.flags & FL_GODMODE)
		return;

	if (ent.flags & FL_NOBLOOD)
		return;

	if (ent.flags & FL_GIBBED)
		return;

	if (ent.flags & FL_CORPSE)
		damage /= 4;

//	print("damage=", ftos(damage), "\n");

	damage = ceil(damage/4);

	if (damage <= 4)
		return;

	if (damage > 128)
		damage = 128;

//	print("iterations=", ftos(damage), "\n");
/*
	pos_x = self.origin_x + 0.7*crandom()*(0.5*self.size_x);
	pos_y = self.origin_y + 0.7*crandom()*(0.5*self.size_y);
	pos_z = self.origin_z + 0.7*crandom()*self.size_z;	//random()*self.size_z;
	pos_z = self.absmin_z + (0.6 + 0.2*crandom())*self.size_z;
*/
	while (damage > 0)
	{
//		org_x = ent.origin_x + 0.6*crandom()*ent.size_x;
//		org_y = ent.origin_y + 0.6*crandom()*ent.size_y;
//		org_z = ent.absmin_z + (0.5 + 0.2*crandom())*ent.size_z;
//		org = ent.origin;

		org_x = ent.origin_x + getrandom2(1, -1)*(0.2 + 0.2*random())*ent.size_x;
		org_y = ent.origin_y + getrandom2(1, -1)*(0.2 + 0.2*random())*ent.size_y;
		org_z = ent.absmin_z + (0.4 + 0.3*crandom())*ent.size_z;

		dir = 200*normalize(dir);	//200*randomdirvec();

		vel = (1.2 - 0.4*random())*dir;
		vel_x = vel_x + 50*crandom();
		vel_y = vel_y + 50*crandom();
		vel_z = vel_z + 100 + 50*random();

//		printvector (vel);

//		te_blood(org, vel, 3);
//		pointparticles(particleeffectnum("EF_BLOOD_EXPL"), org, vel, 1);
//		SpawnMeatSpray(org, vel);

		if (ent.classname == "monster_tarbaby")
			effectnum = particleeffectnum("TE_TARBLOOD");
		else if (ent.classname == "monster_wizard")
			effectnum = particleeffectnum("TE_WIZBLOOD");
		else
			effectnum = particleeffectnum("TE_BLOOD");

		pointparticles(effectnum, org, vel, 3);

/*		missile = spawn ();
		missile.owner = ent;
		missile.movetype = MOVETYPE_BOUNCE;
		missile.solid = SOLID_TRIGGER;
		
		missile.velocity = vel;
		
//		missile.avelocity_x = random()*1000;
//		missile.avelocity_y = random()*1000;
//		missile.avelocity_z = random()*1000;
		
		missile.nextthink = time + 3;
		missile.think = SUB_Remove;
		missile.touch = SUB_Null;	//SUB_Remove;	//meatspraytouch;
		
		setmodel (missile, "progs/zom_gib.mdl");
		setsize (missile, '0 0 0', '0 0 0');		
		setorigin (missile, org);

		missile.effects = missile.effects | EF_LOWPRECISION;
//		missile.effects = missile.effects | EF_NODRAW;
//		missile.alpha = -1;
		missile.classname = "gib";
*/
		damage--;
	}
}

void(float effectnum, vector pmins, vector pmaxs, float pvel, float pcount) SpawnBlood_Shower =
{
	local float i;
	local vector org, pos, vel, dir;

	org = 0.5*(pmins + pmaxs);

	for (i = 0; i < pcount; i++)
	{
		pos_x = random2(pmins_x, pmaxs_x);
		pos_y = random2(pmins_y, pmaxs_y);
		pos_z = random2(pmins_z, pmaxs_z);

		dir = normalize(pos - org);
		vel = dir*pvel*random();

		pointparticles(effectnum, pos, vel, 1);
	}
};

void(float damage) CreateBloodshower =
{
	local float pcount, pvel, effectnum;
	local vector pmins, pmaxs;

	pcount = fabs(damage);
	pcount = ceil(pcount*0.5);
	if (pcount > 128)	// limit the number of particles
		pcount = 128;

	pvel = 64 + 2*pcount + 32*crandom();

	pmins = self.origin + self.mins + '-2 -2 -2';
	pmaxs = self.origin + self.maxs + '2 2 2';
	if (self.flags & FL_CORPSE)	// move up a little 
		pmaxs_z += 16;

	if (self.classname == "monster_tarbaby")
		effectnum = particleeffectnum("TE_TARBLOOD");
	else if (self.classname == "monster_wizard")
		effectnum = particleeffectnum("TE_WIZBLOOD");
	else
		effectnum = particleeffectnum("TE_BLOOD");

//	te_bloodshower(pmins, pmaxs, pvel, pcount);
	SpawnBlood_Shower(effectnum, pmins, pmaxs, pvel, pcount);	
};

vector() wall_velocity =
{
	local 	vector	vel;

	makevectors(self.angles);	

	vel = normalize(self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel*200;
	
	return vel;
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local 	vector	vel;

	vel = wall_velocity()*0.2;
	SpawnBlood (other, self.origin + vel*0.01, vel, damage);
};
