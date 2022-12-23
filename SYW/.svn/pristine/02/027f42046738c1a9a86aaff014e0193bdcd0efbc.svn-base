;
; Cubemap tex gen shader. Assumes model space vert in r4 and model space normal in r5.
;
#line 11 "cubemap.vsh"
m4x4 r0, r4, c[CONST_MAT_WORLD]
m3x3 r1.xyz, r5, c[CONST_MAT_WORLD]

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
add SPHEREMAP_OUT_REG, r3, -r1
mov SPHEREMAP_OUT_REG.w, ONE
