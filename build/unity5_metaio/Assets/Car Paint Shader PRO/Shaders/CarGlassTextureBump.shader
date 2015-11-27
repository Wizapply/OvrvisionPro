Shader "RedDotGames/Car Glass with Texture + Bump" {
Properties {
	_Color ("Main Color (RGB)", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color (RGB)", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {} 
	_Cube ("Reflection Cubemap (CUBE)", Cube) = "_Skybox" { TexGen CubeReflect }
	_BumpMap ("Normal Map", 2D) = "bump" {}
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
//   opengl - ALU: 34 to 89
//   d3d9 - ALU: 35 to 92
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 58 ALU
PARAM c[24] = { { 1 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[18];
DP4 R2.y, R0, c[17];
DP4 R2.x, R0, c[16];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[21];
DP4 R3.y, R1, c[20];
DP4 R3.x, R1, c[19];
ADD R2.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R3.xyz, R0.x, c[22];
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[6].xyz, R2, R3;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R0, c[15];
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[13].w, -vertex.position;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP3 R0.y, R3, c[5];
DP3 R0.w, -R2, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[13].w;
DP3 R0.y, R3, c[6];
DP3 R0.w, -R2, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[13].w;
DP3 R0.y, R3, c[7];
DP3 R0.w, -R2, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
DP3 result.texcoord[1].y, R2, R3;
DP3 result.texcoord[5].y, R3, R1;
MUL result.texcoord[4], R0, c[13].w;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 58 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [_MainTex_ST]
"vs_3_0
; 61 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c12.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c23.x
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c20
dp4 r3.y, r1, c19
dp4 r3.x, r1, c18
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c21
add o7.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1.w, c23.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c12.w
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c22, c22.zwzw
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_23;
  mediump vec4 normal;
  normal = tmpvar_22;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal);
  x1.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal);
  x1.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal);
  x1.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC);
  x3 = tmpvar_32;
  tmpvar_23 = ((x1 + x2) + x3);
  shlight = tmpvar_23;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_14, xlv_TEXCOORD5));
  highp vec3 tmpvar_22;
  tmpvar_22 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_21) * 2.0);
  c_i0_i1.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_10;
  c_i0_i1.w = tmpvar_23;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_23;
  mediump vec4 normal;
  normal = tmpvar_22;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHAr, normal);
  x1.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAg, normal);
  x1.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAb, normal);
  x1.z = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHBr, tmpvar_27);
  x2.x = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBg, tmpvar_27);
  x2.y = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBb, tmpvar_27);
  x2.z = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (unity_SHC.xyz * vC);
  x3 = tmpvar_32;
  tmpvar_23 = ((x1 + x2) + x3);
  shlight = tmpvar_23;
  tmpvar_7 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_21).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (normal, xlv_TEXCOORD5));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_20) * 2.0);
  c_i0_i1.xyz = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = tmpvar_10;
  c_i0_i1.w = tmpvar_22;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 34 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
MAD R1.xyz, R1, c[13].w, -vertex.position;
DP3 R0.y, R2, c[5];
DP3 R0.w, -R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[13].w;
DP3 R0.y, R2, c[6];
DP3 R0.w, -R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[13].w;
DP3 R0.y, R2, c[7];
DP3 R0.w, -R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
DP3 result.texcoord[1].y, R1, R2;
MUL result.texcoord[4], R0, c[13].w;
DP3 result.texcoord[1].z, vertex.normal, R1;
DP3 result.texcoord[1].x, R1, vertex.attrib[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c12.w, -v0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r1, r2
mul o5, r0, c12.w
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
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

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_9 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz));
  c.w = tmpvar_10;
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
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

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  c.xyz = (tmpvar_9 * ((8.0 * tmpvar_20.w) * tmpvar_20.xyz));
  c.w = tmpvar_10;
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 34 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R2.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
MAD R1.xyz, R1, c[13].w, -vertex.position;
DP3 R0.y, R2, c[5];
DP3 R0.w, -R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[13].w;
DP3 R0.y, R2, c[6];
DP3 R0.w, -R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[13].w;
DP3 R0.y, R2, c[7];
DP3 R0.w, -R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
DP3 result.texcoord[1].y, R1, R2;
MUL result.texcoord[4], R0, c[13].w;
DP3 result.texcoord[1].z, vertex.normal, R1;
DP3 result.texcoord[1].x, R1, vertex.attrib[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[5].xy, vertex.texcoord[1], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c16.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c12.w, -v0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r1, r2
mul o5, r0, c12.w
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
mad o1.xy, v3, c15, c15.zwzw
mad o6.xy, v4, c14, c14.zwzw
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

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize (xlv_TEXCOORD1);
  mediump vec4 tmpvar_22;
  mediump vec3 viewDir;
  viewDir = tmpvar_21;
  highp float nh;
  mediump vec3 normal;
  normal = tmpvar_14;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_23;
  tmpvar_23 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz);
  lm_i0 = tmpvar_23;
  lowp vec3 tmpvar_24;
  tmpvar_24 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD5).xyz);
  scalePerBasisVector_i0 = tmpvar_24;
  lm_i0 = (lm_i0 * dot (clamp ((mat3(0.816497, -0.408248, -0.408248, 0.0, 0.707107, -0.707107, 0.57735, 0.57735, 0.57735) * normal), 0.0, 1.0), scalePerBasisVector_i0));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.0, dot (tmpvar_14, normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = lm_i0;
  tmpvar_26.w = pow (nh, 0.0);
  tmpvar_22 = tmpvar_26;
  c.xyz = vec3(0.0, 0.0, 0.0);
  mediump vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_9 * tmpvar_22.xyz);
  c.xyz = tmpvar_27;
  c.w = tmpvar_10;
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
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

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)));
  highp mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (tmpvar_10 * v_i0_i1.xyz);
  tmpvar_11.w = tmpvar_8.x;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * unity_Scale.w);
  tmpvar_3 = tmpvar_12;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_10 * v_i0_i1_i2.xyz);
  tmpvar_13.w = tmpvar_8.y;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_4 = tmpvar_14;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_10 * v_i0_i1_i2_i3.xyz);
  tmpvar_15.w = tmpvar_8.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_10 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (unity_Lightmap, xlv_TEXCOORD5);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (unity_LightmapInd, xlv_TEXCOORD5);
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD1);
  mediump vec4 tmpvar_23;
  mediump vec3 viewDir;
  viewDir = tmpvar_22;
  highp float nh;
  mediump vec3 normal_i0;
  normal_i0 = normal;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_24;
  tmpvar_24 = ((8.0 * tmpvar_20.w) * tmpvar_20.xyz);
  lm_i0 = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = ((8.0 * tmpvar_21.w) * tmpvar_21.xyz);
  scalePerBasisVector_i0 = tmpvar_25;
  lm_i0 = (lm_i0 * dot (clamp ((mat3(0.816497, -0.408248, -0.408248, 0.0, 0.707107, -0.707107, 0.57735, 0.57735, 0.57735) * normal_i0), 0.0, 1.0), scalePerBasisVector_i0));
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, dot (normal, normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27.xyz = lm_i0;
  tmpvar_27.w = pow (nh, 0.0);
  tmpvar_23 = tmpvar_27;
  c.xyz = vec3(0.0, 0.0, 0.0);
  mediump vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_9 * tmpvar_23.xyz);
  c.xyz = tmpvar_28;
  c.w = tmpvar_10;
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 89 ALU
PARAM c[32] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..31] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[13].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[17];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[16];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[18];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[19];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[21];
MAD R1.xyz, R0.x, c[20], R1;
MAD R0.xyz, R0.z, c[22], R1;
MAD R1.xyz, R0.w, c[23], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[29];
DP4 R3.y, R0, c[28];
DP4 R3.x, R0, c[27];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
MOV R1.w, c[0].x;
DP4 R2.z, R4, c[26];
DP4 R2.y, R4, c[25];
DP4 R2.x, R4, c[24];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[30];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[6].xyz, R3, R1;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1.xyz, c[14];
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R0, c[15];
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[13].w, -vertex.position;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP3 R0.y, R3, c[5];
DP3 R0.w, -R2, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[13].w;
DP3 R0.y, R3, c[6];
DP3 R0.w, -R2, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[13].w;
DP3 R0.y, R3, c[7];
DP3 R0.w, -R2, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
DP3 result.texcoord[1].y, R2, R3;
DP3 result.texcoord[5].y, R3, R1;
MUL result.texcoord[4], R0, c[13].w;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[31], c[31].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 89 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
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
Vector 30 [_MainTex_ST]
"vs_3_0
; 92 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c31, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c16
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c15
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c31.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c17
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c18
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c25
dp4 r2.y, r4, c24
dp4 r2.x, r4, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mad r1.xyz, r0.w, c22, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c28
dp4 r3.y, r0, c27
dp4 r3.x, r0, c26
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c29
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add o7.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1.w, c31.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c12.w
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c30, c30.zwzw
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
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

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_20;
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_20.x) + (tmpvar_36 * tmpvar_20.y)) + (tmpvar_37 * tmpvar_20.z)) * inversesqrt (tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_7 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_14, xlv_TEXCOORD5));
  highp vec3 tmpvar_22;
  tmpvar_22 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_21) * 2.0);
  c_i0_i1.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_10;
  c_i0_i1.w = tmpvar_23;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
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

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_glesVertex.xyz - ((_World2Object * tmpvar_8).xyz * unity_Scale.w)));
  highp mat3 tmpvar_11;
  tmpvar_11[0] = tmpvar_1.xyz;
  tmpvar_11[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_11[2] = tmpvar_2;
  mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_11[0].x;
  tmpvar_12[0].y = tmpvar_11[1].x;
  tmpvar_12[0].z = tmpvar_11[2].x;
  tmpvar_12[1].x = tmpvar_11[0].y;
  tmpvar_12[1].y = tmpvar_11[1].y;
  tmpvar_12[1].z = tmpvar_11[2].y;
  tmpvar_12[2].x = tmpvar_11[0].z;
  tmpvar_12[2].y = tmpvar_11[1].z;
  tmpvar_12[2].z = tmpvar_11[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_13;
  tmpvar_13.xyz = (tmpvar_12 * v_i0_i1.xyz);
  tmpvar_13.w = tmpvar_10.x;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * unity_Scale.w);
  tmpvar_3 = tmpvar_14;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = (tmpvar_12 * v_i0_i1_i2.xyz);
  tmpvar_15.w = tmpvar_10.y;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * unity_Scale.w);
  tmpvar_4 = tmpvar_16;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_i0_i1_i2_i3.xyz);
  tmpvar_17.w = tmpvar_10.z;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_12 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_20;
  mediump vec3 tmpvar_24;
  mediump vec4 normal;
  normal = tmpvar_23;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHAr, normal);
  x1.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAg, normal);
  x1.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAb, normal);
  x1.z = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHBr, tmpvar_28);
  x2.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBg, tmpvar_28);
  x2.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBb, tmpvar_28);
  x2.z = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (unity_SHC.xyz * vC);
  x3 = tmpvar_33;
  tmpvar_24 = ((x1 + x2) + x3);
  shlight = tmpvar_24;
  tmpvar_7 = shlight;
  highp vec3 tmpvar_34;
  tmpvar_34 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_35;
  tmpvar_35 = (unity_4LightPosX0 - tmpvar_34.x);
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosY0 - tmpvar_34.y);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosZ0 - tmpvar_34.z);
  highp vec4 tmpvar_38;
  tmpvar_38 = (((tmpvar_35 * tmpvar_35) + (tmpvar_36 * tmpvar_36)) + (tmpvar_37 * tmpvar_37));
  highp vec4 tmpvar_39;
  tmpvar_39 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_35 * tmpvar_20.x) + (tmpvar_36 * tmpvar_20.y)) + (tmpvar_37 * tmpvar_20.z)) * inversesqrt (tmpvar_38))) * (1.0/((1.0 + (tmpvar_38 * unity_4LightAtten0)))));
  highp vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 + ((((unity_LightColor[0].xyz * tmpvar_39.x) + (unity_LightColor[1].xyz * tmpvar_39.y)) + (unity_LightColor[2].xyz * tmpvar_39.z)) + (unity_LightColor[3].xyz * tmpvar_39.w)));
  tmpvar_7 = tmpvar_40;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (normal, xlv_TEXCOORD5));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_20) * 2.0);
  c_i0_i1.xyz = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = tmpvar_10;
  c_i0_i1.w = tmpvar_22;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_9 * xlv_TEXCOORD6));
  c.xyz = (c.xyz + (tmpvar_9 * 0.25));
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 3
//   opengl - ALU: 38 to 46, TEX: 3 to 5
//   d3d9 - ALU: 36 to 42, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 40 ALU, 3 TEX
PARAM c[6] = { program.local[0..3],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R2.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.x, R2.y, R2.y;
MAD R0.x, -R2, R2, -R0;
ADD R0.x, R0, c[4].y;
RSQ R0.x, R0.x;
RCP R2.z, R0.x;
DP3 R0.y, R2, R2;
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, R2;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R0, R1;
MAX R0.w, R0, c[4].z;
ADD_SAT R0.w, -R0, c[4].y;
POW R0.w, R0.w, c[3].x;
MUL R0.w, R0, c[4];
ADD R0.w, R0, c[5].x;
DP3 R1.x, R2, fragment.texcoord[2];
DP3 R1.y, R2, fragment.texcoord[3];
DP3 R1.z, R2, fragment.texcoord[4];
MOV R0.x, fragment.texcoord[2].w;
MOV R0.z, fragment.texcoord[4].w;
MOV R0.y, fragment.texcoord[3].w;
DP3 R1.w, R1, R0;
MUL R1.xyz, R1, R1.w;
MAD R0.xyz, -R1, c[4].x, R0;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
DP3 R1.w, R2, fragment.texcoord[5];
MUL R1.xyz, R1, c[1];
TEX R0.xyz, R0, texture[2], CUBE;
MAD R0.xyz, R0, c[2], R1;
MAX R1.w, R1, c[4].z;
MUL R1.xyz, R0, c[0];
MUL R1.xyz, R1, R1.w;
MUL R1.xyz, R1, c[4].x;
MAD R1.xyz, R0, fragment.texcoord[6], R1;
MAD result.color.xyz, R0, c[5].y, R1;
MAX result.color.w, R0, c[4].z;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 38 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c4, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c5, 0.79627001, 0.20373000, 0.25000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
texld r0.yw, v0, s1
mad_pp r2.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.y, r2, r2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, r2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.w, r0.x, c4
dp3_pp r0.x, r2, v2
dp3_pp r0.y, r2, v3
dp3_pp r0.z, r2, v4
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r2.w, r0, r1
mul r3.xyz, r0, r2.w
mad r1.xyz, -r3, c4.x, r1
add_sat r1.w, -r0, c4.z
pow r0, r1.w, c3.x
dp3_pp r0.y, r2, v5
max_pp r0.y, r0, c4.w
texld r3.xyz, v0, s0
mad r0.x, r0, c5, c5.y
texld r1.xyz, r1, s2
mul r3.xyz, r3, c1
mad r1.xyz, r1, c2, r3
mul_pp r2.xyz, r1, c0
mul_pp r2.xyz, r2, r0.y
mul r2.xyz, r2, c4.x
mad_pp r2.xyz, r1, v6, r2
mad_pp oC0.xyz, r1, c5.z, r2
max oC0.w, r0.x, c4
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 38 ALU, 4 TEX
PARAM c[5] = { program.local[0..2],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R1.xy, R0.wyzw, c[3].x, -c[3].y;
MUL R0.x, R1.y, R1.y;
MAD R0.x, -R1, R1, -R0;
ADD R0.x, R0, c[3].y;
RSQ R0.x, R0.x;
RCP R1.z, R0.x;
DP3 R0.y, R1, R1;
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R0.y, R1;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R2;
MAX R0.w, R0.x, c[3].z;
DP3 R0.x, R1, fragment.texcoord[2];
DP3 R0.y, R1, fragment.texcoord[3];
DP3 R0.z, R1, fragment.texcoord[4];
MOV R1.x, fragment.texcoord[2].w;
MOV R1.z, fragment.texcoord[4].w;
MOV R1.y, fragment.texcoord[3].w;
DP3 R1.w, R0, R1;
MUL R0.xyz, R0, R1.w;
MAD R1.xyz, -R0, c[3].x, R1;
ADD_SAT R0.w, -R0, c[3].y;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
POW R1.w, R0.w, c[2].x;
MUL R2.xyz, R0, c[0];
TEX R0, fragment.texcoord[5], texture[3], 2D;
MUL R0.xyz, R0.w, R0;
TEX R1.xyz, R1, texture[2], CUBE;
MAD R1.xyz, R1, c[1], R2;
MUL R0.xyz, R0, R1;
MUL R0.w, R1, c[3];
MUL R1.xyz, R1, c[4].z;
ADD R0.w, R0, c[4].x;
MAD result.color.xyz, R0, c[4].y, R1;
MAX result.color.w, R0, c[3].z;
END
# 38 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [unity_Lightmap] 2D
"ps_3_0
; 36 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c3, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c4, 0.79627001, 0.20373000, 0.25000000, 8.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c3.x, c3.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
dp3 r1.x, v1, v1
rsq r1.w, r1.x
add_pp r0.z, r0, c3
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r2.xyz, r1.w, v1
dp3 r0.w, r2, r1
max r0.w, r0, c3
add_sat r1.w, -r0, c3.z
dp3_pp r2.x, r0, v2
dp3_pp r2.y, r0, v3
dp3_pp r2.z, r0, v4
pow r0, r1.w, c2.x
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r2.w, r2, r1
mul r2.xyz, r2, r2.w
mad r2.xyz, -r2, c3.x, r1
texld r1.xyz, v0, s0
mul r0.yzw, r1.xxyz, c0.xxyz
texld r2.xyz, r2, s2
mad r2.xyz, r2, c1, r0.yzww
mov r0.w, r0.x
texld r1, v5, s3
mul_pp r1.xyz, r1.w, r1
mad r0.w, r0, c4.x, c4.y
mul_pp r1.xyz, r1, r2
mul_pp r0.xyz, r2, c4.z
mad_pp oC0.xyz, r1, c4.w, r0
max oC0.w, r0, c3
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 46 ALU, 5 TEX
PARAM c[7] = { program.local[0..2],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, -0.40824828, -0.70710677, 0.57735026 },
		{ -0.40824831, 0.70710677, 0.57735026, 8 },
		{ 0.81649655, 0, 0.57735026, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R1.xy, R0.wyzw, c[3].x, -c[3].y;
MUL R0.x, R1.y, R1.y;
MAD R0.x, -R1, R1, -R0;
ADD R0.x, R0, c[3].y;
RSQ R1.z, R0.x;
TEX R0, fragment.texcoord[5], texture[4], 2D;
RCP R1.z, R1.z;
MUL R2.xyz, R0.w, R0;
DP3_SAT R0.z, R1, c[4].yzww;
DP3_SAT R0.x, R1, c[6];
DP3_SAT R0.y, R1, c[5];
MUL R0.xyz, R2, R0;
DP3 R2.y, R1, R1;
DP3 R1.w, R0, c[5].w;
TEX R0, fragment.texcoord[5], texture[3], 2D;
RSQ R2.y, R2.y;
MUL R0.xyz, R0.w, R0;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R3.xyz, R2.y, R1;
RSQ R2.x, R2.x;
MUL R2.xyz, R2.x, fragment.texcoord[1];
DP3 R2.x, R2, R3;
MAX R0.w, R2.x, c[3].z;
ADD_SAT R0.w, -R0, c[3].y;
POW R0.w, R0.w, c[2].x;
MUL R0.w, R0, c[3];
ADD R0.w, R0, c[4].x;
DP3 R3.x, R1, fragment.texcoord[2];
DP3 R3.y, R1, fragment.texcoord[3];
DP3 R3.z, R1, fragment.texcoord[4];
MOV R2.x, fragment.texcoord[2].w;
MOV R2.z, fragment.texcoord[4].w;
MOV R2.y, fragment.texcoord[3].w;
DP3 R1.x, R3, R2;
MUL R3.xyz, R3, R1.x;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R2.xyz, -R3, c[3].x, R2;
MUL R0.xyz, R0, R1.w;
MUL R1.xyz, R1, c[0];
TEX R2.xyz, R2, texture[2], CUBE;
MAD R1.xyz, R2, c[1], R1;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R1, c[6].w;
MAD result.color.xyz, R0, c[5].w, R1;
MAX result.color.w, R0, c[3].z;
END
# 46 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_3_0
; 42 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
def c3, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c4, 0.79627001, 0.20373000, 8.00000000, 0.25000000
def c5, -0.40824828, -0.70710677, 0.57735026, 0
def c6, -0.40824831, 0.70710677, 0.57735026, 0
def c7, 0.81649655, 0.00000000, 0.57735026, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xy
texld r1, v5, s4
texld r0.yw, v0, s1
mad_pp r0.xy, r0.wyzw, c3.x, c3.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c3
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
mul_pp r2.xyz, r1.w, r1
dp3_pp_sat r1.z, r0, c5
dp3_pp_sat r1.x, r0, c7
dp3_pp_sat r1.y, r0, c6
mul_pp r1.xyz, r2, r1
dp3_pp r0.w, r1, c4.z
dp3_pp r1.y, r0, r0
rsq_pp r1.y, r1.y
dp3 r1.x, v1, v1
mul_pp r2.xyz, r1.y, r0
rsq r1.x, r1.x
mul r1.xyz, r1.x, v1
dp3 r2.x, r1, r2
texld r1, v5, s3
mul_pp r1.xyz, r1.w, r1
mul_pp r3.xyz, r1, r0.w
max r2.x, r2, c3.w
add_sat r1.w, -r2.x, c3.z
dp3_pp r2.x, r0, v2
dp3_pp r2.y, r0, v3
dp3_pp r2.z, r0, v4
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r2.w, r2, r1
pow r0, r1.w, c2.x
mul r0.yzw, r2.xxyz, r2.w
texld r2.xyz, v0, s0
mad r1.xyz, -r0.yzww, c3.x, r1
mad r0.x, r0, c4, c4.y
mul r2.xyz, r2, c0
texld r1.xyz, r1, s2
mad r1.xyz, r1, c1, r2
mul_pp r2.xyz, r3, r1
mul_pp r1.xyz, r1, c4.w
mad_pp oC0.xyz, r2, c4.z, r1
max oC0.w, r0.x, c3
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
//   opengl - ALU: 40 to 49
//   d3d9 - ALU: 43 to 52
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 48 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MOV R1, c[19];
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R3.xyz, R2, c[17].w, -vertex.position;
MUL R2.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
MOV R0.w, c[0].x;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
MAD R1.xyz, R1, c[17].w, -vertex.position;
DP3 R0.y, R2, c[5];
DP3 R0.w, -R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[17].w;
DP3 R0.y, R2, c[6];
DP3 R0.w, -R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[17].w;
DP3 R0.y, R2, c[7];
DP3 R0.w, -R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[4], R0, c[17].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].y, R1, R2;
DP3 result.texcoord[5].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R1;
DP3 result.texcoord[1].x, R1, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R3;
DP3 result.texcoord[5].x, vertex.attrib[14], R3;
DP4 result.texcoord[6].z, R0, c[15];
DP4 result.texcoord[6].y, R0, c[14];
DP4 result.texcoord[6].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 48 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 51 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r2.xyz, v2.zxyw, r0.yzxw
mov r1, c10
dp4 r3.z, c18, r1
mov r1, c9
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r2
mov r2, c8
dp4 r3.x, c18, r2
mul r2.xyz, r0, v1.w
dp4 r3.y, c18, r1
mad r3.xyz, r3, c16.w, -v0
mov r0.xyz, c17
mov r0.w, c20.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c16.w, -v0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c16.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c16.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c16.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r1, r2
dp3 o6.y, r2, r3
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp3 o6.z, v2, r3
dp3 o6.x, v1, r3
dp4 o7.z, r0, c14
dp4 o7.y, r0, c13
dp4 o7.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
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

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (xlv_TEXCOORD5);
  lightDir = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = vec2(dot (xlv_TEXCOORD6, xlv_TEXCOORD6));
  lowp float atten;
  atten = texture2D (_LightTexture0, tmpvar_22).w;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (tmpvar_14, lightDir));
  highp vec3 tmpvar_24;
  tmpvar_24 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_23) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_10;
  c_i0_i1.w = tmpvar_25;
  c = c_i0_i1;
  c.w = tmpvar_10;
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

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD5);
  lightDir = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = vec2(dot (xlv_TEXCOORD6, xlv_TEXCOORD6));
  lowp float atten;
  atten = texture2D (_LightTexture0, tmpvar_21).w;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (normal, lightDir));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_22) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_10;
  c_i0_i1.w = tmpvar_24;
  c = c_i0_i1;
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[17] = { { 1 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R0, c[15];
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[13].w, -vertex.position;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP3 R0.y, R3, c[5];
DP3 R0.w, -R2, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[13].w;
DP3 R0.y, R3, c[6];
DP3 R0.w, -R2, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[13].w;
DP3 R0.y, R3, c[7];
DP3 R0.w, -R2, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
DP3 result.texcoord[1].y, R2, R3;
DP3 result.texcoord[5].y, R3, R1;
MUL result.texcoord[4], R0, c[13].w;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [_MainTex_ST]
"vs_3_0
; 43 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
mov r1.w, c16.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c12.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c12.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c12.w
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o1.xy, v3, c15, c15.zwzw
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

varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  lightDir = xlv_TEXCOORD5;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_14, lightDir));
  highp vec3 tmpvar_22;
  tmpvar_22 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_21) * 2.0);
  c_i0_i1.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_10;
  c_i0_i1.w = tmpvar_23;
  c = c_i0_i1;
  c.w = tmpvar_10;
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

varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  lightDir = xlv_TEXCOORD5;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (normal, lightDir));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_20) * 2.0);
  c_i0_i1.xyz = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = tmpvar_10;
  c_i0_i1.w = tmpvar_22;
  c = c_i0_i1;
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 49 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MOV R1, c[19];
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R3.xyz, R2, c[17].w, -vertex.position;
MUL R2.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
MOV R0.w, c[0].x;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
MAD R1.xyz, R1, c[17].w, -vertex.position;
DP3 R0.y, R2, c[5];
DP3 R0.w, -R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[17].w;
DP3 R0.y, R2, c[6];
DP3 R0.w, -R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[17].w;
DP3 R0.y, R2, c[7];
DP3 R0.w, -R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[4], R0, c[17].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].y, R1, R2;
DP3 result.texcoord[5].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R1;
DP3 result.texcoord[1].x, R1, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R3;
DP3 result.texcoord[5].x, vertex.attrib[14], R3;
DP4 result.texcoord[6].w, R0, c[16];
DP4 result.texcoord[6].z, R0, c[15];
DP4 result.texcoord[6].y, R0, c[14];
DP4 result.texcoord[6].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 49 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 52 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r2.xyz, v2.zxyw, r0.yzxw
mov r1, c10
dp4 r3.z, c18, r1
mov r1, c9
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r2
mov r2, c8
dp4 r3.x, c18, r2
mul r2.xyz, r0, v1.w
dp4 r3.y, c18, r1
mad r3.xyz, r3, c16.w, -v0
mov r0.xyz, c17
mov r0.w, c20.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c16.w, -v0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c16.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c16.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c16.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r1, r2
dp3 o6.y, r2, r3
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp3 o6.z, v2, r3
dp3 o6.x, v1, r3
dp4 o7.w, r0, c15
dp4 o7.z, r0, c14
dp4 o7.y, r0, c13
dp4 o7.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
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

varying highp vec4 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (xlv_TEXCOORD5);
  lightDir = tmpvar_21;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD6.xyz;
  highp vec2 tmpvar_22;
  tmpvar_22 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD6.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD6.xy / xlv_TEXCOORD6.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_22).w);
  lowp vec4 c_i0_i1;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (tmpvar_14, lightDir));
  highp vec3 tmpvar_24;
  tmpvar_24 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_23) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_10;
  c_i0_i1.w = tmpvar_25;
  c = c_i0_i1;
  c.w = tmpvar_10;
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

varying highp vec4 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD5);
  lightDir = tmpvar_20;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD6.xyz;
  highp vec2 tmpvar_21;
  tmpvar_21 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD6.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD6.xy / xlv_TEXCOORD6.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_21).w);
  lowp vec4 c_i0_i1;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (normal, lightDir));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_22) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_10;
  c_i0_i1.w = tmpvar_24;
  c = c_i0_i1;
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 48 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MOV R1, c[19];
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R3.xyz, R2, c[17].w, -vertex.position;
MUL R2.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
MOV R0.w, c[0].x;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
MAD R1.xyz, R1, c[17].w, -vertex.position;
DP3 R0.y, R2, c[5];
DP3 R0.w, -R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[17].w;
DP3 R0.y, R2, c[6];
DP3 R0.w, -R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[17].w;
DP3 R0.y, R2, c[7];
DP3 R0.w, -R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[4], R0, c[17].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].y, R1, R2;
DP3 result.texcoord[5].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R1;
DP3 result.texcoord[1].x, R1, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R3;
DP3 result.texcoord[5].x, vertex.attrib[14], R3;
DP4 result.texcoord[6].z, R0, c[15];
DP4 result.texcoord[6].y, R0, c[14];
DP4 result.texcoord[6].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 48 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 51 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r2.xyz, v2.zxyw, r0.yzxw
mov r1, c10
dp4 r3.z, c18, r1
mov r1, c9
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r2
mov r2, c8
dp4 r3.x, c18, r2
mul r2.xyz, r0, v1.w
dp4 r3.y, c18, r1
mad r3.xyz, r3, c16.w, -v0
mov r0.xyz, c17
mov r0.w, c20.x
dp4 r1.z, r0, c10
dp4 r1.x, r0, c8
dp4 r1.y, r0, c9
mad r1.xyz, r1, c16.w, -v0
dp3 r0.y, r2, c4
dp3 r0.w, -r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c16.w
dp3 r0.y, r2, c5
dp3 r0.w, -r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c16.w
dp3 r0.y, r2, c6
dp3 r0.w, -r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c16.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r1, r2
dp3 o6.y, r2, r3
dp3 o2.z, v2, r1
dp3 o2.x, r1, v1
dp3 o6.z, v2, r3
dp3 o6.x, v1, r3
dp4 o7.z, r0, c14
dp4 o7.y, r0, c13
dp4 o7.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
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

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (xlv_TEXCOORD5);
  lightDir = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22 = vec2(dot (xlv_TEXCOORD6, xlv_TEXCOORD6));
  lowp float atten;
  atten = (texture2D (_LightTextureB0, tmpvar_22).w * textureCube (_LightTexture0, xlv_TEXCOORD6).w);
  lowp vec4 c_i0_i1;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (tmpvar_14, lightDir));
  highp vec3 tmpvar_24;
  tmpvar_24 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_23) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_10;
  c_i0_i1.w = tmpvar_25;
  c = c_i0_i1;
  c.w = tmpvar_10;
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

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD5);
  lightDir = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = vec2(dot (xlv_TEXCOORD6, xlv_TEXCOORD6));
  lowp float atten;
  atten = (texture2D (_LightTextureB0, tmpvar_21).w * textureCube (_LightTexture0, xlv_TEXCOORD6).w);
  lowp vec4 c_i0_i1;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (normal, lightDir));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_22) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_10;
  c_i0_i1.w = tmpvar_24;
  c = c_i0_i1;
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 46 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R0, c[19];
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[17].w, -vertex.position;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP3 R0.y, R3, c[5];
DP3 R0.w, -R2, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[17].w;
DP3 R0.y, R3, c[6];
DP3 R0.w, -R2, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[17].w;
DP3 R0.y, R3, c[7];
DP3 R0.w, -R2, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[4], R0, c[17].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].y, R2, R3;
DP3 result.texcoord[5].y, R3, R1;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
DP4 result.texcoord[6].y, R0, c[14];
DP4 result.texcoord[6].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 46 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_3_0
; 49 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1.w, c20.x
mov r1.xyz, c17
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c16.w, -v0
mov r1, c8
dp4 r4.x, c18, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c16.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c16.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c16.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r2, r3
dp3 o6.y, r3, r4
dp3 o2.z, v2, r2
dp3 o2.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
dp4 o7.y, r0, c13
dp4 o7.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
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

varying highp vec2 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec3 tmpvar_14;
  lowp vec4 packednormal;
  packednormal = bump;
  tmpvar_14 = ((packednormal.xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_2, tmpvar_14);
  tmpvar_15.y = dot (tmpvar_3, tmpvar_14);
  tmpvar_15.z = dot (tmpvar_4, tmpvar_14);
  highp vec3 tmpvar_16;
  tmpvar_16 = reflect (tmpvar_1, tmpvar_15);
  worldReflVec = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = normalize (tmpvar_14);
  highp float tmpvar_19;
  tmpvar_19 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_18), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_20;
  tmpvar_10 = tmpvar_19;
  lightDir = xlv_TEXCOORD5;
  lowp float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD6).w;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_21;
  tmpvar_21 = max (0.0, dot (tmpvar_14, lightDir));
  highp vec3 tmpvar_22;
  tmpvar_22 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_21) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_10;
  c_i0_i1.w = tmpvar_23;
  c = c_i0_i1;
  c.w = tmpvar_10;
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

varying highp vec2 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  lowp vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  mediump vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp mat3 tmpvar_10;
  tmpvar_10[0] = tmpvar_1.xyz;
  tmpvar_10[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_10[2] = tmpvar_2;
  mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_10[0].x;
  tmpvar_11[0].y = tmpvar_10[1].x;
  tmpvar_11[0].z = tmpvar_10[2].x;
  tmpvar_11[1].x = tmpvar_10[0].y;
  tmpvar_11[1].y = tmpvar_10[1].y;
  tmpvar_11[1].z = tmpvar_10[2].y;
  tmpvar_11[2].x = tmpvar_10[0].z;
  tmpvar_11[2].y = tmpvar_10[1].z;
  tmpvar_11[2].z = tmpvar_10[2].z;
  vec4 v_i0_i1;
  v_i0_i1.x = _Object2World[0].x;
  v_i0_i1.y = _Object2World[1].x;
  v_i0_i1.z = _Object2World[2].x;
  v_i0_i1.w = _Object2World[3].x;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (tmpvar_11 * v_i0_i1.xyz);
  tmpvar_12.w = tmpvar_9.x;
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * unity_Scale.w);
  tmpvar_3 = tmpvar_13;
  vec4 v_i0_i1_i2;
  v_i0_i1_i2.x = _Object2World[0].y;
  v_i0_i1_i2.y = _Object2World[1].y;
  v_i0_i1_i2.z = _Object2World[2].y;
  v_i0_i1_i2.w = _Object2World[3].y;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_11 * v_i0_i1_i2.xyz);
  tmpvar_14.w = tmpvar_9.y;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = _Object2World[0].z;
  v_i0_i1_i2_i3.y = _Object2World[1].z;
  v_i0_i1_i2_i3.z = _Object2World[2].z;
  v_i0_i1_i2_i3.w = _Object2World[3].z;
  highp vec4 tmpvar_16;
  tmpvar_16.xyz = (tmpvar_11 * v_i0_i1_i2_i3.xyz);
  tmpvar_16.w = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * unity_Scale.w);
  tmpvar_5 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (tmpvar_11 * (((_World2Object * tmpvar_19).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying mediump vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ReflectColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _FresnelPower;
uniform samplerCube _Cube;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5.x = xlv_TEXCOORD2.w;
  tmpvar_5.y = xlv_TEXCOORD3.w;
  tmpvar_5.z = xlv_TEXCOORD4.w;
  tmpvar_1 = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD2.xyz;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD4.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  lowp float tmpvar_10;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  highp vec4 bump;
  mediump vec4 c_i0;
  mediump vec4 tex;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  tex = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (tex * _Color);
  c_i0 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_BumpMap, xlv_TEXCOORD0);
  bump = tmpvar_13;
  lowp vec4 packednormal;
  packednormal = bump;
  lowp vec3 normal;
  normal.xy = ((packednormal.wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  mediump vec3 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_2, normal);
  tmpvar_14.y = dot (tmpvar_3, normal);
  tmpvar_14.z = dot (tmpvar_4, normal);
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (tmpvar_1, tmpvar_14);
  worldReflVec = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = normalize (normal);
  highp float tmpvar_18;
  tmpvar_18 = max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD1), tmpvar_17), 0.0)), 0.0, 1.0), _FresnelPower))), 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_9 = tmpvar_19;
  tmpvar_10 = tmpvar_18;
  lightDir = xlv_TEXCOORD5;
  lowp float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD6).w;
  lowp vec4 c_i0_i1;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (normal, lightDir));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((tmpvar_9 * _LightColor0.xyz) * tmpvar_20) * (atten * 2.0));
  c_i0_i1.xyz = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = tmpvar_10;
  c_i0_i1.w = tmpvar_22;
  c = c_i0_i1;
  c.w = tmpvar_10;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 38 to 50, TEX: 3 to 5
//   d3d9 - ALU: 37 to 47, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 44 ALU, 4 TEX
PARAM c[6] = { program.local[0..3],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R2.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.x, R2.y, R2.y;
MAD R0.x, -R2, R2, -R0;
ADD R0.x, R0, c[4].y;
RSQ R0.x, R0.x;
RCP R2.z, R0.x;
DP3 R0.y, R2, R2;
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, R2;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
RSQ R0.y, R0.w;
MAX R0.w, R0.x, c[4].z;
MUL R3.xyz, R0.y, fragment.texcoord[5];
DP3 R1.x, R2, fragment.texcoord[2];
DP3 R1.y, R2, fragment.texcoord[3];
DP3 R1.z, R2, fragment.texcoord[4];
MOV R0.x, fragment.texcoord[2].w;
MOV R0.z, fragment.texcoord[4].w;
MOV R0.y, fragment.texcoord[3].w;
DP3 R2.w, R1, R0;
DP3 R1.w, R2, R3;
MUL R2.xyz, R1, R2.w;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, -R2, c[4].x, R0;
MUL R1.xyz, R1, c[1];
TEX R0.xyz, R0, texture[2], CUBE;
MAD R0.xyz, R0, c[2], R1;
MAX R1.x, R1.w, c[4].z;
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
ADD_SAT R0.w, -R0, c[4].y;
POW R1.x, R0.w, c[3].x;
DP3 R1.y, fragment.texcoord[6], fragment.texcoord[6];
TEX R0.w, R1.y, texture[3], 2D;
MUL R1.y, R0.w, c[4].x;
MUL R1.x, R1, c[4].w;
ADD R0.w, R1.x, c[5].x;
MUL result.color.xyz, R0, R1.y;
MAX result.color.w, R0, c[4].z;
END
# 44 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 42 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c4, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c5, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
texld r0.yw, v0, s1
mad_pp r2.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.y, r2, r2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, r2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4.w
add_sat r0.w, -r0.x, c4.z
dp3_pp r0.y, v5, v5
rsq_pp r0.y, r0.y
mul_pp r3.xyz, r0.y, v5
dp3_pp r1.x, r2, v2
dp3_pp r1.y, r2, v3
dp3_pp r1.z, r2, v4
dp3_pp r1.w, r2, r3
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r2.w, r1, r0
mul r2.xyz, r1, r2.w
mad r0.xyz, -r2, c4.x, r0
texld r1.xyz, v0, s0
mul r1.xyz, r1, c1
texld r0.xyz, r0, s2
mad r0.xyz, r0, c2, r1
mul_pp r0.xyz, r0, c0
max_pp r1.x, r1.w, c4.w
mul_pp r2.xyz, r0, r1.x
pow r1, r0.w, c3.x
dp3 r0.x, v6, v6
texld r0.x, r0.x, s3
mul_pp r0.z, r0.x, c4.x
mov r0.y, r1.x
mad r0.x, r0.y, c5, c5.y
mul oC0.xyz, r2, r0.z
max oC0.w, r0.x, c4
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 38 ALU, 3 TEX
PARAM c[6] = { program.local[0..3],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R2.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.x, R2.y, R2.y;
MAD R0.x, -R2, R2, -R0;
ADD R0.x, R0, c[4].y;
RSQ R0.x, R0.x;
RCP R2.z, R0.x;
DP3 R0.y, R2, R2;
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, R2;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
MAX R0.x, R0, c[4].z;
ADD_SAT R0.x, -R0, c[4].y;
POW R0.w, R0.x, c[3].x;
MUL R0.w, R0, c[4];
ADD R0.w, R0, c[5].x;
DP3 R1.x, R2, fragment.texcoord[2];
DP3 R1.y, R2, fragment.texcoord[3];
DP3 R1.z, R2, fragment.texcoord[4];
MOV R0.x, fragment.texcoord[2].w;
MOV R0.z, fragment.texcoord[4].w;
MOV R0.y, fragment.texcoord[3].w;
DP3 R1.w, R1, R0;
MUL R1.xyz, R1, R1.w;
MAD R0.xyz, -R1, c[4].x, R0;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R1.xyz, R1, c[1];
TEX R0.xyz, R0, texture[2], CUBE;
MAD R0.xyz, R0, c[2], R1;
DP3 R1.w, R2, fragment.texcoord[5];
MAX R1.x, R1.w, c[4].z;
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
MAX result.color.w, R0, c[4].z;
MUL result.color.xyz, R0, c[4].x;
END
# 38 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 37 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c4, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c5, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
texld r0.yw, v0, s1
mad_pp r1.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.x, r1.y, r1.y
mad_pp r0.x, -r1, r1, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3_pp r0.y, r1, r1
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r2
max r0.x, r0, c4.w
add_sat r1.w, -r0.x, c4.z
pow r0, r1.w, c3.x
dp3_pp r0.w, r1, v4
dp3_pp r0.y, r1, v2
dp3_pp r0.z, r1, v3
dp3_pp r1.x, r1, v5
mov r2.x, v2.w
mov r2.z, v4.w
mov r2.y, v3.w
dp3 r2.w, r0.yzww, r2
mov r1.w, r0.x
mul r0.xyz, r0.yzww, r2.w
mad r0.xyz, -r0, c4.x, r2
mad r0.w, r1, c5.x, c5.y
texld r2.xyz, v0, s0
texld r0.xyz, r0, s2
mul r2.xyz, r2, c1
mad r0.xyz, r0, c2, r2
max_pp r1.x, r1, c4.w
mul_pp r0.xyz, r0, c0
mul_pp r0.xyz, r0, r1.x
max oC0.w, r0, c4
mul oC0.xyz, r0, c4.x
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 5 TEX
PARAM c[6] = { program.local[0..3],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R2.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.x, R2.y, R2.y;
MAD R0.x, -R2, R2, -R0;
ADD R0.x, R0, c[4].y;
RSQ R0.x, R0.x;
RCP R2.z, R0.x;
DP3 R0.y, R2, R2;
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, R2;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
RSQ R0.y, R0.w;
MAX R0.w, R0.x, c[4].z;
MUL R3.xyz, R0.y, fragment.texcoord[5];
DP3 R1.x, R2, fragment.texcoord[2];
DP3 R1.y, R2, fragment.texcoord[3];
DP3 R1.z, R2, fragment.texcoord[4];
DP3 R1.w, R2, R3;
MOV R0.x, fragment.texcoord[2].w;
MOV R0.z, fragment.texcoord[4].w;
MOV R0.y, fragment.texcoord[3].w;
DP3 R2.w, R1, R0;
MUL R2.xyz, R1, R2.w;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, -R2, c[4].x, R0;
MUL R1.xyz, R1, c[1];
TEX R0.xyz, R0, texture[2], CUBE;
MAD R0.xyz, R0, c[2], R1;
MAX R1.x, R1.w, c[4].z;
RCP R1.y, fragment.texcoord[6].w;
MAD R1.zw, fragment.texcoord[6].xyxy, R1.y, c[5].y;
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
ADD_SAT R0.w, -R0, c[4].y;
POW R1.x, R0.w, c[3].x;
DP3 R1.y, fragment.texcoord[6], fragment.texcoord[6];
TEX R0.w, R1.zwzw, texture[3], 2D;
TEX R1.w, R1.y, texture[4], 2D;
SLT R1.y, c[4].z, fragment.texcoord[6].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MUL R0.w, R1.x, c[4];
MUL R1.x, R1.y, c[4];
ADD R0.w, R0, c[5].x;
MUL result.color.xyz, R0, R1.x;
MAX result.color.w, R0, c[4].z;
END
# 50 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_3_0
; 47 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
def c4, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c5, 0.79627001, 0.20373000, 0.50000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6
texld r0.yw, v0, s1
mad_pp r2.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.y, r2, r2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, r2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4.w
add_sat r0.w, -r0.x, c4.z
dp3_pp r0.y, v5, v5
rsq_pp r0.y, r0.y
mul_pp r3.xyz, r0.y, v5
dp3_pp r1.x, r2, v2
dp3_pp r1.y, r2, v3
dp3_pp r1.z, r2, v4
dp3_pp r1.w, r2, r3
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r2.w, r1, r0
mul r2.xyz, r1, r2.w
mad r0.xyz, -r2, c4.x, r0
pow r2, r0.w, c3.x
texld r1.xyz, v0, s0
mul r1.xyz, r1, c1
texld r0.xyz, r0, s2
mad r0.xyz, r0, c2, r1
mul_pp r0.xyz, r0, c0
max_pp r1.x, r1.w, c4.w
mul_pp r1.xyz, r0, r1.x
rcp r0.x, v6.w
mad r3.xy, v6, r0.x, c5.z
dp3 r0.x, v6, v6
texld r0.x, r0.x, s4
texld r0.w, r3, s3
cmp r0.y, -v6.z, c4.w, c4.z
mul_pp r0.y, r0, r0.w
mul_pp r0.y, r0, r0.x
mov r0.x, r2
mul_pp r0.y, r0, c4.x
mad r0.x, r0, c5, c5.y
mul oC0.xyz, r1, r0.y
max oC0.w, r0.x, c4
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 46 ALU, 5 TEX
PARAM c[6] = { program.local[0..3],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R2.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.x, R2.y, R2.y;
MAD R0.x, -R2, R2, -R0;
ADD R0.x, R0, c[4].y;
RSQ R0.x, R0.x;
RCP R2.z, R0.x;
DP3 R0.y, R2, R2;
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, R2;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
MAX R0.x, R0, c[4].z;
ADD_SAT R0.w, -R0.x, c[4].y;
DP3 R0.y, fragment.texcoord[5], fragment.texcoord[5];
RSQ R0.y, R0.y;
MUL R3.xyz, R0.y, fragment.texcoord[5];
DP3 R1.x, R2, fragment.texcoord[2];
DP3 R1.y, R2, fragment.texcoord[3];
DP3 R1.z, R2, fragment.texcoord[4];
DP3 R1.w, R2, R3;
MOV R0.x, fragment.texcoord[2].w;
MOV R0.z, fragment.texcoord[4].w;
MOV R0.y, fragment.texcoord[3].w;
DP3 R2.w, R1, R0;
MUL R2.xyz, R1, R2.w;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, -R2, c[4].x, R0;
MUL R1.xyz, R1, c[1];
TEX R0.xyz, R0, texture[2], CUBE;
MAD R0.xyz, R0, c[2], R1;
MAX R1.x, R1.w, c[4].z;
DP3 R1.y, fragment.texcoord[6], fragment.texcoord[6];
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
POW R1.x, R0.w, c[3].x;
TEX R0.w, fragment.texcoord[6], texture[4], CUBE;
TEX R1.w, R1.y, texture[3], 2D;
MUL R1.y, R1.w, R0.w;
MUL R0.w, R1.x, c[4];
MUL R1.x, R1.y, c[4];
ADD R0.w, R0, c[5].x;
MUL result.color.xyz, R0, R1.x;
MAX result.color.w, R0, c[4].z;
END
# 46 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_3_0
; 43 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_cube s4
def c4, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c5, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
texld r0.yw, v0, s1
mad_pp r2.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.y, r2, r2
dp3 r0.x, v1, v1
rsq r0.w, r0.x
rsq_pp r0.y, r0.y
mul_pp r0.xyz, r0.y, r2
mul r1.xyz, r0.w, v1
dp3 r0.x, r1, r0
max r0.x, r0, c4.w
add_sat r0.x, -r0, c4.z
pow r4, r0.x, c3.x
dp3_pp r0.y, v5, v5
rsq_pp r0.y, r0.y
mul_pp r3.xyz, r0.y, v5
dp3_pp r0.w, r2, r3
dp3_pp r1.x, r2, v2
dp3_pp r1.y, r2, v3
dp3_pp r1.z, r2, v4
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r1.w, r1, r0
mul r2.xyz, r1, r1.w
texld r1.xyz, v0, s0
mad r0.xyz, -r2, c4.x, r0
mul r1.xyz, r1, c1
texld r0.xyz, r0, s2
mad r0.xyz, r0, c2, r1
mul_pp r0.xyz, r0, c0
max_pp r0.w, r0, c4
mul_pp r1.xyz, r0, r0.w
dp3 r0.x, v6, v6
texld r0.x, r0.x, s3
texld r0.w, v6, s4
mul r0.y, r0.x, r0.w
mov r0.x, r4
mul_pp r0.y, r0, c4.x
mad r0.x, r0, c5, c5.y
mul oC0.xyz, r1, r0.y
max oC0.w, r0.x, c4
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 40 ALU, 4 TEX
PARAM c[6] = { program.local[0..3],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.yw, fragment.texcoord[0], texture[1], 2D;
MAD R2.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.x, R2.y, R2.y;
MAD R0.x, -R2, R2, -R0;
ADD R0.x, R0, c[4].y;
RSQ R0.x, R0.x;
RCP R2.z, R0.x;
DP3 R0.y, R2, R2;
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R1.xyz, R0.y, R2;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R0, R1;
MAX R0.x, R0, c[4].z;
ADD_SAT R0.x, -R0, c[4].y;
POW R0.x, R0.x, c[3].x;
MUL R0.w, R0.x, c[4];
ADD R0.w, R0, c[5].x;
MAX result.color.w, R0, c[4].z;
TEX R0.w, fragment.texcoord[6], texture[3], 2D;
DP3 R0.x, R2, fragment.texcoord[2];
DP3 R0.y, R2, fragment.texcoord[3];
DP3 R0.z, R2, fragment.texcoord[4];
MOV R1.x, fragment.texcoord[2].w;
MOV R1.z, fragment.texcoord[4].w;
MOV R1.y, fragment.texcoord[3].w;
DP3 R1.w, R0, R1;
MUL R3.xyz, R0, R1.w;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R1.xyz, -R3, c[4].x, R1;
TEX R1.xyz, R1, texture[2], CUBE;
MUL R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[2], R0;
DP3 R1.x, R2, fragment.texcoord[5];
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[4].z;
MUL R0.w, R0, c[4].x;
MUL R0.xyz, R0, R1.x;
MUL result.color.xyz, R0, R0.w;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_Cube] CUBE
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 38 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c4, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c5, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xy
texld r0.yw, v0, s1
mad_pp r2.xy, r0.wyzw, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.y, r2, r2
rsq_pp r0.y, r0.y
dp3 r0.x, v1, v1
mul_pp r1.xyz, r0.y, r2
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.x, r0, r1
max r0.x, r0, c4.w
add_sat r1.x, -r0, c4.z
pow r0, r1.x, c3.x
mov r0.w, r0.x
mad r0.w, r0, c5.x, c5.y
max oC0.w, r0, c4
texld r0.w, v6, s3
dp3_pp r0.x, r2, v2
dp3_pp r0.y, r2, v3
dp3_pp r0.z, r2, v4
mov r1.x, v2.w
mov r1.z, v4.w
mov r1.y, v3.w
dp3 r1.w, r0, r1
mul r3.xyz, r0, r1.w
texld r0.xyz, v0, s0
mad r1.xyz, -r3, c4.x, r1
texld r1.xyz, r1, s2
mul r0.xyz, r0, c1
mad r0.xyz, r1, c2, r0
dp3_pp r1.x, r2, v5
mul_pp r0.xyz, r0, c0
max_pp r1.x, r1, c4.w
mul_pp r0.w, r0, c4.x
mul_pp r0.xyz, r0, r1.x
mul oC0.xyz, r0, r0.w
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

#LINE 54


}
	
FallBack "Reflective/VertexLit"
} 

