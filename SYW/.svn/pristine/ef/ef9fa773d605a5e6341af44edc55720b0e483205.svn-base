#line 3 "fleximesh0_fire.vsh"
vs .1 .1
#line 6 "fleximesh0_fire.vsh"
mul r0, v2.zyxw, c[0].wwww
mov a0.x, r0.x

dp4 r4.x, v0, c[a0.x + 15 + 0]
dp4 r4.y, v0, c[a0.x + 15 + 1]
dp4 r4.z, v0, c[a0.x + 15 + 2]
mov r4.w, c[0].x

dp3 r5.x, v3, c[a0.x + 15 + 0]
dp3 r5.y, v3, c[a0.x + 15 + 1]
dp3 r5.z, v3, c[a0.x + 15 + 2]
mov r5.w, c[0].y

mad r4 , r5, c[0].z, r4
#line 5 "C:\\romans\\shaders\\fragments\\burning_man.vsh"
m4x4 oT0, v4, c[8]

mov oT1, v4

dp4 r6.x, r4, c[1 + 0]
dp4 r6.y, r4, c[1 + 1]
dp4 r6.z, r4, c[1 + 2]
dp4 r6.w, r4, c[1 + 3]

mov oPos, r6
#line 22 "fleximesh0_fire.vsh"
mov oD0, c[0].x 
mov oD1, c[0].yyyy 
mov oFog, c[0].y
