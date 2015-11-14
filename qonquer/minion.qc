/*
==============================================================================

MONSTER_MINION

==============================================================================
*/

void() monster_army_precache;
void() monster_dog_precache;
void() monster_enforcer_precache;
void() monster_fish_precache;
void() monster_hell_knight_precache;
void() monster_knight_precache;
void() monster_ogre_precache;
void() monster_shalrath_precache;
void() monster_shambler_precache;
void() monster_tarbaby_precache;
void() monster_wizard_precache;
void() monster_zombie_precache;
void() monster_demon1_precache;

void() monster_army_spawn;
void() monster_dog_spawn;
void() monster_enforcer_spawn;
void() monster_fish_spawn;
void() monster_hell_knight_spawn;
void() monster_knight_spawn;
void() monster_ogre_spawn;
void() monster_shalrath_spawn;
void() monster_shambler_spawn;
void() monster_tarbaby_spawn;
void() monster_wizard_spawn;
void() monster_zombie_spawn;
void() monster_demon1_spawn;

void(entity minionfactory) monster_minion_setclassname =
{
	if (minionfactory.minion_class == "army")
		self.classname = "monster_army";
	else if (minionfactory.minion_class == "dog")
		self.classname = "monster_dog";
	else if (minionfactory.minion_class == "enforcer")
		self.classname = "monster_enforcer";
	else if (minionfactory.minion_class == "fish")
		self.classname = "monster_fish";
	else if (minionfactory.minion_class == "hell_knight")
		self.classname = "monster_hell_knight";
	else if (minionfactory.minion_class == "knight")
		self.classname = "monster_knight";
	else if (minionfactory.minion_class == "ogre")
		self.classname = "monster_ogre";
	else if (minionfactory.minion_class == "shalrath")
		self.classname = "monster_shalrath";
	else if (minionfactory.minion_class == "shambler")
		self.classname = "monster_shambler";
	else if (minionfactory.minion_class == "tarbaby")
		self.classname = "monster_tarbaby";
	else if (minionfactory.minion_class == "wizard")
		self.classname = "monster_wizard";
	else if (minionfactory.minion_class == "zombie")
		self.classname = "monster_zombie";
	else
		self.classname = "monster_demon1";
};

/*QUAKED monster_minion (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_minion =
{
	if (self.minion_class == "army")
	{
		self.spawnfactory = monster_army_spawn;
		monster_army_precache();
	}
	else if (self.minion_class == "dog")
	{
		self.spawnfactory = monster_dog_spawn;
		monster_dog_precache();
	}
	else if (self.minion_class == "enforcer")
	{
		self.spawnfactory = monster_enforcer_spawn;
		monster_enforcer_precache();
	}
	else if (self.minion_class == "fish")
	{
		self.spawnfactory = monster_fish_spawn;
		monster_fish_precache();
	}
	else if (self.minion_class == "hell_knight")
	{
		self.spawnfactory = monster_hell_knight_spawn;
		monster_hell_knight_precache();
	}
	else if (self.minion_class == "knight")
	{
		self.spawnfactory = monster_knight_spawn;
		monster_knight_precache();
	}
	else if (self.minion_class == "ogre")
	{
		self.spawnfactory = monster_ogre_spawn;
		monster_ogre_precache();
	}
	else if (self.minion_class == "shalrath")
	{
		self.spawnfactory = monster_shalrath_spawn;
		monster_shalrath_precache();
	}
	else if (self.minion_class == "shambler")
	{
		self.spawnfactory = monster_shambler_spawn;
		monster_shambler_precache();
	}
	else if (self.minion_class == "tarbaby")
	{
		self.spawnfactory = monster_tarbaby_spawn;
		monster_tarbaby_precache();
	}
	else if (self.minion_class == "wizard")
	{
		self.spawnfactory = monster_wizard_spawn;
		monster_wizard_precache();
	}
	else if (self.minion_class == "zombie")
	{
		self.spawnfactory = monster_zombie_spawn;
		monster_zombie_precache();
	}
	else
	{
		// the minion is a demon by default unless overridden
		self.minion_class = "demon1";
		self.spawnfactory = monster_demon1_spawn;
		monster_demon1_precache();
	}

	if (self.spawnwavestart == 0)
		self.spawnwavestart = 1;
	if (self.spawnwaveend == 0)
		self.spawnwaveend = MAX_WAVE;
	if (self.spawnwaveend < self.spawnwavestart)
		self.spawnwaveend = self.spawnwavestart;
};
