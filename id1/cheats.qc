/*
================================
impulse 9	give all
impulse 11	give rune

impulse 100	bot cheat
impulse 101	gib self
impulse 249	secrets
impulse 250	massacre
impulse 251	give radsuit
impulse 252	give invisibility
impulse 253	give 666
impulse 254	give quad
impulse 255	permanent quad
================================
hipnotic
impulse 200	WetsuitCheat
impulse 201	EmpathyShieldsCheat
impulse 202	DumpEntities
impulse 203	DumpLiveEntities
impulse 205	Genocide
impulse 206	ToggleDump
================================
*/

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
//	if (deathmatch || coop)
//		return;

	if (deathmatch && !cvar("developer"))
		return;

	self.ammo_rockets = MAX_AMMO_ROCKETS;
	self.ammo_nails = MAX_AMMO_NAILS;
	self.ammo_shells = MAX_AMMO_SHELLS;
	self.ammo_cells = MAX_AMMO_CELLS;

	self.armortype = 0.8;
	self.armorvalue = 200;
	
	while (self.health < self.max_health) 
	{

		local float h;
		h = T_Heal(self, 1, 1);

		if (!h)
			break;
	}

	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_LIGHTNING |
//		IT_KEY1 | IT_KEY2 |
		IT_ARMOR3;

#ifdef HIPNOTIC
		self.items = self.items |
		IT_LASER_CANNON |
		IT_MJOLNIR |
		IT_PROXIMITY_GUN;
#endif

	//self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();

	bprint (self.netname);
	bprint (" activated give all cheat\n");
};



/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	if (deathmatch)
		return;

	serverflags = serverflags*2 + 1;
};

void() QuadCheat =
{
	if (deathmatch) 	//|| coop)
		return;

	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	sound (self, CHAN_BODY, "items/damage.wav", 1, ATTN_NORM);

	bprint (self.netname);
	bprint (" activated quad cheat\n");
};

void() QuadCheatPermanent =
{
	if (deathmatch)		//|| coop)
		return;

	if (!self.super_time)
	{
		self.super_time = 1;
		self.super_damage_finished = time + EXTRA_HIGH;
		self.items = self.items | IT_QUAD;
		sound (self, CHAN_BODY, "items/damage.wav", 1, ATTN_NORM);

		bprint (self.netname);
		bprint (" activated permanent quad cheat\n");
	}
	else
	{
		//self.items = self.items - IT_QUAD;
		self.super_damage_finished = time - 1;
		self.super_time = 0;
		sound (self, CHAN_BODY, "items/damage.wav", 1, ATTN_NORM);

		bprint (self.netname);
		bprint (" deactivated permanent quad cheat\n");
	}
};

void() InvulnCheat =
{
	if (deathmatch)		//|| coop)
		return;

	self.items = self.items | IT_INVULNERABILITY;
	self.invincible_time = 1;
	self.invincible_finished = time + 30;
	sound (self, CHAN_BODY, "items/protect.wav", 1, ATTN_NORM);

	bprint (self.netname);
	bprint( " activated pentagram cheat\n" );
};

void() RadCheat =
{
	if (deathmatch)		//|| coop)
		return;

	self.items = self.items | IT_SUIT;
	self.rad_time = 1;
	self.radsuit_finished = time + 30;
	sound (self, CHAN_BODY, "items/suit.wav", 1, ATTN_NORM);

	bprint (self.netname);
	bprint( " activated biosuit cheat\n" );
};

void() InvisCheat =
{
	if (deathmatch)		//|| coop)
		return;
	
	self.items = self.items | IT_INVISIBILITY;
	self.invisible_time = 1;
	self.invisible_finished = time + 30;
	sound (self, CHAN_BODY, "items/inv1.wav", 1, ATTN_NORM);

	bprint (self.netname);
	bprint( " activated invisibility cheat\n" );
};

void() Massacre =
{
	local entity head;
	local float toll;
	
	if (deathmatch)		//|| coop)
		return;

	head = nextent(world);
	while (head != world)
	{
		if ((head.health > 0) && (head.flags & FL_MONSTER))
		{
			T_Damage(head, world, world, head.health + 10, "");
			toll++;
		}
		head = nextent(head);
	}

	if (toll)
	{
		sound(world, CHAN_VOICE, "player/udeath.wav", 1.0, ATTN_NONE);
		bprint (self.netname);
		bprint (" massacred ");
		bprint(ftos(toll));
		bprint(" monsters\n");
	}
	else
		sprint(self, "no monsters to massacre\n");
};

void() GibSelf =
{
//	bprint (self.netname);
//	bprint (" explodes himself violently\n");

//	T_Damage(self, self, self, 50000, "");

	self.deathtype = "suicide2";
	self.health = -100;	//self.gibhealth - 999;
	printvector(self.dest);
	Killed(self, self);
};

#ifdef HIPNOTIC
void() WetsuitCheat =
{
	if (deathmatch)		//|| coop)
		return;

	self.items2 = self.items2 | HIP_IT_WETSUIT;
	self.wetsuit_time = 1;
	self.wetsuit_finished = time + 30;
	sound (self, CHAN_BODY, "misc/weton.wav", 1, ATTN_NORM);

	bprint (self.netname);
	bprint( " activated wetsuit cheat\n" );
};

void() EmpathyShieldsCheat =
{
	if (deathmatch)		//|| coop)
		return;

	self.items2 = self.items2 | HIP_IT_EMPATHY_SHIELDS;
	self.empathy_time = 1;
	self.empathy_finished = time + 30;
	sound (self, CHAN_BODY, "hipitems/empathy.wav", 1, ATTN_NORM);

	bprint (self.netname);
	bprint( " activated empathy shields cheat\n" );
};

void() DumpEntities =
{
	local	entity	head;
	local	float	i;

	i = 1;
	head = nextent(world);
	while (head != world)
	{
		dprint(ftos(i));
		dprint(" ");
		dprint(head.classname);
		dprint("\n");
		head = nextent(head);
		i = i + 1;
	}
};

void() DumpLiveEntities =
{
	local	entity	head;
	local	float	i;

	i = 1;
	head = nextent(world);
	while (head!=world)
	{
		if (head.health > 0)
		{
			dprint(ftos(i));
			dprint(" ");
			dprint(head.classname);
			dprint(" ");
			dprint(vtos(head.origin));
			dprint("\n");
			dprint("--------------------\n");
		}
		head = nextent(head);
		i = i + 1;
	}
};

/*
void() Genocide =
{
	local entity   head;
	
	if (deathmatch || coop)
		return;
	bprint("Genocide!\n");
	head = nextent(world);
	while (head!=world)
	{
		if ((head.health > 0) && (head.flags & FL_MONSTER))
		{
			 T_Damage(head,world,world,head.health+10);
		}
		head = nextent(head);
	}
};

float dump_coord;
void () ToggleDump =
{
	dump_coord = 1 - dump_coord;
	if (dump_coord == 1)
	bprint("Dumping Player Location\n");
};

void () DumpCoordinates =
{
	local entity pl;
	pl = checkclient();
	if (pl)
	{
		bprint("Player: ");
		bprint(vtos(pl.origin));
		bprint("\n");
	}
};
*/
#endif

void() SecretsCheat =
{
	local entity secret, blinker;
//	local float tmp;

	blinker = find(world, classname, "secret_blinker");

	if (!blinker)
	{
//		AddBlinkers();

		secret = find(world, classname, "trigger_secret");

		if (!secret)
		{
			sprint(self, "no secrets in this level\n");
			return;	
		}			

		while (secret != world)
		{
			blinker = spawn();
			setorigin (blinker, 0.5*(secret.absmin + secret.absmax));
			blinker.classname = "secret_blinker";
			blinker.pflags = PFLAGS_NOSHADOW | PFLAGS_FULLDYNAMIC | PFLAGS_CORONA;
			blinker.color = '2 0 0';
			blinker.style = 9;	//4
			blinker.light_lev = 24 + vlen(secret.size);
			blinker.goalentity = secret;

//			print(etos(secret), " adding ", etos(blinker), "\n");

			secret = find(secret, classname, "trigger_secret");
		}

		sprint(self, "secret areas are now marked\n");
		return;
	}

	else
	{
//		RemoveBlinkers();

		while (blinker != world)
		{
//			print("removing ", etos(blinker), "\n");

			remove(blinker);
			blinker = find(world, classname, "secret_blinker");
		}

		sprint(self, "secrets areas are unmarked\n");
		return;		
	}

/*	blinker = find(world, classname, "trigger_secret");

	while (blinker != world)
	{
//		print(etos(blinker), "\n");

		if (mod(framecount, 40) > 19)
		{
			blinker.effects |= EF_FULLBRIGHT;
			blinker.colormod = '4 0 0';
		}	
		else
		{
			blinker.effects -= self.effects & EF_FULLBRIGHT;
			blinker.colormod = '0 0 0';
		}

		blinker = find(blinker, classname, "trigger_secret");
	}

	while (blinker != world)
	{
		if (blinker.classname == "func_door")
		{
			print (ftos(framecount), " ", etos(blinker), "\n");

			if (mod(framecount, 40) > 19)
			{
				blinker.effects |= EF_FULLBRIGHT;
				blinker.colormod = '4 0 0';
			}	
			else
			{
				blinker.effects -= self.effects & EF_FULLBRIGHT;
				blinker.colormod = '0 0 0';
			}
		}
		blinker = nextent(blinker);		
	}
*/
};

/*
============
Cheater bots
============
*/
void() BotCheat =
{
	local entity pl, oldself;
	local float bots;

	if (!coop)	// & !deathmatch)
		return;

	pl = find (world, classname, "player");
	while (pl != world)
	{
		if (!pl.ishuman)
		{
			oldself = self;
			self = pl;
	
//			stuffcmd(self, "god\n");
			self.flags = self.flags & FL_GODMODE;
			bprint(self.netname);
			bprint(" activated god mode\n");
			CheatCommand();

//			QuadCheatPermanent();

			self.super_time = 1;
			self.super_damage_finished = time + EXTRA_HIGH;
			self.items = self.items | IT_QUAD;
			sound (self, CHAN_BODY, "items/damage.wav", 1, ATTN_NORM);
			bprint (self.netname);
			bprint (" activated permanent quad cheat\n");
	
			self = oldself;

			bots++;
		}
		pl = find (pl, classname, "player");
	}

	if (!bots)
		sprint(self, "no bots found on this server\n");	
};


/*
============
ImpulseCommands
============
*/
void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

#ifdef HIPNOTIC
	else if (self.impulse >= 225 && self.impulse <= 226)
		W_ChangeWeapon ();
#endif

	else if (self.impulse == 9)
		CheatCommand ();

	else if (self.impulse == 10)
		CycleWeaponCommand ();

	else if (self.impulse == 11)
		ServerflagsCommand ();

	else if (self.impulse == 12)
		CycleWeaponReverseCommand ();

	else if (self.impulse == 255)
		QuadCheatPermanent ();

	else if (self.impulse == 254)
		QuadCheat ();
		
	else if (self.impulse == 253)
		InvulnCheat ();
		
	else if (self.impulse == 252)
		InvisCheat ();
		
	else if (self.impulse == 251)
		RadCheat ();

	else if (self.impulse == 250)
		Massacre ();

	else if (self.impulse == 249)
		SecretsCheat ();

	else if (self.impulse == 101)
		GibSelf ();

	else if (self.impulse == 100)
		BotCheat ();
		
#ifdef HIPNOTIC
	else if (self.impulse == 200)
		WetsuitCheat();

	else if (self.impulse == 201)
		EmpathyShieldsCheat();

	else if (self.impulse == 202)
		DumpEntities();

	else if (self.impulse == 203)
		DumpLiveEntities();

/*
	else if (self.impulse == 205)
		Genocide();

	else if (self.impulse == 206)
		ToggleDump();

	if (dump_coord == 1)
		DumpCoordinates();
*/
#endif

	self.impulse = 0;
};
