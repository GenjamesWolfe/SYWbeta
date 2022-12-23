
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
#line 18 "fleximesh0_basic_tgen_0.vsh"
mul r1, v2.zyxw, c[0].wwww
#line 21 "fleximesh0_basic_tgen_0.vsh"
mov a0.x, r1.x
m4x3 r4, v0, c[a0.x + 22]
m3x3 r5, v3, c[a0.x + 22]
#line 26 "fleximesh0_basic_tgen_0.vsh"
mov r4.w, c[0].x
m4x4 r6, r4, c[2]
mov oPos, r6
#line 31 "fleximesh0_basic_tgen_0.vsh"
mul r8.x, -c[0].y, r6.z ; - (fog_exp_density * z_dist)
exp r9.x, r8.x ; evaluate exponential function (2^ ( -fog_exp_density * z_dist))

mov oD0.xyzw, ALL_ONE
#line 39 "fleximesh0_basic_tgen_0.vsh"
mov oD1, c[0].zzzz
mov oFog, c[0].z
