/*
float(float yaw, float dist) walkmove =
{
	float result;

	if(self.flags & FL_MONSTER)
		SemisolidPreThink();
	
	result = real_walkmove(yaw, dist);
	
	if(self.flags & FL_MONSTER)
		SemisolidPostThink();

	return result;
}


float(float yaw, float dist) droptofloor =
{
	float result;

	if (self.flags & FL_MONSTER)
		SemisolidPreThink();
	
	result = real_droptofloor(yaw, dist);
	
	if (self.flags & FL_MONSTER)
		SemisolidPostThink();

	return result;
}
*/
/*
void(entity attacker, float damage) Wiz_Pain =
{
	wiz_pain(attacker, damage);
}
*/
/*
void() CastLightning =
{
	sham_lightning();
};
*/


void() SUB_regen =
{
	SUB_Regen();
};


/*
void(entity ent, void() framefunc) BecomeCorpse =
{
	make_corpse(ent, framefunc);
};

void(void() framefunc) MonsterBecomeCorpse =
{
	monster_corpse(framefunc);	
};
*/
