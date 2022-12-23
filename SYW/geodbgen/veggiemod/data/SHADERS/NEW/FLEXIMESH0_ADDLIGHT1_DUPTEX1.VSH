#line 3 "C:\\romans\\shaders\\fleximesh0_addlight1.vsh"
vs .1 .1
#line 6 "C:\\romans\\shaders\\fleximesh0_addlight1.vsh"
mul r0, v2.zyxw, c[0].wwww
#line 9 "C:\\romans\\shaders\\fleximesh0_addlight1.vsh"
mov a0.x, r0.x
dp4 r4.x, v0, c[a0.x + 24 + 0]
dp4 r4.y, v0, c[a0.x + 24 + 1]
dp4 r4.z, v0, c[a0.x + 24 + 2]
mov r4.w, c[0].x

dp3 r5.x, v3, c[a0.x + 24 + 0]
dp3 r5.y, v3, c[a0.x + 24 + 1]
dp3 r5.z, v3, c[a0.x + 24 + 2]
mov r5.w, c[0].z
#line 21 "C:\\romans\\shaders\\fleximesh0_addlight1.vsh"
m4x4 r6, r4, c[2]
mov oPos, r6

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
#line 30 "C:\\romans\\shaders\\fleximesh0_addlight1.vsh"
min oD0, r1, c[0].x ; clamp if > 1
mov oD1, c[0].zzzz ; output specular

; Copy texture coordinate
mov oT0, v4

mov oFog, c[0].y
mov oT1, v4
