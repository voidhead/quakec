
void () BecomeExplosion =
{
	if ((nospr32 == 1))
	{
		NormalExplosion ();
		return;
	}
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.frame = 0;
	self.cnt = 4;
	self.dmg = 20;
	self.lefty = time;
	setmodel (self, "sprites/explode3.spr32");
	self.solid = SOLID_NOT;
	spr32_boom ();
};

void () BecomeExplosion2 =
{
	if ((nospr32 == 1))
	{
		NormalExplosion ();
		return;
	}
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.frame = 0;
	self.cnt = 4;
	self.dmg = 20;
	self.lefty = time;
	setmodel (self, "sprites/explode1.spr32");
	self.solid = SOLID_NOT;
	spr32_boom ();
};

void () BecomeExplosion3 =
{
	if ((nospr32 == 1))
	{
		NormalExplosion ();
		return;
	}
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.frame = 0;
	self.cnt = 4;
	self.dmg = 20;
	self.lefty = time;
	self.touch = SUB_Null;
	setmodel (self, "sprites/explode4.spr32");
	self.solid = SOLID_NOT;
	spr32_boom ();
};

void () spr32_boom =
{
	local float num;

	num = (time - self.lefty) * self.dmg;
	if ((num > self.cnt))
	{
		remove (self);
	}
	self.frame = num;
	self.think = spr32_boom;
	self.nextthink = (time + 0.01);
};

void () gibgore =
{
	local vector min;
	local vector max;
	local float vel;

	min = self.origin + self.mins;
	max = (self.origin + self.maxs) + self.maxs;
	vel = 10;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_BLOODSHOWER);
	WriteCoord (MSG_BROADCAST, min_x);
	WriteCoord (MSG_BROADCAST, min_y);
	WriteCoord (MSG_BROADCAST, min_z);
	WriteCoord (MSG_BROADCAST, max_x);
	WriteCoord (MSG_BROADCAST, max_y);
	WriteCoord (MSG_BROADCAST, max_z);
	WriteCoord (MSG_BROADCAST, vel);
	WriteShort (MSG_BROADCAST, 5);
};

/*
void (entity mark) backup_gibgore =
{
	local vector min;
	local vector max;
	local float vel;

	min = self.origin + self.mins;
	max = self.origin + self.maxs;
	vel = 30;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_BLOODSHOWER);
	WriteCoord (MSG_BROADCAST, min_x);
	WriteCoord (MSG_BROADCAST, min_y);
	WriteCoord (MSG_BROADCAST, min_z);
	WriteCoord (MSG_BROADCAST, max_x);
	WriteCoord (MSG_BROADCAST, max_y);
	WriteCoord (MSG_BROADCAST, max_z);
	WriteCoord (MSG_BROADCAST, vel);
	WriteShort (MSG_BROADCAST, 700);
};
*/

void () s_explode1 = [ 0, s_explode2 ]
{
};

void () s_explode2 = [ 1, s_explode3 ]
{
};

void () s_explode3 = [ 2, s_explode4 ]
{
};

void () s_explode4 = [ 3, s_explode5 ]
{
};

void () s_explode5 = [ 4, s_explode6 ]
{
};

void () s_explode6 = [ 5, SUB_Remove ]
{
};

void () NormalExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};
