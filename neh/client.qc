
void (entity mark) ResetEnemies =
{
	local entity head;

	head = findentity (world, enemy, mark);
	while (head)
	{
		if ((head.flags & FL_MONSTER))
		{
			head.enemy = world;
			head.oldenemy = world;
		}
		head = findentity (head, enemy, mark);
	}
};

float (entity Top, entity bottom) IsOnTopOf =
{
//	local string Msg;

	if ((Top.absmin_z < (bottom.absmax_z - 3)))
	{
		return (0);
	}
	if ((Top.absmin_z > (bottom.absmax_z + 2)))
	{
		return (0);
	}
	if ((Top.absmin_y > bottom.absmax_y))
	{
		return (0);
	}
	if ((Top.absmax_y < bottom.absmin_y))
	{
		return (0);
	}
	if ((Top.absmin_x > bottom.absmax_x))
	{
		return (0);
	}
	if ((Top.absmax_x < bottom.absmin_x))
	{
		return (0);
	}
	return (1);
};

void () Client_Ground =
{
//	local string msg;

	if (((other.solid == SOLID_BBOX) || (other.solid == SOLID_SLIDEBOX)))
	{
		if (IsOnTopOf (self, other))
		{
			self.flags = (self.flags | FL_ONGROUND);
		}
	}
};

void () demofunc_getparms =
{
	parm1 = cvar ("nehx01");
	nehx01 = parm1;
	parm2 = cvar ("nehx02");
	nehx02 = parm2;
	parm3 = cvar ("nehx03");
	nehx03 = parm3;
	parm4 = cvar ("nehx04");
	nehx04 = parm4;
	parm5 = cvar ("nehx05");
	nehx05 = parm5;
	parm6 = cvar ("nehx06");
	nehx06 = parm6;
	parm7 = cvar ("nehx07");
	nehx07 = parm7;
	parm8 = cvar ("nehx08");
	nehx08 = parm8;
	parm9 = cvar ("nehx09");
	nehx09 = parm9;
	parm10 = cvar ("nehx10");
	nehx10 = parm10;
	parm11 = cvar ("nehx11");
	nehx11 = parm11;
	parm12 = cvar ("nehx12");
	nehx12 = parm12;
	parm13 = cvar ("nehx13");
	nehx13 = parm13;
	parm14 = cvar ("nehx14");
	nehx14 = parm14;
	cvar_set ("viewsize", ftos (parm13));
	cvar_set ("nehx15", "0");
	nehx15 = 1;
};

void () feedstoredparms =
{
	cvar_set ("nehx01", ftos (nehx01));
	cvar_set ("nehx02", ftos (nehx02));
	cvar_set ("nehx03", ftos (nehx03));
	cvar_set ("nehx04", ftos (nehx04));
	cvar_set ("nehx05", ftos (nehx05));
	cvar_set ("nehx06", ftos (nehx06));
	cvar_set ("nehx07", ftos (nehx07));
	cvar_set ("nehx08", ftos (nehx08));
	cvar_set ("nehx09", ftos (nehx09));
	cvar_set ("nehx10", ftos (nehx10));
	cvar_set ("nehx11", ftos (nehx11));
	cvar_set ("nehx12", ftos (nehx12));
	cvar_set ("nehx13", ftos (nehx13));
	cvar_set ("nehx14", "777");
	cvar_set ("nehx15", "1");
};

void () demofunc_storeparms =
{
	local float num;

	self.items = (self.items - (self.items & (((((IT_KEY1 | IT_KEY2) | IT_INVISIBILITY) | IT_INVULNERABILITY) | IT_SUIT) | IT_QUAD)));
	if ((self.health > 100))
	{
		self.health = 100;
	}
	if ((self.health < 50))
	{
		self.health = 50;
	}
	cvar_set ("nehx01", ftos (self.items));
	cvar_set ("nehx02", ftos (self.health));
	cvar_set ("nehx03", ftos (self.armorvalue));
	if ((self.ammo_shells < 25))
	{
		cvar_set ("nehx04", "25");
	}
	else
	{
		cvar_set ("nehx04", ftos (self.ammo_shells));
	}
	cvar_set ("nehx05", ftos (self.ammo_nails));
	cvar_set ("nehx06", ftos (self.ammo_rockets));
	cvar_set ("nehx07", ftos (self.ammo_cells));
	cvar_set ("nehx08", ftos (self.weapon));
	cvar_set ("nehx09", ftos ((self.armortype * 100)));
	cvar_set ("nehx10", ftos (self.items2));
	cvar_set ("nehx11", ftos (self.lives));
	cvar_set ("nehx12", ftos (self.regen));
	num = cvar ("viewsize");
	cvar_set ("nehx13", ftos (num));
	cvar_set ("nehx14", "777");
	cvar_set ("nehx15", "0");
};

void () SetChangeParms =
{
	if ((self.health <= 0))
	{
		SetNewParms ();
		return;
	}
	self.items = (self.items - (self.items & (((((IT_KEY1 | IT_KEY2) | IT_INVISIBILITY) | IT_INVULNERABILITY) | IT_SUIT) | IT_QUAD)));
	if ((self.health > 100))
	{
		self.health = 100;
	}
	if ((self.health < 50))
	{
		self.health = 50;
	}
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	if ((self.ammo_shells < 25))
	{
		parm4 = 25;
	}
	else
	{
		parm4 = self.ammo_shells;
	}
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
	parm10 = self.items2;
	parm11 = self.lives;
	parm12 = self.regen;
};

void () SetNewParms =
{
	parm1 = IT_SHOTGUN | IT_SWORD;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;
	parm10 = 0;
	parm11 = 1;
	parm12 = 0;
};

void () DecodeLevelParms =
{
	local float num;
	local float t;

	if (!deathmatch)
	{
		if ((world.model == "maps/start.bsp"))
		{
			SetNewParms ();
		}
	}
	if (!deathmatch)
	{
		if (!coop)
		{
			num = cvar ("cutscene");
			if ((num == 1))
			{
				num = cvar ("nehx15");
				if ((num == 1))
				{
					t = cvar ("nehx14");
					if ((t == 777))
					{
						demofunc_getparms ();
						if ((parm2 < 50))
						{
							parm2 = 50;
						}
					}
				}
			}
		}
	}
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = (parm9 * 0.01);
	self.items2 = parm10;
	self.lives = parm11;
	self.regen = parm12;
};

entity () FindIntermission =
{
	local entity spot;
	local float cyc;

	spot = find (world, classname, "info_intermission");
	if (spot)
	{
		cyc = random () * MOVETYPE_STEP;
		while ((cyc > 1))
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
			{
				spot = find (spot, classname, "info_intermission");
			}
			cyc = cyc - 1;
		}
		return (spot);
	}
	spot = find (world, classname, "info_player_start");
	if (spot)
	{
		return (spot);
	}
	spot = find (world, classname, "testplayerstart");
	if (spot)
	{
		return (spot);
	}
	objerror ("FindIntermission: no spot");

	return world;
};

void () GotoNextMap =
{
	local float num;

	num = cvar ("cutscene");
	if ((num == 1))
	{
		if (self.demo)
		{
			if ((world.model == "maps/nehstart.bsp"))
			{
				stuffcmd (self, "nehx15 1\n");
			}
			stuffcmd (self, "r_oldsky 0\n");
			stuffcmd (self, "playdemo ");
			stuffcmd (self, self.demo);
			stuffcmd (self, "\n");
			return;
		}
	}
	if (cvar ("samelevel"))
	{
		changelevel (mapname);
	}
	else
	{
		changelevel (nextmap);
	}
};

void () ExitIntermission =
{
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;
	if ((intermission_running == FL_SWIM))
	{
		if ((world.model == "maps/e1m7.bsp"))
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, FL_SWIM);
			WriteByte (MSG_ALL, MOVETYPE_WALK);
			if (!cvar ("registered"))
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in...");
			}
			else
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A...");
			}
			return;
		}
		else
		{
			if ((world.model == "maps/e2m6.bsp"))
			{
				WriteByte (MSG_ALL, SVC_CDTRACK);
				WriteByte (MSG_ALL, FL_SWIM);
				WriteByte (MSG_ALL, MOVETYPE_WALK);
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death...");
				return;
			}
			else
			{
				if ((world.model == "maps/e3m6.bsp"))
				{
					WriteByte (MSG_ALL, SVC_CDTRACK);
					WriteByte (MSG_ALL, FL_SWIM);
					WriteByte (MSG_ALL, MOVETYPE_WALK);
					WriteByte (MSG_ALL, SVC_FINALE);
					WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your ...");
					return;
				}
				else
				{
					if ((world.model == "maps/e4m7.bsp"))
					{
						WriteByte (MSG_ALL, SVC_CDTRACK);
						WriteByte (MSG_ALL, FL_SWIM);
						WriteByte (MSG_ALL, MOVETYPE_WALK);
						WriteByte (MSG_ALL, SVC_FINALE);
						WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being...");
						return;
					}
					else
					{
						if ((world.model == "maps/nehend.bsp"))
						{
							WriteByte (MSG_ALL, SVC_CDTRACK);
							WriteByte (MSG_ALL, FL_SWIM);
							WriteByte (MSG_ALL, MOVETYPE_WALK);
							WriteByte (MSG_ALL, SVC_FINALE);
							WriteString (MSG_ALL, "Wrung from the blood of a thousand\ndamned, the blood of Max seeps into the\ncold metal floor of his otherworld\narena and the spirits of the innumerable\nslip away from his lifeless hands.\nTheir liberated voices echo off the once\ndispassionate indu...");
							return;
						}
						else
						{
							if ((world.model == "maps/nehahra.bsp"))
							{
								WriteByte (MSG_ALL, SVC_CDTRACK);
								WriteByte (MSG_ALL, FL_SWIM);
								WriteByte (MSG_ALL, MOVETYPE_WALK);
								WriteByte (MSG_ALL, SVC_FINALE);
								WriteString (MSG_ALL, "Paralyzed, courage lost to quicksand\nand senses deafened by the roar of \nthe daemonic tornado, your heart  \nscreams with rage, your lungs labor \nfor air, as your hands wildly dance,\ngroping for the nothing.  Leaping,\nfalling, flying madly throug...");
								return;
							}
							else
							{
								if ((world.model == "maps/neh1m3.bsp"))
								{
									WriteByte (MSG_ALL, SVC_CDTRACK);
									WriteByte (MSG_ALL, FL_SWIM);
									WriteByte (MSG_ALL, MOVETYPE_WALK);
									WriteByte (MSG_ALL, SVC_FINALE);
									WriteString (MSG_ALL, "Odds weigh against you but luck is\non your side. Free from the death\nenveloping Forge City, you have only a\nquestion mark lingering in the air\nto look forward to.  Not knowing what to\nexpect, not knowing where you're going\nor how to get there, y...");
									return;
								}
								else
								{
									if ((world.model == "maps/neh1m9.bsp"))
									{
										WriteByte (MSG_ALL, SVC_CDTRACK);
										WriteByte (MSG_ALL, FL_SWIM);
										WriteByte (MSG_ALL, MOVETYPE_WALK);
										WriteByte (MSG_ALL, SVC_FINALE);
										WriteString (MSG_ALL, "The battle cries of the vile Vores\nand the strange utterances of the\nbizarre race of Tsemoch echo through\nyour thoughts.  Amazed you survived this\nlong, you leave the last threads of\nhuman civilization behind and boldly\nventure into the alien ou...");
										return;
									}
									else
									{
										if ((world.model == "maps/neh3m4.bsp"))
										{
											WriteByte (MSG_ALL, SVC_CDTRACK);
											WriteByte (MSG_ALL, FL_SWIM);
											WriteByte (MSG_ALL, MOVETYPE_WALK);
											WriteByte (MSG_ALL, SVC_FINALE);
											WriteString (MSG_ALL, "The bitter taste of adrenaline lingers\non your lips like Stygian wine and the\nblood staining your hands feels no\nless cold than your own that rushes\nthrough your veins and hammers your\nears long after the warped Archgaunt\nfell.  You shudder from...");
											return;
										}
										else
										{
											if ((world.model == "maps/alk10d.bsp"))
											{
												WriteByte (MSG_ALL, SVC_CDTRACK);
												WriteByte (MSG_ALL, FL_SWIM);
												WriteByte (MSG_ALL, MOVETYPE_WALK);
												WriteByte (MSG_ALL, SVC_FINALE);
												WriteString (MSG_ALL, "You've stumbled through underground\ncaverns of mud and pools of thick blood\nfrom hundreds of slaughtered beasts.\nEventually you found your way to the \ndecaying stronghold of Shub-Niggurath's\nmini-army.  With your bloody rocket\nlauncher stolen fr...");
												return;
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		GotoNextMap ();
	}
	if ((intermission_running == MOVETYPE_WALK))
	{
		if (!cvar ("registered"))
		{
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		if (((serverflags & 15) == 15))
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront he...");
			return;
		}
	}
	GotoNextMap ();
};

void () IntermissionThink =
{
	local float num;

	if ((time < intermission_exittime))
	{
		return;
	}
	if (((!self.button0 && !self.button1) && !self.button2))
	{
		return;
	}
	if (!deathmatch)
	{
		if (!coop)
		{
			num = cvar ("cutscene");
			if ((num == 1))
			{
				if (self.demo)
				{
					demofunc_storeparms ();
				}
			}
		}
	}
	ExitIntermission ();
};

void () execute_changelevel =
{
	local entity pos;

	display_dm3outcome ();
	intermission_running = 1;
	if (deathmatch)
	{
		intermission_exittime = time + MOVETYPE_FLY;
	}
	else
	{
		intermission_exittime = time + FL_SWIM;
	}
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, MOVETYPE_WALK);
	WriteByte (MSG_ALL, MOVETYPE_WALK);
	pos = FindIntermission ();
	other = find (world, classname, "player");
	while ((other != world))
	{
		stuffcmd (other, "stopmod\n");
		other.view_ofs = VEC_ORIGIN;
		other.v_angle = pos.mangle;
		other.angles = pos.mangle;
		other.fixangle = 1;
		other.nextthink = (time + 0.5);
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
	}
	WriteByte (MSG_ALL, SVC_INTERMISSION);
};

void () changelevel_touch =
{
//	local entity pos;

	if ((other.classname != "player"))
	{
		return;
	}
	if (self.noise)
	{
		stuffcmd (other, "play2 ");
		stuffcmd (other, self.noise);
		stuffcmd (other, "\n");
	}
	if (cvar ("noexit"))
	{
		T_Damage (other, self, self, 50000);
		return;
	}
	bprint (other.netname);
	bprint (" exited the level\n");
	ResetEnemies (other);
	if (!coop)
	{
		if (!deathmatch)
		{
			if (self.demo)
			{
				other.demo = self.demo;
			}
		}
	}
	nextmap = self.map;
	SUB_UseTargets ();
	if (((self.spawnflags & 1) && (deathmatch == 0)))
	{
		GotoNextMap ();
		return;
	}
	self.touch = SUB_Null;
	self.think = execute_changelevel;
	self.nextthink = (time + 0.1);
};

void () trigger_changelevel =
{
	if ((world.model == "maps/neh1m3.bsp"))
	{
		self.noise = "cuts1/opening.wav";
	}
	if ((world.model == "maps/neh2m6.bsp"))
	{
		self.noise = "cuts1/opening.wav";
	}
	if ((world.model == "maps/nehstart.bsp"))
	{
		self.demo = "gamedem1";
	}
	if ((world.model == "maps/neh1m6.bsp"))
	{
		self.demo = "gamedem4";
	}
	if ((world.model == "maps/neh1m9.bsp"))
	{
		self.demo = "gamedem5";
		self.noise = "cuts1/opening.wav";
	}
	if ((world.model == "maps/neh2m4.bsp"))
	{
		self.demo = "gamedem6";
	}
	if ((world.model == "maps/neh2m6.bsp"))
	{
		self.demo = "gamedem7";
	}
	if ((world.model == "maps/nehend.bsp"))
	{
		self.demo = "gameend";
	}
	if (!self.map)
	{
		objerror ("changelevel trigger doesn't have map");
	}
	InitTrigger ();
	self.touch = changelevel_touch;
};

void () respawn =
{
	if (coop)
	{
		CopyToBodyQue (self);
		setspawnparms (self);
		PutClientInServer ();
	}
	else
	{
		if (deathmatch)
		{
			CopyToBodyQue (self);
			SetNewParms ();
			PutClientInServer ();
		}
		else
		{
			localcmd ("stopmod\n");
			if ((nehx15 == 1))
			{
				nehx13 = cvar ("viewsize");
				feedstoredparms ();
			}
			localcmd ("restart\n");
		}
	}
};

void () ClientKill =
{
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame ();
	self.angles_x = 0;
	self.angles_z = 0;
	self.modelindex = self.modelindex_player;
	self.frags = (self.frags - FL_SWIM);
	dm3_adjustscores (self, -2);
	respawn ();
};

float (vector v) CheckSpawnPoint =
{
	return (0);
};

entity () SelectSpawnPoint =
{
	local entity spot;

	spot = find (world, classname, "testplayerstart");
	if (spot)
	{
		return (spot);
	}
	if (((coop || (self.classname != "player")) || (deathmatch == 5)))
	{
		lastspawn = find (lastspawn, classname, "info_player_coop");
		if ((lastspawn == world))
		{
			lastspawn = find (lastspawn, classname, "info_player_start");
		}
		if ((lastspawn != world))
		{
			return (lastspawn);
		}
	}
	else
	{
		if (deathmatch)
		{
			lastspawn = find (lastspawn, classname, "info_player_deathmatch");
			if ((lastspawn == world))
			{
				lastspawn = find (lastspawn, classname, "info_player_deathmatch");
			}
			if ((lastspawn != world))
			{
				return (lastspawn);
			}
		}
	}
	if (serverflags)
	{
		spot = find (world, classname, "info_player_start2");
		if (spot)
		{
			return (spot);
		}
	}
	spot = find (world, classname, "info_player_start");
	if (!spot)
	{
		error ("PutClientInServer: no info_player_start on level");
	}
	return (spot);
};

void () PutClientInServer =
{
	local entity spot;

	self.skin = 0;
	self.oldpmodel = self.pmodel;
	self.classname = "player";
	self.targetname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = (time + 12);
	self.dmg = FL_SWIM;
	self.burn_burning = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.fly_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.fly_time = 0;
	DecodeLevelParms ();
	W_SetCurrentAmmo ();
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = 0;
	spot = SelectSpawnPoint ();
	if ((spot.forcemodel > 0))
	{
		self.objekt = spot;
	}
	self.soul = "yes";
	self.origin = (spot.origin + '0 0 1');
	self.angles = spot.angles;
	self.fixangle = 1;
	setmodel (self, "progs/s_null.spr");
	self.model = "";
	modelindex_eyes = self.modelindex;
	select_pmodel ();
	self.modelindex_player = self.modelindex;
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';
	self.touch = Client_Ground;
	cvar_set ("sv_aim", "1.0");
	nospr32 = cvar ("nospr32");
	panzy_mode = cvar ("nomonsters");
	player_stand1 ();
	if ((deathmatch || coop))
	{
		makevectors (self.angles);
		spawn_tfog ((self.origin + (v_forward * 20)));
		if ((coop && (world.model == "maps/nehend.bsp")))
		{
			self.impulse = 0;
			self.attack_finished = (time + 0.5);
			Deathmatch5 ();
		}
		if ((deathmatch == 5))
		{
			self.impulse = 0;
			self.attack_finished = (time + 0.5);
			Deathmatch5 ();
		}
	}
	spawn_tdeath (self.origin, self);
	client_cvarpimp ();
};

void () info_player_start =
{
	self.event = "spawn_point";
	if ((world.model == "maps/nehend.bsp"))
	{
		if (deathmatch)
		{
			deathmatch_nehend ();
			return;
		}
		precache_mr ();
		spawn_mister ();
	}
};

void () deathmatch_nehend =
{
	local entity head;

	head = find (world, targetname, "deadmax");
	if ((head != world))
	{
		remove (head);
	}
};

void () info_player_start2 =
{
	self.event = "spawn_point";
};

void () testplayerstart =
{
};

void () info_player_deathmatch =
{
	if ((deathmatch == 5))
	{
		self.classname = "info_player_coop";
	}
	self.event = "spawn_point";
};

void () old_deathmatch =
{
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.model = "";
	self.origin = (self.origin + '0 0 27');
};

void () info_player_coop =
{
	self.event = "spawn_point";
};

void (entity c) PrintClientScore =
{
	if (((c.frags > -10) && (c.frags < 0)))
	{
		bprint (" ");
	}
	else
	{
		if ((c.frags >= 0))
		{
			if ((c.frags < 100))
			{
				bprint (" ");
			}
			if ((c.frags < MOVETYPE_BOUNCE))
			{
				bprint (" ");
			}
		}
	}
	bprint (ftos (c.frags));
	bprint (" ");
	bprint (c.netname);
	bprint ("\n");
};

void () DumpScore =
{
	local entity e;
	local entity sort;
	local entity walk;

	if (world.chain)
	{
		error ("DumpScore: world.chain is set");
	}
	e = find (world, classname, "player");
	sort = world;
	while (e)
	{
		if (!sort)
		{
			sort = e;
			e.chain = world;
		}
		else
		{
			if ((e.frags > sort.frags))
			{
				e.chain = sort;
				sort = e;
			}
			else
			{
				walk = sort;
				do
				{
					if (!walk.chain)
					{
						e.chain = world;
						walk.chain = e;
					}
					else
					{
						if ((walk.chain.frags < e.frags))
						{
							e.chain = walk.chain;
							walk.chain = e;
						}
						else
						{
							walk = walk.chain;
						}
					}

				} while ((walk.chain != e));
			}
		}
		e = find (e, classname, "player");
	}
	bprint ("\n");
	while (sort)
	{
		PrintClientScore (sort);
		sort = sort.chain;
	}
	bprint ("\n");
};

void () NextLevel =
{
	local entity o;

	o = find (world, classname, "trigger_changelevel");
	if ((!o || (mapname == "start")))
	{
		o = spawn ();
		o.map = mapname;
	}
	nextmap = o.map;
	if ((o.nextthink < time))
	{
		o.think = execute_changelevel;
		o.nextthink = (time + 0.1);
	}
};

void () CheckRules =
{
	local float timelimit;
	local float fraglimit;

	if (gameover)
	{
		return;
	}
	timelimit = cvar ("timelimit") * 60;
	fraglimit = cvar ("fraglimit");
	if ((timelimit && (time >= timelimit)))
	{
		NextLevel ();
		return;
	}
	if ((fraglimit && (self.frags >= fraglimit)))
	{
		NextLevel ();
		return;
	}
};

void () PlayerRiseFromDead =
{
	self.alpha = 0;
	self.effects = (self.effects - (self.effects & EF_DIMLIGHT));
	self.items = (self.items - (self.items & (((IT_INVISIBILITY | IT_INVULNERABILITY) | IT_SUIT) | IT_QUAD)));
	self.super_damage_finished = 0;
	self.super_time = 0;
	self.fly_finished = 0;
	self.invincible_time = 1;
	self.invincible_finished = (time + 3.5);
	self.items = (self.items | IT_INVULNERABILITY);
	self.effects = (self.effects - (self.effects & EF_RED));
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.deadflag = DEAD_NO;
	self.air_finished = (time + 12);
	self.dmg = FL_SWIM;
	self.boost = 0;
	self.origin = (self.origin + '0 0 1');
	self.fixangle = 1;
	self.view_ofs = '0 0 22';
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.fly_finished = 0;
	self.fly_time = 0;
	self.touch = Client_Ground;
	self.effects = 0;
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = 0;
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	W_SetCurrentAmmo ();
	W_BestWeapon ();
	PlayerPreThink ();
};

void () SpawnLifeGiver =
{
	local entity life;

	self.effects = (self.effects | EF_RED);
	self.alpha = 0.5;
	sound (self, CHAN_WEAPON, "player/dedrise.wav", 1, ATTN_NORM);
	life = spawn ();
	life.origin = self.origin;
	life.classname = "lifegiver";
	life.owner = self;
	self.health = 0;
	life.effects = EF_DIMLIGHT;
	life.cnt = -8;
	life.method = 91;
	life.brain = 0;
	life.think = raise_the_client;
	life.nextthink = (time + 0.3);
	PlayerDeathThink ();
};

void () raise_the_client =
{
	local entity dead;
//	local float damg;
	local float num;
//	local float t;

	dead = self.owner;
	if ((dead.lives == -1))
	{
		dead.health = 0;
		remove (self);
		return;
	}
	dead.view_ofs_z = self.cnt;
	num = 23 - dead.view_ofs_z;
	dead.health = 1;
	if ((dead.view_ofs_z < 23))
	{
		self.method = (self.method - 1);
		self.brain = (self.brain + 1);
		if ((self.brain > 3))
		{
			self.brain = 0;
			dead.view_ofs_z = (dead.view_ofs_z + 1);
		}
		self.cnt = dead.view_ofs_z;
	}
	if (((self.cnt == 20) && (pointcontents (self.origin) == CONTENT_WATER)))
	{
		sound (self, CHAN_BODY, "player/razh20.wav", 1, ATTN_NORM);
	}
	if ((self.cnt == 12))
	{
		sound (self, CHAN_VOICE, "player/razd1.wav", 1, ATTN_NORM);
	}
	if (((self.cnt == 9) || (self.cnt == 13)))
	{
		sound (self, CHAN_WEAPON, "player/dedrise.wav", 1, ATTN_NORM);
	}
	if ((self.cnt == 18))
	{
		sound (self, CHAN_AUTO, "player/razd2.wav", 1, ATTN_NORM);
	}
	if ((random () < 0.5))
	{
		stuffcmd (dead, "bf\n");
	}
	msg_entity = dead;
	WriteByte (1, 10);
	WriteAngle (1, dead.v_angle_x);
	WriteAngle (1, dead.v_angle_y);
	WriteAngle (1, self.method);
	self.nextthink = (time + 0.05);
	self.think = raise_the_client;
};

void () PlayerDeathThink =
{
//	local entity old_self;
	local float forward;
	local entity head;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if ((forward <= 0))
		{
			self.velocity = VEC_ORIGIN;
		}
		else
		{
			self.velocity = (forward * normalize (self.velocity));
		}
	}
	if ((self.deadflag == DEAD_DEAD))
	{
		if (((self.button2 || self.button1) || self.button0))
		{
			return;
		}
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}
	if ((self.view_ofs_z > 22))
	{
		PlayerRiseFromDead ();
		head = find (world, classname, "lifegiver");
		while (head)
		{
			if ((head.owner == self))
			{
				remove (head);
			}
			head = find (head, classname, "lifegiver");
		}
		return;
	}
	head = find (world, classname, "lifegiver");
	if ((head != world))
	{
		return;
	}
	if (((!self.button2 && !self.button1) && !self.button0))
	{
		return;
	}
	erase_deadstate ();
	if ((self.lives > 1))
	{
		SpawnLifeGiver ();
		kill_deathspirits ();
		self.lives = (self.lives - 1);
		return;
	}
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn ();
};

void () erase_deadstate =
{
	msg_entity = self;
	self.dlmp = 0;
	WriteByte (MSG_ONE, SVC_HIDELMP);
	WriteString (MSG_ONE, "deadstate");
};

void () PlayerJump =
{
//	local vector start;
//	local vector end;

	if ((self.flags & FL_WATERJUMP))
	{
		return;
	}
	if ((self.waterlevel >= FL_SWIM))
	{
		if ((self.watertype == CONTENT_WATER))
		{
			self.velocity_z = 100;
		}
		else
		{
			if ((self.watertype == CONTENT_SLIME))
			{
				self.velocity_z = 80;
			}
			else
			{
				self.velocity_z = 50;
			}
		}
		if ((self.swim_flag < time))
		{
			self.swim_flag = (time + 1);
			if ((random () < 0.5))
			{
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			}
			else
			{
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
			}
		}
		return;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		return;
	}
	if (!(self.flags & FL_JUMPRELEASED))
	{
		return;
	}
	self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
	self.flags = (self.flags - FL_ONGROUND);
	if (!self.fly_finished)
	{
		self.button2 = 0;
		sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	}
	self.velocity_z = (self.velocity_z + 270);
};

void () WaterMove =
{
	if ((self.movetype == MOVETYPE_NOCLIP))
	{
		return;
	}
	if ((self.health < 0))
	{
		return;
	}
	if ((self.waterlevel != MOVETYPE_WALK))
	{
		if ((self.air_finished < time))
		{
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		}
		else
		{
			if ((self.air_finished < (time + MOVETYPE_FLYMISSILE)))
			{
				sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
			}
		}
		self.air_finished = (time + 12);
		self.dmg = FL_SWIM;
	}
	else
	{
		if ((self.air_finished < time))
		{
			if ((self.pain_finished < time))
			{
				self.dmg = (self.dmg + FL_SWIM);
				if ((self.dmg > 15))
				{
					self.dmg = MOVETYPE_BOUNCE;
				}
				self.deathtype = "drowning";
				T_Damage (self, world, world, self.dmg);
				self.pain_finished = (time + 1);
			}
		}
	}
	if (!self.waterlevel)
	{
		if ((self.flags & FL_INWATER))
		{
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = (self.flags - FL_INWATER);
		}
		return;
	}
	if ((self.watertype == CONTENT_LAVA))
	{
		if ((self.dmgtime < time))
		{
			if ((self.radsuit_finished > time))
			{
				self.dmgtime = (time + 1);
			}
			else
			{
				self.dmgtime = (time + 0.2);
			}
			T_Damage (self, world, world, (MOVETYPE_BOUNCE * self.waterlevel));
		}
	}
	else
	{
		if ((self.watertype == CONTENT_SLIME))
		{
			if (((self.dmgtime < time) && (self.radsuit_finished < time)))
			{
				self.dmgtime = (time + 1);
				T_Damage (self, world, world, (MOVETYPE_STEP * self.waterlevel));
			}
		}
	}
	if (!(self.flags & FL_INWATER))
	{
		if ((self.watertype == CONTENT_LAVA))
		{
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		}
		if ((self.watertype == CONTENT_WATER))
		{
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		}
		if ((self.watertype == CONTENT_SLIME))
		{
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);
		}
		self.flags = (self.flags + FL_INWATER);
		self.dmgtime = 0;
	}
	if (!(self.flags & FL_WATERJUMP))
	{
		self.velocity = (self.velocity - (((0.8 * self.waterlevel) * frametime) * self.velocity));
	}
};

void () CheckWaterJump =
{
	local vector start;
	local vector end;

	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + FL_CLIENT;
	v_forward_z = 0;
	normalize (v_forward);
	end = start + (v_forward * 24);
	traceline (start, end, 1, self);
	if ((trace_fraction < 1))
	{
		start_z = (start_z + self.maxs_z) - FL_CLIENT;
		end = start + (v_forward * 24);
		self.movedir = (trace_plane_normal * -50);
		traceline (start, end, 1, self);
		if ((trace_fraction == 1))
		{
			self.flags = (self.flags | FL_WATERJUMP);
			self.velocity_z = 225;
			self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
			self.teleport_time = (time + FL_SWIM);
			return;
		}
	}
};

void () PlayerPreThink =
{
//	local float mspeed;
//	local float aspeed;
//	local float r;
//	local entity goback;

	if (intermission_running)
	{
		IntermissionThink ();
		return;
	}
	if ((self.view_ofs == VEC_ORIGIN))
	{
		if (((self.script_count < self.script_delay) && (self.script_time < time)))
		{
			Script_play ();
		}
		return;
	}
	makevectors (self.v_angle);

	self.deathtype = "";

	CheckRules ();
	if ((self.deadflag >= DEAD_DEAD))
	{
		PlayerDeathThink ();
		return;
	}
	WaterMove ();
	if ((self.waterlevel == FL_SWIM))
	{
		CheckWaterJump ();
	}
	if ((self.deadflag == DEAD_DYING))
	{
		return;
	}
	if (self.button2)
	{
		PlayerJump ();
	}
	else
	{
		self.flags = (self.flags | FL_JUMPRELEASED);
	}
	if ((time < self.pausetime))
	{
		self.velocity = VEC_ORIGIN;
	}
	if ((((time > self.attack_finished) && (self.currentammo == 0)) && (self.weapon != IT_SWORD)))
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
	if ((self.regen > 0))
	{
		if (((self.health > 0) && (self.health < 1)))
		{
			self.health = 1;
		}
		if (((self.health < self.regen) && (self.health >= 1)))
		{
			self.health = (self.health + ((self.regen * 0.05) * frametime));
			return;
		}
	}
};

void () ShakePlayer =
{
	local float num;

	if ((self.flags & FL_FLEE))
	{
		if (!(self.flags & FL_ONGROUND))
		{
			if ((self.jump_flag > -505))
			{
				self.velocity = (self.velocity - (random () * '0 0 70'));
			}
		}
		else
		{
			self.velocity = (self.velocity + (random () * '0 0 75'));
		}
		num = 2;
		if (((world.model == "maps/hehend.bsp") && (hknight_type == 666)))
		{
			num = 5;
		}
		else
		{
			if ((random () < 0.5))
			{
				self.view_ofs_x = num;
			}
			else
			{
				self.view_ofs_x = (num * -1);
			}
			if ((random () < 0.5))
			{
				self.view_ofs_y = num;
			}
			else
			{
				self.view_ofs_y = (num * -1);
			}
			if ((random () < 0.5))
			{
				self.view_ofs_z = (22 + num);
			}
			else
			{
				self.view_ofs_z = (22 - num);
			}
		}
	}
	else
	{
		if ((self.view_ofs != '0 0 22'))
		{
			self.view_ofs = '0 0 22';
		}
		if ((self.v_angle_z != 0))
		{
			msg_entity = self;
			WriteByte (1, 10);
			WriteAngle (1, self.v_angle_x);
			WriteAngle (1, self.v_angle_y);
			WriteAngle (1, 0);
			self.v_angle_z = 0;
		}
	}
};

void () FlyJump =
{
//	local vector start;
//	local vector end;

	self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
	self.velocity_x = (self.velocity_x * 1.01);
	self.velocity_y = (self.velocity_y * 1.01);
	if ((self.velocity_z < 300))
	{
		self.velocity_z = (self.velocity_z + 80);
	}
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
	}
	if ((self.fly_sound < time))
	{
		self.fly_sound = (time + 0.8);
		sound (self, CHAN_AUTO, "player/flight.wav", 1, ATTN_NORM);
	}
};

void () CheckPowerups =
{
	if ((self.health <= 0))
	{
		return;
	}
	if (self.invisible_finished)
	{
		if ((self.invisible_sound < time))
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = (time + ((random () * MOVETYPE_WALK) + 1));
		}
		if ((self.invisible_finished < (time + MOVETYPE_WALK)))
		{
			if ((self.invisible_time == 1))
			{
				sprint (self, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = (time + 1);
			}
			if ((self.invisible_time < time))
			{
				self.invisible_time = (time + 1);
				stuffcmd (self, "bf\n");
			}
		}
		if ((self.invisible_finished < time))
		{
			self.items = (self.items - IT_INVISIBILITY);
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
	{
		self.modelindex = self.modelindex_player;
	}
	if (self.invincible_finished)
	{
		if ((self.invincible_finished < (time + MOVETYPE_WALK)))
		{
			if ((self.invincible_time == 1))
			{
				sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = (time + 1);
			}
			if ((self.invincible_time < time))
			{
				self.invincible_time = (time + 1);
				stuffcmd (self, "bf\n");
			}
		}
		if ((self.invincible_finished < time))
		{
			self.items = (self.items - IT_INVULNERABILITY);
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if ((self.invincible_finished > time))
		{
			self.effects = (self.effects | EF_DIMLIGHT);
		}
		else
		{
			self.effects = (self.effects - (self.effects & EF_DIMLIGHT));
		}
	}
	if (self.super_damage_finished)
	{
		if ((self.super_damage_finished < (time + MOVETYPE_WALK)))
		{
			if ((self.super_time == 1))
			{
				sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = (time + 1);
			}
			if ((self.super_time < time))
			{
				self.super_time = (time + 1);
				stuffcmd (self, "bf\n");
			}
		}
		if ((self.super_damage_finished < time))
		{
			self.items = (self.items - IT_QUAD);
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if ((self.super_damage_finished > time))
		{
			self.effects = (self.effects | EF_DIMLIGHT);
		}
		else
		{
			self.effects = (self.effects - (self.effects & EF_DIMLIGHT));
		}
	}
	if (self.radsuit_finished)
	{
		self.air_finished = (time + 12);
		if ((self.radsuit_finished < (time + MOVETYPE_WALK)))
		{
			if ((self.rad_time == 1))
			{
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = (time + 1);
			}
			if ((self.rad_time < time))
			{
				self.rad_time = (time + 1);
				stuffcmd (self, "bf\n");
			}
		}
		if ((self.radsuit_finished < time))
		{
			self.items = (self.items - IT_SUIT);
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}
	if (self.fly_finished)
	{
		if ((self.fly_finished < (time + MOVETYPE_WALK)))
		{
			if ((self.fly_time == 1))
			{
				sprint (self, "Fly time almost gone\n");
				stuffcmd (self, "bf\n");
				self.fly_time = (time + 1);
			}
			if ((self.fly_time < time))
			{
				self.fly_time = (time + 1);
				stuffcmd (self, "bf\n");
			}
		}
		if ((self.fly_finished < time))
		{
			self.fly_finished = 0;
			self.fly_time = 0;
		}
	}
};

void () PlayerPostThink =
{
//	local float mspeed;
//	local float aspeed;
//	local float r;
	local float num;

	if ((self.view_ofs == VEC_ORIGIN))
	{
		return;
	}
	if ((deathmatch || coop))
	{
		if (PmodelChanged ())
		{
			return;
		}
	}
	if (self.deadflag)
	{
		return;
	}
	if ((time > self.attack_finished))
	{
		self.event = "";
	}
	W_WeaponFrame ();
	if ((((self.jump_flag < -300) && (self.flags & FL_ONGROUND)) && (self.health > 0)))
	{
		if ((self.watertype == CONTENT_WATER))
		{
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		}
		else
		{
			if ((self.jump_flag < -630))
			{
				num = rint (((self.jump_flag + 600) * -0.1));
				self.deathtype = "falling";
				T_Damage (self, world, world, num);
				sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			}
			else
			{
				sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
			}
		}
		self.jump_flag = 0;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		self.jump_flag = self.velocity_z;
	}
	if ((self.fly_finished || (deathmatch == 4)))
	{
		if (self.button2)
		{
			FlyJump ();
		}
	}
	CheckPowerups ();
	ShakePlayer ();
	self.movedir = self.velocity;
};

void () ClientConnect =
{
	bprint (self.netname);
	bprint (" entered the game\n");
	if (intermission_running)
	{
		ExitIntermission ();
	}
};

void () ClientDisconnect =
{
	if (gameover)
	{
		return;
	}
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos (self.frags));
	bprint (" frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame ();
};

void () kill_deathspirits =
{
	local entity head;

	head = find (world, classname, "deathspirit");
	while (head)
	{
		head.think = SUB_Remove;
		head.nextthink = (time + 0.2);
		head = find (head, classname, "deathspirit");
	}
};

void () spawn_deathspirits =
{
	local entity mark;

	mark = spawn ();
	mark.classname = "deathspirit";
	mark.objekt = self;
	mark.cnt = 0;
	mark.think = deathspirits;
	mark.nextthink = (time + 0.3);
};

void () deathspirits =
{
	if ((self.objekt.dlmp > 0))
	{
		if ((self.objekt.health > 0))
		{
			msg_entity = self.objekt;
			self.objekt.dlmp = 0;
			WriteByte (MSG_ONE, SVC_HIDELMP);
			WriteString (MSG_ONE, "deadstate");
			remove (self);
			return;
		}
	}
	self.cnt = (self.cnt + 1);
	if ((self.cnt > 300))
	{
		remove (self);
		return;
	}
	self.think = deathspirits;
	self.nextthink = (time + 0.3);
};

void (entity targ, entity attacker) ClientObituary =
{
	local float rnum;
	local string deathstring;
	local string deathstring2;

	rnum = random ();
	if ((targ.classname == "player"))
	{
		if ((attacker.classname == "teledeath"))
		{
			bprint (targ.netname);
			bprint (" was telefragged by the evil ");
			bprint (attacker.owner.netname);
			bprint ("\n");
			attacker.owner.frags = (attacker.owner.frags + 1);
			dm3_adjustscores (attacker.owner, 1);
			return;
		}
		if ((attacker.classname == "teledeath2"))
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");
			targ.frags = (targ.frags - 1);
			dm3_adjustscores (targ, -1);
			return;
		}
		if ((attacker.classname == "player"))
		{
			if ((targ == attacker))
			{
				attacker.frags = (attacker.frags - 1);
				dm3_adjustscores (attacker, -1);
				bprint (targ.netname);
				if (((targ.weapon == FL_GODMODE) && (targ.waterlevel > 1)))
				{
					bprint (" discharges into the water.\n");
					return;
				}
				if ((targ.weapon == FL_INWATER))
				{
					bprint (" tries to put the pin back in\n");
					attacker.boost = 1;
				}
				else
				{
					attacker.boost = 2;
					if (rnum)
					{
						bprint (" becomes bored with life\n");
					}
					else
					{
						bprint (" checks if his weapon is loaded\n");
					}
				}
				return;
			}
			else
			{
				attacker.frags = (attacker.frags + 1);
				dm3_adjustscores (attacker, 1);
				rnum = attacker.weapon;
				if ((rnum == IT_SWORD))
				{
					deathstring = " was slashed by ";
					deathstring2 = "\n";
				}
				if ((rnum == IT_SHOTGUN))
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				if ((rnum == IT_SUPER_SHOTGUN))
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				if ((rnum == IT_AUTO_SHOTGUN))
				{
					deathstring = " got hosed down by ";
					deathstring2 = "\n";
				}
				if ((rnum == IT_NAILGUN))
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				if ((rnum == IT_SUPER_NAILGUN))
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				if ((rnum == IT_GRENADE_LAUNCHER))
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if ((targ.health < -40))
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				if ((rnum == IT_ROCKET_LAUNCHER))
				{
					deathstring = " rides ";
					deathstring2 = "'s rocket\n";
					if ((targ.health < -40))
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s rocket\n";
					}
				}
				if ((rnum == IT_LIGHTNING))
				{
					deathstring = " accepts ";
					if ((attacker.waterlevel > 1))
					{
						deathstring2 = "'s discharge\n";
					}
					else
					{
						deathstring2 = "'s shaft\n";
					}
				}
				if ((rnum == IT_SPROCKET))
				{
					deathstring = " rides ";
					deathstring2 = "'s sprocket\n";
					if ((targ.health < -40))
					{
						deathstring = " was sent to hell on ";
						deathstring2 = "'s sprocket\n";
					}
				}
				bprint (targ.netname);
				bprint (deathstring);
				bprint (attacker.netname);
				bprint (deathstring2);
			}
			return;
		}
		else
		{
			targ.frags = (targ.frags - 1);
			dm3_adjustscores (targ, -1);
			rnum = targ.watertype;
			bprint (targ.netname);
			if ((rnum == CONTENT_WATER))
			{
				if ((random () < 0.5))
				{
					bprint (" sleeps with the fishes\n");
				}
				else
				{
					bprint (" sucks it down\n");
					sound (self, CHAN_ITEM, "player/razh20.wav", 1, ATTN_IDLE);
				}
				return;
			}
			else
			{
				if ((rnum == CONTENT_SLIME))
				{
					if ((random () < 0.5))
					{
						bprint (" gulped a load of slime\n");
					}
					else
					{
						bprint (" can't exist on slime alone\n");
					}
					return;
				}
				else
				{
					if ((rnum == CONTENT_LAVA))
					{
						if ((!coop && !deathmatch))
						{
							sound (self, CHAN_AUTO, "ambience/amsizl.wav", 0.2, ATTN_IDLE);
						}
						if ((targ.health < -15))
						{
							bprint (" burst into flames\n");
							return;
						}
						if ((random () < 0.5))
						{
							bprint (" turned into hot slag\n");
						}
						else
						{
							bprint (" visits the Volcano God\n");
						}
						return;
					}
				}
			}
			if ((attacker.flags & FL_MONSTER))
			{
				if ((attacker.classname == "monster_army"))
				{
					bprint (" was shot by a Grunt\n");
				}
				if ((attacker.classname == "monster_army3"))
				{
					bprint (" was nailed by a Grunt\n");
				}
				if ((attacker.classname == "monster_army2"))
				{
					bprint (" was killed by a Grunt\n");
				}
				if ((attacker.classname == "monster_army4"))
				{
					bprint (" was killed by a Grunt\n");
				}
				if ((attacker.classname == "monster_demon1"))
				{
					bprint (" was eviscerated by a Fiend\n");
				}
				if ((attacker.classname == "monster_dog"))
				{
					bprint (" was mauled by a Rottweiler\n");
				}
				if ((attacker.classname == "monster_baron"))
				{
					bprint (" became a Baron's thrill kill\n");
				}
				if ((attacker.classname == "monster_enforcer"))
				{
					bprint (" was blasted by an Enforcer\n");
				}
				if ((attacker.classname == "monster_shalrath"))
				{
					bprint (" was exploded by a Vore\n");
				}
				if ((attacker.classname == "monster_fish"))
				{
					bprint (" was fed to the Rotfish\n");
				}
				if ((attacker.classname == "monster_hell_knight"))
				{
					bprint (" was slain by a Death Knight\n");
				}
				if ((attacker.classname == "monster_beard"))
				{
					bprint (" was slain by Ghoro\n");
				}
				if ((attacker.classname == "monster_knight"))
				{
					bprint (" was slashed by a Knight\n");
				}
				if (((attacker.classname == "monster_ogre") || (attacker.classname == "monster_ogre_marksman")))
				{
					bprint (" was destroyed by an Ogre\n");
				}
				if ((attacker.classname == "monster_jagger"))
				{
					bprint (" was jagged by a Jagger\n");
				}
				if ((attacker.classname == "monster_cook"))
				{
					if ((random () < 0.5))
					{
						bprint (" becomes the cook's next dish\n");
					}
					else
					{
						bprint (" was panned to death\n");
					}
				}
				if ((attacker.classname == "the_mister"))
				{
					if ((random () < 0.5))
					{
						bprint (" got owned by Max\n");
					}
					else
					{
						bprint (" was put to shame by Max\n");
					}
				}
				if ((attacker.classname == "monster_qguy"))
				{
					bprint (" becomes a statistic\n");
				}
				if ((attacker.classname == "monster_shambler"))
				{
					bprint (" was smashed by a Shambler\n");
				}
				if ((attacker.classname == "monster_tarbaby"))
				{
					bprint (" was slimed by a Spawn\n");
				}
				if ((attacker.classname == "monster_vomit"))
				{
					bprint (" was vomited on by a Vomitus\n");
				}
				if ((attacker.classname == "monster_wizard"))
				{
					bprint (" was scragged by a Scrag\n");
				}
				if ((attacker.classname == "monster_zombie"))
				{
					bprint (" joins the Zombies\n");
				}
				if ((attacker.classname == "monster_wraith"))
				{
					bprint (" was killed by a wraith\n");
				}
				if ((attacker.classname == "monster_gaunt"))
				{
					bprint (" was killed by a gaunt\n");
				}
				if ((attacker.classname == "monster_enf2"))
				{
					bprint (" was shot by a field enforcer\n");
				}
				if ((attacker.classname == "monster_enf3"))
				{
					bprint (" was killed by an ogre mutant\n");
				}
				if ((attacker.classname == "monster_library"))
				{
					bprint (" was killed by an Archgaunt librarian\n");
				}
				if ((attacker.classname == "monster_archgaunt"))
				{
					bprint (" was exterminated by an ArchGaunt\n");
				}
				if ((attacker.classname == "monster_oglib\n"))
				{
					bprint (" was killed by a rabid librarian\n");
				}
				if ((attacker.classname == "monster_hunter"))
				{
					bprint (" was taken down by a tsemoch\n");
				}
				if ((attacker.classname == "monster_nehahra"))
				{
					bprint (" was destroyed by Nehahra\n");
				}
				return;
			}
			if ((attacker.classname == "explo_box"))
			{
				bprint (" blew up\n");
				return;
			}
			if ((attacker.deathtype == "hotp"))
			{
				if ((random () < 0.5))
				{
					bprint (" fried on a hot plate\n");
					return;
				}
				bprint (" was fried medium rare\n");
				return;
			}
			if ((attacker.deathtype == "impaled"))
			{
				if ((random () < 0.5))
				{
					bprint (" was impaled\n");
					return;
				}
				bprint (" lies in pieces\n");
				return;
			}
			if ((attacker.deathtype == "diced"))
			{
				if ((random () < 0.5))
				{
					bprint (" goes home in several boxes\n");
					return;
				}
				bprint (" was diced\n");
				return;
			}
			if ((attacker.deathtype == "hod"))
			{
				if ((random () < 0.5))
				{
					bprint (" died at the hands of death\n");
					return;
				}
				bprint (" croaked\n");
				return;
			}
			if ((attacker.deathtype == "hell"))
			{
				if ((random () < 0.5))
				{
					bprint (" takes a permanent vacation in Hell\n");
					return;
				}
				bprint (" went to Hell the fast way down\n");
				return;
			}
			if ((attacker.deathtype == "void"))
			{
				bprint (" fell into the void\n");
				return;
			}
			if ((attacker.deathtype == "swal"))
			{
				if ((random () < 0.5))
				{
					bprint (" was swallowed\n");
					return;
				}
				bprint (" made for a tasty meal\n");
				return;
			}
			if ((attacker.deathtype == "hotm"))
			{
				bprint (" shouldn't have touched the machinery\n");
				return;
			}
			if ((attacker.deathtype == "simple"))
			{
				bprint (" is dead\n");
				return;
			}
			if ((attacker.deathtype == "furn"))
			{
				if ((random () < 0.5))
				{
					bprint (" took a walk in the furnace\n");
					return;
				}
				bprint (" fried in the furnace\n");
				return;
			}
			if (((attacker.solid == SOLID_BSP) && (attacker != world)))
			{
				if ((random () < 0.4))
				{
					bprint (" bought the farm\n");
					return;
				}
				bprint (" was squished\n");
				return;
			}
			if ((targ.deathtype == "falling"))
			{
				targ.boost = 3;
				targ.deathtype = "";
				bprint (" fell to his death\n");
				return;
			}
			if (((attacker.classname == "trap_shooter") || (attacker.classname == "trap_spikeshooter")))
			{
				bprint (" was spiked\n");
				return;
			}
			if ((attacker.classname == "fireball"))
			{
				bprint (" ate a lavaball\n");
				return;
			}
			if ((attacker.classname == "trigger_changelevel"))
			{
				bprint (" tried to leave\n");
				return;
			}
			bprint (" died\n");
		}
	}
};
