/*
===========
ClientObituary

called when a player dies
============
*/
void(entity targ, entity attacker) ClientObituary =
{
	local	float rnum;
	local	string deathstring, deathstring2;

	if (!(targ.flags & FL_CLIENT))
		return;
	
//	eprint(targ);
//	eprint(attacker);

	if (targ.deathtype == "squish")
	{
		if ((teamplay) && (targ.team == attacker.team) && (targ != attacker))
		{
			attacker.frags = attacker.frags - 1; 
			bprint (attacker.netname);
			bprint (" squished a teammate\n");
			return;
		}
		else if ((attacker.flags & FL_CLIENT) && (targ != attacker) && (targ.flags & FL_CLIENT))
		{
			bprint (attacker.netname);
			bprint (" squishes ");
			bprint (targ.netname);
			bprint ("\n");
			attacker.frags = attacker.frags + 1;
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;            // killed self
			bprint (targ.netname);
			bprint (" was squished\n");
			return;
		}
		return;
	}

	if (targ.deathtype == "barrel")
	{
		if ((teamplay) && (targ.team == attacker.team) && (targ != attacker))
		{
			attacker.frags = attacker.frags - 1; 
			bprint (attacker.netname);
			bprint (" blew up a teammate\n");
			return;
		}
		else if ((attacker.flags & FL_CLIENT) && (targ != attacker) && (targ.flags & FL_CLIENT))
		{
			bprint (targ.netname);
			bprint (" was blown up by ");
			bprint (attacker.netname);
			bprint ("\n");
			attacker.frags = attacker.frags + 1;
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;            // killed self
			bprint (targ.netname);
			bprint (" blew himself up\n");
			return;
		}
		return;
	}

	if (attacker.classname == "teledeath")
	{
		bprint (targ.netname);
		bprint (" was telefragged by ");
		bprint (attacker.owner.netname);
		bprint ("\n");

		attacker.owner.frags = attacker.owner.frags + 1;
		return;
	}

	if (attacker.classname == "teledeath2")
	{
		bprint ("Satan's power deflects ");
		bprint (targ.netname);
		bprint ("'s telefrag\n");

		targ.frags = targ.frags - 1;
		return;
	}

	// double 666 telefrag
	// (can happen often in deathmatch 4 and levels with more than one pentagram)
	if (attacker.classname == "teledeath3")
	{
		bprint (targ.netname);
		bprint (" was telefragged by ");
		bprint (attacker.owner.netname);
		bprint ("'s Satan's power\n");
//		targ.frags = targ.frags - 1;
		attacker.owner.frags = attacker.owner.frags + 1;
		return;
	}

	if (attacker.flags & FL_CLIENT)
	{
		if (targ == attacker)	//&& attacker.flags & FL_CLIENT
		{
			// killed self
			attacker.frags = attacker.frags - 1;
			bprint (targ.netname);
			
			if (targ.deathtype == "suicide")
			{
				attacker.frags = attacker.frags - 1;	// extra penalty
				bprint (" suicides\n");
				return;
			}
			else if (targ.deathtype == "suicide2")
			{
				attacker.frags = attacker.frags - 1;	// extra penalty
				bprint (" explodes himself violently\n");
				return;
			}
			else if (targ.deathtype == "grenade")
			{
				if (targ.health < targ.gibhealth)
					bprint (" kicked a grenade into his own ass\n");
				else
					bprint (" tries to put the pin back in\n");
				return;
			}
			else if (targ.deathtype == "rocket")
			{
				if (targ.health < targ.gibhealth)
					bprint (" explodes with his own rocket\n");
				else
					bprint (" dies through his own rocket\n");
				return;
			}
#ifdef HIPNOTIC
			else if (targ.deathtype == "hiplaser")
			{
				bprint (" toasted himself with lasers\n");
				return;
			}
			else if (targ.deathtype == "proximity")
			{
				rnum = random();
				if (rnum < 0.5)
					bprint (" should be more careful with his proximity grenades\n");
				else
					bprint (" tripped his own proximity bomb\n");
				return;
			}
#endif
			else if (targ.weapon == IT_LIGHTNING && targ.waterlevel > LEVEL_FEET)
			{
				if (targ.watertype == CONTENT_SLIME)
					bprint (" discharges into the slime\n");
				else if (targ.watertype == CONTENT_LAVA)
					bprint (" discharges into the lava\n");
				else
					bprint (" discharges into the water\n");
				return;
			}
#ifdef HIPNOTIC
			else if (targ.weapon == IT_MJOLNIR && targ.deathtype == "mjolnir_discharge")
			{
				if (targ.watertype == CONTENT_SLIME)
					bprint (" goes Thor in the slime\n");
				else if (targ.watertype == CONTENT_LAVA)
					bprint (" goes Thor in the lava\n");
				else
					bprint (" goes Thor in the water\n");
				return;
			}
#endif
			else
				bprint (" becomes bored with life\n");
			return;
		}
		else if ((teamplay == 2) && (targ.team > 0) && (targ.team == attacker.team))
		{
			rnum = random();
			if (rnum < 0.25)
				deathstring = " mows down a teammate\n";
			else if (rnum < 0.50)
				deathstring = " checks his glasses\n";
			else if (rnum < 0.75)
				deathstring = " gets a frag for the other team\n";
			else
				deathstring = " loses another friend\n";

			bprint (attacker.netname);
			bprint (deathstring);
			attacker.frags = attacker.frags - 1;
			return;
		}
		else
		{
			attacker.frags = attacker.frags + 1;

#ifdef HIPNOTIC
			if (targ.deathtype == "empathy")
			{
				rnum = random();
				bprint (targ.netname);

				if (rnum < 0.5)
					bprint (" shares ");
				else
					bprint (" feels ");

				bprint (attacker.netname);
				bprint ("'s pain\n");
				return;
			}

			if (targ.deathtype == "proximity")
			{
				rnum = random();
				bprint (targ.netname);

				if (rnum < 0.5)
					bprint (" got too friendly with ");
				else
					bprint (" did the rhumba with ");

				bprint (attacker.netname);
				bprint ("'s bomb\n");
				return;
			}

			if (targ.deathtype == "hiplaser")
			{
				rnum = random();
				bprint (targ.netname);

				if (rnum < 0.5)
					bprint (" was toasted by ");
				else
					bprint (" was radiated by ");

				bprint (attacker.netname);
				bprint ("'s laser\n");
				return;
			}
#endif

			if (targ.deathtype == "nail")
			{
				deathstring = " was nailed by ";
				deathstring2 = "\n";
			}
			else if (targ.deathtype == "supernail")
			{
				deathstring = " was punctured by ";
				deathstring2 = "\n";
			}
			else if (targ.deathtype == "grenade")
			{
				if ((attacker.super_damage_finished > 0) && (targ.health < targ.gibhealth))
				{
					rnum = random();
					if (rnum < 0.5)
						deathstring = " was pulverized by ";
					else 
						deathstring = " was splattered by ";
					deathstring2 = "'s quad grenade\n";
				}
				else
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < targ.gibhealth)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
			}
			else if (targ.deathtype == "rocket")
			{
				if ((attacker.super_damage_finished > 0) && (targ.health < targ.gibhealth))
				{
					rnum = random();
					if (rnum < 0.3)
						deathstring = " was brutalized by ";
					else if (rnum < 0.6)
						deathstring = " was smeared by ";
					else
					{
						bprint (attacker.netname);
						bprint (" rips ");
						bprint (targ.netname);
						bprint (" a new one\n");
						return;
					}
					deathstring2 = "'s quad rocket\n";
				}
				else
				{
					deathstring = " rides ";
					deathstring2 = "'s rocket\n";
					if (targ.health < targ.gibhealth)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s rocket\n";
					}
				}
			}
			else if (attacker.weapon == IT_AXE)
			{
				deathstring = " was ax-murdered by ";
				deathstring2 = "\n";
			}
			else if (attacker.weapon == IT_SHOTGUN)
			{
				deathstring = " chewed on ";
				deathstring2 = "'s boomstick\n";
			}
			else if (attacker.weapon == IT_SUPER_SHOTGUN)
			{
				deathstring = " ate 2 loads of ";
				deathstring2 = "'s buckshot\n";
			}
			else if (attacker.weapon == IT_LIGHTNING)
			{
				deathstring = " accepts ";
				if (attacker.waterlevel > LEVEL_FEET)
					deathstring2 = "'s discharge\n";
				else
					deathstring2 = "'s shaft\n";
			}
#ifdef HIPNOTIC
			else if (attacker.weapon == IT_MJOLNIR)
			{
				if (targ.deathtype == "mjolnir_melee")
					deathstring = " was slammed by ";
				else if (targ.deathtype == "mjolnir_discharge")
					deathstring2 = " accepts the discharge of ";
				else
					deathstring = " was thunderstruck by ";
				deathstring2 = "'s hammer\n";
			}
#endif
			bprint (targ.netname);
			bprint (deathstring);
			bprint (attacker.netname);
			bprint (deathstring2);
		}
		return;
	}
	else
	{
		targ.frags = targ.frags - 1;
		bprint (targ.netname);

		// killed by a montser?
		if (attacker.flags & FL_MONSTER)
		{
			if (attacker.classname == "monster_army")
				bprint (" was shot by a Grunt\n");
			if (attacker.classname == "monster_demon1")
				bprint (" was eviscerated by a Fiend\n");
			if (attacker.classname == "monster_dog")
				bprint (" was mauled by a Rottweiler\n");
			if (attacker.classname == "monster_dragon")
				bprint (" was fried by a Dragon\n");
			if (attacker.classname == "monster_enforcer")
				bprint (" was blasted by an Enforcer\n");
			if (attacker.classname == "monster_fish")
				bprint (" was fed to the Rotfish\n");
			if (attacker.classname == "monster_hell_knight")
			{
				if (targ.deathtype == "knightspike")
					bprint (" was vanquished by Death Knight's dark magic\n");
				else
					bprint (" was slain by a Death Knight\n");
			}
			if (attacker.classname == "monster_knight")
				bprint (" was slashed by a Knight\n");
			if (attacker.classname == "monster_ogre" || attacker.classname == "monster_ogre_marksman")
			{
				if (targ.deathtype == "ogre_melee")
					bprint (" was chainsawed by an Ogre\n");
				else
					bprint (" was destroyed by an Ogre\n");
			}
			if (attacker.classname == "monster_shalrath")
				bprint (" was exploded by a Vore\n");
			if (attacker.classname == "monster_shambler")
			{
				if (targ.deathtype == "shambler_melee1")
					bprint (" was smashed by a Shambler\n");
				else if (targ.deathtype == "shambler_melee2")
					bprint (" was gutted by a Shambler\n");
				else
					bprint (" was struck down by Shambler's thunderbolt\n");
			}
			if (attacker.classname == "monster_tarbaby")
				bprint (" was slimed by a Spawn\n");
			if (attacker.classname == "monster_vomit")
				bprint (" was vomited on by a Vomitus\n");
			if (attacker.classname == "monster_wizard")
				bprint (" was scragged by a Scrag\n");
			if (attacker.classname == "monster_zombie")
				bprint (" joins the Zombies\n");
#ifdef HIPNOTIC
			if (attacker.classname == "trap_spike_mine")
				bprint (" was blasted by a Spike Mine\n");
			if (attacker.classname == "monster_gremlin")
			{
				// TODO: add humiliating msgs for stolen weapon frags

				if (targ.deathtype == "proximity")
				{
					bprint (" tripped on Gremlin's proximity bomb\n");
					return;
				}
				if (targ.deathtype == "hiplaser")
				{
					rnum = random();
					if (rnum < 0.5)
						bprint (" was toasted by a Gremlin\n");
					else
						bprint (" was radiated by a Gremlin\n");
					return;
				}
				if (targ.deathtype == "nail")
				{
					bprint (" was nailed by a Gremlin\n");
					return;
				}
				else if (targ.deathtype == "supernail")
				{
					bprint (" was punctured by a Gremlin\n");
					return;
				}
				else if (targ.deathtype == "ogre_grenade")
				{
					if (targ.health < targ.gibhealth)
						bprint (" was gibbed by Gremlin's grenade\n");
					else
						bprint (" ate Gremlin's pineapple\n");
					return;
				}
				else if (targ.deathtype == "rocket")
				{
					if (targ.health < targ.gibhealth)
						bprint (" was gibbed by Gremlin's rocket\n");
					else
						bprint (" rides Gremlin's rocket\n");
					return;
				}
				else if (attacker.weapon == IT_SUPER_SHOTGUN)
				{
					bprint (" ate 2 loads of Gremlin's buckshot\n");
					return;
				}
				else if (attacker.weapon == IT_LIGHTNING)
				{
					bprint (" accepts Gremlin's");
					if (targ.deathtype == "discharge")
						bprint (" discharge\n");
					else
						bprint (" shaft\n");
					return;
				}
				else
				{
					bprint (" was outsmarted by a Gremlin\n");
					return;
				}
			}
			if (attacker.classname == "monster_scourge")
			{
				if (targ.deathtype == "nail")
					bprint (" was turned into a pin-cushion by a Centroid\n");					
				else
					bprint (" was stung by a Centroid\n");
			}
			if (attacker.classname == "monster_armagon")
				bprint (" was outgunned by Armagon\n");
#endif
			return;
		}

		// bosses
		if (attacker.classname == "monster_boss")
		{
			if (targ.deathtype == "chthon_ball")
				bprint (" was obliterated by Chthon\n");
			if (targ.deathtype == "chthon_splash")
				bprint (" could not escape Chthon's wrath\n");
			return;
		}
		if (attacker.classname == "monster_oldone")
		{
			bprint (" became one with Shub-Niggurath\n");
			return;
		}

		// monster projectiles (fallback)
		if (targ.deathtype == "wizspike")
		{
			bprint (" was scragged by a Scrag\n");
			return;
		}
		if (targ.deathtype == "knightspike")
		{
			bprint (" was vanquished by Death Knight's dark magic\n");
			return;
		}
		if (targ.deathtype == "enfspike")
		{
			bprint (" was blasted by an Enforcer\n");
			return;
		}
		if (targ.deathtype == "shal_missile")	
		{
			bprint (" was exploded by a Vore\n");
			return;
		}
		if (targ.deathtype == "ogre_grenade")	
		{
			if (attacker.classname == "trap_spikeshooter")
			{
				if (targ.health < targ.gibhealth)
					bprint (" was blown to pieces\n");
				else
					bprint (" perished in the blast\n");
			}
			else
				bprint (" was destroyed by an Ogre\n");
			return;
		}

		// tricks and traps

//		if (attacker.classname == "explo_box")
//		if (targ.deathtype == "barrel")
//		{
//			bprint (" blew up\n");
//			return;
//		}
		if (targ.deathtype == "falling")
		{
			bprint (" fell to his death\n");
			return;
		}
		if (targ.deathtype == "nail")
		{
			bprint (" was spiked\n");
			return;
		}
		if (targ.deathtype == "supernail")
		{
			bprint (" was nailed\n");
			return;
		}
		if (targ.deathtype == "laser")
		{
			bprint (" was lazed\n");
			return;
		}
#ifdef HIPNOTIC
		if (targ.deathtype == "hiplaser")
		{
			bprint (" was lasered\n");
			return;
		}
#endif
		if (attacker.classname == "fireball")
		{
			bprint (" ate a lavaball\n");
			return;
		}
		if (targ.deathtype == "rocket")
		{
			bprint (" caught a rocket up his ass\n");
			return;
		}
		if (targ.deathtype == "zap")
		{
			rnum = random();
			if (rnum < 0.5)
				bprint (" was zapped\n");
			else
				bprint (" was electrocuted\n");	
//			eprint(attacker);		
			return;
		}
#ifdef HIPNOTIC
		if (targ.deathtype == "exploder")
		{
			bprint (" blew up\n");
			return;
		}

		if (targ.deathtype == "impact")
		{
			rnum = random();
			if (rnum < 0.5)
				bprint (" suffered a lethal blunt trauma\n");
			else
				bprint (" was stoned to death\n");			
			return;
		}

		if (attacker.classname == "trap_gravity_well")
		{
			rnum = random();
			if (targ.waterlevel > LEVEL_FEET)
			{
				if (rnum < 0.5)
					bprint (" was sliced 'n' diced\n");
				else
					bprint (" was minced\n");
				return;
			}
			else
			{
				if (rnum < 0.5)
					bprint (" departs to prove the Einstein's theory\n");
				else
					bprint (" was sucked into the event horizon\n");
				return;
			}
		}
		if (attacker.classname == "trap_gods_wrath")
		{
			bprint (" suffers the wrath of God\n");
			return;
		}
		if (attacker.classname == "func_rotate_entity")
		{
			bprint (" ");
			bprint (attacker.deathtype);
			bprint ("\n");
			return;
		}
		if (attacker.classname == "func_rotate_train")
		{
			bprint (" ");
			bprint (attacker.deathtype);
			bprint ("\n");
			return;
		}
#endif
		if (attacker.classname == "trigger_changelevel")
		{
			bprint (" tried to leave\n");
			return;
		}

		// in-water deaths
		if (targ.deathtype == "drowning")
		if (targ.watertype == CONTENT_WATER)
		{
			rnum = random();
			if (rnum < 0.5)
				bprint (" sleeps with the fishes\n");
			else
				bprint (" sucks it down\n");
			return;
		}

		if (targ.deathtype == "drowning2")
		{
			if (targ.watertype == CONTENT_SLIME)
			{
				rnum = random();
				if (rnum < 0.5)
					bprint (" gulped a load of slime\n");
				else
					bprint (" can't exist on slime alone\n");
				return;
			}
			if (targ.watertype == CONTENT_LAVA)
			{
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					return;
				}
				rnum = random();				
				if (rnum < 0.5)
					bprint (" turned into hot slag\n");
				else
					bprint (" visits the Volcano God\n");
				return;
			}
		}

		// hell if I know; he's just dead!!!
		bprint (" died\n");
	}
};
