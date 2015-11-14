/*
=============
camerathink

camera think function
==============
*/
/*
void() camerathink =
   {
   local entity   pl;
   local vector   d_diff;
   local vector   a_diff;
   local vector   p;
   local vector   a;
   local float    dist;
   local float    timeelapsed;

   timeelapsed = (time - self.cnt) * self.duration;
   if ( timeelapsed > 1 )
      timeelapsed = 1;

   p = self.oldorigin + (timeelapsed * (self.movetarget.origin - self.oldorigin));
   d_diff = p - self.origin;

   a = self.mangle + (timeelapsed * (self.movetarget.mangle - self.mangle));
   a_diff = a - self.angles;

   self.origin = self.origin + self.pos1 + (1.0 * d_diff);
   self.angles = self.v_angle = self.angles + self.avelocity + (1.0 * a_diff);

   self.nextthink = time + 0.1;
   };
*/
/*
=============
camerachase

camera chase function
==============
*/
/*
void() camerachase =
   {
   local float    timeelapsed;
   local vector v;
   local vector a;


   timeelapsed = time - self.cnt;
   if ( timeelapsed > 1 )
      timeelapsed = 1;
   self.cnt = time;

   self.velocity = (self.movetarget.origin - self.oldorigin)*(1/timeelapsed);
   self.oldorigin = self.movetarget.origin;
   if (self.state == 0) // setup
      {
      self.velocity = '0 0 0';
      self.cnt = time;
      }
   // calculate new camera position
   a = '0 0 0';
   a_y = vectoyaw( normalize( self.movetarget.origin - self.movetarget.movetarget.origin) );
   makevectors(a);
   self.origin = self.movetarget.origin + v_forward * self.distance;
   self.origin_z = self.origin_z + self.height;

   v = normalize( self.movetarget.origin - self.origin );
   a = self.angles;
   a_y = vectoyaw(v);
   v_x = v_y;
   v_y = 0 - v_z;
   a_x = vectoyaw(v);
   self.angles = a;
//   SetViewPoint(self, self);
//   UpdateCamera(self, self);
   SetViewAngle(self, a);

   self.think = camerachase;
   self.nextthink = time + 0.1;
   };
*/

/*
=============
camerafollow

camera follow function
==============
*/
/*
void() camerafollow =
   {
   local vector v;
   local vector a;

   v = normalize( self.movetarget.origin - self.origin );
   a = self.angles;
   a_y = vectoyaw(v);
   v_x = v_y;
   v_y = 0 - v_z;
   a_x = vectoyaw(v);
   self.angles = a;
   SetViewAngle(self, a);

   self.think = camerafollow;
   self.nextthink = time + 0.01;
   };
*/
/*
=============
t_cameratarget

a camera has reached a path trigger
==============
*/
/*
void() t_cameratarget =
{
local entity	temp;

	if (other.movetarget != self)
		return;

	temp = self;
	self = other;
	other = temp;

   self.angles = self.movetarget.mangle;
   self.movetarget = find (world, targetname, other.target);
   if (!self.movetarget)
      {
      self.nextthink = time + 999999;
      }
   else
      {
      local vector   d_diff;
      local vector   a_diff;
      local float    t;

      self.think = camerathink;
      self.duration = 1 / other.duration;
      self.cnt = time;

      self.oldorigin = self.origin;
      d_diff = self.movetarget.origin - self.oldorigin;
      self.pos1 = d_diff*self.duration;

      self.mangles = self.angles;
      a_diff = self.movetarget.mangle - self.mangle;
      self.avelocity = a_diff*self.duration;
      if (other.delay)
         {
         self.nextthink = time + other.delay;
         self.cnt = time + other.delay;
         }
      }
};
*/

/*QUAKED path_camera (0.5 0.3 0) (-8 -8 -8) (8 8 8)
path for a camera
"delay" delay to wait before proceeding to next segment;
"mangle" position the camera should be when it gets here
"duration" how long it should take to cover the distance
           (default 10 seconds)
*/
/*
void() path_camera =
{
	self.solid = SOLID_TRIGGER;
   self.touch = t_cameratarget;
   if (!self.duration)
      self.duration = 10;
	setsize (self, '-8 -8 -8', '8 8 8');
};
*/

void(entity me, entity camera) UpdateCamera =
{
	msg_entity = me;                         	// target of message
	WriteByte (MSG_ONE, SVC_UPDATEENTITY | 15); 	// 0x80|1|2|4|8
	WriteByte (MSG_ONE, 64); 			// 0x40
	WriteEntity (MSG_ONE,camera);
	WriteCoord (MSG_ONE,camera.origin_x);
	WriteCoord (MSG_ONE,camera.origin_y);
	WriteCoord (MSG_ONE,camera.origin_z);
};


//void() effect_finale_think =
//   {
//   self.flags = self.flags - (self.flags & FL_ONGROUND);
//   self.angles = self.mangle;
//   self.v_angle = self.mangle;
//   self.fixangle = TRUE;
//   NezuUpdateCamera(self,self.trigger_field);
//   NezuSetViewPoint(self,self.trigger_field);
//   NezuSetViewAngle(self,self.mangle);
//   self.think = effect_finale_think;
//   self.nextthink = time + 0.05;
//   };


void() effect_finale_use =
{
	local	entity   pos, pl, targ;
//	local	entity   temp;
	
	if (self.state == 1)
		return;
	
//	intermission_exittime = time + 10000000;  // never allow exit
//	intermission_running = 1;
	self.state = 1;
	
	// find the intermission spot
	pos = find (world, targetname, self.target);

	if (!pos)
		error ("no target in finale");
	
//	WriteByte (MSG_ALL, SVC_FINALE);
	WriteByte (MSG_ALL, SVC_CUTSCENE);
	WriteString (MSG_ALL, "");
	
	// setup decoy
	if (!(self.spawnflags & CAMERA_NODECOY))
	{
		if (self.spawnflags & CAMERA_USEPLAYER)
		{
			pl = find (world, classname, "player");
			targ = find (world, targetname, self.mdl);
			become_decoy (targ.target, pl.origin);
		}
		else
		{
			targ = find (world, targetname, self.mdl);
			become_decoy (targ.target, targ.origin);
		}
	}
	
	pl = find (world, classname, "player");

	while (pl != world)
	{
		pl.view_ofs = '0 0 0';
		pl.angles = other.v_angle = pos.mangle;
		pl.mangle = pos.mangle;
		pl.fixangle = TRUE;     // turn this way immediately
		pl.trigger_field = self;
		pl.nextthink = time + 0.5;
		pl.takedamage = DAMAGE_NO;
		pl.solid = SOLID_NOT;
		pl.movetype = MOVETYPE_NONE;
		pl.modelindex = 0;
		setorigin (pl, pos.origin);
		pl.origin = pos.origin;
		pl.oldorigin = pos.origin;

		UpdateCamera(pl, pl);
		UpdateCamera(pl, pl.trigger_field);

		pl = find (pl, classname, "player");
	}
	
	// wait for next sequence
	if (self.spawnfunction)
	{
		self.nextthink = time + self.wait;
		self.think = self.spawnfunction;
	}

//	intermission_running = FALSE;
};

/*
 "count" 0 - static camera
       1 - path camera
       2 - chase camera
 "distance" distance from chase guy
         (default 100)
 "height" height distance from chase guy
         (default 64)
*/

/*QUAKED effect_finale (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) useplayer nodecoy
 start the finale sequence
 "target" the camera to go to.
 "mdl" if useplayer is specified, this is a
 path corner with target of the next
 path_corner to run to.
 if use player isn't specified this becomes
 the spawn point as well.
 "spawnfunction" next routine to run
 "delay" time to wait until running routine
 useplayer - use the current player as
             decoy location.
 nodecoy - no decoy, only the camera
*/
void() effect_finale =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	setorigin(self,self.origin);
	self.angles = self.mangle;
	self.use = effect_finale_use;
//	setsize(self,'-16 -16 -16','16 16 16');
//	self.touch = effect_finale_use;
//	InitTrigger ();
	self.state = 0;
};
	
void() info_startendtext_use =
{
	intermission_running = TRUE;
	ExitIntermission();
};

/*QUAKED info_startendtext (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
start the end text
*/
void() info_startendtext =
{
	self.use = info_startendtext_use;
};