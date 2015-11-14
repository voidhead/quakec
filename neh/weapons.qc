
void () W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");
	precache_sound ("weapons/rocket1i.wav");
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");
	precache_sound ("weapons/ric1.wav");
	precache_sound ("weapons/shotgn3.wav");
	precache_sound ("enforcer/enfstop.wav");
	precache_sound ("weapons/shotdud.wav");
	precache_sound ("weapons/ric2.wav");
	precache_sound ("weapons/ric3.wav");
	precache_sound ("weapons/spike2.wav");
	precache_sound ("weapons/tink1.wav");
	precache_sound ("weapons/grenade.wav");
	precache_sound ("weapons/thump.wav");
	precache_sound ("weapons/shotgn2.wav");
	precache_sound ("weapons/sprocket.wav");
	precache_sound ("boss2/pop2.wav");
	precache_sound ("weapons/bounce.wav");
	precache_sound ("weapons/shotgn2.wav");
};

float () crandom =
{
	return ((FL_SWIM * (random () - 0.5)));
};

void () W_FireAxe =
{
	local vector source;
	local vector org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, (source + (v_forward * FL_GODMODE)), 0, self);
	if ((trace_fraction == 1))
	{
		return;
	}
	org = trace_endpos - (v_forward * MOVETYPE_STEP);
	if (trace_ent.takedamage)
	{
		if ((random () < 0.4))
		{
			if ((trace_ent.flags & FL_MONSTER))
			{
				trace_ent.pain_finished = (time + 1.5);
			}
		}
		trace_ent.axhitme = 1;
		SpawnBlood (org, VEC_ORIGIN, 35);
		T_Damage (trace_ent, self, self, 35);
		if ((trace_ent.flags & FL_BLOODLESS))
		{
			sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		}
	}
	else
	{
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

vector () wall_velocity =
{
	local vector vel;

	vel = normalize (self.velocity);
	vel = normalize (((vel + (v_up * (random () - 0.5))) + (v_right * (random () - 0.5))));
	vel = vel + (FL_SWIM * trace_plane_normal);
	vel = vel * 200;
	return (vel);
};

void (vector org, vector vel) SpawnMeatSpray =
{
	local entity missile;
//	local entity mpuff;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;
	makevectors (self.angles);
	missile.velocity = vel;
	missile.velocity_z = ((missile.velocity_z + 250) + (50 * random ()));
	missile.avelocity = '3000 1000 2000';
	missile.nextthink = (time + 1);
	missile.think = SUB_Remove;
	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, org);
};

void (vector org, vector vel, float damage) SpawnBlood =
{
	if (!(trace_ent.flags & FL_BLOODLESS))
	{
		particle (org, (vel * 0.1), 73, (damage * FL_SWIM));
		return;
	}
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_GUNSHOT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

void (float damage) spawn_touchblood =
{
	local vector vel;

	if (!(trace_ent.flags & FL_BLOODLESS))
	{
		vel = wall_velocity () * 0.2;
		SpawnBlood ((self.origin + (vel * 0.01)), vel, damage);
		return;
	}
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	remove (self);
};

void (vector org, vector vel) SpawnChunk =
{
	particle (org, (vel * 0.02), 0, MOVETYPE_BOUNCE);
};

void() ApplyMultiDamage =
{
   local entity e;
   
   e = nextent(world);
   while (e)
   {
      if (e.multi_damage)
      {
         T_Damage (e, self, self, e.multi_damage);
         e.multi_damage = 0;
      }
      e = nextent(e);
   }
};

void (float damage, vector dir) TraceAttack =
{
	local vector vel;
	local vector org;

	vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
	vel = vel + (FL_SWIM * trace_plane_normal);
	vel = vel * 200;
	org = trace_endpos - (dir * MOVETYPE_STEP);
	if ((self.flags & FL_MONSTER))
	{
		if (((trace_ent.flags & FL_MONSTER) && (trace_ent != self.enemy)))
		{
			return;
		}
	}
	if (trace_ent.takedamage)
	{
		SpawnBlood (org, (vel * 0.2), damage);
		trace_ent.multi_damage = trace_ent.multi_damage + damage;
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

void (float shotcount, vector dir, vector spread) FireBullets =
{
	local vector direction;
	local vector src;

	makevectors (self.v_angle);
	src = self.origin + (v_forward * MOVETYPE_BOUNCE);
	src_z = self.absmin_z + (self.size_z * 0.7);
//	ClearMultiDamage ();
	while ((shotcount > 0))
	{
		direction = (dir + ((crandom () * spread_x) * v_right)) + ((crandom () * spread_y) * v_up);
		traceline (src, (src + (direction * FL_WATERJUMP)), 0, self);
		if (((trace_fraction != 1) && (pointcontents (trace_endpos) != CONTENT_SKY)))
		{
			TraceAttack (4, direction);	//4
		}
		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

void () W_FireAutoShotgun =
{
	local vector dir;
	local entity en;

	sound (self, CHAN_WEAPON, "weapons/autos.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_LAVA;
	self.currentammo = self.ammo_shells = (self.ammo_shells - 1);
	dir = aim (self, 1000000);
	FireBullets (7, dir, '0.1 0.08 0');
//	walkmove ((self.angles_y - 180), 20);
//	if (!(self.flags & FL_ONGROUND))
//	{
		makevectors (self.angles);
		self.velocity = (self.velocity + (v_forward * -100)); 		//-100
//	}
	if ((self.angles_x < -10))
	{
		autosh_physics ();
	}
};

void () autosh_physics =
{
	local vector spot1;

	if ((self.velocity_z < -275))
	{
		self.velocity_z = -275;
	}
	spot1 = self.origin - '0 0 60';
	traceline (self.origin, spot1, 1, self);
	if ((trace_fraction == 1))
	{
		return;
	}
	makevectors (self.angles);
	self.origin_z = (self.origin_z + 1);
	self.velocity = ((v_forward * -150) + '0 0 150');
	if ((self.angles_x < -20))
	{
		self.velocity_z = 300;
	}
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
	}
};

void () W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_shells = (self.ammo_shells - 1);
	dir = aim (self, 100000);
	FireBullets (MOVETYPE_TOSS, dir, '0.04 0.04 0');
};

void () W_FireSuperShotgun =
{
	local vector dir;
	local float num;

	sound (self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SLIME;
	if ((self.ammo_shells == 1))
	{
		num = 1;
	}
	else
	{
		num = 2;
	}
	self.currentammo = self.ammo_shells = (self.ammo_shells - num);
	dir = aim (self, 100000);
	FireBullets (7*num, dir, '0.14 0.08 0');
};

void () T_MissileTouch =
{
	local float damg;

	if ((other == self.owner))
	{
		return;
	}
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if ((self.flags & FL_MONSTER))
	{
		damg = 25 + (random () * 5);
		T_RadiusDamage (self, self.owner, 60, other);
	}
	else
	{
		damg = 100 + (random () * 20);
		T_RadiusDamage (self, self.owner, 120, other);
	}
	if (other.health)
	{
		if ((other.classname == "monster_shambler"))
		{
			damg = damg * 0.5;
		}
		T_Damage (other, self, self.owner, damg);
	}
	self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	if ((random () < 0.4))
	{
		BecomeExplosion ();
	}
	else
	{
		BecomeExplosion3 ();
	}
};

void () W_FireRocket =
{
	local entity missile;
//	local entity mpuff;

	self.currentammo = self.ammo_rockets = (self.ammo_rockets - 1);
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	missile.event = "thrett";
	makevectors (self.v_angle);
	missile.velocity = aim (self, 950);
	missile.velocity = (missile.velocity * 950);
	missile.angles = vectoangles (missile.velocity);
	missile.touch = T_MissileTouch;
	missile.nextthink = (time + MOVETYPE_FLY);
	missile.think = SUB_Remove;
	setmodel (missile, "progs/missile.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, ((self.origin + (v_forward * FL_CLIENT)) + '0 0 16'));
};

void () W_FireLightning =
{
	local vector org;
	local float cells;

	if ((self.ammo_cells < 1))
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	if ((self.waterlevel > 1))
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, (35 * cells), world);
		return;
	}
	if ((self.t_width < time))
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = (time + 0.6);
	}
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_cells = (self.ammo_cells - 1);
	org = self.origin + '0 0 16';
	traceline (org, (org + (v_forward * 600)), 1, self);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	ClientLightningDamage (self.origin, (trace_endpos + (v_forward * MOVETYPE_STEP)), self, SVC_INTERMISSION);
};

void () W_GauntLightning =
{
	local vector org;
	local float cells;

	if ((self.ammo_cells < 1))
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	if ((self.waterlevel > 1))
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, (35 * cells), world);
		return;
	}
	if ((self.t_width < time))
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = (time + 0.6);
	}
	self.punchangle_x = CONTENT_SOLID;
	self.ammo_cells = (self.ammo_cells - 1);
	self.currentammo = (self.ammo_cells - 1);
	org = self.origin + '0 0 16';
	traceline (org, (org + (v_forward * 600)), 1, self);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING3);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	ClientLightningDamage (self.origin, (trace_endpos + (v_forward * MOVETYPE_STEP)), self, SVC_INTERMISSION);
};

void () GrenadeExplode =
{
	self.classname = "nadda";
	self.event = "";
	if ((self.flags & FL_MONSTER))
	{
		T_RadiusDamage (self, self.owner, 30, world);
	}
	else
	{
		T_RadiusDamage (self, self.owner, 120, world);
	}
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion3 ();
};

void () GrenadeTouch =
{
	if ((other == self.owner))
	{
		return;
	}
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if ((other.takedamage == DAMAGE_AIM))
	{
		GrenadeExplode ();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if ((self.velocity == VEC_ORIGIN))
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void () W_FireGrenade =
{
	local entity missile;
//	local entity mpuff;

	self.currentammo = self.ammo_rockets = (self.ammo_rockets - 1);
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	missile.event = "thrett";
	makevectors (self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = ((((v_forward * 600) + (v_up * 200)) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));
	}
	else
	{
		missile.velocity = aim (self, 10000);
		missile.velocity = (missile.velocity * 600);
		missile.velocity_z = 200;
	}
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = GrenadeTouch;
	missile.nextthink = (time + 2.5);
	missile.think = GrenadeExplode;
	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, self.origin);
};

void (vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles (dir);
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	if ((newmis.owner.classname == "player"))
	{
		newmis.event = "thrett";
	}
	else
	{
		newmis.event = "mthret";
	}
	newmis.think = SUB_Remove;
	newmis.nextthink = (time + MOVETYPE_TOSS);
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	newmis.velocity = (dir * 1000);
};

void () W_FireSuperSpikes =
{
	local vector dir;
	local entity old;

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = (time + 0.2);
	
	self.currentammo = self.ammo_nails = (self.ammo_nails - FL_SWIM);
	dir = aim (self, 1000);
	launch_spike ((self.origin + '0 0 16'), dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = CONTENT_SOLID;
};

void (float ox) W_FireSpikes =
{
	local vector dir;
	local entity old;

	makevectors (self.v_angle);
	if (((self.ammo_nails >= FL_SWIM) && (self.weapon == IT_SUPER_NAILGUN)))
	{
		W_FireSuperSpikes ();
		return;
	}
	if ((self.ammo_nails < 1))
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/nailgun.wav", 1, ATTN_NORM);
	self.attack_finished = (time + 0.2);
	self.currentammo = self.ammo_nails = (self.ammo_nails - 1);
	dir = aim (self, 1000);
	launch_spike (((self.origin + '0 0 16') + (v_forward * 15) + (v_right * ox)), dir);
	self.punchangle_x = CONTENT_SOLID;
};

void () spike_touch =
{
//	local float rand;

	if ((other == self.owner))
	{
		return;
	}
	if ((other.solid == SOLID_TRIGGER))
	{
		return;
	}
	if ((self.owner.classname == "monster_wizard"))
	{
		if ((other.classname == "monster_wizard"))
		{
			remove (self);
			return;
		}
	}
	if (((self.owner.classname == "monster_hell_knight") || (self.owner.classname == "monster_baron")))
	{
		if ((((other.classname == "monster_knight") || (other.classname == "monster_hell_knight")) || (other.classname == "monster_baron")))
		{
			remove (self);
			return;
		}
	}
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, MOVETYPE_FLYMISSILE);
		if (!(other.flags & FL_BLOODLESS))
		{
			spawn_touchblood (MOVETYPE_FLYMISSILE);
		}
		else
		{
			remove (self);
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		if ((self.classname == "wizspike"))
		{
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		}
		else
		{
			if ((self.classname == "wraithspike"))
			{
				WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			}
			else
			{
				if ((self.classname == "knightspike"))
				{
					WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
				}
				else
				{
					WriteByte (MSG_BROADCAST, TE_SPIKE);
				}
			}
		}
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	remove (self);
};

void () superspike_touch =
{
//	local float rand;

	if ((other == self.owner))
	{
		return;
	}
	if ((other.solid == SOLID_TRIGGER))
	{
		return;
	}
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 18);
		if (!(other.flags & FL_BLOODLESS))
		{
			spawn_touchblood (18);
		}
		else
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
			remove (self);
			return;
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	remove (self);
};

void () W_SetCurrentAmmo =
{
	player_run ();
	self.items = (self.items - (self.items & (((IT_SHELLS | IT_NAILS) | IT_ROCKETS) | IT_CELLS)));
	if ((self.weapon == IT_SWORD))
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/mv_nad.mdl";
		self.weaponframe = 0;
	}
	else
	{
		if ((self.weapon == IT_SHOTGUN))
		{
			self.currentammo = self.ammo_shells;
			self.weaponmodel = "progs/v_shot.mdl";
			self.weaponframe = 0;
			self.items = (self.items | IT_SHELLS);
		}
		else
		{
			if ((self.weapon == IT_SUPER_SHOTGUN))
			{
				self.currentammo = self.ammo_shells;
				self.weaponmodel = "progs/v_shot2.mdl";
				self.weaponframe = 0;
				self.items = (self.items | IT_SHELLS);
			}
			else
			{
				if ((self.weapon == IT_NAILGUN))
				{
					self.currentammo = self.ammo_nails;
					self.weaponmodel = "progs/v_nail.mdl";
					self.weaponframe = 0;
					self.items = (self.items | IT_NAILS);
				}
				else
				{
					if ((self.weapon == IT_SUPER_NAILGUN))
					{
						self.currentammo = self.ammo_nails;
						self.weaponmodel = "progs/v_nail2.mdl";
						self.weaponframe = 0;
						self.items = (self.items | IT_NAILS);
					}
					else
					{
						if ((self.weapon == IT_GRENADE_LAUNCHER))
						{
							self.currentammo = self.ammo_rockets;
							self.weaponmodel = "progs/v_rock.mdl";
							self.weaponframe = 0;
							self.items = (self.items | IT_ROCKETS);
						}
						else
						{
							if ((self.weapon == IT_ROCKET_LAUNCHER))
							{
								self.currentammo = self.ammo_rockets;
								self.weaponmodel = "progs/v_rock2.mdl";
								self.weaponframe = 0;
								self.items = (self.items | IT_ROCKETS);
							}
							else
							{
								if ((self.weapon == IT_LIGHTNING))
								{
									self.currentammo = self.ammo_cells;
									self.weaponmodel = "progs/v_light.mdl";
									self.weaponframe = 0;
									self.items = (self.items | IT_CELLS);
								}
								else
								{
									if ((self.weapon == IT_SPROCKET))
									{
										self.currentammo = self.ammo_rockets;
										self.weaponmodel = "progs/mv_rock2.mdl";
										self.weaponframe = 0;
										self.items = (self.items | IT_ROCKETS);
									}
									else
									{
										if ((self.weapon == IT_AUTO_SHOTGUN))
										{
											self.currentammo = self.ammo_shells;
											self.weaponmodel = "progs/mv_sh2.mdl";
											self.weaponframe = 0;
											self.items = (self.items | IT_SHELLS);
										}
										else
										{
											self.currentammo = 0;
											self.weaponmodel = "";
											self.weaponframe = 0;
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

float () W_BestWeapon =
{
	local float it;

	it = self.items;
	if ((((self.waterlevel <= 1) && (self.ammo_cells >= 1)) && (it & IT_LIGHTNING)))
	{
		return (IT_LIGHTNING);
	}
	if (((self.ammo_nails >= FL_SWIM) && (it & IT_SUPER_NAILGUN)))
	{
		return (IT_SUPER_NAILGUN);
	}
	if (((self.ammo_nails >= FL_SWIM) && (it & IT_NAILGUN)))
	{
		return (IT_NAILGUN);
	}
	if (((self.ammo_shells >= FL_SWIM) && (it & IT_AUTO_SHOTGUN)))
	{
		return (IT_AUTO_SHOTGUN);
	}
	if (((self.ammo_shells >= FL_SWIM) && (it & IT_SUPER_SHOTGUN)))
	{
		return (IT_SUPER_SHOTGUN);
	}
	if (((self.ammo_shells >= 1) && (it & IT_SHOTGUN)))
	{
		return (IT_SHOTGUN);
	}
	return (IT_SWORD);
};

float () W_CheckNoAmmo =
{
	if ((self.currentammo > 0))
	{
		return (1);
	}
	if ((self.weapon == IT_SWORD))
	{
		return (1);
	}
	self.weapon = W_BestWeapon ();
	W_SetCurrentAmmo ();
	return (0);
};

void () W_Attack =
{
	local float r;

	if (!W_CheckNoAmmo ())
	{
		return;
	}
	makevectors (self.v_angle);
	self.show_hostile = (time + 1);
	if ((self.weapon == IT_SWORD))
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random ();
		if ((r < 0.25))
		{
			player_axe1 ();
		}
		else
		{
			if ((r < 0.5))
			{
				player_axeb1 ();
			}
			else
			{
				if ((r < 0.75))
				{
					player_axec1 ();
				}
				else
				{
					player_axed1 ();
				}
			}
		}
		self.attack_finished = (time + 0.5);
	}
	else
	{
		if ((self.weapon == IT_SHOTGUN))
		{
			player_shot1 ();
			W_FireShotgun ();
			self.event = "thrett";
			self.attack_finished = (time + 0.5);
		}
		else
		{
			if ((self.weapon == IT_SUPER_SHOTGUN))
			{
				player_shot1 ();
				W_FireSuperShotgun ();
				self.event = "thrett";
				self.attack_finished = (time + 0.7);
			}
			else
			{
				if ((self.weapon == IT_AUTO_SHOTGUN))
				{
					self.event = "thrett";
					player_autos1 ();
				}
				else
				{
					if ((self.weapon == IT_SUPER_NAILGUN))
					{
						self.event = "thrett";
						player_nail1 ();
					}
					else
					{
						if ((self.weapon == IT_GRENADE_LAUNCHER))
						{
							player_rocket1 ();
							W_FireGrenade ();
							self.attack_finished = (time + 0.6);
						}
						else
						{
							if ((self.weapon == IT_ROCKET_LAUNCHER))
							{
								player_rocket1 ();
								W_FireRocket ();
								self.attack_finished = (time + 0.8);
							}
							else
							{
								if ((self.weapon == IT_LIGHTNING))
								{
									player_light1 ();
									self.attack_finished = (time + 0.1);
									self.event = "thrett";
									sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
								}
								else
								{
									if ((self.weapon == IT_SPROCKET))
									{
										player_rocket1 ();
										W_FireSprocket ();
										self.attack_finished = (time + 0.6);
									}
									else
									{
										if ((self.weapon == IT_NAILGUN))
										{
											self.event = "thrett";
											player_nail1 ();
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

void () W_ChangeWeapon =
{
	local float it;
	local float am;
	local float fl;

	it = self.items;
	am = 0;
	if ((self.impulse == 1))
	{
		fl = IT_SWORD;
	}
	else
	{
		if ((self.impulse == FL_SWIM))
		{
			fl = IT_SHOTGUN;
			if ((self.ammo_shells < 1))
			{
				am = 1;
			}
		}
		else
		{
			if ((self.impulse == MOVETYPE_WALK))
			{
				fl = IT_SUPER_SHOTGUN;
				if ((self.ammo_shells < FL_SWIM))
				{
					am = 1;
				}
			}
			else
			{
				if ((self.impulse == MOVETYPE_STEP))
				{
					fl = IT_NAILGUN;
					if ((self.ammo_nails < 1))
					{
						am = 1;
					}
				}
				else
				{
					if ((self.impulse == MOVETYPE_FLY))
					{
						fl = IT_SUPER_NAILGUN;
						if ((self.ammo_nails < FL_SWIM))
						{
							am = 1;
						}
					}
					else
					{
						if ((self.impulse == MOVETYPE_TOSS))
						{
							fl = IT_GRENADE_LAUNCHER;
							if ((self.ammo_rockets < 1))
							{
								am = 1;
							}
						}
						else
						{
							if ((self.impulse == MOVETYPE_PUSH))
							{
								fl = IT_ROCKET_LAUNCHER;
								if ((self.ammo_rockets < 1))
								{
									am = 1;
								}
							}
							else
							{
								if ((self.impulse == FL_CLIENT))
								{
									fl = IT_LIGHTNING;
									if ((self.ammo_cells < 1))
									{
										am = 1;
									}
								}
								else
								{
									if ((self.impulse == MOVETYPE_FLYMISSILE))
									{
										fl = IT_SPROCKET;
										if ((self.ammo_rockets < FL_SWIM))
										{
											am = 1;
										}
									}
									else
									{
										if ((self.impulse == 100))
										{
											fl = IT_AUTO_SHOTGUN;
											if ((self.ammo_shells < 1))
											{
												am = 1;
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
	self.impulse = 0;
	if (!(self.items & fl))
	{
		sprint (self, "you don't have that item.\n");
		return;
	}
	if (am)
	{
		sprint (self, "no can do.\n");
		return;
	}
	self.weapon = fl;
	W_SetCurrentAmmo ();
};

void () CheatCommand =
{
	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 200;
	self.ammo_cells = 100;

	self.armortype = 0.8;
	self.armorvalue = 200;

	self.items = ((((((((((self.items | IT_SWORD) | IT_NAILGUN) | IT_SHOTGUN) | IT_SUPER_SHOTGUN) | IT_AUTO_SHOTGUN) | IT_SUPER_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_ROCKET_LAUNCHER) | IT_KEY1) | IT_KEY2);
	self.items = (((self.items | IT_LIGHTNING) | IT_SPROCKET) | IT_ARMOR3);

	while (self.health < self.max_health) {

		local float h;
		h = T_Heal(self, 1, 1);
		if (!h)
			break;

	}

	self.regen = (self.regen + 30);
	if ((self.regen > 100))
	{
		self.regen = 100;
	}

	self.lives = (self.lives + 1);

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

void () CycleWeaponCommand =
{
	local float it;
	local float am;

	it = self.items;
	self.impulse = 0;
	while (1)
	{
		am = 0;
		if ((self.weapon == IT_AUTO_SHOTGUN))
		{
			self.weapon = IT_SWORD;
		}
		else
		{
			if ((self.weapon == IT_SWORD))
			{
				self.weapon = IT_SHOTGUN;
				if ((self.ammo_shells < 1))
				{
					am = 1;
				}
			}
			else
			{
				if ((self.weapon == IT_SHOTGUN))
				{
					self.weapon = IT_SUPER_SHOTGUN;
					if ((self.ammo_shells < FL_SWIM))
					{
						am = 1;
					}
				}
				else
				{
					if ((self.weapon == IT_SUPER_SHOTGUN))
					{
						self.weapon = IT_NAILGUN;
						if ((self.ammo_nails < 1))
						{
							am = 1;
						}
					}
					else
					{
						if ((self.weapon == IT_NAILGUN))
						{
							self.weapon = IT_SUPER_NAILGUN;
							if ((self.ammo_nails < FL_SWIM))
							{
								am = 1;
							}
						}
						else
						{
							if ((self.weapon == IT_SUPER_NAILGUN))
							{
								self.weapon = IT_GRENADE_LAUNCHER;
								if ((self.ammo_rockets < 1))
								{
									am = 1;
								}
							}
							else
							{
								if ((self.weapon == IT_GRENADE_LAUNCHER))
								{
									self.weapon = IT_ROCKET_LAUNCHER;
									if ((self.ammo_rockets < 1))
									{
										am = 1;
									}
								}
								else
								{
									if ((self.weapon == IT_ROCKET_LAUNCHER))
									{
										self.weapon = IT_LIGHTNING;
										if ((self.ammo_cells < 1))
										{
											am = 1;
										}
									}
									else
									{
										if ((self.weapon == IT_LIGHTNING))
										{
											self.weapon = IT_SPROCKET;
											if ((self.ammo_rockets < 1))
											{
												am = 1;
											}
										}
										else
										{
											if ((self.weapon == IT_SPROCKET))
											{
												self.weapon = IT_AUTO_SHOTGUN;
												if ((self.ammo_shells < 1))
												{
													am = 1;
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
		if (((it & self.weapon) && (am == 0)))
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
};

void () CycleWeaponReverseCommand =
{
	local float it;
	local float am;

	it = self.items;
	self.impulse = 0;
	while (1)
	{
		am = 0;
		if ((self.weapon == IT_LIGHTNING))
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if ((self.ammo_rockets < 1))
			{
				am = 1;
			}
		}
		else
		{
			if ((self.weapon == IT_ROCKET_LAUNCHER))
			{
				self.weapon = IT_GRENADE_LAUNCHER;
				if ((self.ammo_rockets < 1))
				{
					am = 1;
				}
			}
			else
			{
				if ((self.weapon == IT_GRENADE_LAUNCHER))
				{
					self.weapon = IT_SUPER_NAILGUN;
					if ((self.ammo_nails < FL_SWIM))
					{
						am = 1;
					}
				}
				else
				{
					if ((self.weapon == IT_SUPER_NAILGUN))
					{
						self.weapon = IT_NAILGUN;
						if ((self.ammo_nails < 1))
						{
							am = 1;
						}
					}
					else
					{
						if ((self.weapon == IT_NAILGUN))
						{
							self.weapon = IT_SUPER_SHOTGUN;
							if ((self.ammo_shells < FL_SWIM))
							{
								am = 1;
							}
						}
						else
						{
							if ((self.weapon == IT_SUPER_SHOTGUN))
							{
								self.weapon = IT_SHOTGUN;
								if ((self.ammo_shells < 1))
								{
									am = 1;
								}
							}
							else
							{
								if ((self.weapon == IT_SHOTGUN))
								{
									self.weapon = IT_SWORD;
								}
								else
								{
									if ((self.weapon == IT_SWORD))
									{
										self.weapon = IT_AUTO_SHOTGUN;
										if ((self.ammo_shells < 1))
										{
											am = 1;
										}
									}
									else
									{
										if ((self.weapon == IT_AUTO_SHOTGUN))
										{
											self.weapon = IT_SPROCKET;
											if ((self.ammo_rockets < 1))
											{
												am = 1;
											}
										}
										else
										{
											if ((self.weapon == IT_SPROCKET))
											{
												self.weapon = IT_LIGHTNING;
												if ((self.ammo_cells < 1))
												{
													am = 1;
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
		if (((it & self.weapon) && (am == 0)))
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
};

void () ServerflagsCommand =
{
	serverflags = (serverflags * FL_SWIM) + 1;
};

void () QuadCheat =
{
	if ((deathmatch || coop))
	{
		return;
	}
	self.super_time = 1;
	self.super_damage_finished = (time + SVC_INTERMISSION);
	self.items = (self.items | IT_QUAD);
	bprint ("quad cheat\n");
};

void() QuadCheatPermanent =
{
	if (deathmatch || coop)
		return;
	if (!self.super_time) {
		self.super_time = 1;
		self.super_damage_finished = time + EXTRA_HIGH;
		self.items = self.items | IT_QUAD;
		bprint ("permanent quad cheat activated\n");
	} else {
		//self.items = self.items - IT_QUAD;
		//self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		self.super_damage_finished = time - 1;
		self.super_time = 0;
		bprint ("permanent quad cheat deactivated\n");
	}
};

void() InvulnCheat =
{
   if (deathmatch || coop)
		return;
   self.items = self.items | IT_INVULNERABILITY;
	self.invincible_time = 1;
	self.invincible_finished = time + 30;
   bprint( "pentagram cheat activated\n" );
};

void() RadCheat =
{
   if (deathmatch || coop)
		return;
   self.items = self.items | IT_SUIT;
		self.rad_time = 1;
		self.radsuit_finished = time + 30;
   bprint( "biosuit cheat activated\n" );
};

void() InvisCheat =
{
   if (deathmatch || coop)
		return;
   self.items = self.items | IT_INVISIBILITY;
		self.invisible_time = 1;
		self.invisible_finished = time + 30;
   bprint( "invisibility cheat activated\n" );
};

void () ImpulseCommands =
{
//	local entity mark;

	if ((self.impulse == 100))
	{
		W_ChangeWeapon ();
	}
	if (((self.impulse >= 1) && (self.impulse <= 9)))
	{
		W_ChangeWeapon ();
	}
	if ((self.impulse == 221))
	{
		dm3_showscores ();
	}
	if ((self.impulse == 222))
	{
		if ((coop || deathmatch))
		{
			return;
		}
		CheatCommand ();
	}
	if ((self.impulse == 223))
	{
		bprint ("ORIGIN: ");
		bprint (vtos (self.origin));
		bprint (" ---- ANGLES: ");
		bprint (vtos (self.angles));
		bprint ("\n");
	}
	if ((self.impulse == 224))
	{
		bprint (self.netname);
		bprint (" is a llama\n");
	}
	if ((self.impulse == MOVETYPE_BOUNCE))
	{
		CycleWeaponCommand ();
	}
	if ((self.impulse == MOVETYPE_BOUNCEMISSILE))
	{
		ServerflagsCommand ();
	}
	if ((self.impulse == 12))
	{
		CycleWeaponReverseCommand ();
	}
	if (self.impulse == 255)
		QuadCheatPermanent ();

	if (self.impulse == 254)
		QuadCheat ();
		
	if (self.impulse == 253)
		InvulnCheat ();
		
	if (self.impulse == 252)
		InvisCheat ();
		
	if (self.impulse == 251)
		RadCheat ();

	self.impulse = 0;
};

void () W_WeaponFrame =
{
	if ((time < self.attack_finished))
	{
		return;
	}
	if (self.impulse)
		ImpulseCommands ();

	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

void () SuperDamageSound =
{
	if ((self.super_damage_finished > time))
	{
		if ((self.super_sound < time))
		{
			self.super_sound = (time + 1);
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};

void () W_FireSprocket =
{
	local entity missile;
//	local entity mpuff;

	self.ammo_rockets = (self.ammo_rockets - AS_STRAIGHT);
	self.currentammo = (self.ammo_rockets - AS_STRAIGHT);
	sound (self, CHAN_WEAPON, "weapons/thump.wav", AS_STRAIGHT, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "sprocket";
	missile.event = "thrett";
	makevectors (self.v_angle);
	missile.velocity = aim (self, 700);
	missile.velocity = (missile.velocity * 700);
	missile.angles = vectoangles (missile.velocity);
	missile.touch = Sprocket_Touch;
	missile.nextthink = (time + 2.5);
	missile.think = SUB_Remove;
	setmodel (missile, "progs/sprocket.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, ((self.origin + (v_forward * WEAPON_BIG)) + '0 0 16'));
};

void () Sprocket_Touch =
{
	local vector pnt;
	local float num;

	if ((other == self.owner))
	{
		return;
	}
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if ((other.classname == "monster_nehahra"))
	{
		self.think = SprocketExplode;
		self.nextthink = (time + 0.1);
		return;
	}
	self.enemy = other;
	if ((other.takedamage == DAMAGE_AIM))
	{
		self.solid = SOLID_NOT;
		self.enemy = other;
		pnt = self.origin;
		if ((self.origin_x > self.enemy.origin_x))
		{
			num = self.origin_x - self.enemy.origin_x;
			num = num * 0.6;
			pnt_x = pnt_x - num;
		}
		else
		{
			if ((self.origin_x < self.enemy.origin_x))
			{
				num = self.enemy.origin_x - self.origin_x;
				num = num * 0.6;
				pnt_x = pnt_x + num;
			}
		}
		if ((self.origin_y > self.enemy.origin_y))
		{
			num = self.origin_y - self.enemy.origin_y;
			num = num * 0.6;
			pnt_y = pnt_y - num;
		}
		else
		{
			if ((self.origin_y < self.enemy.origin_y))
			{
				num = self.enemy.origin_y - self.origin_y;
				num = num * 0.6;
				pnt_y = pnt_y + num;
			}
		}
		if ((self.origin_z > self.enemy.origin_z))
		{
			num = self.origin_z - self.enemy.origin_z;
			num = num * 0.4;
			pnt_z = pnt_z - num;
		}
		else
		{
			if ((self.origin_z < self.enemy.origin_z))
			{
				num = self.enemy.origin_z - self.origin_z;
				num = num * 0.4;
				pnt_z = pnt_z + num;
			}
		}
		self.aether = (self.enemy.origin - pnt);
		self.touch = SUB_Null;
		self.think = Sprocket_Imbed;
		self.nextthink = (time + 0.1);
		return;
	}
	self.dest = (self.origin - other.origin);
	self.cnt = 0;
	sound (self, CHAN_ITEM, "weapons/sprwall.wav", 1, ATTN_NORM);
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	self.touch = SUB_Null;
	self.think = Sprocket_Imbed;
	self.nextthink = time;
};

void () Sprocket_Imbed =
{
	local float num;

	if ((self.enemy != world))
	{
		self.frame = 1;
		if ((self.enemy.flags & FL_MONSTER))
		{
			self.velocity = self.enemy.velocity;
			self.enemy.velocity = '0 0 0';
			self.origin = (self.enemy.origin - self.aether);
			if ((self.enemy.health < 1))
			{
				self.think = SprocketExplode;
				self.nextthink = (time + 0.05);
				return;
			}
		}
		else
		{
			self.origin = (self.enemy.origin + self.dest);
		}
		num = FL_SWIM;
		if ((self.items & IT_QUAD))
		{
			num = num * 4;
		}
		if ((self.enemy.health > num))
		{
			T_Damage (self.enemy, self, self.owner, FL_SWIM);
		}
	}
	self.cnt = (self.cnt + 1);
	if ((((self.cnt == 15) || (self.cnt == 23)) || (self.cnt == 30)))
	{
		sound (self, CHAN_WEAPON, "weapons/sprocket.wav", AS_STRAIGHT, ATTN_NORM);
		self.effects = (self.effects | EF_MUZZLEFLASH);
		if ((self.enemy != world))
		{
			if ((((self.enemy.flags & FL_MONSTER) || self.enemy.flags) & FL_CLIENT))
			{
				if ((random () < 0.4))
				{
					SpawnMeatSpray (self.origin, ((crandom () * 86) * v_right));
				}
				else
				{
					SpawnMeatSpray (self.origin, ((crandom () * -86) * v_right));
				}
			}
		}
	}
	if ((self.cnt > 33))
	{
		if ((self.enemy.flags & FL_BLOODLESS))
		{
			T_Damage (self.enemy, self, self.owner, 30);
		}
		self.cnt = 0;
		self.think = SprocketExplode;
		self.nextthink = (time + 0.1);
		return;
	}
	self.think = Sprocket_Imbed;
	self.nextthink = time;
};

void () SprocketExplode =
{
	T_RadiusDamage (self, self.owner, 85, world);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion2 ();
};
