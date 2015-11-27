Shader "RedDotGames/Car Glass Advanced" {
Properties {
	_Color ("Main Color (RGB)", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color (RGB)", Color) = (1,1,1,0.5)
	_Cube ("Reflection Cubemap (CUBE)", Cube) = "" { }
	_FresnelPower ("Fresnel Power", Range(0.05,5.0)) = 0.75
	_TintColor ("Tint Color (RGB)", Color) = (1,1,1,1)
	_AlphaPower ("Alpha", Range(0.0,2.0)) = 1.0
	
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
"!!ARBvp1.0
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
"vs_2_0
; 42 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT3.xyz, r2, r3
add oT1.xyz, -r0, c13
mov oT2.z, r2.w
mov oT2.y, r3.w
mov oT2.x, r0.w
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
#line 395
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 415
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 405
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 409
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 413
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 440
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 444
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 448
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 452
    surf( surfIN, o);
    c = vec4( 0.000000);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 456
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.vlight = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:96(39): error: too few components to construct `mat3'
0:96(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:96(14): error: cannot construct `float' from a non-numeric data type
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
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 412
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 416
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 443
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 447
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 451
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 455
    surf( surfIN, o);
    c = vec4( 0.000000);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 459
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.vlight = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:96(39): error: too few components to construct `mat3'
0:96(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:96(14): error: cannot construct `float' from a non-numeric data type
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
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaadaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v3.xyz, r2.xyzz, r3.xyzz
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaabaaahaeaeaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r4.xyzz, c13
aaaaaaaaacaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.z, r2.w
aaaaaaaaacaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.y, r3.w
aaaaaaaaacaaabaeaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v2.x, r0.w
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
"vs_2_0
; 25 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT1.xyz, -r0, c13
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mad oT3.xy, v2, c14, c14.zwzw
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
#line 395
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 415
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
    lowp vec3 normal;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
uniform sampler2D unity_Lightmap;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec3 DecodeLightmap( in lowp vec4 color );
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 405
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 409
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 413
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return (2.00000 * color.xyz);
}
#line 442
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec3 lm;
    #line 445
    surfIN.worldRefl = IN.worldRefl;
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    #line 449
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    #line 453
    o.Normal = IN.normal;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 457
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 461
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lmap = vec2( xlv_TEXCOORD3);
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
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
    lowp vec3 normal;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
uniform highp vec4 _ReflectColor;
uniform highp vec4 _TintColor;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;
uniform sampler2D unity_Lightmap;
lowp vec3 highpass( in lowp vec3 c );
void surf( in Input IN, inout SurfaceOutput o );
lowp vec3 DecodeLightmap( in lowp vec4 color );
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 412
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 416
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return ((8.00000 * color.w) * color.xyz);
}
#line 445
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec3 lm;
    #line 448
    surfIN.worldRefl = IN.worldRefl;
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    #line 452
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    #line 456
    o.Normal = IN.normal;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 460
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 464
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lmap = vec2( xlv_TEXCOORD3);
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
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaabaaahaeacaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r2.xyzz, c13
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
adaaaaaaacaaadacaeaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a4, c14
abaaaaaaadaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v3.xy, r2.xyyy, c14.zwzw
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
"vs_2_0
; 25 ALU
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT1.xyz, -r0, c13
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mad oT3.xy, v2, c14, c14.zwzw
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
#line 395
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 415
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
    lowp vec3 normal;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 405
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 409
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 413
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 443
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec4 lmIndTex;
    mediump vec3 lm;
    surfIN.worldRefl = IN.worldRefl;
    #line 447
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 451
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 455
    surf( surfIN, o);
    c = vec4( 0.000000);
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    #line 459
    lmIndTex = texture2D( unity_LightmapInd, IN.lmap.xy);
    lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 463
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lmap = vec2( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:98(39): error: too few components to construct `mat3'
0:98(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:98(14): error: cannot construct `float' from a non-numeric data type
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
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
    lowp vec3 normal;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 412
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 416
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 446
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    lowp vec4 lmtex;
    lowp vec4 lmIndTex;
    mediump vec3 lm;
    surfIN.worldRefl = IN.worldRefl;
    #line 450
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 454
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 458
    surf( surfIN, o);
    c = vec4( 0.000000);
    lmtex = texture2D( unity_Lightmap, IN.lmap.xy);
    #line 462
    lmIndTex = texture2D( unity_LightmapInd, IN.lmap.xy);
    lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 466
    c.xyz += o.Emission;
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lmap = vec2( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:98(39): error: too few components to construct `mat3'
0:98(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:98(14): error: cannot construct `float' from a non-numeric data type
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
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaabaaahaeacaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r2.xyzz, c13
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
adaaaaaaacaaadacaeaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a4, c14
abaaaaaaadaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v3.xy, r2.xyyy, c14.zwzw
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
"vs_2_0
; 71 ALU
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
add oT3.xyz, r3, r0
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c29.y, -r1
mov r3.x, r4.w
mov r3.y, r4
dp3 oT0.z, r1, c6
dp3 oT0.y, r1, c5
dp3 oT0.x, r1, c4
add oT1.xyz, -r3.wxyw, c13
mov oT2.z, r4.x
mov oT2.y, r4.z
mov oT2.x, r5
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
#line 395
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 415
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 405
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 409
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 413
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 442
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    #line 445
    surfIN.worldRefl = IN.worldRefl;
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    #line 449
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    #line 453
    o.Normal = IN.normal;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 457
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    c.w = o.Alpha;
    #line 461
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.vlight = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:97(39): error: too few components to construct `mat3'
0:97(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:97(14): error: cannot construct `float' from a non-numeric data type
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
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 412
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 416
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 445
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp float atten = 1.00000;
    lowp vec4 c;
    #line 448
    surfIN.worldRefl = IN.worldRefl;
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    #line 452
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    #line 456
    o.Normal = IN.normal;
    surf( surfIN, o);
    c = vec4( 0.000000);
    #line 460
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    c.w = o.Alpha;
    #line 464
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.vlight = vec3( xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:97(39): error: too few components to construct `mat3'
0:97(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:97(14): error: cannot construct `float' from a non-numeric data type
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
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaapaaaaoeabaaaaaa add r2, r2.z, c15
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaaoaaaaoeabaaaaaa add r1, r1.w, c14
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaiacbnaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c29.x
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaabaaaaaoeabaaaaaa add r1, r1.x, c16
bcaaaaaaaeaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c6
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacaeaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r4.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaabbaaaaoeabaaaaaa mul r1, r2, c17
abaaaaaaabaaapacabaaaaoeacaaaaaabnaaaaaaabaaaaaa add r1, r1, c29.x
aaaaaaaaafaaaeacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r4.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r2.z, r5, c24
bdaaaaaaacaaacacafaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r2.y, r5, c23
bdaaaaaaacaaabacafaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r2.x, r5, c22
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
adaaaaaaabaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r1, r5.xyzz, r5.yzzx
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
adaaaaaaaaaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r0.w, r4.z, r4.z
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaaaaaaappacaaaaaa sub r1.w, r6.w, r0.w
adaaaaaaagaaahacacaaaakeacaaaaaaamaaaappabaaaaaa mul r6.xyz, r2.xyzz, c12.w
acaaaaaaabaaahacagaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r6.xyzz, a0
bfaaaaaaagaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r1.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaagaaaakeacaaaaaa dp3 r0.w, a1, r6.xyzz
adaaaaaaafaaaoacabaaaappacaaaaaabmaaaajaabaaaaaa mul r5.yzw, r1.w, c28.xxyz
abaaaaaaadaaahacadaaaakeacaaaaaaafaaaapjacaaaaaa add r3.xyz, r3.xyzz, r5.yzww
abaaaaaaadaaahaeadaaaakeacaaaaaaaaaaaakeacaaaaaa add v3.xyz, r3.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r2.xyz, a1, r0.w
bfaaaaaaagaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r2.xyzz
adaaaaaaagaaahacagaaaakeacaaaaaabnaaaaffabaaaaaa mul r6.xyz, r6.xyzz, c29.y
acaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r6.xyzz, r1.xyzz
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
bcaaaaaaaaaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r1.xyzz, c6
bcaaaaaaaaaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r1.xyzz, c5
bcaaaaaaaaaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r1.xyzz, c4
bfaaaaaaagaaalacadaaaapdacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyw, r3.wxww
abaaaaaaabaaahaeagaaaafdacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r6.wxyy, c13
aaaaaaaaacaaaeaeaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v2.z, r4.x
aaaaaaaaacaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v2.y, r4.z
aaaaaaaaacaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v2.x, r5.x
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

}
Program "fp" {
// Fragment combos: 3
//   opengl - ALU: 34 to 36, TEX: 1 to 2
//   d3d9 - ALU: 36 to 38, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_AlphaPower]
Float 6 [_FresnelPower]
Float 7 [_threshold]
Float 8 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 36 ALU, 1 TEX
PARAM c[12] = { program.local[0..8],
		{ 0.11450195, 0.29882813, 0.58642578, 1 },
		{ 0, 0.79627001, 0.20373, 0.25 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
MUL R0.w, R0.y, c[9].z;
MAD R0.w, R0.x, c[9].y, R0;
DP3 R1.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
DP3 R2.w, fragment.texcoord[2], c[0];
MUL R2.xyz, R1.y, fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MAX R1.x, R1, c[10];
MAD_SAT R0.w, R0.z, c[9].x, R0;
ADD_SAT R1.w, -R1.x, c[9];
ADD R1.xyz, R0.w, -R0;
MAD R1.xyz, R1, c[7].x, R0;
POW R0.w, R1.w, c[6].x;
MAD R1.w, R0, c[10].y, c[10].z;
MOV R0.w, c[9];
MUL R0.xyz, R0, c[4];
MUL R0.xyz, R0, c[3];
ADD R0.w, R0, -c[7].x;
MAX R1.w, R1, c[10].x;
ADD R2.xyz, R0, c[2];
ADD R1.xyz, R1, -c[7].x;
RCP R0.w, R0.w;
MUL_SAT R0.xyw, R1.yzzx, R0.w;
MAD R1.xyz, R0.wxyw, c[8].x, R2;
MUL_SAT R1.w, R1, c[5].x;
MUL R2.xyz, R1, fragment.texcoord[3];
MUL R0.xyz, R1, c[1];
MAX R2.w, R2, c[10].x;
MUL R0.xyz, R2.w, R0;
MAD R0.xyz, R0, c[11].x, R2;
MAD result.color.xyz, R1, c[10].w, R0;
MAD result.color.w, R0, c[8].x, R1;
END
# 36 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_AlphaPower]
Float 6 [_FresnelPower]
Float 7 [_threshold]
Float 8 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"ps_2_0
; 38 ALU, 1 TEX
dcl_cube s0
def c9, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c10, 0.00000000, 0.79627001, 0.20373000, 2.00000000
def c11, 0.25000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r0, t0, s0
mul_pp r1.x, r0.y, c9
mad_pp r1.x, r0, c9.y, r1
mad_pp_sat r1.x, r0.z, c9.z, r1
add_pp r1.xyz, r1.x, -r0
mad_pp r1.xyz, r1, c7.x, r0
mov_pp r2.x, c7
add_pp r2.x, c9.w, -r2
mul r0.xyz, r0, c4
dp3 r3.x, t1, t1
rsq r3.x, r3.x
mul r0.xyz, r0, c3
dp3_pp r4.x, t2, c0
rcp_pp r2.x, r2.x
add r1.xyz, r1, -c7.x
mul_sat r1.xyz, r1, r2.x
dp3_pp r2.x, t2, t2
rsq_pp r2.x, r2.x
add r0.xyz, r0, c2
mul_pp r2.xyz, r2.x, t2
mul r3.xyz, r3.x, t1
dp3 r2.x, r3, r2
max r2.x, r2, c10
add_sat r2.x, -r2, c9.w
pow r3.y, r2.x, c6.x
mad_pp r0.xyz, r1, c8.x, r0
mad r3.x, r3.y, c10.y, c10.z
max r3.x, r3, c10
mul_sat r3.x, r3, c5
mul_pp r2.xyz, r0, c1
max_pp r4.x, r4, c10
mul_pp r2.xyz, r4.x, r2
mul_pp r4.xyz, r0, t3
mad_pp r2.xyz, r2, c10.w, r4
mad_pp r0.xyz, r0, c11.x, r2
mad_pp r0.w, r1.x, c8.x, r3.x
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
Float 5 [_AlphaPower]
Float 6 [_FresnelPower]
Float 7 [_threshold]
Float 8 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"agal_ps
c9 0.586426 0.298828 0.114502 1.0
c10 0.0 0.79627 0.20373 2.0
c11 0.25 0.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r0, v0, s0 <cube wrap linear point>
adaaaaaaabaaabacaaaaaaffacaaaaaaajaaaaoeabaaaaaa mul r1.x, r0.y, c9
adaaaaaaabaaaiacaaaaaaaaacaaaaaaajaaaaffabaaaaaa mul r1.w, r0.x, c9.y
abaaaaaaabaaabacabaaaappacaaaaaaabaaaaaaacaaaaaa add r1.x, r1.w, r1.x
adaaaaaaacaaabacaaaaaakkacaaaaaaajaaaakkabaaaaaa mul r2.x, r0.z, c9.z
abaaaaaaabaaabacacaaaaaaacaaaaaaabaaaaaaacaaaaaa add r1.x, r2.x, r1.x
bgaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r1.x, r1.x
acaaaaaaabaaahacabaaaaaaacaaaaaaaaaaaakeacaaaaaa sub r1.xyz, r1.x, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaahaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c7.x
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
aaaaaaaaacaaabacahaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c7
acaaaaaaacaaabacajaaaappabaaaaaaacaaaaaaacaaaaaa sub r2.x, c9.w, r2.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c4
bcaaaaaaadaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r3.x, v1, v1
akaaaaaaadaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r3.x, r3.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c3
bcaaaaaaaeaaabacacaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r4.x, v2, c0
afaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r2.x
acaaaaaaabaaahacabaaaakeacaaaaaaahaaaaaaabaaaaaa sub r1.xyz, r1.xyzz, c7.x
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaaaacaaaaaa mul r1.xyz, r1.xyzz, r2.x
bgaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r1.xyz, r1.xyzz
bcaaaaaaacaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r2.x, v2, v2
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaoeabaaaaaa add r0.xyz, r0.xyzz, c2
adaaaaaaacaaahacacaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r2.xyz, r2.x, v2
adaaaaaaadaaahacadaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r3.xyz, r3.x, v1
bcaaaaaaacaaabacadaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.x, r3.xyzz, r2.xyzz
ahaaaaaaacaaabacacaaaaaaacaaaaaaakaaaaoeabaaaaaa max r2.x, r2.x, c10
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaajaaaappabaaaaaa add r2.x, r2.x, c9.w
bgaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r2.x, r2.x
alaaaaaaadaaapacacaaaaaaacaaaaaaagaaaaaaabaaaaaa pow r3, r2.x, c6.x
adaaaaaaafaaahacabaaaakeacaaaaaaaiaaaaaaabaaaaaa mul r5.xyz, r1.xyzz, c8.x
abaaaaaaaaaaahacafaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r5.xyzz, r0.xyzz
adaaaaaaadaaabacadaaaaaaacaaaaaaakaaaaffabaaaaaa mul r3.x, r3.x, c10.y
abaaaaaaadaaabacadaaaaaaacaaaaaaakaaaakkabaaaaaa add r3.x, r3.x, c10.z
ahaaaaaaadaaabacadaaaaaaacaaaaaaakaaaaoeabaaaaaa max r3.x, r3.x, c10
adaaaaaaadaaabacadaaaaaaacaaaaaaafaaaaoeabaaaaaa mul r3.x, r3.x, c5
bgaaaaaaadaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r3.x, r3.x
adaaaaaaacaaahacaaaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r0.xyzz, c1
ahaaaaaaaeaaabacaeaaaaaaacaaaaaaakaaaaoeabaaaaaa max r4.x, r4.x, c10
adaaaaaaacaaahacaeaaaaaaacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r4.x, r2.xyzz
adaaaaaaaeaaahacaaaaaakeacaaaaaaadaaaaoeaeaaaaaa mul r4.xyz, r0.xyzz, v3
adaaaaaaacaaahacacaaaakeacaaaaaaakaaaappabaaaaaa mul r2.xyz, r2.xyzz, c10.w
abaaaaaaacaaahacacaaaakeacaaaaaaaeaaaakeacaaaaaa add r2.xyz, r2.xyzz, r4.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaalaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c11.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
adaaaaaaaaaaaiacabaaaaaaacaaaaaaaiaaaaaaabaaaaaa mul r0.w, r1.x, c8.x
abaaaaaaaaaaaiacaaaaaappacaaaaaaadaaaaaaacaaaaaa add r0.w, r0.w, r3.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_FresnelPower]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 34 ALU, 2 TEX
PARAM c[10] = { program.local[0..6],
		{ 0.11450195, 0.29882813, 0.58642578, 1 },
		{ 0, 0.79627001, 0.20373, 8 },
		{ 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MUL R1.w, R1.y, c[7].z;
MAD R1.w, R1.x, c[7].y, R1;
DP3 R2.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.y, R2.y;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
MAD_SAT R1.w, R1.z, c[7].x, R1;
MUL R3.xyz, R2.y, fragment.texcoord[2];
RSQ R2.x, R2.x;
MUL R2.xyz, R2.x, fragment.texcoord[1];
DP3 R2.x, R2, R3;
MAX R2.x, R2, c[8];
ADD_SAT R2.w, -R2.x, c[7];
ADD R2.xyz, R1.w, -R1;
MAD R2.xyz, R2, c[5].x, R1;
POW R1.w, R2.w, c[4].x;
MOV R2.w, c[7];
MUL R1.xyz, R1, c[2];
ADD R2.w, R2, -c[5].x;
MUL R1.xyz, R1, c[1];
MUL R0.xyz, R0.w, R0;
MAD R1.w, R1, c[8].y, c[8].z;
MAX R0.w, R1, c[8].x;
ADD R2.xyz, R2, -c[5].x;
RCP R2.w, R2.w;
MUL_SAT R2.xyz, R2, R2.w;
ADD R1.xyz, R1, c[0];
MAD R1.xyz, R2, c[6].x, R1;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R1, c[9].x;
MUL_SAT R0.w, R0, c[3].x;
MAD result.color.xyz, R0, c[8].w, R1;
MAD result.color.w, R2.x, c[6].x, R0;
END
# 34 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_FresnelPower]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 36 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c7, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c8, 0.00000000, 0.79627001, 0.20373000, 0.25000000
def c9, 8.00000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r3, t0, s0
texld r2, t3, s1
mul_pp r0.x, r3.y, c7
mad_pp r0.x, r3, c7.y, r0
mad_pp_sat r0.x, r3.z, c7.z, r0
add_pp r1.xyz, r0.x, -r3
mad_pp r1.xyz, r1, c5.x, r3
add r4.xyz, r1, -c5.x
dp3 r0.x, t1, t1
rsq r0.x, r0.x
mul r5.xyz, r0.x, t1
dp3_pp r1.x, t2, t2
mov_pp r0.x, c5
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
add_pp r0.x, c7.w, -r0
rcp_pp r0.x, r0.x
mul_sat r4.xyz, r4, r0.x
dp3 r1.x, r5, r1
max r0.x, r1, c8
mul r1.xyz, r3, c2
mul r3.xyz, r1, c1
add_sat r0.x, -r0, c7.w
pow r1.w, r0.x, c4.x
add r0.xyz, r3, c0
mad_pp r3.xyz, r4, c6.x, r0
mov r0.x, r1.w
mul_pp r1.xyz, r2.w, r2
mad r0.x, r0, c8.y, c8.z
max r0.x, r0, c8
mul_sat r0.x, r0, c3
mul_pp r1.xyz, r1, r3
mul_pp r2.xyz, r3, c8.w
mad_pp r1.xyz, r1, c9.x, r2
mad_pp r1.w, r4.x, c6.x, r0.x
mov_pp oC0, r1
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
Float 3 [_AlphaPower]
Float 4 [_FresnelPower]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c7 0.586426 0.298828 0.114502 1.0
c8 0.0 0.79627 0.20373 0.25
c9 8.0 0.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
ciaaaaaaacaaapacadaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v3, s1 <2d wrap linear point>
adaaaaaaaaaaabacadaaaaffacaaaaaaahaaaaoeabaaaaaa mul r0.x, r3.y, c7
adaaaaaaaaaaaiacadaaaaaaacaaaaaaahaaaaffabaaaaaa mul r0.w, r3.x, c7.y
abaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r0.w, r0.x
adaaaaaaabaaabacadaaaakkacaaaaaaahaaaakkabaaaaaa mul r1.x, r3.z, c7.z
abaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.x, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaabaaahacaaaaaaaaacaaaaaaadaaaakeacaaaaaa sub r1.xyz, r0.x, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
abaaaaaaabaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r1.xyzz, r3.xyzz
acaaaaaaaeaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa sub r4.xyz, r1.xyzz, c5.x
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaafaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r5.xyz, r0.x, v1
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
aaaaaaaaaaaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c5
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
acaaaaaaaaaaabacahaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c7.w, r0.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r4.xyz, r4.xyzz, r0.x
bgaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r4.xyz, r4.xyzz
bcaaaaaaabaaabacafaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.x, r5.xyzz, r1.xyzz
ahaaaaaaaaaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r1.x, c8
adaaaaaaabaaahacadaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c2
adaaaaaaadaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c1
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa pow r1, r0.x, c4.x
abaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa add r0.xyz, r3.xyzz, c0
adaaaaaaadaaahacaeaaaakeacaaaaaaagaaaaaaabaaaaaa mul r3.xyz, r4.xyzz, c6.x
abaaaaaaadaaahacadaaaakeacaaaaaaaaaaaakeacaaaaaa add r3.xyz, r3.xyzz, r0.xyzz
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaabaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r2.w, r2.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r0.x, r0.x, c8.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaakkabaaaaaa add r0.x, r0.x, c8.z
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
adaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa mul r0.x, r0.x, c3
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r1.xyzz, r3.xyzz
adaaaaaaacaaahacadaaaakeacaaaaaaaiaaaappabaaaaaa mul r2.xyz, r3.xyzz, c8.w
adaaaaaaabaaahacabaaaakeacaaaaaaajaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c9.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaabaaaiacaeaaaaaaacaaaaaaagaaaaaaabaaaaaa mul r1.w, r4.x, c6.x
abaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r1.w, r1.w, r0.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_FresnelPower]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 34 ALU, 2 TEX
PARAM c[10] = { program.local[0..6],
		{ 0.11450195, 0.29882813, 0.58642578, 1 },
		{ 0, 0.79627001, 0.20373, 8 },
		{ 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MUL R1.w, R1.y, c[7].z;
MAD R1.w, R1.x, c[7].y, R1;
DP3 R2.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.y, R2.y;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
MAD_SAT R1.w, R1.z, c[7].x, R1;
MUL R3.xyz, R2.y, fragment.texcoord[2];
RSQ R2.x, R2.x;
MUL R2.xyz, R2.x, fragment.texcoord[1];
DP3 R2.x, R2, R3;
MAX R2.x, R2, c[8];
ADD_SAT R2.w, -R2.x, c[7];
ADD R2.xyz, R1.w, -R1;
MAD R2.xyz, R2, c[5].x, R1;
POW R1.w, R2.w, c[4].x;
MOV R2.w, c[7];
MUL R1.xyz, R1, c[2];
ADD R2.w, R2, -c[5].x;
MUL R1.xyz, R1, c[1];
MUL R0.xyz, R0.w, R0;
MAD R1.w, R1, c[8].y, c[8].z;
MAX R0.w, R1, c[8].x;
ADD R2.xyz, R2, -c[5].x;
RCP R2.w, R2.w;
MUL_SAT R2.xyz, R2, R2.w;
ADD R1.xyz, R1, c[0];
MAD R1.xyz, R2, c[6].x, R1;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R1, c[9].x;
MUL_SAT R0.w, R0, c[3].x;
MAD result.color.xyz, R0, c[8].w, R1;
MAD result.color.w, R2.x, c[6].x, R0;
END
# 34 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_FresnelPower]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 36 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c7, 0.58642578, 0.29882813, 0.11450195, 1.00000000
def c8, 0.00000000, 0.79627001, 0.20373000, 0.25000000
def c9, 8.00000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r3, t0, s0
texld r2, t3, s1
mul_pp r0.x, r3.y, c7
mad_pp r0.x, r3, c7.y, r0
mad_pp_sat r0.x, r3.z, c7.z, r0
add_pp r1.xyz, r0.x, -r3
mad_pp r1.xyz, r1, c5.x, r3
add r4.xyz, r1, -c5.x
dp3 r0.x, t1, t1
rsq r0.x, r0.x
mul r5.xyz, r0.x, t1
dp3_pp r1.x, t2, t2
mov_pp r0.x, c5
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
add_pp r0.x, c7.w, -r0
rcp_pp r0.x, r0.x
mul_sat r4.xyz, r4, r0.x
dp3 r1.x, r5, r1
max r0.x, r1, c8
mul r1.xyz, r3, c2
mul r3.xyz, r1, c1
add_sat r0.x, -r0, c7.w
pow r1.w, r0.x, c4.x
add r0.xyz, r3, c0
mad_pp r3.xyz, r4, c6.x, r0
mov r0.x, r1.w
mul_pp r1.xyz, r2.w, r2
mad r0.x, r0, c8.y, c8.z
max r0.x, r0, c8
mul_sat r0.x, r0, c3
mul_pp r1.xyz, r1, r3
mul_pp r2.xyz, r3, c8.w
mad_pp r1.xyz, r1, c9.x, r2
mad_pp r1.w, r4.x, c6.x, r0.x
mov_pp oC0, r1
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
Float 3 [_AlphaPower]
Float 4 [_FresnelPower]
Float 5 [_threshold]
Float 6 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c7 0.586426 0.298828 0.114502 1.0
c8 0.0 0.79627 0.20373 0.25
c9 8.0 0.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
ciaaaaaaacaaapacadaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v3, s1 <2d wrap linear point>
adaaaaaaaaaaabacadaaaaffacaaaaaaahaaaaoeabaaaaaa mul r0.x, r3.y, c7
adaaaaaaaaaaaiacadaaaaaaacaaaaaaahaaaaffabaaaaaa mul r0.w, r3.x, c7.y
abaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r0.w, r0.x
adaaaaaaabaaabacadaaaakkacaaaaaaahaaaakkabaaaaaa mul r1.x, r3.z, c7.z
abaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.x, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
acaaaaaaabaaahacaaaaaaaaacaaaaaaadaaaakeacaaaaaa sub r1.xyz, r0.x, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
abaaaaaaabaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r1.xyzz, r3.xyzz
acaaaaaaaeaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa sub r4.xyz, r1.xyzz, c5.x
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaafaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r5.xyz, r0.x, v1
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
aaaaaaaaaaaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c5
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
acaaaaaaaaaaabacahaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c7.w, r0.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r4.xyz, r4.xyzz, r0.x
bgaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r4.xyz, r4.xyzz
bcaaaaaaabaaabacafaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.x, r5.xyzz, r1.xyzz
ahaaaaaaaaaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r1.x, c8
adaaaaaaabaaahacadaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c2
adaaaaaaadaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c1
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa pow r1, r0.x, c4.x
abaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa add r0.xyz, r3.xyzz, c0
adaaaaaaadaaahacaeaaaakeacaaaaaaagaaaaaaabaaaaaa mul r3.xyz, r4.xyzz, c6.x
abaaaaaaadaaahacadaaaakeacaaaaaaaaaaaakeacaaaaaa add r3.xyz, r3.xyzz, r0.xyzz
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaabaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r2.w, r2.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r0.x, r0.x, c8.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaakkabaaaaaa add r0.x, r0.x, c8.z
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
adaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa mul r0.x, r0.x, c3
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r1.xyzz, r3.xyzz
adaaaaaaacaaahacadaaaakeacaaaaaaaiaaaappabaaaaaa mul r2.xyz, r3.xyzz, c8.w
adaaaaaaabaaahacabaaaakeacaaaaaaajaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c9.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaabaaaiacaeaaaaaaacaaaaaaagaaaaaaabaaaaaa mul r1.w, r4.x, c6.x
abaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r1.w, r1.w, r0.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT4.z, r0, c14
dp4 oT4.y, r0, c13
dp4 oT4.x, r0, c12
add oT1.xyz, -r0, c17
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
add oT3.xyz, -r0, c18
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
#line 397
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
#line 380
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 386
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 403
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 407
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 411
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 415
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
    surfIN.worldRefl = IN.worldRefl;
    #line 447
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 451
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 455
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.00000));
    c.w = o.Alpha;
    #line 459
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD4);
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
#line 400
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
#line 383
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 389
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 406
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 410
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 414
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 418
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
    surfIN.worldRefl = IN.worldRefl;
    #line 450
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 454
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 458
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.00000));
    c.w = o.Alpha;
    #line 462
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD4);
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
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v4.z, r0, c14
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v4.y, r0, c13
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v4.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaabaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r2.xyzz, c17
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaadaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v3.xyz, r2.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
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
"vs_2_0
; 25 ALU
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
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT1.xyz, -r0, c13
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mov oT3.xyz, c14
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
#line 395
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 415
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
uniform lowp vec4 _LightColor0;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 405
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 409
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 413
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 439
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 442
    surfIN.worldRefl = IN.worldRefl;
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    #line 446
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    #line 450
    o.Normal = IN.normal;
    surf( surfIN, o);
    lightDir = IN.lightDir;
    c = LightingLambert( o, lightDir, 1.00000);
    #line 454
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
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
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
uniform lowp vec4 _LightColor0;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 412
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 416
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 442
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    #line 445
    surfIN.worldRefl = IN.worldRefl;
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    #line 449
    o.Emission = vec3( 0.000000);
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    #line 453
    o.Normal = IN.normal;
    surf( surfIN, o);
    lightDir = IN.lightDir;
    c = LightingLambert( o, lightDir, 1.00000);
    #line 457
    c.w = o.Alpha;
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
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
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaabaaahaeacaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r2.xyzz, c13
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
aaaaaaaaadaaahaeaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c14
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
"vs_2_0
; 30 ALU
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
dp4 oT4.w, r0, c15
dp4 oT4.z, r0, c14
dp4 oT4.y, r0, c13
dp4 oT4.x, r0, c12
add oT1.xyz, -r0, c17
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
add oT3.xyz, -r0, c18
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
#line 406
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 426
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
#line 389
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 395
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 416
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 420
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 424
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 452
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 456
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 460
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 464
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (((float((IN._LightCoord.z > 0.000000)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.00000));
    c.w = o.Alpha;
    #line 468
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec4( xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:98(39): error: too few components to construct `mat3'
0:98(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:98(14): error: cannot construct `float' from a non-numeric data type
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
#line 409
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 429
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
#line 392
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 398
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 415
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 419
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 423
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 427
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 459
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 463
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 467
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, (((float((IN._LightCoord.z > 0.000000)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.00000));
    c.w = o.Alpha;
    #line 471
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec4( xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:98(39): error: too few components to construct `mat3'
0:98(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:98(14): error: cannot construct `float' from a non-numeric data type
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
bdaaaaaaaeaaaiaeaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 v4.w, r0, c15
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v4.z, r0, c14
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v4.y, r0, c13
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v4.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaabaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r2.xyzz, c17
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaadaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v3.xyz, r2.xyzz, c18
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
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT4.z, r0, c14
dp4 oT4.y, r0, c13
dp4 oT4.x, r0, c12
add oT1.xyz, -r0, c17
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
add oT3.xyz, -r0, c18
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
#line 398
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 418
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 408
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 412
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 416
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 444
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 448
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 452
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 456
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, ((texture2D( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * textureCube( _LightTexture0, IN._LightCoord).w) * 1.00000));
    c.w = o.Alpha;
    #line 460
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:96(39): error: too few components to construct `mat3'
0:96(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:96(14): error: cannot construct `float' from a non-numeric data type
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
#line 401
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 421
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
#line 384
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 390
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 407
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 411
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 415
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 419
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
#line 447
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    SurfaceOutput o;
    lowp vec3 lightDir;
    lowp vec4 c;
    surfIN.worldRefl = IN.worldRefl;
    #line 451
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 455
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 459
    surf( surfIN, o);
    lightDir = normalize(IN.lightDir);
    c = LightingLambert( o, lightDir, ((texture2D( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * textureCube( _LightTexture0, IN._LightCoord).w) * 1.00000));
    c.w = o.Alpha;
    #line 463
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3( xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:96(39): error: too few components to construct `mat3'
0:96(61): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:96(14): error: cannot construct `float' from a non-numeric data type
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
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v4.z, r0, c14
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v4.y, r0, c13
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v4.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaabaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r2.xyzz, c17
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaadaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v3.xyz, r2.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
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
dp4 oT4.y, r0, c13
dp4 oT4.x, r0, c12
add oT1.xyz, -r0, c17
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mov oT3.xyz, c18
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
#line 397
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
#line 380
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 386
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 403
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 407
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 411
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 415
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
    surfIN.worldRefl = IN.worldRefl;
    #line 447
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 451
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 455
    surf( surfIN, o);
    lightDir = IN.lightDir;
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, IN._LightCoord).w * 1.00000));
    c.w = o.Alpha;
    #line 459
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec2( xlv_TEXCOORD4);
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
#line 400
struct Input {
    highp vec3 worldRefl;
    highp vec3 viewDir;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    mediump vec3 worldRefl;
    highp vec3 viewDir;
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
uniform highp float _AlphaPower;
uniform highp vec4 _Color;
uniform samplerCube _Cube;
uniform highp float _FresnelPower;
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
#line 383
lowp vec3 highpass( in lowp vec3 c ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 389
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((c * mat3( luminanceFilter))));
    desaturated = mix( c, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - _threshold) * normalizationFactor));
}
#line 406
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 c;
    mediump vec3 worldReflVec;
    mediump vec4 reflcol;
    highp float fcbias = 0.203730;
    highp float facing;
    highp float refl2Refr;
    c = _Color;
    worldReflVec = IN.worldRefl;
    #line 410
    reflcol = textureCube( _Cube, worldReflVec);
    facing = xll_saturate((1.00000 - max( dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.000000)));
    refl2Refr = max( (fcbias + ((1.00000 - fcbias) * pow( facing, _FresnelPower))), 0.000000);
    #line 414
    o.Albedo = (((reflcol.xyz * _ReflectColor.xyz) * vec3( _TintColor)) + c.xyz);
    o.Albedo.xyz += (highpass( vec3( reflcol)) * _thresholdInt);
    o.Emission = (o.Albedo * 0.250000);
    o.Alpha = xll_saturate((refl2Refr * _AlphaPower));
    #line 418
    o.Alpha += float( (highpass( vec3( reflcol)) * _thresholdInt));
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
    surfIN.worldRefl = IN.worldRefl;
    #line 450
    surfIN.viewDir = IN.viewDir;
    o.Albedo = vec3( 0.000000);
    o.Emission = vec3( 0.000000);
    #line 454
    o.Specular = 0.000000;
    o.Alpha = 0.000000;
    o.Gloss = 0.000000;
    o.Normal = IN.normal;
    #line 458
    surf( surfIN, o);
    lightDir = IN.lightDir;
    c = LightingLambert( o, lightDir, (texture2D( _LightTexture0, IN._LightCoord).w * 1.00000));
    c.w = o.Alpha;
    #line 462
    return c;
}
varying mediump vec3 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.worldRefl = vec3( xlv_TEXCOORD0);
    xlt_IN.viewDir = vec3( xlv_TEXCOORD1);
    xlt_IN.normal = vec3( xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3( xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec2( xlv_TEXCOORD4);
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
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v4.y, r0, c13
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v4.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaabaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r2.xyzz, c17
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
aaaaaaaaadaaahaebcaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, c0
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 35 to 46, TEX: 1 to 3
//   d3d9 - ALU: 38 to 48, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 40 ALU, 2 TEX
PARAM c[10] = { program.local[0..7],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 0.29882813, 0.58642578, 0.11450195, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MUL R1.y, R0, c[9];
MAX R1.x, R1, c[8].w;
ADD_SAT R1.x, -R1, c[8].z;
POW R1.x, R1.x, c[5].x;
MAD R1.x, R1, c[8].y, c[8];
MAX R1.x, R1, c[8].w;
MOV R2.x, c[8].z;
ADD R2.x, R2, -c[6];
MAD R1.y, R0.x, c[9].x, R1;
MUL_SAT R1.w, R1.x, c[4].x;
MAD_SAT R1.x, R0.z, c[9].z, R1.y;
ADD R1.xyz, R1.x, -R0;
MAD R1.xyz, R1, c[6].x, R0;
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
RCP R2.x, R2.x;
ADD R1.xyz, R1, -c[6].x;
MUL_SAT R1.xyz, R1, R2.x;
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.x, R2.x;
ADD R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[7].x, R0;
MUL R2.xyz, R2.x, fragment.texcoord[3];
DP3 R1.y, fragment.texcoord[2], R2;
MUL R0.xyz, R0, c[0];
MAX R1.y, R1, c[8].w;
MAD result.color.w, R1.x, c[7].x, R1;
TEX R0.w, R0.w, texture[1], 2D;
MUL R0.w, R1.y, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[9].w;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 42 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c8, 0.00000000, 0.79627001, 0.20373000, 0.58642578
def c9, 0.29882813, 0.11450195, 1.00000000, 2.00000000
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r1, t0, s0
mul_pp r2.x, r1.y, c8.w
mad_pp r2.x, r1, c9, r2
mad_pp_sat r2.x, r1.z, c9.y, r2
add_pp r2.xyz, -r1, r2.x
mad_pp r2.xyz, r2, c6.x, r1
dp3 r0.x, t4, t4
mov r0.xy, r0.x
mov_pp r3.x, c6
add_pp r3.x, c9.z, -r3
mul r1.xyz, r1, c3
dp3 r4.x, t1, t1
rsq r4.x, r4.x
mul r1.xyz, r1, c2
rcp_pp r3.x, r3.x
add r2.xyz, r2, -c6.x
mul_sat r2.xyz, r2, r3.x
dp3_pp r3.x, t2, t2
rsq_pp r3.x, r3.x
add r1.xyz, r1, c1
mad_pp r1.xyz, r2, c7.x, r1
mul_pp r3.xyz, r3.x, t2
mul r4.xyz, r4.x, t1
dp3 r3.x, r4, r3
max r3.x, r3, c8
add_sat r3.x, -r3, c9.z
pow r4.y, r3.x, c5.x
dp3_pp r3.x, t3, t3
rsq_pp r3.x, r3.x
mad r4.x, r4.y, c8.y, c8.z
mul_pp r3.xyz, r3.x, t3
dp3_pp r3.x, t2, r3
mul_pp r1.xyz, r1, c0
max r4.x, r4, c8
max_pp r3.x, r3, c8
texld r0, r0, s1
mul_pp r0.x, r3, r0
mul_pp r0.xyz, r0.x, r1
mul_sat r1.x, r4, c4
mul_pp r0.xyz, r0, c9.w
mad_pp r0.w, r2.x, c7.x, r1.x
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
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c8 0.0 0.79627 0.20373 0.586426
c9 0.298828 0.114502 1.0 2.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r1, v0, s0 <cube wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
aaaaaaaaacaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c6
acaaaaaaacaaabacajaaaakkabaaaaaaacaaaaaaacaaaaaa sub r2.x, c9.z, r2.x
bcaaaaaaadaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r3.x, v1, v1
akaaaaaaadaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r3.x, r3.x
afaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r2.x
adaaaaaaadaaahacadaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r3.xyz, r3.x, v1
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
adaaaaaaaaaaabacabaaaaffacaaaaaaaiaaaappabaaaaaa mul r0.x, r1.y, c8.w
adaaaaaaacaaaiacabaaaaaaacaaaaaaajaaaaoeabaaaaaa mul r2.w, r1.x, c9
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
adaaaaaaadaaaiacabaaaakkacaaaaaaajaaaaffabaaaaaa mul r3.w, r1.z, c9.y
abaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r3.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
bfaaaaaaaeaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r1.xyzz
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaaaaacaaaaaa add r0.xyz, r4.xyzz, r0.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c6.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
acaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaaaaabaaaaaa sub r0.xyz, r0.xyzz, c6.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaaaacaaaaaa mul r0.xyz, r0.xyzz, r2.x
bgaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r0.xyz, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c3
bcaaaaaaacaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r2.x, v2, v2
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
adaaaaaaacaaahacacaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r2.xyz, r2.x, v2
bcaaaaaaacaaabacadaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.x, r3.xyzz, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c2
ahaaaaaaacaaabacacaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r2.x, r2.x, c8
bfaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r2.x
abaaaaaaacaaabacacaaaaaaacaaaaaaajaaaakkabaaaaaa add r2.x, r2.x, c9.z
bgaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r2.x, r2.x
alaaaaaaadaaapacacaaaaaaacaaaaaaafaaaaaaabaaaaaa pow r3, r2.x, c5.x
abaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c1
adaaaaaaaeaaahacaaaaaakeacaaaaaaahaaaaaaabaaaaaa mul r4.xyz, r0.xyzz, c7.x
abaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r4.xyzz, r1.xyzz
bcaaaaaaacaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r2.x, v3, v3
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
adaaaaaaadaaabacadaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r3.x, r3.x, c8.y
abaaaaaaadaaabacadaaaaaaacaaaaaaaiaaaakkabaaaaaa add r3.x, r3.x, c8.z
adaaaaaaacaaahacacaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r2.xyz, r2.x, v3
bcaaaaaaacaaabacacaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r2.x, v2, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
ahaaaaaaadaaabacadaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r3.x, r3.x, c8
ahaaaaaaacaaabacacaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r2.x, r2.x, c8
adaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaappacaaaaaa mul r2.x, r2.x, r0.w
adaaaaaaabaaahacacaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r2.x, r1.xyzz
adaaaaaaacaaabacadaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r2.x, r3.x, c4
bgaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r2.x, r2.x
adaaaaaaabaaahacabaaaakeacaaaaaaajaaaappabaaaaaa mul r1.xyz, r1.xyzz, c9.w
adaaaaaaabaaaiacaaaaaaaaacaaaaaaahaaaaaaabaaaaaa mul r1.w, r0.x, c7.x
abaaaaaaabaaaiacabaaaappacaaaaaaacaaaaaaacaaaaaa add r1.w, r1.w, r2.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 1 TEX
PARAM c[10] = { program.local[0..7],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 0.29882813, 0.58642578, 0.11450195, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
MOV R1.w, c[8].z;
ADD R1.w, R1, -c[6].x;
MUL R2.xyz, R1.x, fragment.texcoord[2];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R1, R2;
MUL R1.x, R0.y, c[9].y;
MAD R1.x, R0, c[9], R1;
MAD_SAT R1.x, R0.z, c[9].z, R1;
ADD R1.xyz, R1.x, -R0;
MAD R1.xyz, R1, c[6].x, R0;
MAX R0.w, R0, c[8];
ADD_SAT R0.w, -R0, c[8].z;
POW R0.w, R0.w, c[5].x;
MAD R0.w, R0, c[8].y, c[8].x;
MAX R0.w, R0, c[8];
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
MUL_SAT R0.w, R0, c[4].x;
ADD R1.xyz, R1, -c[6].x;
RCP R1.w, R1.w;
MUL_SAT R1.xyz, R1, R1.w;
ADD R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[7].x, R0;
MOV R2.xyz, fragment.texcoord[3];
DP3 R1.y, fragment.texcoord[2], R2;
MUL R0.xyz, R0, c[0];
MAX R1.y, R1, c[8].w;
MUL R0.xyz, R1.y, R0;
MAD result.color.w, R1.x, c[7].x, R0;
MUL result.color.xyz, R0, c[9].w;
END
# 35 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"ps_2_0
; 38 ALU, 1 TEX
dcl_cube s0
def c8, 0.00000000, 0.79627001, 0.20373000, 0.58642578
def c9, 0.29882813, 0.11450195, 1.00000000, 2.00000000
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r3, t0, s0
mul_pp r0.x, r3.y, c8.w
mad_pp r0.x, r3, c9, r0
mad_pp_sat r1.x, r3.z, c9.y, r0
add_pp r1.xyz, -r3, r1.x
mad_pp r1.xyz, r1, c6.x, r3
mov_pp r0.x, c6
add_pp r0.x, c9.z, -r0
add r1.xyz, r1, -c6.x
rcp_pp r0.x, r0.x
mul_sat r2.xyz, r1, r0.x
dp3_pp r1.x, t2, t2
dp3 r0.x, t1, t1
rsq_pp r1.x, r1.x
rsq r0.x, r0.x
mul r0.xyz, r0.x, t1
mul_pp r1.xyz, r1.x, t2
dp3 r0.x, r0, r1
mul r1.xyz, r3, c3
mul r1.xyz, r1, c2
max r0.x, r0, c8
add r3.xyz, r1, c1
add_sat r0.x, -r0, c9.z
pow r1.w, r0.x, c5.x
mad_pp r0.xyz, r2, c7.x, r3
mul_pp r3.xyz, r0, c0
mov r0.x, r1.w
mov_pp r1.xyz, t3
dp3_pp r1.x, t2, r1
mad r0.x, r0, c8.y, c8.z
max r0.x, r0, c8
max_pp r1.x, r1, c8
mul_pp r1.xyz, r1.x, r3
mul_sat r0.x, r0, c4
mul_pp r1.xyz, r1, c9.w
mad_pp r1.w, r2.x, c7.x, r0.x
mov_pp oC0, r1
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
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
"agal_ps
c8 0.0 0.79627 0.20373 0.586426
c9 0.298828 0.114502 1.0 2.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
adaaaaaaaaaaabacadaaaaffacaaaaaaaiaaaappabaaaaaa mul r0.x, r3.y, c8.w
adaaaaaaaaaaaiacadaaaaaaacaaaaaaajaaaaoeabaaaaaa mul r0.w, r3.x, c9
abaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r0.w, r0.x
adaaaaaaabaaabacadaaaakkacaaaaaaajaaaaffabaaaaaa mul r1.x, r3.z, c9.y
abaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r1.x, r1.x, r0.x
bgaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r1.x, r1.x
bfaaaaaaacaaahacadaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r3.xyzz
abaaaaaaabaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa add r1.xyz, r2.xyzz, r1.x
adaaaaaaabaaahacabaaaakeacaaaaaaagaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c6.x
abaaaaaaabaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r1.xyzz, r3.xyzz
aaaaaaaaaaaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c6
acaaaaaaaaaaabacajaaaakkabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c9.z, r0.x
acaaaaaaabaaahacabaaaakeacaaaaaaagaaaaaaabaaaaaa sub r1.xyz, r1.xyzz, c6.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r2.xyz, r1.xyzz, r0.x
bgaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r2.xyz, r2.xyzz
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c3
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c2
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
abaaaaaaadaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa add r3.xyz, r1.xyzz, c1
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaajaaaakkabaaaaaa add r0.x, r0.x, c9.z
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaafaaaaaaabaaaaaa pow r1, r0.x, c5.x
adaaaaaaaaaaahacacaaaakeacaaaaaaahaaaaaaabaaaaaa mul r0.xyz, r2.xyzz, c7.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaadaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r0.xyzz, c0
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
aaaaaaaaabaaahacadaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v3
bcaaaaaaabaaabacacaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v2, r1.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r0.x, r0.x, c8.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaakkabaaaaaa add r0.x, r0.x, c8.z
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
ahaaaaaaabaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r1.x, r1.x, c8
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r1.x, r3.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.x, c4
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaajaaaappabaaaaaa mul r1.xyz, r1.xyzz, c9.w
adaaaaaaabaaaiacacaaaaaaacaaaaaaahaaaaaaabaaaaaa mul r1.w, r2.x, c7.x
abaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r1.w, r1.w, r0.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 46 ALU, 3 TEX
PARAM c[11] = { program.local[0..7],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 0.29882813, 0.58642578, 0.11450195, 0.5 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
RCP R0.x, fragment.texcoord[4].w;
MAD R1.xy, fragment.texcoord[4], R0.x, c[9].w;
DP3 R1.z, fragment.texcoord[4], fragment.texcoord[4];
TEX R0.w, R1, texture[1], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R1.w, R1.z, texture[2], 2D;
DP3 R1.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MUL R1.y, R0, c[9];
MAD R1.y, R0.x, c[9].x, R1;
MAX R1.x, R1, c[8].w;
ADD_SAT R1.x, -R1, c[8].z;
POW R1.x, R1.x, c[5].x;
MAD R1.x, R1, c[8].y, c[8];
MAX R1.x, R1, c[8].w;
MOV R2.x, c[8].z;
ADD R2.x, R2, -c[6];
MAD_SAT R1.y, R0.z, c[9].z, R1;
MUL_SAT R2.w, R1.x, c[4].x;
ADD R1.xyz, R1.y, -R0;
MAD R1.xyz, R1, c[6].x, R0;
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
RCP R2.x, R2.x;
ADD R1.xyz, R1, -c[6].x;
MUL_SAT R1.xyz, R1, R2.x;
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
ADD R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[7].x, R0;
SLT R1.z, c[8].w, fragment.texcoord[4];
MUL R0.w, R1.z, R0;
RSQ R2.x, R2.x;
MUL R2.xyz, R2.x, fragment.texcoord[3];
MUL R1.z, R0.w, R1.w;
DP3 R1.y, fragment.texcoord[2], R2;
MAX R0.w, R1.y, c[8];
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, R1.z;
MUL R0.xyz, R0.w, R0;
MAD result.color.w, R1.x, c[7].x, R2;
MUL result.color.xyz, R0, c[10].x;
END
# 46 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 48 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_2d s2
def c8, 0.00000000, 0.79627001, 0.20373000, 0.58642578
def c9, 0.29882813, 0.11450195, 1.00000000, 0.50000000
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4
texld r3, t0, s0
dp3 r1.x, t4, t4
mov r1.xy, r1.x
rcp r0.x, t4.w
mad r0.xy, t4, r0.x, c9.w
texld r0, r0, s1
texld r5, r1, s2
mul_pp r0.x, r3.y, c8.w
mad_pp r0.x, r3, c9, r0
mad_pp_sat r0.x, r3.z, c9.y, r0
add_pp r0.xyz, -r3, r0.x
mad_pp r1.xyz, r0, c6.x, r3
add r4.xyz, r1, -c6.x
dp3 r0.x, t1, t1
rsq r1.x, r0.x
mul r2.xyz, r1.x, t1
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
mul_pp r1.xyz, r1.x, t2
mov_pp r0.x, c6
dp3 r1.x, r2, r1
add_pp r0.x, c9.z, -r0
rcp_pp r2.x, r0.x
max r0.x, r1, c8
add_sat r0.x, -r0, c9.z
pow r1.w, r0.x, c5.x
mul r3.xyz, r3, c3
mul r0.xyz, r3, c2
add r3.xyz, r0, c1
mov r0.x, r1.w
mul_sat r2.xyz, r4, r2.x
mad_pp r1.xyz, r2, c7.x, r3
mul_pp r4.xyz, r1, c0
dp3_pp r1.x, t3, t3
rsq_pp r3.x, r1.x
mad r0.x, r0, c8.y, c8.z
max r0.x, r0, c8
cmp r1.x, -t4.z, c10, c10.y
mul_pp r3.xyz, r3.x, t3
dp3_pp r3.x, t2, r3
mul_sat r0.x, r0, c4
mul_pp r1.x, r1, r0.w
mul_pp r1.x, r1, r5
max_pp r3.x, r3, c8
mul_pp r1.x, r3, r1
mul_pp r1.xyz, r1.x, r4
mul_pp r1.xyz, r1, c10.z
mad_pp r1.w, r2.x, c7.x, r0.x
mov_pp oC0, r1
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
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"agal_ps
c8 0.0 0.79627 0.20373 0.586426
c9 0.298828 0.114502 1.0 0.5
c10 0.0 1.0 2.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
afaaaaaaaaaaabacaeaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, v4.w
aaaaaaaaabaaadacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.xy, r1.x
adaaaaaaaaaaadacaeaaaaoeaeaaaaaaaaaaaaaaacaaaaaa mul r0.xy, v4, r0.x
abaaaaaaaaaaadacaaaaaafeacaaaaaaajaaaappabaaaaaa add r0.xy, r0.xyyy, c9.w
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaabaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r1, r1.xyyy, s2 <2d wrap linear point>
adaaaaaaaaaaabacadaaaaffacaaaaaaaiaaaappabaaaaaa mul r0.x, r3.y, c8.w
adaaaaaaacaaabacadaaaaaaacaaaaaaajaaaaoeabaaaaaa mul r2.x, r3.x, c9
abaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.x, r0.x
adaaaaaaacaaaiacadaaaakkacaaaaaaajaaaaffabaaaaaa mul r2.w, r3.z, c9.y
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
bfaaaaaaaeaaahacadaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r3.xyzz
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaaaaacaaaaaa add r0.xyz, r4.xyzz, r0.x
adaaaaaaabaaahacaaaaaakeacaaaaaaagaaaaaaabaaaaaa mul r1.xyz, r0.xyzz, c6.x
abaaaaaaabaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r1.xyzz, r3.xyzz
acaaaaaaaeaaahacabaaaakeacaaaaaaagaaaaaaabaaaaaa sub r4.xyz, r1.xyzz, c6.x
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
adaaaaaaacaaahacabaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r2.xyz, r1.x, v1
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
aaaaaaaaaaaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c6
bcaaaaaaabaaabacacaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.x, r2.xyzz, r1.xyzz
acaaaaaaaaaaabacajaaaakkabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c9.z, r0.x
afaaaaaaacaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r0.x
ahaaaaaaaaaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r1.x, c8
adaaaaaaacaaahacaeaaaakeacaaaaaaacaaaaaaacaaaaaa mul r2.xyz, r4.xyzz, r2.x
bgaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r2.xyz, r2.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c3
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaajaaaakkabaaaaaa add r0.x, r0.x, c9.z
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaadaaapacaaaaaaaaacaaaaaaafaaaaaaabaaaaaa pow r3, r0.x, c5.x
adaaaaaaaaaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r0.xyz, r1.xyzz, c2
abaaaaaaabaaahacaaaaaakeacaaaaaaabaaaaoeabaaaaaa add r1.xyz, r0.xyzz, c1
adaaaaaaafaaahacacaaaakeacaaaaaaahaaaaaaabaaaaaa mul r5.xyz, r2.xyzz, c7.x
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaaeaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r4.xyz, r1.xyzz, c0
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaadaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r3.x, r1.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r0.x, r0.x, c8.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaakkabaaaaaa add r0.x, r0.x, c8.z
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
bfaaaaaaafaaaeacaeaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r5.z, v4.z
ckaaaaaaabaaabacafaaaakkacaaaaaaakaaaaaaabaaaaaa slt r1.x, r5.z, c10.x
adaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.x, r0.w
adaaaaaaadaaahacadaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r3.xyz, r3.x, v3
bcaaaaaaadaaabacacaaaaoeaeaaaaaaadaaaakeacaaaaaa dp3 r3.x, v2, r3.xyzz
adaaaaaaabaaabacabaaaaaaacaaaaaaabaaaappacaaaaaa mul r1.x, r1.x, r1.w
ahaaaaaaadaaabacadaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r3.x, r3.x, c8
adaaaaaaabaaabacadaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r1.x, r3.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r1.xyz, r1.x, r4.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.x, c4
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaakaaaakkabaaaaaa mul r1.xyz, r1.xyzz, c10.z
adaaaaaaabaaaiacacaaaaaaacaaaaaaahaaaaaaabaaaaaa mul r1.w, r2.x, c7.x
abaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r1.w, r1.w, r0.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 42 ALU, 3 TEX
PARAM c[10] = { program.local[0..7],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 0.29882813, 0.58642578, 0.11450195, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R1.w, fragment.texcoord[4], texture[2], CUBE;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MUL R1.y, R0, c[9];
MAD R1.y, R0.x, c[9].x, R1;
MAX R1.x, R1, c[8].w;
ADD_SAT R1.x, -R1, c[8].z;
POW R1.x, R1.x, c[5].x;
MAD R1.x, R1, c[8].y, c[8];
MAX R1.x, R1, c[8].w;
MOV R2.x, c[8].z;
ADD R2.x, R2, -c[6];
MAD_SAT R1.y, R0.z, c[9].z, R1;
MUL_SAT R2.w, R1.x, c[4].x;
ADD R1.xyz, R1.y, -R0;
MAD R1.xyz, R1, c[6].x, R0;
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
RCP R2.x, R2.x;
ADD R1.xyz, R1, -c[6].x;
MUL_SAT R1.xyz, R1, R2.x;
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
ADD R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[7].x, R0;
RSQ R2.x, R2.x;
MUL R2.xyz, R2.x, fragment.texcoord[3];
MUL R0.xyz, R0, c[0];
DP3 R1.y, fragment.texcoord[2], R2;
MAD result.color.w, R1.x, c[7].x, R2;
TEX R0.w, R0.w, texture[1], 2D;
MUL R1.z, R0.w, R1.w;
MAX R0.w, R1.y, c[8];
MUL R0.w, R0, R1.z;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[9].w;
END
# 42 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 44 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_cube s2
def c8, 0.00000000, 0.79627001, 0.20373000, 0.58642578
def c9, 0.29882813, 0.11450195, 1.00000000, 2.00000000
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r2, t0, s0
dp3 r0.x, t4, t4
mov r1.xy, r0.x
texld r0, t4, s2
texld r5, r1, s1
mul_pp r0.x, r2.y, c8.w
mad_pp r0.x, r2, c9, r0
mad_pp_sat r0.x, r2.z, c9.y, r0
add_pp r1.xyz, -r2, r0.x
mad_pp r1.xyz, r1, c6.x, r2
add r3.xyz, r1, -c6.x
dp3 r0.x, t1, t1
rsq r0.x, r0.x
mul r4.xyz, r0.x, t1
dp3_pp r1.x, t2, t2
mov_pp r0.x, c6
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
add_pp r0.x, c9.z, -r0
rcp_pp r0.x, r0.x
dp3 r1.x, r4, r1
mul_sat r3.xyz, r3, r0.x
max r0.x, r1, c8
mul r1.xyz, r2, c3
mul r2.xyz, r1, c2
add_sat r0.x, -r0, c9.z
pow r1.w, r0.x, c5.x
add r0.xyz, r2, c1
mad_pp r2.xyz, r3, c7.x, r0
mov r0.x, r1.w
mad r0.x, r0, c8.y, c8.z
max r0.x, r0, c8
dp3_pp r1.x, t3, t3
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t3
dp3_pp r1.x, t2, r1
mul_sat r0.x, r0, c4
mul_pp r2.xyz, r2, c0
mul r4.x, r5, r0.w
max_pp r1.x, r1, c8
mul_pp r1.x, r1, r4
mul_pp r1.xyz, r1.x, r2
mul_pp r1.xyz, r1, c9.w
mad_pp r1.w, r3.x, c7.x, r0.x
mov_pp oC0, r1
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
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"agal_ps
c8 0.0 0.79627 0.20373 0.586426
c9 0.298828 0.114502 1.0 2.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
ciaaaaaaabaaapacaeaaaaoeaeaaaaaaacaaaaaaafbababb tex r1, v4, s2 <cube wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
adaaaaaaaaaaabacacaaaaffacaaaaaaaiaaaappabaaaaaa mul r0.x, r2.y, c8.w
adaaaaaaacaaaiacacaaaaaaacaaaaaaajaaaaoeabaaaaaa mul r2.w, r2.x, c9
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
adaaaaaaadaaabacacaaaakkacaaaaaaajaaaaffabaaaaaa mul r3.x, r2.z, c9.y
abaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r3.x, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
bfaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r2.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa add r1.xyz, r1.xyzz, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaagaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c6.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
acaaaaaaadaaahacabaaaakeacaaaaaaagaaaaaaabaaaaaa sub r3.xyz, r1.xyzz, c6.x
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaeaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r4.xyz, r0.x, v1
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
aaaaaaaaaaaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c6
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
acaaaaaaaaaaabacajaaaakkabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c9.z, r0.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
bcaaaaaaabaaabacaeaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r1.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r3.xyz, r3.xyzz, r0.x
bgaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r3.xyz, r3.xyzz
ahaaaaaaaaaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r1.x, c8
adaaaaaaabaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c3
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaajaaaakkabaaaaaa add r0.x, r0.x, c9.z
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaacaaapacaaaaaaaaacaaaaaaafaaaaaaabaaaaaa pow r2, r0.x, c5.x
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c2
abaaaaaaaaaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa add r0.xyz, r1.xyzz, c1
adaaaaaaabaaahacadaaaakeacaaaaaaahaaaaaaabaaaaaa mul r1.xyz, r3.xyzz, c7.x
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.x
adaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c0
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r0.x, r0.x, c8.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaakkabaaaaaa add r0.x, r0.x, c8.z
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaabaaabacacaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v2, r1.xyzz
adaaaaaaaeaaabacaaaaaappacaaaaaaabaaaappacaaaaaa mul r4.x, r0.w, r1.w
ahaaaaaaabaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r1.x, r1.x, c8
adaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r1.x, r1.x, r4.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.x, c4
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaajaaaappabaaaaaa mul r1.xyz, r1.xyzz, c9.w
adaaaaaaabaaaiacadaaaaaaacaaaaaaahaaaaaaabaaaaaa mul r1.w, r3.x, c7.x
abaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r1.w, r1.w, r0.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 37 ALU, 2 TEX
PARAM c[10] = { program.local[0..7],
		{ 0.20373, 0.79627001, 1, 0 },
		{ 0.29882813, 0.58642578, 0.11450195, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0.w, fragment.texcoord[4], texture[1], 2D;
DP3 R1.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MUL R1.y, R0, c[9];
MAD R1.y, R0.x, c[9].x, R1;
MAX R1.x, R1, c[8].w;
ADD_SAT R1.x, -R1, c[8].z;
POW R1.x, R1.x, c[5].x;
MAD R1.x, R1, c[8].y, c[8];
MAX R1.w, R1.x, c[8];
MAD_SAT R1.y, R0.z, c[9].z, R1;
ADD R1.xyz, R1.y, -R0;
MAD R1.xyz, R1, c[6].x, R0;
MOV R2.x, c[8].z;
ADD R2.x, R2, -c[6];
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
RCP R2.x, R2.x;
ADD R1.xyz, R1, -c[6].x;
MUL_SAT R1.xyz, R1, R2.x;
MUL_SAT R1.w, R1, c[4].x;
ADD R0.xyz, R0, c[1];
MAD R0.xyz, R1, c[7].x, R0;
MOV R2.xyz, fragment.texcoord[3];
DP3 R1.y, fragment.texcoord[2], R2;
MAX R1.y, R1, c[8].w;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.y, R0;
MUL R0.xyz, R0.w, R0;
MAD result.color.w, R1.x, c[7].x, R1;
MUL result.color.xyz, R0, c[9].w;
END
# 37 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 39 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c8, 0.00000000, 0.79627001, 0.20373000, 0.58642578
def c9, 0.29882813, 0.11450195, 1.00000000, 2.00000000
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r2, t0, s0
texld r0, t4, s1
mul_pp r0.x, r2.y, c8.w
mad_pp r0.x, r2, c9, r0
mad_pp_sat r0.x, r2.z, c9.y, r0
add_pp r1.xyz, -r2, r0.x
mad_pp r1.xyz, r1, c6.x, r2
add r3.xyz, r1, -c6.x
dp3 r0.x, t1, t1
rsq r0.x, r0.x
mul r4.xyz, r0.x, t1
dp3_pp r1.x, t2, t2
mov_pp r0.x, c6
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
add_pp r0.x, c9.z, -r0
rcp_pp r0.x, r0.x
mul_sat r3.xyz, r3, r0.x
dp3 r1.x, r4, r1
max r0.x, r1, c8
mul r1.xyz, r2, c3
mul r2.xyz, r1, c2
add_sat r0.x, -r0, c9.z
pow r1.w, r0.x, c5.x
add r0.xyz, r2, c1
mad_pp r2.xyz, r3, c7.x, r0
mov r0.x, r1.w
mul_pp r1.xyz, r2, c0
mad r0.x, r0, c8.y, c8.z
max r0.x, r0, c8
mov_pp r2.xyz, t3
dp3_pp r2.x, t2, r2
max_pp r2.x, r2, c8
mul_pp r2.x, r2, r0.w
mul_pp r1.xyz, r2.x, r1
mul_sat r0.x, r0, c4
mul_pp r1.xyz, r1, c9.w
mad_pp r1.w, r3.x, c7.x, r0.x
mov_pp oC0, r1
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
Float 4 [_AlphaPower]
Float 5 [_FresnelPower]
Float 6 [_threshold]
Float 7 [_thresholdInt]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c8 0.0 0.79627 0.20373 0.586426
c9 0.298828 0.114502 1.0 2.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
ciaaaaaaaaaaapacaeaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v4, s1 <2d wrap linear point>
adaaaaaaaaaaabacacaaaaffacaaaaaaaiaaaappabaaaaaa mul r0.x, r2.y, c8.w
adaaaaaaabaaabacacaaaaaaacaaaaaaajaaaaoeabaaaaaa mul r1.x, r2.x, c9
abaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r1.x, r0.x
adaaaaaaacaaaiacacaaaakkacaaaaaaajaaaaffabaaaaaa mul r2.w, r2.z, c9.y
abaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.w, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
bfaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r2.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa add r1.xyz, r1.xyzz, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaagaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c6.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
acaaaaaaadaaahacabaaaakeacaaaaaaagaaaaaaabaaaaaa sub r3.xyz, r1.xyzz, c6.x
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaeaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r4.xyz, r0.x, v1
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
aaaaaaaaaaaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c6
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
acaaaaaaaaaaabacajaaaakkabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c9.z, r0.x
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
adaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r3.xyz, r3.xyzz, r0.x
bgaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaaaaaaaaaaa sat r3.xyz, r3.xyzz
bcaaaaaaabaaabacaeaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r1.xyzz
ahaaaaaaaaaaabacabaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r1.x, c8
adaaaaaaabaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c3
adaaaaaaacaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c2
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaajaaaakkabaaaaaa add r0.x, r0.x, c9.z
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaafaaaaaaabaaaaaa pow r1, r0.x, c5.x
abaaaaaaaaaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa add r0.xyz, r2.xyzz, c1
adaaaaaaacaaahacadaaaakeacaaaaaaahaaaaaaabaaaaaa mul r2.xyz, r3.xyzz, c7.x
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c0
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r0.x, r0.x, c8.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaakkabaaaaaa add r0.x, r0.x, c8.z
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
aaaaaaaaacaaahacadaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r2.xyz, v3
bcaaaaaaacaaabacacaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r2.x, v2, r2.xyzz
ahaaaaaaacaaabacacaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r2.x, r2.x, c8
adaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaappacaaaaaa mul r2.x, r2.x, r0.w
adaaaaaaabaaahacacaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r2.x, r1.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.x, c4
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaajaaaappabaaaaaa mul r1.xyz, r1.xyzz, c9.w
adaaaaaaabaaaiacadaaaaaaacaaaaaaahaaaaaaabaaaaaa mul r1.w, r3.x, c7.x
abaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaacaaaaaa add r1.w, r1.w, r0.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

}
	}

#LINE 82


}
	
FallBack "Reflective/VertexLit"
} 

