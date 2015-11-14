void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;
void() monster_spawnwanderpath;

void() execute_changelevel;
void() trigger_changelevel;
void() changelevel_touch;

void() qonquer_monster_died;
void(entity ent) qonquer_monster_gibbed;
void(entity ent) qonquer_corpse_gibbed;

//============================================================================

//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float amount, float ignore) T_Heal =
{
	if (e.health < 1)
		return FALSE;

	if (!ignore)
	if (e.health >= e.max_health)
		return FALSE;

	amount = ceil(amount);

	if (!ignore && e.health + amount >= e.max_health)
	{
		e.health = e.max_health;
		return TRUE;
	}

	e.health = e.health + amount;

	if (e.flags & FL_CLIENT)	
	if (e.health > MAX_PL_HEALTH_MEGA)
		e.health = MAX_PL_HEALTH_MEGA;

	return TRUE;
};


/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
	local vector dif;

// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// testing middle of half-size bounding box
	dif_z = 0;

// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...front left
	dif_x = targ.mins_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...back left
	dif_y = targ.mins_y * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...back right
	dif_x = targ.maxs_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// testing top of half-sized bounding box
	dif_z = targ.maxs_z * 0.5;

// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...front left
	dif_x = targ.mins_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...back left
	dif_y = targ.mins_y * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...back right
	dif_x = targ.maxs_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// testing bottom of half-sized bounding box
	dif_z = targ.mins_z * 0.5;

// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...front left
	dif_x = targ.mins_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...back left
	dif_y = targ.mins_y * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

// ...back right
	dif_x = targ.maxs_x * 0.5;

	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	
/*	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
*/
	return FALSE;
};


/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself, otemp, trig;

	oself = self;
	self = targ;

	// clean up wanderpath
	if (self.movetarget.classname == "monster_wanderpath")
	{
//		print("removing wanderpath for ", etos(self), "\n");
		remove(self.movetarget);
		self.movetarget = world;
	}

//	if (self.classname == "player")
//		if (self.health < -99)
//			self.health = -99;		// don't let sbar look bad if a player

#ifdef HIPNOTIC
	if (self.charmed)
	{
		self.invisible_finished = 0;
		self.invincible_finished = 0;
		self.super_damage_finished = 0;
		self.radsuit_finished = 0;
		self.wetsuit_finished = 0;
		self.empathy_finished = 0;

		self.glow_size = 0;
		self.alpha = 1;

		self.charmed = FALSE;
		self.charmer = world;
	}
#endif

// doors, triggers, etc
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE || self.movetype == MOVETYPE_TOSS)
	{	
		self.th_die (attacker, self.health);
		self = oself;
		return;
	}

	self.enemy = attacker;

// bump the monster counter
	if (self.flags & FL_MONSTER)
	if (!self.minion)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

// special fix for shub
	if (attacker.classname == "trigger_hurt")
	if (attacker.owner)
	if (attacker.owner.health > 0)
		attacker = attacker.owner;

// track who killed shub to show the proper colormap
	if (self.classname == "monster_oldone")
	{
		if (attacker.owner)
			shub_killer = attacker.owner;
		else
			shub_killer = attacker;
	}

	ClientObituary(self, attacker);
	
	self.takedamage = DAMAGE_NO;

//	if (!(self.flags & FL_CLIENT))
//		self.touch = SUB_Null;

	if (qonquer)
	{
		if (self.flags & FL_MONSTER)
		{
			qonquer_monster_died();		// let Qonquer know that a monster was killed
	
			if (self.health < self.gibhealth)
				qonquer_monster_gibbed(attacker);		
		}
		else if (self.flags & FL_CORPSE)
			qonquer_corpse_gibbed(attacker);
	}

	monster_death_use();

	self.angles_x = 0;
	self.angles_z = 0;
	self.idealpitch = 0;
	self.ideal_yaw = 0;

//check for gib
	if (self.health < self.gibhealth)
	{
		if (self.th_gib)
			self.th_gib(self.headname, self.health, self.gib);
	}
	else
		self.th_die(attacker, self.health);
	
	self = oself;

	if (!qonquer)
		return;
	
// update Qonquer stats
	if (targ.classname == "monster_army")
		qonquer.stat_soldierkills = qonquer.stat_soldierkills + 1;
	if (targ.classname == "monster_demon1")
		qonquer.stat_demonkills = qonquer.stat_demonkills + 1;
	if (targ.classname == "monster_dog")
		qonquer.stat_dogkills = qonquer.stat_dogkills + 1;
	if (targ.classname == "monster_enforcer")
		qonquer.stat_enforcerkills = qonquer.stat_enforcerkills + 1;
	if (targ.classname == "monster_fish")
		qonquer.stat_fishkills = qonquer.stat_fishkills + 1;
	if (targ.classname == "monster_hell_knight")
		qonquer.stat_hellknightkills = qonquer.stat_hellknightkills + 1;
	if (targ.classname == "monster_knight")
		qonquer.stat_knightkills = qonquer.stat_knightkills + 1;
	if (targ.classname == "monster_ogre")
		qonquer.stat_ogrekills = qonquer.stat_ogrekills + 1;
	if (targ.classname == "monster_shalrath")
		qonquer.stat_shalrathkills = qonquer.stat_shalrathkills + 1;
	if (targ.classname == "monster_shambler")
		qonquer.stat_shamblerkills = qonquer.stat_shamblerkills + 1;
	if (targ.classname == "monster_tarbaby")
		qonquer.stat_tarbabykills = qonquer.stat_tarbabykills + 1;
	if (targ.classname == "monster_wizard")
		qonquer.stat_wizardkills = qonquer.stat_wizardkills + 1;
	if (targ.classname == "monster_zombie")
		qonquer.stat_zombiekills = qonquer.stat_zombiekills + 1;
	
	if (targ.classname == "player")
	{
		// Spawn a trigger_changelevel and use it to start up the intermission screen
		
		trig = spawn();
		trig.classname = "trigger_changelevel";
		trig.map = mapname;

		oself = self;
		self = trig;
		trigger_changelevel();
		
		otemp = other;
		other = targ;
		self.touch();

		other = otemp;		
		self = oself;
	}
};


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage, string dtype) T_Damage =
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;
	local 	float 	mo;
	local 	float 	chance;

	if (!targ.takedamage)
		return;

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;
// used to keep track of what hit us
	damage_inflictor = inflictor;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
	if (inflictor.classname != "door")	// no quad power for doors
	if (inflictor.classname != "plat")	// plats
	if (inflictor.classname != "train")	// trains
	if (inflictor.classname != "barrel")	// and barrels
	if (dtype != "telefrag")
		damage = damage*4;

	if (qonquer)
	if (attacker.minion)
		damage = damage*2.0;	// the minion packs a real punch against other monsters

#ifdef HIPNOTIC
	if (targ.empathy_finished >= time)	//targ.items2 & HIP_IT_EMPATHY_SHIELDS)
	if (targ != attacker)
	if (inflictor.empathy_finished < time)	//!(inflictor.items2 & HIP_IT_EMPATHY_SHIELDS))
	{
		damage = damage/2;
		T_Damage (attacker, targ, targ, damage, "empathy");
	}
#endif

// save damage based on the target's armor level
	if (dtype != "drowning")
	{
		save = ceil(targ.armortype*damage);
		if (save >= targ.armorvalue)
		{
			save = targ.armorvalue;
			targ.armortype = 0;	// lost all armor
			targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		}
	} else
		save = 0;

	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage - save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
	if (targ.mass > 0)
	if (targ.movetype > MOVETYPE_NONE)
	if (targ.movetype < MOVETYPE_PUSH)
	if (inflictor != world)
//	if (inflictor.classname != "door")
//	if (inflictor.classname != "plat")
//	if (inflictor.classname != "train")
	if (inflictor.classname != "trigger_hurt")
	if (dtype != "telefrag")
	if (dtype != "discharge")
	if (dtype != "zap")
	if (targ.health - take >= targ.gibhealth || (targ.flags & FL_GODMODE || targ.invincible_finished > time))
	{

/*		if ( (targ.classname != "monster_boss") && (targ.classname != "monster_oldone") )
			targ.velocity = targ.velocity + dir*damage*8;
			targ.velocity = targ.velocity + dir*damage*8*(100/targ.mass);

		if (inflictor == attacker)
		{
			dir = inflictor.origin + 0.5*(inflictor.mins + inflictor.maxs);
			dir_z = inflictor.absmin_z + 0.3*inflictor.size_z;
			dir = targ.origin - dir;
		}
		else
*/

//		if (inflictor.classname != "door" || inflictor.classname != "plat" || inflictor.classname != "train")
//		{
//		}
//		else

		dir = targ.origin - (inflictor.absmin + inflictor.absmax)*0.5;

		mo = 4*damage*(100/targ.mass);	//8

//		if (dtype == "zap")
//			mo /= 8;

		if (targ.flags & FL_CORPSE)
			mo /= 8;

		//reduce moment if in water
		if (entwaterlevel(targ) > LEVEL_FEET)
		if (entwatertype(targ) < CONTENT_SOLID)
			mo /= 4;

		// make fall forwards sometimes
		if (damage < 60)	//40
		if (damage > targ.health)
		if (targ.origin_z - (inflictor.absmin_z + inflictor.absmax_z)*0.5 > 64)
		if (random() > 0.5)	//P_Random ()&1
		{
//			dir = vreverse(dir);
			dir_x = 0 - dir_x;
			dir_y = 0 - dir_y;
			dir_z = 0.1*(5 - 2*random())*dir_z;
			mo *= 2;
		}

		dir = normalize(dir);

		// apply the momentum
		targ.velocity = targ.velocity + dir*mo;

		// launch the target up in the air
		if (!(targ.flags & FL_CORPSE))
		if (targ.flags & FL_ONGROUND)
//		if (dtype != "zap")
		{
			targ.flags = targ.flags - FL_ONGROUND;
			tracebox(targ.origin, targ.mins, targ.maxs, targ.origin + '0 0 1', FALSE, targ);
			setorigin(targ, trace_endpos);
		}
	}

#ifdef HIPNOTIC
	if (targ.wetsuit_finished)
	if (dtype == "discharge")
		return;
#endif

// dpmod
	if (targ.flags & FL_CLIENT)
	if (targ.ishuman)
	{
		local vector force;

		force = 32*(damage/100)*normalize(targ.origin - (inflictor.absmin + inflictor.absmax)*0.5);

		targ.punchvector = targ.punchvector - force;

		if (vlen(targ.punchvector) > 32)	//4
			targ.punchvector = 32*normalize(targ.punchvector);

//		printvector(targ.punchvector);
	}

// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;

	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

#ifdef HIPNOTIC
	if (targ.empathy_finished >= time)	//targ.items2 & HIP_IT_EMPATHY_SHIELDS)
	{
		if (self.empathy_sound < time)
		{
			sound (targ, CHAN_ITEM, "hipitems/empathy2.wav", 1, ATTN_NORM);
			self.empathy_sound = time + 0.5;
		}
	}	
#endif

// team play damage avoidance
	if (teamplay)
	if (targ.team)
	if (targ.team == attacker.team)
	if (targ != attacker)
	if (attacker.flags & FL_CLIENT)
	if (inflictor.classname != "door")	// because squishing a teammate is still possible
	if (inflictor.classname != "plat")
	if (inflictor.classname != "train")
		return;

	if (qonquer)
	if (!(targ.flags & FL_CORPSE))
	{
		if (attacker.minion)
		if (targ.classname == "player" || targ.minion)
			return;		// minions can't hurt the player or each other
		
		if (targ.minion)
		if (attacker.classname == "player")
			return;		// player can't hurt his own minions
	}

// do the damage
	if (targ.classname == "monster_boss" && attacker.flags & FL_MONSTER)
		targ.health = targ.health - take*0.5;		//half damage for boss from monsters

	if (targ.classname == "monster_shambler" && attacker.classname == "monster_boss")
		targ.health = targ.health - take*2;		//full damage for shamblers from boss

	else
		targ.health = targ.health - take;

// register the deathtype
	targ.deathtype = dtype;

// if it bleeds, we can kill it			
	if (targ.health <= 0)
	{
// 		Use self.dest to keep track of intended gib direction
		if (targ.health < targ.gibhealth)
//		if (dtype != "telefrag")
//		if (dtype != "discharge")
		{
/*			if ((attacker.flags & FL_CLIENT) && (attacker.health > 0))
			{
				makevectors(attacker.v_angle);
				targ.dest = v_forward + v_right + v_up;
				print(vtos(normalize(v_forward + v_right + v_up)), "\n");
				print(vtos(normalize(targ.origin - inflictor.origin)), "\n\n");
			}
			else
*/			
			targ.dest = targ.origin - inflictor.origin;

			// if telefragged, root target in place and do not apply momentum
			if (dtype != "telefrag")	
				targ.velocity = targ.dest = VEC_0;
		}

		Killed (targ, attacker);
		return;
	}


	oldself = self;
	self = targ;

// react to the damage
	if (self.flags & FL_MONSTER)
	{
//		if (attacker.takedamage)
		// ignore world hazards
		if (attacker != world)
		if (attacker.solid != SOLID_BSP)
		if (attacker.classname != "trigger_hurt")
		if (attacker.classname != "trap_spikeshooter")
		if (attacker.classname != "trap_shooter")
		{
		// get mad unless of the same class (except for soldiers)
			if (self != attacker && attacker != self.enemy	
#ifdef HIPNOTIC
			    && self.charmer != attacker
#endif
			   )
			{
#ifdef ID1
				if ((self.classname != attacker.classname) ||
#endif
#ifdef HIPNOTIC
//				if ((self.classname != attacker.classname && !self.charmed && !attacker.charmed) ||
//				    (self.classname == attacker.classname && (self.charmed || attacker.charmed) && self.charmer != attacker.charmer) ||
				if ((self.classname != attacker.classname && !(self.charmed && attacker.charmed && self.charmer == attacker.charmer)) ||
				    (self.classname == attacker.classname && ((!self.charmed && attacker.charmed) || (self.charmed && !attacker.charmed) || (self.charmed && attacker.charmed && self.charmer != attacker.charmer))) ||
				    (self.classname == "monster_armagon") ||
#endif
				    (qonquer && (self.classname == attacker.classname) && ((self.minion && !attacker.minion) || (!self.minion && attacker.minion))) ||
				    (self.classname == "monster_army") ||
				    (self.classname == "monster_enforcer")
				   )
				{
					if (qonquer)
					{
						if (self.minion)
						{
							if (attacker.classname != "player")
							if (attacker.classname != "monster_zombie")
							{
								self.enemy = attacker;
								FoundTarget ();
							}
						}
						else if (self.enemy.classname == "player" && !(attacker.flags & FL_NOTARGET))
						{
							if (skill == SKILL_EASY)
								chance = 0.05;
							else if (skill == SKILL_NORMAL)
								chance = 0.25;
							else if (skill == SKILL_HARD)
								chance = 0.6;
							else
								chance = 0.95;

//							chance = 0.10 + 0.25*skill;

							if (random() > chance || take > random()*self.max_health)
							{
								if (self.enemy.classname == "player")
									self.oldenemy = self.enemy;

								self.enemy = attacker;
								FoundTarget ();
							}
						}
						else
						{
							self.enemy = attacker;
							FoundTarget();
						}
					}
					else if (!(attacker.flags & FL_NOTARGET))
					{
						if (self.enemy.classname == "player")
							self.oldenemy = self.enemy;
	
						self.enemy = attacker;
						FoundTarget();
					}
					else if (!self.enemy)	// not in fight and has been hit by somebody unseen 
					{
						if (self.movetarget.classname != "monster_wanderpath")
						if (!(self.spawnflags & SPAWNFLAG_WANDER))
							monster_spawnwanderpath();

						self.movetarget.enemy = attacker;
						self.goalentity = self.movetarget;
						self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
						self.enemy_found = FALSE;
						self.th_run();	
					}

				}

			}
			
		}
	}

	if (self.th_pain)
	{
		self.th_pain (attacker, take);
// nightmare mode monsters don't go into pain frames often
		if (skill == SKILL_NIGHTMARE)
			self.pain_finished = time + 4 + 2*random();	//time + 5;

// minions don't go into pain frames all that often
		if (qonquer)
		if (self.minion)
			self.pain_finished = time + 5 + 3*random();	
	}

// reset deathtype if not killed
	targ.deathtype = "";

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage =
{
	local	float	radius;
	local	float 	points;
	local	entity	head, head2;
	local	vector	org, vel;
	local	float	attacker_damaged;
	local	float	attacker_points;

	radius = damage + 40;

	head = findradius_tofield(inflictor.origin, radius, radiusdamagechain);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;

				points = damage - points;

				if (points > 0)
				{
					if (CanDamage(head, inflictor))
					{
						if (head != attacker)
						{
							// shambler takes half damage from all explosions
							if (head.classname == "monster_shambler")						
								points = points*0.5;

							T_Damage (head, inflictor, attacker, points, dtype);

							SpawnBlood_Expl(head, inflictor.velocity, points);
						}
						else
						{
							attacker_damaged = TRUE;
							attacker_points = points*0.5;
						}
					}
				}
			}
		}
		head2 = head;
		head = head.radiusdamagechain;
		head2.radiusdamagechain = world;	//clear the field just in case
	}
	if (attacker_damaged)
	{
		T_Damage (attacker, inflictor, attacker, attacker_points, dtype);

		vel = vreverse(inflictor.velocity);
		SpawnBlood_Expl(attacker, vel, attacker_points);
	}
};

vector (entity ent) feetlevel;
/*
//void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) TestLightningDamage =
void(entity inflictor, entity attacker, entity ignore) TestLightningDamage =
{
	local	float	radius;
	local	float 	points;
	local	entity	head;
	local	vector	org;
	local	float	attacker_damaged;
	local	float	attacker_points;
	local 	float	medium1;
	local 	float	medium2;

	radius = 2048;

	medium1 = pointcontents(feetlevel(inflictor));
	if (medium1 > CONTENT_WATER)
		return;

	head = findradius(inflictor.origin, radius);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				if (checkpvs(inflictor.origin, head))
				{
//					print("checkpvs for ", etos(head), " is true\n" );
					org = feetlevel(head);			//head.origin + (head.mins + head.maxs)*0.5;
//					traceline(inflictor.origin, org, MOVE_NOMONSTERS, inflictor);
					tracebox(feetlevel(inflictor), '-1 -1 0', '1 1 64', org, MOVE_NOMONSTERS, inflictor);
					medium2 = pointcontents(feetlevel(head));

					print("traceline for ", etos(head), " (", head.classname, "):\n");
					print("contents=", ftos(medium2), "\n" );					
					print("startsolid=", ftos(trace_startsolid), "\n" );
					print("inopen=", ftos(trace_inopen), "\n" );
					print("inwater=", ftos(trace_inwater), "\n" );
					print("fraction=", ftos(trace_fraction), "\n" );
					print("ent=", etos(trace_ent), "\n" );
					print("\n" );

					if (trace_inwater)
//					if (!trace_startsolid)
					{
						if (!trace_inopen && medium1 == medium2)		
										//fully underwater
						{
							if (head != attacker)
							{
	//							head.deathtype = "discharge";
	//							T_Damage (head, inflictor, attacker, points);
								head.colormod = '2 2 0';
							}
							else
							{
								attacker_damaged = TRUE;
							}
						}
						else if (trace_fraction == 1)
						{
							if (head != attacker)
							{
	//							head.deathtype = "discharge";
	//							T_Damage (head, inflictor, attacker, points);
								head.colormod = '0 0 2';
							}
							else
							{
								attacker_damaged = TRUE;
							}		
						}
					}
				}
			}
		}
		head = head.chain;
	}

	if (attacker_damaged)
	{
//		attacker.deathtype = "discharge";
//		T_Damage (attacker, inflictor, attacker, attacker_points);
		attacker.colormod = '2 0 0';
	}
};
*/


/*
============
just for development
============
*/
//void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) TestLightningDamage =
void(entity inflictor, entity attacker, entity ignore) TestLightningDamage =
{
	local	float	radius;
//	local	float 	points;
	local	entity	head;
	local	vector	org;
	local	float	attacker_damaged;
//	local	float	attacker_points;
	local 	float	medium1;
	local 	float	medium2;

//	if (attacker.super_damage_finished > time)
//	        radius = 4*damage + 40;
//	else
//		radius = damage + 40;	

	radius = 2048;

	medium1 = pointcontents(feetlevel(inflictor));

	if (medium1 > CONTENT_WATER)
		return;

	head = findradius(inflictor.origin, radius);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				if (checkpvs(inflictor.origin, head))
				{
//					print("checkpvs for ", etos(head), " is true\n" );
					org = feetlevel(head);			//head.origin + (head.mins + head.maxs)*0.5;
//					traceline(inflictor.origin, org, MOVE_NOMONSTERS, inflictor);
					tracebox(feetlevel(inflictor), '-1 -1 0', '1 1 64', org, MOVE_NOMONSTERS, inflictor);
					medium2 = pointcontents(feetlevel(head));

					print("traceline for ", etos(head), " (", head.classname, "):\n");
					print("contents=", ftos(medium2), "\n" );					
					print("startsolid=", ftos(trace_startsolid), "\n" );
					print("inopen=", ftos(trace_inopen), "\n" );
					print("inwater=", ftos(trace_inwater), "\n" );
					print("fraction=", ftos(trace_fraction), "\n" );
					print("ent=", etos(trace_ent), "\n" );
					print("\n" );

					if (trace_inwater)
//					if (!trace_startsolid)
					{
						if (!trace_inopen && medium1 == medium2)		
										//fully underwater
						{
							if (head != attacker)
							{
	//							head.deathtype = "discharge";
	//							T_Damage (head, inflictor, attacker, points);
								head.colormod = '2 2 0';
							}
							else
							{
								attacker_damaged = TRUE;
							}
						}
						else if (trace_fraction == 1)
						{
							if (head != attacker)
							{
	//							head.deathtype = "discharge";
	//							T_Damage (head, inflictor, attacker, points);
								head.colormod = '0 0 2';
							}
							else
							{
								attacker_damaged = TRUE;
							}		
						}
					}
				}
			}
		}
		head = head.chain;
	}

	if (attacker_damaged)
	{
//		attacker.deathtype = "discharge";
//		T_Damage (attacker, inflictor, attacker, attacker_points);
		attacker.colormod = '2 0 0';
	}
};
