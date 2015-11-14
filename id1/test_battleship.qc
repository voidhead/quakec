float	ROWS		= 10;
float	COLS		= 10;
float	board[ROWS*COLS];
float	total_tries;

float	TILE_NEAR	= -1;
float	TILE_EMPTY	= 0;
float	TILE_SHIP1	= 1;
float	TILE_SHIP2	= 2;
float	TILE_SHIP3	= 3;
float	TILE_SHIP4	= 4;


float(float r, float c) tile =
{
	return (COLS*(r - 1) + c) - 1;
};

float(float r, float c) get_tile =
{
	return board[tile(r, c)]; 
};

float(float r, float c) test_tile = 
{
	// out of bounds always passes
	if (r < 1 || r > ROWS || c < 1 || c > COLS)
		return TRUE;

	// the tile is empty
	if (get_tile(r, c) <= TILE_EMPTY)
		return TRUE;
	else
		return FALSE;
};

void(float r, float c, float value) fill_tile =
{
	// do not fill if out of bounds
	if (r < 1 || r > ROWS || c < 1 || c > COLS)
		return;

	//do not overdraw
	if (get_tile(r, c))
	if (get_tile(r, c) >= value)
		return;

	board[tile(r, c)] = value; 
};

float(float x, float y, float szx, float szy) test_ship =
{
	local float i, j;

	for (i = x - 1; i <= x + szx; i++)
	for (j = y - 1; j <= y + szy; j++)
	{
		if (!test_tile(i, j))
			return FALSE;	// next to another ship
	}

	return TRUE;
};

void(float x, float y, float szx, float szy, float value) fill_ship =
{
	local float i, j;

	for (i = x - 1; i <= x + szx; i++)
	for (j = y - 1; j <= y + szy; j++)
		fill_tile(i, j, TILE_NEAR);

	for (i = x; i <= x + szx - 1; i++)
	for (j = y; j <= y + szy - 1; j++)
		fill_tile(i, j, value);
};

void(float sz, float ship) place_ship =
{
	local float x, y, sz1, sz2, tries, done;
	
	do
	{
		tries++;

		x = 1 + floor(ROWS*random());
		y = 1 + floor(COLS*random());

//		print("trying at (", ftos(x), ",", ftos(y), ") try:", ftos(tries), "\n");

		// retry if already occupied
		if (get_tile(x, y))
			continue;

		// flip randomly for some variety
		if (random() > 0.5)
		{
			sz1 = sz;
			sz2 = 1;
		}
		else
		{
			sz1 = 1;
			sz2 = sz;
		}

		// retry if outside of the board boundaries
		if (x + sz1 - 1 > COLS || y + sz2 - 1> ROWS)
			continue;

		done = test_ship(x, y, sz1, sz2);

		if (done)
		{
			print("placed ship (", ftos(sz1), ",", ftos(sz2));
			print(") at (", ftos(x), ",", ftos(y), ") tries:", ftos(tries), "\n");

			fill_ship(x, y, sz1, sz2, ship);
			total_tries += tries;
			return;
		}
			
	}
	while (done == FALSE);
};

void() clearboard =
{
	local float i;

	for (i = 0; i < ROWS*COLS; i++)
		board[i] = TILE_EMPTY;

	total_tries = 0;
};

void() fillboard =
{
	place_ship(4, 1);

	place_ship(3, 2);
	place_ship(3, 2);

	place_ship(2, 3);
	place_ship(2, 3);
	place_ship(2, 3);

	place_ship(1, 4);
	place_ship(1, 4);
	place_ship(1, 4);
	place_ship(1, 4);

/*
// american variant
	place_ship(5, 1);

	place_ship(4, 2);

	place_ship(3, 3);
	place_ship(3, 3);

	place_ship(2, 4);
	place_ship(2, 4);
*/

	print("total tries: ", ftos(total_tries), "\n");
};

void() printboard =
{
	local float r, c, t;
	local string str, str2, str3;

	if (self.enemy.classname != "player")
		return;

	str2 = "\n\n\n\n\n\n";

	for (r = 1; r <= ROWS; r++)
	{
		str = string_null;

		for (c = 1; c <= COLS; c++)
		{
			t = get_tile(r, c);

//			if (t == TILE_EMPTY)
//				str = strcat(str, chr2str(5));
//			else if (t == TILE_NEAR)
//				str = strcat(str, chr2str(133));
			if (t == TILE_SHIP1)
				str = strcat(str, "^1", chr2str(11), "^7");	//139
			else if (t == TILE_SHIP2)
				str = strcat(str, "^2", chr2str(11), "^7");
			else if (t == TILE_SHIP3)
				str = strcat(str, "^3", chr2str(11), "^7");
			else if (t == TILE_SHIP4)
				str = strcat(str, "^5", chr2str(11), "^7");
			else
				str = strcat(str, chr2str(5));
		}

		str2 = strcat(str2, "\n", str);
	}

	centerprint(self.enemy, str2);

/*
// double-sized output
	for (r = 1; r <= ROWS; r++)
	{
		str2 = string_null;

		for (c = 1; c <= COLS; c++)
		{
			t = get_tile(r, c);

			if (t == TILE_SHIP1)
				str = strcat("^1", chr2str(11), "^7");	//139
			else if (t == TILE_SHIP2)
				str = strcat("^2", chr2str(11), "^7");
			else if (t == TILE_SHIP3)
				str = strcat("^3", chr2str(11), "^7");
			else if (t == TILE_SHIP4)
				str = strcat("^5", chr2str(11), "^7");
			else
				str = strcat(chr2str(5));

				str2 = strcat(str2, str, str);
		}

		str3 = strcat(str3, "\n", str2, "\n", str2);
	}

	centerprint(self.enemy, str3);
*/
};


void() test_explobox_use =
{
	if (self.spawnflags & START_OFF)
	{
		spawn_tfog(self.origin + 0.5*(self.mins + self.maxs));

		self.solid = SOLID_BBOX;	// allow it to be touched again
		self.health = 5;
		self.model = self.mdl;		// restore original model

		setorigin (self, self.origin);
		setmodel(self, self.model);

		setsize (self, '-24 -24 0', '24 24 48');

		self.spawnflags = self.spawnflags - (self.spawnflags & START_OFF);
	}
	else
	{
		self.solid = SOLID_NOT;
		self.model = self.mdl = "";
		self.spawnflags = self.spawnflags | START_OFF;
	}
};

void(entity killer, float damage) test_explobox_die =
{
	local entity e;
	local vector org;

	org = self.origin + 0.5*(self.mins + self.maxs);
//	self.origin = org;

	self.spawnflags = self.spawnflags | START_OFF;
	self.solid = SOLID_NOT;
	self.model = self.mdl = "";
	
	// keep track who exploded the barrel
	T_RadiusDamage(self, killer, 48, world, "barrel");	//160

	// put explosion fx
	barrel_gibs(org);
	te_explosion(org);		

	e = spawn();
	setorigin(e, org);
	e.think = BecomeExplosion;
	e.nextthink = time + 0.01;
};

void() misc_explobox_place =
{
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_AIM;
	self.flags = self.flags | FL_NOBLOOD;
//	self.effects = self.effects | EF_DYNAMICMODELLIGHT;

	self.scale = 1.5;
	self.health = 5;
	self.th_die = test_explobox_die;
	self.use = test_explobox_use;
	self.mass = EXTRA_HIGH;

	setmodel (self, self.mdl);
	setsize (self, '-24 -24 0', '24 24 48');
//	setsize (self, '-18 -18 0', '18 18 48');

	if (self.spawnflags & START_OFF)
	{
		self.model = "";
		self.solid = SOLID_NOT;
	}

	self.origin_z = self.origin_z + 8;
	droptofloor(0,0);	
};

void() misc_explobox_test =
{
	precache_model ("progs/b_shell1.bsp");
	precache_model ("progs/b_nail1.bsp");
	precache_model ("progs/b_batt1.bsp");
	precache_model ("progs/b_bh100.bsp");

	precache_model ("progs/crt_gib1.mdl");
	precache_model ("progs/crt_gib2.mdl");
	precache_model ("progs/crt_gib3.mdl");
	precache_model ("progs/crt_gib4.mdl");
	precache_model ("progs/crt_gib5.mdl");
	precache_model ("progs/crt_gib6.mdl");
	precache_model ("progs/crt_gib7.mdl");
	precache_model ("progs/crt_gib8.mdl");

	self.think = misc_explobox_place;
	self.nextthink = time + 0.2;
};


void() switch_spotlights =
{
	local float i;
	local string str;
	local entity spot;

	for (i = 0; i < ROWS*COLS; i++)
	{
		str = strcat("spot", ftos(i));
		spot = find (world, netname, str);

		if (!spot)
			continue;

		if (board[i] > TILE_EMPTY)
			spot.style = 13;
		else
			spot.style = 63;
	}

	SUB_UseTargets();

//	spot = find (world, targetname, self.target);
//	spot.use();	
};

void() switch_boxes =
{
	local float i;
	local string str;
	local entity box, stemp;

	for (i = 0; i < ROWS*COLS; i++)
	{
		str = strcat("box", ftos(i));
		box = find (world, targetname, str);

//		eprint (box);

		if (!box)
		{
			print(str, "\n");
			continue;
		}
		
/*		if (board[i] <= TILE_EMPTY)
		{
			if (box.model == "" || box.health < 1)		
				continue;
		}
		else if (box.model =! "")
			self.spawnflags = self.spawnflags | START_OFF;
*/	
		// place the box at current cell;	
		if (board[i] > TILE_EMPTY)
		{		
			// if there was already a box, replace it
			if (box.model != "")
				box.spawnflags = box.spawnflags | START_OFF;

			if (board[i] == TILE_SHIP1)
				box.mdl = "progs/b_shell1.bsp";
			else if (board[i] == TILE_SHIP2)
				box.mdl = "progs/b_nail1.bsp";
			else if (board[i] == TILE_SHIP3)
				box.mdl = "progs/b_batt1.bsp";
			else if (board[i] == TILE_SHIP4)
				box.mdl = "progs/b_bh100.bsp";
		}
		// if the cell is empty and/or the box has been destroyed, skip it
		else if (box.model == "")
			continue;

		stemp = self;
		self = box;
		box.use();
		self = stemp;
	}
};

void() trigger_board_use =
{
	self.enemy = activator;

	fillboard();

	// switch lights
	if (self.spawnflags & 1)	
		switch_spotlights();

	// place boxes and print
	else if (self.spawnflags & 2)
	{
		switch_boxes();
		printboard();
	}
	
	// print via centerprint
	else
		printboard();

	clearboard();
};

void() trigger_board =
{
	self.use = trigger_board_use;	
};


void() monster_shambler_test =
{
	monster_shambler();
	self.th_missile = SUB_Null;
};