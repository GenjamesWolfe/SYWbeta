
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; v0 = position
; v1 = blend weights
; v2 = blend indices
; v3 = normal
; v4 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; r1 = Blend indices
; r4 = Blended position in camera space
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

vs .1 .1
#line 18 "C:\\romans\\shaders\\fleximesh0_basic.vsh"
mul r1, v2.zyxw, c[0].wwww
#line 21 "C:\\romans\\shaders\\fleximesh0_basic.vsh"
mov a0.x, r1.x
m4x3 r4, v0, c[a0.x + 20]
#line 25 "C:\\romans\\shaders\\fleximesh0_basic.vsh"
mov r4.w, c[0].x
m4x4 r6, r4, c[2]
mov oPos, r6

mov oD0, c[0].y
mov oD1, c[0].zzzz
mov oFog, c[0].z
#line 3 "C:\\romans\\shaders\\fleximesh0_basic_tgen_1.vsh"
; Relies on world space position being in r4
m4x3 oT0, r4, c[11] ; generate world space coordinate.
#line 3 "fleximesh0_basic_tgen_2.vsh"
m4x3 oT1, r4, c[14] ; generate world space coordinate.
