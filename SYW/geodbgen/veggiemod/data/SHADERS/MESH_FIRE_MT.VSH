
vs .1 .1

mov r4, v0 ; position
mov r5, v3 ; normal

mov r4.w, c[0].x
mov r5.w, c[0].y

dp4 r6.x, r4, c[1 + 0]
dp4 r6.y, r4, c[1 + 1]
dp4 r6.z, r4, c[1 + 2]
dp4 r6.w, r4, c[1 + 3]

mov oPos, r6
#line 13 "mesh_fire_mt.vsh"
mul r8.x, -c[0].w, r6.z ; - (fog_exp_density * z_dist)
exp oFog, r8.x ; evaluate exponential function (2^ ( -fog_exp_density * z_dist))
#line 17 "mesh_fire_mt.vsh"
mov oD0, c[14] 
mov oD1, c[0].yyyy 
mov oFog, c[0].y
mov oT0, v4
m4x4 oT1, v4, c[8]
