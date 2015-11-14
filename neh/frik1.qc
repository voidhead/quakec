
void () Deathmatch5 =
{
	self.ammo_rockets = 10;
	self.ammo_nails = 50;
	self.ammo_shells = 52;
	self.items = ((((((((((self.items | IT_SWORD) | IT_NAILGUN) | IT_SHOTGUN) | IT_SUPER_SHOTGUN) | IT_AUTO_SHOTGUN) | IT_SUPER_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_ROCKET_LAUNCHER) | IT_KEY1) | IT_KEY2);
	self.ammo_cells = 50;
	self.items = ((self.items | IT_LIGHTNING) | IT_SPROCKET);
	self.regen = 30;
	self.weapon = IT_SUPER_SHOTGUN;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

void (entity belf, float num) dm3_adjustscores =
{
	if ((deathmatch != 3))
	{
		return;
	}
	if ((belf.pmodel == 0))
	{
		tscore0 = tscore0 + num;
	}
	if ((belf.pmodel == 1))
	{
		tscore1 = tscore1 + num;
	}
	if ((belf.pmodel == 2))
	{
		tscore2 = tscore2 + num;
	}
	if ((belf.pmodel == 3))
	{
		tscore3 = tscore3 + num;
	}
	if ((belf.pmodel == 4))
	{
		tscore4 = tscore4 + num;
	}
	if ((belf.pmodel == 5))
	{
		tscore5 = tscore5 + num;
	}
};

void () dm3_showscores =
{
	if ((deathmatch != 3))
	{
		return;
	}
	sprint (self, "DEATHMATCH 3 SCORES\n");
	sprint (self, "###################\n");
	sprint (self, "Marines       ");
	sprint (self, ftos (tscore0));
	sprint (self, "\n");
	sprint (self, "Grunts        ");
	sprint (self, ftos (tscore1));
	sprint (self, "\n");
	sprint (self, "Lab Guys      ");
	sprint (self, ftos (tscore2));
	sprint (self, "\n");
	sprint (self, "Ogre Mutants  ");
	sprint (self, ftos (tscore3));
	sprint (self, "\n");
	sprint (self, "Bents         ");
	sprint (self, ftos (tscore4));
	sprint (self, "\n");
	sprint (self, "Jacks         ");
	sprint (self, ftos (tscore5));
	sprint (self, "\n###################\n");
};

float () PmodelChanged =
{
	if ((self.oldpmodel == self.pmodel))
	{
		return (0);
	}
	if ((self.pmodel_time > time))
	{
		return (0);
	}
	self.pmodel_time = (time + 3);
	self.oldpmodel = self.pmodel;
	ClientPmodelChange ();
	return (1);
};

void () ClientPmodelChange =
{
	if ((self.health < 1))
	{
		erase_deadstate ();
	}
	bprint (self.netname);
	bprint (" respawns as ");
	if ((self.pmodel == 0))
	{
		bprint ("quake marine\n");
	}
	else
	{
		if ((self.pmodel == 1))
		{
			bprint ("grunt\n");
		}
		else
		{
			if ((self.pmodel == 2))
			{
				bprint ("labguy\n");
			}
			else
			{
				if ((self.pmodel == 3))
				{
					bprint ("ogre mutant\n");
				}
				else
				{
					if ((self.pmodel == 4))
					{
						bprint ("Bent\n");
					}
					else
					{
						bprint ("Jack\n");
					}
				}
			}
		}
	}
	set_suicide_frame ();
	self.angles_x = 0;
	self.angles_z = 0;
	self.modelindex = self.modelindex_player;
	respawn ();
};

void () select_pmodel =
{
	local float num;

	if (((deathmatch < 1) && (coop < 1)))
	{
		self.skin = 0;
		if ((self.objekt != world))
		{
			set_playmodel_special ();
			return;
		}
		setmodel (self, "progs/player1.mdl");
		return;
	}
	self.oldpmodel = self.pmodel;
	num = self.pmodel;
	if ((num == 5))
	{
		self.skin = 0;
		setmodel (self, "progs/player1.mdl");
		return;
	}
	if (((num < 0) || (num > 5)))
	{
		num = 0;
	}
	self.skin = num;
	setmodel (self, "progs/player2.mdl");
};

void () display_dm3outcome =
{
	if ((deathmatch != 3))
	{
		return;
	}
	bprint ("DEATHMATCH 3 SCORES\n");
	bprint ("###################\n");
	bprint ("Marines       ");
	bprint (ftos (tscore0));
	bprint ("\n");
	bprint ("Grunts        ");
	bprint (ftos (tscore1));
	bprint ("\n");
	bprint ("Lab Guys      ");
	bprint (ftos (tscore2));
	bprint ("\n");
	bprint ("Ogre Mutants  ");
	bprint (ftos (tscore3));
	bprint ("\n");
	bprint ("Bents         ");
	bprint (ftos (tscore4));
	bprint ("\n");
	bprint ("Jacks         ");
	bprint (ftos (tscore5));
	bprint ("\n###################\n");
};

void () set_playmodel_special =
{
	local float num;

	num = self.objekt.pmodel;
	if ((num == 5))
	{
		self.skin = 0;
		setmodel (self, "progs/player1.mdl");
		return;
	}
	if (((num < 0) || (num > 5)))
	{
		num = 0;
	}
	self.skin = num;
	setmodel (self, "progs/player2.mdl");
};
