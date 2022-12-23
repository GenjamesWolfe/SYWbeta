#line 3 "fleximesh1_basic.vsh"
vs .1 .1
#line 6 "fleximesh1_basic.vsh"
mul r1, v2.zyxw, c[0].wwww
#line 10 "fleximesh1_basic.vsh"
dp3 r0.w, v1.xyz, c[0].xzz; 
add r0.w, -r0.w, c[0].x
#line 14 "fleximesh1_basic.vsh"
mov a0.x, r1.x
m3x3 r4, v0, c[a0.x + 20]
#line 18 "fleximesh1_basic.vsh"
mul r4, r4, v1.xxxx
#line 22 "fleximesh1_basic.vsh"
mov r11.x, c[a0.x + 20 + 0].w
mov r11.y, c[a0.x + 20 + 1].w
mov r11.z, c[a0.x + 20 + 2].w
mov r11.w, c0.x
#line 28 "fleximesh1_basic.vsh"
mov a0.x, r1.y
m3x3 r2, v0, c[a0.x + 20]
#line 32 "fleximesh1_basic.vsh"
mad r4, r2, r0.wwww, r4
#line 35 "fleximesh1_basic.vsh"
add r4, r4, r11
#line 38 "fleximesh1_basic.vsh"
mov r4.w, c[0].x
m4x4 r6, r4, c[2]
mov oPos, r6

mov oD0, c[0].y
mov oD1, c[0].zzzz
mov oFog, c[0].z
