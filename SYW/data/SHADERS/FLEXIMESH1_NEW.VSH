
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
; Constants specified by the app;
;
; c0 = constants
; c1 = light_dir
; c2-5 = World * View * Projection
; c6 = Light diffuse colour
; c7 = Light ambient colour
; c8-11 = World matrix
; c12 = Specular color 
; c13 = Camera look vector
; c14 = Material diffuse colour
; c15-18 = Tex transform matrix 1
; c19-22 = Tex transform matrix 2
; c23-95 = Matrix palette
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; oPos = Output position
; oD0 = Diffuse
; oD1 = Specular
; oT0 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
#line 48 "fleximesh1_NEW.vsh"
mul r1,v2.zyxw,c0.wwww
#line 52 "fleximesh1_NEW.vsh"
dp3 r0.w,v1.xyz,c0.xzz; 
add r0.w, -r0.w,c0.x
#line 56 "fleximesh1_NEW.vsh"
mov a0.x,r1.x
m3x3 r4,v0,c[a0.x + 23]
m3x3 r5,v3,c[a0.x + 23]
#line 61 "fleximesh1_NEW.vsh"
mul r4,r4,v1.xxxx
mul r5,r5,v1.xxxx
#line 66 "fleximesh1_NEW.vsh"
mov r11.x, c[a0.x + 23 + 0].w
mov r11.y, c[a0.x + 23 + 1].w
mov r11.z, c[a0.x + 23 + 2].w
mov r11.w, c0.x
#line 72 "fleximesh1_NEW.vsh"
mov a0.x,r1.y
m3x3 r2,v0,c[a0.x + 23]
m3x3 r3,v3,c[a0.x + 23]
#line 77 "fleximesh1_NEW.vsh"
mad r4,r2,r0.wwww,r4
mad r5,r3,r0.wwww,r5
#line 81 "fleximesh1_NEW.vsh"
add r4, r4, r11
#line 84 "fleximesh1_NEW.vsh"
mov r4.w,c0.x
m4x4 r6,r4,c2
mov oPos, r6

; Do the lighting calculation
dp3 r1.x, r5, -c1 ; normal dot light
mul r0, r1.x, c6 ; scale light diffuse
mov r0.w, c0.x ; set alpha to one
mul r0, r0, c14 ; scale by material diffuse
max r0, r0, c0.z ; clamp if < 0
add r0, r0, c7 ; Add in ambient
min oD0, r0, c0.x ; clamp if > 1 and output
mov oD1, c0.zzzz ; output specular

;mov oD0.y, c0.z
; Copy texture coordinate
mov oT0, v4

;
; Calculate the fog using D3DFOG_EXP
;

mul r8.x, -c0.y, r6.z ; - (fog_exp_density * z_dist)
exp oFog, r8.x ; evaluate exponential function (2^ ( -fog_exp_density * z_dist))
