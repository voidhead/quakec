// prototypes
void () W_WeaponFrame;
void () W_SetCurrentAmmo;
void () player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
void () player_jump;

/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	if (coop)
	{
		// make a copy of the dead body for appearances sake
//		CopyToBodyQue (self);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
//		CopyToBodyQue (self);
		// set default spawn parms
		SetNewParms ();
		// respawn		
		PutClientInServer ();
	}
	else
	{	// restart the entire server
		localcmd ("restart\n");
	}
};

/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	if (intermission_running && (coop || deathmatch))  // not allowed during intermission
		return;

/*
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	self.frags = self.frags - 2;	// extra penalty
	respawn ();
*/

//	T_Damage (self, self, self, self.health, "suicide");
	self.deathtype = "suicide";
	self.health = 0;
	Killed(self, self);
};

/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() PlayerDie;

void() PutClientInServer =
{
	local	entity spot;

//	spot = SelectSpawnPoint ();

	self.classname = "player";
	self.health = MAX_PL_HEALTH;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = MAX_PL_HEALTH;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.invincible_time = 0;

#ifdef HIPNOTIC
	self.wetsuit_finished = 0;
	self.empathy_finished = 0;
	self.items2 = 0;
	self.gravity = 1.0;
#endif

	self.effects = 0;
	self.bubble_count = 0;

	self.corpsehealth = 100;
	self.gibhealth = -40;
	self.gib = GIB_HUMANOID;
	self.headname = "progs/h_player.mdl";
	self.mass = 100;
	self.dest = VEC_0;

	self.colormod = VEC_0;
	self.skin = 0;

//	if (self.ishuman)	//frikbot
	if (self.aiment.flags & FL_CORPSE)
	{
		// unlink corpse from their client
		self.aiment.aiment = self.aiment;
		// unlink client from their corpse
		self.aiment = self;
	}

	DecodeLevelParms ();	
	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.th_gib = GibPlayer;
	self.th_jump = player_jump;

	self.deadflag = DEAD_NO;

// pausetime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
	spot = SelectSpawnPoint ();

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

// oh, this is a hack!
#ifdef HIPNOTIC
	setmodel (self, "progs/playham.mdl");
	modelindex_hammer = self.modelindex;
#endif
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

	player_stand1 ();
	
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}

	spawn_tdeath (self.origin, self);
};

void() PlayerDeathThink =
{
//	local entity	old_self;
	local float	forward, do_respawn;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

// wait for all buttons released
	do_respawn = FALSE;

	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down

	if (!self.button2 && !self.button1 && !self.button0)
	{
		// Player wants to respawn ASAP
		if (self.deadflag == DEAD_WAITING)
		{
//			centerprint (self, "");     // Erase button release message
			do_respawn = TRUE;
		}
		else
			return;
	}

	// In netgames, don't respawn as long as a button is held
	if (!do_respawn)
	{
		if (deathmatch || coop)
		{
			// Player wants to respawn ASAP.
			self.deadflag = DEAD_WAITING;

			// Message not necessary, but useful nonetheless.
/*			if (self.button0)
			{
				centerprint (self, "Release attack to respawn");
			}
			else if (self.button1)
			{
				centerprint (self, "Release use to respawn");
			}
			else if (self.button2)
			{
				centerprint (self, "Release jump to respawn");
			}
*/
			return;
		}
	}

//	if (!self.button2 && !self.button1 && !self.button0)
//		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;

	respawn();
};


void() PlayerJump =
{
//	local vector start, end;
	
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= LEVEL_WAIST)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

// play swimming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if (!(self.flags & FL_JUMPRELEASED))
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk

	if (self.attack_finished <= time)
		self.th_jump ();

	self.button2 = 0;

// player jumping sound
	sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};

#ifdef HIPNOTIC
void(float num_bubbles) DeathBubbles;

// WETSUIT
void() wetsuit_prethink =
{
	if (self.wetsuit_finished <= time)
		return;

	if (self.waterlevel == LEVEL_WAIST)
		self.velocity = self.velocity*1.25;
	if (self.waterlevel == LEVEL_EYES)
		self.velocity = self.velocity*1.5;

	if (self.waterlevel >= LEVEL_EYES)
	{
	// play scuba sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 7;
			sound (self, CHAN_BODY, "misc/wetsuit.wav", 1, ATTN_NORM);
		}
		else
		{
			if (fabs(self.swim_flag - time - 6) < 0.04)
				DeathBubbles(1);
			else if (fabs(self.swim_flag - time - 5.5) < 0.04)
				DeathBubbles(1);
			else if (fabs(self.swim_flag - time - 5) < 0.04)
				DeathBubbles(1);
		}
	}
};

void() wetsuit_postthink =
{
	if (self.wetsuit_finished <= time)
		return;

	if (self.waterlevel == LEVEL_WAIST)
		self.velocity = self.velocity*0.8;
	if (self.waterlevel == LEVEL_EYES)
		self.velocity = self.velocity*0.66;
};

#endif


/*
===========
WaterMove

============
*/
void(vector offs, vector spacing, float vel, float puffs, float rate, float ttl) spawnsmoker;

void() PlayerWaterMove =
{
	local vector smokebox, smokepos;


	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;

	smokebox = 0.5*self.size;
	smokebox_z = 0.2*self.size_z;
	smokepos_z = 0.2*self.size_z*(self.waterlevel - 1);

	if (self.waterlevel != LEVEL_EYES)
	{
		if (self.air_finished < time)
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		else if (self.air_finished < time + 9)
			sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, self.dmg, "drowning");
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{	
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		spawnsmoker(smokepos, smokebox, 20, 2, 0, 0.2);				
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel, "drowning2");
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;

			T_Damage (self, world, world, 4*self.waterlevel, "drowning2");
		}
	}
	
	if (!(self.flags & FL_INWATER))
	{	

// player enter water sound
		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.bubble_count = 0;
		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (!(self.flags & FL_WATERJUMP))
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);

	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);

		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			self.th_jump ();
			return;
		}
	}
};


void() PlayerFootsteps =
{
	local float r;

	if (!self.solid) 			// observer
		return;
	if (self.deadflag) 			// no walking dead...
		return;
	if (!(self.flags & FL_ONGROUND))	// airborne
		return;
	if (self.waterlevel >= LEVEL_WAIST)	// swimming
		return;
	if (vlen(self.velocity) < 300)
		return;

	if (time < self.nextfootstep)
		return;
	self.nextfootstep = time + 0.3;

	r = random() * 7;
	// ATTN_IDLE to make them short range
	if (r < 1)
		sound(self, CHAN_FEET, "player/foot1.wav", 0.5, ATTN_IDLE);
	else if (r < 2)
		sound(self, CHAN_FEET, "player/foot2.wav", 0.5, ATTN_IDLE);
	else if (r < 3)
		sound(self, CHAN_FEET, "player/foot3.wav", 0.5, ATTN_IDLE);
	else if (r < 4)
		sound(self, CHAN_FEET, "player/foot4.wav", 0.5, ATTN_IDLE);
	else if (r < 5)
		sound(self, CHAN_FEET, "player/foot5.wav", 0.5, ATTN_IDLE);
	else if (r < 6)
		sound(self, CHAN_FEET, "player/foot6.wav", 0.5, ATTN_IDLE);
	else
		sound(self, CHAN_FEET, "player/foot7.wav", 0.5, ATTN_IDLE);
};

/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
//	local	float	mspeed, aspeed;
//	local	float	r;
//	local	float	a, r;

	if (BotPreFrame()) // FrikBot
		return;
/*
	// dpmod - fade pain view kick
	a = vlen(self.punchvector);
	if (a)
	{
		r = a - frametime*15;

		if (r < 0)
			r = 0;

		self.punchvector = self.punchvector*(r/a);
	}
*/
	if (intermission_running)
	{
#ifdef HIPNOTIC
		earthquake_prethink();
#endif
		self.items = self.items - (self.items &	(IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
		IntermissionThink ();		// otherwise a button could be missed between
		return;				// the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

#ifdef HIPNOTIC
// kill player on Edge of Oblivion
	if (world.model == "maps/hipdm1.bsp")
	if (self.health > 0)
	if (self.origin_z < -1300)
	{
		if (self.invincible_finished >= time)
		{
			self.invincible_finished = 0;
			self.items = self.items - (self.items & IT_INVULNERABILITY);
			self.invincible_time = 0;
			self.invincible_finished = 0;
//			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			self.glow_size = 0;
		}
			T_Damage( self, self, world, self.health + 1000, "falling");
	}
	
//	if (!deathmatch)
//	{
	earthquake_prethink();
//	}	
#endif

	makevectors (self.v_angle);		// is this still used

//	self.deathtype = "";

	CheckRules ();
	PlayerWaterMove ();

#ifdef HIPNOTIC
	wetsuit_prethink();
#endif

	slope_angles(self);

	if (self.waterlevel == LEVEL_WAIST)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	if (time > self.attack_finished)
	if (self.currentammo == 0)
	if (self.weapon != IT_AXE)
#ifdef HIPNOTIC
	if (self.weapon != IT_MJOLNIR)
#endif
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
};


void() invisweapon_think =
{
	if (self.owner.deadflag >= DEAD_DYING)
	{
//		print("remove invis weapon\n");
		self.owner.invisweapon = world;
		remove(self);
		return;
	}
	
	if (self.model != self.owner.weaponmodel)
		setmodel(self, self.owner.weaponmodel);

	if (self.frame != self.owner.weaponframe)
		self.frame = self.owner.weaponframe;

	self.nextthink = self.owner.nextthink - 0.1; 
};


void() invisweapon_spawn =
{
	local entity wep;

//	if (self.invisweapon != world)
//		return;

	if (!self.ishuman)
		return;

//	print("spawn invis weapon\n");

	wep = spawn();

	wep.movetype = MOVETYPE_FOLLOW;
	wep.solid = SOLID_NOT;
	wep.viewmodelforclient = self;
	wep.owner = self;
	wep.alpha = 0.3;	//0.5;	0.2;
	wep.colormod = '1 1 1';
	wep.glowmod = '0.3 0.3 0.3';
	wep.classname = "invis_weapon";

	setmodel(wep, self.weaponmodel);
	setsize(wep, '0 0 0', '0 0 0');
	setorigin(wep, self.origin);

	wep.frame = self.weaponframe;	
	wep.nextthink = 1;	//time + 0.01; 
	wep.think = invisweapon_think;

	self.invisweapon = wep;
};

void() invisweapon_remove =
{
//	print("remove invis weapon\n");
	remove(self.invisweapon);
	self.invisweapon = world;
};
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// invisibility
	if (self.invisible_finished)
	{

	if (!self.invisweapon)
		invisweapon_spawn();

// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{	// just stopped

		if (self.invisweapon)
			invisweapon_remove();

			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
	
/*
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.alpha = 0.2;
	newmis.colormod = '1 1 1';
	setmodel(newmis, self.weaponmodel);
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '0 0 0');
	newmis.frame = self.weaponframe;	
//	newmis.lerpfrac -= frametime*10;	//animate at 10fps
//	newmis.lerpfrac += 1;			//animate at 10fps
	newmis.nextthink = time; 
	newmis.think = SUB_Remove;
*/
	
	// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
#ifdef HIPNOTIC
	else if (self.weapon == IT_MJOLNIR)
		self.modelindex = modelindex_hammer;   // don't use eyes
#endif
	else
		self.modelindex = modelindex_player;	// don't use eyes

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

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out
		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
				self.glow_size = 0 - self.glow_size;
			}	  
			
			if ((self.super_time) && (self.super_time < time))
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
				self.glow_size = 0 - self.glow_size;
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time) {
//			self.effects = self.effects | EF_DIMLIGHT;
			self.glow_color = 244;
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

};

float(entity ent) monsterwaterlevel;
float(entity ent) monsterwatertype;
/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{
	if (BotPostFrame()) // FrikBot
		return;

//	local	float	mspeed, aspeed;
//	local	float	r;

	if (self.view_ofs == '0 0 0')
	{
#ifdef HIPNOTIC
		earthquake_postthink();
#endif
		return;		// intermission or finale
	}

#ifdef HIPNOTIC
	wetsuit_postthink();

//	if (!deathmatch)
//	{
	earthquake_postthink();
//	}
#endif

	if (self.deadflag)
		return;

/*
===============================================================================

 For Testing

===============================================================================
*/

//	print(etos(self.cursor_trace_ent), "\n");
//	print("origin=", vtos(self.origin), "\n");
//	print("feet=", vtos(feetlevel(self)), "\n");
//	print("contents=", ftos(pointcontents(headlevel(self))), "\n");
//	print("eyes=", vtos(self.origin + self.view_ofs), "\n");

//	if (self.cursor_trace_ent.flags & FL_MONSTER)
//		centerprint(self, sprintf("entity %i: waterlevel=%d watertype=%d\n", self.cursor_trace_ent, monsterwaterlevel(self.cursor_trace_ent), monsterwatertype(self.cursor_trace_ent)));
//	else
//		centerprint(self, "");
//		centerprint(self, ftos(rand(1,100)));
//	centerprint(self, ftos(self.v_angle_x));

/*		local string str, str1;
		str = str1 = "";
		str = "";
		str1 = str;
		str1 = strcat(str, ", ");
		str = strcat(str1, "Shotgun");
		print(str, "\n");
*/
/*	print(chr2str(0x80));
	print(chr2str(0x81, 0x81, 0x81, 0x81, 0x81));
	print(chr2str(0x83));
	print(chr2str(0x81, 0x81, 0x81, 0x81, 0x81));
	print(chr2str(0x82));
	print("\n");
*/

//	self.punchvector += 4*randomvec();

//===============================================================================

	
// do weapon stuff
	W_WeaponFrame ();

	PlayerFootsteps ();

// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 5, "falling"); 
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups ();

	// See if the player needs to regen a health point
	if (qonquer)
	if (time > self.regen_time)
	{
		if (skill == SKILL_EASY)
			self.regen_time = time + 1;
		else
			self.regen_time = time + 3*skill;
		
			T_Heal(self, 1, FALSE);
	}

};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
	ClientInRankings(); // FrikBot

	bprint (self.netname);
	bprint (" entered the game\n");
	
// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();

	if (qonquer)
		self.regen_time = time + 1;
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	ClientDisconnected(); // FrikBot

	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
	if (self.frags == 1)
		bprint (" frag\n");
	else
		bprint (" frags\n");

	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);

	if (self.modelindex == modelindex_eyes)
	{
		if (self.health >= self.gibhealth)
			setmodel(self, "progs/player.mdl");
		else
			setmodel(self, "progs/h_player.mdl");			
	}

	self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.effects = 0;

	if (self.deadflag < DEAD_DEAD)
		set_suicide_frame ();

	CopyToBodyQue(self);
	setmodel(self, "");
};
