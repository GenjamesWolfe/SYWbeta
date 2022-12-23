#line 3 "fleximesh1.vsh"
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
#line 32 "fleximesh1.vsh"
mul r8, v2.zyxw, c[0].wwww
#line 36 "fleximesh1.vsh"
dp3 r0.w, v1.xyz,	c[0].xzz; 
add r0.w, -r0.w, c[0].x
#line 40 "fleximesh1.vsh"
mov a0.x, r8.x
dp3 r4.x, v0, c[a0.x + 20 + 0]
dp3 r4.y, v0, c[a0.x + 20 + 1]
dp3 r4.z, v0, c[a0.x + 20 + 2]
mov r4.w, c[0].x

dp3 r5.x, v3, c[a0.x + 20 + 0]
dp3 r5.y, v3, c[a0.x + 20 + 1]
dp3 r5.z, v3, c[a0.x + 20 + 2]
mov r5.w, c[0].z
#line 53 "fleximesh1.vsh"
mul r4, r4, v1.xxxx
mul r5, r5, v1.xxxx
#line 57 "fleximesh1.vsh"
mov r9.x, c[a0.x + 20 + 0].w
mov r9.y, c[a0.x + 20 + 1].w
mov r9.z, c[a0.x + 20 + 2].w
mov r9.w, c[0].z
#line 63 "fleximesh1.vsh"
mov a0.x, r8.y
dp3 r2.x, v0, c[a0.x + 20 + 0]
dp3 r2.y, v0, c[a0.x + 20 + 1]
dp3 r2.z, v0, c[a0.x + 20 + 2]
mov r2.w, c[0].x

dp3 r3.x, v3, c[a0.x + 20 + 0]
dp3 r3.y, v3, c[a0.x + 20 + 1]
dp3 r3.z, v3, c[a0.x + 20 + 2]
mov r3.w, c[0].z
#line 75 "fleximesh1.vsh"
mad r4, r2, r0.wwww, r4
mad r5, r3, r0.wwww, r5
#line 79 "fleximesh1.vsh"
add r4, r4, r9
#line 82 "fleximesh1.vsh"
m4x4 r6, r4, c[2]
mov oPos, r6
; Do the lighting calculation
dp3 r0.x, r5, -c[1] ; normal dot light
mul r1, r0.x, c[6] ; multiply with light diffuse
mov r1.w, c[0].x ; set alpha to one
max r1, r1, c[0].z
add r1, r1, c[7] ; Add in ambient
#line 87 "fleximesh1.vsh"
min oD0, r1, c[0].x ; clamp if > 1 and output
mov oD1, c[0].zzzz ; output specular

; Copy texture coordinate
mov oT0, v4
mov oFog, c[0].y
