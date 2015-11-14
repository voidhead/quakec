float(float type, float amount) CheckAmmo =
{
	local float ammo; 

	switch (type)
	{
	  case -1:	// doesn't need ammo
		return TRUE;
	    
	  case 0:	// fallthrough
		return TRUE;

	  case 5:	// check for everything
		ammo =  getstati(STAT_SHELLS) +
			getstati(STAT_NAILS) +
			getstati(STAT_ROCKETS) +
			getstati(STAT_CELLS);

		return (!ammo) ? FALSE : TRUE;

	  default:
		ammo = getstati(type);
	
		if (!amount)
			amount = 1;
		if (!ammo)
			return FALSE;
		else if (ammo >= amount)
			return TRUE;
		else 
			return -1;
	}
};


float(float type) CheckWeapon =
{
	local float i, items, titems;

	items = getstatb(STAT_ITEMS, 0, 24);	//GetStat_FLOAT_TRUNCATED(STAT_ITEMS); 	//GetStat_BITS(STAT_ITEMS, 0, 24);

	if (type == -1)		//check if we have nothing at all
	{
		for (i=0; i<=3; i++)
		{
				if (slot1impulse[i])
					titems += items & slot1item[i];
				if (slot2impulse[i])
					titems += items & slot2item[i];
				if (slot3impulse[i])
					titems += items & slot3item[i];
				if (slot4impulse[i])
					titems += items & slot4item[i];
				if (slot5impulse[i])
					titems += items & slot5item[i];
		}

		return (titems) ? FALSE : TRUE;
	}

	if (items & type)
			return TRUE;
	else
			return FALSE;
};


void(float impulse) SwitchWeapon =
{
	local string cmd;

	cmd = strcat("impulse ", ftos(impulse), "\n");
	localcmd(cmd);
};


float() GetCurrentWeapon =
{
	return getstati(STAT_ACTIVEWEAPON);
};

float() AdvanceInSlot =
{
	slot_nextpos += 1;

	if (slot_nextpos == slot_currentpos)
		slot_nextpos += 1;

	if (slot_nextpos > 3 && !slot_fullcheck)
	{
		slot_nextpos = 0;
		slot_fullcheck = 1;
	}
	if ((slot_fullcheck) && (slot_nextpos == slot_currentpos))
		return FALSE;
	else
		return TRUE;
};

float(float slot) ChangeWeaponSlot =
{
//	print ("CSQC: Switching weapon slot ", ftos(slot), "\n");

	local float currentweapon;
	local float i;
	float result;

	if (CheckWeapon(-1)) 		//no weapons!
		return WC_NOWEAPON;

	if (!CheckAmmo(5, 0)) 		//totally out of ammo
		return WC_NOAMMO;

			currentweapon = GetCurrentWeapon();
//			print("current weapon is ", ftos(currentweapon), "\n");

			slot_currentpos = -1;
			slot_nextpos = -1;
			slot_foundpos = -1;
			slot_fullcheck = 0;
			result = -1;

	switch (slot) {

//====== SLOT 1 ============================================================================================================
		case 1:

			for (i=0; i<=3; i=i+1)		// try to find current weapon in this slot
			{
				if (currentweapon == slot1item[i])
				{
					slot_currentpos = i;	// found something
					break;
				}
			}

			if (slot_currentpos == -1)		// nothing found - maybe not this slot
			{
//				print("current weapon not found in slot1!\n");
				slot_nextpos = -1;
			}

//			else if (slot_currentpos > 0)
//			{
//				print("found current weapon in slot1 with index=", ftos(slot_currentpos), " and impulse=", ftos(slot1impulse[slot_currentpos]), "\n");
//				print("current slot1 pos=", ftos(currentpos), "\n"); 
//				slot_nextpos = slot_currentpos;
//				slot_nextpos = -1;
//			}

			else
			{
				slot_nextpos = slot_currentpos;
			}

			while (AdvanceInSlot())
			{
//				print("checking slot1 pos=", ftos(slot_nextpos), "\n"); 

				if (slot1impulse[slot_nextpos])				// see if we have a defined impulse
				{	
					if (CheckWeapon(slot1item[slot_nextpos]))	// and the weapon
					{
						if (CheckAmmo(slot1ammo[slot_nextpos], slot1ammo2[slot_nextpos]) > 0)	// and some ammo
						{
//							print("found slot1 pos=", ftos(slot_nextpos), "\n"); 
							slot_foundpos = slot_nextpos;	// we must switch now
							result = WC_SUCCESS;
							break;
						}
						else
						{
//							print("not enough ammo slot1 pos=", ftos(slot_nextpos), "\n"); 
							if (CheckAmmo(slot1ammo[slot_nextpos], slot1ammo2[slot_nextpos]) == -1)
								result = WC_LOWAMMO;
							else
								result = WC_NOAMMO;
							continue;
						}
					}
					else
					{
//						print("no weapon slot1 pos=", ftos(slot_nextpos), "\n"); 
						result = WC_NOWEAPON;
						continue;
					}
				}
				else
				{
					if (slot_fullcheck)
					{
//						result = WC_NOCHANGE; 	// made full loop through the slot - bail out
						break;
					}
//					print("checking next in slot1\n"); 
					continue;
				}
			}

			if ((slot_foundpos != -1) && (result < 1))
			{
//				print("switching to impulse=", ftos(slot_foundpos), "\n"); 
				SwitchWeapon(slot1impulse[slot_foundpos]);
			}
	
			return result;

//====== SLOT 2 ============================================================================================================
		case 2:   

			for (i=0; i<=3; i=i+1)		// try to find current weapon in this slot
			{
				if (currentweapon == slot2item[i])
				{
					slot_currentpos = i;	// found something
					break;
				}
			}

			if (slot_currentpos == -1)		// nothing found - maybe not this slot
			{
//				print("current weapon not found in slot2!\n");
//				return WC_NOCHANGE;
				slot_nextpos = -1;
			}

			else
			{
//				print("found current weapon in slot2 with index=", ftos(currentpos), " and impulse=", ftos(slot2impulse[currentpos]), "\n");
//				print("current slot2 pos=", ftos(currentpos), "\n"); 
				slot_nextpos = slot_currentpos;
			}

			while (AdvanceInSlot())
			{
//				print("checking slot2 pos=", ftos(nextpos), "\n"); 

				if (slot2impulse[slot_nextpos])				// see if we have a defined impulse
				{	
					if (CheckWeapon(slot2item[slot_nextpos]))	// and the weapon
					{
						if (CheckAmmo(slot2ammo[slot_nextpos], slot2ammo2[slot_nextpos]) > 0)	// and some ammo
						{
//							print("found slot2 pos=", ftos(nextpos), "\n"); 
							slot_foundpos = slot_nextpos;	// we must switch now
							result = WC_SUCCESS;
							break;
						}
						else
						{
//							print("not enough ammo slot2 pos=", ftos(nextpos), "\n"); 
							if (CheckAmmo(slot2ammo[slot_nextpos], slot2ammo2[slot_nextpos]) == -1)
								result = WC_LOWAMMO;
							else
								result = WC_NOAMMO;
							continue;
						}
					}
					else
					{
//						print("no weapon slot2 pos=", ftos(nextpos), "\n"); 
						result = WC_NOWEAPON;
						continue;
					}
				}
				else
				{
					if (slot_fullcheck)
					{
//						result = WC_NOCHANGE; 	// made full loop through the slot - bail out
						break;
					}
//					print("checking next slot2 pos\n"); 
					continue;
				}
			}

			if ((slot_foundpos != -1) && (result < 1))
			{
//				print("switching to impulse=", ftos(foundpos), "\n"); 
				SwitchWeapon(slot2impulse[slot_foundpos]);
			}
	
			return result;

//====== SLOT 3 ============================================================================================================
		case 3:  

			for (i=0; i<=3; i=i+1)		// try to find current weapon in this slot
			{
				if (currentweapon == slot3item[i])
				{
					slot_currentpos = i;	// found something
					break;
				}
			}

			if (slot_currentpos == -1)		// nothing found - maybe not this slot
			{
//				print("current weapon not found in slot3!\n");
//				return WC_NOCHANGE;
				slot_nextpos = -1;
			}

			else
			{
//				print("found current weapon in slot3 with index=", ftos(currentpos), " and impulse=", ftos(slot3impulse[currentpos]), "\n");
//				print("current slot3 pos=", ftos(currentpos), "\n"); 
				slot_nextpos = slot_currentpos;
			}

			while (AdvanceInSlot())
			{
//				print("checking slot3 pos=", ftos(nextpos), "\n"); 

				if (slot3impulse[slot_nextpos])				// see if we have a defined impulse
				{	
					if (CheckWeapon(slot3item[slot_nextpos]))	// and the weapon
					{
						if (CheckAmmo(slot3ammo[slot_nextpos], slot3ammo2[slot_nextpos]) > 0)	// and some ammo
						{
//							print("found slot3 pos=", ftos(nextpos), "\n"); 
							slot_foundpos = slot_nextpos;	// we must switch now
							result = WC_SUCCESS;
							break;
						}
						else
						{
//							print("not enough ammo slot3 pos=", ftos(nextpos), "\n"); 
							if (CheckAmmo(slot3ammo[slot_nextpos], slot3ammo2[slot_nextpos]) == -1)
								result = WC_LOWAMMO;
							else
								result = WC_NOAMMO;
							continue;
						}
					}
					else
					{
//						print("no weapon slot3 pos=", ftos(nextpos), "\n"); 
						result = WC_NOWEAPON;
						continue;
					}
				}
				else
				{
					if (slot_fullcheck)
					{
//						result = WC_NOCHANGE; 	// made full loop through the slot - bail out
						break;
					}
//					print("checking next slot3 pos\n"); 
					continue;
				}
			}

			if ((slot_foundpos != -1) && (result < 1))
			{
//				print("switching to impulse=", ftos(foundpos), "\n"); 
				SwitchWeapon(slot3impulse[slot_foundpos]);
			}
	
			return result;

//====== SLOT 4 ============================================================================================================
		case 4:  

			for (i=0; i<=3; i=i+1)		// try to find current weapon in this slot
			{
				if (currentweapon == slot4item[i])
				{
					slot_currentpos = i;	// found something
					break;
				}
			}

			if (slot_currentpos == -1)		// nothing found - maybe not this slot
			{
//				print("current weapon not found in slot4!\n");
//				return WC_NOCHANGE;
				slot_nextpos = -1;
			}

			else
			{
//				print("found current weapon in slot4 with index=", ftos(currentpos), " and impulse=", ftos(slot4impulse[currentpos]), "\n");
//				print("current slot4 pos=", ftos(currentpos), "\n"); 
				slot_nextpos = slot_currentpos;
			}

			while (AdvanceInSlot())
			{
//				print("checking slot4 pos=", ftos(nextpos), "\n"); 

				if (slot4impulse[slot_nextpos])				// see if we have a defined impulse
				{	
					if (CheckWeapon(slot4item[slot_nextpos]))	// and the weapon
					{
						if (CheckAmmo(slot4ammo[slot_nextpos], slot4ammo2[slot_nextpos]) > 0)	// and some ammo
						{
//							print("found slot4 pos=", ftos(nextpos), "\n"); 
							slot_foundpos = slot_nextpos;	// we must switch now
							result = WC_SUCCESS;
							break;
						}
						else
						{
//							print("not enough ammo slot4 pos=", ftos(nextpos), "\n"); 
							if (CheckAmmo(slot4ammo[slot_nextpos], slot4ammo2[slot_nextpos]) == -1)
								result = WC_LOWAMMO;
							else
								result = WC_NOAMMO;
							continue;
						}
					}
					else
					{
//						print("no weapon slot4 pos=", ftos(nextpos), "\n"); 
						result = WC_NOWEAPON;
						continue;
					}
				}
				else
				{
					if (slot_fullcheck)
					{
//						result = WC_NOCHANGE; 	// made full loop through the slot - bail out
						break;
					}
//					print("checking next slot4 pos\n"); 
					continue;
				}
			}

			if ((slot_foundpos != -1) && (result < 1))
			{
//				print("switching to impulse=", ftos(foundpos), "\n"); 
				SwitchWeapon(slot4impulse[slot_foundpos]);
			}
	
			return result;

//====== SLOT 5 ============================================================================================================
		case 5:  

			for (i=0; i<=3; i=i+1)		// try to find current weapon in this slot
			{
				if (currentweapon == slot5item[i])
				{
					slot_currentpos = i;	// found something
					break;
				}
			}

			if (slot_currentpos == -1)		// nothing found - maybe not this slot
			{
//				print("current weapon not found in slot5!\n");
//				return WC_NOCHANGE;
				slot_nextpos = -1;
			}

			else
			{
//				print("found current weapon in slot5 with index=", ftos(currentpos), " and impulse=", ftos(slot5impulse[currentpos]), "\n");
//				print("current slot5 pos=", ftos(currentpos), "\n"); 
				slot_nextpos = slot_currentpos;
			}

			while (AdvanceInSlot())
			{
//				print("checking slot5 pos=", ftos(nextpos), "\n"); 

				if (slot5impulse[slot_nextpos])				// see if we have a defined impulse
				{	
					if (CheckWeapon(slot5item[slot_nextpos]))	// and the weapon
					{
						if (CheckAmmo(slot5ammo[slot_nextpos], slot5ammo2[slot_nextpos]) > 0)	// and some ammo
						{
//							print("found slot5 pos=", ftos(nextpos), "\n"); 
							slot_foundpos = slot_nextpos;	// we must switch now
							result = WC_SUCCESS;
							break;
						}
						else
						{
//							print("not enough ammo slot5 pos=", ftos(nextpos), "\n"); 
							if (CheckAmmo(slot5ammo[slot_nextpos], slot5ammo2[slot_nextpos]) == -1)
								result = WC_LOWAMMO;
							else
								result = WC_NOAMMO;
							continue;
						}
					}
					else
					{
//						print("no weapon slot5 pos=", ftos(nextpos), "\n"); 
						result = WC_NOWEAPON;
						continue;
					}
				}
				else
				{
					if (slot_fullcheck)
					{
//						result = WC_NOCHANGE; 	// made full loop through the slot - bail out
						break;
					}
//					print("checking next slot5 pos\n"); 
					continue;
				}
			}

			if ((slot_foundpos != -1) && (result < 1))
			{
//				print("switching to impulse=", ftos(foundpos), "\n"); 
				SwitchWeapon(slot5impulse[slot_foundpos]);
			}
	
			return result;

		default:
				return WC_NOCHANGE;

	}
};
