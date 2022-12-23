#line 3 "C:\\romans\\shaders\\ffp.vsh"
vs .1 .1
mov r4, v0 ; position
mov r5, v3 ; normal
; Do the lighting calculation
dp3 r0.x, r5, -c[1] ; normal dot light
mul r1, r0.x, c[6] ; multiply with light diffuse
mov r1.w, c[0].x ; set alpha to one
max r1, r1, c[0].z
add r1, r1, c[7] ; Add in ambient
mov r7, c[0].zzzz
mov oT0, v4

dp4 r6.x, r4, c[2 + 0]
dp4 r6.y, r4, c[2 + 1]
dp4 r6.z, r4, c[2 + 2]
dp4 r6.w, r4, c[2 + 3]

mov oPos, r6
mov oD0, r1
mov oD1,	r7
mul r8.x, -c[0].y, r6.z ; - (fog_exp_density * z_dist)
exp oFog, r8.x ; evaluate exponential function (2^ ( -fog_exp_density * z_dist))
#line 13 "C:\\romans\\shaders\\ffp.vsh"
mov oT1,	v4 
m4x4 oT1, r4, c[11]
