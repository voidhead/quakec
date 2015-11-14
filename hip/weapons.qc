/*
================
HIPNOTIC WEAPONS
================
*/
void() HIP_LaserTouch =
{
	local vector org;
	local vector spot1, spot2;
	local vector oldvel;
//	local float mag;
//	local float r;

	self.owner = world;
	self.cnt = self.cnt + 1;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	oldvel = normalize(self.old_velocity);
	spot1 = self.origin - (16*oldvel);
	spot2 = self.origin + (16*oldvel);
	traceline (spot1, spot2, FALSE, self);  	// see through other monsters
	self.origin = trace_endpos;

	org = self.origin;

	if (other.health)
	{
		if (self.lastvictim == other)
			self.dmg = self.dmg/2;

		spawn_touchblood (self.dmg);
		T_Damage (other, self, self.lastvictim, self.dmg, "hiplaser");
	}

	else if ((self.cnt == 3) || (random() < 0.15))
	{
		if (CheckQuad(self.lastvictim))
			te_gunshotquad(org);
		else
			te_gunshot(org);
	}

	else
	{
//		self.dmg = 0.66*self.dmg;
		self.dmg = 0.9*self.dmg;
//		self.speed = 0.95*self.speed;

		self.velocity = oldvel + 2*trace_plane_normal;
		self.velocity = normalize(self.velocity);
		self.velocity = self.speed*self.velocity;
		self.old_velocity = self.velocity;

		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;

//		r = random();
		sound (self, CHAN_WEAPON, "hipweap/laserric.wav", 1, ATTN_STATIC);
/*
		if (r < 0.33)
			sound (self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
		else if (r < 0.66)
			sound (self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
		else
			sound (self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
*/
		return;
      }

	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	remove(self);
};

void() HIP_LaserThink =
{
//	local float delta;
	
	if (time > self.attack_finished)
	{
		remove(self);
		return;
	}

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;

	if (CheckQuad(self.lastvictim))
		self.glow_color = 144;
	else
		self.glow_color = 251;

	self.velocity = self.old_velocity;
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.05;
};

void(vector org, vector vec, float flash) HIP_LaunchLaser =
{
//	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	sound (self ,CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.classname = "hiplaser";
	newmis.lastvictim = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

//	if (flash)
//	{
//		newmis.effects = EF_DIMLIGHT;
		newmis.glow_color = 251;
		newmis.glow_size = 70;
		newmis.glow_trail = FALSE;
//	}

	setmodel (newmis, "progs/lasrspik.mdl");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, org);

	newmis.speed = 1000;
	newmis.dmg = 18;
	newmis.velocity = vec*newmis.speed;
	newmis.old_velocity = newmis.velocity;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.avelocity = '0 0 400';

	newmis.traileffectnum = particleeffectnum("TR_SPIKE");

	newmis.nextthink = 1;
	newmis.attack_finished = time + 5;
	newmis.think = HIP_LaserThink;
	newmis.touch = HIP_LaserTouch;
	newmis.count = 0;
};

/*
=================
HIP_FireLaser
=================
*/
void(float stat) HIP_FireLaser =
   {
	local vector org;
	local vector dir;
	local vector out;
	local float ofs;
	local float aofs;

	if (!self.button0)
	{
		player_run ();
		return;
	}

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	SuperDamageSound();
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.v_angle);
	
	ofs = 6;
	out = v_forward;
	out_z = 0;
	out = normalize(out);
//	org = self.origin + self.view_ofs - 10*v_up + 32*v_forward;	//12
	org = self.origin + (12 - ofs)*v_up + 12*out;	//12
//	org = self.origin + self.view_ofs - 6*v_up + v_forward*15;
//	org = self.origin + 1*v_forward;

	dir = aim (self, 1000);
	aofs = ofs*0.707;

	if (stat == 0)
	{
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;
		org = org + aofs*v_right;
		org = org - aofs*v_up;
		HIP_LaunchLaser(org, dir, 0);
		org = org - 2*aofs*v_right;
		HIP_LaunchLaser(org, dir, 0);
	}
	else if (stat == 1)
	{
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;
		org = org + ofs*v_up;

		if (random() < 0.1)
		{
			HIP_LaunchLaser(org, dir, 1);
			newmis.dmg = 25;
		}

		else
			HIP_LaunchLaser(org, dir, 0);
	}

	self.punchangle_x = -1;
};

/*
=================
HIP_HammerDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage =
{
	local	entity	e1, e2;		//, otemp;
	local	vector	f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

//	traceline (p1, p2, FALSE, self);
	weapontraceline (p1, p2, FALSE, self);

	if (trace_ent.takedamage)
	if (!trace_ent.wetsuit_finished)
	{
//		otemp = other;
//		other = trace_ent;
		SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*2);
//		other = otemp;

		T_Damage (trace_ent, from, from, damage, "zap");

		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	} else
		te_plasmaburn(trace_endpos);

	e1 = trace_ent;
//	traceline (p1 + f, p2 + f, FALSE, self);
	weapontraceline (p1 + f, p2 + f, FALSE, self);

	if (trace_ent != e1)
	if (trace_ent.takedamage)
	if (!trace_ent.wetsuit_finished)
	{
//		otemp = other;
//		other = trace_ent;
		SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*2);
//		other = otemp;

		T_Damage (trace_ent, from, from, damage, "zap");
	} else
		te_plasmaburn(trace_endpos);

	e2 = trace_ent;
//	traceline (p1 - f, p2 - f, FALSE, self);
	weapontraceline (p1 - f, p2 - f, FALSE, self);

	if (trace_ent != e1 && trace_ent != e2)
	if (trace_ent.takedamage)
	if (!trace_ent.wetsuit_finished)
	{
//		otemp = other;
//		other = trace_ent;
		SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*2);
//		other = otemp;

		T_Damage (trace_ent, from, from, damage, "zap");
	} else
		te_plasmaburn(trace_endpos);
};

/*
void() HIP_DiversionLightningThink =
{
	local vector   org,end;
	
	if (time > self.delay)
	{
		remove(self);
		return;
	}
	
	makevectors(self.v_angle);
	org = self.origin;
	end = org + v_forward*200;
//	end = end + (((200*random()) - 100) * v_up);
	end = end + (((400*random()) - 200) * v_right);
	
	traceline (org, end, TRUE, self);
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	
	self.nextthink = time + 0.1;
};
*/

//void(entity prev, entity owner, float dst) HIP_SpawnMjolnirLightning;
void() HIP_LightningThink =
{
	local vector org;
	local vector dst;
	local entity head;
	local entity selected;
	local float cur_dist;
	local float head_dist;
	local vector vec;
	local float dot;
	local float oldstate;
	local float dam;


	if (time > self.delay)
	{
		if (self.enemy != world)
			self.enemy.struck_by_mjolnir = FALSE;
		remove(self);
		return;
	}

	oldstate = self.state;
	if (self.state == 0)
	{
	// look in our immediate vicinity
		self.enemy = world;
		selected = world;
		cur_dist = self.distance;
		head = findradius(self.owner.origin, self.distance);
		while (head)
		{
			if (!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT)))
			{
				if (visible(head) && (head != self.owner.owner) && (head.health > 0))
				{
					head_dist = vlen(head.origin - self.lastvictim.origin);
	
					if ((head_dist < cur_dist) && (head.struck_by_mjolnir == FALSE))
					{
						selected = head;
						cur_dist = head_dist;
					}
				}
			}
			head = head.chain;
		}
	
		if (selected != world)
		{
			self.state = 1;
			self.enemy = selected;
			self.enemy.struck_by_mjolnir = TRUE;
		}
		else
		{
			local vector end;
		
			makevectors(self.v_angle);
			org = self.owner.origin;
			end = org + v_forward*200;
			end = end + (400*random() - 200)*v_right;
			
//			traceline (org, end, TRUE, self);
			weapontraceline (org, end, TRUE, self);

			te_lightning2(self, org, trace_endpos);
			trailparticles(self, particleeffectnum("TR_SPIKE"), org, trace_endpos);
/*
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity (MSG_BROADCAST, self);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
			WriteCoord (MSG_BROADCAST, trace_endpos_x);
			WriteCoord (MSG_BROADCAST, trace_endpos_y);
			WriteCoord (MSG_BROADCAST, trace_endpos_z);
*/			
			self.nextthink = time + 0.1;
//			self.think = HIP_DiversionLightningThink;
//			self.nextthink = time;
//			self.delay = time + 0.30;
//			self.origin = self.owner.origin;
//			self.think();

			return;
		}
	}

	org = self.lastvictim.origin;
	dst = self.enemy.absmin + 0.25*(self.enemy.absmax - self.enemy.absmin);
	dst = dst + (random()*0.5*(self.enemy.absmax - self.enemy.absmin));
//	traceline (org, dst, TRUE, self.owner.owner);
	weapontraceline (org, dst, TRUE, self.owner.owner);

	if (trace_fraction != 1.0 || self.enemy.health <= 0)
	{
		self.enemy.struck_by_mjolnir = FALSE;
		self.state = 0;
		self.nextthink = time + 0.1;
		return;
	}

	te_lightning2(self, org, trace_endpos);
	trailparticles(self, particleeffectnum("TR_SPIKE"), org, trace_endpos);
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
*/

	vec = normalize(self.enemy.origin - self.owner.origin);
	dot = vec*self.owner.movedir;
	head = self;
	self = self.owner.owner;

	if (oldstate == 0)
		dam = 80;
	else
		dam = 30;

	if (dot > 0.3)
		HIP_HammerDamage (org, trace_endpos, self, dam);
	else
		HIP_HammerDamage (org, trace_endpos, self, dam*0.5);
	self = head;

	self.nextthink = time + 0.2;
};

void(entity prev, entity own, float dst) HIP_SpawnMjolnirLightning =
{
	local	entity	lightning;
// spawn actual lightning
	lightning = spawn();
	lightning.delay = time + 0.8;
	lightning.state = 0;
	lightning.lastvictim = prev;
	lightning.distance = dst;
	lightning.owner = own;
	lightning.v_angle = self.angles;
	lightning.v_angle_x = 0;
	lightning.v_angle_z = 0;
	lightning.origin = own.origin;
	lightning.think = HIP_LightningThink;
	lightning.nextthink = time;
};

void() HIP_SpawnMjolnirBase =
{
	local	entity	lightning;

// spawn lightning base
	lightning= spawn();
//	light.origin = self.origin - '0 0 24' + (32*v_forward);
	lightning.origin = trace_endpos;
	lightning.flags = 0;
	lightning.owner = self;
	lightning.struck_by_mjolnir = TRUE;
	lightning.think = SUB_Remove;
	lightning.nextthink = time + 1;
	sound (lightning, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
	sound (lightning, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
	makevectors(self.v_angle);
	lightning.movedir = v_forward;
	HIP_SpawnMjolnirLightning(lightning, lightning, 350);
	HIP_SpawnMjolnirLightning(lightning, lightning, 350);
	HIP_SpawnMjolnirLightning(lightning, lightning, 350);
	HIP_SpawnMjolnirLightning(lightning, lightning, 350);
};

void() HIP_FireMjolnirLightning =
{
//	local	vector	org;
	local	float	cells;

// explode if under water
	if (self.waterlevel > LEVEL_FEET)
	{
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world, "mjolnir_discharge");
		return;
	}

//	if (self.t_width < time)
//	{
//		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
//		self.t_width = time + 0.6;
//	}
//	self.punchangle_x = 12;

	self.currentammo = self.ammo_cells = self.ammo_cells - 15;

	HIP_SpawnMjolnirBase();
};

void() HIP_FireMjolnir =
{
	local	vector	org;
//	local	float	cells;
	local	float	damage;
	local	vector	source;
//	local	vector	ang;
//	local	entity 	otemp;
	local	float	r;

	self.attack_finished = time + 0.4;
//	source = self.origin + '0 0 16';
	source = self.origin + self.view_ofs - 6*v_up;
//	ang = self.angles;
//	ang_x = 0;
//	ang_y = 0;

	makevectors(self.v_angle);

	weapontraceline(source, source + v_forward*32, FALSE, self);	//32

	if (trace_fraction == 1.0)
	if (self.ammo_cells >= 15)
	{
		source = source + v_forward*32;
		weapontraceline (source, source - v_up*50, FALSE, self);

//		dprint("fraction = ");
//		dprint(ftos(trace_fraction));
//		dprint("\n");

		if (trace_fraction > 0.3)
		if (trace_fraction < 1.0)
		{
			HIP_FireMjolnirLightning();
			self.attack_finished = time + 1.5;
			return;
		}
	}

	else
		weapontraceline(source, source + v_forward*64, FALSE, self);

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		damage = 50;

		if (trace_ent.classname == "monster_zombie")
			damage = 70;

		trace_ent.axhitme = TRUE;

		if (trace_ent.solid == SOLID_BSP)
			sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
		else
		{
			r = random();
			if (r > 0.66)
				sound (self, CHAN_WEAPON, "hipweap/mjolslam1.wav", 1, ATTN_NORM);
			else if (r > 33)
				sound (self, CHAN_WEAPON, "hipweap/mjolslam2.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_WEAPON, "blob/hit1.wav", 1, ATTN_NORM);
		}

//		otemp = other;
//		other = trace_ent;
		SpawnBlood (trace_ent, org, v_forward, damage);
//		other = otemp;

		T_Damage (trace_ent, self, self, damage, "mjolnir_melee");
	}
	else
	{  // hit wall
		if (trace_fraction != 1.0)
		{
			sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
	
			if (CheckQuad(self))
				te_gunshotquad(org);
			else
				te_gunshot(org);		
/*
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
*/
		}
		else
			sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
	}

	self.attack_finished = time + 0.4;
};

void() ProximityExplode =
{
	self.glow_size = 0;

	T_RadiusDamage (self, self.owner, 95, world, "proximity");

	te_explosion(self.origin);
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	BecomeExplosion ();
};

/*
================
ProximityGrenadeExplode
================
*/
void() ProximityGrenadeExplode =
{
	   self.takedamage = DAMAGE_NO;
	   NumProximityGrenades = NumProximityGrenades - 1;
//	   self.deathtype = "exploding";
	   self.nextthink = time + 0.1;
	   self.think = ProximityExplode;
	   self.owner = self.lastvictim;
};

/*
================
ProximityGrenadeTouch
================
*/
void() ProximityGrenadeTouch =
{
	if (other == self)
		return;

	if (other.classname == self.classname)
		return;

	self.movetype = MOVETYPE_TOSS;

	if (self.state == 1)
		return;

	if (vlen(other.velocity) > 0)
	{
	      ProximityGrenadeExplode();
	      self.think();
	      return;
	}

	if (other.takedamage == DAMAGE_AIM)
	{
		ProximityGrenadeExplode();
		self.think();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM); // bounce sound
	self.movetype = MOVETYPE_NONE;

//	if (vlen(self.velocity) == 0)
//		setsize (self, '-8 -8 -8', '8 8 8');

	self.state = 1;
	self.spawnmaster = other;
};

/*
================
ProximityBomb
================
*/
void() ProximityBomb =
   {
	local entity   head;
	local float    blowup;

	if (vlen(self.velocity) == 0)
		setsize (self, '-8 -8 -8', '8 8 8');

	if (!self.cnt)
		sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);

	if ((self.cnt & 7) == 1)
	{
		self.glow_size = 150;
	}	
	else
	{
		self.glow_size = 0;
	}

//	print(ftos(self.cnt), " ", ftos(self.cnt & 11), "\n");

	if ((time > self.delay) || (NumProximityGrenades > MAX_PROXIMITY_GRENADES) || (vlen(self.spawnmaster.velocity) > 0))
	{
	      ProximityGrenadeExplode();
	      self.think();
	      return;
	}

	self.owner = world;
	self.takedamage = DAMAGE_YES;
	head = findradius(self.origin, 140);
	blowup = FALSE;

	while (head)
	{
		if ((head != self) && (head.health > 0) && (head.flags & (FL_CLIENT | FL_MONSTER)) && (head.classname != self.classname))
			blowup = TRUE;
		if ((head.classname == self.classname) && (head.state == 0))
			blowup = TRUE;

		traceline(self.origin, head.origin, TRUE, self);

		if (trace_fraction != 1.0)
			blowup = FALSE;

		if (blowup == TRUE)
		{
			self.glow_size = 300;
			sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);
			ProximityGrenadeExplode();
			self.nextthink = time + 0.5;
			return;
		}

		head = head.chain;
	}

	self.cnt++;
	self.nextthink = time + 0.25;	//0.25;
};

/*
================
W_FireProximityGrenade
================
*/
void() W_FireProximityGrenade =
{
	local entity missile;	//, mpuff;

	NumProximityGrenades = NumProximityGrenades + 1;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);
	
	self.punchangle_x = -2;
	
	missile = spawn ();
	missile.owner = self;
	missile.lastvictim = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
	missile.classname = "proximity_grenade";
	missile.takedamage = DAMAGE_NO;
	missile.health = 5;
	missile.state = 0;

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '100 600 100';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = ProximityGrenadeTouch;

	missile.glow_color = 251;

// set missile duration
	missile.nextthink = time + 2;
	missile.delay = time + 15 + 10*random();
	missile.think = ProximityBomb;
	missile.th_die = ProximityGrenadeExplode;

	setmodel (missile, "progs/proxbomb.mdl");
	setorigin (missile, self.origin);
	setsize (missile, '-1 -1 -2', '1 1 2');
//	setsize (missile, '-4 -4 -4', '4 4 4');
};
