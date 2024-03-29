#line 3 "C:\\romans\\shaders\\fleximesh0_addlight4.vsh"
vs .1 .1
#line 6 "C:\\romans\\shaders\\fleximesh0_addlight4.vsh"
mul r0, v2.zyxw, c[0].wwww
#line 9 "C:\\romans\\shaders\\fleximesh0_addlight4.vsh"
mov a0.x, r0.x
dp4 r4.x, v0, c[a0.x + 24 + 0]
dp4 r4.y, v0, c[a0.x + 24 + 1]
dp4 r4.z, v0, c[a0.x + 24 + 2]
mov r4.w, c[0].x

dp3 r5.x, v3, c[a0.x + 24 + 0]
dp3 r5.y, v3, c[a0.x + 24 + 1]
dp3 r5.z, v3, c[a0.x + 24 + 2]
mov r5.w, c[0].z
#line 21 "C:\\romans\\shaders\\fleximesh0_addlight4.vsh"
m4x4 r6, r4, c[2]
mov oPos, r6

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
#line 26 "C:\\romans\\shaders\\fleximesh0_addlight4.vsh"
min oD0, r1, c[0].x ; clamp if > 1
mov oD1, c[0].zzzz ; output specular

; Copy texture coordinate
mov oT0, v4

mov oFog, c[0].y
#line 3 "fleximesh0_addlight4_tgen_1.vsh"
; Relies on world space position being in r4
m4x3 oT1, r4, c[11] ; generate world space coordinate.
