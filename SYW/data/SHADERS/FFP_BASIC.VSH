#line 3 "ffp_basic.vsh"
vs .1 .1
mov r4, v0 ; position
mov r5, v3 ; normal
mov r7, c[0].zzzz

dp4 r6.x, r4, c[2 + 0]
dp4 r6.y, r4, c[2 + 1]
dp4 r6.z, r4, c[2 + 2]
dp4 r6.w, r4, c[2 + 3]

mov oPos, r6
#line 9 "ffp_basic.vsh"
mov oD0, c[0].y
mov oD1, c[0].zzzz
mov oFog, c[0].z
