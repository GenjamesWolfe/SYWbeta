#line 3 "C:\\romans\\shaders\\fleximesh0.vsh"
vs .1 .1
#line 6 "C:\\romans\\shaders\\fleximesh0.vsh"
mul r0, v2.zyxw, c[0].wwww
#line 9 "C:\\romans\\shaders\\fleximesh0.vsh"
mov a0.x, r0.x
dp4 r4.x, v0, c[a0.x + 20 + 0]
dp4 r4.y, v0, c[a0.x + 20 + 1]
dp4 r4.z, v0, c[a0.x + 20 + 2]
mov r4.w, c[0].x

dp3 r5.x, v3, c[a0.x + 20 + 0]
dp3 r5.y, v3, c[a0.x + 20 + 1]
dp3 r5.z, v3, c[a0.x + 20 + 2]
mov r5.w, c[0].z
#line 21 "C:\\romans\\shaders\\fleximesh0.vsh"
m4x4 r6, r4, c[2]
mov oPos, r6
; Do the lighting calculation
dp3 r0.x, r5, -c[1] ; normal dot light
mul r1, r0.x, c[6] ; multiply with light diffuse
mov r1.w, c[0].x ; set alpha to one
max r1, r1, c[0].z
add r1, r1, c[7] ; Add in ambient
#line 26 "C:\\romans\\shaders\\fleximesh0.vsh"
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
#line 6 "C:\\romans\\shaders\\fleximesh0_gloss.vsh"
mov oT2, v4
#line 3 "C:\\romans\\shaders\\fleximesh0_gloss_tgen_1.vsh"
; Relies on world space position being in r4
mov oT3, v4
m4x3 oT4, r4, c[11] ; generate world space coordinate.
#line 3 "C:\\romans\\shaders\\fleximesh0_gloss_tgen_2.vsh"
m4x3 oT5, r4, c[14] ; generate world space coordinate
#line 3 "fleximesh0_gloss_tgen_3.vsh"
m4x3 oT6, r4, c[17] ; generate world space coordinate
