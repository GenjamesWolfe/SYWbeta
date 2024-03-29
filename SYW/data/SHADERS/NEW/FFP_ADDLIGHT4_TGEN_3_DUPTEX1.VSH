#line 3 "C:\\romans\\shaders\\ffp_addlight4.vsh"
vs .1 .1
mov r4, v0 ; position
mov r5, v3 ; normal

; normal dot light1
dp3 r0.x, r5, -c[1]

; normal dot light2
dp3 r0.y, r5, -c[20]

; normal dot light2
dp3 r0.z, r5, -c[22]

; normal dot light3
dp3 r0.w, r5, -c[17]
#line 15 "C:\\romans\\shaders\\fragments\\light_addlight4_diffuse_dir.vsh"
; clamp them all to 0
max r0.xyzw, r0.xyzw, c[0].z

; start with ambient
mov r1,	c[7]
#line 22 "C:\\romans\\shaders\\fragments\\light_addlight4_diffuse_dir.vsh"
; add light1 colour * intensity
mad r1.xyz,	r0.x, c[6], r1

; add light2 colour * intensity
mad r1.xyz,	r0.y, c[21], r1

; add light3 colour * intensity
mad r1.xyz,	r0.z, c[23], r1

; add light4 colour * intensity
mad r1.xyz,	r0.w, c[18], r1
#line 35 "C:\\romans\\shaders\\fragments\\light_addlight4_diffuse_dir.vsh"
; last light
dp3 r0.x, r5, -c[19]
max r0.x, r0.x, c[0].z

; unpack colour from 3 registers, and add it to diffuse lighting
mad r1.x,	r0.x, c[21].w,	r1.x
mad r1.y,	r0.x, c[23].w,	r1.y
mad r1.z,	r0.x, c[18].w,	r1.z
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
#line 13 "C:\\romans\\shaders\\ffp_addlight4.vsh"
mov oT1,	v4 
mov	oT1, v4
m4x4 oT2, r4, c[11]

m4x4 oT3, r4, c[14]

m4x4 oT4, r4, c[17]
