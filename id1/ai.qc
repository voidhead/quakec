void() movetarget_f;
void() t_movetarget;
void() knight_walk1;
void() knight_bow6;
void() knight_bow1;
void() FoundTarget;
void() ogre_pull;
void() ogre_sight;

/*

.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.huntt_ime
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

walkmove(angle, speed) primitive is all or nothing
*/

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//

/*
void() ChangePitch =
{
	local float ideal, move;

// mod down the current angle
	current_pitch = self.angles_x;		//anglemod(self.angles_x);

	if (current_pitch > 180)
		current_pitch = current_pitch - 360;

	ideal = self.ideal_pitch;
	
	if (current_pitch == ideal)
		return;
	
	move = ideal - current_pitch;

//	dprint("ideal =");
//	dprint(ftos(ideal));
//	dprint("\n");

//	dprint("current =");
//	dprint(ftos(current_pitch));
//	dprint("\n");
	
//	dprint("move =");
//	dprint(ftos(move));
//	dprint("\n");

	if (ideal > current_pitch)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}
		
	if (move > 0)
	{
		if (move > self.yaw_speed)
			move = self.yaw_speed;
	}
	else
	{
		if (move < (0 - self.yaw_speed) )
			move = 0 - self.yaw_speed;
	}

//	current_pitch = anglemod (current_pitch + move);
	current_pitch = current_pitch + move;


	self.angles_x = current_pitch;
};
*/

void(entity ent) changeroll =
{
	local vector ang;
	local float current, ideal, move, rspeed;

// mod down the current angle
	ang = anglemod_view(ent.angles);

	current = ang_z;
	ideal = ent.idealroll;
	rspeed = ent.pitch_speed;	//ent.roll_speed;

	if (current == ideal)
		return;
	
	move = ideal - current;

//	print("ideal=");
//	print(ftos(ideal));
//	print("\n");

//	print(" current=");
//	print(ftos(current));
//	print("\n");
	
//	print(" move=");
//	print(ftos(move));
//	print("\n");

/*	if (ideal > current)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}*/

	ang_z = move;
	ang = anglemod_view(ang);
	move = ang_z;
		
	if (move > 0)
	{
		if (move > rspeed)
			move = rspeed;
	}
	else
	{
		if (move < (0 - rspeed))
			move = 0 - rspeed;
	}

//	print(" move2=");
//	print(ftos(move));
//	print("\n");

	current = current + move;

//	print(" current2=");
//	print(ftos(move));
//	print("\n");

//	ent.angles_z = ideal;
	ent.angles_z = current;
};


/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/


void() movetarget_f =
{
	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
	
};

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
"delay" delay to wait before proceeding to next segment;
*/
void() path_corner =
{
	movetarget_f ();
};


/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
local entity	temp;

	if (other.health < 1)
		return;

	if (other.movetarget != self)
		return;
	
	if (other.enemy)
		return;		// fighting, not following a path

	temp = self;
	self = other;
	other = temp;

	if (self.classname == "monster_ogre" || self.classname == "monster_ogre_marksman")
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

//dprint ("t_movetarget\n");

#ifdef HIPNOTIC
	if (other.target)
	{
#endif
		self.goalentity = self.movetarget = find(world, targetname, other.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			self.pausetime = time + EXTRA_HIGH;
			self.th_stand ();
			return;
		}

#ifdef HIPNOTIC
		else if (other.delay)
		{
			self.pausetime = time + other.delay;
			self.th_stand ();
		}
	}
	else
	{
	      self.pausetime = time + EXTRA_HIGH;
	      self.th_stand ();
	      return;
	}
#endif
};

#ifdef HIPNOTIC
/*
=============
t_followtarget

Something has bumped into a followtarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_followtarget =
{
	local	entity   temp;
	local	vector   spot1, spot2;
	local	entity   targ;
	local	entity   client;

	if (!(other.flags & FL_MONSTER))
		return;
	if (other.classname == "monster_decoy")
		return;
//	if (other.enemy == world)
//		return;

	if (other.wetsuit_time > time)
		return;

	targ = other.enemy;

// see if any entities are in the way of the shot
	spot1 = other.origin + other.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, other);
	if (trace_fraction == 1)
		return;

	if (other.enemy)
	{
// make the monster tame
	      other.oldenemy = other.enemy;
	      other.enemy = world;
	      other.think = other.th_walk;
	}

	temp = self;
	self = other;
	other = temp;

	self.goalentity = self.movetarget = find (world, targetname, other.target);

/*
	bprint("target ");
	bprint(other.target);
	bprint(" targetname ");
	bprint(self.goalentity.targetname);
	bprint(" origin ");
	bprint(vtos(self.goalentity.origin));
	bprint("\n");
*/

	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	self.wetsuit_time = time + 2;

	if (!self.movetarget)
	{
		if (self.oldenemy != world)
		{
			 self.enemy = self.oldenemy;
			 FoundTarget();
			 return;
		}
		else
		{
			client = checkclient ();
			if (!client)
			{
				self.enemy = client;
				FoundTarget();
				return;
			}

			self.pausetime = time + EXTRA_HIGH;
			self.th_stand ();
		}
	}
};


void() followtarget_f =
{
//	if (!self.targetname)
//	objerror ("monster_followtarget: no targetname");

	self.solid = SOLID_TRIGGER;
	self.touch = t_followtarget;
	setmodel (self, self.model);  // set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
//	setsize (self, '-8 -8 -8', '8 8 8');
};


/*QUAKED path_follow (0.5 0.3 0) ?
Monsters will stop what they are doing and follow to the path
*/
void() path_follow =
{
	followtarget_f ();
};


/*QUAKED path_follow2 (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will stop what they are doing and follow to the path
*/
void() path_follow2 =
{
	self.solid = SOLID_TRIGGER;
	self.touch = t_followtarget;
	setsize (self, '-8 -8 -8', '8 8 8');
};
#endif

void() monster_wanderpaththink =
{
	local vector v, v1, org;
	local float a, b, c;

	self.nextthink = time + 3 + 7*random();

	if (self.owner.health < 1) // dead (also handled in death code)
	{
//		print("removing wanderpath for ", etos(self.owner), "\n");
		self.owner.movetarget = world;
		remove(self);
		return;
	}

	if (self.enemy.health < 1)
		self.enemy = world;

	if (self.enemy)
	{
		org = self.enemy.origin;
		a = 512;
	}
	else
	{
		org = self.owner.origin;
		a = 1024;
	}

//	org = self.owner.origin;
//	a = 1024;
	b = -1;
	c = 10;

	while (c > 0)
	{
		v = randomvec();
		traceline(org, org + v*a, FALSE, self);
		v = trace_endpos - org - normalize(v)*16;
		if (vlen(v) > b)
		{
			b = vlen(v);
			v1 = v;
		}
		c = c - 1;
	}

	setorigin(self, v1 + org);
	self.owner.ideal_yaw = vectoyaw(self.origin - self.owner.origin);

	if (self.owner.classname == "monster_ogre" || self.owner.classname == "monster_ogre_marksman")
	if (!self.enemy)
	if (random() < 0.3)
		sound (self.owner, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);	// play chainsaw drag sound

};

void() monster_wanderpathtouch =
{
	if (other.health < 1)
		return;

	if (other.movetarget != self)	// this wanderpath is not ours
		return;

	if (other.enemy)		// fighting, not following a path
		return;

	monster_wanderpaththink();
};

void() monster_spawnwanderpath =
{
	local entity path;

//	print("creating wanderpath for ", etos(self), "\n");
	path = spawn();
	path.classname = "monster_wanderpath";
	path.solid = SOLID_TRIGGER;
	path.touch = monster_wanderpathtouch;
	setsize (path, '-8 -8 -512', '8 8 512');
	path.think = monster_wanderpaththink;
	path.nextthink = time + random()*10 + 1;
	path.owner = self;

	self.goalentity = self.movetarget = path;
	self.enemy_found = FALSE;
};


//============================================================================

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/
float(entity targ) range =
{
	local 	vector	spot1, spot2;
	local 	float	r;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 120)
		return RANGE_MELEE;
	if (r < 500)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/
float (entity targ) visible =
{
	local	vector	spot1, spot2;
	local	float	walpha;

	if (vlen(targ.origin - self.origin) > 5000) // long traces are slow
		return FALSE;

	if (targ.flags & FL_NOTARGET)
		return FALSE;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	walpha = cvar("r_wateralpha");

	if (trace_inopen && trace_inwater)	// sight line crossed contents
	{
		if (random() > walpha)		//monster sometimes can see through transparent water
		if (targ.watertype != CONTENT_LAVA)	//not in lava
			return TRUE;
		if (targ.classname == "monster_boss")	//see the boss's origin, which is below surface of lava
			return TRUE;		
		else
			return FALSE;
	}

	if (trace_fraction == 1)
	{
#ifdef HIPNOTIC
		visible_distance = vlen(spot2 - spot1);
#endif
		return TRUE;
	}

	return FALSE;
};


/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float	dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if (dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};


//============================================================================

/*
===========
ChangeYaw

Turns towards self.ideal_yaw at self.yaw_speed
Sets the global variable current_yaw
Called every 0.1 sec by monsters
============
*/
/*

void() ChangeYaw =
{
	local float		ideal, move;

//current_yaw = self.ideal_yaw;
// mod down the current angle
	current_yaw = anglemod( self.angles_y );
	ideal = self.ideal_yaw;
	
	if (current_yaw == ideal)
		return;
	
	move = ideal - current_yaw;
	if (ideal > current_yaw)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}
		
	if (move > 0)
	{
		if (move > self.yaw_speed)
			move = self.yaw_speed;
	}
	else
	{
		if (move < 0-self.yaw_speed )
			move = 0-self.yaw_speed;
	}

	current_yaw = anglemod (current_yaw + move);

	self.angles_y = current_yaw;
};

*/

#ifdef HIPNOTIC
// charmed stuff
//============================================================================
void() UpdateCharmerGoal =
{
	local	entity targ;
	local	vector d;
	
	d = normalize(self.origin - self.charmer.origin);
	
	if (self.huntingcharmer == 1)
	{
		targ = spawn();
		self.trigger_field = targ;
		setorigin(targ, self.charmer.origin);
		self.huntingcharmer = 2;
		self.goalentity = targ;
	}
	if (self.huntingcharmer == 2)
	{
		targ = self.trigger_field;
		traceline(self.origin, self.charmer.origin, TRUE, self);

		if (trace_fraction == 1.0)
		{
//			dprint("can see ");
//			dprint(vtos(self.charmer.origin));
//			dprint("\n");
			setorigin(targ, self.charmer.origin);
		}
	}
	else
	{
		targ = self.trigger_field;
		setorigin(targ, self.charmer.origin + d*300);
	}
};

//============================================================================
void() HuntCharmer =
{
	self.huntingcharmer = 1;
	UpdateCharmerGoal();
//	self.goalentity = self.charmer;
	self.think = self.th_walk;
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	self.nextthink = time + 0.1;
};

//============================================================================
void() FleeCharmer =
{
	self.huntingcharmer = 1;
	UpdateCharmerGoal();
	self.huntingcharmer = 3;
//	self.goalentity = self.charmer;
	self.think = self.th_walk;
//	self.ideal_yaw = vectoyaw(self.originself.goalentity.origin - self.origin);
	self.nextthink = time + 0.1;
};

//============================================================================
void() StopHuntingCharmer =
{
	self.goalentity = world;

	if (self.huntingcharmer > 1)
		remove(self.trigger_field);

	self.huntingcharmer = 0;
	self.think = self.th_stand;
	self.nextthink = time + 0.1;
};
#endif

//============================================================================

void() HuntTarget =
{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	SUB_AttackFinished (1);	// wait a while before first attack
};

void() FoundTarget =
{
	if (self.health < 1 || !self.th_run)
		return;

	if (self.enemy.health < 1 || !self.enemy.takedamage)
		return;

	if (self.enemy.flags & FL_NOTARGET)
	{
		self.enemy = world;
		return;
	}

	if (self.enemy.classname == "player")
	{
#ifdef HIPNOTIC
		if (self.charmed)
		{
			if ((self.charmer == self.enemy) || (self.charmer == self.enemy.charmer))
			{
				self.enemy = world;
				return;
			}
		}
#endif

	// let other monsters see this monster for a while
		if (!(self.enemy.flags & FL_NOTARGET))
		{
			sight_entity = self;
			sight_entity_time = time + 0.1;
		}
	}
	
#ifdef HIPNOTIC
	else if (self.charmed)
	{
		if (self.charmer == self.enemy.charmer)
		{
			self.enemy = world;
			return;
		}
	}
#endif

// wake up other monsters
	self.show_hostile = time + 1;

// stop wandering
	if (self.movetarget.classname == "monster_wanderpath")
	{
		if (!(self.spawnflags & SPAWNFLAG_WANDER))
		{
//			print("removing wanderpath for ", etos(self), "\n");
			remove(self.movetarget);
			self.movetarget = world;
		}
	}

// clear ambush
	if (self.classname != "monster_zombie")
		self.spawnflags =  self.spawnflags - (self.spawnflags & SPAWNFLAG_AMBUSH);
	else
		self.spawnflags =  self.spawnflags - (self.spawnflags & (SPAWNFLAG_CRUCIFIED + 1));
		

	if (self.classname == "monster_ogre" || self.classname == "monster_ogre_marksman")
	{
		if (!self.oldenemy)
		if (random() > 0.2)
		{	
			ogre_pull();
			return;
		}
		else if (random() > 0.66)
		{
			ogre_pull();
			return;
		}
		else
		{
			ogre_sight();
			HuntTarget();
			return;
		}
	}

	else
	{
		if (self.th_sight)
			self.th_sight();
		HuntTarget();
	}
};

// Qonquer - minion
float() FindMonster =
{
	local entity monster;

	if (self.enemy)
		return FALSE;

// TODO - get out if qonquer is not running

	monster = findradius(self.origin, 1500);

	while (monster)
	{
		if (self.minion)
		{
			if (monster != self)
			if (monster.flags & FL_MONSTER)
			if (monster.health > 0)
			if (visible(monster))
			if (!monster.minion)
			if (monster.classname != "monster_zombie")
			{
				// Prevent the minions from targetting zombies.  They don't know that they need to gib them.
				self.enemy = monster;
				break;
			}
		}
		else
		{
			if (monster != self)
			if (monster.flags & FL_MONSTER)
			if (visible(monster))
			if (monster.minion)
			{
				// % chance for monsters to target the minion rather than the player
				if (random() < (0.5 - 0.1*skill))	//0.35)
				{
					self.enemy = monster;
					break;
				}
			}
		}
		
		monster = monster.chain;
	}
	
	if (!self.enemy)
		return FALSE;

	FoundTarget();

	return TRUE;
};


/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
float() FindTarget =
{
	local entity client;
	local float r;

	if (self.health < 1)
		return FALSE;

	if (intermission_running)	// do not attack player during intermission
	{
		return FALSE;
	}

	// Qonquer - minion
	if (qonquer)
	if (FindMonster())
		return TRUE;
	// Qonquer - minion

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well

#ifdef HIPNOTIC
// charmed stuff
	if (self.charmed)
	{
//		self.effects = self.effects | EF_DIMLIGHT;

		if (self.huntingcharmer > 0)
		{
			UpdateCharmerGoal();
//			self.goalentity = self.charmer;
			r = vlen(self.origin - self.goalentity.origin);

			if (r < MIN_CHARMER_DISTANCE)
			{
//				dprint("stopping\n");
				if ((self.huntingcharmer == 3) && (r > TOOCLOSE_CHARMER_DISTANCE))
					return FALSE;
//				self.huntingcharmer = 0;
				StopHuntingCharmer();
				return TRUE;
			}
		}
		else if (vlen(self.origin - self.charmer.origin) > MAX_CHARMER_DISTANCE)
		{
//			self.huntingcharmer = 1;
//			dprint("hunting\n");
			HuntCharmer();
			return FALSE;
		}
		else if (vlen (self.origin - self.charmer.origin) < TOOCLOSE_CHARMER_DISTANCE)
		{
//			self.huntingcharmer = 1;
//			dprint("fleeing\n");
			FleeCharmer();
			return FALSE;
		}
	}
#endif

#ifdef ID1
	if ( (self.classname != "monster_zombie" && (self.spawnflags & SPAWNFLAG_AMBUSH)) ||
	     (self.classname == "monster_zombie" && (self.spawnflags & (SPAWNFLAG_CRUCIFIED + 1)))
           )
#endif

#ifdef HIPNOTIC
	if ( ( (self.classname != "monster_zombie" && (self.spawnflags & SPAWNFLAG_AMBUSH)) ||
	       (self.classname == "monster_zombie" && (self.spawnflags & (SPAWNFLAG_CRUCIFIED + 1)))
	     ) &&
	      !(self.charmed)
	   )
#endif
	{
		// don't wake up on seeing another monster getting angry
		client = checkclient ();
		if (!client)
			return FALSE;   // current check entity isn't in PVS

		else if (!infront(client) && range(client))
		{
			return FALSE;	
		}
	}
	else
	{
		if (sight_entity_time >= time)
		{
			client = sight_entity;
			if (client.enemy == self.enemy)
				return TRUE;
		}

#ifdef HIPNOTIC
// charmed clause
		else if (self.charmed)
		{
			local entity head;
			local entity selected;
			local float dist;
			
			selected = world;
			dist = CHARMED_RADIUS;
			head = findradius(self.origin, CHARMED_RADIUS);
		
			while(head)
			{
				if(!(head.flags & FL_NOTARGET) && (head.flags & FL_MONSTER))
				{
					if (visible(head) && (visible_distance < dist) && (head.health > 0))
					{
						if ((head != self) && (head != self.charmer) && (head.charmer != self.charmer))
						{
							selected = head;
							dist = visible_distance;
			          		}
					}
				}
				head = head.chain;
			}
		
			if (selected == world)
				return FALSE;
			
			client = selected;
		}
#endif

		else
		{
			client = checkclient ();
			if (!client)
				return FALSE;   // current check entity isn't in PVS
		}


	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_CORPSE)
		return FALSE;

#ifdef HIPNOTIC
	if (!self.charmed)
	{
#endif
		if (client.flags & FL_NOTARGET)
			return FALSE;
#ifdef HIPNOTIC
	}
#endif

	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);

	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

#ifdef HIPNOTIC
	if (!self.charmed)
	{
#endif
		if (r == RANGE_NEAR)
		{
			if (client.show_hostile < time && !infront (client))
				return FALSE;
		}
		else if (r == RANGE_MID)
		{
//			if ( /* client.show_hostile < time || */ !infront (client))
			if (client.show_hostile < time && !infront (client))
				return FALSE;
		}
#ifdef HIPNOTIC
	}
#endif
	
//
// got one
//

	// Qonquer - minion
	if (qonquer)
	{
		if (self.attack_state == AS_MINION)
			return FALSE;
	
		if (self.minion)
		{
			self.goalentity = client;
			self.attack_state = AS_MINION;
			self.th_walk();
			return TRUE;
		}
	}
	// Qonquer - minion

	if (client.model == "")
		return FALSE;

	self.enemy = client;

#ifdef HIPNOTIC
	if ((!self.charmed) && (!self.enemy.charmed))
	{
#endif
		if (self.enemy.classname != "player")
		{
			self.enemy = self.enemy.enemy;
			if (self.enemy.classname != "player")
			{
				self.enemy = world;
				return FALSE;
			}
		}
#ifdef HIPNOTIC
	}
#endif
	
	FoundTarget ();

	return TRUE;
};

//=============================================================================

void(float dist) ai_forward =
{
//	if (!(self.flags & FL_FLY))
//	if (!(self.flags & FL_SWIM))
//	if (!(self.flags & FL_ONGROUND))
//		return;

	walkmove(self.angles_y, dist);
};

void(float dist) ai_back =
{
//	if (!(self.flags & FL_FLY))
//	if (!(self.flags & FL_SWIM))
//	if (!(self.flags & FL_ONGROUND))
//		return;

	walkmove((self.angles_y + 180), dist);
};


/*
=============
ai_pain

stagger back a bit
=============
*/
void(float dist) ai_pain =
{
	if (self.health < 1)
		return;

//	if (!(self.flags & FL_FLY))
//	if (!(self.flags & FL_SWIM))
//	if (!(self.flags & FL_ONGROUND))
//		return;

	walkmove((self.angles_y + 180 + 30*crandom()), dist);

/*	ai_back (dist);

	local	float	away;
	
	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
	+ 180*(random()- 0.5) );
	
	walkmove (away, dist);
*/
};

/*
=============
ai_painforward

stagger back a bit
=============
*/
void(float dist) ai_painforward =
{
	if (self.health < 1)
		return;

//	if (!(self.flags & FL_FLY))
//	if (!(self.flags & FL_SWIM))
//	if (!(self.flags & FL_ONGROUND))
//		return;

	walkmove ((self.ideal_yaw + 30*crandom()), dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
//	local vector mtemp;

	if (self.health < 1)
		return;
	
	self.movedist = dist;
	
	if (self.classname == "monster_dragon")
	{
		movetogoal(dist);
		return;
	}

	// check for noticing a player
	if (self.oldenemy.takedamage)
	if (self.oldenemy.health >= 1)
	{
		self.enemy = self.oldenemy;
		self.oldenemy = world;
		FoundTarget();
		return;
	}

	if (self.enemy)
	{
		if (self.enemy.takedamage)
		{
			if (self.enemy.health >= 1)
			{
				FoundTarget();
				return;
			}
			else
				self.enemy = world;
		}
		else
			self.enemy = world;
	}

	self.enemy_found = FALSE;

#ifdef HIPNOTIC
	if (self.huntingcharmer)
	{
//		movetogoal (dist*2);
		movetogoal (dist);
		self.nextthink = time + ((self.nextthink - time)/2);
	}
	else
#endif
		movetogoal (dist);

	// Qonquer - minion
	if (qonquer)
	if (self.minion)
//	if (time > self.pausetime)
	if (vlen(self.origin - self.goalentity.origin) < 250)
	{
		self.pausetime = time + 1;
		self.th_stand();
	}
	// Qonquer - minion
};


/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() ai_stand =
{
	if (self.health < 1)
		return;

	if (self.enemy)
	{
		if (self.enemy.takedamage)
		{
			if (self.enemy.health >= 1)
			{
				FoundTarget();
				return;
			}
			else
				self.enemy = world;
		}
		else
			self.enemy = world;
	}

	self.enemy_found = FALSE;

// start wandering if we're flagged to do so and not following a path
	if (self.spawnflags & SPAWNFLAG_WANDER)
	if (!self.target)
	if (self.movetarget.classname != "monster_wanderpath")
	{
		monster_spawnwanderpath();
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk();	
	}

	if (time > self.pausetime)
	if (vlen(self.origin - self.goalentity.origin) > 250)
	{
		self.th_walk ();
		return;
	}
	
// change angle slightly

};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn =
{
	if (self.enemy)
	{
		if (self.enemy.takedamage)
		{
			if (self.enemy.health >= 1)
			{
				FoundTarget();
				return;
			}
			else
				self.enemy = world;
		}
		else
			self.enemy = world;
	}

	self.enemy_found = FALSE;
	
	changeyaw();
};


#ifdef HIPNOTIC
/*
=============
ai_turn_in_place

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn_in_place =
{
	local float delta;

	self.nextthink = time + 0.1;
	self.enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	delta = fabs(self.angles_y - self.enemy_yaw);

	if (delta > MIN_ANGLE_DELTA)
	{
		self.ideal_yaw = self.enemy_yaw;
		changeyaw();
	}
	else
		self.think = self.th_run;
};
#endif

//=============================================================================

/*
=============
ChooseTurn
=============
*/
void(vector dest3) ChooseTurn =
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};

/*
============
FacingIdeal

============
*/
float() FacingIdeal =
{
	local float delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	
	if (delta > 45)
	if (delta < 315)
		return FALSE;
	
	return TRUE;
};


//=============================================================================

float()	SoldierCheckAttack;
float()	OgreCheckAttack;
float()	ShamCheckAttack;
float()	DemonCheckAttack;
float()	DogCheckAttack;
float()	WizCheckAttack;
float() EnfCheckAttack;
float() ShalCheckAttack;
float() HknightCheckAttack;
float() ZombieCheckAttack;
float() BossCheckAttack;
float()	CheckAttack;
#ifdef HIPNOTIC
float() GremlinCheckAttack;
float() ScourgeCheckAttack;
float() ArmagonCheckAttack;
#endif

float() CheckAnyAttack =
{
	if (!self.enemy_vis)
		return FALSE;

	if (self.classname == "monster_army")
		return SoldierCheckAttack ();
	if (self.classname == "monster_ogre" || self.classname == "monster_ogre_marksman")
		return OgreCheckAttack ();
	if (self.classname == "monster_shambler")
		return ShamCheckAttack ();
	if (self.classname == "monster_demon1")
		return DemonCheckAttack ();
	if (self.classname == "monster_dog")
		return DogCheckAttack ();
	if (self.classname == "monster_wizard")
		return WizCheckAttack ();
	if (self.classname == "monster_enforcer")
		return EnfCheckAttack ();
	if (self.classname == "monster_shalrath")
		return ShalCheckAttack ();
	if (self.classname == "monster_hell_knight")
		return HknightCheckAttack ();
	if (self.classname == "monster_zombie")
		return ZombieCheckAttack ();
	if (self.classname == "monster_boss")
		return BossCheckAttack ();

#ifdef HIPNOTIC
	if (self.classname == "monster_gremlin")
		return GremlinCheckAttack ();
	if (self.classname == "monster_scourge")
		return ScourgeCheckAttack ();
	if (self.classname == "monster_armagon")
		return ArmagonCheckAttack ();
#endif

	return CheckAttack ();
};

/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) ai_run =
{
//	local	vector	delta;
//	local	float	axis;
//	local	float	direct, ang_rint, ang_floor, ang_ceil;
	local float ofs;
#ifdef HIPNOTIC
	local float newyaw;
	local float axis;
#endif

	if (self.health < 1)
		return;
	
	self.movedist = dist;

// if the enemy we were chasing has become invisible, ignore it and run towards our wanderpath
// also makes monsters run amok during intermission
	if ((self.enemy.flags & FL_NOTARGET && self.enemy.health >= 1) || 
            (self.enemy.flags & FL_CLIENT && intermission_running))
	{
		// go after old enemy if present
/*		if (self.oldenemy.health > 1)
		if (!(self.oldenemy.flags & FL_CORPSE))
		{
			self.enemy = self.oldenemy;
			self.oldenemy = world;
			HuntTarget();
			return;
		}
*/
		if (!(self.spawnflags & SPAWNFLAG_WANDER))
			monster_spawnwanderpath();
		else
			self.goalentity = self.movetarget;

		// transfer our enemy to the wanderpath so that it will use its origin
		if (!intermission_running)
			self.movetarget.enemy = self.enemy;

		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);

		self.enemy = world;
		self.enemy_found = FALSE;

		self.th_run();	
	}

// if wandering, just run to goal
	if (self.movetarget.classname == "monster_wanderpath")
	if (self.goalentity == self.movetarget)
	if (self.enemy == world)
	{
		self.enemy_found = FALSE;
		movetogoal(dist);
		return;
	}

// see if the enemy is dead
	if (self.enemy.health < 1 || (self.enemy.flags & FL_CORPSE)
#ifdef HIPNOTIC
	   || (self.charmed && (self.charmer == self.enemy))
#endif
	   )
	{
		self.enemy = world;

#ifdef HIPNOTIC
		if (self.charmed)
		{
			HuntCharmer();
			return;
		}
#endif

//		self.idealpitch = 0;
//		changepitch(self);

// FIXME: look all around for other targets
		if (self.oldenemy.health > 1 && !(self.oldenemy.flags & FL_CORPSE))
		{
			self.enemy = self.oldenemy;
			self.oldenemy = world;
			HuntTarget();
			return;
		}
		else if (self.target)
		{
			self.goalentity = self.movetarget = find(world, targetname, self.target);
			if (!self.movetarget)
			{	// this used to be an objerror
				dprint ("Monster can't find target at ");
				dprint (vtos(self.origin));
				dprint ("\n");
			}

			if (self.movetarget.classname == "path_corner")
				self.th_walk ();
			else
			{
				self.pausetime = EXTRA_HIGH;
				self.th_stand ();
			}
		}
		else if (self.movetarget.classname == "monster_wanderpath")
		{
			if (!(self.spawnflags & SPAWNFLAG_WANDER))
			{
//				print("removing wanderpath for ", etos(self), "\n");
				remove(self.movetarget);
				self.movetarget = world;
				self.pausetime = EXTRA_HIGH;
			}
			else
			{
				self.goalentity = self.movetarget;
				self.pausetime = time + 5 + 10*random();
			}
			self.th_stand ();
		}
		else if (qonquer)
		{
			activator = find (world, classname, "player");
	
			if (self.minion)
			{
				self.goalentity = activator;
				self.attack_state = AS_MINION;
				self.th_walk();
				return;
			}
			else if (!(activator.flags & FL_NOTARGET))
			{
				monster_use();
				return;
			}
			else
			{
				if (self.movetarget.classname != "monster_wanderpath")
				if (!(self.spawnflags & SPAWNFLAG_WANDER))
					monster_spawnwanderpath();

				self.movetarget.enemy = activator;
				self.goalentity = self.movetarget;
				self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
				self.enemy_found = FALSE;
				self.th_run();
				return;						
			}
		}
		else
		{
			self.pausetime = EXTRA_HIGH;
			self.th_stand ();
		}
		return;
	}

	self.show_hostile = time + 1;		// wake up other monsters

// check knowledge of enemy
	self.enemy_vis = visible(self.enemy);

	if (self.enemy_vis)
		self.search_time = time + 5;

	self.enemy_infront = infront(self.enemy);
	self.enemy_range = range(self.enemy);
	self.enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

// look for other coop players
	if (coop)
	if (self.search_time < time)
#ifdef HIPNOTIC
	if (!(self.charmed))
#endif
	{
		if (FindTarget())
			return;
	}

	
#ifdef HIPNOTIC
	if (self.th_turn)
	{
		local float angledelta;
		angledelta = fabs(self.angles_y - self.enemy_yaw);

		if (angledelta > MIN_ANGLE_DELTA)
		{
			self.th_turn();
			return;
		}
	}
#endif

// turn and close until within an angle to launch a melee attack
	if (self.attack_state == AS_MELEE)
	{
		self.ideal_yaw = self.enemy_yaw;
		changeyaw ();

		if (FacingIdeal())
		{
			self.th_melee ();
			self.attack_state = AS_STRAIGHT;
		}
		return;
	}

// turn in place until within an angle to launch a missile attack
	if (self.attack_state == AS_MISSILE)
	{
		self.ideal_yaw = self.enemy_yaw;
		changeyaw ();

		if (FacingIdeal())
		{
			if (self.th_missile())
				self.th_missile();

			self.attack_state = AS_STRAIGHT;
		}
		return;
	}

	if (CheckAnyAttack ())
		return;			// beginning an attack
		
// strafe sideways, but stay at aproximately the same range
	if (self.attack_state == AS_SLIDING)
	{
		self.ideal_yaw = self.enemy_yaw;
		changeyaw ();

		if (self.lefty)
			ofs = 90;
		else
			ofs = -90;
		
		if (walkmove (self.ideal_yaw + ofs, self.movedist))
			return;
			
		self.lefty = !self.lefty;
		
		walkmove (self.ideal_yaw - ofs, self.movedist);
		
return;
	}

#ifdef HIPNOTIC
// strafe sideways, but continue moving towards the enemy
// used by the Scourge.
	if (self.attack_state == AS_DODGING)
	{
/*
//		attempt to jump over missiles
		if (self.enemy.weaponframe == 1)
		{
			if (self.flags & FL_ONGROUND)
			{
				self.origin_z = self.origin_z + 1;
				self.velocity = self.velocity + '0 0 500';
				self.flags = self.flags - FL_ONGROUND;
			}
			self.ltime = self.ltime + 1.0;
		}
*/
		self.nextthink = time + 0.1;
	
		if (self.lefty)
			ofs = 40;
		else
			ofs = -40;
	
		if (time > self.ltime)
		{
			self.lefty = !self.lefty;
			self.ltime = time + 0.8;
		}
	
		newyaw = self.enemy_yaw + ofs;
		self.ideal_yaw = self.enemy_yaw;
	
		if (walkmove (newyaw, self.movedist))
		{
			changeyaw ();
			return;
		}
	
		self.lefty = !self.lefty;
		self.ltime = time + 0.8;
		newyaw = self.enemy_yaw - ofs;
		self.ideal_yaw = self.enemy_yaw;
		walkmove (newyaw, self.movedist);
		changeyaw ();

		return;
	}

	if (self.run_straight && (time > self.endtime))
	{
		self.run_straight = FALSE;
		axis = walkmove (self.angles_y, self.movedist);
		if (!axis)
		{
			self.endtime = time + 3;
			movetogoal (dist);      // done in C code...
		}
//	else
//		changeyaw();
	}

	else
	{
#endif

// head straight in
		movetogoal (dist);		// done in C code...
#ifdef HIPNOTIC
	}
#endif
};

/*

A monster is in fight mode if it thinks it can effectively attack its
enemy.

When it decides it can't attack, it goes into hunt mode.

*/

void() knight_attack;
void() knight_atk1;
void() knight_runatk1;
void() ogre_smash1;
void() ogre_swing1;
void() sham_smash1;
void() sham_swingr1;
void() sham_swingl1;
void(float side) Demon_Melee;
void(vector dest) ChooseTurn;
void() ai_face;

//=============================================================================

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() CheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float	chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
#ifdef HIPNOTIC
	if (!self.charmed)	
#endif
		return FALSE;		// don't have a clear shot

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (self.enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{
			if (self.classname == "monster_knight")
				knight_attack ();
			else
				self.th_melee ();
			return TRUE;
		}
	}
	
// missile attack
	if (!self.th_missile)
		return FALSE;
		
	if (time < self.attack_finished)
		return FALSE;
		
	if (self.enemy_range == RANGE_FAR)
		return FALSE;
		
	if (self.enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (self.enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			chance = 0.2;
		else
			chance = 0.4;
	}
	else if (self.enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			chance = 0.05;
		else
			chance = 0.1;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (2*random());
		return TRUE;
	}

	return FALSE;
};


/*
=============
ai_face

Stay facing the enemy
=============
*/

/*void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};*/

void() ai_face =
{
	local vector dir, pitch;
	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	changeyaw();

	if (self.pitch_speed && self.enemy_vis && self.enemy_infront)
	{
		dir = normalize(self.enemy.origin - self.origin);
		pitch = vectoangles(dir);
		pitch = anglemod_view(pitch);
		self.idealpitch = pitch_x/3;
	}	
	else
		self.idealpitch = 0;
 
	changepitch(self);
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/
float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge =
{
//	if ((!self.enemy) || 
	if (self.enemy.flags & FL_CORPSE)
		return;		// removed before stroke

	ai_face ();	
	movetogoal (d);		// done in C code...
};

void() ai_charge_side =
{
	local	vector	dtemp;
	local	float	heading;
	
// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	changeyaw ();

	makevectors (self.angles);
	dtemp = self.enemy.origin - 30*v_right;
	heading = vectoyaw(dtemp - self.origin);
	
	walkmove(heading, 20);
};


/*
=============
ai_melee

=============
*/
float() ai_melee =
{
	local	vector	delta;
	local	float 	r1, r2, r3, ldmg;
//	local	entity	otemp;

	if (!self.enemy)
//	if (self.enemy.flags & FL_CORPSE)
		return FALSE;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return FALSE;

	if (!CanDamage (self.enemy, self))
		return FALSE;

	r1 = random();
	r2 = random();
	r3 = random();
	ldmg = (r1 + r2 + r3)*3;
	T_Damage (self.enemy, self, self, ldmg, "");

	traceline (self.origin, self.enemy.origin, MOVE_NORMAL, self);

//	otemp = other;
//	other = trace_ent;
	SpawnBlood (trace_ent, trace_endpos, '0 0 40', ldmg);
//	other = otemp;

	return TRUE;
};


float() ai_melee_side =
{
	local	vector	delta;
	local	float 	r1, r2, r3, ldmg;
//	local	entity	otemp;

	if (!self.enemy)
//	if (self.enemy.flags & FL_CORPSE)
		return FALSE;		// removed before stroke
		
	ai_charge_side();
	
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return FALSE;
	if (!CanDamage (self.enemy, self))
		return FALSE;

	r1 = random();
	r2 = random();
	r3 = random();
	ldmg = (r1 + r2 + r3)*3;
	T_Damage (self.enemy, self, self, ldmg, "");

	traceline (self.origin, self.enemy.origin, MOVE_NORMAL, self);
//	otemp = other;
//	other = trace_ent;
	SpawnBlood (trace_ent, trace_endpos, '0 0 40', ldmg);
//	other = otemp;

	return TRUE;
};
