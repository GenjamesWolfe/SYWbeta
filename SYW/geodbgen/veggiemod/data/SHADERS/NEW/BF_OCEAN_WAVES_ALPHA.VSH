
vs .1 .1

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; v0 = position
; v1 = colour
; v2 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; r0 = view space vertex position
; r1 = diffuse lighting component
; r2 = adjusted alpha factors (alpha, cos(pitch), distance_sq, ? ) 
; r3 = distance effect factors (distance_effect, ? , ? , ? )
; r7 = vertex to camera position
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; Constants specified by the app;
;
; c0 = constants (1, 0, ? , fog_exp_density) 
; c1 = alpha factors (min_alpha, max_alpha, ? , specular_power)
; c2-c5 = World * View transform * Projection
; c6-c9 = Texture transform matrix
; c10 = Light direction
; c11 = Light diffuse colour
; c12 = Light ambient colour
; c13 = Light specular colour
; c14 = Camera position in world space
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; oPos = Output position
; oD0 = Diffuse
; oD1 = Specular
; oT0 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

;
; Transform the position
;

m4x4	r0, v0, c2
mov oPos, r0

;
; Do the diffuse lighting calculation
;

mov r1.x, -c10.y	; normals are straight up, so use the y component of the light direction
mul r1, r1.xxxx, c11 ; scale by light diffuse
max r1, r1, c0.yyyy ; clamp if < 0
add r1, r1, c12 ; Add in ambient

; Modulate by the ocean proportion (in v1.y)
mul r1.w, r1.w, v1.y

; Modulate by the wave opacity (in c1.x)
mul r1.w, r1.w, c1.x

;
; Store the lighting components 
;

mov oD0, r1 ; set the diffuse colour
mov oD1, c0.yyyy ; set the specular to zero

;
; Transform the texture coordinates using the texture transform
;

m4x4 oT0, v2, c6 ; 2 D texture transform

;
; Calculate the fog using D3DFOG_EXP
;

mul r8.x, -c0.w, r0.z ; - (fog_exp_density * z_dist)
exp oFog, r8.x ; evaluate exponential function
