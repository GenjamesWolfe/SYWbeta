
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
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; Constants specified by the app;
;
; c9-c95 = world-view matrix palette
; c8 = diffuse * light.diffuse
; c7 = ambient color
; c2-c5 = projection matrix
; c1 = light direction
; c0 = {1, power, 0, 1020.01};
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; oPos = Output position
; oD0 = Diffuse
; oD1 = Specular
; oT0 = texture coordinates
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
#line 40 "simple.vsh"
m4x4 oPos,v0,c2
#line 43 "simple.vsh"
mov oT0, v4
mov oD0.xyzw, c0.x
