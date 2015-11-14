float SEEKER_FRAMETIME	= 0.001;	//0.005;
float SEEKER_RUNSTEP	= 24;	//16;
float SEEKER_BACKDIST	= 256;
float SEEKER_RADIUS	= 1024;
float SEEKER_DELAY	= 0.5;
float SEEKER_VEL	= 1000;

void() seeker_charge;
void() seeker_findtargets;
void(entity targ) spawn_seeker;

void() seeker_run = [$attack8, seeker_run] {seeker_charge();};

void() seeker_charge =
{
	if (time - self.ltime > SEEKER_DELAY)
	{
		print("removed seeker (", etos(self), ") - timeout\n");
		remove(self);
		return;
	}

	if (!self.enemy || self.enemy.flags & FL_CORPSE)
	{
		print("removed seeker (", etos(self), ") - dead target\n");
		remove(self);
		return;
	}

	self.flags = self.flags - (self.flags & FL_ONGROUND);
	
	self.delay = SEEKER_FRAMETIME;
	self.nextthink = time + self.delay;

//	if (self.cnt > 1)
//	{
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
//		self.cnt = 0;
//	}
//	else
//		self.cnt++;

	changeyaw();
	movetogoal(SEEKER_RUNSTEP);
};

void() seeker_touch =
{
	if (other.classname == self.classname)
		return;

	if (other == self.owner)
		return;

	if (other != self.enemy)
		return;

	sound(self, CHAN_VOICE, "fish/bite.wav", 1, ATTN_NORM);
	T_Damage(self.enemy, self, self, 0, "");

	print("(", etos(self), ") other=", other.classname, " eta=", ftos(time - self.ltime), "\n");
	remove(self);
};

void() seeker_findtargets =
{
	local entity head;

	head = findradius(self.origin, SEEKER_RADIUS);
	while (head)
	{
		if (head != self)
		if (head.flags & FL_MONSTER)
		if (head.takedamage)
//		if (head.classname != "info_notnull")
		{
			spawn_seeker(head);
		}
		head = head.chain;
	}
};

void(entity targ) spawn_seeker =
{
	local entity e;

 	precache_model2 ("progs/fish.mdl");
	precache_sound2 ("fish/bite.wav");

	e = spawn();

	e.classname = "test_seeker";
	e.solid = SOLID_TRIGGER;			//SOLID_TRIGGER;
	e.movetype = MOVETYPE_FLYMISSILE;	//MOVETYPE_STEP;
	e.flags = FL_MONSTER | FL_FLY;
	e.effects = EF_DIMLIGHT;

	e.glow_color = 254;
	e.glow_size = 100;
	e.glow_trail = TRUE;

	setmodel (e, "progs/fish.mdl");
	setsize (e, VEC_0, VEC_0);

	makevectors(self.v_angle);
	setorigin (e, self.origin + 16*v_forward + '0 0 16');

	e.gravity = 0.001;
	e.scale = 0.4;
	e.mass = EXTRA_HIGH;
	e.takedamage = DAMAGE_NO;
	e.health = EXTRA_HIGH;

	e.th_stand = SUB_Null;
	e.th_die = SUB_Null;
   	e.th_pain = SUB_Null;
	e.th_melee = SUB_Null;
	e.th_gib = SUB_Null;
	e.th_sight = SUB_Null;
	e.use = SUB_Null;

	e.th_walk = seeker_run;
	e.th_run = seeker_run;
	e.touch = seeker_touch;

	e.yaw_speed = 1800;

	e.ltime = time;

	e.owner = self;
	e.enemy = targ;
	e.ideal_yaw = vectoyaw(e.enemy.origin - e.origin);

//	e.bouncefactor = 1;
//	e.velocity = SEEKER_VEL*normalize(e.enemy.origin - e.origin);

	e.think = seeker_run;
	e.nextthink = 1;

	print("spawned seeker (", etos(e), ")\n");

//	force_retouch = 2;
};
