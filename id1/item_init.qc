/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */

/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

void() item_use =
{
	
};

/*
============
PlaceItem

plants the object on the floor
============
*/

void() PlaceItem =
{
//	local float oldz;

	self.mdl = self.model;		// so it can be restored on respawn

	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = VEC_0;

	self.origin_z = self.origin_z + 6;

	if (!droptofloor(0,0))
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}
};


void() PlaceItem_off =
{
	self.mdl = self.model;
	self.model = "";

	self.flags = FL_ITEM;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;	//MOVETYPE_NONE;	
	self.velocity = VEC_0;

	self.think1 = self.touch;
	self.touch = SUB_Null;
	self.use = SUB_Regen;

	self.origin_z = self.origin_z + 6;
	droptofloor(0,0);
};


/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
	self.nextthink = time + 0.2;	// items start after other solids

	if (self.spawnflags & SPAWNFLAG_ITEM_TARGETED)
	{
		if (!self.targetname)
			objerror("No targetname for triggerable item.");

		self.oldorigin = self.origin;
		self.think = PlaceItem_off;
		return;
	}

	self.think = PlaceItem;
};

void() item_tfog =
{
	pointparticles(particleeffectnum("TE_ITEMTELEPORT"), self.origin, VEC_0, 1);
};