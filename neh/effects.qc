
void () RestoreGame =
{
	local entity head;

	dprint ("RESTORE GAME CALLED\n");
	head = spawn ();
	head.think = restore_settings;
	head.nextthink = (time + 0.05);
};

void (entity obj1, entity obj2) fog_restoration =
{
	stuffcmd (obj1, "gl_fogenable ");
	fog_ftos_scr (obj2.clfog_enable, obj1);
	stuffcmd (obj1, "gl_fogdensity ");
	fog_ftos_scr (obj2.clfog_density, obj1);
	stuffcmd (obj1, "gl_fogred ");
	fog_ftos_scr (obj2.clfog_red, obj1);
	stuffcmd (obj1, "gl_foggreen ");
	fog_ftos_scr (obj2.clfog_green, obj1);
	stuffcmd (obj1, "gl_fogblue ");
	fog_ftos_scr (obj2.clfog_blue, obj1);
};

void () restore_settings =
{
	local entity mark;
	local entity head;

	head = find (world, classname, "player");
	if ((head == world))
	{
		error ("Could not restore settings!\n");
	}
	stuffcmd (head, "v_cshift 0 0 0 0\n");
	mark = find (world, classname, "info_start");
	if ((mark == world))
	{
		stuffcmd (head, "gl_fogenable 0\n");
		stuffcmd (head, "r_wateralpha 1\n");
		stuffcmd (head, "r_oldsky 1\n");
		bprint ("RestoreGame: No info_start found!\n");
		return;
	}
	if (mark.noise)
	{
		stuffcmd (head, "playmod ");
		stuffcmd (head, mark.noise);
		stuffcmd (head, "\n");
	}
	if (mark.sky)
	{
		stuffcmd (head, "r_oldsky 0\n");
		WriteByte (MSG_ALL, SVC_SKYBOX);
		WriteString (MSG_ALL, mark.sky);
	}
	fog_restoration (head, mark);
	stuffcmd (head, "r_waterripple ");
	stuffcmd (head, ftos (mark.wripple));
	stuffcmd (head, "\n");
	stuffcmd (head, "r_wateralpha ");
	stuffcmd (head, ftos (mark.walpha));
	stuffcmd (head, "\n");
	stuffcmd (head, "sv_gravity ");
	stuffcmd (head, ftos (mark.gravity));
	stuffcmd (head, "\n");
};

void () info_start =
{
	if ((world.model == "maps/neh1m8.bsp"))
	{
		spawn_borkedvigil ('-1466 3259 -1501');
		spawn_borkedvigil ('-1688 2712 -1501');
	}
	if ((world.model == "maps/nehend.bsp"))
	{
		self.fog_density = 0.2;
		self.fog_red = 1;
		self.fog_blue = 0;
		self.fog_green = 0.1;
		self.fog_enable = 0;
	}
	fog_defaults ();
	if ((self.gravity == 0))
	{
		self.gravity = 800;
	}
	if ((self.walpha == 0))
	{
		self.walpha = 1;
	}
	self.think = supervise_level;
	self.nextthink = (time + 0.3);
};

void () supervise_level =
{
//	local vector vec;
	local entity head;
	local vector spot1;
	local vector spot2;

	head = find (world, soul, "yes");
	while (head)
	{
		if ((head.health > 0))
		{
			if ((head.classname != "monster_wizard"))
			{
				if ((head.classname != "player"))
				{
					if ((pointcontents (head.origin) == CONTENT_LAVA))
					{
						T_Damage (head, self, self, 20);
					}
				}
			}
		}
		head = find (head, soul, "yes");
	}
	head = find (world, classname, "player");
	while (head)
	{
		if ((((head.health > -40) && (head.health < 1)) && (head.lives != -1)))
		{
			spot1 = head.origin - '0 0 50';
			traceline (head.origin, spot1, 1, head);
			if ((pointcontents (trace_endpos) < CONTENT_SLIME))
			{
				msg_entity = head;
				WriteByte (MSG_ONE, SVC_HIDELMP);
				WriteString (MSG_ONE, "deadstate");
				WriteByte (MSG_ONE, SVC_SHOWLMP);
				WriteString (MSG_ONE, "deadstate");
				WriteString (MSG_ONE, "gfx/it/res2.lmp");
				WriteByte (MSG_ONE, 10);
				WriteByte (MSG_ONE, 10);
				head.dlmp = 1;
				head.lives = -1;
			}
		}
		if (((head.health > 0) && (head.dlmp == 1)))
		{
			msg_entity = head;
			WriteByte (MSG_ONE, SVC_HIDELMP);
			WriteString (MSG_ONE, "deadstate");
			head.dlmp = 0;
		}
		head = find (head, classname, "player");
	}
	self.nextthink = (time + 0.5);
	self.think = supervise_level;
};

void () fog_defaults =
{
	if ((self.fog_start == 0))
	{
		self.fog_start = 50;
	}
	if ((self.fog_end == 0))
	{
		self.fog_end = 1500;
	}
	if ((self.fog_density == 0))
	{
		self.fog_density = 0.8;
	}
};

void () trigger_fog =
{
	fog_defaults ();
	InitTrigger ();
	self.touch = adjust_fog;
};

void (entity obj1, entity obj2, entity obj3) fog_set =
{
//	local string txt;

	stuffcmd (obj1, "gl_fogenable ");
	fog_ftos_scr (obj2.fog_enable, obj1);
	stuffcmd (obj1, "gl_fogdensity ");
	fog_ftos_scr (obj2.fog_density, obj1);
	stuffcmd (obj1, "gl_fogred ");
	fog_ftos_scr (obj2.fog_red, obj1);
	stuffcmd (obj1, "gl_foggreen ");
	fog_ftos_scr (obj2.fog_green, obj1);
	stuffcmd (obj1, "gl_fogblue ");
	fog_ftos_scr (obj2.fog_blue, obj1);
	obj3.clfog_enable = obj2.fog_enable;
	obj3.clfog_red = obj2.fog_red;
	obj3.clfog_green = obj2.fog_green;
	obj3.clfog_blue = obj2.fog_blue;
	obj3.clfog_density = obj2.fog_density;
	obj3.clfog_start = obj2.fog_start;
	obj3.clfog_end = obj2.fog_end;
};

void () adjust_fog =
{
	local entity head;
//	local entity targ;

	if ((other.classname != "player"))
	{
		return;
	}
	head = find (world, classname, "info_start");
	if ((head == world))
	{
		objerror ("YOUR LEVEL NEEDS AN INFO_START");
	}
	if ((self.spawnflags & FL_MONSTER))
	{
		fog_set (other, head, head);
		return;
	}
	fog_set (other, self, head);
	if (self.target)
	{
		SUB_UseTargets ();
	}
};

void (float num, entity obj1) fog_ftos_scr =
{
	local string txt;

	txt = ftos (num);
	stuffcmd (obj1, txt);
	stuffcmd (obj1, "\n");
};

void () client_cvarpimp =
{
	local entity obj1;
	local entity head;

	obj1 = spawn ();
	obj1.origin = self.origin;
	head = find (world, classname, "info_start");
	obj1.owner = self;
	obj1.enemy = head;
	if ((head == world))
	{
		dprint ("No info_start\n");
		obj1.think = client_cvarnorm;
	}
	else
	{
		obj1.think = set_clientcvars;
	}
	obj1.nextthink = (time + 0.1);
};

void () set_clientcvars =
{
//	local entity temp;
	local float num;

	stuffcmd (self.owner, "v_cshift 0 0 0 0\n");
	if ((self.enemy.sky != ""))
	{
		stuffcmd (self.owner, "r_oldsky 0\n");
		WriteByte (MSG_ALL, SVC_SKYBOX);
		WriteString (MSG_ALL, self.enemy.sky);
	}
	fog_set (self.owner, self.enemy, self.enemy);
	if (self.enemy.noise)
	{
		stuffcmd (self.owner, "playmod ");
		stuffcmd (self.owner, self.enemy.noise);
		stuffcmd (self.owner, "\n");
	}
	num = self.enemy.walpha;
	if ((num == 0))
	{
		num = 0.9;
	}
	stuffcmd (self.owner, "r_wateralpha ");
	stuffcmd (self.owner, ftos (num));
	stuffcmd (self.owner, "\n");
	stuffcmd (self.owner, "sv_gravity ");
	stuffcmd (self.owner, ftos (self.enemy.gravity));
	stuffcmd (self.owner, "\n");
	stuffcmd (self.owner, "r_waterripple ");
	stuffcmd (self.owner, ftos (self.enemy.wripple));
	stuffcmd (self.owner, "\n");
	remove (self);
};

void () client_cvarnorm =
{
	stuffcmd (self.owner, "v_cshift 0 0 0 0\n");
	stuffcmd (self.owner, "r_oldsky 1\n");
	stuffcmd (self.owner, "r_waterripple 2\n");
	stuffcmd (self.owner, "gl_fogenable 0\n");
	stuffcmd (self.owner, "gl_fogdensity 0.8\n");
	stuffcmd (self.owner, "gl_fogred 0.3\n");
	stuffcmd (self.owner, "gl_foggreen 0.3\n");
	stuffcmd (self.owner, "gl_fogblue 0.3\n");
	stuffcmd (self.owner, "r_wateralpha 1\n");
	remove (self);
};

void () info_particles =
{
	if ((self.speed == 0))
	{
		self.speed = 1;
	}
	if ((self.delay == 0))
	{
		self.delay = 0.1;
	}
	if (self.targetname)
	{
		if ((self.spawnflags & FL_GODMODE))
		{
			self.use = particles_reset;
			self.think = emit_particles;
			self.nextthink = (time + self.wait);
			return;
		}
		self.use = trigger_particles;
		return;
	}
	trigger_particles ();
};

void () trigger_particles =
{
	self.count = 0;
	self.use = particles_reset;
	self.think = emit_particles;
	self.nextthink = (time + self.wait);
};

void () particles_reset =
{
	self.use = trigger_particles;
	self.think = info_player_start;
	self.nextthink = (time + 999999);
};

void () emit_particles =
{
	local vector spot1;

	if ((self.endtime > 0))
	{
		self.count = (self.count + self.delay);
		if ((self.count > self.endtime))
		{
			particles_reset ();
			return;
		}
	}
	if ((self.method < 1))
	{
		particle (self.origin, self.movedir, self.cnt, self.duration);
	}
	else
	{
		makevectors (self.aether);
		self.aether_y = (self.aether_y + self.speed);
		if ((self.aether_y > 360))
		{
			self.aether_y = (self.aether_y - 360);
		}
		if ((self.aether_y < 0))
		{
			self.aether_y = (self.aether_y + 360);
		}
		spot1 = self.origin + (v_forward * self.impulse);
		particle (spot1, self.movedir, self.cnt, self.duration);
		if ((self.method == 2))
		{
			spot1 = self.origin + (v_forward * (0 - self.impulse));
			particle (spot1, self.movedir, self.cnt, self.duration);
		}
	}
	self.think = emit_particles;
	self.nextthink = (time + self.delay);
};

void () misc_smokemaker =
{
	precache_model ("progs/null.mdl");
	if (!self.speed)
	{
		self.speed = 2000;
	}
	if ((self.cnt == 0))
	{
		self.cnt = 0.2;
	}
	if ((self.wait == 0))
	{
		self.wait = 0.5;
	}
	if (self.targetname)
	{
		self.use = trigger_smoke;
		return;
	}
	self.nextthink = (time + random ());
	self.think = spawn_smokethang;
};

void () trigger_smoke =
{
	self.use = stop_smoke;
	self.nextthink = (time + random ());
	self.think = spawn_smokethang;
};

void () stop_smoke =
{
	self.nextthink = (time + 99999);
	self.think = SUB_Null;
	self.use = trigger_smoke;
};

void () spawn_smokethang =
{
	local entity head;

	head = spawn ();
	head.alpha = -1;
	head.solid = SOLID_TRIGGER;
	head.movetype = MOVETYPE_NOCLIP;
	head.velocity = '0 0 1000';
	head.velocity_z = (self.speed + (random () * 200));
	setmodel (head, "progs/null.mdl");
	setsize (head, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (head, self.origin);
	head.effects = (head.effects & EF_NODRAW);
	head.nextthink = (time + self.wait);
	head.think = SUB_Remove;
	if ((self.cnt == -1))
	{
		self.nextthink = (time + random ());
	}
	else
	{
		self.nextthink = (time + self.cnt);
	}
	self.think = spawn_smokethang;
};

void (vector vec) lavasplash =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, vec_x);
	WriteCoord (MSG_BROADCAST, vec_y);
	WriteCoord (MSG_BROADCAST, vec_z);
};

void (vector vec) makesmoke =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_SMOKE);
	WriteCoord (MSG_BROADCAST, vec_x);
	WriteCoord (MSG_BROADCAST, vec_y);
	WriteCoord (MSG_BROADCAST, vec_z);
	WriteByte (MSG_BROADCAST, 15);
};
