
void () trigger_console =
{
	InitTrigger ();
	if (!self.event)
	{
		bprint ("Trigger Console with no command set in event field\n");
		remove (self);
	}
	self.touch = console_send;
};

void () console_send =
{
	if ((other.classname != "player"))
	{
		return;
	}
	stuffcmd (other, self.event);
	stuffcmd (other, "\n");
};

void () info_idscale =
{
	self.use = trigger_V_IDLES_use;
	if (!self.message)
	{
		dprint ("No V_IDLESCALE set in info_idscale\n");
	}
};

void () trigger_V_IDLES_use =
{
	cvar_set ("v_idlescale", self.message);
};

void () info_script =
{
	if ((coop || deathmatch))
	{
		self.message = "";
		self.targetname = "cammies";
		self.use = script_usetargets;
	}
};

void () script_usetargets =
{
	SUB_UseTargets ();
	remove (self);
};

void () info_camera =
{
	if ((coop || deathmatch))
	{
		remove (self);
		return;
	}
	self.use = camera_cyclez;
};

void () info_intermission =
{
	self.use = camera_cyclez;
};

void () remove_movers =
{
	local entity m;
//	local entity mtarg;

	m = find (world, classname, "info_movecam");
	while (m)
	{
		if ((m.think == come_to_me))
		{
			//mtarg = find(world, targetname, m.target);
			//if (mtarg)

			if (m.objekt)
				remove (m.objekt);

			remove (m);
		}
		m = find (m, classname, "info_movecam");
	}
};

void () info_movecam =
{
	if ((deathmatch || coop))
	{
		remove (self);
		return;
	}
	if ((self.speed < 1))
	{
		self.speed = 1;
	}
	self.use = move_the_camera;
};

void () move_the_camera =
{
	local entity head;
	local entity s;
//	local string str;

	head = find (world, classname, "camera");
	if ((head == world))
	{
		return;
	}
	remove_movers ();
	s = spawn ();
	s.origin = head.origin;
	setorigin (s, head.origin);
//	str = etos(s);
	self.enemy = head;
//	self.target = str;
	self.objekt = s;
//	s.targetname = str;
	s.classname = "mover";
	self.think = come_to_me;
	self.nextthink = (time + 0.01);
};

void () come_to_me =
{
	local vector dave;
	local entity s;
	local entity cam;
//	local entity targ;

//	targ = find(world, targetname, self.target);

	dave = self.enemy.origin - self.origin;
	if ((vlen (dave) < 10))
	{
		//if (targ)
		if (self.objekt)
			remove (self.objekt);

		remove (self);
		return;
	}
	s = self.objekt;
	cam = self.enemy;
	if ((s.origin_x < self.origin_x))
	{
		s.origin_x = (s.origin_x + self.speed);
	}
	if ((s.origin_x > self.origin_x))
	{
		s.origin_x = (s.origin_x - self.speed);
	}
	if ((s.origin_y < self.origin_y))
	{
		s.origin_y = (s.origin_y + self.speed);
	}
	if ((s.origin_y > self.origin_y))
	{
		s.origin_y = (s.origin_y - self.speed);
	}
	if ((s.origin_z < self.origin_z))
	{
		s.origin_z = (s.origin_z + self.speed);
	}
	if ((s.origin_z > self.origin_z))
	{
		s.origin_z = (s.origin_z - self.speed);
	}
	cam.origin = s.origin;
	setorigin (cam, s.origin);
	self.think = come_to_me;
	self.nextthink = (time + 0.01);
};

void () camera_cyclez =
{
	local entity head;

	head = find (world, classname, "camera");
	if (head == world)
	{
		return;
	}
	head.enemy = self;
	head.velocity = VEC_ORIGIN;
	head.view_ofs = VEC_ORIGIN;
	head.angles = self.mangle;
	head.origin = self.origin;
	setorigin (head, self.origin);
};

void (entity o) spawn_dummy =
{
	local entity s;

	if ((deathmatch || coop))
	{
		return;
	}
	s = spawn ();
	s.origin = o.origin;
	s.velocity = o.velocity;
	s.angles = o.angles;
	s.mangle = o.mangle;
	s.health = o.health;
	s.weapon = o.weapon;
	s.classname = "dummy";
	s.movetype = MOVETYPE_NONE;
	s.solid = SOLID_NOT;
	s.weaponmodel = o.weaponmodel;
	s.flags = o.flags;
	s.skin = o.skin;
	setorigin (s, o.origin);
	setmodel (s, o.model);
	s.frame = 12;
	s.think = dummy_stand;
	s.nextthink = (time + 0.1);
};

void () dummy_stand = [ 12, dummy_stand2 ]
{
};

void () dummy_stand2 = [ 13, dummy_stand3 ]
{
};

void () dummy_stand3 = [ 14, dummy_stand4 ]
{
};

void () dummy_stand4 = [ 15, dummy_stand5 ]
{
};

void () dummy_stand5 = [ 16, dummy_stand ]
{
};

void () name_player =
{
	local entity play;

	play = find (world, classname, "camera");
	play.classname = "player";
	stuffcmd (play, "-forward\n");
};

void () go_back =
{
	local entity t;
	local entity c;
	local entity d;
//	local vector org;
	local string val;

	if ((deathmatch || coop))
	{
		remove (self);
	}
	t = find (world, classname, "dummy");
	if (!t)
	{
		dprint ("couldn't find dummy");
		return;
	}
	c = find (world, classname, "camera");
	if (!c)
	{
		dprint ("couldn't find camera");
		return;
	}
	remove_movers ();
	setorigin (c, t.origin);
	c.velocity = t.velocity;
	c.view_ofs = '0 0 22';
	c.mangle = t.mangle;
	c.angles_x = t.angles_x;
	c.angles_y = t.angles_y;
	c.angles_z = t.angles_z;	//0;
	c.health = t.health;
	c.weapon = t.weapon;
	c.weaponmodel = t.weaponmodel;
	c.weaponframe = 0;
	c.flags = t.flags;
	c.fixangle = 1;
	c.takedamage = DAMAGE_AIM;
	c.solid = SOLID_SLIDEBOX;
	c.movetype = MOVETYPE_WALK;
	c.think = player_stand1;
	c.air_finished = (time + 12);
	stuffcmd (c, "v_cshift 0 0 0 0\n");
	d = spawn ();
	d.nextthink = (time + 0.1);
	d.think = name_player;
	val = ftos (c.cnt);
	cvar_set ("viewsize", val);
	val = ftos (c.blink);
	cvar_set ("chase_active", val);
	cvar_set ("v_idlescale", "0");
	t.nextthink = (time + 0.1);
	t.think = SUB_Remove;
	remove (self);
};

void () look_ahead =
{
	self.angles = self.enemy.mangle;
	self.fixangle = 1;
	self.nextthink = (time + 0.01);
};

void () go_camera =
{
	self.classname = "camera";
	self.velocity = VEC_ORIGIN;
	self.view_ofs = VEC_ORIGIN;
	self.angles = self.enemy.mangle;
	self.fixangle = 1;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.weaponmodel = "";
	self.nextthink = (time + 0.05);
	self.think = look_ahead;
	if (!self.script)
	{
		dprint ("trigger_camera needs a script number");
	}
	self.script_count = 0;
	self.cnt = cvar ("viewsize");
	self.blink = cvar ("chase_active");
	cvar_set ("chase_active", "0");
	cvar_set ("viewsize", "120");
	cvar_set ("v_idlescale", "0");
	setorigin (self, self.enemy.origin);
};

void () camera_use =
{
	local entity head;

	head = find (world, classname, "player");
	if ((head == world))
	{
		bprint ("No player found!\n");
		return;
	}
	if ((head.health <= 0))
	{
		dprint ("Player dead\n");
		return;
	}
	self.enemy = head;
	self.nextthink = (time + self.delay);
	self.think = activate_cutscene;
};

void () trigger_camera =
{
	InitTrigger ();
	if ((coop || deathmatch))
	{
		self.target = "cammies";
		self.use = script_usetargets;
		self.touch = camerap_touch;
		return;
	}
	self.touch = camera_touch;
	if (!self.target)
	{
		objerror ("no target");
	}
	self.use = camera_use;
};

void () camerap_touch =
{
//	local entity t;

	if (((other.health <= 0) || (other.classname != "player")))
	{
		return;
	}
	script_usetargets ();
};

void () Script_play =
{
	local entity scrpt;
	local entity temp;

	scrpt = find (world, script_num, self.script);
	if (!scrpt)
	{
		dprint ("Error: script not found!");
	}
	if (scrpt.target)
	{
		temp = self;
		self = scrpt;
		SUB_UseTargets ();
		self.target = string_null;
		self = temp;
	}
	self.script_delay = scrpt.script_delay;
	self.script_time = (time + 1);
	self.script_count = (self.script_count + 1);
	centerprint (self, scrpt.message);
	if ((self.script_count == self.script_delay))
	{
		self.script = scrpt.next_script;
		if ((self.script != "0"))
		{
			self.script_count = 0;
		}
		else
		{
			scrpt.nextthink = (time + MOVETYPE_STEP);
			scrpt.think = go_back;
		}
	}
	return;
};

void () big_bang =
{
	local vector newo;
	local float x;
	local float y;
	local float z;

	if ((self.wait == 1))
	{
		sound (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NONE);
	}
	x = (random () * FL_NOTARGET) - FL_GODMODE;
	y = (random () * FL_NOTARGET) - FL_GODMODE;
	z = (random () * FL_NOTARGET) - FL_GODMODE;
	newo_x = self.origin_x + x;
	newo_y = self.origin_y + y;
	newo_z = self.origin_z + z;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, newo_x);
	WriteCoord (MSG_BROADCAST, newo_y);
	WriteCoord (MSG_BROADCAST, newo_z);
	self.wait = (self.wait - 1);
	if ((self.wait < 0))
	{
		remove (self);
	}
	self.nextthink = ((time + (0.2 * random ())) + 0.1);
	self.think = big_bang;
};

void () misc_boom =
{
	precache_sound2 ("boss2/pop2.wav");
	self.use = big_bang;
};

void () info_angle =
{
	dprint ("There is no info_angle!!!!  Only Zuuuuul!!!!!!!!\n");
};

void () camera_touch =
{
//	local entity t;

	if (self.targetname)
	{
		if ((self.nextthink < time))
		{
			return;
		}
	}
	if ((((other.health <= 0) || (other.classname != "player")) || (self.cnt == CONTENT_EMPTY)))
	{
		return;
	}
	self.enemy = other;
	self.nextthink = (time + self.delay);
	self.think = activate_cutscene;
};

void () activate_cutscene =
{
	local entity t;

	ResetEnemies (self.enemy);
	SUB_UseTargets ();
	if ((self.enemy.flags & FL_ONGROUND))
	{
		self.enemy.flags = (self.enemy.flags - FL_ONGROUND);
	}
	if ((self.targetname == "xnehahra_finale"))
	{
		spawn_dummy_finale (self.enemy);
	}
	else
	{
		spawn_dummy (self.enemy);
	}
	t = find (world, targetname, self.target);
	if (!t)
	{
		error ("couldn't find target");
	}
	self.enemy.enemy = t;
	self.enemy.script = self.script;
	self.enemy.script_delay = self.script_delay;
	if (!deathmatch)
	{
		if (!coop)
		{
			self.enemy.nextthink = (time + 0.05);
			self.enemy.think = go_camera;
		}
	}
	self.cnt = CONTENT_EMPTY;
	self.nextthink = (time + 0.1);
	self.think = SUB_Remove;
};

void () info_fadeout =
{
	if ((self.speed == 0))
	{
		self.speed = 0.01;
	}
	self.cnt = 0;
	self.use = fade_out_go;
};

void () info_fadein =
{
	if ((self.speed == 0))
	{
		self.speed = 0.01;
	}
	self.cnt = 255;
	self.use = fade_in_go;
};

void () fade_in_go =
{
	if (findcamera ())
	{
		fade_in ();
	}
};

void () fade_out_go =
{
	if (findcamera ())
	{
		fade_away ();
	}
};

float () findcamera =
{
	local entity head;

	head = find (world, classname, "camera");
	if ((head == world))
	{
		return (0);
	}
	else
	{
		self.enemy = head;
		return (1);
	}
};

void () fade_in =
{
	fade_v_cshift ();
	self.cnt = (self.cnt - 5);
	if ((self.cnt < 1))
	{
		stuffcmd (self.enemy, "v_cshift 0 0 0 0");
		self.enemy = world;
		self.nextthink = (time + 9999);
		self.think = SUB_Null;
		return;
	}
	self.think = fade_in;
	self.nextthink = (time + self.speed);
};

void () fade_away =
{
	fade_v_cshift ();
	self.cnt = (self.cnt + 5);
	if ((self.cnt > 254))
	{
		stuffcmd (self.enemy, "v_cshift 0 0 0 255");
		self.enemy = world;
		self.nextthink = (time + 9999);
		self.think = SUB_Null;
		return;
	}
	self.think = fade_away;
	self.nextthink = (time + self.speed);
};

void () fade_v_cshift =
{
	stuffcmd (self.enemy, "v_cshift ");
	if ((self.spawnflags == 0))
	{
		stuffcmd (self.enemy, "0 ");
	}
	else
	{
		stuffcmd (self.enemy, "100 ");
	}
	stuffcmd (self.enemy, "0 0 ");
	stuffcmd (self.enemy, ftos (self.cnt));
	stuffcmd (self.enemy, "\n");
};
