/*
void () spawn_smokethang =
{
	local entity head;
	local float stime;
	local vector org;

	stime = time - self.ltime;

	if (stime > self.delay || !self.aiment)
	{
		remove(self);
		return;
	}

	org = self.origin;
	org_x = org_x + 2*crandom();
	org_y = org_y + 2*crandom();

	head = spawn ();
	head.alpha = -1;
	head.solid = SOLID_TRIGGER;
	head.movetype = MOVETYPE_NOCLIP;
	head.velocity = '0 0 100';
	head.velocity_z = head.velocity_z + self.speed + 200*random ();
	setmodel(head, "progs/spike.mdl");
	setsize(head, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (head, org);
	head.effects = head.effects & EF_NODRAW;
	head.modelflags = MF_GRENADE;
	head.nextthink = time + self.wait;
	head.think = SUB_Remove;

	if (!self.pausetime)
		self.nextthink = time + 0.01 + random();
	else
		self.nextthink = time + 0.01 + self.pausetime;
};
*/
float (vector org) clientvisible;

void () spawn_smokethang =
{
	local float stime, puffs;
	local vector org, vel;

	if (!self.owner)
	{
		remove(self);
		return;
	}	
	else
		self.owner.smoke_finished = TRUE;
	
	self.nextthink = time + self.pausetime;

	stime = time - self.ltime;
	if (stime > self.delay)
	{
		if (self.owner)
			self.owner.smoke_finished = FALSE;

		remove(self);
		return;
	}

	if (!clientvisible(self.origin))
	{
//		print("no client visible\n");
		return;
	}

	org_x = self.origin_x + self.size_x*crandom();
	org_y = self.origin_y + self.size_y*crandom();
	org_z = self.origin_z + self.size_z*crandom();

	vel = '0 0 1'*self.speed*random();

	puffs = self.cnt;

	pointparticles(particleeffectnum("EF_SMOKETHANG"), org, vel, puffs);
};


void(vector offs, vector spacing, float vel, float puffs, float rate, float ttl) spawnsmoker =
{
	local entity e;

// don't spam smokes if previous ones are still active
	if (self.smoke_finished)
	{
//		print("skip smoker\n");
		return;
	}

//	org = feetlevel(self) + offs;
//	if (!clientvisible(org))
//	{
//		print("no client visible\n");
//		return;
//	}

	e = spawn();
	setorigin (e, feetlevel(self));
	setsize (e, 0.5*vreverse(spacing), 0.5*spacing);	// for random positioning of puffs
	e.classname = "smoker";
	e.aiment = self;
	e.view_ofs = offs;					// offset from spawner ent
	e.movetype = MOVETYPE_FOLLOW;
	e.solid = SOLID_NOT;
	e.effects = e.effects | EF_LOWPRECISION;

	e.speed = vel;						// vertical speed of smoke
	e.cnt = puffs;						// number of particles
	e.pausetime = rate;					// time between releasing puffs
	e.delay = ttl;						// how long the smoker should exist 

	if (!self.speed)
		self.speed = 20;
	if (!self.cnt)
		self.cnt = 1;
	if (!self.pausetime)
		self.pausetime = 0.5;
	if (!self.delay)
		self.delay = 5;

	e.ltime = time;
	e.owner = self;

	e.nextthink = time + 0.01 + 0.5*random();
	e.think = spawn_smokethang;
};
