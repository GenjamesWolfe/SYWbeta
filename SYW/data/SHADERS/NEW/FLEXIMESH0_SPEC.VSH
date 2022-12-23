#line 3 "fleximesh0_spec.vsh"
vs .1 .1

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; v0 = position
; v1 = blend weights
; v2 = blend indices
; v3 = normal
; v4 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; r0.w = Last blend weight
; r1 = Blend indices
; r2 = Temp position
; r3 = Temp normal
; r4 = Blended position in camera space
; r5 = Blended normal in camera space
; r6 = view space vertex position
; r8.x = fog exponent
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; oPos = Output position
; oD0 = Diffuse
; oD1 = Specular
; oT0 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
#line 32 "fleximesh0_spec.vsh"
mul r1, v2.zyxw,	c0.wwww
#line 35 "fleximesh0_spec.vsh"
mov a0.x, r1.x
m4x3 r4, v0, c[a0.x + 24]
m3x3 r5, v3, c[a0.x + 24]
#line 40 "fleximesh0_spec.vsh"
mov r4.w, c[0].x
m4x4 r6, r4, c[2]
mov oPos, r6

;
; Calculate the fog using D3DFOG_EXP
;

;mul r8.x, -c0.y, r6.z ; - (fog_exp_density * z_dist)
;exp r8.x, r8.x ; evaluate exponential function

mov r8.x, c[0].x ; HACK - just set it to 1 for now while investigating
; flashing characters on the strat map
mov oFog, r8.x

; Do the lighting calculation
dp3 r1.x, r5, -c[1] ; normal dot light
mul r0, r1.x, c[6] ; multiply with light diffuse
mov r0.w, c[0].x ; set alpha to one
#line 61 "fleximesh0_spec.vsh"
max r0, r0, c[0].z
add r10, r0, c[7] ; Add in ambient
#line 65 "fleximesh0_spec.vsh"
m4x3 r0, v0, c[8] ; Transform point to world space 
add r0, -r0, c[12] ; Get a vector toward the camera position
; This is the negative of the camera direction 
#line 70 "fleximesh0_spec.vsh"
dp3 r11.x, r0.xyz, r0.xyz ; Load the square into r1
rsq r11.xyz,	r11.x ; Get the inverse of the square
mul r0.xyz, r0.xyz, r11.xyz ; Multiply, r0 = - (camera vector)
mov r7, -c[1]
m3x3 r9, r7, c[8]
add r2.xyz, r0.xyz, r9 ; Get half angle
#line 78 "fleximesh0_spec.vsh"
dp3 r11.x, r2.xyz, r2.xyz ; Load the square into r1
rsq r11.xyz,	r11.x ; Get the inverse of the square
mul r2.xyz, r2.xyz, r11.xyz ; Multiply, r2 = HalfAngle
m3x3 r1, r5, c[8] ; Transform normal to world space, put in r1
#line 84 "fleximesh0_spec.vsh"
dp3 r3.xyzw,	r1, r2
#line 87 "fleximesh0_spec.vsh"
;max r3, r3, ALL_ONE
mul r3, r3, r3 
mul r3, r3, r3 
mul r3, r3, r3 
mul r3, r3, r3 

mul r3, r3, r8.xxxx ; reduce specular by the fog factor
mul r3, r3, c[11]	; modulate by specular colour

mov r10.w, c[6].w ; set alpha
min oD0, r10, c[0].x ; clamp if > 1 and output
mov oD1, r3 ; output specular

; Copy texture coordinate
mov oT0, v4
