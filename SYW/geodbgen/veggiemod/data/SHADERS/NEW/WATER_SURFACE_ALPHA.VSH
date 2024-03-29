
vs .1 .1

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; v0 = position
; v1 = normal
; v2 = colour
; v3 = texture coordinates
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
#line 48 "water_surface_alpha.vsh"
;
; Do the diffuse lighting calculation
;

dp3 r1.x, v1, -c10 ; normal dot light
mul r1, r1.x, c11 ; scale by light diffuse
max r1, r1, c0.y ; clamp if < 0
add r1, r1, c12 ; Add in ambient
#line 58 "water_surface_alpha.vsh"
;
; Calculate the alpha based on depth and incident angle
;

add r2.x, v2.w, c1.x ; alpha = vertex_alpha + min_alpha - max_alpha
add r2.x, r2.x, -c1.y ;
min r2.x, r2.x, c0.y ; alpha = Min(alpha, 0)

add r7, -v0, c14 ; vertex to camera position
mul r7.xz, r7.xz, c1.zz
dp3 r2.z, r7, r7 ; normalise r7 (vertex to camera position)
rsq r2.z, r2.z ;
mul r2.y, r7.y, r2.z ; store y component of normalised r7 as cos(pitch)
max r2.y, r2.y, c0.y ; ensure that it is not negative

mul r2.y, r2.y, r2.y
mul r2.y, r2.y, r2.y

mad r1.w, r2.x, r2.y, c1.y ; diffuse_alpha = max_alpha + cos(pitch) * alpha

;
; Store the lighting components 
;

mov oD0, r1 ; set the diffuse colour
mov oD1, c0.yyyy ; set the specular to zero
#line 86 "water_surface_alpha.vsh"
;
; Transform the texture coordinates using the texture transform
;

m4x4	oT0, v3, c6 ; 2 D texture transform

;
; Calculate the fog using D3DFOG_EXP
;

mul r8.x, -c0.w, r0.z ; - (fog_exp_density * z_dist)
exp oFog, r8.x ; evaluate exponential function
