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
#line 3 "C:\\romans\\shaders\\fleximesh0_tgen_1.vsh"
; Relies on world space position being in r4
m4x3 oT1, r4, c[11] ; generate world space coordinate.
#line 3 "C:\\romans\\shaders\\fleximesh0_tgen_2.vsh"
; Relies on world space position being in r4
m4x3 oT2, r4, c[14] ; generate world space coordinate.
#line 3 "fleximesh0_tgen_3.vsh"
; Relies on world space position being in r4
m4x3 oT3, r4, c[17] ; generate world space coordinate.
