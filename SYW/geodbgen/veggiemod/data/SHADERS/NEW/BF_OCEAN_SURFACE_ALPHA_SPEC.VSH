
vs .1 .1

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; v0 = position
; v1 = colour
; v2 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; r0 = view space vertex position
; r1 = specular lighting component
; r2 = specular half angle vector 
; r3 = distance effect factors (distance_effect, ? , ? , ? )
; r4 = temp used to normalise vectors & specular input parameters
; r5 = temp used in specular calculations
; r6 = vertex to camera vector
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; Constants specified by the app;
;
; c0 = constants (1, 0, ? , ? ) 
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
; Caclulate the normalised vertex to camera vector (store in r6)
;

add r6, -v0, c14 ; get a vector toward the camera position
dp3 r4.x, r6.xyz,	r6.xyz ; magnitude squared
rsq r4.xyz, r4.x ; get the inverse of the square
mul r6.xyz, r6.xyz, r4.xyz ; multiply, r6 = - (camera vector)

;
; Calculate the alpha based on depth and incident angle
;

add r2.x, v1.w, c1.x ; alpha = vertex_alpha + min_alpha - max_alpha
add r2.x, r2.x, -c1.y ;
min r2.x, r2.x, c0.y ; alpha = Max(alpha, 0) ... ensure that it is not positive

add r7, -v0, c14 ; vertex to camera position
mul r7.xz, r7.xz, c1.zz
dp3 r2.z, r7, r7 ; normalise r7 (vertex to camera position)
rsq r2.z, r2.z ;
mul r2.y, r7.y, r2.z ; store y component of normalised r7 as cos(pitch)

max r2.y, r2.y, c0.y ; get cos(pitch) from y component of camera vector and ensure that it is not negative
mul r2.y, r2.y, r2.y
mul r2.y, r2.y, r2.y
mad r1.xyzw, r2.x, r2.y, c1.y	; diffuse_alpha = max_alpha + cos(pitch) * alpha
;
; Calc specular lighting
;
add r2.xyz, r6.xyz, -c10.xyz	; get half angle... camera vector + direction to light
dp3 r4.x, r2.xyz,	r2.xyz ; magnitude squared
rsq r4.xyz, r4.x ; get the inverse of the square
mul r2.xyz, r2.xyz, r4.xyz ; multiply, r2 = half vector
#line 89 "water_surface_alpha_spec.vsh"
mov r4.x, -c10.y ; normal 'dot' direction to light (normal straight up)
mov r4.y, r2.y ; normal 'dot' half vector (normal straight up)
mov r4.w, c1.w ; specular power

lit r5, r4 ; perform lighting calculations

mul r1.w, r1.w, r5.z ; modulate the alpha by the specular component

;
; Calculate the fog using D3DFOG_EXP
;

mul r8.x, -c0.w, r0.z ; - (fog_exp_density * z_dist)
exp r8.x, r8.x ; evaluate exponential function
mul r1.w, r1.w, r8.x ; modulate the alpha by the fog function

; Modulate by the ocean proportion (in v1.y)
mul r1.w, r1.w, v1.y

;
; Store the lighting components 
;

mov oD0, r1 ; set the diffuse alpha
mov oD1, c13 ; set the specular colour

;
; Transform the texture coordinates using the texture transform
;
#line 120 "water_surface_alpha_spec.vsh"
dp4 r2.x, v0.xzyw, c6
dp4 r2.y, v0.xzyw, c7
mov oT0.xy, r2.xy

;m4x4	oT0, v0.xzyw, c6 ; 2 D texture transform (using world space x,z)

mov oFog, c0.x ; clear vertex fog
