
void () player_stand1 = [ 17, player_stand1 ]
{
	self.weaponframe = 0;
	if ((self.velocity_x || self.velocity_y))
	{
		self.walkframe = 0;
		player_run ();
		return;
	}
	if ((self.weapon == IT_SWORD))
	{
		if ((self.walkframe >= 12))
		{
			self.walkframe = 0;
		}
		self.frame = (17 + self.walkframe);
	}
	else
	{
		if ((self.walkframe >= MOVETYPE_FLY))
		{
			self.walkframe = 0;
		}
		self.frame = (12 + self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
};

void () player_run = [ 6, player_run ]
{
	self.weaponframe = 0;
	if ((!self.velocity_x && !self.velocity_y))
	{
		self.walkframe = 0;
		player_stand1 ();
		return;
	}
	if ((self.weapon == IT_SWORD))
	{
		if ((self.walkframe == MOVETYPE_TOSS))
		{
			self.walkframe = 0;
		}
		self.frame = (0 + self.walkframe);
	}
	else
	{
		if ((self.walkframe == MOVETYPE_TOSS))
		{
			self.walkframe = 0;
		}
		self.frame = (self.frame + self.walkframe);
	}

	self.spawnsilent = self.spawnsilent + vlen(self.origin - self.old_velocity);
	self.old_velocity = self.origin;
	if (self.flags & FL_ONGROUND)
	{
		if (self.spawnsilent > 95)
		{
	    		local float r;
	    		if (self.spawnsilent > 190)
	       			self.spawnsilent = 0;
	    		else
	       			self.spawnsilent = 0.5*(self.spawnsilent - 95);
	    		r = random();
			if (r < 0.14)
				sound (self, CHAN_VOICE, "player/foot1.wav", 0.5, ATTN_NORM);
			else if (r < 0.29)
				sound (self, CHAN_VOICE, "player/foot2.wav", 0.5, ATTN_NORM);
			else if (r < 0.43)
				sound (self, CHAN_VOICE, "player/foot3.wav", 0.5, ATTN_NORM);
			else if (r < 0.58)
				sound (self, CHAN_VOICE, "player/foot4.wav", 0.5, ATTN_NORM);
			else if (r < 0.72)
				sound (self, CHAN_VOICE, "player/foot5.wav", 0.5, ATTN_NORM);
			else if (r < 0.86)
				sound (self, CHAN_VOICE, "player/foot6.wav", 0.5, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "player/foot7.wav", 0.5, ATTN_NORM);
		}
	}

	self.walkframe = (self.walkframe + 1);
};

void () player_shot1 =
{
	if ((self.angles_x > 12))
	{
		player3_shotup1 ();
		return;
	}
	if ((self.angles_x < -12))
	{
		player2_shotdown1 ();
		return;
	}
	state [ 113, player_shot2 ];
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_shot2 = [ 114, player_shot3 ]
{
	self.weaponframe = FL_SWIM;
};

void () player_shot3 = [ 115, player_shot4 ]
{
	self.weaponframe = MOVETYPE_WALK;
};

void () player_shot4 = [ 116, player_shot5 ]
{
	self.weaponframe = MOVETYPE_STEP;
};

void () player_shot5 = [ 117, player_shot6 ]
{
	self.weaponframe = MOVETYPE_FLY;
};

void () player_shot6 = [ 118, player_run ]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void () player_axe1 = [ 119, player_axe2 ]
{
	self.weaponframe = 1;
};

void () player_axe2 = [ 120, player_axe3 ]
{
	self.weaponframe = 2;
};

void () player_axe3 = [ 121, player_axe4 ]
{
	self.weaponframe = 3;
	W_FireAxe ();
};

void () player_axe4 = [ 122, player_run ]
{
	self.weaponframe = 4;
};

void () player_axeb1 = [ 123, player_axeb2 ]
{
	self.weaponframe = 5;
};

void () player_axeb2 = [ 124, player_axeb3 ]
{
	self.weaponframe = 6;
};

void () player_axeb3 = [ 125, player_axeb4 ]
{
	self.weaponframe = 7;
	W_FireAxe ();
};

void () player_axeb4 = [ 126, player_run ]
{
	self.weaponframe = 8;
};

void () player_axec1 = [ 127, player_axec2 ]
{
	self.weaponframe = 9;
};

void () player_axec2 = [ 128, player_axec3 ]
{
	self.weaponframe = 10;
};

void () player_axec3 = [ 129, player_axec4 ]
{
	self.weaponframe = 11;
	W_FireAxe ();
};

void () player_axec4 = [ 130, player_run ]
{
	self.weaponframe = 12;
};

void () player_axed1 = [ 131, player_axed2 ]
{
	self.weaponframe = 13;
};

void () player_axed2 = [ 132, player_axed3 ]
{
	self.weaponframe = 14;
};

void () player_axed3 = [ 133, player_axed4 ]
{
	self.weaponframe = 15;
	W_FireAxe ();
};

void () player_axed4 = [ 134, player_run ]
{
	self.weaponframe = 16;
};

void () player_nail1 =
{
	if ((self.angles_x > 12))
	{
		player3_nail1 ();
		return;
	}
	if ((self.angles_x < -12))
	{
		player2_nail1 ();
		return;
	}
	state [ 103, player_nail2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if (!self.button0)
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLYMISSILE))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (2);
	self.attack_finished = (time + 0.2);
};

void () player_nail2 = [ 104, player_nail1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if (!self.button0)
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLYMISSILE))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (-2);
	self.attack_finished = (time + 0.2);
};

void () player_autos1 =
{
	if ((self.angles_x > 12))
	{
		player3_autos1 ();
		return;
	}
	if ((self.angles_x < -12))
	{
		player2_autos1 ();
		return;
	}
	state [ 103, player_autos2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_shells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == 18))
	{
		self.weaponframe = 0;
	}
	SuperDamageSound ();
	W_FireAutoShotgun ();
	self.attack_finished = (time + 0.2);
};

void () player_autos2 = [ 104, player_autos1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_shells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == 18))
	{
		self.weaponframe = 0;
	}
	SuperDamageSound ();
	W_FireAutoShotgun ();
	self.attack_finished = (time + 0.2);
};

void () player_light1 =
{
	if ((self.angles_x > 12))
	{
		player3_light1 ();
		return;
	}
	if ((self.angles_x < -12))
	{
		player2_light1 ();
		return;
	}
	state [ 105, player_light2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_cells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLY))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	self.attack_finished = (time + 0.2);
};

void () player_light2 = [ 106, player_light1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_cells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLY))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	self.attack_finished = (time + 0.2);
};

void () player_rocket1 =
{
	if ((self.angles_x > 12))
	{
		player3_rocket1 ();
		return;
	}
	if ((self.angles_x < -12))
	{
		player2_rocket1 ();
		return;
	}
	state [ 107, player_rocket2 ];
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_rocket2 = [ 108, player_rocket3 ]
{
	self.weaponframe = FL_SWIM;
};

void () player_rocket3 = [ 109, player_rocket4 ]
{
	self.weaponframe = MOVETYPE_WALK;
};

void () player_rocket4 = [ 110, player_rocket5 ]
{
	self.weaponframe = MOVETYPE_STEP;
};

void () player_rocket5 = [ 111, player_rocket6 ]
{
	self.weaponframe = MOVETYPE_FLY;
};

void () player_rocket6 = [ 112, player_run ]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void () PainSound =
{
	local float rs;

	if ((self.health < 0))
	{
		return;
	}
	if ((damage_attacker.classname == "teledeath"))
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (((self.watertype == CONTENT_WATER) && (self.waterlevel == MOVETYPE_WALK)))
	{
		DeathBubbles (1);
		if ((random () > 0.5))
		{
			sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		}
		return;
	}
	if ((self.watertype == CONTENT_SLIME))
	{
		if (self.waterlevel == 3)
			DeathBubbles(1);

		if ((random () > 0.5))
		{
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		}
		return;
	}
	if ((self.watertype == CONTENT_LAVA))
	{
		if ((random () > 0.5))
		{
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		}
		return;
	}
	if (self.burn_burning)
	{
		BurnPainSound ();
		return;
	}
	if ((self.pain_finished > time))
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = (time + 0.5);
	if ((self.axhitme == 1))
	{
		self.axhitme = 0;
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}
	rs = rint (((random () * MOVETYPE_FLY) + 1));
	self.noise = "";
	if ((rs == 1))
	{
		self.noise = "player/pain1.wav";
	}
	else
	{
		if ((rs == FL_SWIM))
		{
			self.noise = "player/pain2.wav";
		}
		else
		{
			if ((rs == MOVETYPE_WALK))
			{
				self.noise = "player/pain3.wav";
			}
			else
			{
				if ((rs == MOVETYPE_STEP))
				{
					self.noise = "player/pain4.wav";
				}
				else
				{
					if ((rs == MOVETYPE_FLY))
					{
						self.noise = "player/pain5.wav";
					}
					else
					{
						self.noise = "player/pain6.wav";
					}
				}
			}
		}
	}
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void () player_pain1 = [ 35, player_pain2 ]
{
	PainSound ();
	self.weaponframe = 0;
};

void () player_pain2 = [ 36, player_pain3 ]
{
};

void () player_pain3 = [ 37, player_pain4 ]
{
};

void () player_pain4 = [ 38, player_pain5 ]
{
};

void () player_pain5 = [ 39, player_pain6 ]
{
};

void () player_pain6 = [ 40, player_run ]
{
};

void () player_axpain1 = [ 29, player_axpain2 ]
{
	PainSound ();
	self.weaponframe = 0;
};

void () player_axpain2 = [ 30, player_axpain3 ]
{
};

void () player_axpain3 = [ 31, player_axpain4 ]
{
};

void () player_axpain4 = [ 32, player_axpain5 ]
{
};

void () player_axpain5 = [ 33, player_axpain6 ]
{
};

void () player_axpain6 = [ 34, player_run ]
{
};

void () player_pain =
{
	if (self.weaponframe)
	{
		return;
	}
	if ((self.invisible_finished > time))
	{
		return;
	}
	if ((self.weapon == IT_SWORD))
	{
		player_axpain1 ();
	}
	else
	{
		player_pain1 ();
	}
};

void () DeathBubblesSpawn =
{
	local entity bubble;

	if ((self.owner.waterlevel != 3) && (self.owner.health > 0))
	{
		remove(self);	// remove bubble spawner
		return;
	}

	bubble = spawn ();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, (self.owner.origin + '0 0 24'));
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = (time + 0.5);
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = (time + 0.01);
	self.think = DeathBubblesSpawn;
	self.air_finished = (self.air_finished + 1);
	if ((self.air_finished >= self.bubble_count))
	{
		remove (self);
	}
};

void (float num_bubbles) DeathBubbles =
{
	local entity bubble_spawner;

	bubble_spawner = spawn ();
	setorigin (bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = (time + 0.01);
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};

void () DeathSound =
{
	local float rs;

	if ((self.waterlevel == MOVETYPE_WALK))
	{
		DeathBubbles (20);
		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
		return;
	}
	rs = rint (((random () * MOVETYPE_STEP) + 1));
	if ((rs == 1))
	{
		self.noise = "player/death1.wav";
	}
	if ((rs == FL_SWIM))
	{
		self.noise = "player/death2.wav";
	}
	if ((rs == MOVETYPE_WALK))
	{
		self.noise = "player/death3.wav";
	}
	if ((rs == MOVETYPE_STEP))
	{
		self.noise = "player/death4.wav";
	}
	if ((rs == MOVETYPE_FLY))
	{
		self.noise = "player/death5.wav";
	}
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};

void () PlayerDead =
{
	self.nextthink = CONTENT_EMPTY;
	self.deadflag = DEAD_DEAD;
};

vector (float dm) VelocityForDamage =
{
	local vector v;

	v_x = 100 * crandom ();
	v_y = 100 * crandom ();
	v_z = 200 + (100 * random ());
	if ((dm > -50))
	{
		v = v * 0.7;
	}
	else
	{
		if ((dm > -200))
		{
			v = v * FL_SWIM;
		}
		else
		{
			v = v * MOVETYPE_BOUNCE;
		}
	}
	return (v);
};

void (string gibname, float dm) ThrowGib =
{
	local entity new;

	new = spawn ();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, VEC_ORIGIN, VEC_ORIGIN);
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = (random () * 600);
	new.avelocity_y = (random () * 600);
	new.avelocity_z = (random () * 600);
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = ((time + MOVETYPE_BOUNCE) + (random () * MOVETYPE_BOUNCE));
	new.frame = 0;
	new.flags = 0;
};

void (string gibname, float dm) ThrowHead =
{
	self.skin = 0;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_pain = SUB_Null;
	self.th_die = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_runfire = SUB_Null;
	self.use = SUB_Null;
	setmodel (self, gibname);
	self.frame = 0;
	self.nextthink = (time + 30);
	self.think = corpse_think;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage (dm);
	self.origin_z = (self.origin_z - 24);
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.avelocity = (crandom () * '0 600 0');
};

void () GibPlayer =
{
	erase_deadstate ();
	kill_deathspirits ();
	self.lives = 0;
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SHOWLMP);
	WriteString (MSG_ONE, "deadstate");
	WriteString (MSG_ONE, "gfx/it/res2.lmp");
	WriteByte (MSG_ONE, 10);
	WriteByte (MSG_ONE, 10);

	if (deathmatch)
		ThrowHead ("progs/h_player.mdl", self.health);
	else
		ThrowHead ("progs/h_jack.mdl", self.health);

	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	self.deadflag = DEAD_DEAD;
	if ((damage_attacker.classname == "teledeath"))
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if ((damage_attacker.classname == "teledeath2"))
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if ((random () < 0.5))
	{
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	}
	else
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	}
};

void () PlayerDie =
{
	local float i;

	if ((self.lives == 1))
	{
		self.lives = 0;
		msg_entity = self;
		WriteByte (MSG_ONE, SVC_SHOWLMP);
		WriteString (MSG_ONE, "deadstate");
		WriteString (MSG_ONE, "gfx/it/res3.lmp");
		WriteByte (MSG_ONE, 10);
		WriteByte (MSG_ONE, 10);
	}
	else
	{
		msg_entity = self;
		WriteByte (MSG_ONE, SVC_SHOWLMP);
		WriteString (MSG_ONE, "deadstate");
		WriteString (MSG_ONE, "gfx/it/res1.lmp");
		WriteByte (MSG_ONE, 10);
		WriteByte (MSG_ONE, 10);
	}
	kill_deathspirits ();
	self.dlmp = 1;
	spawn_deathspirits ();
	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.items = self.items - (self.items & IT_INVULNERABILITY);
	self.items = self.items - (self.items & IT_QUAD);
	self.items = self.items - (self.items & IT_SUIT);

	self.effects = self.effects - (self.effects & EF_DIMLIGHT);

	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;

	self.attack_finished = (time + 1);
	self.modelindex = self.modelindex_player;
	if ((deathmatch || coop))
	{
		if (((self.health > -41) && (self.lives == 0)))
		{
			DropBackpack ();
		}
	}
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	if ((self.lives < 1))
	{
		self.solid = SOLID_NOT;
	}
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.movetype = MOVETYPE_TOSS;
	if ((self.velocity_z < MOVETYPE_BOUNCE))
	{
		self.velocity_z = (self.velocity_z + (random () * 300));
	}
	if ((self.health < -40))
	{
		GibPlayer ();
		DropBackpack ();
		return;
	}
	DeathSound ();
	self.angles_x = 0;
	self.angles_z = 0;
	if (self.burn_burning)
	{
		player_dieb1 ();
		return;
	}
	if ((self.weapon == IT_SWORD))
	{
		player_die_ax1 ();
		return;
	}
	i = cvar ("temp1");
	if (!i)
	{
		i = 1 + floor ((random () * MOVETYPE_TOSS));
	}
	if ((i == 1))
	{
		player_diea1 ();
	}
	else
	{
		if ((i == FL_SWIM))
		{
			player_dieb1 ();
		}
		else
		{
			if ((i == MOVETYPE_WALK))
			{
				player_diec1 ();
			}
			else
			{
				if ((i == MOVETYPE_STEP))
				{
					player_died1 ();
				}
				else
				{
					player_diee1 ();
				}
			}
		}
	}
};

void () set_suicide_frame =
{
	if ((self.model == "progs/vplayer2.mdl"))
	{
		return;
	}
	self.frame = 60;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = CONTENT_EMPTY;
};

void () player_diea1 = [ 50, player_diea2 ]
{
};

void () player_diea2 = [ 51, player_diea3 ]
{
};

void () player_diea3 = [ 52, player_diea4 ]
{
};

void () player_diea4 = [ 53, player_diea5 ]
{
};

void () player_diea5 = [ 54, player_diea6 ]
{
};

void () player_diea6 = [ 55, player_diea7 ]
{
};

void () player_diea7 = [ 56, player_diea8 ]
{
};

void () player_diea8 = [ 57, player_diea9 ]
{
};

void () player_diea9 = [ 58, player_diea10 ]
{
};

void () player_diea10 = [ 59, player_diea11 ]
{
};

void () player_diea11 =
{
	self.angles_x = 0;
	self.angles_z = 0;
	state [ 60, player_diea11 ];
	if ((self.classname == "player"))
	{
		PlayerDead ();
	}
};

void () player_dieb1 = [ 61, player_dieb2 ]
{
};

void () player_dieb2 = [ 62, player_dieb3 ]
{
};

void () player_dieb3 = [ 63, player_dieb4 ]
{
};

void () player_dieb4 = [ 64, player_dieb5 ]
{
};

void () player_dieb5 = [ 65, player_dieb6 ]
{
};

void () player_dieb6 = [ 66, player_dieb7 ]
{
};

void () player_dieb7 = [ 67, player_dieb8 ]
{
};

void () player_dieb8 = [ 68, player_dieb9 ]
{
};

void () player_dieb9 =
{
	self.angles_x = 0;
	self.angles_z = 0;
	state [ 69, player_dieb9 ];
	if ((self.classname == "player"))
	{
		PlayerDead ();
	}
};

void () player_diec1 = [ 70, player_diec2 ]
{
};

void () player_diec2 = [ 71, player_diec3 ]
{
};

void () player_diec3 = [ 72, player_diec4 ]
{
};

void () player_diec4 = [ 73, player_diec5 ]
{
};

void () player_diec5 = [ 74, player_diec6 ]
{
};

void () player_diec6 = [ 75, player_diec7 ]
{
};

void () player_diec7 = [ 76, player_diec8 ]
{
};

void () player_diec8 = [ 77, player_diec9 ]
{
};

void () player_diec9 = [ 78, player_diec10 ]
{
};

void () player_diec10 = [ 79, player_diec11 ]
{
};

void () player_diec11 = [ 80, player_diec12 ]
{
};

void () player_diec12 = [ 81, player_diec13 ]
{
};

void () player_diec13 = [ 82, player_diec14 ]
{
};

void () player_diec14 = [ 83, player_diec15 ]
{
};

void () player_diec15 =
{
	self.angles_x = 0;
	self.angles_z = 0;
	state [ 84, player_diec15 ];
	if ((self.classname == "player"))
	{
		PlayerDead ();
	}
};

void () player_died1 = [ 85, player_died2 ]
{
};

void () player_died2 = [ 86, player_died3 ]
{
};

void () player_died3 = [ 87, player_died4 ]
{
};

void () player_died4 = [ 88, player_died5 ]
{
};

void () player_died5 = [ 89, player_died6 ]
{
};

void () player_died6 = [ 90, player_died7 ]
{
};

void () player_died7 = [ 91, player_died8 ]
{
};

void () player_died8 = [ 92, player_died9 ]
{
};

void () player_died9 =
{
	self.angles_x = 0;
	self.angles_z = 0;
	state [ 93, player_died9 ];
	if ((self.classname == "player"))
	{
		PlayerDead ();
	}
};

void () player_diee1 = [ 94, player_diee2 ]
{
};

void () player_diee2 = [ 95, player_diee3 ]
{
};

void () player_diee3 = [ 96, player_diee4 ]
{
};

void () player_diee4 = [ 97, player_diee5 ]
{
};

void () player_diee5 = [ 98, player_diee6 ]
{
};

void () player_diee6 = [ 99, player_diee7 ]
{
};

void () player_diee7 = [ 100, player_diee8 ]
{
};

void () player_diee8 = [ 101, player_diee9 ]
{
};

void () player_diee9 =
{
	self.angles_x = 0;
	self.angles_z = 0;
	state [ 102, player_diee9 ];
	if ((self.classname == "player"))
	{
		PlayerDead ();
	}
};

void () player_die_ax1 = [ 41, player_die_ax2 ]
{
};

void () player_die_ax2 = [ 42, player_die_ax3 ]
{
};

void () player_die_ax3 = [ 43, player_die_ax4 ]
{
};

void () player_die_ax4 = [ 44, player_die_ax5 ]
{
};

void () player_die_ax5 = [ 45, player_die_ax6 ]
{
};

void () player_die_ax6 = [ 46, player_die_ax7 ]
{
};

void () player_die_ax7 = [ 47, player_die_ax8 ]
{
};

void () player_die_ax8 = [ 48, player_die_ax9 ]
{
};

void () player_die_ax9 = [ 49, player_die_ax9 ]
{
	PlayerDead ();
};

void () player2_shotdown1 = [ 146, player2_shotdown2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player2_shotdown2 = [ 147, player2_shotdown3 ]
{
	self.weaponframe = FL_SWIM;
};

void () player2_shotdown3 = [ 148, player2_shotdown4 ]
{
	self.weaponframe = MOVETYPE_WALK;
};

void () player2_shotdown4 = [ 149, player2_shotdown5 ]
{
	self.weaponframe = MOVETYPE_STEP;
};

void () player2_shotdown5 = [ 150, player2_shotdown6 ]
{
	self.weaponframe = MOVETYPE_FLY;
};

void () player2_shotdown6 = [ 151, player_run ]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void () player2_nail1 =
{
	if ((self.angles_x > -5))
	{
		player_nail1 ();
		return;
	}
	state [ 135, player2_nail2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if (!self.button0)
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLYMISSILE))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (MOVETYPE_STEP);
	self.attack_finished = (time + 0.2);
};

void () player2_nail2 = [ 136, player2_nail1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if (!self.button0)
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLYMISSILE))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (CONTENT_SLIME);
	self.attack_finished = (time + 0.2);
};

void () player2_autos1 =
{
	if ((self.angles_x > -5))
	{
		player_autos1 ();
		return;
	}
	state [ 135, player2_autos2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_shells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == 17))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireAutoShotgun ();
	self.attack_finished = (time + 0.2);
};

void () player2_autos2 = [ 136, player2_autos1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_shells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == 17))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireAutoShotgun ();
	self.attack_finished = (time + 0.2);
};

void () player2_light1 =
{
	if ((self.angles_x > -5))
	{
		player_light1 ();
		return;
	}
	state [ 137, player2_light2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_cells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLY))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	self.attack_finished = (time + 0.2);
};

void () player2_light2 = [ 138, player2_light1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_cells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLY))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	self.attack_finished = (time + 0.2);
};

void () player2_rocket1 = [ 139, player2_rocket2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player2_rocket2 = [ 140, player2_rocket3 ]
{
	self.weaponframe = FL_SWIM;
};

void () player2_rocket3 = [ 141, player2_rocket4 ]
{
	self.weaponframe = MOVETYPE_WALK;
};

void () player2_rocket4 = [ 142, player2_rocket5 ]
{
	self.weaponframe = MOVETYPE_STEP;
};

void () player2_rocket5 = [ 143, player2_rocket6 ]
{
	self.weaponframe = MOVETYPE_FLY;
};

void () player2_rocket6 = [ 144, player_run ]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void () player3_shotup1 = [ 162, player3_shotup2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player3_shotup2 = [ 163, player3_shotup3 ]
{
	self.weaponframe = FL_SWIM;
};

void () player3_shotup3 = [ 164, player3_shotup4 ]
{
	self.weaponframe = MOVETYPE_WALK;
};

void () player3_shotup4 = [ 165, player3_shotup5 ]
{
	self.weaponframe = MOVETYPE_STEP;
};

void () player3_shotup5 = [ 166, player3_shotup6 ]
{
	self.weaponframe = MOVETYPE_FLY;
};

void () player3_shotup6 = [ 167, player_run ]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void () player3_nail1 =
{
	if ((self.angles_x < 7))
	{
		player_nail1 ();
		return;
	}
	state [ 152, player3_nail2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if (!self.button0)
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLYMISSILE))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (MOVETYPE_STEP);
	self.attack_finished = (time + 0.2);
};

void () player3_nail2 = [ 153, player3_nail1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if (!self.button0)
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLYMISSILE))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (CONTENT_SLIME);
	self.attack_finished = (time + 0.2);
};

void () player3_autos1 =
{
	if ((self.angles_x < 7))
	{
		player_autos1 ();
		return;
	}
	state [ 152, player3_autos2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_shells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == 17))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireAutoShotgun ();
	self.attack_finished = (time + 0.2);
};

void () player3_autos2 = [ 153, player3_autos1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_shells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == 17))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireAutoShotgun ();
	self.attack_finished = (time + 0.2);
};

void () player3_light1 =
{
	if ((self.angles_x < 7))
	{
		player_light1 ();
		return;
	}
	state [ 154, player3_light2 ];
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_cells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLY))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	self.attack_finished = (time + 0.2);
};

void () player3_light2 = [ 155, player3_light1 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_cells < 1)))
	{
		player_run ();
		return;
	}
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weaponframe == MOVETYPE_FLY))
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	self.attack_finished = (time + 0.2);
};

void () player3_rocket1 = [ 156, player3_rocket2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player3_rocket2 = [ 157, player3_rocket3 ]
{
	self.weaponframe = FL_SWIM;
};

void () player3_rocket3 = [ 158, player3_rocket4 ]
{
	self.weaponframe = MOVETYPE_WALK;
};

void () player3_rocket4 = [ 159, player3_rocket5 ]
{
	self.weaponframe = MOVETYPE_STEP;
};

void () player3_rocket5 = [ 160, player3_rocket6 ]
{
	self.weaponframe = MOVETYPE_FLY;
};

void () player3_rocket6 = [ 161, player_run ]
{
	self.weaponframe = MOVETYPE_TOSS;
};
