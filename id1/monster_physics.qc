void(float num_bubbles) DeathBubbles;

/*
s->waterlevel = WATERLEVEL_NONE;
	
VectorSet(origin1, s->origin[0], s->origin[1], s->origin[2] + s->mins[2] + 1);
s->waterlevel = WATERLEVEL_WETFEET;

origin1[2] = s->origin[2] + (s->mins[2] + s->maxs[2]) * 0.5f;
s->waterlevel = WATERLEVEL_SWIMMING;

origin1[2] = s->origin[2] + 22;
s->waterlevel = WATERLEVEL_SUBMERGED;
*/

vector (entity ent) feetlevel =
{
	local vector feet;

	feet = ent.origin + 0.5*(ent.mins + ent.maxs);
	feet_z = ent.absmin_z + 1;

	return feet;
};

vector (entity ent) headlevel =
{
	local vector head;

	head = ent.origin + 0.5*(ent.mins + ent.maxs);
	head_z = ent.absmin_z + 0.7*ent.size_z;

	return head;
};

vector (entity ent) waistlevel =
{
	local vector head;

	head = ent.origin + 0.5*(ent.mins + ent.maxs);
	head_z = ent.absmin_z + 0.4*ent.size_z;

	return head;
};

//returns contents for specified level 
float (entity ent, float level) checkwatertype =
{
	local vector lvl;

	if (level == LEVEL_FEET)
	{
		lvl = feetlevel(ent);
		return pointcontents(lvl);
	}
	else if (level == LEVEL_WAIST)
	{
		lvl = waistlevel(ent);
		return pointcontents(waistlevel(ent));
	}
	else if (level == LEVEL_EYES)
	{
		lvl = headlevel(ent);
		return pointcontents(headlevel(ent));
	}
	else
		return CONTENT_EMPTY;
};


//checks how deep the monster is submerged and returns the level
float(entity ent) monsterwaterlevel =
{
	if (checkwatertype(ent, LEVEL_EYES) < CONTENT_SOLID)
		return LEVEL_EYES;
	if (checkwatertype(ent, LEVEL_WAIST) < CONTENT_SOLID)
		return LEVEL_WAIST;
	if (checkwatertype(ent, LEVEL_FEET) < CONTENT_SOLID)
		return LEVEL_FEET;
	return LEVEL_NONE;
};


//checks if we're in a water of some kind and returns its type
float(entity ent) monsterwatertype =
{
	local float wt, lvl;

	lvl = monsterwaterlevel(ent);

	wt = checkwatertype(ent, lvl);

	return wt;		
};

float(entity ent) entwaterlevel =
{

	if (ent.flags & FL_CLIENT)
		return ent.waterlevel;
	else
		return monsterwaterlevel(ent);

	return LEVEL_NONE;
};

float(entity ent) entwatertype =
{
	local float lvl;

	if (ent.flags & FL_CLIENT)
		return ent.watertype;
	else
	{
		lvl = monsterwaterlevel(ent);
		return checkwatertype(ent, lvl);
	}

	return CONTENT_EMPTY;
};


/*
==============================================================================
 adjusts pitch and roll if on slope
==============================================================================
*/
//.float slope_pitch;
//.float slope_roll;
//.vector slopeangles;

void(entity ent) slope_angles =
{
	local vector org, org2, ang, pitchdir, rolldir, norm;
	local float pitch_sin, roll_sin, pitch, roll;

	if (ent.movetype == MOVETYPE_NOCLIP)	// ignore observers
		return;

	if (!ent.solid)
		return;

//	if (ent.size == VEC_0)	// not initialized
//	if (ent.origin == VEC_0)
//		return;

// hack to avoid traceline runaways for ents placed upside down 
	if (ent.angles_x > 90 || ent.angles_x < -90)
		return;

	if (ent.angles_z > 90 || ent.angles_z < -90)
		return;

// trace line downwards and try to hit a ground plane
	org = ent.origin;

	if (ent.flags & FL_MONSTER)
	if (!checkclient())
		return;

	org2 = org + '0 0 -16';	// use small dist to account for thin walkways and such 
	traceline(org, org2, MOVE_NOMONSTERS, ent);

// if unsuccessful, then increment and trace again
	while ((trace_fraction == 1) && (org_z - org2_z >= ent.mins_z))	
	{
		org2 = org2 + '0 0 -8';
		traceline(org, org2, MOVE_NOMONSTERS, ent);

		if (org2_z <= -1024)	// prevent runaways
			break;
	}

	norm = trace_plane_normal;

	if (checkbottom(ent) &&		// on ground
	    (trace_fraction != 1) && 	// touching the ground
	    (norm_x || norm_y))		// ground plane is a slope
	{
		ang = ent.angles;
	
		if (ent.flags & FL_CORPSE)
		{
			ang_x = 0;
			ang_z = 0;
		}
		else if (ent.flags & FL_CLIENT)
			ang_z = 0;	// no roll, for client rollangle
	
		makevectors(ang);
	
		pitchdir = vreverse(v_forward);
		rolldir = v_right;
	
		pitch_sin = pitchdir_x*norm_x + pitchdir_y*norm_y + pitchdir_z*norm_z;
		pitch = RAD2DEG*asin(pitch_sin);
		roll_sin = rolldir_x*norm_x + rolldir_y*norm_y + rolldir_z*norm_z;
		roll = RAD2DEG*asin(roll_sin);
	
		if (ent.flags & FL_CORPSE)
		{
			ent.angles_x = pitch;
			ent.angles_z = roll;
			return;
		}
	
		if (ent.flags & FL_MONSTER)
		{
			if (ent.enemy == world)
			{
				ent.idealpitch = pitch/3;
				changepitch(ent);
			}
//			ent.idealroll = roll/3;
//			changeroll(self);
			return;
		}
	
		if (ent.flags & FL_CLIENT)
		{
			ent.angles_x = ent.angles_x + pitch/3;
			ent.angles_z = ent.angles_z + roll/3;
		}
	}
	else if (ent.flags & FL_MONSTER)
	{
		if (ent.enemy == world)
		{	
			ent.idealpitch = 0;
			changepitch(ent);
		}
//		ent.idealroll = 0;
//		changeroll(self);
	}
};


/*
=============
clientvisible

returns 1 if the entity is visible to a client
=============
*/
float (vector org) clientvisible =
{
	local entity client;
	local vector spot1, spot2, vec, view1, view2, diff;

	client = checkclient();

	if (client == world)
		return FALSE;

	if (!(client.flags & FL_CLIENT))
		return FALSE;

	spot1 = org;
	spot2 = client.origin + client.view_ofs;
	vec = spot2 - spot1;

	if (vlen(vec) > 5000)		// long traces are slow
		return FALSE;

	traceline(spot1, spot2, MOVE_NOMONSTERS, self);	// see through other monsters
//	tracebox(spot1, self.mins, self.maxs, spot2, MOVE_NOMONSTERS, self);

	if (trace_fraction != 1)
		return FALSE;

	if (vlen(vec) < 64)	//if close enough, don't check viewangles
		return TRUE;

	vec = normalize(vec);
	view1 = anglemod_view(vectoangles(vec));
	view2 = client.v_angle;

	diff = anglemod_view(view1 - view2);
	
	if (fabs(diff_x) > 45)
		return FALSE;
	if (fabs(diff_y) > 60)
		return FALSE;

	return TRUE;
};
