; Do the lighting calculation
dp3 TEMP0.x, NORMAL_MODEL, -c[CONST_LDIR] ; normal dot light
mul DIFFUSE_CLR, TEMP0.x, c[CONST_LDIF_CLR] ; multiply with light diffuse
mov DIFFUSE_CLR.w, ONE ; set alpha to one
max DIFFUSE_CLR, DIFFUSE_CLR, ZERO
add DIFFUSE_CLR, DIFFUSE_CLR, c[CONST_LAMB_CLR] ; Add in ambient
