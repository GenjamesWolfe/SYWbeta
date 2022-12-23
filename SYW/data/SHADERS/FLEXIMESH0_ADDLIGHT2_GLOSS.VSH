#line 3 "C:\\romans\\shaders\\fleximesh0_addlight2.vsh"
vs .1 .1
#line 6 "C:\\romans\\shaders\\fleximesh0_addlight2.vsh"
mul r0, v2.zyxw, c[0].wwww
#line 9 "C:\\romans\\shaders\\fleximesh0_addlight2.vsh"
mov a0.x, r0.x
dp4 r4.x, v0, c[a0.x + 24 + 0]
dp4 r4.y, v0, c[a0.x + 24 + 1]
dp4 r4.z, v0, c[a0.x + 24 + 2]
mov r4.w, c[0].x

dp3 r5.x, v3, c[a0.x + 24 + 0]
dp3 r5.y, v3, c[a0.x + 24 + 1]
dp3 r5.z, v3, c[a0.x + 24 + 2]
mov r5.w, c[0].z
#line 21 "C:\\romans\\shaders\\fleximesh0_addlight2.vsh"
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
#line 30 "C:\\romans\\shaders\\fleximesh0_addlight2.vsh"
min oD0, r1, c[0].x ; clamp if > 1
mov oD1, c[0].zzzz ; output specular

; Copy texture coordinate
mov oT0, v4

mov oFog, c[0].y
;
; Cubemap tex gen shader. Assumes model space vert in r4 and model space normal in r5.
;
#line 11 "C:\\romans\\shaders\\fragments\\cubemap.vsh"
m4x3 r0, r4, c[8]
m3x3 r1.xyz, r5, c[8]

; Create r3, the normalized vector from the eye to the vertex
dp3 r3.w, r0, r0
rsq r3.w, r3.w 
mul r3, r0, r3.w

; Need to re-normalize normal
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1, r1, r1.w

; Calculate E - 2* (E dot N) *N
dp3 r11, r3, r1
add r11, r11, r11
mul r1, r1, r11
add oT1, r3, -r1
mov oT1.w, c[0].x
#line 6 "fleximesh0_addlight2_gloss.vsh"
mov oT2, v4
