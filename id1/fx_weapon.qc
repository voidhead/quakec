void() wallspike_touch =
{
	if (other.classname == self.classname)
	if ((random() > 0.5 && time - other.ltime > 10) || (other.origin == self.origin && time - other.ltime > 1))
	{
		other.nextthink = 1;
		other.think = SUB_Remove;
	}
};

// make a spike in the wall
void(vector org, entity en, vector dir) WallSpike =
{
	local entity e;
	local vector norm, axis, spikedir, spikeorg;
	local float planeang_sin, ang_delta;

	if (self.classname == "wizspike" || self.classname == "knightspike")
		return;

//	if (en.solid != SOLID_BSP || en.model == "")

	if (en.solid != SOLID_BSP)
	if (en.solid != SOLID_BBOX)
		return;

	if (en.solid == SOLID_BSP)
	if (en.model == "")
		return;

	if (en.solid == SOLID_BBOX)
	if (other.classname != "trigger_multiple")
	if (other.classname != "trigger_once")
//	if (other.classname != "misc_explobox")
//	if (other.classname != "misc_explobox2")
		return;
/*
	if (
		(en.solid != SOLID_BSP && en.solid != SOLID_BBOX) ||
		(en.solid == SOLID_BSP && en.model == "") ||
		(en.solid == SOLID_BBOX && other.classname != "trigger_multiple" && other.classname != "trigger_once")
	   )
		return;
*/
	traceline(self.origin, self.origin, MOVE_NORMAL, self);
	if (trace_dpstartcontents & DPCONTENTS_SKY)
		return;

	dir = normalize(dir);
	spikedir = vreverse(dir);
	traceline (org - dir, org + dir, MOVE_NORMAL, self);
	norm = trace_plane_normal;

	planeang_sin = spikedir*norm;

// normalize the impact angle if too shallow
	if (planeang_sin < 0.3)		// approx. 17.5 deg
	{
		ang_delta = 0.3 - planeang_sin;

		axis = crossproduct(spikedir, norm);
		axis = normalize(axis);
	
		dir = vrotate(dir, axis, ang_delta);
		dir = normalize(dir);
	}

	e = spawn();
	e.classname = "wallspike";
	e.solid = SOLID_TRIGGER;	//SOLID_BBOX;	//SOLID_NOT;
	e.frame = 0;
	e.touch = wallspike_touch;
	e.flags = FL_ONGROUND;
	e.groundentity = en;
	e.movetype = MOVETYPE_NONE;
	e.ltime = time;

	e.fadetime = 2;
	e.think = SUB_Fadeaway;		//SUB_Remove;
	e.nextthink = time + 30;	//30;

	e.effects = e.effects | EF_LOWPRECISION;
	e.skin = self.skin;
	e.alpha = self.alpha;

	setmodel (e, "progs/spike.mdl");	//s_spike.mdl
//	setsize (e, '0 0 0', '0 0 0');
	setsize (e, self.mins, self.maxs);

	spikeorg = org - dir*2.5;

	if (en.solid == SOLID_BBOX)
	if (other.classname != "misc_explobox")
	if (other.classname != "misc_explobox2")
		spikeorg += dir*8;	// - dir*2.5+

       	setorigin (e, spikeorg);	//org - dir * 3);

	e.angles = vectoangles(dir);

	if (en != world) 		// might be a mobile surface, follow it
	{
		e.aiment = en;
		e.movetype = MOVETYPE_FOLLOW;
		e.view_ofs = spikeorg - en.origin;		//(en.absmax + en.absmin)*0.5;	//en.origin;
		e.punchangle = en.angles;
		e.v_angle = e.angles - en.angles;
	}

	force_retouch = 2;
};

/*
==============================================================================

SHELL CASINGS

==============================================================================
*/

void() casing_touch =
{
	if (trace_dphitcontents & (DPCONTENTS_SKY | DPCONTENTS_NODROP))
	{
		remove(self);
		return;
	}

	if (other.solid == SOLID_BSP)
	{
//		self.velocity = self.velocity*0.8;

		if (vlen(self.velocity) >= 50)
		if (time >= self.attack_finished)
//		if (self.origin != self.dest + self.groundentity.origin)
		{
			sound7(self, CHAN_WEAPON, "weapons/tink1.wav", 0.5, ATTN_NORM, 70, 0);
	//		sound (self, CHAN_WEAPON, "weapons/tink1.wav", 0.5, ATTN_NORM);
			self.attack_finished = time + 0.2;
		}
	}

//	self.dest = self.origin - self.groundentity.origin;
};

void() casing_think =
{
/*
	local float p;

	if (self.flags & FL_ONGROUND)
	if (!self.lefty)
	{
	// just keep the yaw angle
		self.angles_x = 0;
		self.angles_z = 0;
		self.flags = self.flags - FL_ONGROUND;
		self.nextthink = time + 0.5;
	}

	p = pointcontents(self.origin);

	if (p == CONTENT_SOLID || p == CONTENT_LAVA || p == CONTENT_SKY)
	{
		removedecor(self);
		return;
	}
*/
	traceline(self.origin, self.origin, MOVE_NORMAL, self);

	if (trace_dpstartcontents & DPCONTENTS_LAVA)
	{
		self.fadetime = 0.7;
		self.think = SUB_Fadeaway;
		self.nextthink = time + 5 + 5*random();
		return;
	}

	else if (trace_dpstartcontents & DPCONTENTS_SLIME)
	{
		self.fadetime = 5;
		self.think = SUB_Fadeaway;
		self.nextthink = time + 15 + 5*random();
		return;
	}

	else if (trace_dpstartcontents & DPCONTENTS_NODROP) 
	{
		remove(self);
		return;
	}

	if (vlen(self.velocity) < 10)
	{
		self.avelocity_x = 0;
		self.idealpitch = anglemod_ground(self.angles_x);
		changepitch(self);
	}

	if (vlen(self.velocity) == 0)
	{
//		slope_angles(self);
		self.effects = EF_NOMODELFLAGS;	// stop emitting smoke
		self.avelocity = VEC_0;
		self.touch = SUB_Null;
		self.fadetime = 1.5;
		self.think = SUB_Fadeaway;
		self.nextthink = time + 60 + random()*20;
		return;
	}

	self.nextthink = time + 0.2;	//0.1
};

void(vector org, vector vel, float randomvel, vector ang, vector avel, float randomavel) ejectcasing =
{
	local entity shell;

	shell = spawn();

	setmodel (shell, "progs/shell.mdl");
	setsize (shell, '-1 -2 -1', '1 2 1');
	setorigin (shell, org);

	tracebox(shell.origin, shell.mins, shell.maxs, shell.origin, MOVE_NOMONSTERS, shell);
	if (trace_allsolid == TRUE)
	{
		setsize (shell, VEC_0, VEC_0);
		setorigin (shell, org);
	}

	shell.classname = "shell";
	shell.movetype = MOVETYPE_BOUNCE;
	shell.solid = SOLID_TRIGGER;	//SOLID_BBOX;	//SOLID_TRIGGER;
	shell.effects = shell.effects | EF_LOWPRECISION;

	shell.touch = casing_touch;

	shell.pitch_speed = 20;

	shell.angles = ang;
	shell.avelocity = avel + randomvec()*randomavel;
	shell.velocity = vel + randomvec()*randomvel;

	if (deathmatch)
	{
		shell.nextthink = time + 5;
		shell.think = SUB_Remove;
	}
	else
	{
		shell.nextthink = time + 0.1;
		shell.think = casing_think;
	}
};

void(vector ofs, vector vel, float randomvel, vector avel, float randomavel) player_ejectcasing =
{
	local vector org;
/*
//	makevectors(self.angles);
//	ejectcasing(self.origin + 2*v_forward + 5*v_right + 8*v_up, v_right*120 + v_up*50, 40, self.angles_x*'-1 0 0' + self.angles_y*'0 1 0', '30 -200 0', 50);
//	ejectcasing(self.origin + 2*v_forward + 5*v_right + 8*v_up, v_right*120 + v_up*50, 30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '30 -200 0', 80);
//	ejectcasing(self.origin + 2*v_forward + 4*v_right + 8*v_up, v_right* -120 + v_up*50, 30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '30 200 0', 80);
*/
	makevectors(self.v_angle + self.punchangle);

	org = self.origin + self.view_ofs - v_up*6 + v_forward*12;	//12

//	v_forward*ofs_x + v_right*ofs_y + v_up*ofs_z

	ejectcasing(org + v_forward*ofs_x + v_right*ofs_y + v_up*ofs_z, v_forward*vel_x + v_right*vel_y + v_up*vel_z, randomvel, '-1 0 0'*self.v_angle_x + '0 1 0'*self.v_angle_y, avel, randomavel);
	
//	ejectcasing(org + -5*v_forward, v_right*120 + v_up*30, 40, self.v_angle_x*'-1 0 0' + self.v_angle_y*'0 1 0', '30 -200 0', 50);

//	ejectcasing(org -8*v_forward + v_right, v_right*120 + v_up*50, 30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '30 -200 0', 80);
//	ejectcasing(org -8*v_forward - v_right, v_right* -120 + v_up*50, 30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '30 200 0', 80);

//	ejectcasing(shotorg + v_forward * -5, 			v_right * 100 + v_up * 40, 	30, self.v_angle_x * '-1 0 0' + self.v_angle_y * '0 1 0', '0 250 0', 100, 1);
//	ejectcasing(vector org, vector vel, float randomvel, vector ang, vector avel, float randomavel);

};