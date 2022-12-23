
vs .1 .1

mov r4, v0 ; position
mov r5, v3 ; normal

mov r4.w, c[0].x
mov r5.w, c[0].y

mad r4 , r5, c[0].z, r4
#line 5 "C:\\romans\\shaders\\fragments\\burning_man.vsh"
m4x4 oT0, v4, c[8]

mov oT1, v4

dp4 r6.x, r4, c[1 + 0]
dp4 r6.y, r4, c[1 + 1]
dp4 r6.z, r4, c[1 + 2]
dp4 r6.w, r4, c[1 + 3]

mov oPos, r6
#line 14 "mesh_fire.vsh"
mul r8.x, -c[0].w, r6.z ; - (fog_exp_density * z_dist)
exp oFog, r8.x ; evaluate exponential function (2^ ( -fog_exp_density * z_dist))
#line 18 "mesh_fire.vsh"
mov oD0, c[0].x 
mov oD1, c[0].yyyy 
mov oFog, c[0].y
