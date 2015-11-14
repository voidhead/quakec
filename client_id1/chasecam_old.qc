void() ClientView = 
{
	local float chasecam, health; 
	local vector org, ang;

/*
chase_back is "48" ["48"] chase cam distance from the player
chase_overhead is "0" ["0"] chase cam looks straight down if this is not zero
chase_pitchangle is "55" ["55"] chase cam pitch angle
chase_stevie is "0" ["0"] (GOODVSBAD2 only) chase cam view from above
chase_up is "24" ["24"] chase cam distance from the player
*/
	org = pmove_org;
	ang = input_angles;		//vectoangles(input_movevalues);			//input_angles;

//	chasecam = cvar("chase_active");

	chasecam = autocvar_chase_active != FALSE;

	if (chasecam)
	{
		local float chase_back, chase_up, chase_pitch, temptan;	//, fov, fov2, newang;
		local vector chaseofs, clrot, chaseang;

		chase_back = autocvar_chase_back;
		chase_up = 2*autocvar_chase_up;
		chase_pitch = autocvar_chase_pitchangle;

		//fov = (M_PI * (cvar("fov"))) / 180;
		//fov2 = fov / 2;
		clrot_x = (M_PI * ang_x) / 180;	// yaw
		clrot_y = (M_PI * ang_y) / 180; // pitch
		clrot_z = (M_PI * ang_z) / 180;	// roll

		//newang = (chase_back * (sin(fov2) / cos(fov2)) * sin(clrot)) / (chase_back + chase_back * (sin(fov2) / cos(fov2)) * cos(clrot));
		//newang = (180 * newang) / M_PI;

		//chaseang_y = newang;		

		//chaseofs_x = -chase_back;
		//chaseofs_z = chase_up;

		//chaseofs_x = -chase_back * cos(clrot_y);
		//chaseofs_y = -chase_back * sin(clrot_y);
		//chaseofs_z = chase_up * cos(-clrot_x);

		temptan = sin(clrot_x) / cos(clrot_x);


		chaseofs_x = sqrt( 1 / ( 1 / pow(chase_back,2) + pow(temptan,2) / pow(chase_up,2) ) );
		chaseofs_z = 0.5*chase_up + chaseofs_x*temptan;		

		chaseofs_x = -chaseofs_x * cos(clrot_y);
		chaseofs_y = -chase_back * sin(clrot_y);

		if (ang_x == -90)
			chaseofs_z = -0.5 * chase_up;		

		if (ang_x == 90)
			chaseofs_z = 1.5 * chase_up;		
		
//		chaseang_x = chase_pitch;
		chaseang_x = (M_PI * chase_pitch) / 180;

//		print(ftos(clrot_x), " ", ftos(clrot_y), " ", ftos(clrot_z), "\n");
//		print(ftos(chaseofs_x), " ", ftos(chaseofs_y), " ", ftos(chaseofs_z), "\n");
				
		org += chaseofs;
		ang += chaseang;
	}

//	if (self.health <=0)
//		self.view_ofs = '0 0 0';

	health = getstati(STAT_HEALTH);

	if ( health <= -40)
		org -= CLIENT_VIEW_OFS_GIB;
	else if (health <= 0)
		org -= CLIENT_VIEW_OFS;

	if (!intermission)
		org += CLIENT_VIEW_OFS;

	setvieworg = org;

	if (health > 0)
		setviewang = ang;
	else
		setviewang = input_angles;

//	setvieworg = pmove_org;
//	setviewang = input_angles;		//vectoangles(input_movevalues);			//input_angles;

	return;
};


void() ClientView2 = 
{
	local float chasecam, health; 
	local vector org, ang;

/*
chase_back is "48" ["48"] chase cam distance from the player
chase_overhead is "0" ["0"] chase cam looks straight down if this is not zero
chase_pitchangle is "55" ["55"] chase cam pitch angle
chase_stevie is "0" ["0"] (GOODVSBAD2 only) chase cam view from above
chase_up is "24" ["24"] chase cam distance from the player
*/
	org = pmove_org;
	ang = input_angles;

	chasecam = autocvar_chase_active != FALSE;

	if (chasecam)
	{
		local float chase_back, chase_up, chase_pitch, temptan;	//, fov, fov2, newang;
		local vector chaseofs, clrot, chaseang;

		chase_back = autocvar_chase_back;
		chase_up = 2*autocvar_chase_up;
		chase_pitch = autocvar_chase_pitchangle;

		clrot_x = (M_PI * ang_x) / 180;	// yaw
		clrot_y = (M_PI * ang_y) / 180; // pitch
		clrot_z = (M_PI * ang_z) / 180;	// roll

		//newang = (chase_back * (sin(fov2) / cos(fov2)) * sin(clrot)) / (chase_back + chase_back * (sin(fov2) / cos(fov2)) * cos(clrot));
		//newang = (180 * newang) / M_PI;

		//chaseang_y = newang;		

		//chaseofs_x = -chase_back;
		//chaseofs_z = chase_up;

		//chaseofs_x = -chase_back * cos(clrot_y);
		//chaseofs_y = -chase_back * sin(clrot_y);
		//chaseofs_z = chase_up * cos(-clrot_x);

		temptan = sin(clrot_x) / cos(clrot_x);


		chaseofs_x = sqrt( 1 / ( 1 / pow(chase_back,2) + pow(temptan,2) / pow(chase_up,2) ) );
		chaseofs_z = 0.5*chase_up + chaseofs_x*temptan;		

		chaseofs_x = -chaseofs_x * cos(clrot_y);
		chaseofs_y = -chase_back * sin(clrot_y);

		if (ang_x == -90)
			chaseofs_z = -0.5 * chase_up;		

		if (ang_x == 90)
			chaseofs_z = 1.5 * chase_up;		
		
//		chaseang_x = chase_pitch;
		chaseang_x = 0 - (M_PI * chase_pitch) / 180;

//		print(ftos(clrot_x), " ", ftos(clrot_y), " ", ftos(clrot_z), "\n");
//		print(ftos(chaseofs_x), " ", ftos(chaseofs_y), " ", ftos(chaseofs_z), "\n");
				
		org += chaseofs;
		ang -= chaseang;
	}

	health = getstati(STAT_HEALTH);

	if (health <= -40)
		org -= CLIENT_VIEW_OFS_GIB;
	else if (health <= 0)
		org -= CLIENT_VIEW_OFS;

	if (!intermission)
		org += CLIENT_VIEW_OFS;

	setvieworg = org;

	if (health > 0)
		setviewang = ang;
	else
		setviewang = input_angles;

//	setvieworg = pmove_org;
//	setviewang = input_angles;

	return;
};
