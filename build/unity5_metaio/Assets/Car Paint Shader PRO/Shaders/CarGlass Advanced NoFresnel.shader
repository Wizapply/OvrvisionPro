Shader "RedDotGames/Car Glass Advanced NoFresnel" {
Properties {
	_Color ("Main Color (RGB)", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color (RGB)", Color) = (1,1,1,0.5)
	_Cube ("Reflection Cubemap (CUBE)", Cube) = "_Skybox" { TexGen CubeReflect }
	_TintColor ("Tint Color (RGB)", Color) = (1,1,1,1)
	
	  _threshold ("Reflection PowerUp Threshold ", Range(0,1)) = 0.5
	  _thresholdInt ("Reflection PowerUp Power", Range(0,20)) = 0	
	
}
SubShader {
	//Cull Off
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	
	Alphatest Greater 0 ZWrite Off ColorMask RGB
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 4
//   opengl - ALU: 17 to 68
//   d3d9 - ALU: 17 to 68
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
"!!ARBvp1.0
# 38 ALU
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
ADD result.texcoord[2].xyz, R2, R3;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R0.w;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 38 instructions, 4 R-regs
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
"vs_2_0
; 38 ALU
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
add oT2.xyz, r2, r3
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r0.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 393
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 409
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 376
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 382
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 399
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 403
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 407
    o.Alpha = _Color.w;
}
#line 317
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 321
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 431
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    #line 434
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 438
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 442
    surf( surfIN, o);
    c = vec4( 0.000000);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 446
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.vlight = vec3( xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:93(39): error: too few components to construct `mat3'
0:93(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:93(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 396
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 412
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 379
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 385
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 406
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 410
    o.Alpha = _Color.w;
}
#line 320
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 324
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 434
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    #line 437
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 441
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 445
    surf( surfIN, o);
    c = vec4( 0.000000);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 449
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.vlight = vec3( xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:93(39): error: too few components to construct `mat3'
0:93(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:93(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c21 1.0 2.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaadaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r1.xyzz, c5
bcaaaaaaacaaaiacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c6
bcaaaaaaaaaaaiacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.w, r1.xyzz, c4
aaaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.w
aaaaaaaaaaaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.w
aaaaaaaaaaaaaeacbfaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c21.x
adaaaaaaabaaapacaaaaaafdacaaaaaaaaaaaaneacaaaaaa mul r1, r0.wxyy, r0.xyyw
bdaaaaaaacaaaeacaaaaaajdacaaaaaabaaaaaoeabaaaaaa dp4 r2.z, r0.wxyz, c16
bdaaaaaaacaaacacaaaaaajdacaaaaaaapaaaaoeabaaaaaa dp4 r2.y, r0.wxyz, c15
bdaaaaaaacaaabacaaaaaajdacaaaaaaaoaaaaoeabaaaaaa dp4 r2.x, r0.wxyz, c14
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r0.z, r1, c19
bdaaaaaaaaaaabacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.x, r1, c17
bdaaaaaaaaaaacacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.y, r1, c18
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
aaaaaaaaabaaaiacbfaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c21.x
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaaeaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r4.xyz, r0.xyzz, c12.w
acaaaaaaabaaahacaeaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r4.xyzz, a0
adaaaaaaaaaaacacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.y, r3.w, r3.w
adaaaaaaaeaaaiacaaaaaappacaaaaaaaaaaaappacaaaaaa mul r4.w, r0.w, r0.w
acaaaaaaabaaaiacaeaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r4.w, r0.y
bfaaaaaaaeaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaaeaaaakeacaaaaaa dp3 r0.x, a1, r4.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
adaaaaaaaeaaahacaeaaaakeacaaaaaabfaaaaffabaaaaaa mul r4.xyz, r4.xyzz, c21.y
acaaaaaaaaaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r4.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabeaaaaoeabaaaaaa mul r3.xyz, r1.w, c20
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
aaaaaaaaabaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r2.w
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r0.w
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
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
"!!ARBvp1.0
# 17 ALU
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
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
MAD result.texcoord[1].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
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
"vs_2_0
; 17 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
mad oT1.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying highp vec2 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 393
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 409
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec2 lmap;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
uniform sampler2D unity_Lightmap;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec3 DecodeLightmap( in lowp vec4 color );
lowp vec4 frag_surf( in v2f_surf IN );
#line 376
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 382
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 399
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 403
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 407
    o.Alpha = _Color.w;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return (2.00000 * color.xyz);
}
#line 431
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec3 lm;
    surfIN.worldRefl = IN.worldRefl;
    #line 436
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 440
    o.Gloss = 0.000000;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 444
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 448
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.lmap = vec2( xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:91(39): error: too few components to construct `mat3'
0:91(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:91(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying highp vec2 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 396
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 412
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec2 lmap;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
uniform sampler2D unity_Lightmap;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec3 DecodeLightmap( in lowp vec4 color );
lowp vec4 frag_surf( in v2f_surf IN );
#line 379
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 385
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 406
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 410
    o.Alpha = _Color.w;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return ((8.00000 * color.w) * color.xyz);
}
#line 434
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec3 lm;
    surfIN.worldRefl = IN.worldRefl;
    #line 439
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 443
    o.Gloss = 0.000000;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 447
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 451
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.lmap = vec2( xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:91(39): error: too few components to construct `mat3'
0:91(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:91(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c15 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
aaaaaaaaabaaaiacapaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c15.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r0.xyzz, c12.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaapaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c15.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
adaaaaaaacaaadacaeaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a4, c14
abaaaaaaabaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v1.xy, r2.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
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
"!!ARBvp1.0
# 17 ALU
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
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
MAD result.texcoord[1].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
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
"vs_2_0
; 17 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
mad oT1.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying highp vec2 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 393
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 409
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec2 lmap;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec3 DecodeLightmap( in lowp vec4 color );
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector );
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal );
lowp vec4 frag_surf( in v2f_surf IN );
#line 376
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 382
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 399
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 403
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 407
    o.Alpha = _Color.w;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return (2.00000 * color.xyz);
}
#line 304
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm;
    mediump vec3 normalInRnmBasis;
    lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 308
    if (surfFuncWritesNormal){
        normalInRnmBasis = xll_saturate((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 313
    return lm;
}
#line 332
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    mediump vec3 lm;
    mediump vec3 scalePerBasisVector;
    #line 336
    lm = DirLightmapDiffuse( mat3( 0.816497, -0.408248, -0.408248, 0.000000, 0.707107, -0.707107, 0.577350, 0.577350, 0.577350), color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.000000);
}
#line 432
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec4 lmIndTex;
    mediump vec3 lm;
    surfIN.worldRefl = IN.worldRefl;
    #line 437
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 441
    o.Gloss = 0.000000;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 445
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    lmIndTex = texture2D( unity_LightmapInd, IN.lmap.xy);
    lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * lm);
    #line 449
    c.w = o.Alpha;
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.lmap = vec2( xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:94(39): error: too few components to construct `mat3'
0:94(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:94(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying highp vec2 xlv_TEXCOORD1;
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
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_2).xyz * unity_Scale.w)), normalize (_glesNormal)));
  tmpvar_1 = tmpvar_4;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 396
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 412
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec2 lmap;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec3 DecodeLightmap( in lowp vec4 color );
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector );
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal );
lowp vec4 frag_surf( in v2f_surf IN );
#line 379
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 385
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 406
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 410
    o.Alpha = _Color.w;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return ((8.00000 * color.w) * color.xyz);
}
#line 307
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm;
    mediump vec3 normalInRnmBasis;
    lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 311
    if (surfFuncWritesNormal){
        normalInRnmBasis = xll_saturate((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 316
    return lm;
}
#line 335
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    mediump vec3 lm;
    mediump vec3 scalePerBasisVector;
    #line 339
    lm = DirLightmapDiffuse( mat3( 0.816497, -0.408248, -0.408248, 0.000000, 0.707107, -0.707107, 0.577350, 0.577350, 0.577350), color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.000000);
}
#line 435
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec4 lmIndTex;
    mediump vec3 lm;
    surfIN.worldRefl = IN.worldRefl;
    #line 440
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 444
    o.Gloss = 0.000000;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 448
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    lmIndTex = texture2D( unity_LightmapInd, IN.lmap.xy);
    lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * lm);
    #line 452
    c.w = o.Alpha;
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.lmap = vec2( xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:94(39): error: too few components to construct `mat3'
0:94(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:94(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c15 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
aaaaaaaaabaaaiacapaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c15.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r0.xyzz, c12.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaapaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c15.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
adaaaaaaacaaadacaeaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a4, c14
abaaaaaaabaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v1.xy, r2.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
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
"!!ARBvp1.0
# 68 ALU
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
DP3 R5.x, R3, c[7];
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[16];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[15];
MUL R1, R1, R1;
MOV R4.z, R5.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[17];
MAD R1, R0, R0, R1;
MAD R0, R5.x, R0, R2;
MUL R2, R1, c[18];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[25];
DP4 R2.y, R4, c[24];
DP4 R2.x, R4, c[23];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].z;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MUL R1, R4.xyzz, R4.yzzx;
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
MUL R0.w, R3, R3;
MAD R1.w, R4.x, R4.x, -R0;
MAD R1.xyz, R2, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R1;
MUL R4.yzw, R1.w, c[29].xxyz;
MUL R2.xyz, vertex.normal, R0.w;
MAD R1.xyz, -R2, c[0].y, -R1;
ADD R3.xyz, R3, R4.yzww;
ADD result.texcoord[2].xyz, R3, R0;
DP3 result.texcoord[0].z, R1, c[7];
DP3 result.texcoord[0].y, R1, c[6];
DP3 result.texcoord[0].x, R1, c[5];
MOV result.texcoord[1].z, R5.x;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R4;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 68 instructions, 6 R-regs
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
"vs_2_0
; 68 ALU
def c29, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
mul r3.xyz, v1, c12.w
dp3 r5.x, r3, c6
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp4 r0.x, v0, c5
add r1, -r0.x, c15
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mul r1, r1, r1
mov r4.z, r5.x
mov r4.w, c29.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c16
mad r1, r0, r0, r1
mad r0, r5.x, r0, r2
mul r2, r1, c17
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c29.x
dp4 r2.z, r4, c24
dp4 r2.y, r4, c23
dp4 r2.x, r4, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c29.z
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mul r1, r4.xyzz, r4.yzzx
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
mul r0.w, r3, r3
mad r1.w, r4.x, r4.x, -r0
mad r1.xyz, r2, c12.w, -v0
dp3 r0.w, v1, -r1
mul r4.yzw, r1.w, c28.xxyz
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c29.y, -r1
add r3.xyz, r3, r4.yzww
add oT2.xyz, r3, r0
dp3 oT0.z, r1, c6
dp3 oT0.y, r1, c5
dp3 oT0.x, r1, c4
mov oT1.z, r5.x
mov oT1.y, r3.w
mov oT1.x, r4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define VERTEXLIGHT_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 393
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 409
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 376
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 382
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 399
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 403
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 407
    o.Alpha = _Color.w;
}
#line 317
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 321
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 433
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 438
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 442
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 446
    c = vec4( 0.000000);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 450
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.vlight = vec3( xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:94(39): error: too few components to construct `mat3'
0:94(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:94(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define VERTEXLIGHT_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 396
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 412
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 379
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 385
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 406
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 410
    o.Alpha = _Color.w;
}
#line 320
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 324
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 436
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 441
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 445
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 449
    c = vec4( 0.000000);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 453
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.vlight = vec3( xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:94(39): error: too few components to construct `mat3'
0:94(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:94(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c29 1.0 2.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r3.xyz, a1, c12.w
bcaaaaaaafaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c6
bcaaaaaaaeaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c4
bcaaaaaaadaaaiacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c5
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.x, a0, c5
bfaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r0.x
abaaaaaaabaaapacabaaaaaaacaaaaaaapaaaaoeabaaaaaa add r1, r1.x, c15
adaaaaaaacaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r2, r3.w, r1
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaapacaaaaaaaaacaaaaaaaoaaaaoeabaaaaaa add r0, r0.x, c14
adaaaaaaabaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r1, r1, r1
aaaaaaaaaeaaaeacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.z, r5.x
aaaaaaaaaeaaaiacbnaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r4.w, c29.x
adaaaaaaagaaapacaeaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r6, r4.x, r0
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bdaaaaaaaeaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.y, a0, c6
adaaaaaaagaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r6, r0, r0
abaaaaaaabaaapacagaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r6, r1
bfaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r4.y
abaaaaaaaaaaapacaaaaaaffacaaaaaabaaaaaoeabaaaaaa add r0, r0.y, c16
adaaaaaaagaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r6, r0, r0
abaaaaaaabaaapacagaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r6, r1
adaaaaaaaaaaapacafaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r0, r5.x, r0
abaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa add r0, r0, r2
adaaaaaaacaaapacabaaaaoeacaaaaaabbaaaaoeabaaaaaa mul r2, r1, c17
aaaaaaaaaeaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r3.w
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r1.y, r1.y
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
akaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.z, r1.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
abaaaaaaabaaapacacaaaaoeacaaaaaabnaaaaaaabaaaaaa add r1, r2, c29.x
bdaaaaaaacaaaeacaeaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r2.z, r4, c24
bdaaaaaaacaaacacaeaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r2.y, r4, c23
bdaaaaaaacaaabacaeaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r2.x, r4, c22
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabnaaaakkabaaaaaa max r0, r0, c29.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabdaaaaoeabaaaaaa mul r1.xyz, r0.y, c19
adaaaaaaagaaahacaaaaaaaaacaaaaaabcaaaaoeabaaaaaa mul r6.xyz, r0.x, c18
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabeaaaaoeabaaaaaa mul r0.xyz, r0.z, c20
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaapacaeaaaakeacaaaaaaaeaaaacjacaaaaaa mul r1, r4.xyzz, r4.yzzx
adaaaaaaagaaahacaaaaaappacaaaaaabfaaaaoeabaaaaaa mul r6.xyz, r0.w, c21
abaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r6.xyzz, r0.xyzz
bdaaaaaaadaaaeacabaaaaoeacaaaaaablaaaaoeabaaaaaa dp4 r3.z, r1, c27
bdaaaaaaadaaabacabaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r3.x, r1, c25
bdaaaaaaadaaacacabaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r3.y, r1, c26
abaaaaaaadaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r3.xyz, r2.xyzz, r3.xyzz
aaaaaaaaabaaaiacbnaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c29.x
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaacaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.z, r1, c10
bdaaaaaaacaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.y, r1, c9
bdaaaaaaacaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r2.x, r1, c8
adaaaaaaaaaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.w, r3.w, r3.w
adaaaaaaagaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r6.w, r4.x, r4.x
acaaaaaaabaaaiacagaaaappacaaaaaaaaaaaappacaaaaaa sub r1.w, r6.w, r0.w
adaaaaaaagaaahacacaaaakeacaaaaaaamaaaappabaaaaaa mul r6.xyz, r2.xyzz, c12.w
acaaaaaaabaaahacagaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r6.xyzz, a0
bfaaaaaaagaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r1.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaagaaaakeacaaaaaa dp3 r0.w, a1, r6.xyzz
adaaaaaaaeaaaoacabaaaappacaaaaaabmaaaajaabaaaaaa mul r4.yzw, r1.w, c28.xxyz
adaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r2.xyz, a1, r0.w
bfaaaaaaagaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r2.xyzz
adaaaaaaagaaahacagaaaakeacaaaaaabnaaaaffabaaaaaa mul r6.xyz, r6.xyzz, c29.y
acaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r6.xyzz, r1.xyzz
abaaaaaaadaaahacadaaaakeacaaaaaaaeaaaapjacaaaaaa add r3.xyz, r3.xyzz, r4.yzww
abaaaaaaacaaahaeadaaaakeacaaaaaaaaaaaakeacaaaaaa add v2.xyz, r3.xyzz, r0.xyzz
bcaaaaaaaaaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r1.xyzz, c6
bcaaaaaaaaaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r1.xyzz, c5
bcaaaaaaaaaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r1.xyzz, c4
aaaaaaaaabaaaeaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r5.x
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r4.x
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

}
Program "fp" {
// Fragment combos: 3
//   opengl - ALU: 21 to 23, TEX: 1 to 2
//   d3d9 - ALU: 20 to 23, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 1 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.11450195, 0.29882813, 0.58642578, 1 },
		{ 0.25, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MUL R0.w, R0.y, c[7].z;
MAD R0.w, R0.x, c[7].y, R0;
MAD_SAT R0.w, R0.z, c[7].x, R0;
ADD R1.xyz, R0.w, -R0;
MAD R1.xyz, R1, c[5].x, R0;
MOV R0.w, c[7];
MUL R0.xyz, R0, c[4];
ADD R0.w, R0, -c[5].x;
MUL R0.xyz, R0, c[3];
RCP R0.w, R0.w;
ADD R1.xyz, R1, -c[5].x;
MUL_SAT R1.xyz, R1, R0.w;
ADD R0.xyz, R0, c[2];
MAD R1.xyz, R1, c[6].x, R0;
DP3 R0.w, fragment.texcoord[1], c[0];
MUL R2.xyz, R1, fragment.texcoord[2];
MUL R0.xyz, R1, c[1];
MAX R0.w, R0, c[8].y;
MUL R0.xyz, R0.w, R0;
MAD R0.xyz, R0, c[8].z, R2;
MAD result.color.xyz, R1, c[8].x, R0;
MOV result.color.w, c[2];
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"ps_2_0
; 23 ALU, 1 TEX
dcl_cube s0
def c7, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c8, 0.00000000, 2.00000000, 0.25000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
texld r2, t0, s0
mul_pp r0.x, r2.y, c7
mad_pp r0.x, r2, c7.y, r0
mad_pp_sat r0.x, r2.z, c7.z, r0
add_pp r0.xyz, r0.x, -r2
mad_pp r0.xyz, r0, c5.x, r2
add r1.xyz, r0, -c5.x
mov_pp r0.x, c5
mul r2.xyz, r2, c4
add_pp r0.x, c7.w, -r0
mul r2.xyz, r2, c3
rcp_pp r0.x, r0.x
mul_sat r0.xyz, r1, r0.x
add r2.xyz, r2, c2
mad_pp r1.xyz, r0, c6.x, r2
dp3_pp r0.x, t1, c0
mul_pp r3.xyz, r1, t2
mul_pp r2.xyz, r1, c1
max_pp r0.x, r0, c8
mul_pp r0.xyz, r0.x, r2
mad_pp r0.xyz, r0, c8.y, r3
mad_pp r0.xyz, r1, c8.z, r0
mov_pp r0.w, c2
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"agal_ps
c7 0.586426 0.298828 0.114502 1.0
c8 0.0 2.0 0.25 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
adaaaaaaaaaaabacacaaaaffacaaaaaaahaaaaoeabaaaaaa mul r0.x, r2.y, c7
adaaaaaaabaaabacacaaaaaaacaaaaaaahaaaaffabaaaaaa mul r1.x, r2.x, c7.y
abaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.x, r0.x
adaaaaaaabaaaiacacaaaakkacaaaaaaahaaaakkabaaaaaa mul r1.w, r2.z, c7.z
abaaaaaaaaaaabacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa sub r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaafaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c5.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
acaaaaaaabaaahacaaaaaakeacaaaaaaafaaaaaaabaaaaaa sub r1.xyz, r0.xyzz, c5.x
aaaaaaaaaaaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c5
adaaaaaaacaaahacacaaaakeacaaaaaaaeaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c4
acaaaaaaaaaaabacahaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c7.w, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c3
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa add r2.xyz, r2.xyzz, c2
adaaaaaaabaaahacaaaaaakeacaaaaaaagaaaaaaabaaaaaa mul r1.xyz, r0.xyzz, c6.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v1, c0
adaaaaaaadaaahacabaaaakeacaaaaaaacaaaaoeaeaaaaaa mul r3.xyz, r1.xyzz, v2
adaaaaaaacaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c1
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaiaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c8.y
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaaiaaaakkabaaaaaa mul r1.xyz, r1.xyzz, c8.z
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_threshold]
Float 4 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 2 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.11450195, 0.29882813, 0.58642578, 1 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0, fragment.texcoord[1], texture[1], 2D;
MUL R1.w, R1.y, c[5].z;
MAD R1.w, R1.x, c[5].y, R1;
MAD_SAT R1.w, R1.z, c[5].x, R1;
ADD R2.xyz, R1.w, -R1;
MAD R2.xyz, R2, c[3].x, R1;
MOV R1.w, c[5];
MUL R1.xyz, R1, c[2];
ADD R1.w, R1, -c[3].x;
MUL R1.xyz, R1, c[1];
ADD R2.xyz, R2, -c[3].x;
RCP R1.w, R1.w;
MUL_SAT R2.xyz, R2, R1.w;
ADD R1.xyz, R1, c[0];
MAD R1.xyz, R2, c[4].x, R1;
MUL R0.xyz, R0.w, R0;
MUL R2.xyz, R1, c[6].y;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[6].x, R2;
MOV result.color.w, c[0];
END
# 21 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_threshold]
Float 4 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 20 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c5, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c6, 0.25000000, 8.00000000, 0, 0
dcl t0.xyz
dcl t1.xy
texld r3, t0, s0
texld r1, t1, s1
mul_pp r0.x, r3.y, c5
mad_pp r0.x, r3, c5.y, r0
mad_pp_sat r0.x, r3.z, c5.z, r0
add_pp r0.xyz, r0.x, -r3
mad_pp r2.xyz, r0, c3.x, r3
mov_pp r0.x, c3
add_pp r0.x, c5.w, -r0
mul r3.xyz, r3, c2
add r2.xyz, r2, -c3.x
rcp_pp r0.x, r0.x
mul_sat r0.xyz, r2, r0.x
mul r3.xyz, r3, c1
add r2.xyz, r3, c0
mad_pp r0.xyz, r0, c4.x, r2
mul_pp r2.xyz, r0, c6.x
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r1, r0
mad_pp r0.xyz, r0, c6.y, r2
mov_pp r0.w, c0
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_threshold]
Float 4 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c5 0.586426 0.298828 0.114502 1.0
c6 0.25 8.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
ciaaaaaaabaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v1, s1 <2d wrap linear point>
adaaaaaaaaaaabacadaaaaffacaaaaaaafaaaaoeabaaaaaa mul r0.x, r3.y, c5
adaaaaaaacaaabacadaaaaaaacaaaaaaafaaaaffabaaaaaa mul r2.x, r3.x, c5.y
abaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.x, r0.x
adaaaaaaacaaaiacadaaaakkacaaaaaaafaaaakkabaaaaaa mul r2.w, r3.z, c5.z
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaaaaaahacaaaaaaaaacaaaaaaadaaaakeacaaaaaa sub r0.xyz, r0.x, r3.xyzz
adaaaaaaacaaahacaaaaaakeacaaaaaaadaaaaaaabaaaaaa mul r2.xyz, r0.xyzz, c3.x
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaaaaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c3
acaaaaaaaaaaabacafaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c5.w, r0.x
adaaaaaaadaaahacadaaaakeacaaaaaaacaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c2
acaaaaaaacaaahacacaaaakeacaaaaaaadaaaaaaabaaaaaa sub r2.xyz, r2.xyzz, c3.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r2.xyzz, r0.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c1
abaaaaaaacaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa add r2.xyz, r3.xyzz, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c4.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
adaaaaaaacaaahacaaaaaakeacaaaaaaagaaaaaaabaaaaaa mul r2.xyz, r0.xyzz, c6.x
adaaaaaaabaaahacabaaaappacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r1.w, r1.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c6.y
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
aaaaaaaaaaaaaiacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c0
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_threshold]
Float 4 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 2 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.11450195, 0.29882813, 0.58642578, 1 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0, fragment.texcoord[1], texture[1], 2D;
MUL R1.w, R1.y, c[5].z;
MAD R1.w, R1.x, c[5].y, R1;
MAD_SAT R1.w, R1.z, c[5].x, R1;
ADD R2.xyz, R1.w, -R1;
MAD R2.xyz, R2, c[3].x, R1;
MOV R1.w, c[5];
MUL R1.xyz, R1, c[2];
ADD R1.w, R1, -c[3].x;
MUL R1.xyz, R1, c[1];
ADD R2.xyz, R2, -c[3].x;
RCP R1.w, R1.w;
MUL_SAT R2.xyz, R2, R1.w;
ADD R1.xyz, R1, c[0];
MAD R1.xyz, R2, c[4].x, R1;
MUL R0.xyz, R0.w, R0;
MUL R2.xyz, R1, c[6].y;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[6].x, R2;
MOV result.color.w, c[0];
END
# 21 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_threshold]
Float 4 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 20 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c5, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c6, 0.25000000, 8.00000000, 0, 0
dcl t0.xyz
dcl t1.xy
texld r3, t0, s0
texld r1, t1, s1
mul_pp r0.x, r3.y, c5
mad_pp r0.x, r3, c5.y, r0
mad_pp_sat r0.x, r3.z, c5.z, r0
add_pp r0.xyz, r0.x, -r3
mad_pp r2.xyz, r0, c3.x, r3
mov_pp r0.x, c3
add_pp r0.x, c5.w, -r0
mul r3.xyz, r3, c2
add r2.xyz, r2, -c3.x
rcp_pp r0.x, r0.x
mul_sat r0.xyz, r2, r0.x
mul r3.xyz, r3, c1
add r2.xyz, r3, c0
mad_pp r0.xyz, r0, c4.x, r2
mul_pp r2.xyz, r0, c6.x
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r1, r0
mad_pp r0.xyz, r0, c6.y, r2
mov_pp r0.w, c0
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_threshold]
Float 4 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c5 0.586426 0.298828 0.114502 1.0
c6 0.25 8.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
ciaaaaaaabaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v1, s1 <2d wrap linear point>
adaaaaaaaaaaabacadaaaaffacaaaaaaafaaaaoeabaaaaaa mul r0.x, r3.y, c5
adaaaaaaacaaabacadaaaaaaacaaaaaaafaaaaffabaaaaaa mul r2.x, r3.x, c5.y
abaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.x, r0.x
adaaaaaaacaaaiacadaaaakkacaaaaaaafaaaakkabaaaaaa mul r2.w, r3.z, c5.z
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaaaaaahacaaaaaaaaacaaaaaaadaaaakeacaaaaaa sub r0.xyz, r0.x, r3.xyzz
adaaaaaaacaaahacaaaaaakeacaaaaaaadaaaaaaabaaaaaa mul r2.xyz, r0.xyzz, c3.x
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaaaaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c3
acaaaaaaaaaaabacafaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c5.w, r0.x
adaaaaaaadaaahacadaaaakeacaaaaaaacaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c2
acaaaaaaacaaahacacaaaakeacaaaaaaadaaaaaaabaaaaaa sub r2.xyz, r2.xyzz, c3.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r2.xyzz, r0.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c1
abaaaaaaacaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa add r2.xyz, r3.xyzz, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c4.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
adaaaaaaacaaahacaaaaaakeacaaaaaaagaaaaaaabaaaaaa mul r2.xyz, r0.xyzz, c6.x
adaaaaaaabaaahacabaaaappacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r1.w, r1.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c6.y
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
aaaaaaaaaaaaaiacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c0
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
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
//   opengl - ALU: 21 to 29
//   d3d9 - ALU: 21 to 29
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
"!!ARBvp1.0
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
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 28 instructions, 2 R-regs
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
"vs_2_0
; 28 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#define POINT 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 411
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 378
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 384
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 401
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 405
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 409
    o.Alpha = _Color.w;
}
#line 317
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 321
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 434
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 437
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 441
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 445
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.00000));
    c.w = o.Alpha;
    #line 449
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:92(39): error: too few components to construct `mat3'
0:92(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:92(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#define POINT 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 414
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 381
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 387
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 404
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 412
    o.Alpha = _Color.w;
}
#line 320
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 324
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 437
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 440
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 444
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 448
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.00000));
    c.w = o.Alpha;
    #line 452
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:92(39): error: too few components to construct `mat3'
0:92(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:92(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c19 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c19.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabdaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c19.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v3.z, r0, c14
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v3.y, r0, c13
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v3.x, r0, c12
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
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
"!!ARBvp1.0
# 21 ALU
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
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[15];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 2 R-regs
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
"vs_2_0
; 21 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
mov oT2.xyz, c14
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 393
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 409
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 376
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 382
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 399
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 403
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 407
    o.Alpha = _Color.w;
}
#line 317
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 321
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 430
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 435
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 439
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lightDir = IN.lightDir;
    #line 443
    c = LightingLambert( o, lightDir, 1.00000);
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:90(39): error: too few components to construct `mat3'
0:90(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:90(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 396
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 412
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 379
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 385
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 406
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 410
    o.Alpha = _Color.w;
}
#line 320
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 324
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 433
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 438
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    #line 442
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lightDir = IN.lightDir;
    #line 446
    c = LightingLambert( o, lightDir, 1.00000);
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:90(39): error: too few components to construct `mat3'
0:90(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:90(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c15 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
aaaaaaaaabaaaiacapaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c15.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r0.xyzz, c12.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaapaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c15.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
aaaaaaaaacaaahaeaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c14
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
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
"!!ARBvp1.0
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
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[3].w, R0, c[16];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 29 instructions, 2 R-regs
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
"vs_2_0
; 29 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT3.w, r0, c15
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#define SPOT 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 404
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp float UnitySpotCookie( in highp vec4 LightCoord );
lowp float UnitySpotAttenuate( in highp vec3 LightCoord );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 387
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 393
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 410
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 414
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 418
    o.Alpha = _Color.w;
}
#line 373
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture2D( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.500000)).w;
}
#line 377
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture2D( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 317
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 321
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 443
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 446
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 450
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 454
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (((float((IN._LightCoord.z > 0.000000)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.00000));
    c.w = o.Alpha;
    #line 458
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec4( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:95(39): error: too few components to construct `mat3'
0:95(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:95(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#define SPOT 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 423
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp float UnitySpotCookie( in highp vec4 LightCoord );
lowp float UnitySpotAttenuate( in highp vec3 LightCoord );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 390
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 396
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 417
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 421
    o.Alpha = _Color.w;
}
#line 376
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture2D( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.500000)).w;
}
#line 380
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture2D( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 320
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 324
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 446
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 449
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 453
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 457
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (((float((IN._LightCoord.z > 0.000000)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.00000));
    c.w = o.Alpha;
    #line 461
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec4( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:95(39): error: too few components to construct `mat3'
0:95(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:95(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c19 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c19.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabdaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c19.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaadaaaiaeaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 v3.w, r0, c15
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v3.z, r0, c14
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v3.y, r0, c13
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v3.x, r0, c12
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
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
"!!ARBvp1.0
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
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 28 instructions, 2 R-regs
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
"vs_2_0
; 28 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#define POINT_COOKIE 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 396
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 412
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform samplerCube _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 379
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 385
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 402
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 406
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 410
    o.Alpha = _Color.w;
}
#line 317
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 321
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 435
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 438
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 442
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 446
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, ((texture2D( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * textureCube( _LightTexture0, IN._LightCoord).w) * 1.00000));
    c.w = o.Alpha;
    #line 450
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:93(39): error: too few components to construct `mat3'
0:93(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:93(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

#define POINT_COOKIE 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 415
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform samplerCube _LightTexture0;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 382
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 388
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 409
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 413
    o.Alpha = _Color.w;
}
#line 320
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 324
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 438
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 441
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 445
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 449
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, ((texture2D( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * textureCube( _LightTexture0, IN._LightCoord).w) * 1.00000));
    c.w = o.Alpha;
    #line 453
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:93(39): error: too few components to construct `mat3'
0:93(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:93(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c19 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c19.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabdaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c19.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v3.z, r0, c14
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v3.y, r0, c13
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v3.x, r0, c12
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
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
"!!ARBvp1.0
# 27 ALU
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
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 27 instructions, 2 R-regs
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
"vs_2_0
; 27 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
mov oT2.xyz, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
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

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL_COOKIE 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 294
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 395
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 411
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 378
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 384
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 401
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 405
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 409
    o.Alpha = _Color.w;
}
#line 317
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 321
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 434
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 437
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 441
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 445
    surf( surfIN, o);
    lightDir = IN.lightDir;
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, IN._LightCoord).w * 1.00000));
    c.w = o.Alpha;
    #line 449
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec2( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:92(39): error: too few components to construct `mat3'
0:92(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:92(14): error: cannot construct `float' from a non-numeric data type
*/


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

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
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
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

#define DIRECTIONAL_COOKIE 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
float xll_saturate( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 136
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 172
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 166
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 297
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 414
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 37
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform lowp vec4 _LightColor0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten );
lowp vec4 frag_surf( in v2f_surf IN );
#line 381
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 387
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 404
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    #line 412
    o.Alpha = _Color.w;
}
#line 320
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff;
    lowp vec4 c;
    diff = max( 0.000000, dot( s.Normal, lightDir));
    #line 324
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.00000));
    c.w = s.Alpha;
    return c;
}
#line 437
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 440
    surfIN.worldRefl = IN.worldRefl;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 444
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 448
    surf( surfIN, o);
    lightDir = IN.lightDir;
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, IN._LightCoord).w * 1.00000));
    c.w = o.Alpha;
    #line 452
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying lowp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.normal = vec3( xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD2);
    xlt_IN._LightCoord = vec2( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:92(39): error: too few components to construct `mat3'
0:92(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:92(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "flash " {
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
"agal_vs
c19 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c19.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabdaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c19.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v3.y, r0, c13
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v3.x, r0, c12
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
aaaaaaaaacaaahaebcaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 22 to 33, TEX: 1 to 3
//   d3d9 - ALU: 22 to 32, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 2 TEX
PARAM c[8] = { program.local[0..5],
		{ 0.29882813, 0.58642578, 0.11450195, 1 },
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MOV R1.w, c[6];
ADD R1.w, R1, -c[4].x;
RCP R1.w, R1.w;
MOV result.color.w, c[1];
TEX R0.w, R0.x, texture[1], 2D;
MUL R0.x, R1.y, c[6].y;
MAD R0.x, R1, c[6], R0;
MAD_SAT R0.x, R1.z, c[6].z, R0;
ADD R0.xyz, R0.x, -R1;
MAD R0.xyz, R0, c[4].x, R1;
ADD R0.xyz, R0, -c[4].x;
MUL_SAT R0.xyz, R0, R1.w;
MUL R1.xyz, R1, c[3];
DP3 R1.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R1, c[2];
ADD R1.xyz, R1, c[1];
MAD R0.xyz, R0, c[5].x, R1;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R2;
MAX R1.x, R1, c[7];
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 27 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c6, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c7, 0.00000000, 2.00000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r1, t0, s0
dp3 r0.x, t3, t3
mov r0.xy, r0.x
mov_pp r0.w, c1
texld r2, r0, s1
mul_pp r0.x, r1.y, c6
mad_pp r0.x, r1, c6.y, r0
mad_pp_sat r0.x, r1.z, c6.z, r0
add_pp r3.xyz, r0.x, -r1
mad_pp r3.xyz, r3, c4.x, r1
mov_pp r0.x, c4
add_pp r0.x, c6.w, -r0
mul r1.xyz, r1, c3
mul r1.xyz, r1, c2
rcp_pp r0.x, r0.x
add r3.xyz, r3, -c4.x
mul_sat r3.xyz, r3, r0.x
dp3_pp r0.x, t2, t2
add r1.xyz, r1, c1
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t1, r0
mad_pp r1.xyz, r3, c5.x, r1
mul_pp r1.xyz, r1, c0
max_pp r0.x, r0, c7
mul_pp r0.x, r0, r2
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.y
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c6 0.586426 0.298828 0.114502 1.0
c7 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r1, v0, s0 <cube wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
adaaaaaaaaaaabacabaaaaffacaaaaaaagaaaaoeabaaaaaa mul r0.x, r1.y, c6
adaaaaaaabaaaiacabaaaaaaacaaaaaaagaaaaffabaaaaaa mul r1.w, r1.x, c6.y
abaaaaaaaaaaabacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.w, r0.x
adaaaaaaacaaabacabaaaakkacaaaaaaagaaaakkabaaaaaa mul r2.x, r1.z, c6.z
abaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.x, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaacaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa sub r2.xyz, r0.x, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r2.xyz, r2.xyzz, c4.x
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
acaaaaaaaaaaabacagaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c6.w, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c3
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c2
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
acaaaaaaacaaahacacaaaakeacaaaaaaaeaaaaaaabaaaaaa sub r2.xyz, r2.xyzz, c4.x
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r2.xyz, r2.xyzz, r0.x
bgaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r2.xyz, r2.xyzz
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
abaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c1
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v1, r0.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaafaaaaaaabaaaaaa mul r2.xyz, r2.xyzz, c5.x
abaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r2.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaahaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c7.y
aaaaaaaaaaaaaiacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 1 TEX
PARAM c[8] = { program.local[0..5],
		{ 0.29882813, 0.58642578, 0.11450195, 1 },
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
MUL R0.x, R1.y, c[6].y;
MAD R0.x, R1, c[6], R0;
MAD_SAT R0.x, R1.z, c[6].z, R0;
ADD R0.xyz, R0.x, -R1;
MAD R0.xyz, R0, c[4].x, R1;
MOV R0.w, c[6];
ADD R0.w, R0, -c[4].x;
MUL R1.xyz, R1, c[3];
MUL R1.xyz, R1, c[2];
RCP R0.w, R0.w;
ADD R0.xyz, R0, -c[4].x;
MUL_SAT R0.xyz, R0, R0.w;
ADD R1.xyz, R1, c[1];
MOV R2.xyz, fragment.texcoord[2];
MAD R0.xyz, R0, c[5].x, R1;
DP3 R0.w, fragment.texcoord[1], R2;
MUL R0.xyz, R0, c[0];
MAX R0.w, R0, c[7].x;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
MOV result.color.w, c[1];
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"ps_2_0
; 22 ALU, 1 TEX
dcl_cube s0
def c6, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c7, 0.00000000, 2.00000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
texld r2, t0, s0
mul_pp r0.x, r2.y, c6
mad_pp r0.x, r2, c6.y, r0
mad_pp_sat r0.x, r2.z, c6.z, r0
add_pp r0.xyz, r0.x, -r2
mad_pp r1.xyz, r0, c4.x, r2
mov_pp r0.x, c4
add_pp r0.x, c6.w, -r0
mul r2.xyz, r2, c3
mul r2.xyz, r2, c2
add r1.xyz, r1, -c4.x
rcp_pp r0.x, r0.x
mul_sat r0.xyz, r1, r0.x
add r2.xyz, r2, c1
mad_pp r2.xyz, r0, c5.x, r2
mov_pp r1.xyz, t2
dp3_pp r0.x, t1, r1
mul_pp r1.xyz, r2, c0
max_pp r0.x, r0, c7
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.y
mov_pp r0.w, c1
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"agal_ps
c6 0.586426 0.298828 0.114502 1.0
c7 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
adaaaaaaaaaaabacacaaaaffacaaaaaaagaaaaoeabaaaaaa mul r0.x, r2.y, c6
adaaaaaaabaaabacacaaaaaaacaaaaaaagaaaaffabaaaaaa mul r1.x, r2.x, c6.y
abaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.x, r0.x
adaaaaaaabaaaiacacaaaakkacaaaaaaagaaaakkabaaaaaa mul r1.w, r2.z, c6.z
abaaaaaaaaaaabacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa sub r0.xyz, r0.x, r2.xyzz
adaaaaaaabaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r1.xyz, r0.xyzz, c4.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
acaaaaaaaaaaabacagaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c6.w, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c3
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
acaaaaaaabaaahacabaaaakeacaaaaaaaeaaaaaaabaaaaaa sub r1.xyz, r1.xyzz, c4.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa add r2.xyz, r2.xyzz, c1
adaaaaaaadaaahacaaaaaakeacaaaaaaafaaaaaaabaaaaaa mul r3.xyz, r0.xyzz, c5.x
abaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r3.xyzz, r2.xyzz
aaaaaaaaabaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r0.x, v1, r1.xyzz
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaahaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c7.y
aaaaaaaaaaaaaiacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 33 ALU, 3 TEX
PARAM c[8] = { program.local[0..5],
		{ 0.29882813, 0.58642578, 0.11450195, 1 },
		{ 0, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
RCP R0.x, fragment.texcoord[3].w;
MAD R1.xy, fragment.texcoord[3], R0.x, c[7].y;
DP3 R1.z, fragment.texcoord[3], fragment.texcoord[3];
MOV R2.x, c[6].w;
ADD R2.x, R2, -c[4];
RCP R2.x, R2.x;
MOV result.color.w, c[1];
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0.w, R1, texture[1], 2D;
TEX R1.w, R1.z, texture[2], 2D;
MUL R1.x, R0.y, c[6].y;
MAD R1.x, R0, c[6], R1;
MAD_SAT R1.x, R0.z, c[6].z, R1;
ADD R1.xyz, R1.x, -R0;
MAD R1.xyz, R1, c[4].x, R0;
ADD R1.xyz, R1, -c[4].x;
MUL_SAT R1.xyz, R1, R2.x;
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
ADD R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[5].x, R0;
RSQ R2.x, R2.x;
MUL R1.xyz, R2.x, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
SLT R1.y, c[7].x, fragment.texcoord[3].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[7].x;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].z;
END
# 33 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 32 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_2d s2
def c6, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c7, 0.50000000, 0.00000000, 1.00000000, 2.00000000
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r2, t0, s0
dp3 r1.x, t3, t3
mov r1.xy, r1.x
rcp r0.x, t3.w
mad r0.xy, t3, r0.x, c7.x
texld r0, r0, s1
texld r3, r1, s2
mul_pp r0.x, r2.y, c6
mad_pp r0.x, r2, c6.y, r0
mad_pp_sat r0.x, r2.z, c6.z, r0
add_pp r0.xyz, r0.x, -r2
mad_pp r0.xyz, r0, c4.x, r2
add r1.xyz, r0, -c4.x
mov_pp r0.x, c4
mul r2.xyz, r2, c3
add_pp r0.x, c6.w, -r0
mul r2.xyz, r2, c2
rcp_pp r0.x, r0.x
mul_sat r0.xyz, r1, r0.x
add r2.xyz, r2, c1
mad_pp r0.xyz, r0, c5.x, r2
mul_pp r2.xyz, r0, c0
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
cmp r0.x, -t3.z, c7.y, c7.z
mul_pp r0.x, r0, r0.w
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t1, r1
mul_pp r0.x, r0, r3
max_pp r1.x, r1, c7.y
mul_pp r0.x, r1, r0
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c7.w
mov_pp r0.w, c1
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"agal_ps
c6 0.586426 0.298828 0.114502 1.0
c7 0.5 0.0 1.0 2.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
afaaaaaaaaaaabacadaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, v3.w
aaaaaaaaabaaadacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.xy, r1.x
adaaaaaaaaaaadacadaaaaoeaeaaaaaaaaaaaaaaacaaaaaa mul r0.xy, v3, r0.x
abaaaaaaaaaaadacaaaaaafeacaaaaaaahaaaaaaabaaaaaa add r0.xy, r0.xyyy, c7.x
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaabaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r1, r1.xyyy, s2 <2d wrap linear point>
adaaaaaaaaaaabacacaaaaffacaaaaaaagaaaaoeabaaaaaa mul r0.x, r2.y, c6
adaaaaaaacaaaiacacaaaaaaacaaaaaaagaaaaffabaaaaaa mul r2.w, r2.x, c6.y
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
adaaaaaaadaaabacacaaaakkacaaaaaaagaaaakkabaaaaaa mul r3.x, r2.z, c6.z
abaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r3.x, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa sub r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c4.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
acaaaaaaabaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa sub r1.xyz, r0.xyzz, c4.x
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
adaaaaaaacaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c3
acaaaaaaaaaaabacagaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c6.w, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa add r2.xyz, r2.xyzz, c1
adaaaaaaaaaaahacaaaaaakeacaaaaaaafaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c5.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
adaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r0.xyzz, c0
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
bfaaaaaaadaaaeacadaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r3.z, v3.z
ckaaaaaaaaaaabacadaaaakkacaaaaaaahaaaaffabaaaaaa slt r0.x, r3.z, c7.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaappacaaaaaa mul r0.x, r0.x, r1.w
ahaaaaaaabaaabacabaaaaaaacaaaaaaahaaaaffabaaaaaa max r1.x, r1.x, c7.y
adaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r1.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaahaaaappabaaaaaa mul r0.xyz, r0.xyzz, c7.w
aaaaaaaaaaaaaiacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 3 TEX
PARAM c[8] = { program.local[0..5],
		{ 0.29882813, 0.58642578, 0.11450195, 1 },
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R1.w, fragment.texcoord[3], texture[2], CUBE;
MUL R1.x, R0.y, c[6].y;
MAD R1.x, R0, c[6], R1;
MAD_SAT R1.x, R0.z, c[6].z, R1;
ADD R1.xyz, R1.x, -R0;
MAD R1.xyz, R1, c[4].x, R0;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
MOV R2.x, c[6].w;
ADD R2.x, R2, -c[4];
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
RCP R2.x, R2.x;
ADD R1.xyz, R1, -c[4].x;
MUL_SAT R1.xyz, R1, R2.x;
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
ADD R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[5].x, R0;
RSQ R2.x, R2.x;
MUL R1.xyz, R2.x, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[0];
MOV result.color.w, c[1];
TEX R0.w, R0.w, texture[1], 2D;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[7].x;
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
END
# 29 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 28 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_cube s2
def c6, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c7, 0.00000000, 2.00000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
dp3 r0.x, t3, t3
mov r1.xy, r0.x
texld r0, t3, s2
texld r3, r1, s1
mul_pp r0.x, r2.y, c6
mad_pp r0.x, r2, c6.y, r0
mad_pp_sat r0.x, r2.z, c6.z, r0
add_pp r0.xyz, r0.x, -r2
mad_pp r0.xyz, r0, c4.x, r2
add r1.xyz, r0, -c4.x
mov_pp r0.x, c4
mul r2.xyz, r2, c3
add_pp r0.x, c6.w, -r0
mul r2.xyz, r2, c2
rcp_pp r0.x, r0.x
mul_sat r0.xyz, r1, r0.x
add r2.xyz, r2, c1
mad_pp r1.xyz, r0, c5.x, r2
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t1, r0
mul r2.x, r3, r0.w
max_pp r0.x, r0, c7
mul_pp r1.xyz, r1, c0
mul_pp r0.x, r0, r2
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.y
mov_pp r0.w, c1
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"agal_ps
c6 0.586426 0.298828 0.114502 1.0
c7 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
ciaaaaaaabaaapacadaaaaoeaeaaaaaaacaaaaaaafbababb tex r1, v3, s2 <cube wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
adaaaaaaaaaaabacacaaaaffacaaaaaaagaaaaoeabaaaaaa mul r0.x, r2.y, c6
adaaaaaaacaaaiacacaaaaaaacaaaaaaagaaaaffabaaaaaa mul r2.w, r2.x, c6.y
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
adaaaaaaadaaabacacaaaakkacaaaaaaagaaaakkabaaaaaa mul r3.x, r2.z, c6.z
abaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r3.x, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa sub r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c4.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
acaaaaaaabaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa sub r1.xyz, r0.xyzz, c4.x
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
adaaaaaaacaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c3
acaaaaaaaaaaabacagaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c6.w, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa add r2.xyz, r2.xyzz, c1
adaaaaaaabaaahacaaaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r0.xyzz, c5.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v1, r0.xyzz
adaaaaaaacaaabacaaaaaappacaaaaaaabaaaappacaaaaaa mul r2.x, r0.w, r1.w
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r0.x, r0.x, r2.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaahaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c7.y
aaaaaaaaaaaaaiacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 24 ALU, 2 TEX
PARAM c[8] = { program.local[0..5],
		{ 0.29882813, 0.58642578, 0.11450195, 1 },
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0.w, fragment.texcoord[3], texture[1], 2D;
MUL R0.x, R1.y, c[6].y;
MAD R0.x, R1, c[6], R0;
MAD_SAT R0.x, R1.z, c[6].z, R0;
ADD R0.xyz, R0.x, -R1;
MAD R0.xyz, R0, c[4].x, R1;
MOV R1.w, c[6];
ADD R1.w, R1, -c[4].x;
MUL R1.xyz, R1, c[3];
MUL R1.xyz, R1, c[2];
ADD R1.xyz, R1, c[1];
ADD R0.xyz, R0, -c[4].x;
RCP R1.w, R1.w;
MUL_SAT R0.xyz, R0, R1.w;
MAD R0.xyz, R0, c[5].x, R1;
MOV R2.xyz, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R2;
MAX R1.x, R1, c[7];
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[7].y;
MOV result.color.w, c[1];
END
# 24 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 23 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c6, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c7, 0.00000000, 2.00000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r2, t0, s0
texld r0, t3, s1
mul_pp r0.x, r2.y, c6
mad_pp r0.x, r2, c6.y, r0
mad_pp_sat r0.x, r2.z, c6.z, r0
add_pp r0.xyz, r0.x, -r2
mad_pp r0.xyz, r0, c4.x, r2
add r1.xyz, r0, -c4.x
mov_pp r0.x, c4
mul r2.xyz, r2, c3
add_pp r0.x, c6.w, -r0
mul r2.xyz, r2, c2
rcp_pp r0.x, r0.x
mul_sat r0.xyz, r1, r0.x
add r2.xyz, r2, c1
mad_pp r1.xyz, r0, c5.x, r2
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
max_pp r0.x, r0, c7
mul_pp r0.x, r0, r0.w
mul_pp r1.xyz, r1, c0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c7.y
mov_pp r0.w, c1
mov_pp oC0, r0
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

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_threshold]
Float 5 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c6 0.586426 0.298828 0.114502 1.0
c7 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
ciaaaaaaaaaaapacadaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v3, s1 <2d wrap linear point>
adaaaaaaaaaaabacacaaaaffacaaaaaaagaaaaoeabaaaaaa mul r0.x, r2.y, c6
adaaaaaaabaaabacacaaaaaaacaaaaaaagaaaaffabaaaaaa mul r1.x, r2.x, c6.y
abaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.x, r0.x
adaaaaaaabaaaiacacaaaakkacaaaaaaagaaaakkabaaaaaa mul r1.w, r2.z, c6.z
abaaaaaaaaaaabacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa sub r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c4.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
acaaaaaaabaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa sub r1.xyz, r0.xyzz, c4.x
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
adaaaaaaacaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c3
acaaaaaaaaaaabacagaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c6.w, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa add r2.xyz, r2.xyzz, c1
adaaaaaaabaaahacaaaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r0.xyzz, c5.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
aaaaaaaaaaaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v1, r0.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaahaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c7.y
aaaaaaaaaaaaaiacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}

#LINE 72


}
	
FallBack "Reflective/VertexLit"
} 

