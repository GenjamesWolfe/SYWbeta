#line 3 "dead_person.vsh"
vs .1 .1
mov r4, v0 ; position
mov r5, v3 ; normal
; Do the lighting calculation
dp3 r0.x, r5, -c[1] ; normal dot light
mul r1, r0.x, c[6] ; multiply with light diffuse
mov r1.w, c[0].x ; set alpha to one
max r1, r1, c[0].z
add r1, r1, c[7] ; Add in ambient
mul r8.x, -c[0].y, r6.z ; - (fog_exp_density * z_dist)
exp oFog, r8.x ; evaluate exponential function (2^ ( -fog_exp_density * z_dist))
mov r7, c[0].zzzz
mov oT0, v4

m4x4 r6, r4, c[2]
mov oPos, r6
mov oD0, r1
mov oD1,	r7
#line 13 "dead_person.vsh"
mov oT1,	v4 
