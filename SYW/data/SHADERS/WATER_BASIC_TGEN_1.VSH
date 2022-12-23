
vs.1.1

;------------------------------------------------------------------------------
; v0 = position
; v1 = normal
; v2 = colour
; v3 = texture coordinates
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; r0		= view space vertex position
; r1		= diffuse lighting component
; r2		= adjusted alpha factors (alpha, cos(pitch), distance_sq, ?) 
; r3		= distance effect factors (distance_effect, ?, ?, ?)
; r7		= vertex to camera position
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Constants specified by the app;
;
; c0		= constants (1, 0, ?, fog_exp_density) 
; c1		= alpha factors (min_alpha, max_alpha, ?, specular_power)
; c2-c5		= World * View transform * Projection
; c6-c9		= Texture transform matrix
; c10		= Light direction
; c11		= Light diffuse colour
; c12		= Light ambient colour
; c13		= Light specular colour
; c14		= Camera position in world space
; c15-c18	= Texture generation matrix
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; oPos	  = Output position
; oD0	  = Diffuse
; oD1	  = Specular
; oT0	  = texture coordinates
;------------------------------------------------------------------------------

;
; Transform the position
;

m4x4	r0, v0, c2
mov		oPos, r0

;
; Store the lighting components 
;

mul r8, c0.w, r0.z ; - (fog_exp_density * z_dist)
mov oD0.xyz, r8.xxx; 
mov oD0, c0.x

mov		oD1,  c0.yyyy				; set the specular to zero
mov		oFog, c[0].x


;
; Transform the texture coordinates using the texture transform
;

m4x3 oT0, v0, c15					; generate world space coordinate.

