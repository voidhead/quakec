/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/
void() W_SetCurrentAmmo =
{
	if (self.health > 1)		// 1998-08-12 avoiding ghosts by Athos
		player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
#ifdef HIPNOTIC
	else if (self.weapon == IT_LASER_CANNON)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_laserg.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == IT_MJOLNIR)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_hammer.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == IT_PROXIMITY_GUN)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_prox.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
#endif
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.items;

	if ((self.waterlevel < LEVEL_WAIST) && (self.ammo_cells >= 1) && (it & IT_LIGHTNING))
		return IT_LIGHTNING;
#ifdef HIPNOTIC
	if ((self.ammo_cells >= 1) && (it & IT_LASER_CANNON))
		return IT_LASER_CANNON;
#endif
	if ((self.ammo_nails >= 2) && (it & IT_SUPER_NAILGUN))
		return IT_SUPER_NAILGUN;
	if ((self.ammo_shells >= 2) && (it & IT_SUPER_SHOTGUN))
		return IT_SUPER_SHOTGUN;
	if ((self.ammo_nails >= 1) && (it & IT_NAILGUN))
		return IT_NAILGUN;
	if ((self.ammo_shells >= 1) && (it & IT_SHOTGUN))
		return IT_SHOTGUN;
#ifdef HIPNOTIC
	else if(it & IT_MJOLNIR)
		return IT_MJOLNIR;
#endif
	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;
#ifdef HIPNOTIC
	if (self.weapon == IT_MJOLNIR)
		return TRUE;
#endif

//	if (self.button0)
//		self.button0 = 0;	// depress the fire button

	self.weapon = W_BestWeapon ();
	W_SetCurrentAmmo ();

// drop the weapon down
	return FALSE;
};

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
	local	float	it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}		
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
#ifdef HIPNOTIC
		if (self.weapon == IT_GRENADE_LAUNCHER)
			fl = IT_PROXIMITY_GUN;
		else
#endif
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}
#ifdef HIPNOTIC
	else if (self.impulse == 225)
	{
		fl = IT_LASER_CANNON;
		if (self.ammo_cells < 1)
			am = 1;
	}
	else if (self.impulse == 226)
		fl = IT_MJOLNIR;
#endif



	self.impulse = 0;
	
	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
#ifdef HIPNOTIC
		if (fl == IT_GRENADE_LAUNCHER)
		{
			fl = IT_PROXIMITY_GUN;
			if (!(self.items & fl))
			{
				sprint (self, "no weapon.\n");
				return;
			}
			if (self.ammo_rockets < 1)
				am = 1;
			else
				am = 0;
		}
		else
		{
#endif
			sprint (self, "no weapon.\n");
			return;
#ifdef HIPNOTIC
		}
#endif
	}
	
	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

// set weapon, set ammo
	self.weapon = fl;		
	W_SetCurrentAmmo ();
};


/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;
	
	while (1)
	{
		am = 0;

#ifdef ID1
		if (self.weapon == IT_LIGHTNING)
#endif
#ifdef HIPNOTIC
		if (self.weapon == IT_MJOLNIR)
#endif
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
#ifdef ID1
			self.weapon = IT_ROCKET_LAUNCHER;
#endif
#ifdef HIPNOTIC
			self.weapon = IT_PROXIMITY_GUN;
#endif
			if (self.ammo_rockets < 1)
				am = 1;
		}
#ifdef HIPNOTIC
		else if (self.weapon == IT_PROXIMITY_GUN)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
#endif
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
#ifdef HIPNOTIC
		else if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_LASER_CANNON;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == IT_LASER_CANNON)
		{
			self.weapon = IT_MJOLNIR;
		}
#endif
		else
		{
			self.weapon = IT_SHOTGUN;
			am = 1;
		}

		if (it & self.weapon)
		if (!am)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

#ifdef HIPNOTIC
		if (self.weapon == IT_MJOLNIR)
		{
			self.weapon = IT_LASER_CANNON;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == IT_LASER_CANNON)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else
#endif
		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
#ifdef ID1
			self.weapon = IT_GRENADE_LAUNCHER;
#endif
#ifdef HIPNOTIC
			self.weapon = IT_PROXIMITY_GUN;
#endif
			if (self.ammo_rockets < 1)
				am = 1;
		}
#ifdef HIPNOTIC
		else if (self.weapon == IT_PROXIMITY_GUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
#endif
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
#ifdef ID1
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
#endif
#ifdef HIPNOTIC
			self.weapon = IT_MJOLNIR;
#endif
		}
		else
		{
			self.weapon = IT_SHOTGUN;
			am = 1;
		}

		if (it & self.weapon)
		if (!am)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};
