void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8)
testing air bubbles
*/

void() air_bubbles =

{
//	if (deathmatch)
//	{
//		remove (self);
//		return;
//	}

//	precache_model ("progs/s_bubble.spr");
	precache_model ("progs/s_bubble.spr32");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void() make_bubbles =
{
	local 	entity	bubble;

	bubble = spawn();
//	setmodel (bubble, "progs/s_bubble.spr");
	setmodel (bubble, "progs/s_bubble.spr32");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";

	bubble.frame = floor(3*random() + 0.5);	//0
	setsize (bubble, '-8 -8 -8', '8 8 8');
	bubble.scale = 0.375;
	bubble.cnt = 0;

	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split =
{
	local entity bubble;

	bubble = spawn();
//	setmodel (bubble, "progs/s_bubble.spr");
	setmodel (bubble, "progs/s_bubble.spr32");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";

	setsize (bubble, '-4 -4 -4', '4 4 4');	//8
	bubble.frame = floor(3*random() + 0.5);	//1
	bubble.scale = 0.1875;
	bubble.cnt = 10;

	setsize (self, '-4 -4 -4', '4 4 4');	//8
	self.frame = 3*rint(random());		//1
	self.scale = 0.1875;
	self.cnt = 10;

	if (self.waterlevel != LEVEL_EYES)
	{
		self.think = SUB_Remove;
		self.nextthink = 1;
	}
};

void() bubble_remove =
{
	if (other.classname == self.classname)
	{
//		dprint ("bump");
		return;
	}
	remove(self);
};

void() bubble_bob =
{
	local float rnd1, rnd2, rnd3;

	if (self.waterlevel != LEVEL_EYES)
	{
		self.think = SUB_Remove;
		self.nextthink = 1;
		return;
	}

	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();
	if (self.cnt == 20)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 7;
	if (rnd1 < -10)
		rnd1 = -7;
		
	if (rnd2 > 10)
		rnd2 = 7;
	if (rnd2 < -10)
		rnd2 = -7;
		
	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;
	
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;

	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};


void() DeathBubblesSpawn =
{
	local	entity	bubble;
	local	vector	org;

	if (self.owner.movetype == MOVETYPE_WALK)
	{
		if (self.owner.waterlevel != LEVEL_EYES)
		if (self.owner.health > 0)
		{
			remove(self);	// remove bubble spawner
			return;
		}
	}
	else if (self.owner.movetype == MOVETYPE_STEP)
	{
		if (monsterwaterlevel(self.owner) != LEVEL_EYES)
		if (self.owner.health > 0)
		{
			remove(self);	// remove bubble spawner
			return;
		}
	}

	bubble = spawn();
//	setmodel (bubble, "progs/s_bubble.spr");
	setmodel (bubble, "progs/s_bubble.spr32");

	org = crandomvec();	//1.5
	org_z = 0;
	org = org + self.owner.origin;
	org_z = self.owner.absmin_z + 0.75*self.owner.size_z;

//	head = ent.origin + 0.5*(ent.mins + ent.maxs);
//	head_z = ent.absmin_z + 0.7*ent.size_z;
//	org = org + 0.5*(self.owner.absmin + self.owner.absmax) + '0 0 24';	//self.owner.origin + '0 0 24';

	setorigin (bubble, org);

	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;	//0.5
	bubble.think = bubble_bob;
	bubble.classname = "bubble";

	bubble.frame = 3*rint(random());	//0
	setsize (bubble, '-8 -8 -8', '8 8 8');
	bubble.scale = 0.375;
	bubble.cnt = 0;

	self.nextthink = time + 0.015;	//0.01;	//0.1
	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;

	if (self.air_finished >= self.bubble_count)
		remove(self);
};

void(float num_bubbles) DeathBubbles =
{
	local entity bubble_spawner;

	bubble_spawner = spawn();
	setorigin (bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;

	bubble_spawner.nextthink = 1;	//time + 0.01;	//0.1
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
};

void(float b1, float b2) MonsterBubbles =
{
	local float wl, wt, rb;

	wl = monsterwaterlevel(self);
	wt = monsterwatertype(self);

	if (wl == LEVEL_EYES)
	if (wt != CONTENT_LAVA)
	{
		rb = b1 + b2*random();
		DeathBubbles(rb);
	}
};
