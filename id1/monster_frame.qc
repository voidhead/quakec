void(entity e) MonsterWaterMove =
{
	local float wl, wt, damg, dormant;
	local vector smokepos, smokebox;
 
	if (e.classname == "monster_boss" || e.classname == "monster_oldone")
		return;

	if (e.movetype == MOVETYPE_WALK)
	{
		wl = e.waterlevel;
		wt = e.watertype;
	}
	else 				// non-walk creatures have depth 1
	{
		wl = monsterwaterlevel(e);
		wt = monsterwatertype(e);
	}

	smokebox = 0.5*e.size;
	smokebox_z = 0.2*e.size_z;
	smokepos_z = (wl - 1)*0.2*e.size_z;

	if (e.flags & FL_INWATER)	// sleeping monsters don't drown
	if (!(e.flags & FL_CORPSE))	
	if (!(e.goalentity.flags & FL_CLIENT))
	if (!(e.goalentity.flags & FL_MONSTER))
	{
		dormant = TRUE;
		e.bubble_count = 0;
		e.air_finished = time + 12;
		e.dmgtime = 0;	
	}

	if (!(e.flags & FL_INWATER))
	{
	// play enter water sound
		if (e.solid) 		// ignore observers
		{
			if (wt == CONTENT_LAVA)
				sound (e, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
			else if (wt == CONTENT_WATER)
				sound (e, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
			else if (wt == CONTENT_SLIME)
				sound (e, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);
		}
		e.bubble_count = 0;
		e.air_finished = time + 12;
		e.dmgtime = 0;	
		e.flags = e.flags | FL_INWATER;
	}

	if (!(e.flags & FL_WATERJUMP))
		e.velocity = e.velocity - 0.8 * wl * frametime * e.velocity;

// for player corpses only
	if (e.flags & FL_CORPSE)
	if (e.aiment.flags & FL_CLIENT)
	{
		if (time > e.dmgtime)
		{
			if (wt == CONTENT_LAVA)
			{
				e.dmgtime = e.dmgtime + 0.2;
				if (e.dmgtime < time)
					e.dmgtime = time + 0.2;
				spawnsmoker(smokepos, smokebox, 20, 2, 0, 0.2);				
				T_Damage (e, world, world, 10*wl, "drowning2");	//10
			}
			else if (wt == CONTENT_SLIME)
			{
				e.dmgtime = e.dmgtime + 1;
				if (e.dmgtime < time)
					e.dmgtime = time + 1;
				T_Damage (e, world, world, 2*wl, "drowning2");	//4
			}
/*
			dprint("damaging player corpse: ");
			dprint(e.classname);
			dprint(" health=");
			dprint(ftos(e.health));
			dprint(" waterlevel=");
			dprint(ftos(wl));
			dprint(" watertype=");
			dprint(ftos(wt));
			dprint("\n");
*/
		}
		return;
	}

	if (e.takedamage)
	if (e.health > 0)
	{
		if (!(e.flags & FL_NOBREATH))
		{
			if (wl != LEVEL_EYES)
			{
				if (e.solid) // ignore observers
				{
					if (e.air_finished < time)
						sound (e, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
					else if (e.air_finished < time + 9)
						sound (e, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
				}

				e.air_finished = time + 12;
				e.dmg = 2;
			}
			else if (e.air_finished < time)
			{
				// drown!
				if (e.drown_finished < time)
				{
					e.dmg = e.dmg + 2;
					if (e.dmg > 15)
						e.dmg = 10;

					if (e.solid) 		// ignore observers
					if (!dormant)
					{
						T_Damage (e, world, world, e.dmg, "drowning");
					}
					e.drown_finished = time + 1;
				}
			}
		}

		if (time > e.dmgtime)
		{
/*
			dprint("damaging ent: ");
			dprint(e.classname);
			dprint(" health=");
			dprint(ftos(e.health));
			dprint(" watertype=");
			dprint(ftos(wt));
			dprint(" waterlevel=");
			dprint(ftos(wl));
			dprint("\n"); 
*/
			if (wt == CONTENT_LAVA)
			{
				if (!(e.flags & FL_NOLAVADMG))
				if (!(e.flags & FL_NOSLIMEDMG))
				{
					e.dmgtime = e.dmgtime + 0.2;
					if (e.dmgtime < time)
						e.dmgtime = time + 0.2;
	
//					if (e.flags & FL_CORPSE) 
//						damg = 5*wl;	//half dmg to corpses
//					else
						damg = 10*wl;
	
					if (!dormant)
					{
						spawnsmoker(smokepos, smokebox, 20, 2, 0, 0.2);				
						T_Damage (e, world, world, damg, "drowning2");
					}
				}
				if (!(e.flags & FL_NOLAVADMG))
				if (e.flags & FL_NOSLIMEDMG)
				{
					e.dmgtime = e.dmgtime + 1;
					if (e.dmgtime < time)
						e.dmgtime = time + 1;

					if (!dormant)
					{
						spawnsmoker(smokepos, smokebox, 20, 1, 0, 0.8);				
						T_Damage (e, world, world, 10*wl, "drowning2");
					}
				}
			}
			else if (wt == CONTENT_SLIME)
			if (!(e.flags & FL_NOSLIMEDMG))
			{
				e.dmgtime = e.dmgtime + 1;
				if (e.dmgtime < time)
					e.dmgtime = time + 1;

				if (e.flags & FL_CORPSE) 
					damg = 2*wl;	//half dmg to corpses
				else
					damg = 4*wl;	

				if (!dormant)
				{
					T_Damage (e, world, world, damg, "drowning2");
				}
			}
		}
	}
};
//===========================================================================


#ifdef HIPNOTIC
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CharmerCheckPowerups =
{
//	if (self.health < 1)
//		return;
//	if (self.charmer.health < 1)
//		return;

/*
	self.invisible_finished = self.charmer.invisible_finished;
	self.invincible_finished = self.charmer.invincible_finished;
	self.super_damage_finished = self.charmer.super_damage_finished;
	self.radsuit_finished = self.charmer.radsuit_finished;
	self.wetsuit_finished = self.charmer.wetsuit_finished;
	self.empathy_finished = self.charmer.empathy_finished;
*/

// super damage
	if (self.charmer.super_damage_finished)
	{
		self.super_damage_finished = self.charmer.super_damage_finished;

		if (self.charmer.super_damage_finished < time + 3)
		{
			if (self.charmer.super_time == 1)
			{
				self.glow_size = 0 - self.glow_size;
			}	  
			
			if ((self.charmer.super_time) && (self.charmer.super_time < time))
			{
				self.glow_size = 0 - self.glow_size;
			}
		}

		if (self.super_damage_finished > time)
		{
			self.glow_color = 244;
			self.glow_size = 300;
			self.glow_trail = FALSE;
		}
		else
			self.glow_size = 0;
	} 



/*
// invisibility
	if (self.charmer.invisible_finished)
	{
		if (self.charmer.invisible_finished < time + 3)
		{
			if (self.charmer.invisible_time == 1)
			{
				self.alpha = 1;
			}
			
			if (self.charmer.invisible_time < time)
			{
				self.alpha = 0.3;
			}
		}

//		if (self.invisible_finished < time)
//		{	// just stopped
//
//		}
		else
			self.alpha = 0.3;	// use the eyes

	}
	else
		self.alpha = 1;		// don't use eyes
*/

/*
// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
				self.glow_size = 0 - self.glow_size;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
				self.glow_size = 0 - self.glow_size;
			}
		}
		
		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if (self.invincible_finished > time) {
//			self.effects = self.effects | EF_DIMLIGHT;
			self.glow_color = 250;
			self.glow_size = 300;
			self.glow_trail = FALSE;
		} else
//			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			self.glow_size = 0;
	}


// suit	
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

		if (self.skin != 1) 			// use the suit skin
			self.skin = 1;

// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
			self.skin = 0;
		}
	}	

#ifdef HIPNOTIC
// wetsuit
	if (self.wetsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown
		
	// sound and screen flash when items starts to run out
		if (self.wetsuit_finished < time + 3)
		{
			if (self.wetsuit_time == 1)
			{
				sprint (self, "Air supply in Wetsuit is running out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.wetsuit_time = time + 1;
			}
		
			if (self.wetsuit_time < time)
			{
				self.wetsuit_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		
		if (self.wetsuit_finished < time)	// just stopped
		{
			self.items2 = self.items2 - HIP_IT_WETSUIT;
			self.wetsuit_time = 0;
			self.wetsuit_finished = 0;
		}
	}

// empathy shields
	if (self.empathy_finished)
	{
	// sound and screen flash when items starts to run out
		if (self.empathy_finished < time + 3)
		{
			if (self.empathy_time == 1)
			{
				sprint (self, "Empathy Shields are running out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.empathy_time = time + 1;
				self.glow_size = 0 - self.glow_size;
			}

			if (self.empathy_time && self.empathy_time < time)
			{
				self.empathy_time = time + 1;
				stuffcmd (self, "bf\n");
				self.glow_size = 0 - self.glow_size;
			}
		}

		if (self.empathy_finished < time)	// just stopped
		{
		         self.items2 = self.items2 - HIP_IT_EMPATHY_SHIELDS;
		         self.empathy_time = 0;
		         self.empathy_finished = 0;
		}

		if (self.empathy_finished > time)
		{
//			self.effects = self.effects | EF_DIMLIGHT;
			self.glow_color = 243;
			self.glow_size = 300;
			self.glow_trail = FALSE;
		}
		else
//			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			self.glow_size = 300;
	}
#endif
*/

};
#endif


//===========================================================================
void() MonsterFrame =
{
	local entity oldself;
	local float iterations;
	local float wl, wt;
	
	oldself = self;
	self = creaturetocheck;

	if (self == world)
		self = nextent(world);

	// only process up to 200 creatures per frame
	iterations = 0;

	while ((self) && (iterations < 200))
	{
		iterations = iterations + 1;

		if (self != world)
		if (!(self.flags & FL_CLIENT))
		if (self.flags & (FL_MONSTER | FL_CORPSE))
		if (self.takedamage)
		if (self.health > 0)
		{
/*
===============================================================================

 For Testing

===============================================================================
*/

//			if (num_for_edict(self) == 82)
//			{
//				print(ftos(clientvisible(self.origin)), "\n");

//				if (client)
//				{
//					print("bang\n");
//					print(etos(client), "\n");
//				}
//				else
//					print("no client\n");
//			}

//===============================================================================

			wl = monsterwaterlevel(self);
			wt = monsterwatertype(self);
			
			if (!(self.flags & FL_CORPSE))
			{
				if (self.movetype != MOVETYPE_NOCLIP)
				if (self.movetype != MOVETYPE_NONE)
				{
					slope_angles(self);
				}

				if (!self.enemy_found)
				{
					self.enemy_found = TRUE;

					// reset knowledge of enemy
					self.enemy_vis = FALSE;
					self.enemy_infront = FALSE;
					self.enemy_range = FALSE;
					self.enemy_yaw = FALSE;

					FindTarget();
				}
#ifdef HIPNOTIC
				if (self.charmed)
				{
					CharmerCheckPowerups();
				}
#endif			
			}

			if (wt >= CONTENT_EMPTY)
			{
				if (self.flags & FL_INWATER)
				{
					// play leave water sound, but only if not an observer
					if (self.solid)
						sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
					self.flags = self.flags - FL_INWATER;
				}
			}
			else
			{
				if (self.movetype != MOVETYPE_NOCLIP)
					MonsterWaterMove(self);
			}

			if (self.flags & FL_ONGROUND)
			{
				// friction
				if (self.velocity_x || self.velocity_y)
				{
					local float f, stopspeed, friction;
					local vector v;

					stopspeed = 100;
					friction = 4;

					v = self.velocity;
					v_z = 0;
					f = vlen(v);
					if (f < stopspeed)
						f = 1 - frametime * (stopspeed / f) * friction;
					else
						f = 1 - frametime * friction;
					if (f > 0)
						self.velocity = self.velocity * f;
					else
						self.velocity = '0 0 0';
				}

				if (self.jump_flag < -200)
				if (self.solid) 	// ignore observers
				{
					local float d;
					d = 0;
					if (wt > CONTENT_WATER)
					{
						if (self.jump_flag < -650)
							d = 5;
					}
					if (d)
					{
						T_Damage (self, world, world, d, "falling");
					}
					self.jump_flag = 0;
				}
			}
			if (!(self.flags & FL_ONGROUND))
				self.jump_flag = self.velocity_z;
		}
		self = nextent(self);
	}

	creaturetocheck = self;
	self = oldself;
};
