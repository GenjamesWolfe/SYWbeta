#line 3 "C:\\romans\\shaders\\ffp_addlight1.vsh"
vs .1 .1
mov r4, v0 ; position
mov r5, v3 ; normal

; normal dot light1
dp3 r0.x, r5, -c[1]

; normal dot light2
dp3 r0.y, r5, -c[20]

; clamp both it to 0
max r0.xy, r0.xy, c[0].z

; start with ambient
mov r1,	c[7]

; add light1 colour * intensity
mad r1.xyz,	r0.x, c[6], r1

; add light2 colour * intensity
mad r1.xyz,	r0.y, c[21], r1
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
#line 13 "C:\\romans\\shaders\\ffp_addlight1.vsh"
mov oT1,	v4 
mov	oT1, v4
m4x4 oT2, r4, c[11]
