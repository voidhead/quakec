
float (float dist) ai4_strategy =
{
	local vector megadeth;
	local entity head;
//	local vector dave;
	local float num;

	if (visible (self.enemy))
	{
		self.xtrace = self.enemy.origin;
		self.xgoal = VEC_ORIGIN;
		return (0);
	}
	if ((self.xgoal != '0 0 0'))
	{
		if ((self.xtrace == '0 0 0'))
		{
			self.xgoal = self.xtrace;
			return (0);
		}
		if ((self.enemy.waterlevel > 0))
		{
			if (!scan_xgoal ())
			{
				self.nojump = 50;
				self.xgoal = '0 0 0';
				self.xtrace = '0 0 0';
				return (0);
			}
		}
		megadeth = self.xgoal - self.origin;
		if ((vlen (megadeth) < 40))
		{
			if ((self.xgoal == self.xtrace))
			{
				self.xtrace = '0 0 0';
			}
		}
	}
	if ((self.xgoal == VEC_ORIGIN))
	{
		if ((self.xtrace != VEC_ORIGIN))
		{
			self.xgoal = self.xtrace;
		}
		else
		{
			return (0);
		}
	}
	if (ai4_vis (self.xgoal))
	{
		ai4_face (self.xgoal);
		if ((self.flags & FL_ONGROUND))
		{
			if (((self.nojump == FALSE) && ai4_checkorg_z ('0 0 1'*self.xgoal)))
			{
				num = at_ledge (self.angles, self.origin);
				if ((num > CONTENT_SLIME))
				{
					ai2_jump (self.angles, 200, '0 0 225');
				}
			}
		}
	}
	coffee_move (dist);
	return (1);
};

float () scan_xgoal =
{
	local vector spot1;
	local vector spot2;

	if ((self.brain & INTREPID))
	{
		return (1);
	}
	spot1 = self.xgoal;
	if ((pointcontents (spot1) < CONTENT_SOLID))
	{
		return (0);
	}
	spot2 = spot1 - '0 0 2000';
	traceline (spot1, spot2, 1, self.enemy);
	if ((trace_fraction == 1))
	{
		return (0);
	}
	if ((pointcontents (trace_endpos) < CONTENT_SOLID))
	{
		return (0);
	}
	return (1);
};

void (vector dave) ai4_face =
{
	self.ideal_yaw = vectoyaw ((dave - self.origin));
	ChangeYaw ();
};

float (float dave) ai4_checkorg_z =
{
	local float num;
//	local float t;

	if ((dave < self.origin_z))
	{
		num = self.origin_z - dave;
		if ((num > 40))
		{
			return (1);
		}
	}
	return (0);
};

void (float dist) coffee_move =
{
	movedist = dist;
	if ((walkmove (self.angles_y, movedist) == 0))
	{
		if ((walkmove ((self.angles_y + self.button1), movedist) == 0))
		{
			self.angles_y = (self.angles_y + (self.button1 / SPAWNFLAG_LASER));
		}
	}
	if ((random () <= 0.02))
	{
		if ((self.button1 == 90))
		{
			self.button1 = -90;
		}
		else
		{
			self.button1 = 90;
		}
	}
};

float (vector dave) ai4_vis =
{
	local vector spot1;
	local vector spot2;

	spot1 = self.origin + self.view_ofs;
	spot2 = dave + self.enemy.view_ofs;
	traceline (spot1, spot2, 1, self);
	if ((trace_inopen && trace_inwater))
	{
		return (0);
	}
	if ((trace_fraction == 1))
	{
		return (1);
	}
	return (0);
};

void () ai4_checkblink =
{
	local float t;

	if (!(self.flags & FL_ONGROUND))
	{
		return;
	}
	if ((self.enemy.classname != "player"))
	{
		return;
	}
	if (visible (self.enemy))
	{
		return;
	}
	if (coop)
	{
		return;
	}
	if ((self.classname == "monster_beard"))
	{
		t = 200;
	}
	else
	{
		t = 600;
	}
	if (ai2_checkdist (self.enemy, 600))
	{
		return;
	}
	self.blink = (self.blink + 1);
	if ((self.blink > 15))
	{
		self.blink = 0;
	}
	if ((self.blink == 1))
	{
		fudge_blink1 ();
	}
	else
	{
		if ((self.blink == 5))
		{
			fudge_blink2 ();
		}
		else
		{
			if ((self.blink == 10))
			{
				if ((random () > 0.2))
				{
					self.blink = -10;
					return;
				}
				fudge_blink3 ();
			}
		}
	}
};

void () fudge_blink1 =
{
	local entity head;
	local entity selected;
	local float dist;
	local vector spot;

	dist = 500;
	selected = world;
	head = findradius (self.origin, 500);
	while (head)
	{
		if ((trace_plane_dist < 500))
		{
			if (((head.classname == "trigger_teleport") || (head.classname == "trigger_qtele")))
			{
				selected = head;
				dist = trace_plane_dist;
			}
		}
		head = head.chain;
	}
	if ((selected == world))
	{
		return;
	}
	else
	{
		self.aether = self.origin;
		spot = Sub_CalcOrigin (selected);
		beardblink ();
		self.origin = spot;
		if (!walkmove (0, 0))
		{
			self.origin = self.aether;
		}
		self.aether = VEC_ORIGIN;
		beardblink ();
	}
};

void () fudge_blink2 =
{
	local entity head;
	local entity selected;
	local float dist;
	local float num;

	if (!ai_check_z ())
	{
		return;
	}
	dist = 500;
	selected = world;
	head = findradius (self.origin, 500);
	while (head)
	{
		if ((((head.flags & FL_ITEM) || (head.flags & FL_MONSTER)) || (head.classname == "info_player_start")))
		{
			if ((head.origin_z > self.origin_z))
			{
				num = head.origin_z - self.origin_z;
				if ((num > 50))
				{
					if (((head.health < 1) && (trace_plane_dist < 500)))
					{
						if ((pointcontents (head.origin) == CONTENT_EMPTY))
						{
							traceline (self.origin, head.origin, 1, self);
							if ((trace_fraction < 1))
							{
								selected = head;
								dist = trace_plane_dist;
							}
						}
					}
				}
			}
		}
		head = head.chain;
	}
	if ((selected != world))
	{
		beardblink ();
		self.xtrace = self.origin;
		self.origin = (selected.origin + '0 0 25');
		beardblink ();
		if (!walkmove (0, 0))
		{
			self.origin = self.xtrace;
		}
		self.xtrace = VEC_ORIGIN;
	}
};

void () beardblink =
{
	if ((self.classname == "monster_beard"))
	{
		spawn_tfog (self.origin);
	}
};

void () fudge_blink3 =
{
	local entity head;
	local entity selected;
	local vector megadeth;
	local vector dave;
	local float dist;

	selected = world;
	head = find (world, classname, "info_teleport_destination");
	while (head)
	{
		megadeth = head.origin - self.enemy.origin;
		dave = self.origin - self.enemy.origin;
		if ((vlen (megadeth) < vlen (dave)))
		{
			selected = head;
		}
		head = find (head, classname, "info_teleport_destination");
	}
	if ((selected != world))
	{
		self.blink = -120;
		self.angles = selected.mangle;
		spawn_tfog (self.origin);
		spawn_tdeath (selected.origin, self);
		self.origin = selected.origin;
		spawn_tfog (selected.origin);
		if ((self.flags & FL_ONGROUND))
		{
			self.flags = (self.flags - FL_ONGROUND);
		}
		self.velocity = (v_forward * 300);
	}
};

void () path_danger =
{
	setorigin (self, self.origin);
	self.solid = SOLID_TRIGGER;
	self.health = 69;
	setsize (self, '-8 -8 -8', '8 8 8');
	self.touch = direct_fleers;
	InitTrigger ();
};

void () direct_fleers =
{
//	local entity mark;
//	local entity head;

	if (!(other.flags & FL_MONSTER))
	{
		return;
	}
	if ((other.enemy != self))
	{
		return;
	}
	if (self.target2)
	{
		if ((random () < 0.4))
		{
			other.enemy = find (world, targetname, self.target2);
			return;
		}
	}
	other.enemy = find (world, targetname, self.target);
};
