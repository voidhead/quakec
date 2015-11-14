float (float v) anglemod =
{
	while ((v >= 360))
	{
		v = v - 360;
	}
	while ((v < 0))
	{
		v = v + 360;
	}
	return (v);
};

void () movetarget_f =
{
	if (!self.targetname)
	{
		objerror ("monster_movetarget: no targetname");
	}
	self.solid = SOLID_TRIGGER;
	setsize (self, '-8 -8 -8', '8 8 8');
	if (self.event)
	{
		self.touch = ex_movetarget;
		return;
	}
	if ((self.delay == -1))
	{
		self.touch = x_movetarget;
		return;
	}
	self.touch = t_movetarget;
};

void () x_movetarget =
{
	local entity temp;

	if ((other.movetarget != self))
	{
		return;
	}
	if (other.enemy)
	{
		return;
	}
	temp = self;
	self = other;
	other = temp;
	self.movetarget = world;
	self.goalentity = world;
	self.pausetime = (time + 999999);
	self.th_stand ();
	return;
};

void () ex_movetarget =
{
	local entity temp;

	if ((other.movetarget != self))
	{
		return;
	}
	if (other.enemy)
	{
		return;
	}
	temp = self;
	self = other;
	other = temp;
	self.movetarget = find (world, targetname, other.target);
	self.goalentity = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
	self.enemy = find (world, targetname, temp.event);
	if ((self.enemy != world))
	{
		self.th_run ();
	}
	else
	{
		if (!self.movetarget)
		{
			self.pausetime = (time + 999999);
			self.th_stand ();
			return;
		}
	}
};

void () path_corner =
{
	movetarget_f ();
};

void () t_movetarget =
{
	local entity temp;

	if ((other.movetarget != self))
	{
		return;
	}
	if (other.enemy)
	{
		return;
	}
	temp = self;
	self = other;
	other = temp;
	if ((self.classname == "monster_ogre"))
	{
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);
	}
	if (other.target2)
	{
		if ((random () < 0.4))
		{
			self.movetarget = find (world, targetname, other.target2);
			self.goalentity = find (world, targetname, other.target2);
		}
		else
		{
			self.movetarget = find (world, targetname, other.target);
			self.goalentity = find (world, targetname, other.target);
		}
	}
	else
	{
		self.movetarget = find (world, targetname, other.target);
		self.goalentity = find (world, targetname, other.target);
	}
	self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
	if (!self.movetarget)
	{
		self.pausetime = (time + 999999);
		self.th_stand ();
		return;
	}
};

float (entity targ) range =
{
	local vector spot1;
	local vector spot2;
	local float r;

	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	r = vlen ((spot1 - spot2));
	if ((r < 120))
	{
		return (RANGE_MELEE);
	}
	if ((r < 500))
	{
		return (RANGE_NEAR);
	}
	if ((r < 1000))
	{
		return (RANGE_MID);
	}
	return (RANGE_FAR);
};

float (entity targ) visible =
{
	local vector spot1;
	local vector spot2;

	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
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

float (entity targ) infront =
{
	local vector vec;
	local float dot;

	makevectors (self.angles);
	vec = normalize ((targ.origin - self.origin));
	dot = vec * v_forward;
	if ((dot > 0.3))
	{
		return (1);
	}
	return (0);
};

void () HuntTarget =
{
	if ((self.health < 1))
	{
		return;
	}
	self.goalentity = self.enemy;
	self.think = self.th_run;
	if ((self.flags & FL_FLEE))
	{
		self.ideal_yaw = vectoyaw ((self.origin - self.enemy.origin));
	}
	else
	{
		self.ideal_yaw = vectoyaw ((self.enemy.origin - self.origin));
	}
	self.nextthink = (time + 0.1);
	SUB_AttackFinished (1);
};

void () SightSound =
{
	local float rsnd;

	if ((self.classname == "monster_nehahra"))
	{
		sound (self, CHAN_BODY, "boss3/neh3.wav", 1, ATTN_NONE);
		return;
	}
	if ((self.classname == "monster_enf3"))
	{
		enf3_sightsound ();
		return;
	}
	if ((self.classname == "monster_beard"))
	{
		sound (self, CHAN_VOICE, "ghoro/laugh.wav", 1, ATTN_NORM);
		return;
	}
	if ((self.classname == "monster_ogre"))
	{
		sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM);
	}
	else
	{
		if ((self.classname == "monster_knight"))
		{
			sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
		}
		else
		{
			if ((self.classname == "monster_shambler"))
			{
				sound (self, CHAN_VOICE, "shambler/ssight.wav", 1, ATTN_NORM);
			}
			else
			{
				if ((self.classname == "monster_demon1"))
				{
					sound (self, CHAN_VOICE, "demon/sight2.wav", 1, ATTN_NORM);
				}
				else
				{
					if ((self.classname == "monster_wizard"))
					{
						sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
					}
					else
					{
						if ((self.classname == "monster_zombie"))
						{
							sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM);
						}
						else
						{
							if ((self.classname == "monster_dog"))
							{
								sound (self, CHAN_VOICE, "dog/dsight.wav", 1, ATTN_NORM);
							}
							else
							{
								if ((self.classname == "monster_hell_knight"))
								{
									sound (self, CHAN_VOICE, "hknight/sight1.wav", 1, ATTN_NORM);
								}
								else
								{
									if ((self.classname == "monster_tarbaby"))
									{
										sound (self, CHAN_VOICE, "blob/sight1.wav", 1, ATTN_NORM);
									}
									else
									{
										if ((self.classname == "monster_vomit"))
										{
											sound (self, CHAN_VOICE, "vomitus/v_sight1.wav", 1, ATTN_NORM);
										}
										else
										{
											if ((self.classname == "monster_enforcer"))
											{
												rsnd = rint ((random () * MOVETYPE_WALK));
												if ((rsnd == 1))
												{
													sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM);
												}
												else
												{
													if ((rsnd == FL_SWIM))
													{
														sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, ATTN_NORM);
													}
													else
													{
														if ((rsnd == 0))
														{
															sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
														}
														else
														{
															sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, ATTN_NORM);
														}
													}
												}
											}
											else
											{
												if ((self.classname == "monster_army"))
												{
													sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
												}
												else
												{
													if ((self.classname == "monster_shalrath"))
													{
														sound (self, CHAN_VOICE, "shalrath/sight.wav", 1, ATTN_NORM);
													}
													else
													{
														if ((self.classname == "monster_enf2"))
														{
															enf2_sightsound ();
															return;
														}
														else
														{
															if ((self.classname == "monster_baron"))
															{
																sound (self, CHAN_VOICE, "baron/sight.wav", 1, ATTN_NORM);
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
					}
				}
			}
		}
	}
};

void () FoundTarget =
{
	if ((self.health < 1))
	{
		return;
	}
	if ((self.enemy.health < 1))
	{
		return;
	}
	if ((self.enemy.classname == "player"))
	{
		sight_entity = self;
		sight_entity_time = time;
	}
	self.show_hostile = (time + 1);
	SightSound ();
	HuntTarget ();
};

float () FindTarget =
{
	local entity client;
	local float r;

	if ((self.health < 1))
	{
		return FALSE;
	}
	if ((self.enemy.health < 1))
	{
		self.enemy = world;
	}
	if (((self.relations > 1) && (random () < 0.2)))
	{
		ai_protectclient ();
		return (0);
	}
	if (((sight_entity_time >= (time - 0.1)) && !(self.spawnflags & MOVETYPE_WALK)))
	{
		client = sight_entity;
		if ((client.enemy == self.enemy))
		{
			return TRUE;
		}
	}
	else
	{
		client = checkclient ();
		if (!client)
		{
			return (0);
		}
	}
	if ((client == self.enemy))
	{
		return (0);
	}
	if ((client.flags & FL_NOTARGET))
	{
		return (0);
	}
	if ((client.items & IT_INVISIBILITY))
	{
		return (0);
	}
	if (((self.relations > 0) && (self.relations < 3)))
	{
		return (0);
	}
	r = range (client);
	if ((r == RANGE_FAR))
	{
		return (0);
	}
	if (!visible (client))
	{
		return (0);
	}
	if ((r == RANGE_NEAR))
	{
		if (((client.show_hostile < time) && !infront (client)))
		{
			return (0);
		}
	}
	else
	{
		if ((r == RANGE_MID))
		{
			if (!infront (client))
			{
				return (0);
			}
		}
	}
	if (((self.relations > 2) && (client.classname == "player")))
	{
		self.objekt = client;
		self.goalentity = client;
		if (self.th_greet)
		{
			self.th_greet ();
			self.th_greet = SUB_Null;
		}
		return (0);
	}
	if ((client.view_ofs_z < 22))
	{
		return (0);
	}
	self.enemy = client;
	if (((self.enemy.classname != "player") && (self.relations < 2)))
	{
		self.enemy = self.enemy.enemy;
		if ((self.enemy.classname != "player"))
		{
			self.enemy = world;
			return (0);
		}
	}
	FoundTarget ();
	return (1);
};

void (float dist) ai_forward =
{
	walkmove (self.angles_y, dist);
};

void (float dist) ai_back =
{
	if ((walkmove ((self.angles_y + 180), dist) == FALSE))
	{
		ai_ledgejump ((self.angles + '0 180 0'), 1);
		ai_run_slide ((dist * 0.75));
	}
};

void (float dist) ai_pain =
{
	ai_back (dist);
};

void (float dist) ai_painforward =
{
	walkmove (self.ideal_yaw, dist);
};

void (float dist) ai_walk =
{
//	local vector mtemp;

	movedist = dist;
	if (FindTarget ())
	{
		return;
	}
	if (self.objekt)
	{
		if (ai_objekt ())
		{
			self.th_stand ();
			return;
		}
	}
	if (!(self.spawnflags & FL_MONSTER))
	{
		if (ai_threatproxim ())
		{
			return;
		}
	}
	movetogoal (dist);
};

void () ai_stand =
{
	if (FindTarget ())
	{
		return;
	}
	if (self.objekt)
	{
		ai_face_objekt ();
		if (ai_objekt ())
		{
			return;
		}
		self.th_walk ();
		return;
	}
	if (!(self.spawnflags & FL_MONSTER))
	{
		if (ai_threatproxim ())
		{
			return;
		}
	}
	if ((time < self.pausetime))
	{
		return;
	}
	self.th_walk ();
};

float () ai_objekt =
{
	local vector megadeth;

	if (((self.objekt.health < 1) && (self.classname != "monster_hunter")))
	{
		self.objekt = world;
		self.goalentity = world;
		self.th_stand ();
		return (0);
	}
	megadeth = self.objekt.origin - self.origin;
	if ((vlen (megadeth) < 100))
	{
		self.goalentity = world;
		return (1);
	}
	else
	{
		self.goalentity = self.objekt;
		return (0);
	}
};

void () ai_turn =
{
	if (FindTarget ())
	{
		return;
	}
	ChangeYaw ();
};

void (vector dest3) ChooseTurn =
{
	local vector dir;
	local vector newdir;

	dir = self.origin - dest3;
	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	if (((dir * newdir) > 0))
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}
	dir_z = 0;
	self.ideal_yaw = vectoyaw (dir);
};

float () FacingIdeal =
{
	local float delta;

	delta = anglemod ((self.angles_y - self.ideal_yaw));
	if (((delta > 45) && (delta < 315)))
	{
		return (0);
	}
	return (1);
};

void () CheckAnyAttack =
{
	if (!enemy_vis)
	{
		return FALSE;
	}
	if ((self.classname == "monster_army"))
	{
		return (SoldierCheckAttack ());
	}
	if (((self.classname == "monster_ogre") || (self.classname == "monster_ogre_marksman")))
	{
		return (OgreCheckAttack ());
	}
	if ((self.classname == "monster_baron"))
	{
		return (OgreCheckAttack ());
	}
	if ((self.classname == "monster_shambler"))
	{
		return (ShamCheckAttack ());
	}
	if ((self.classname == "monster_demon1"))
	{
		return (DemonCheckAttack ());
	}
	if ((self.classname == "monster_dog"))
	{
		return (DogCheckAttack ());
	}
	if ((self.classname == "monster_wizard"))
	{
		return (WizardCheckAttack ());
	}
	if ((self.classname == "monster_jagger"))
	{
		return (JaggerCheckAttack ());
	}
	if ((self.classname == "monster_cook"))
	{
		return (CookCheckAttack ());
	}
	return (CheckAttack ());
};

void () ai_run_melee =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal ())
	{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};

void () ai_run_missile =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal ())
	{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
};

void (float dist) id_run_slide =
{
	if (((self.enemy.angles_y > -30) && (self.enemy.angles_y < 20)))
	{
		walkmove ((self.angles_y + 180), dist);
		return;
	}
	if ((self.enemy.angles_y > 340))
	{
		movetogoal (dist);
	}
};

void (float dist) ai_run_slide =
{
	local float ofs;

	movedist = dist;
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
	{
		ofs = 90;
	}
	else
	{
		ofs = -90;
	}
	if (walkmove ((self.ideal_yaw + ofs), movedist))
	{
		return;
	}
	self.lefty = (1 - self.lefty);
	walkmove ((self.ideal_yaw - ofs), movedist);
	ai_face ();
};

void (float dist) back_ai_run_slide =
{
	local float ofs;

	movedist = dist;
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
	{
		ofs = 90;
	}
	else
	{
		ofs = -90;
	}
	if (walkmove ((self.ideal_yaw + ofs), movedist))
	{
		return;
	}
	self.lefty = (1 - self.lefty);
	walkmove ((self.ideal_yaw - ofs), movedist);
};

void (float dist) ai_run =
{
//	local vector delta;
//	local float axis;
//	local float direct;
//	local float ang_rint;
//	local float ang_floor;
//	local float ang_ceil;
	local entity putz;
//	local entity head;

	if (((self.relations == 4) && (self.enemy.classname == "player")))
	{
		self.enemy = world;
		self.oldenemy = world;
		self.goalentity = world;
		self.th_stand ();
		return;
	}
	movedist = dist;
	self.goalentity = self.enemy;
	if ((self.objekt && !visible (self.enemy)))
	{
		if ((random () < 0.1))
		{
			self.enemy = world;
			self.oldenemy = world;
			self.goalentity = world;
			self.th_stand ();
			return;
		}
	}
	if ((self.enemy.health <= 0))
	{
		putz = self.enemy;
		self.enemy = world;
		self.goalentity = world;
		self.objekt = world;
		self.walkframe = 0;
		if (self.th_wins)
			if ((visible(putz)) && (putz.classname == "player"))
			{
				self.th_wins ();
				return;
			}
		if ((self.oldenemy.health > 0))
		{
			self.enemy = self.oldenemy;
			HuntTarget ();
		}
		else
		{
			if (self.movetarget)
			{
				self.th_walk ();
			}
			else
			{
				self.th_stand ();
			}
			return;
		}
	}
	self.show_hostile = (time + 1);
	enemy_vis = visible (self.enemy);
	if (enemy_vis)
	{
		self.search_time = (time + MOVETYPE_FLY);
	}
	if ((coop && (self.search_time < time)))
	{
		if (FindTarget ())
		{
			return;
		}
	}
	enemy_infront = infront (self.enemy);
	enemy_range = range (self.enemy);
	enemy_yaw = vectoyaw ((self.enemy.origin - self.origin));
	if ((self.attack_state == AS_MISSILE))
	{
		ai_run_missile ();
		return;
	}
	if ((self.attack_state == AS_MELEE))
	{
		ai_run_melee ();
		return;
	}
	if (CheckAnyAttack ())
	{
		return;
	}
	if ((self.attack_state == AS_SLIDING))
	{
		ai_run_slide (dist);
		return;
	}
	if (((self.classname != "monster_cook") && (self.classname != "monster_gaunt")))
	{
		if (ai_checkdist ())
		{
			ai_back (0.1);
			ai_face ();
			return;
		}
	}
	if ((self.brain & BLINK))
	{
		ai4_checkblink ();
	}
	if ((self.brain & NAVLOGIC))
	{
		if (ai4_strategy (dist))
		{
			return;
		}
	}
	movetogoal (dist);
};

void () monster_swim =
{
	local float num;
	local vector start;
	local vector end;
	local entity head;
	local entity head2;
	local float t;
	local float num1;
	local float num2;

	makevectors (self.angles);
	if ((self.flags & FL_SWIM))
	{
		t = self.origin_z - self.enemy.origin_z;
		if ((t > 45))
		{
			t = 45;
		}
		if ((t < -45))
		{
			t = -45;
		}
		num1 = pointcontents (self.origin);
		num2 = pointcontents (self.enemy.origin);
		if ((self.classname != "fish"))
		{
			if ((num1 > CONTENT_WATER))
			{
				self.flags = (self.flags - FL_SWIM);
				self.angles_x = 0;
			}
			else
			{
				if ((num1 == num2))
				{
					self.angles_x = (t * -1);
				}
				else
				{
					if ((num2 > num1))
					{
						self.angles_x = 0;
						self.angles_z = 0;
					}
				}
			}
		}
		if (!walkmove (0, 0))
		{
			head = spawn ();
			head.origin = (self.origin - '0 0 600');
			head.think = SUB_Remove;
			head.nextthink = (time + 0.1);
			head2 = self.enemy;
			self.enemy = head;
			movetogoal (10);
			self.enemy = head2;
			return;
		}
	}
	if (!(self.flags & FL_ONGROUND))
	{
		if ((self.flags & FL_WATERJUMP))
		{
			self.velocity = ((v_forward * 20) + '0 0 300');
			self.flags = (self.flags - FL_WATERJUMP);
		}
		else
		{
			if ((pointcontents ((self.origin - '0 0 50')) < CONTENT_SOLID))
			{
				num = self.velocity_z;
				self.velocity = (v_forward * 20);
				self.velocity_z = (num * 1.1);
			}
		}
	}
	if ((pointcontents (self.origin) < CONTENT_SOLID))
	{
		self.flags = (self.flags | FL_SWIM);
	}
	else
	{
		if ((self.flags & FL_SWIM))
		{
			self.flags = (self.flags - FL_SWIM);
			return;
		}
	}
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
			self.flags = (self.flags - FL_SWIM);
			self.flags = (self.flags | FL_WATERJUMP);
			self.velocity_z = 300;
			self.angles_x = 0;
			self.teleport_time = (time + FL_SWIM);
		}
	}
};

void () old_monster_swim =
{
	local float num;
	local vector start;
	local vector end;
	local entity head;
	local entity head2;
	local float t;

	makevectors (self.angles);
	if ((self.flags & FL_SWIM))
	{
		t = self.origin_z - self.enemy.origin_z;
		if ((t > 45))
		{
			t = 45;
		}
		if ((t < -45))
		{
			t = -45;
		}
		if ((pointcontents (self.origin) == pointcontents (self.enemy.origin)))
		{
			self.angles_x = (t * -1);
		}
		if (!walkmove (0, 0))
		{
			head = spawn ();
			head.origin = (self.origin - '0 0 600');
			head.think = SUB_Remove;
			head.nextthink = (time + 0.1);
			head2 = self.enemy;
			self.enemy = head;
			movetogoal (10);
			self.enemy = head2;
			return;
		}
	}
	if (!(self.flags & FL_ONGROUND))
	{
		if ((self.flags & FL_WATERJUMP))
		{
			self.velocity = ((v_forward * 20) + '0 0 300');
			self.flags = (self.flags - FL_WATERJUMP);
		}
		else
		{
			if ((pointcontents ((self.origin - '0 0 50')) < CONTENT_SOLID))
			{
				num = self.velocity_z;
				self.velocity = (v_forward * 20);
				self.velocity_z = (num * 1.1);
			}
		}
	}
	if ((pointcontents (self.origin) < CONTENT_SOLID))
	{
		self.flags = (self.flags | FL_SWIM);
	}
	else
	{
		if ((self.flags & FL_SWIM))
		{
			self.flags = (self.flags - FL_SWIM);
			return;
		}
	}
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
			self.flags = (self.flags - FL_SWIM);
			self.flags = (self.flags | FL_WATERJUMP);
			self.velocity_z = 300;
			self.angles_x = 0;
			self.teleport_time = (time + FL_SWIM);
		}
	}
	if ((pointcontents (self.enemy.origin) > pointcontents (self.origin)))
	{
		self.angles_x = 0;
		self.angles_z = 0;
	}
};

/*
float () old_ai_protectclient =
{
	local entity mark;
	local entity head;
	local entity selected;

	selected = world;
	head = find (world, classname, "player");

	if ((head == world))
	{
		return (0);
	}

	mark = find (world, enemy, head);
	if ((((mark.health > 0) && (mark != self)) && visible (mark)))
	{
		if ((selected.classname != "player"))
		{
			selected = mark;
		}
	}
	if ((selected != world))
	{
		if (((mark.classname == "monster_qguy") && (mark.classname == self.classname)))
		{
			if ((mark.relations > 0))
			{
				selected = world;
			}
		}
	}
	if ((selected == world))
	{
		return (0);
	}
	else
	{
		self.enemy = selected;
		self.goalentity = selected;
		FoundTarget ();
		return (1);
	}
};
*/

void () ai_protectclient =
{
	local entity head;
	local entity selected;
	local float dist;

	dist = 1000;
	selected = world;
	head = findradius (self.origin, 1000);
	while (head)
	{
		if (visible (head))
		{
			if ((trace_plane_dist < dist))
			{
				if (((head.health > 0) && (head != self)))
				{
					if (((head.relations < 1) || (head.enemy.classname == "player")))
					{
						if ((head.flags & FL_MONSTER))
						{
							selected = head;
							dist = trace_plane_dist;
						}
					}
				}
			}
		}
		head = head.chain;
	}
	if ((((selected == world) || (selected == self.enemy)) || (selected.relations > 2)))
	{
		return;
	}
	else
	{
		self.enemy = selected;
		FoundTarget ();
		HuntTarget ();
		return;
	}
};
