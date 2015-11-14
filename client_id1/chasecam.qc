float(float v) anglemod =
{
	while (v > 180)
		v = v - 360;

	while (v < -180)
		v = v + 360;

	return v;
};

void() AdjustChasecam =
{
	local float health;
	local vector view_ofs;

	local float horz, vert, ang_new;
	local vector org, org2, end, end2, dir1, dir2, ang, ang2, ang3;

	health = getstati(STAT_HEALTH);
	view_ofs = '0 0 1'*getstati(STAT_VIEWHEIGHT);

	if (autocvar_chase_active != FALSE)
	{
		ang = input_angles;

		makevectors(input_angles);

		dir1 = v_forward;

		org = pmove_org + view_ofs;
		end = org + 2048*v_forward;

		traceline(org, end, MOVE_NORMAL, world);
		end2 = trace_endpos;	// + 2*v_forward;

		org2 = org - v_forward*autocvar_chase_back + v_up*autocvar_chase_up;
		dir2 = end2 - org2;

		ang2 = org - v_forward*autocvar_chase_back + v_up*autocvar_chase_up - trace_endpos;

		vert = ang2_z;
		ang2_z = 0;
		horz = vlen(ang2);
		
		ang_new = anglemod(90 - RAD2DEG*atan2(horz, vert));

		ang_x = ang_new;

		ang3 = input_angles;

		if (input_angles_x > 90 - autocvar_chase_pitchangle)
			ang3_x = 90 - autocvar_chase_pitchangle;
		if (input_angles_x < -90 + autocvar_chase_pitchangle)
			ang3_x = -90 + autocvar_chase_pitchangle;

		setproperty(VF_CL_VIEWANGLES, ang3);
		setproperty(VF_ANGLES, ang);

		if (health < 1 && health > -40)
			setproperty(VF_ORIGIN, org2 + '0 0 22');
		else if (health <= -40)
			setproperty(VF_ORIGIN, org2);	// + '0 0 14');
		else
			setproperty(VF_ORIGIN, org2);
	}
	else
	{
		setproperty(VF_CL_VIEWANGLES, input_angles);

		if (health >= 1)
			setproperty(VF_ORIGIN, pmove_org + view_ofs + view_punchvector);
		else if (health > -40)
			setproperty(VF_ORIGIN, pmove_org);		
		else
			setproperty(VF_ORIGIN, pmove_org);	// - '0 0 1');						
	}

/*	}
	else
	{
//			print(ftos(view_ofs_z), "\n");

		if (chasecam)
		{
//			setproperty(VF_ANGLES, input_angles);
			setproperty(VF_ORIGIN, pmove_org + view_ofs + 2*'0 0 22');
		}
		else
		{
//			setproperty(VF_ANGLES, input_angles);
//			setproperty(VF_ORIGIN, pmove_org - '0 0 8');
			setproperty(VF_ORIGIN, pmove_org + view_ofs + '0 0 22');
			setproperty(VF_ORIGIN, pmove_org + '0 0 22');
		}
	}
*/	
};