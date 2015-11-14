float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};

vector(vector v) anglemod_vec =
{
//	return anglemod(v_x)*'1 0 0' + anglemod(v_y)*'0 1 0' + anglemod(v_z)*'0 0 1';
	v_x -= floor(v_x/360)*360;
	v_y -= floor(v_y/360)*360;
	v_z -= floor(v_z/360)*360;
	return v;
};

vector(vector v) anglemod_view =
{
	while (v_x > 180)
		v_x = v_x - 360;
	while (v_y > 180)
		v_y = v_y - 360;
	while (v_z > 180)
		v_z = v_z - 360;

	while (v_x < -180)
		v_x = v_x + 360;
	while (v_y < -180)
		v_y = v_y + 360;
	while (v_y < -180)
		v_y = v_y + 360;

	return v;
};

float(float v) anglemod_ground =
{
	float n;

	while (v >= 180)
	{
		v = v - 180;	//0..180
		n++;
	}
	while (v < 0)
	{
		v = v + 180;	//-180..0
		n++;
	}

	if (v >= 0)
		v = 180*(n + rint(v/180));
	else
		v = -180*(n - rint(v/180));
		
	return v;
};

float() crandom =
{
	return 2*(random() - 0.5);
};

vector() crandomvec =
{
	local vector v;
	v_x = random() - 0.5; // scale doesn't matter because it's normalized
	v_y = random() - 0.5;
	v_z = random() - 0.5;
	v = normalize(v);
	return(v);
};

vector() randomdirvec =
{
	local vector v;
	do
	{
		do
		{
			v_x = random() - 0.5;
			v_y = random() - 0.5;
			v_z = random() - 0.5;
		}
		while (vlen(v) > 0.25);
	}
	while (vlen(v) < 0.1);
	
	v = normalize(v);
	return v;
};

void(float n) bprintfloat =
{
	local string s;
	s = ftos(n);
	bprint(s);
};

void(vector n) bprintvector =
{
	local string s;
	s = vtos(n);
	bprint(s);
};

void(float n) dprintfloat =
{
	local string s;
	s = ftos(n);
	dprint(s);
};

/*
void(vector n) printvector =
{
	print("'");
	print(ftos(n_x));
	print(" ");
	print(ftos(n_y));
	print(" ");
	print(ftos(n_z));
	print("'");
//	print("\n");
};
*/

void(vector n) printvector =
{
	print("'", ftos(n_x), " ", ftos(n_y), " ", ftos(n_z), "'\n");
};

vector(vector m1, vector m2) randompos =
{
	local vector v;
	m2 = m2 - m1;
	v_x = m2_x * random() + m1_x;
	v_y = m2_y * random() + m1_y;
	v_z = m2_z * random() + m1_z;
	return  v;
};

vector(vector vec) vreverse = 
{
	local vector vinv;
	
	vinv_x = 0 - vec_x;
	vinv_y = 0 - vec_y;
	vinv_z = 0 - vec_z;

	return vinv;
};

vector(vector a, vector b) crossproduct =
{
	local vector vec;

	vec_x = a_y*b_z - a_z*b_y;
	vec_y = a_z*b_x - a_x*b_z;
	vec_z = a_x*b_y - a_y*b_x;

	return vec;
};

vector (vector vec, vector axis, float angle_sin) vrotate =
{
	local vector out;
	local float angle_cos;

	angle_cos = sqrt(1 - pow(angle_sin, 2));

	out_x = ( angle_cos + (1 - angle_cos)*pow(axis_x, 2)       ) * vec_x + 
		( (1 - angle_cos)*axis_x*axis_y - angle_sin*axis_z ) * vec_y + 
		( (1 - angle_cos)*axis_x*axis_z + angle_sin*axis_y ) * vec_z;

	out_y = ( (1 - angle_cos)*axis_x*axis_y + angle_sin*axis_z ) * vec_x + 
		( angle_cos + (1 - angle_cos)*pow(axis_y, 2)       ) * vec_y + 
		( (1 - angle_cos)*axis_y*axis_z - angle_sin*axis_x ) * vec_z;

	out_z = ( (1 - angle_cos)*axis_x*axis_z - angle_sin*axis_y ) * vec_x + 
		( (1 - angle_cos)*axis_y*axis_z + angle_sin*axis_x ) * vec_y + 
		( angle_cos + (1 - angle_cos)*pow(axis_z, 2)       ) * vec_z;

	out = normalize(out);

	return out;
};

float(float r1, float r2) random2 =
{
	if (r1 >= r2)
		return 0;

	return (r1 + random()*(r2 - r1));
};

float(float a, float b) getrandom2 =
{
	if (random() > 0.5)
		return a;

	else return b;
};

// modulo division
float (float a, float b) mod =
{
	while (b)
		return floor(a/b);

	return 0;
};

// remainder from the modulo
float (float a, float b) rem =
{
	while (b)
		return rint(a - b*floor(a/b));

	return 0;
};