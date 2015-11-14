/* Particle effects QuickC program
   By Jim Dose'  9/19/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

void () particlefield_XZ =
{
	local vector pos;
	local vector start;
	local vector end;
	
	if (self.spawnflags & PARTICLES_USE_COUNT)
	if (counter_GetCount(other) != self.cnt)
		return;

//	dprint( "XZ\n" );
	
	self.ltime = time + 0.25;
	if (self.noise)
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	
	// Only show particles if client is visible.
	// This helps to keep network traffic down to a minimum.
	if (!checkclient())
		return;
	
	start = self.dest1 + self.origin;
	end   = self.dest2 + self.origin;
	pos_y = start_y;
	pos_z = start_z;

	while(pos_z <= end_z)
	{
		pos_x = start_x;
		while(pos_x <= end_x)
		{
			particle (pos, '0 0 0', self.pcolor, self.count);
			pos_x = pos_x + 16;
		}
		pos_z = pos_z + 16;
	}
};

void () particlefield_YZ =
{
	local vector pos;
	local vector start;
	local vector end;

	if (self.spawnflags & PARTICLES_USE_COUNT)
	if (counter_GetCount(other) != self.cnt)
		return;

//	dprint("YZ: ");
//	dprint(vtos(self.dest1));
//	dprint(" - " );
//	dprint(vtos(self.dest2));
//	dprint("\n");

	self.ltime = time + 0.25;

	if (self.noise)
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	
	// Only show particles if client is visible.
	// This helps to keep network traffic down to a minimum.
	if (!checkclient())
	return;
	
	start = self.dest1 + self.origin;
	end   = self.dest2 + self.origin;
	pos_x = start_x;
	pos_z = start_z;

	while(pos_z < end_z)
	{
		pos_y = start_y;
		while(pos_y < end_y)
		{
			particle (pos, '0 0 0', self.pcolor, self.count);
			pos_y = pos_y + 16;
		}
		pos_z = pos_z + 16;
	}
};

void () particlefield_XY =
{
	local vector pos;
	local vector start;
	local vector end;
	
	if (self.spawnflags & PARTICLES_USE_COUNT)
	if (counter_GetCount(other) != self.cnt)
		return;
	
//	dprint( "XY\n" );
	self.ltime = time + 0.25;

	if (self.noise)
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	
	// Only show particles if client is visible.
	// This helps to keep network traffic down to a minimum.
	if (!checkclient())
	return;
		
	start = self.dest1 + self.origin;
	end   = self.dest2 + self.origin;
	pos_x = start_x;
	pos_z = start_z;

	while(pos_x < end_x)
	{
		pos_y = start_y;
		while(pos_y < end_y)
		{
			particle (pos, '0 0 0', self.pcolor, self.count);
			pos_y = pos_y + 16;
		}
		pos_x = pos_x + 16;
	}
};

void () particlefield_touch =
{
	if (!self.dmg)
		return;
	
	if (time > self.ltime)
		return;
	
	if (time < self.attack_finished)
		return;

	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg, "");
};

/*QUAKED func_particlefield (0 .5 .8) ? USE_COUNT
Creates a brief particle flash roughly the size of the defining
brush each time it is triggered.

USE_COUNT when the activator is a func_counter, the field will only
activate when count is equal to "cnt".  Same as using a func_oncount
to trigger.

"cnt" is the count to activate on when USE_COUNT is set.
"color" is the color of the particles.  Default is 192 (yellow).
"count" is the density of the particles.  Default is 2.
"noise" is the sound to play when triggered.  Do not use a looping sound here.
"dmg" is the amount of damage to cause when touched.
*/

void() func_particlefield =
{
	if (!self.pcolor)
		self.pcolor = 192;
	if (self.count == 0)
		self.count = 2;

	self.classname = "particlefield";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.model);
	self.model = "";
	self.origin = (self.mins + self.maxs)*0.5;
	setorigin (self, self.origin);

	self.dest = self.maxs - self.mins - '16 16 16';
	self.dest1 = self.mins + '8 8 8' - self.origin;
	self.dest2 = self.maxs + '7.9 7.9 7.9' - self.origin;
	setsize (self, self.mins, self.maxs);
	self.touch = particlefield_touch;

//   dprint(vtos(self.dest));
//   dprint("  ");

	if (self.dest_x > self.dest_z)
	{
		if (self.dest_y > self.dest_z)
		{
		//	dprint( "XY1 - " );
		//	dprint( ftos( self.cnt ) );
		//	dprint( "\n" );
			self.use = particlefield_XY;
			self.dest1_z = (self.dest1_z + self.dest2_z)/2;
		}
		else
		{
		//	dprint( "XZ1 - " );
		//	dprint( ftos( self.cnt ) );
		//	dprint( "\n" );
			self.use = particlefield_XZ;
			self.dest1_y = (self.dest1_y + self.dest2_y)/2;
		}
	}
	else
	{
		if ( self.dest_y > self.dest_x )
		{
		//	dprint( "YZ2 - " );
		//	dprint( ftos( self.cnt ) );
		//	dprint( "\n" );
			self.use = particlefield_YZ;
			self.dest1_x = (self.dest1_x + self.dest2_x)/2;
		}
		else
		{
		//	dprint( "XZ2 - " );
		//	dprint( ftos( self.cnt ) );
		//	dprint( "\n" );
			self.use = particlefield_XZ;
			self.dest1_y = (self.dest1_y + self.dest2_y)/2;
		}
	}
	
	if (self.noise)
		precache_sound(self.noise);

	self.ltime = time;
};

void () blocker_touch =
{
	if (!self.dmg)
		return;

	if (time < self.attack_finished)
		return;

	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg, "squish");
};

void () blocker_use =
{
	if (!self.state)
	{
		self.state = 1;
		setorigin(self, self.origin - '8000 8000 8000');
		sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	}
	else
	{
		self.state = 0;
		setorigin(self, self.origin + '8000 8000 8000');
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
};

/*QUAKED func_togglewall (0 .5 .8) ? START_OFF
Creates a invisible wall that can be toggled on and off.

START_OFF wall doesn't block until triggered.

"noise" is the sound to play when wall is turned off.
"noise1" is the sound to play when wall is blocking.
"dmg" is the amount of damage to cause when touched.
*/

void() func_togglewall =
{
	self.classname = "togglewall";
	self.movetype = MOVETYPE_PUSH;
	self.mdl = self.model;
	setmodel (self, self.model);
	setsize (self, self.mins, self.maxs);
	setorigin (self, self.origin);
	self.touch = blocker_touch;
	self.use = blocker_use;
	if (!self.noise)
		self.noise = "misc/null.wav";
	if (!self.noise1)
		self.noise1 = "misc/null.wav";
	
	precache_sound(self.noise);
	precache_sound(self.noise1);
	
	self.solid = SOLID_BSP;
	self.model = "";

	if (self.spawnflags & START_OFF)
	{
		self.state = 0;
		setorigin (self, self.origin + '8000 8000 8000');
	}
	else
	{
		self.state = 1;
		sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	}
};


//**********************
//
//   Bobbing water
//
//**********************


void() bobbingwater_think =
{
	local vector ang;
	
	self.count = self.count + self.speed*(time - self.ltime);
	if (self.count > 360)
		self.count = self.count - 360;

	ang_x = self.count;
	ang_y = 0;
	ang_z = 0;

	makevectors(ang);
	self.origin_z = v_forward_z*self.cnt;
	setorigin(self, self.origin);
	self.ltime = time;
	self.nextthink = time + 0.02;
};

/*QUAKED func_bobbingwater (0 .5 .8) ?
Used to emulate water.  To use, create a thin water brush and center it
on the water line of the body of water to bob.  The amount of the bob
is the depth of the brush.

"speed" is how long in seconds it takes the brush to do one full bob.
*/
void() func_bobbingwater =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_STEP;
	self.solid = SOLID_NOT;
	setmodel (self,self.model);
	self.think = bobbingwater_think;
	
	self.count = 0;
	self.cnt = self.size_z/2;

	if (!self.speed)
		self.speed = 4;
	
	self.speed = 360/self.speed;
	
	self.nextthink = time + 0.02;
	self.ltime = time;
};


//**********************
//
//   Bobbing water
//
//**********************


void() hipRubbleTouch =
{
	if (self.ltime < self.pausetime)
		return;

	if (vlen(self.velocity) == 0)
		return;
   
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 10, "impact");
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		self.pausetime = self.ltime + 0.1;
	}
};

void(string rubblename) hipThrowRubble =
{
	local	entity new;
	
	new = spawn();
	new.origin = self.origin;
	setmodel (new, rubblename);
	setsize (new, '0 0 0', '0 0 0');

	new.velocity_x = 70 * crandom();
	new.velocity_y = 70 * crandom();
	new.velocity_z = 140 + 70 * random();

	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_BBOX;

	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;

	new.classname = "gib";
	new.touch = hipRubbleTouch;
	new.think = SUB_Remove;
	new.nextthink = time + 13 + 10*random();
	new.ltime = time;
	self.pausetime = time;
	new.frame = 0;
	new.flags = 0;
};

void() rubble_use =
{
	local float which;
	local float index;
	
	index = 0;
	do
	{
		which = self.cnt;

		if (self.cnt == 0)
		{
			which = 1 + 3*random();
			which = floor(which);
		}

		if (which == 1)
			hipThrowRubble("progs/rubble1.mdl");

		else if (which == 2)
			hipThrowRubble("progs/rubble3.mdl");
		else
			hipThrowRubble("progs/rubble2.mdl");

		index = index + 1;
	}
	while (index < self.count);
};

/*QUAKED func_rubble (0.4 0.4 0.2) (0 0 0) (32 32 32)
Spawns random sized rubble when triggered.  

"count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble =
{
	precache_model ("progs/rubble1.mdl");
	precache_model ("progs/rubble2.mdl");
	precache_model ("progs/rubble3.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble";
	self.cnt = 0;
	self.use = rubble_use;
};
	
/*QUAKED func_rubble1 (0.4 0.4 0.2) (0 0 0) (8 8 8)
Spawns small rubble when triggered.  

"count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble1 =
{
	precache_model ("progs/rubble1.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble1";
	self.cnt = 1;
	self.use = rubble_use;
};
	
/*QUAKED func_rubble2 (0.4 0.4 0.2) (0 0 0) (16 16 16)
Spawns medium rubble when triggered.  

"count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble2 =
{
	precache_model ("progs/rubble3.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble2";
	self.cnt = 2;
	self.use = rubble_use;
};
	
/*QUAKED func_rubble3 (0.4 0.4 0.2) (0 0 0) (32 32 32)
Spawns large rubble when triggered.  

"count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble3 =
{
	precache_model ("progs/rubble2.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble3";
	self.cnt = 3;
	self.use = rubble_use;
};


//**********************
//
//   Wall sprites
//
//**********************


/*QUAKED wallsprite (0 1 0) (-8 -8 -8) (8 8 8)
Places a sprite on a wall.  Angles should be opposite of face.

"model" sprite to place on wall.  Default is "progs/s_blood1.spr".
*/
void() wallsprite =
{
	if (!self.model)
		self.model = "progs/s_blood1.spr";

	precache_model (self.model);
	setmodel (self, self.model);
	
// QuakeEd doesn't save up and down angles properly.
	if (self.angles == '0 -1 0')
		self.angles = '-90 0 0';
	else if (self.angles == '0 -2 0')
		self.angles = '90 0 0';
	
// Pull the sprite away from the wall slightly to
// get rid of z sort errors.
	makevectors (self.angles);
	setorigin (self, self.origin - v_forward*0.2);
	makestatic (self);
};

/*
void() InitBulletHoles =
{
	precache_model ("progs/s_bullet.spr");
	
	bulletholes = nullentity;
	lastbullet = nullentity;
	numbulletholes = 0;
};

void() remove_bullethole =
{
	local entity ent;
	
	// There is a possibility that this is not the first bullet
	// in the list, but it doesn't really matter.  All that
	// matters is there is one less bullet.  Just make sure
	// we don't remove the world!
	if (bulletholes == nullentity)
		objerror("remove_bullethole: bulletholes == nullentity! ");
	
	ent = bulletholes;

	if (ent.classname != "bullethole")
		objerror("remove_bullethole: Tried to remove non-bullethole!");
	
	bulletholes = bulletholes.lastvictim;

	remove(ent);

	if (lastbullet == ent)
		lastbullet = nullentity;

	numbulletholes = numbulletholes - 1;
};

void( vector pos ) placebullethole =
{
	local entity new;
	local entity ent;
	local vector norm;
	
	new = spawn();
	new.owner = new;
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	new.classname = "bullethole";

	setmodel( new, "progs/s_bullet.spr" );
	setsize (new, '0 0 0', '0 0 0');
	
	norm = trace_plane_normal;
	norm_x = 0 - norm_x;
	norm_y = 0 - norm_y;
	new.angles = vectoangles(norm);
	makevectors(self.angles);
	setorigin(new, pos - v_forward*0.2);
	
	new.think = remove_bullethole;
	new.nextthink = time + 300;
	
	numbulletholes = numbulletholes + 1;
	if (numbulletholes > 10)
		remove_bullethole();
	
	if (lastbullet != nullentity)
		lastbullet.lastvictim = new;
	else
		bulletholes = new;

	new.lastvictim = nullentity;
	lastbullet = new;
};
*/