#line 43 "fleximesh.vsh"
texture tex_diffuse;
#line 46 "fleximesh.vsh"
technique t0
{
pass p0
{

Texture[0] = <tex_diffuse> ;
#line 54 "fleximesh.vsh"
wrap0 = U | V;
AddressU[0] = Wrap; 
AddressV[0] = Wrap;
#line 59 "fleximesh.vsh"
ColorArg1[0] = Texture;
ColorOp[0] = Modulate;
ColorArg2[0] = Diffuse;

AlphaArg1[0] = Texture;
AlphaOp[0] = Modulate;
AlphaArg2[0] = Diffuse;
#line 68 "fleximesh.vsh"
ColorOp[1] = Disable;
AlphaOp[1] = Disable;
#line 73 "fleximesh.vsh"
VertexShader = 
decl
{
stream 0;
float v0[3]; 
float v3[3]; 
float v5[3]; 
float v7[3]; 
}
asm
{
vs .1 .1
#line 88 "fleximesh.vsh"
mov a0.x, v1.x
#line 92 "fleximesh.vsh"
dp4 r0.x, v0, c[a0.x + 8 ]
dp4 r0.y, v0, c[a0.x + 9 ]
dp4 r0.z, v0, c[a0.x + 10]
mov r0.w, c[5].w
#line 99 "fleximesh.vsh"
dp4 oPos.x, r0, c[0]
dp4 oPos.y, r0, c[1]
dp4 oPos.z, r0, c[2]
dp4 oPos.w, r0, c[3]
#line 106 "fleximesh.vsh"
dp3	r1.x, v2, c[a0.x + 8 ]
dp3 r1.y, v2, c[a0.x + 9 ]
dp3 r1.z, v2, c[a0.x + 10]
#line 112 "fleximesh.vsh"
mov r2, c5
dp3 r3.x, r1, c4
max r3.x, r3.x, c7.x
mad oD0, c6, r3.x, r2 
#line 119 "fleximesh.vsh"
mov oT0.x, v3.x
mov oT0.y, v3.y
};
}
}