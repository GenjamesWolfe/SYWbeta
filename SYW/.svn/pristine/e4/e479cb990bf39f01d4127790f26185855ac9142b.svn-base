#line 3 "fleximesh0_fire_mt.vsh"
vs .1 .1
#line 6 "fleximesh0_fire_mt.vsh"
mul r0, v2.zyxw, c[0].wwww
mov a0.x, r0.x

dp4 r4.x, v0, c[a0.x + 15 + 0]
dp4 r4.y, v0, c[a0.x + 15 + 1]
dp4 r4.z, v0, c[a0.x + 15 + 2]
mov r4.w, c[0].x

dp4 r6.x, r4, c[1 + 0]
dp4 r6.y, r4, c[1 + 1]
dp4 r6.z, r4, c[1 + 2]
dp4 r6.w, r4, c[1 + 3]

mov oPos, r6
#line 16 "fleximesh0_fire_mt.vsh"
mov oD0, c[14] 
mov oD1, c[0].yyyy 
mov oFog, c[0].y
mov oT0, v4
m3x4 oT1, v4, c[8]
;mov oT1, v4
