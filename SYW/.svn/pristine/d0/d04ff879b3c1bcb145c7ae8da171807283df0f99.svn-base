vs .1 .1

;	v0 = position
;	v1 = index
;	v2 = normal
;	v3 = colour
;	v4 = texture coordinates

;	c0 = constants [0, 1, 0, 255.01]
;	c1 - c4 = world-view-projection matrix
;	c5 = colour
;	c6 = texture1 transform (x = scale, y = x_offset, z = z_offset) 
;	c7-c95 = indexed data

;	r0 = index intermediate
;	r1 = indexed data cache (x = normal multiplier)
;	r2 = world position
;	r3 = offset texture1 cordinates

; compensate for lack of UBYTE4 on Geforce3

mul r0, v1.zyxw,	c0.wwww
; mul	r0, v1, c0.wwww - the way if have ubyte4

mov a0.x,	r0.x ; put index into address register
mov r1, c[a0.x + 7] ; move index data into register

mul r2, v2, r1.xxxx ; multiply normal by offset
add r2, r2, v0 ; add in world position

mov r2.w,	c0.y ; set world position w component to 1 

m4x4	oPos,	r2, c1 ; transform the world position into homogenous clip space and output

mul oD0,	v3, c5 ; modulate colour

mov oT0, v4 ; pass through the texture coordinates

add r3.xy,	r2.xz, c6.yz ; add offsets to world position xz and place in register xy
mul r3.xy,	r3.xy, c6.xx ; scale coordinates
mov r3.zw,	c0.yy ; reset zw components to 1
mov oT1,	r3 ; output texture coordinates
