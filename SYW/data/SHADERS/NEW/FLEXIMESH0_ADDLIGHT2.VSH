#line 3 "fleximesh0_addlight2.vsh"
vs .1 .1
#line 6 "fleximesh0_addlight2.vsh"
mul r0, v2.zyxw, c[0].wwww
#line 9 "fleximesh0_addlight2.vsh"
mov a0.x, r0.x
dp4 r4.x, v0, c[a0.x + 24 + 0]
dp4 r4.y, v0, c[a0.x + 24 + 1]
dp4 r4.z, v0, c[a0.x + 24 + 2]
mov r4.w, c[0].x

dp3 r5.x, v3, c[a0.x + 24 + 0]
dp3 r5.y, v3, c[a0.x + 24 + 1]
dp3 r5.z, v3, c[a0.x + 24 + 2]
mov r5.w, c[0].z
#line 21 "fleximesh0_addlight2.vsh"
m4x4 r6, r4, c[2]
mov oPos, r6

; normal dot light1
dp3 r0.x, r5, -c[1]

; normal dot light2
dp3 r0.y, r5, -c[20]

; normal dot light2
dp3 r0.z, r5, -c[22]
#line 12 "C:\\romans\\shaders\\fragments\\light_addlight2_diffuse_dir.vsh"
; clamp both it to 0
max r0.xyz, r0.xyz, c[0].z

; start with ambient
mov r1,	c[7]
#line 19 "C:\\romans\\shaders\\fragments\\light_addlight2_diffuse_dir.vsh"
; add light1 colour * intensity
mad r1.xyz,	r0.x, c[6], r1

; add light2 colour * intensity
mad r1.xyz,	r0.y, c[21], r1

; add light3 colour * intensity
mad r1.xyz,	r0.z, c[23], r1
#line 30 "fleximesh0_addlight2.vsh"
min oD0, r1, c[0].x ; clamp if > 1
mov oD1, c[0].zzzz ; output specular

; Copy texture coordinate
mov oT0, v4

mov oFog, c[0].y
