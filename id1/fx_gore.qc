vector(float dm, vector dir) VelocityForDamage =
{
	local vector v, gib_dir;

	if (vlen(dir))
	{
		gib_dir = normalize(dir);
		v_x = 100*gib_dir_x + 20*crandom();		//(random() * 70 - 35);
		v_y = 100*gib_dir_y + 20*crandom();		//(random() * 70 - 35);

		if (gib_dir_z < 0 && gib_dir_z > -0.33)
			gib_dir_z = fabs(gib_dir_z);

		v_z = 150 + 50*gib_dir_z + 25*crandom();	//150 + 50*gib_dir_z + 35*crandom();	//(random() * 70 - 35);	//100 * random();
	}
	else
	{
		v_x = 100*crandom();
		v_y = 100*crandom();
		v_z = 200 + 100*random();	
	}

//	if (self.classname == "monster_oldone")
//	{
//		v_z = 0.3*v_z;
//	}

//	if (self.flags & FL_CORPSE)
//	{
//		v = v*0.5;
//	}

	if (dm > -50)
	{
		v = v*0.8;
	}
	else if (dm > -100)
	{
		v = v*1.2;
	}
	else if (dm > -200)
	{
		v = v*2;
	}
	else
	{
		v = v*10;
	}

	return v;
};


void() meatspraytouch =
{
	if (other.classname == "gib")
		return;

	if (trace_dphitcontents & DPCONTENTS_SKY)
	{
		self.touch = SUB_Null;
		self.nextthink = 1;
		self.think = SUB_Remove;
		return;
	}

	if (other.solid != SOLID_BSP)
		return;

	if (trace_plane_normal_z > 0.7)
	{
		self.touch = SUB_Null;
		self.nextthink = 1;
		self.think = SUB_Remove;
		return;
	}

	if (trace_plane_normal_z == 0)
	{
		sound(self, CHAN_WEAPON, "zombie/z_miss.wav", 0.5, ATTN_NORM);
		self.nextthink = self.nextthink + 5;
	}
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
//	local entity missile;
//	local vector org;

	if (deathmatch)
		return;

	newmis = spawn();

	// don't throw a gib if in a NODROP zone (such as lava)
//	traceline(self.origin, self.origin, MOVE_NORMAL, self);
	tracebox(org, VEC_0, VEC_0, org, MOVE_NOMONSTERS, newmis);
	if (trace_dpstartcontents & (DPCONTENTS_NODROP | DPCONTENTS_SKY) || trace_allsolid)
	{
		remove(newmis);
		return;
	}

	newmis.classname = "gib";
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_TRIGGER;

	makevectors (self.angles);

	newmis.velocity = (1.2 - 0.5*random())*vel;
	newmis.velocity_z = newmis.velocity_z + 250 + 50*random();

//	newmis.avelocity = '3000 1000 2000';
	newmis.avelocity_x = random()*3000;
	newmis.avelocity_y = random()*3000;
	newmis.avelocity_z = random()*3000;
	
// set newmis duration
	newmis.nextthink = time + 3;
	newmis.think = SUB_Remove;
	newmis.touch = meatspraytouch;

	newmis.effects = newmis.effects | EF_LOWPRECISION;
	setmodel (newmis, "progs/zom_gib.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, org);

//	newmis.traileffectnum = particleeffectnum("TR_BLOOD");
};


/*
================
ThrowGib
================
*/
void() GibSplat =
{
	local float r;

	if (other.classname == "gib")
		return;

	if (other.solid == SOLID_NOT)
		return;

	if (trace_dphitcontents & DPCONTENTS_SKY)
	{
		self.touch = SUB_Null;
		self.nextthink = 1;
		self.think = SUB_Remove;
		return;
	}

	if (self.pain_finished > time)
		return;

	r = random();
	if (r < 0.1)
	{
		if (!(self.owner.flags & FL_NOBLOOD))
			sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 0.5, ATTN_NORM);
		else
			sound7(self, CHAN_WEAPON, "weapons/tink1.wav", 0.5, ATTN_NORM, 110, 0);

		self.pain_finished = time + 0.5;
	}

//	self.nextthink = time + 0.5;
//	self.touch = SUB_Null;
};


void() GibThink =
{
	traceline(self.origin, self.origin, MOVE_NOMONSTERS, self);

	if (trace_dpstartcontents & DPCONTENTS_LAVA)
	{
		spawnsmoker('0 0 4', '8 8 2', 10, 4, 0, 3);
		self.colormod = TINT_LAVA;
		self.touch = SUB_Null;
		self.fadetime = 4;
		self.think = SUB_Fadeaway;
		self.nextthink = time + 1 + 2*random();
		return;
	}
	else if (trace_dpstartcontents & DPCONTENTS_SLIME)
	{
		self.colormod = TINT_SLIME;
		self.touch = SUB_Null;
		self.fadetime = 10;
		self.think = SUB_Fadeaway;
		self.nextthink = time + 4 + 4*random();
		return;
	}
	else if (trace_dpstartcontents & DPCONTENTS_NODROP) 
	{
		remove(self);
		return;
	}

	if (vlen(self.velocity) == 0)
	{
		self.avelocity = VEC_0;
		self.touch = SUB_Null;
		self.fadetime = 5;
		self.think = SUB_Fadeaway;
		self.nextthink = time + 30 + random()*30;
		return;
	}

	self.touch = GibSplat;
	self.nextthink = time + 0.2;
};

void(string gibname, float dm, vector dir) ThrowGib =
{
	local entity newgib;
	local vector org, pos;
	local float try, grnd;

	newgib = spawn();
	newgib.classname = "gib";

	setmodel(newgib, gibname);

	if (gibname == "progs/gib1.mdl")
		setsize (newgib, '-4 -4 -4', '4 4 4');	//'-16 -16 -2', '16 16 30');
	else if (gibname == "progs/gib2.mdl")
		setsize (newgib, '-8 -8 -8', '8 8 8');
	else if (gibname == "progs/gib3.mdl")
		setsize (newgib, '-4 -4 -4', '4 4 4');
	else if (gibname == "progs/zom_gib.mdl")
		setsize (newgib, '-2 -2 -2', '2 2 2');
	else if (gibname == "progs/tar_gib.mdl")
		setsize (newgib, '-5 -5 -5', '5 5 5');
	else
		setsize (newgib, VEC_0, VEC_0);

	org = self.origin;
	grnd = self.absmin_z;

	do
	{
		try++;

		pos_x = org_x + 0.3*crandom()*self.size_x;
		pos_y = org_y + 0.3*crandom()*self.size_y;
		pos_z = grnd + (0.5 + 0.3*crandom())*self.size_z;

		if (self.flags & FL_CORPSE)
			pos_z += 0.5*newgib.size_z;

		if (try > 32)
		{
			setsize(newgib, VEC_0, VEC_0);
//			print("!!!gib ", etos(newgib), "spawn in solid!!!\n");
		}

		setorigin(newgib, pos);
		tracebox(newgib.origin, newgib.mins, newgib.maxs, newgib.origin, MOVE_NOMONSTERS, newgib);
//		print(gibname, " ", trace_allsolid?"stuck\n":"not stuck\n");
	}
	while (trace_allsolid == TRUE);

//	print(gibname, " ", ftos(try), " tries\n");

	if (trace_dpstartcontents & DPCONTENTS_LAVA)
		newgib.colormod = TINT_LAVA;
	else if (trace_dpstartcontents & DPCONTENTS_SLIME)
		newgib.colormod = TINT_SLIME;

	if (self.classname == "monster_wizard")
	{
		newgib.traileffectnum = particleeffectnum("TR_WIZBLOOD");
		newgib.skin = 1;
	}
	else if (self.classname == "monster_tarbaby")
		newgib.traileffectnum = particleeffectnum("TR_TARBLOOD");

	if (!(self.flags & FL_NOBLOOD))
	{
		SpawnMeatSpray(pos, newgib.velocity);
		newmis.alpha = -1;

		if (self.classname == "monster_wizard")
			newmis.traileffectnum = particleeffectnum("TR_WIZBLOOD");
		else if (self.classname == "monster_tarbaby")
			newmis.traileffectnum = particleeffectnum("TR_TARBLOOD");
	}
/*
	if (trace_dpstartcontents & DPCONTENTS_NODROP)
	if (self.classname != "player")
	if (self.classname != "bodyque")
	{
		newgib.touch = SUB_Null;
		newgib.think = SUB_Remove;
		newgib.nextthink = 1;
		return;
	}

	if (trace_startsolid)
	{
//		print("gib in solid\n");
		newgib.velocity = newgib.avelocity = VEC_0;
		newgib.touch = SUB_Null;
		newgib.fadetime = 0.1;
		newgib.think = SUB_Fadeaway;
		newgib.nextthink = 1;
		return;
	}
*/
	newgib.movetype = MOVETYPE_BOUNCE;
	newgib.solid = SOLID_TRIGGER;
	newgib.owner = self;

//	newgib.bouncefactor = 0.4;

	newgib.velocity = VelocityForDamage (dm, dir);

	newgib.avelocity_x = random()*600;
	newgib.avelocity_y = random()*600;
	newgib.avelocity_z = random()*600;

	newgib.alpha = 1;
	newgib.frame = 0;
	newgib.effects = newgib.effects | EF_LOWPRECISION;
	newgib.flags = newgib.flags - (newgib.flags & FL_ONGROUND);

//	newgib.oldorigin = newgib.origin;

	newgib.touch = SUB_Null;
	newgib.think = GibThink;
	newgib.nextthink = time + 0.1;	//0.2
};


/*
================
ThrowHead
================
*/

void() HeadRest =
{
	self.avelocity = VEC_0;
	self.solid = SOLID_NOT;
	self.touch = SUB_Null;
	self.nextthink = -1;

//	traceline(self.origin, self.origin, MOVE_NORMAL, self);
	tracebox(self.origin, self.mins, self.maxs, self.origin, MOVE_NOMONSTERS, self);

//	if (trace_dpstartcontents & DPCONTENTS_NODROP)
//	if (self.classname != "player")
//	if (self.classname != "bodyque")
//		self.model = "";

	if (trace_dpstartcontents & DPCONTENTS_LAVA)
		spawnsmoker('0 0 8', '8 8 2', 10, 4, 0, 10 + 10*random());

// deathcam (tm)
	if (self.classname == "bodyque")
	{
		if (self.aiment.flags & FL_CLIENT)
		{
			if (self.aiment.ishuman)	//frikbot
			if (!autocvar_chase_active)
			{
				self.aiment.angles_y = self.angles_y - 5;
				self.aiment.angles_z = self.angles_z - 30 + 5*crandom();
				self.aiment.punchangle = VEC_0;
				self.aiment.fixangle = TRUE;
			}
	
			self.aiment.velocity = VEC_0;
			self.aiment.avelocity = VEC_0;
			self.aiment.nextthink = -1;
	
			// allow respawn after a certain time
			self.aiment.deadflag = DEAD_DEAD;
		}
	}

	if (qonquer)
	{
		self.minion = FALSE;
		self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		entity_sink_setup();
	}
};

void() HeadSplat =
{
	local float r;

	if (other.classname == "gib")
		return;

//don't touch the deathcam
	if (other == self.aiment)
	if (self.classname == "bodyque")
		return;

	if (other.solid == SOLID_NOT)
		return;

	if (trace_dphitcontents & DPCONTENTS_SKY)
	{
		self.model = "";
		self.think = HeadRest;
		self.nextthink = time + 0.5;
		return;
	}

// kick the player's view a little
	if (!autocvar_chase_active)
	if (self.aiment.flags & FL_CLIENT)
	if (self.classname == "bodyque")
	{
		self.aiment.punchangle_x = 20*crandom();
		self.aiment.punchangle_y = 20*crandom();	
		self.aiment.punchangle_z = 20*crandom();	
	}	

	if (self.pain_finished > time)
		return;

	if (self.model)
	{
		r = random();
		if (r < 0.1)
		{
			sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 0.5, ATTN_NORM);
			self.pain_finished = time + 0.5;
		}
	}

//	self.nextthink = time + 0.2;
//	self.touch = SUB_Null;
};

void() HeadThink =
{
	traceline(self.origin, self.origin, MOVE_NOMONSTERS, self);

	if (trace_dpstartcontents & DPCONTENTS_LAVA)
	{
		self.colormod = TINT_LAVA;
		spawnsmoker('0 0 8', '8 8 2', 10, 2, 0, 0.5);
	}
	else if (trace_dpstartcontents & DPCONTENTS_SLIME)
	{		
		self.colormod = TINT_SLIME;
	}
	else if (trace_dpstartcontents & DPCONTENTS_NODROP)
	{
		if (self.classname != "player")
		if (self.classname != "bodyque")
		{
	//		dprint("head removed");
	//		dprint("\n");
			self.model = "";
	//		setmodel (self, "");
	//		setmodel (self.aiment, "");
	//		self.aiment.model = "";
			self.think = HeadRest;
			self.nextthink = time + 3;
			return;
		}
	}

	if (vlen(self.velocity) == 0)
	{
//		if (self.classname == "bodyque")
//			self.aiment.fixangle = FALSE;
//		self.aiment.angles = self.angles;
//		self.aiment.fixangle = TRUE;

		self.avelocity = VEC_0;
		self.touch = SUB_Null;
		self.think = HeadRest;
		self.nextthink = 1;
		return;
	}
	
	if (self.aiment.flags & FL_CLIENT)
	if (!autocvar_chase_active)
	{
		local vector ang;

//		print("player view adjust ", ftos(self.angles_y), " ", ftos(self.aiment.angles_y), "\n");
//		print(ftos(time - self.nextthink), "\n");
//		self.aiment.v_angle = self.angles;
//		self.aiment.v_angle = VEC_0;	//'0 0 45';

//		self.aiment.angles_x = self.angles_x;		//-20;
//		self.aiment.angles_z = self.angles_z;

//		self.aiment.v_angle_y = self.angles_y;	//anglemod(self.angles_y - self.aiment.mangle_y); //self.aiment.mangle_y - self.angles_y;		// + 10;

//		self.aiment.punchangle_x = 10*crandom();

		ang = self.aiment.v_angle;
		self.aiment.angles_y = self.angles_y - 5;
		self.aiment.angles_z = self.angles_z - 30;
		self.aiment.fixangle = TRUE;
		self.aiment.v_angle = ang;
		
		self.nextthink = time + 0.01;
		self.touch = HeadSplat;
		return;
	}

	self.nextthink = time + 0.2;
	self.touch = HeadSplat;
};

void(string gibname, float dm, vector dir) ThrowHead =
{
	local float try, grnd;
	local vector org, pos;

//	pos_x = self.origin_x + 0.1*random2(self.mins_x, self.maxs_x);
//	pos_y = self.origin_y + 0.1*random2(self.mins_y, self.maxs_y);
//	pos_z = self.origin_z + 0.5*random2(self.mins_z, self.maxs_z);

//	pos = self.origin;
//	pos_z = self.absmin_z + (0.7 + 0.2*crandom())*self.size_z;

	setmodel (self, gibname);

	if (gibname == "progs/h_player.mdl")
		setsize (self, '-12 -12 0', '12 12 18');
	else if (gibname == "progs/h_demon.mdl")
		setsize (self, '-16 -16 0', '16 16 26');
	else if (gibname == "progs/h_dog.mdl")
		setsize (self, '-10 -10 0', '10 10 16');
	else if (gibname == "progs/h_guard.mdl")
		setsize (self, '-8 -8 0', '8 8 16');
	else if (gibname == "progs/h_hellkn.mdl")
		setsize (self, '-12 -12 0', '12 12 18');
	else if (gibname == "progs/h_knight.mdl")
		setsize (self, '-8 -8 0', '8 8 16');
	else if (gibname == "progs/h_mega.mdl")
		setsize (self, '-11 -11 0', '11 11 18');
	else if (gibname == "progs/h_ogre.mdl")
		setsize (self, '-11 -11 0', '11 11 24');
	else if (gibname == "progs/h_shal.mdl")
		setsize (self, '-17 -17 0', '17 17 24');
	else if (gibname == "progs/h_shams.mdl")
		setsize (self, '-16 -16 0', '16 16 28');
	else if (gibname == "progs/h_wizard.mdl")
		setsize (self, '-10 -10 0', '10 10 16');
	else if (gibname == "progs/h_zombie.mdl")
		setsize (self, '-8 -8 0', '8 8 14');
	else
		setsize (self, '-16 -16 0', '16 16 32');

	org = self.origin;
	grnd = self.absmin_z;

	do
	{
		try++;

		pos_x = org_x + 0.2*crandom()*self.size_x;
		pos_y = org_y + 0.2*crandom()*self.size_y;
		pos_z = grnd + (0.7 + 0.2*crandom())*self.size_z;

		if (self.flags & FL_CORPSE)
			pos_z += 0.5*self.size_z;

		if (try > 32)
		{
			setsize(self, VEC_0, VEC_0);
//			print("!!!head ", etos(self), " spawn in solid!!!\n");
		}

		setorigin(self, pos);
		tracebox(self.origin, self.mins, self.maxs, self.origin, MOVE_NOMONSTERS, self);
	}
	while (trace_allsolid == TRUE);

//	print(gibname, " ", ftos(try), " tries\n");

	if (trace_dpstartcontents & DPCONTENTS_LAVA)
	{
		self.colormod = TINT_LAVA;
	}
	else if (trace_dpstartcontents & DPCONTENTS_SLIME)
	{
		self.colormod = TINT_SLIME;
	}

	if (self.classname == "monster_tarbaby")
		self.traileffectnum = particleeffectnum("TR_TARBLOOD");
	else if (self.classname == "monster_wizard")
		self.traileffectnum = particleeffectnum("TR_WIZBLOOD");
/*	
	if (trace_dpstartcontents & DPCONTENTS_NODROP)
	if (self.classname != "player")
	if (self.classname != "bodyque")
	{
//		self.think = HeadRest;
//		self.nextthink = time + 1;
//		setmodel (self, "");
//		setsize (self, '-16 -16 0', '16 16 56');
		setmodel (self, "");
		self.touch = SUB_Null;
		self.think = HeadRest;
		self.nextthink = 1;		
		return;
	}

	if (trace_startsolid)
	{
//		print("head in solid\n");
		self.velocity = self.avelocity = VEC_0;
		self.touch = SUB_Null;
		self.think = HeadRest;
		self.nextthink = 1;
		self.movetype = MOVETYPE_TOSS;
		droptofloor(0,0);
		return;
	}
*/
	self.velocity = VelocityForDamage (dm, dir);	
	self.avelocity = crandom()*'0 600 0';

	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_NO;

	self.view_ofs = '0 0 8';

	self.frame = 0;
	self.effects = self.effects | EF_LOWPRECISION;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.flags = self.flags - (self.flags & FL_CORPSE);

	if (!(self.flags & FL_CLIENT))
		self.touch = SUB_Null;

	self.think = HeadThink;
	self.nextthink = 1;	//time + 0.2;
};
