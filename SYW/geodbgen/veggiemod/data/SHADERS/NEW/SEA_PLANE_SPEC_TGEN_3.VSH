vs .1 .1

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
;
; source vertex
;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; v0 = position
; v1 = index
; v2 = normal

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
;
; constants
;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; c0 = constants [0, 1, 0, 255.01]
; c1 - c4	= world-view-projection matrix
; c5 = bottom left position
; c6 = extents (x = min x, y = max x, z = min z, w = max z) 

; c7 = light direction
; c8 = camera position
; c9 = specular power (x = power)
; c10 = diffuse colour
; c11 = ambient colour
; c12 = specular colour

; c13 = colour map transform (x = x scale, y = z scale)
; c14 = wave texture transform (x = scale, y = x offset, z = z offset)
; c17 = fog of war transform (x = scale, y = x offset, z = z offset)

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
;
; registers
;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; r0 = clamped modified position

; r1 = lighting co-efficients (x = ambient, y = diffuse, z = specular)
; r2 = camera to position
; r3 = halfway vector
; r4 = modulus reciprocal
; r5 = colour

; r6 = texture coordinates 

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
;
; destination vertex
;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; oT0 = colour map
; oT1 = wave texture
; oT2 = fog of war

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
;
; position
;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; add bottom left position to position and clamp to extents

add r0, v0, c5 ; add bottom left position to position
max r0.x,	r0.x,	c6.x	; clamp min x
min r0.x,	r0.x,	c6.y	; clamp max x
max r0.z,	r0.z,	c6.z	; clamp min z
min r0.z,	r0.z,	c6.w	; clamp max z

; transform position into homogenous clip space and output

m4x4	oPos,	r0, c1 ; transform and output	

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
;
; colour
;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; calculate lighting co-efficients

dp3 r1.x,	v2, -c7 ; normal dot product negative light direction
#line 90 "sea_plane_spec_tgen_3.vsh"
sub r2, r0, c8 ; calculate camera to position

dp3 r4, r2, r2 ; calculate normalised position to camera
rsq r4, r4.x
mul r3, r4, -r2

add r3, r3, -c7 ; add in the negative light direction

dp3 r4, r3, r3 ; normalise to become the halfway vector
rsq r4, r4.x
mul r3, r4, r3

dp3 r1.y,	v2, r3 ; normal dot product halfway vector

mov r1.w,	c9.x ; specular power

lit r1, r1 ; calculate co-efficients (x = ambient, y = diffuse, z = specular)

; calculate diffuse colour and output

mul r5, r1.y,	c10 ; modulate diffuse colour
max r5, r5, c0.x	; clamp if < 0
add r5, r5, c11 ; add in ambient colour
mov r5.w,	c10.w ; reset opacity 
min oD0,	r5, c0.y	; clamp if > 1 and output

; calculate specular colour and output

mul r5, r1.z,	c12 ; modulate specular colour
mov r5.w,	c0.x ; set opacity to 0
max r5, r5, c0.x	; clamp if < 0
min oD1,	r5, c0.y	; clamp if > 1 and output

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
;
; texture
;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; calculate colour map coordinates and output 

mul r6.xy,	r0.xz,	c13.xy	; scale xz position to xy coordinates
mov r6.zw,	c0.yy ; reset zw components to 1
mov oT0,	r6 ; output

; calculate wave texture coordinates and output

mul r6.xy,	r0.xz,	c14.xx	; scale xz position to xy coordinates
add r6.xy,	r6.xy,	c14.yz	; add in xy offset
mov r6.zw,	c0.yy ; reset zw components to 1
mov oT1,	r6

; calculate fog of war coordinates and output

add r6.xy,	r0.xz,	c17.yz	; add xz offset to position xz
mul r6.xy,	r6.xy,	c17.xx	; scale xy coordinates
mov r6.zw,	c0.yy ; reset zw components to 1
mov oT2,	r6 ; output

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
