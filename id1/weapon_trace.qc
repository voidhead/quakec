/*
==============================================================================

BULLETS

==============================================================================
*/

void(vector org, vector vel, float randomvel, vector ang, vector avel, float randomavel) ejectcasing;

void(vector start, vector end, float noents, entity attacker) weapontraceline =
{
	local float s;
	s = attacker.solid;

	if (attacker.solid == SOLID_SLIDEBOX)
		attacker.solid = SOLID_BBOX;

	traceline(start, end, noents, attacker);

	if (s == SOLID_SLIDEBOX)
		attacker.solid = s;
};


/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

void() ApplyMultiDamage =
{
	local entity e;
	
	e = nextent(world);
	while (e)
	{
		if (e.multi_damage)
		if (e.multi_damage_ent == self)
		{
//			print("multi_damage=", ftos(e.multi_damage), "\n");
			T_Damage (e, self, self, e.multi_damage, "");
			e.multi_damage = 0;
			e.multi_damage_ent = world;
		}
		e = nextent(e);
	}
};


/*
================
TraceAttack
================
*/

void(float damage, vector dir) TraceAttack =
{
	local   vector	vel, org;
//	local 	entity	otemp;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel*200;
	
	org = trace_endpos - dir*4;	//4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (trace_ent, org, vel*0.2, damage);

		trace_ent.multi_damage = trace_ent.multi_damage + damage;
		trace_ent.multi_damage_ent = self;

		if (trace_ent.solid == SOLID_BSP || trace_ent.solid == SOLID_BBOX)
		{
			if (CheckQuad(self))
				te_gunshotquad(org);
			else
				te_gunshot(org);	
		}
		
	}
	else
	{
		if (CheckQuad(self))
			te_gunshotquad(org);
//			te_blood(org, vel*0.2, damage*2);
		else
			te_gunshot(org);		
//			pointparticles(particleeffectnum("TE_WIZBLOOD"), org, vel*0.2, damage);
	}
};


/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle + self.punchangle);

	if (self.flags & FL_MONSTER)
	{
		src = self.origin + v_forward*10;
		src_z = self.absmin_z + self.size_z * 0.7;
	}
	else
		src = self.origin + self.view_ofs - v_up*6 + v_forward*12;

//	ClearMultiDamage ();

	while (shotcount > 0)
	{
		direction = dir + (spread_z + crandom()*spread_x)*v_right + crandom()*spread_y*v_up;

//		traceline (src, src + direction*2048, FALSE, self);
		weapontraceline (src, src + direction*2048, FALSE, self);

//		if (pointcontents)
		trailparticles(self, particleeffectnum("TR_BULLET"), src, trace_endpos);

		if (trace_fraction != 1.0)
			TraceAttack (4, direction);	//4

		shotcount = shotcount - 1;
	}

//	if (spread_z == 0)
	if (self.weapon != IT_SUPER_SHOTGUN)
		ApplyMultiDamage ();
};

//void(float effectnum, vector pmins, vector pmaxs, float pvel, float pcount) SpawnBlood_Shower;

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local	entity	e1, e2;	//, otemp;
	local	vector	f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

//	traceline (p1, p2, FALSE, self);
	weapontraceline (p1, p2, FALSE, self);

	if (trace_ent.takedamage
#ifdef HIPNOTIC
	&& !trace_ent.wetsuit_finished
#endif
	)
	{
//		particle (trace_endpos, '0 0 100', 225, damage*4);

		if (trace_ent.flags & FL_CLIENT || trace_ent.flags & FL_MONSTER || trace_ent.flags & FL_CORPSE)
		if (!(trace_ent.flags & FL_NOBLOOD))
			pointparticles(particleeffectnum("EF_LIGHTNINGSMOKE"), trace_endpos, '0 0 100', damage*0.5);

		SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*0.5);		//damage*2
		T_Damage (trace_ent, from, from, damage, "zap");

//		if (self.classname == "player")
//		{
//			if (other.classname == "player")
//				trace_ent.velocity_z = trace_ent.velocity_z + 400;
//		}
	} else
		te_plasmaburn(trace_endpos);
//		SpawnBlood_Shower(particleeffectnum("TE_TARBLOOD"), trace_endpos + '-16 -16 -16', trace_endpos + '16 16 16', 128, damage);	

	e1 = trace_ent;

//	traceline (p1 + f, p2 + f, FALSE, self);
	weapontraceline (p1 + f, p2 + f, FALSE, self);

	if (trace_ent != e1)
	{
		if (trace_ent.takedamage
#ifdef HIPNOTIC
		&& !trace_ent.wetsuit_finished
#endif
		)
		{
//			particle (trace_endpos, '0 0 100', 225, damage*4);

			if (trace_ent.flags & FL_CLIENT || trace_ent.flags & FL_MONSTER || trace_ent.flags & FL_CORPSE)
			if (!(trace_ent.flags & FL_NOBLOOD))
				pointparticles(particleeffectnum("EF_LIGHTNINGSMOKE"), trace_endpos, '0 0 100', damage*0.5);

			SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*0.5);		//damage*2
			T_Damage (trace_ent, from, from, damage, "zap");
		} else
			te_plasmaburn(trace_endpos);
	}

	e2 = trace_ent;

//	traceline (p1 - f, p2 - f, FALSE, self);
	weapontraceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2)
	{
		if (trace_ent.takedamage
#ifdef HIPNOTIC
		&& !trace_ent.wetsuit_finished
#endif
		)
		{
//			particle (trace_endpos, '0 0 100', 225, damage*4);
//			te_blood(trace_endpos, '0 0 100', damage*2);

			if (trace_ent.flags & FL_CLIENT || trace_ent.flags & FL_MONSTER || trace_ent.flags & FL_CORPSE)
			if (!(trace_ent.flags & FL_NOBLOOD))
				pointparticles(particleeffectnum("EF_LIGHTNINGSMOKE"), trace_endpos, '0 0 100', damage*0.5);

			SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*0.5);	//damage*2
			T_Damage (trace_ent, from, from, damage, "zap");
		} else
			te_plasmaburn(trace_endpos);
	}
};


/*
.entity lightningchain;
.float lightningsolidbackup;
.vector lightninghitpoint;
void (vector start, vector end, entity attacker, float damage) LightningDamage =
{
	local entity lightningchainhead, e, otemp;
	local float c;

	// find entities in the beam
	c = 0;
	lightningchainhead = world;
	while (c < 4)	//50	//32
	{
		c = c + 1;
		// pass world instead of attacker so it can hit corpses (could also just set self to SOLID_BBOX) and hit owned objects like plasmacharges
		weapontraceline(start, end, MOVE_MISSILE, world);
		if (trace_fraction == 1)
			break;
		if (trace_ent.solid == SOLID_BSP)
			break;
		// make entity non-solid so the beam can continue
		trace_ent.lightningsolidbackup = trace_ent.solid;
		trace_ent.solid = SOLID_NOT;
		trace_ent.lightninghitpoint = trace_endpos;
		// add entity to chain
		trace_ent.lightningchain = lightningchainhead;
		lightningchainhead = trace_ent;
	}
	// restore their .solid
	e = lightningchainhead;
	while (e != world)
	{
		e.solid = e.lightningsolidbackup;
		e = e.lightningchain;
	}
	end = trace_endpos;

	// now damage them
	e = lightningchainhead;
	while (e != world)
	{
		if (e != attacker && e.takedamage
#ifdef HIPNOTIC
		&& !trace_ent.wetsuit_finished
#endif
		   )
		{
			// special hack to spawn some sparks when hitting an armored enemy (knight)
			otemp = other;
			other = e;
			SpawnBlood(e.lightninghitpoint, '0 0 100', damage*2);
			other = otemp;

			T_Damage(e, attacker, attacker, damage, "zap");
		}
		else
			te_plasmaburn(e.lightninghitpoint);

		e = e.lightningchain;
	}

	te_plasmaburn(end);
};
*/