Shader "RedDotGames/Car Glass" {
Properties {
	_Color ("Main Color (RGB)", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color (RGB)", Color) = (1,1,1,0.5)
	_Cube ("Reflection Cubemap (CUBE)", Cube) = "_Skybox" { TexGen CubeReflect }
	_FresnelPower ("Fresnel Power", Range(0.05,5.0)) = 0.75
}
SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	
	Alphatest Greater 0 ZWrite Off ColorMask RGB
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 4
//   opengl - ALU: 25 to 71
//   d3d9 - ALU: 25 to 71
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
"3.0-!!ARBvp1.0
# 42 ALU
PARAM c[22] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.w, R1, c[5];
MOV R0.x, R3.w;
MOV R0.y, R2.w;
MOV R0.z, c[0].x;
MUL R1, R0.wxyy, R0.xyyw;
DP4 R2.z, R0.wxyz, c[17];
DP4 R2.y, R0.wxyz, c[16];
DP4 R2.x, R0.wxyz, c[15];
DP4 R0.z, R1, c[20];
DP4 R0.x, R1, c[18];
DP4 R0.y, R1, c[19];
ADD R2.xyz, R2, R0;
MOV R1.w, c[0].x;
MOV R1.xyz, c[14];
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R1.xyz, R0, c[13].w, -vertex.position;
MUL R0.y, R3.w, R3.w;
MAD R1.w, R0, R0, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[21];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[3].xyz, R2, R3;
ADD result.texcoord[1].xyz, -R0, c[14];
MOV result.texcoord[2].z, R2.w;
MOV result.texcoord[2].y, R3.w;
MOV result.texcoord[2].x, R0.w;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 42 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
"vs_3_0
; 42 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c21, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c12.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c21.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c16
dp4 r2.y, r0.wxyz, c15
dp4 r2.x, r0.wxyz, c14
dp4 r0.z, r1, c19
dp4 r0.x, r1, c17
dp4 r0.y, r1, c18
add r2.xyz, r2, r0
mov r1.w, c21.x
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r1.xyz, r0, c12.w, -v0
mul r0.y, r3.w, r3.w
mad r1.w, r0, r0, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c21.y, -r1
mul r3.xyz, r1.w, c20
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o4.xyz, r2, r3
add o2.xyz, -r0, c13
mov o3.z, r2.w
mov o3.y, r3.w
mov o3.x, r0.w
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 25 ALU
PARAM c[16] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[1].xyz, -R0, c[14];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MAD result.texcoord[3].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 25 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
"vs_3_0
; 25 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord1 v2
mov r1.xyz, c13
mov r1.w, c15.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c15.y, -r0
mul r1.xyz, v1, c12.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mad o4.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_4).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_2 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz));
  c.w = tmpvar_3;
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_4).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  c.xyz = (tmpvar_2 * ((8.0 * tmpvar_8.w) * tmpvar_8.xyz));
  c.w = tmpvar_3;
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 25 ALU
PARAM c[16] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[1].xyz, -R0, c[14];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MAD result.texcoord[3].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 25 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
"vs_3_0
; 25 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord1 v2
mov r1.xyz, c13
mov r1.w, c15.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c15.y, -r0
mul r1.xyz, v1, c12.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mad o4.xy, v2, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_4).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_i0 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_2 * lm_i0);
  c.xyz = tmpvar_9;
  c.w = tmpvar_3;
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_4).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_8;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  lm_i0 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_2 * lm_i0);
  c.xyz = tmpvar_10;
  c.w = tmpvar_3;
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
"3.0-!!ARBvp1.0
# 71 ALU
PARAM c[30] = { { 1, 2, 0 },
		state.matrix.mvp,
		program.local[5..29] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[13].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[16];
DP3 R4.z, R3, c[6];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[15];
MUL R2, R2, R2;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
DP4 R4.xy, vertex.position, c[7];
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[17];
DP3 R4.x, R3, c[7];
MAD R2, R1, R1, R2;
MAD R0, R4.x, R1, R0;
MUL R1, R2, c[18];
ADD R1, R1, c[0].x;
MOV R5.z, R4.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[25];
DP4 R2.y, R5, c[24];
DP4 R2.x, R5, c[23];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].z;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MUL R1, R5.xyzz, R5.yzzx;
MAD R0.xyz, R0.w, c[22], R0;
DP4 R3.z, R1, c[28];
DP4 R3.x, R1, c[26];
DP4 R3.y, R1, c[27];
ADD R3.xyz, R2, R3;
MOV R1.w, c[0].x;
MOV R1.xyz, c[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MUL R0.w, R4.z, R4.z;
MAD R1.w, R5.x, R5.x, -R0;
MAD R1.xyz, R2, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R1;
MUL R5.yzw, R1.w, c[29].xxyz;
ADD R3.xyz, R3, R5.yzww;
ADD result.texcoord[3].xyz, R3, R0;
MUL R2.xyz, vertex.normal, R0.w;
MAD R1.xyz, -R2, c[0].y, -R1;
MOV R3.x, R4.w;
MOV R3.y, R4;
DP3 result.texcoord[0].z, R1, c[7];
DP3 result.texcoord[0].y, R1, c[6];
DP3 result.texcoord[0].x, R1, c[5];
ADD result.texcoord[1].xyz, -R3.wxyw, c[14];
MOV result.texcoord[2].z, R4.x;
MOV result.texcoord[2].y, R4.z;
MOV result.texcoord[2].x, R5;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 71 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
"vs_3_0
; 71 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c29, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
mul r3.xyz, v1, c12.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c15
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c14
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c29.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c16
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c17
add r1, r1, c29.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c24
dp4 r2.y, r5, c23
dp4 r2.x, r5, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c29.z
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c21, r0
dp4 r3.z, r1, c27
dp4 r3.x, r1, c25
dp4 r3.y, r1, c26
add r3.xyz, r2, r3
mov r1.w, c29.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c12.w, -v0
dp3 r0.w, v1, -r1
mul r5.yzw, r1.w, c28.xxyz
add r3.xyz, r3, r5.yzww
add o4.xyz, r3, r0
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c29.y, -r1
mov r3.x, r4.w
mov r3.y, r4
dp3 o1.z, r1, c6
dp3 o1.y, r1, c5
dp3 o1.x, r1, c4
add o2.xyz, -r3.wxyw, c13
mov o3.z, r4.x
mov o3.y, r4.z
mov o3.x, r5
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_9.x) + (tmpvar_23 * tmpvar_9.y)) + (tmpvar_24 * tmpvar_9.z)) * inversesqrt (tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  tmpvar_4 = tmpvar_27;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = tmpvar_9;
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_4LightPosX0 - tmpvar_21.x);
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosY0 - tmpvar_21.y);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosZ0 - tmpvar_21.z);
  highp vec4 tmpvar_25;
  tmpvar_25 = (((tmpvar_22 * tmpvar_22) + (tmpvar_23 * tmpvar_23)) + (tmpvar_24 * tmpvar_24));
  highp vec4 tmpvar_26;
  tmpvar_26 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_22 * tmpvar_9.x) + (tmpvar_23 * tmpvar_9.y)) + (tmpvar_24 * tmpvar_9.z)) * inversesqrt (tmpvar_25))) * (1.0/((1.0 + (tmpvar_25 * unity_4LightAtten0)))));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_26.x) + (unity_LightColor[1].xyz * tmpvar_26.y)) + (unity_LightColor[2].xyz * tmpvar_26.z)) + (unity_LightColor[3].xyz * tmpvar_26.w)));
  tmpvar_4 = tmpvar_27;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + (tmpvar_2 * 0.25));
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 3
//   opengl - ALU: 20 to 22, TEX: 1 to 2
//   d3d9 - ALU: 20 to 23, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_ReflectColor]
Float 4 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 1 TEX
PARAM c[7] = { program.local[0..4],
		{ 0, 1, 0.79627001, 0.20373 },
		{ 0.25, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.x;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
DP3 R1.w, fragment.texcoord[2], c[0];
MUL R1.xyz, R0.w, fragment.texcoord[1];
MUL R0.xyz, R0.y, fragment.texcoord[2];
DP3 R0.x, R1, R0;
MAX R0.w, R0.x, c[5].x;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MUL R1.xyz, R0, c[3];
ADD R1.xyz, R1, c[2];
ADD_SAT R0.w, -R0, c[5].y;
POW R0.x, R0.w, c[4].x;
MAD R0.w, R0.x, c[5].z, c[5];
MUL R2.xyz, R1, fragment.texcoord[3];
MUL R0.xyz, R1, c[1];
MAX R1.w, R1, c[5].x;
MUL R0.xyz, R1.w, R0;
MAD R0.xyz, R0, c[6].y, R2;
MAX result.color.w, R0, c[5].x;
MAD result.color.xyz, R1, c[6].x, R0;
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_ReflectColor]
Float 4 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
"ps_3_0
; 23 ALU, 1 TEX
dcl_cube s0
def c5, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c6, 0.25000000, 2.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3 r0.x, v1, v1
rsq r0.w, r0.x
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
dp3_pp r1.w, v2, c0
mul r1.xyz, r0.w, v1
mul_pp r0.xyz, r0.y, v2
dp3 r0.x, r1, r0
max r0.x, r0, c5
add_sat r1.x, -r0, c5.y
pow r0, r1.x, c4.x
mad r0.w, r0.x, c5.z, c5
texld r1.xyz, v0, s0
mul r1.xyz, r1, c3
add r1.xyz, r1, c2
mul_pp r2.xyz, r1, v3
mul_pp r0.xyz, r1, c1
max_pp r1.w, r1, c5.x
mul_pp r0.xyz, r1.w, r0
mad_pp r0.xyz, r0, c6.y, r2
max oC0.w, r0, c5.x
mad_pp oC0.xyz, r1, c6.x, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 20 ALU, 2 TEX
PARAM c[5] = { program.local[0..2],
		{ 0, 1, 0.79627001, 0.20373 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.x;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
MUL R1.xyz, R0.w, fragment.texcoord[1];
MUL R0.xyz, R0.y, fragment.texcoord[2];
DP3 R0.x, R1, R0;
MAX R0.x, R0, c[3];
ADD_SAT R0.x, -R0, c[3].y;
POW R0.x, R0.x, c[2].x;
MAD R0.w, R0.x, c[3].z, c[3];
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MUL R1.xyz, R0, c[1];
ADD R1.xyz, R1, c[0];
MAX result.color.w, R0, c[3].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MUL R0.xyz, R0.w, R0;
MUL R2.xyz, R1, c[4].y;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[4].x, R2;
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_3_0
; 20 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c4, 8.00000000, 0.25000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dp3 r0.x, v1, v1
rsq r0.w, r0.x
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
mul r1.xyz, r0.w, v1
mul_pp r0.xyz, r0.y, v2
dp3 r0.x, r1, r0
max r0.x, r0, c3
add_sat r1.x, -r0, c3.y
pow r0, r1.x, c2.x
mad r0.w, r0.x, c3.z, c3
texld r0.xyz, v0, s0
mul r1.xyz, r0, c1
add r1.xyz, r1, c0
max oC0.w, r0, c3.x
texld r0, v3, s1
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r1, c4.y
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c4.x, r2
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 20 ALU, 2 TEX
PARAM c[5] = { program.local[0..2],
		{ 0, 1, 0.79627001, 0.20373 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.x;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
MUL R1.xyz, R0.w, fragment.texcoord[1];
MUL R0.xyz, R0.y, fragment.texcoord[2];
DP3 R0.x, R1, R0;
MAX R0.x, R0, c[3];
ADD_SAT R0.x, -R0, c[3].y;
POW R0.x, R0.x, c[2].x;
MAD R0.w, R0.x, c[3].z, c[3];
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MUL R1.xyz, R0, c[1];
ADD R1.xyz, R1, c[0];
MAX result.color.w, R0, c[3].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MUL R0.xyz, R0.w, R0;
MUL R2.xyz, R1, c[4].y;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[4].x, R2;
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_3_0
; 20 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c4, 8.00000000, 0.25000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dp3 r0.x, v1, v1
rsq r0.w, r0.x
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
mul r1.xyz, r0.w, v1
mul_pp r0.xyz, r0.y, v2
dp3 r0.x, r1, r0
max r0.x, r0, c3
add_sat r1.x, -r0, c3.y
pow r0, r1.x, c2.x
mad r0.w, r0.x, c3.z, c3
texld r0.xyz, v0, s0
mul r1.xyz, r0, c1
add r1.xyz, r1, c0
max oC0.w, r0, c3.x
texld r0, v3, s1
mul_pp r0.xyz, r0.w, r0
mul_pp r2.xyz, r1, c4.y
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c4.x, r2
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		Blend SrcAlpha One
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 25 to 30
//   d3d9 - ALU: 25 to 30
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
"3.0-!!ARBvp1.0
# 29 ALU
PARAM c[20] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[15];
DP4 result.texcoord[4].y, R0, c[14];
DP4 result.texcoord[4].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
ADD result.texcoord[3].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 29 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c19, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mov r1.xyz, c17
mov r1.w, c19.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c19.y, -r0
mul r1.xyz, v1, c16.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
add o2.xyz, -r0, c17
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c18
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * texture2D (_LightTexture0, tmpvar_9).w) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * texture2D (_LightTexture0, tmpvar_9).w) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 25 ALU
PARAM c[16] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[1].xyz, -R0, c[14];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MOV result.texcoord[3].xyz, c[15];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 25 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 25 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mov r1.xyz, c13
mov r1.w, c15.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c15.y, -r0
mul r1.xyz, v1, c12.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o2.xyz, -r0, c13
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mov o4.xyz, c14
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lightDir = xlv_TEXCOORD3;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, lightDir)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lightDir = xlv_TEXCOORD3;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, lightDir)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
"3.0-!!ARBvp1.0
# 30 ALU
PARAM c[20] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[4].w, R0, c[16];
DP4 result.texcoord[4].z, R0, c[15];
DP4 result.texcoord[4].y, R0, c[14];
DP4 result.texcoord[4].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
ADD result.texcoord[3].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 30 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
; 30 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c19, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mov r1.xyz, c17
mov r1.w, c19.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c19.y, -r0
mul r1.xyz, v1, c16.w
dp4 r0.w, v0, c7
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 o5.w, r0, c15
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
add o2.xyz, -r0, c17
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c18
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_8;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_9).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * atten) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_8;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_9).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * atten) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
"3.0-!!ARBvp1.0
# 29 ALU
PARAM c[20] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[15];
DP4 result.texcoord[4].y, R0, c[14];
DP4 result.texcoord[4].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
ADD result.texcoord[3].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 29 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c19, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mov r1.xyz, c17
mov r1.w, c19.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c19.y, -r0
mul r1.xyz, v1, c16.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c14
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
add o2.xyz, -r0, c17
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c18
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * (texture2D (_LightTextureB0, tmpvar_9).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * (texture2D (_LightTextureB0, tmpvar_9).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
"3.0-!!ARBvp1.0
# 28 ALU
PARAM c[20] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].y, R0, c[14];
DP4 result.texcoord[4].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MOV result.texcoord[3].xyz, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 28 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c19, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mov r1.xyz, c17
mov r1.w, c19.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c19.y, -r0
mul r1.xyz, v1, c16.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.y, r0, c13
dp4 o5.x, r0, c12
add o2.xyz, -r0, c17
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mov o4.xyz, c18
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lightDir = xlv_TEXCOORD3;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_5).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_7;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (tmpvar_1 * unity_Scale.w));
  tmpvar_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  highp float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_5), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_2 = tmpvar_7;
  tmpvar_3 = tmpvar_6;
  lightDir = xlv_TEXCOORD3;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_i0_i1.w = tmpvar_3;
  c = c_i0_i1;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 21 to 32, TEX: 1 to 3
//   d3d9 - ALU: 23 to 32, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 26 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R1.xyz, R0.y, fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
MAX R0.x, R0, c[4].w;
ADD_SAT R0.x, -R0, c[4].z;
POW R0.w, R0.x, c[3].x;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MAD R0.w, R0, c[4].y, c[4].x;
MUL R0.xyz, R0, c[2];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
ADD R0.xyz, R0, c[1];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
TEX R1.w, R1.w, texture[1], 2D;
MAX R1.x, R1, c[4].w;
MUL R1.x, R1, R1.w;
MUL R0.xyz, R1.x, R0;
MAX result.color.w, R0, c[4];
MUL result.color.xyz, R0, c[5].x;
END
# 26 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_3_0
; 27 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c5, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4
add_sat r1.x, -r0, c4.y
pow r0, r1.x, c3.x
mov r0.w, r0.x
mad r1.w, r0, c4.z, c4
texld r0.xyz, v0, s0
mul r0.xyz, r0, c2
add r0.xyz, r0, c1
mul_pp r1.xyz, r0, c0
dp3_pp r0.w, v3, v3
rsq_pp r0.w, r0.w
mul_pp r0.yzw, r0.w, v3.xxyz
dp3_pp r0.y, v2, r0.yzww
dp3 r0.x, v4, v4
max_pp r0.y, r0, c4.x
texld r0.x, r0.x, s1
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
max oC0.w, r1, c4.x
mul_pp oC0.xyz, r0, c5.x
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 1 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
MAX R0.x, R0, c[4].w;
ADD_SAT R0.x, -R0, c[4].z;
POW R0.w, R0.x, c[3].x;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MAD R0.w, R0, c[4].y, c[4].x;
MUL R0.xyz, R0, c[2];
MOV R1.xyz, fragment.texcoord[3];
ADD R0.xyz, R0, c[1];
DP3 R1.x, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[4].w;
MUL R0.xyz, R1.x, R0;
MAX result.color.w, R0, c[4];
MUL result.color.xyz, R0, c[5].x;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
"ps_3_0
; 23 ALU, 1 TEX
dcl_cube s0
def c4, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c5, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4
add_sat r1.x, -r0, c4.y
pow r0, r1.x, c3.x
mov r0.w, r0.x
texld r0.xyz, v0, s0
mul r1.xyz, r0, c2
mov_pp r0.xyz, v3
mad r0.w, r0, c4.z, c4
add r1.xyz, r1, c1
dp3_pp r1.w, v2, r0
mul_pp r0.xyz, r1, c0
max_pp r1.x, r1.w, c4
mul_pp r0.xyz, r1.x, r0
max oC0.w, r0, c4.x
mul_pp oC0.xyz, r0, c5.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 32 ALU, 3 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 0.5, 2 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.y;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.w, fragment.texcoord[1];
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.x, R1, R0;
MAX R0.x, R0, c[4].w;
ADD_SAT R0.x, -R0, c[4].z;
POW R0.w, R0.x, c[3].x;
MAD R1.x, R0.w, c[4].y, c[4];
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MUL R0.xyz, R0, c[2];
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.w, R0.w;
MUL R1.yzw, R0.w, fragment.texcoord[3].xxyz;
DP3 R1.y, fragment.texcoord[2], R1.yzww;
RCP R0.w, fragment.texcoord[4].w;
MAD R1.zw, fragment.texcoord[4].xyxy, R0.w, c[5].x;
TEX R1.w, R1.zwzw, texture[1], 2D;
ADD R0.xyz, R0, c[1];
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
SLT R1.z, c[4].w, fragment.texcoord[4];
MUL R0.xyz, R0, c[0];
TEX R0.w, R0.w, texture[2], 2D;
MUL R1.z, R1, R1.w;
MUL R0.w, R1.z, R0;
MAX R1.y, R1, c[4].w;
MUL R0.w, R1.y, R0;
MUL R0.xyz, R0.w, R0;
MAX result.color.w, R1.x, c[4];
MUL result.color.xyz, R0, c[5].y;
END
# 32 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_3_0
; 32 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_2d s2
def c4, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c5, 0.50000000, 2.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4
add_sat r1.x, -r0, c4.y
pow r0, r1.x, c3.x
mov r0.w, r0.x
mad r1.w, r0, c4.z, c4
texld r0.xyz, v0, s0
mul r0.xyz, r0, c2
add r0.xyz, r0, c1
dp3_pp r0.w, v3, v3
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0, c0
mul_pp r0.xyz, r0.w, v3
dp3_pp r0.y, v2, r0
rcp r0.w, v4.w
mad r2.xy, v4, r0.w, c5.x
dp3 r0.x, v4, v4
max_pp r0.y, r0, c4.x
texld r0.w, r2, s1
cmp r0.z, -v4, c4.x, c4.y
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s2
mul_pp r0.x, r0.z, r0
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
max oC0.w, r1, c4.x
mul_pp oC0.xyz, r0, c5.y
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 28 ALU, 3 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.y;
MUL R1.xyz, R0.w, fragment.texcoord[1];
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.x, R1, R0;
MAX R0.x, R0, c[4].w;
ADD_SAT R0.x, -R0, c[4].z;
POW R0.x, R0.x, c[3].x;
MAD R1.x, R0, c[4].y, c[4];
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.w, R0.w;
MUL R1.yzw, R0.w, fragment.texcoord[3].xxyz;
DP3 R1.y, fragment.texcoord[2], R1.yzww;
MUL R0.xyz, R0, c[2];
ADD R0.xyz, R0, c[1];
DP3 R1.z, fragment.texcoord[4], fragment.texcoord[4];
MUL R0.xyz, R0, c[0];
TEX R0.w, fragment.texcoord[4], texture[2], CUBE;
TEX R1.w, R1.z, texture[1], 2D;
MUL R0.w, R1, R0;
MAX R1.y, R1, c[4].w;
MUL R0.w, R1.y, R0;
MUL R0.xyz, R0.w, R0;
MAX result.color.w, R1.x, c[4];
MUL result.color.xyz, R0, c[5].x;
END
# 28 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_3_0
; 27 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_cube s2
def c4, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c5, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4
add_sat r1.x, -r0, c4.y
pow r0, r1.x, c3.x
mad r1.w, r0.x, c4.z, c4
texld r0.xyz, v0, s0
mul r0.xyz, r0, c2
add r1.xyz, r0, c1
dp3_pp r0.w, v3, v3
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v3
dp3_pp r0.y, v2, r0
dp3 r0.x, v4, v4
max_pp r0.y, r0, c4.x
mul_pp r1.xyz, r1, c0
texld r0.w, v4, s2
texld r0.x, r0.x, s1
mul r0.x, r0, r0.w
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
max oC0.w, r1, c4.x
mul_pp oC0.xyz, r0, c5.x
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
DP3 R0.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
MAX R0.x, R0, c[4].w;
ADD_SAT R0.w, -R0.x, c[4].z;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
POW R0.w, R0.w, c[3].x;
MUL R0.xyz, R0, c[2];
MAD R0.w, R0, c[4].y, c[4].x;
ADD R0.xyz, R0, c[1];
MOV R1.xyz, fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
TEX R1.w, fragment.texcoord[4], texture[1], 2D;
MAX R1.x, R1, c[4].w;
MUL R1.x, R1, R1.w;
MUL R0.xyz, R1.x, R0;
MAX result.color.w, R0, c[4];
MUL result.color.xyz, R0, c[5].x;
END
# 23 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_3_0
; 23 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 0.79627001, 0.20373000
def c5, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dp3_pp r0.y, v2, v2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, v2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4
add_sat r1.x, -r0, c4.y
pow r0, r1.x, c3.x
mad r0.w, r0.x, c4.z, c4
mov_pp r0.xyz, v3
dp3_pp r0.x, v2, r0
texld r1.xyz, v0, s0
mul r1.xyz, r1, c2
add r1.xyz, r1, c1
mul_pp r1.xyz, r1, c0
texld r1.w, v4, s1
max_pp r0.x, r0, c4
mul_pp r0.x, r0, r1.w
mul_pp r0.xyz, r0.x, r1
max oC0.w, r0, c4.x
mul_pp oC0.xyz, r0, c5.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}

#LINE 45


}
	
FallBack "Reflective/VertexLit"
} 

