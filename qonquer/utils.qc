void() entity_sink_think =
{
	// "sinkdistance" is used as a work variable to keep track of how much further
	// this entity has left to sink.
	self.sinkdistance = self.sinkdistance - 0.1;
	
	// move the entity downwards
	setorigin (self, self.origin + '0 0 -0.1');
	
	// if the sinkdistance is exhausted, schedule the entity for removal
	if (self.sinkdistance <= 0)
		self.think = SUB_Remove;
	
	// wait a little before sinking again
	self.nextthink = time + 0.01;	//0.2
};

void() entity_sink_setup =
{
/*
	// use half the height of the entity as a default sink distance.
	self.sinkdistance = 0.7*self.size_z;	//0.7
	
	// give the entity a minimum distance to sink of 32.  This allows entities
	// that don't have proper sizes set to sink properly.
	if (self.sinkdistance < 32)
		self.sinkdistance = 32;
	
	// start sinking a little time from now
	self.think = entity_sink_think;
	self.nextthink = time + 3;
*/
	self.fadetime = 0.7;

	self.think = SUB_Fadeaway;
	self.nextthink = time + 10;	//3
};

