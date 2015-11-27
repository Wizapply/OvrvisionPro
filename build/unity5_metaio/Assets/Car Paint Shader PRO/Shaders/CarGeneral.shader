Shader "RedDotGames/Car General" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
      _BumpMap ("Normalmap", 2D) = "bump" {}
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0.0
	  _FrezPow("Fresnel Power",Range(0,2)) = 0.0
	  _FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="False"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 35 to 100
//   d3d9 - ALU: 35 to 100
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_6).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_6).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_6).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_6).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_6).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_6).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_9 + tmpvar_8.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_4 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_3).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [_Color]
"3.0-!!ARBvp1.0
# 95 ALU
PARAM c[23] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
DP4 R1.z, vertex.position, c[7];
DP4 R1.y, vertex.position, c[6];
DP4 R1.x, vertex.position, c[5];
MOV R0.x, c[14].z;
MOV R0.z, c[16];
MOV R0.y, c[15].z;
ADD R0.xyz, -R1, R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
MUL R4.xyz, R1.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
MUL R0.w, R0, c[17].z;
ADD R0.xyz, R0, c[0].x;
ADD R0.w, R0, c[0].y;
MOV R2.x, c[14].y;
MOV R2.z, c[16].y;
MOV R2.y, c[15];
ADD R2.xyz, -R1, R2;
DP3 R1.w, R2, R2;
RSQ R2.w, R1.w;
MUL R3.xyz, R2.w, R2;
DP3 R2.w, R0, R0;
RSQ R2.w, R2.w;
MUL R0.xyz, R2.w, R0;
MOV result.texcoord[1].xyz, R0;
MOV R2.x, c[14];
MOV R2.z, c[16].x;
MOV R2.y, c[15].x;
ADD R2.xyz, -R1, R2;
DP3 R3.w, R2, R2;
RSQ R4.w, R3.w;
MUL R2.xyz, R4.w, R2;
DP3 R2.x, R0, R2;
DP3 R2.y, R0, R3;
MAX R2.w, R2.x, c[0].x;
MUL R2.x, R1.w, c[17].y;
MUL R1.w, R3, c[17].x;
ADD R2.x, R2, c[0].y;
RCP R2.x, R2.x;
MUL R3.xyz, R2.x, c[19];
ADD R1.w, R1, c[0].y;
MAX R4.w, R2.y, c[0].x;
RCP R1.w, R1.w;
MUL R2.xyz, R1.w, c[18];
MUL R3.xyz, R3, c[22];
MUL R3.xyz, R3, R4.w;
MUL R2.xyz, R2, c[22];
MAD R2.xyz, R2, R2.w, R3;
DP3 R1.w, R0, R4;
MAX R2.w, R1, c[0].x;
RCP R1.w, R0.w;
MOV R3.x, c[14].w;
MOV R3.z, c[16].w;
MOV R3.y, c[15].w;
ADD R4.xyz, -R1, R3;
MUL R3.xyz, R1.w, c[20];
DP3 R0.w, R4, R4;
RSQ R1.w, R0.w;
MUL R3.xyz, R3, c[22];
MAD R3.xyz, R3, R2.w, R2;
MUL R2.xyz, R1.w, R4;
MUL R0.w, R0, c[17];
ADD R1.w, R0, c[0].y;
DP3 R2.x, R0, R2;
MAX R0.w, R2.x, c[0].x;
MOV R2.xyz, vertex.attrib[14];
MOV R2.w, c[0].x;
DP4 R4.z, R2, c[7];
DP4 R4.x, R2, c[5];
DP4 R4.y, R2, c[6];
RCP R3.w, R1.w;
DP3 R1.w, R4, R4;
RSQ R1.w, R1.w;
MUL R2.xyz, R3.w, c[21];
MUL R2.xyz, R2, c[22];
MAD result.texcoord[2].xyz, R2, R0.w, R3;
ADD R2.xyz, R1, -c[13];
DP3 R0.w, R2, R2;
RSQ R0.x, R0.w;
MUL result.texcoord[6].xyz, R1.w, R4;
DP4 R1.w, vertex.position, c[8];
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[0], R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 95 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_4LightPosX0]
Vector 14 [unity_4LightPosY0]
Vector 15 [unity_4LightPosZ0]
Vector 16 [unity_4LightAtten0]
Vector 17 [unity_LightColor0]
Vector 18 [unity_LightColor1]
Vector 19 [unity_LightColor2]
Vector 20 [unity_LightColor3]
Vector 21 [_Color]
"vs_3_0
; 95 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c22, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mov r0.x, c13.z
mov r0.z, c15
mov r0.y, c14.z
add r0.xyz, -r1, r0
dp3 r0.w, r0, r0
rsq r1.w, r0.w
mul r4.xyz, r1.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
mul r0.w, r0, c16.z
add r0.xyz, r0, c22.x
add r0.w, r0, c22.y
mov r2.x, c13.y
mov r2.z, c15.y
mov r2.y, c14
add r2.xyz, -r1, r2
dp3 r1.w, r2, r2
rsq r2.w, r1.w
mul r3.xyz, r2.w, r2
dp3 r2.w, r0, r0
rsq r2.w, r2.w
mul r0.xyz, r2.w, r0
mov o2.xyz, r0
mov r2.x, c13
mov r2.z, c15.x
mov r2.y, c14.x
add r2.xyz, -r1, r2
dp3 r3.w, r2, r2
rsq r4.w, r3.w
mul r2.xyz, r4.w, r2
dp3 r2.x, r0, r2
dp3 r2.y, r0, r3
max r2.w, r2.x, c22.x
mul r2.x, r1.w, c16.y
mul r1.w, r3, c16.x
add r2.x, r2, c22.y
rcp r2.x, r2.x
mul r3.xyz, r2.x, c18
add r1.w, r1, c22.y
max r4.w, r2.y, c22.x
rcp r1.w, r1.w
mul r2.xyz, r1.w, c17
mul r3.xyz, r3, c21
mul r3.xyz, r3, r4.w
mul r2.xyz, r2, c21
mad r2.xyz, r2, r2.w, r3
dp3 r1.w, r0, r4
max r2.w, r1, c22.x
rcp r1.w, r0.w
mov r3.x, c13.w
mov r3.z, c15.w
mov r3.y, c14.w
add r4.xyz, -r1, r3
mul r3.xyz, r1.w, c19
dp3 r0.w, r4, r4
rsq r1.w, r0.w
mul r3.xyz, r3, c21
mad r3.xyz, r3, r2.w, r2
mul r2.xyz, r1.w, r4
mul r0.w, r0, c16
add r1.w, r0, c22.y
dp3 r2.x, r0, r2
max r0.w, r2.x, c22.x
mov r2.xyz, v3
mov r2.w, c22.x
dp4 r4.z, r2, c6
dp4 r4.x, r2, c4
dp4 r4.y, r2, c5
rcp r3.w, r1.w
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r2.xyz, r3.w, c20
mul r2.xyz, r2, c21
mad o3.xyz, r2, r0.w, r3
add r2.xyz, r1, -c12
dp3 r0.w, r2, r2
rsq r0.x, r0.w
mul o7.xyz, r1.w, r4
dp4 r1.w, v0, c7
mul o5.xyz, r0.x, r2
mov r0.w, c22.x
mov r0.xyz, v1
mov o1, r1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((tmpvar_6 * _World2Object).xyz);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_2.xyz;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.x = unity_4LightPosX0.x;
  tmpvar_10.y = unity_4LightPosY0.x;
  tmpvar_10.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - tmpvar_4).xyz;
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_11))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.y;
  tmpvar_12.y = unity_4LightPosY0.y;
  tmpvar_12.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_13)))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.z;
  tmpvar_14.y = unity_4LightPosY0.z;
  tmpvar_14.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.w;
  tmpvar_16.y = unity_4LightPosY0.w;
  tmpvar_16.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_17)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = tmpvar_7;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_8).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_5).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_9).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((tmpvar_6 * _World2Object).xyz);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_2.xyz;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.x = unity_4LightPosX0.x;
  tmpvar_10.y = unity_4LightPosY0.x;
  tmpvar_10.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - tmpvar_4).xyz;
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_11))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.y;
  tmpvar_12.y = unity_4LightPosY0.y;
  tmpvar_12.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_13)))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.z;
  tmpvar_14.y = unity_4LightPosY0.z;
  tmpvar_14.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.w;
  tmpvar_16.y = unity_4LightPosY0.w;
  tmpvar_16.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_17)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = tmpvar_7;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_8).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_5).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_9).xyz);
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_18;
  lowp float tmpvar_19;
  tmpvar_19 = (frez * _FrezPow);
  frez = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_16.xyz * ((_Reflection + tmpvar_19) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = ((textureColor.xyz * clamp ((tmpvar_11 + tmpvar_12), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_21;
  color = ((color + reflTex) + (tmpvar_19 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
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
Vector 23 [_Color]
"3.0-!!ARBvp1.0
# 100 ALU
PARAM c[24] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R0;
MAD R2.xyz, vertex.normal.z, c[11], R2;
ADD R2.xyz, R2, c[0].x;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.x, c[15];
MOV R1.z, c[17].x;
MOV R1.y, c[16].x;
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R2.w, R1.w;
MUL R1.xyz, R2.w, R1;
DP3 R0.w, R2, R1;
MUL R1.w, R1, c[18].x;
MAX R0.w, R0, c[0].x;
ADD R1.w, R1, c[0].y;
MOV R3.x, c[15].y;
MOV R3.z, c[17].y;
MOV R3.y, c[16];
ADD R3.xyz, -R0, R3;
DP3 R1.x, R3, R3;
MUL R2.w, R1.x, c[18].y;
RSQ R1.y, R1.x;
MUL R1.xyz, R1.y, R3;
DP3 R1.y, R2, R1;
ADD R2.w, R2, c[0].y;
RCP R1.x, R2.w;
MAX R2.w, R1.y, c[0].x;
MUL R1.xyz, R1.x, c[20];
MUL R1.xyz, R1, c[23];
MUL R3.xyz, R1, R2.w;
MOV R1.x, c[15].z;
MOV R1.z, c[17];
MOV R1.y, c[16].z;
ADD R4.xyz, -R0, R1;
RCP R1.x, R1.w;
DP3 R1.w, R4, R4;
MUL R1.xyz, R1.x, c[19];
MUL R1.xyz, R1, c[23];
MAD R3.xyz, R1, R0.w, R3;
RSQ R2.w, R1.w;
MUL R1.xyz, R2.w, R4;
DP3 R1.x, R2, R1;
MUL R0.w, R1, c[18].z;
MAX R1.w, R1.x, c[0].x;
ADD R0.w, R0, c[0].y;
RCP R0.w, R0.w;
MUL R4.xyz, R0.w, c[21];
MUL R4.xyz, R4, c[23];
MAD R4.xyz, R4, R1.w, R3;
MOV R1.x, c[15].w;
MOV R1.z, c[17].w;
MOV R1.y, c[16].w;
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R1.xyz, R1.w, R1;
MUL R0.w, R0, c[18];
MOV R1.w, c[0].x;
DP3 R1.y, R2, R1;
ADD R0.w, R0, c[0].y;
RCP R1.x, R0.w;
MAX R0.w, R1.y, c[0].x;
MUL R3.xyz, R1.x, c[22];
MOV R1.xyz, vertex.attrib[14];
DP4 R5.z, R1, c[7];
DP4 R5.x, R1, c[5];
DP4 R5.y, R1, c[6];
MUL R1.xyz, R3, c[23];
MAD result.texcoord[2].xyz, R1, R0.w, R4;
DP3 R1.w, R5, R5;
RSQ R0.w, R1.w;
MUL result.texcoord[6].xyz, R0.w, R5;
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MOV R0.w, c[0].x;
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R3.xyz, R1.xyww, c[0].z;
MUL R3.y, R3, c[13].x;
ADD result.texcoord[7].xy, R3, R3.z;
ADD R3.xyz, R0, -c[14];
DP3 R0.x, R3, R3;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R3;
MOV R0.xyz, vertex.normal;
MOV result.position, R1;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
END
# 100 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
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
Vector 23 [_Color]
"vs_3_0
; 100 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c24, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r0
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c24.x
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c15
mov r1.z, c17.x
mov r1.y, c16.x
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r2.w, r1.w
mul r1.xyz, r2.w, r1
dp3 r0.w, r2, r1
mul r1.w, r1, c18.x
max r0.w, r0, c24.x
add r1.w, r1, c24.y
mov r3.x, c15.y
mov r3.z, c17.y
mov r3.y, c16
add r3.xyz, -r0, r3
dp3 r1.x, r3, r3
mul r2.w, r1.x, c18.y
rsq r1.y, r1.x
mul r1.xyz, r1.y, r3
dp3 r1.y, r2, r1
add r2.w, r2, c24.y
rcp r1.x, r2.w
max r2.w, r1.y, c24.x
mul r1.xyz, r1.x, c20
mul r1.xyz, r1, c23
mul r3.xyz, r1, r2.w
mov r1.x, c15.z
mov r1.z, c17
mov r1.y, c16.z
add r4.xyz, -r0, r1
rcp r1.x, r1.w
dp3 r1.w, r4, r4
mul r1.xyz, r1.x, c19
mul r1.xyz, r1, c23
mad r3.xyz, r1, r0.w, r3
rsq r2.w, r1.w
mul r1.xyz, r2.w, r4
dp3 r1.x, r2, r1
mul r0.w, r1, c18.z
max r1.w, r1.x, c24.x
add r0.w, r0, c24.y
rcp r0.w, r0.w
mul r4.xyz, r0.w, c21
mul r4.xyz, r4, c23
mad r4.xyz, r4, r1.w, r3
mov r1.x, c15.w
mov r1.z, c17.w
mov r1.y, c16.w
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r1.xyz, r1.w, r1
mul r0.w, r0, c18
mov r1.w, c24.x
dp3 r1.y, r2, r1
add r0.w, r0, c24.y
rcp r1.x, r0.w
max r0.w, r1.y, c24.x
mul r3.xyz, r1.x, c22
mov r1.xyz, v3
dp4 r5.z, r1, c6
dp4 r5.x, r1, c4
dp4 r5.y, r1, c5
mul r1.xyz, r3, c23
mad o3.xyz, r1, r0.w, r4
dp3 r1.w, r5, r5
rsq r0.w, r1.w
mul o7.xyz, r0.w, r5
dp4 r0.w, v0, c7
mov o1, r0
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mov r0.w, c24.x
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c24.z
mul r3.y, r3, c12.x
mad o8.xy, r3.z, c13.zwzw, r3
add r3.xyz, r0, -c14
dp3 r0.x, r3, r3
rsq r0.x, r0.x
mul o5.xyz, r0.x, r3
mov r0.xyz, v1
mov o0, r1
mov o2.xyz, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((tmpvar_6 * _World2Object).xyz);
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_2.xyz;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.x = unity_4LightPosX0.x;
  tmpvar_11.y = unity_4LightPosY0.x;
  tmpvar_11.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - tmpvar_4).xyz;
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_18, tmpvar_18))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_18)))));
  highp vec4 o_i0;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_19;
  highp vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_20 + tmpvar_19.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = tmpvar_7;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_5).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_10).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((tmpvar_6 * _World2Object).xyz);
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_2.xyz;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.x = unity_4LightPosX0.x;
  tmpvar_11.y = unity_4LightPosY0.x;
  tmpvar_11.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 - tmpvar_4).xyz;
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_18, tmpvar_18))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_18)))));
  highp vec4 o_i0;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_8 * 0.5);
  o_i0 = tmpvar_19;
  highp vec2 tmpvar_20;
  tmpvar_20.x = tmpvar_19.x;
  tmpvar_20.y = (tmpvar_19.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_20 + tmpvar_19.w);
  o_i0.zw = tmpvar_8.zw;
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = tmpvar_7;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_5).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_10).xyz);
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD6;
  tmpvar_4[1] = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  tmpvar_4[2] = xlv_TEXCOORD5;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((localCoords * tmpvar_5));
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_MainTex, tmpvar_8);
  textureColor = tmpvar_9;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_10;
    tmpvar_10 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_10;
  } else {
    highp vec3 tmpvar_11;
    tmpvar_11 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_11)));
    lightDirection = normalize (tmpvar_11);
  };
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_15;
  tmpvar_15 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_15 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec3 tmpvar_16;
  tmpvar_16 = (specularReflection * _Gloss);
  specularReflection = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = reflect (xlv_TEXCOORD4, tmpvar_6);
  reflectedDir = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (abs (dot (reflectedDir, normalize (tmpvar_6))), 0.0, 1.0);
  SurfAngle = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = (frez * _FrezPow);
  frez = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_18.xyz * ((_Reflection + tmpvar_21) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((textureColor.xyz * clamp ((tmpvar_13 + tmpvar_14), 0.0, 1.0)) + tmpvar_16);
  color = tmpvar_23;
  color = ((color + reflTex) + (tmpvar_21 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 84 to 85, TEX: 3 to 4
//   d3d9 - ALU: 82 to 83, TEX: 3 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 84 ALU, 3 TEX
PARAM c[14] = { state.lightmodel.ambient,
		program.local[1..11],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[12].x, -c[12].y;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MUL R2.xyz, R1.y, R2;
MOV R1.z, c[12];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[12].y;
RSQ R1.y, R1.z;
MAD R2.xyz, R1.x, fragment.texcoord[6], R2;
RCP R1.x, R1.y;
MAD R2.xyz, R1.x, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R2, R2;
DP3 R2.w, R1, R1;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
RSQ R2.w, R2.w;
MUL R1.xyz, R2.w, R1;
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[12].z, c[12].y;
ABS R1.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[12].z, c[12].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R2, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R2, -R1.w;
SLT R2.w, R1, c[12].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[12].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.x, R1, R4;
MAX R3.x, R1, c[12].z;
MOV R1.xyz, c[6];
POW R3.x, R3.x, c[7].x;
MUL R1.xyz, R1, c[11];
MUL R1.xyz, R1, R3.x;
CMP R2.w, -R2, c[12].z, c[12].y;
CMP R4.xyz, -R2.w, R1, c[12].z;
MOV R1.xyz, c[4];
MAX R1.w, R1, c[12].z;
MUL R3.xyz, R1, c[11];
MUL R3.xyz, R3, R1.w;
MAD_SAT R3.xyz, R1, c[0], R3;
DP3 R1.w, R2, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R4.xyz, R4, c[8].x;
MAD R3.xyz, R1, R3, R4;
DP3 R1.x, R2, fragment.texcoord[4];
MUL R1.xyz, R2, R1.x;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xyz, -R1, c[12].x, fragment.texcoord[4];
MUL R4.xyz, R1.w, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[4];
DP3 R0.y, R0, R4;
DP3 R0.x, R1, R2;
MAX R0.y, R0, c[12].z;
ABS_SAT R0.x, R0;
ADD_SAT R0.y, -R0, c[12];
ADD R0.x, -R0, c[12].y;
POW R0.x, R0.x, c[10].x;
MUL R0.w, R0.x, c[9].x;
MUL R0.y, R0, c[12].w;
ADD R0.y, R0, c[13].x;
MAX R0.y, R0, c[12].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R1, texture[2], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R3;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 84 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 83 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c12, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c13, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r3.xy, r0.wyzw, c12.x, c12.y
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r3.y, r1
mov r3.z, c12
dp3 r1.w, r3, r3
add r1.w, -r1, c12
mad r2.xyz, r3.x, v5, r1
rsq r1.w, r1.w
rcp r1.x, r1.w
mad r1.xyz, r1.x, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
add r4.xyz, -v0, c1
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r1.w, r1, r2
mul r3.xyz, r1, -r1.w
dp3 r2.w, r4, r4
rsq r2.w, r2.w
mad r2.xyz, -r3, c12.x, -r2
mul r4.xyz, r2.w, r4
dp3 r2.x, r2, r4
max r4.x, r2, c12.z
dp3 r2.y, r1, r1
rsq r2.w, r2.y
dp3 r2.x, r1, v3
mul r3.xyz, r2.w, r1
mul r2.xyz, r1, r2.x
mad r1.xyz, -r2, c12.x, v3
pow r2, r4.x, c7.x
cmp r2.w, r1, c12.z, c12
dp3_pp r3.w, r1, r3
mov r4.x, r2
mov r3.xyz, c11
mul r2.xyz, c6, r3
mul r2.xyz, r2, r4.x
abs_pp r2.w, r2
cmp r2.xyz, -r2.w, r2, c12.z
mul r4.xyz, r2, c8.x
mov r2.xyz, c11
abs_pp_sat r2.w, r3
max r1.w, r1, c12.z
mul r2.xyz, c4, r2
mul r3.xyz, r2, r1.w
add_pp r1.w, -r2, c12
dp4 r2.w, r0, r0
mov r2.xyz, c0
mad_sat r3.xyz, c4, r2, r3
texld r2.xyz, v2, s1
dp3 r0.w, v3, v3
mad r2.xyz, r2, r3, r4
rsq r2.w, r2.w
mul r3.xyz, r2.w, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, v3
dp3 r2.w, r0, r3
pow_pp r0, r1.w, c10.x
max r0.y, r2.w, c12.z
mul_pp r0.w, r0.x, c9.x
add_sat r0.y, -r0, c12.w
mad r0.y, r0, c13.x, c13
max r0.y, r0, c12.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s2
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
mov_pp oC0.w, c4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 84 ALU, 3 TEX
PARAM c[14] = { state.lightmodel.ambient,
		program.local[1..11],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[12].x, -c[12].y;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MUL R2.xyz, R1.y, R2;
MOV R1.z, c[12];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[12].y;
RSQ R1.y, R1.z;
MAD R2.xyz, R1.x, fragment.texcoord[6], R2;
RCP R1.x, R1.y;
MAD R2.xyz, R1.x, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R2, R2;
DP3 R2.w, R1, R1;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
RSQ R2.w, R2.w;
MUL R1.xyz, R2.w, R1;
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[12].z, c[12].y;
ABS R1.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[12].z, c[12].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R2, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R2, -R1.w;
SLT R2.w, R1, c[12].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[12].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.x, R1, R4;
MAX R3.x, R1, c[12].z;
MOV R1.xyz, c[6];
POW R3.x, R3.x, c[7].x;
MUL R1.xyz, R1, c[11];
MUL R1.xyz, R1, R3.x;
CMP R2.w, -R2, c[12].z, c[12].y;
CMP R4.xyz, -R2.w, R1, c[12].z;
MOV R1.xyz, c[4];
MAX R1.w, R1, c[12].z;
MUL R3.xyz, R1, c[11];
MUL R3.xyz, R3, R1.w;
MAD_SAT R3.xyz, R1, c[0], R3;
DP3 R1.w, R2, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R4.xyz, R4, c[8].x;
MAD R3.xyz, R1, R3, R4;
DP3 R1.x, R2, fragment.texcoord[4];
MUL R1.xyz, R2, R1.x;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xyz, -R1, c[12].x, fragment.texcoord[4];
MUL R4.xyz, R1.w, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[4];
DP3 R0.y, R0, R4;
DP3 R0.x, R1, R2;
MAX R0.y, R0, c[12].z;
ABS_SAT R0.x, R0;
ADD_SAT R0.y, -R0, c[12];
ADD R0.x, -R0, c[12].y;
POW R0.x, R0.x, c[10].x;
MUL R0.w, R0.x, c[9].x;
MUL R0.y, R0, c[12].w;
ADD R0.y, R0, c[13].x;
MAX R0.y, R0, c[12].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R1, texture[2], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R3;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 84 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 83 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c12, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c13, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r3.xy, r0.wyzw, c12.x, c12.y
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r3.y, r1
mov r3.z, c12
dp3 r1.w, r3, r3
add r1.w, -r1, c12
mad r2.xyz, r3.x, v5, r1
rsq r1.w, r1.w
rcp r1.x, r1.w
mad r1.xyz, r1.x, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
add r4.xyz, -v0, c1
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r1.w, r1, r2
mul r3.xyz, r1, -r1.w
dp3 r2.w, r4, r4
rsq r2.w, r2.w
mad r2.xyz, -r3, c12.x, -r2
mul r4.xyz, r2.w, r4
dp3 r2.x, r2, r4
max r4.x, r2, c12.z
dp3 r2.y, r1, r1
rsq r2.w, r2.y
dp3 r2.x, r1, v3
mul r3.xyz, r2.w, r1
mul r2.xyz, r1, r2.x
mad r1.xyz, -r2, c12.x, v3
pow r2, r4.x, c7.x
cmp r2.w, r1, c12.z, c12
dp3_pp r3.w, r1, r3
mov r4.x, r2
mov r3.xyz, c11
mul r2.xyz, c6, r3
mul r2.xyz, r2, r4.x
abs_pp r2.w, r2
cmp r2.xyz, -r2.w, r2, c12.z
mul r4.xyz, r2, c8.x
mov r2.xyz, c11
abs_pp_sat r2.w, r3
max r1.w, r1, c12.z
mul r2.xyz, c4, r2
mul r3.xyz, r2, r1.w
add_pp r1.w, -r2, c12
dp4 r2.w, r0, r0
mov r2.xyz, c0
mad_sat r3.xyz, c4, r2, r3
texld r2.xyz, v2, s1
dp3 r0.w, v3, v3
mad r2.xyz, r2, r3, r4
rsq r2.w, r2.w
mul r3.xyz, r2.w, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, v3
dp3 r2.w, r0, r3
pow_pp r0, r1.w, c10.x
max r0.y, r2.w, c12.z
mul_pp r0.w, r0.x, c9.x
add_sat r0.y, -r0, c12.w
mad r0.y, r0, c13.x, c13
max r0.y, r0, c12.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s2
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
mov_pp oC0.w, c4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 84 ALU, 3 TEX
PARAM c[14] = { state.lightmodel.ambient,
		program.local[1..11],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[12].x, -c[12].y;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MUL R2.xyz, R1.y, R2;
MOV R1.z, c[12];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[12].y;
RSQ R1.y, R1.z;
MAD R2.xyz, R1.x, fragment.texcoord[6], R2;
RCP R1.x, R1.y;
MAD R2.xyz, R1.x, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R2, R2;
DP3 R2.w, R1, R1;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
RSQ R2.w, R2.w;
MUL R1.xyz, R2.w, R1;
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[12].z, c[12].y;
ABS R1.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[12].z, c[12].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R2, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R2, -R1.w;
SLT R2.w, R1, c[12].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[12].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.x, R1, R4;
MAX R3.x, R1, c[12].z;
MOV R1.xyz, c[6];
POW R3.x, R3.x, c[7].x;
MUL R1.xyz, R1, c[11];
MUL R1.xyz, R1, R3.x;
CMP R2.w, -R2, c[12].z, c[12].y;
CMP R4.xyz, -R2.w, R1, c[12].z;
MOV R1.xyz, c[4];
MAX R1.w, R1, c[12].z;
MUL R3.xyz, R1, c[11];
MUL R3.xyz, R3, R1.w;
MAD_SAT R3.xyz, R1, c[0], R3;
DP3 R1.w, R2, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R4.xyz, R4, c[8].x;
MAD R3.xyz, R1, R3, R4;
DP3 R1.x, R2, fragment.texcoord[4];
MUL R1.xyz, R2, R1.x;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xyz, -R1, c[12].x, fragment.texcoord[4];
MUL R4.xyz, R1.w, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[4];
DP3 R0.y, R0, R4;
DP3 R0.x, R1, R2;
MAX R0.y, R0, c[12].z;
ABS_SAT R0.x, R0;
ADD_SAT R0.y, -R0, c[12];
ADD R0.x, -R0, c[12].y;
POW R0.x, R0.x, c[10].x;
MUL R0.w, R0.x, c[9].x;
MUL R0.y, R0, c[12].w;
ADD R0.y, R0, c[13].x;
MAX R0.y, R0, c[12].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R1, texture[2], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R3;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 84 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 83 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c12, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c13, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r3.xy, r0.wyzw, c12.x, c12.y
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r3.y, r1
mov r3.z, c12
dp3 r1.w, r3, r3
add r1.w, -r1, c12
mad r2.xyz, r3.x, v5, r1
rsq r1.w, r1.w
rcp r1.x, r1.w
mad r1.xyz, r1.x, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
add r4.xyz, -v0, c1
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r1.w, r1, r2
mul r3.xyz, r1, -r1.w
dp3 r2.w, r4, r4
rsq r2.w, r2.w
mad r2.xyz, -r3, c12.x, -r2
mul r4.xyz, r2.w, r4
dp3 r2.x, r2, r4
max r4.x, r2, c12.z
dp3 r2.y, r1, r1
rsq r2.w, r2.y
dp3 r2.x, r1, v3
mul r3.xyz, r2.w, r1
mul r2.xyz, r1, r2.x
mad r1.xyz, -r2, c12.x, v3
pow r2, r4.x, c7.x
cmp r2.w, r1, c12.z, c12
dp3_pp r3.w, r1, r3
mov r4.x, r2
mov r3.xyz, c11
mul r2.xyz, c6, r3
mul r2.xyz, r2, r4.x
abs_pp r2.w, r2
cmp r2.xyz, -r2.w, r2, c12.z
mul r4.xyz, r2, c8.x
mov r2.xyz, c11
abs_pp_sat r2.w, r3
max r1.w, r1, c12.z
mul r2.xyz, c4, r2
mul r3.xyz, r2, r1.w
add_pp r1.w, -r2, c12
dp4 r2.w, r0, r0
mov r2.xyz, c0
mad_sat r3.xyz, c4, r2, r3
texld r2.xyz, v2, s1
dp3 r0.w, v3, v3
mad r2.xyz, r2, r3, r4
rsq r2.w, r2.w
mul r3.xyz, r2.w, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, v3
dp3 r2.w, r0, r3
pow_pp r0, r1.w, c10.x
max r0.y, r2.w, c12.z
mul_pp r0.w, r0.x, c9.x
add_sat r0.y, -r0, c12.w
mad r0.y, r0, c13.x, c13
max r0.y, r0, c12.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s2
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
mov_pp oC0.w, c4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 85 ALU, 4 TEX
PARAM c[14] = { state.lightmodel.ambient,
		program.local[1..11],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[12].x, -c[12].y;
MUL R2.xyz, R1.y, R2;
MOV R1.z, c[12];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[12].y;
RSQ R1.y, R1.z;
DP3 R3.x, c[2], c[2];
RSQ R3.x, R3.x;
MUL R3.xyz, R3.x, c[2];
RCP R1.w, R1.y;
MAD R2.xyz, R1.x, fragment.texcoord[6], R2;
MAD R2.xyz, R1.w, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R1, R1;
DP3 R1.w, R2, R2;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R1.xyz, R2.w, R1;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[12].z, c[12].y;
ABS R2.w, R2;
CMP R2.w, -R2, c[12].z, c[12].y;
MUL R2.xyz, R1.w, R2;
CMP R1.xyz, -R2.w, R1, R3;
DP3 R1.w, R2, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R2, -R1.w;
SLT R2.w, R1, c[12].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[12].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.y, R1, R4;
MAX R3.x, R1.y, c[12].z;
TXP R1.x, fragment.texcoord[7], texture[2], 2D;
MUL R1.xyz, R1.x, c[11];
POW R3.w, R3.x, c[7].x;
MUL R3.xyz, R1, c[6];
MAX R1.w, R1, c[12].z;
MUL R1.xyz, R1, c[4];
MUL R3.xyz, R3, R3.w;
CMP R2.w, -R2, c[12].z, c[12].y;
CMP R3.xyz, -R2.w, R3, c[12].z;
MUL R4.xyz, R3, c[8].x;
MUL R3.xyz, R1, R1.w;
MOV R1.xyz, c[4];
MAD_SAT R3.xyz, R1, c[0], R3;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R3.xyz, R1, R3, R4;
DP3 R1.x, R2, fragment.texcoord[4];
DP3 R1.w, R2, R2;
MUL R1.xyz, R2, R1.x;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xyz, -R1, c[12].x, fragment.texcoord[4];
MUL R4.xyz, R1.w, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[4];
DP3 R0.y, R0, R4;
DP3 R0.x, R1, R2;
MAX R0.y, R0, c[12].z;
ABS_SAT R0.x, R0;
ADD_SAT R0.y, -R0, c[12];
ADD R0.x, -R0, c[12].y;
POW R0.x, R0.x, c[10].x;
MUL R0.w, R0.x, c[9].x;
MUL R0.y, R0, c[12].w;
ADD R0.y, R0, c[13].x;
MAX R0.y, R0, c[12].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R1, texture[3], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R3;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 85 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 82 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c12, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c13, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r3.xy, r0.wyzw, c12.x, c12.y
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r3.y, r1
mov r3.z, c12
dp3 r1.w, r3, r3
add r1.w, -r1, c12
mad r2.xyz, r3.x, v5, r1
rsq r1.w, r1.w
rcp r1.x, r1.w
mad r1.xyz, r1.x, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
add r4.xyz, -v0, c1
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r1.w, r1, r2
mul r3.xyz, r1, -r1.w
dp3 r2.w, r4, r4
rsq r2.w, r2.w
mad r2.xyz, -r3, c12.x, -r2
mul r4.xyz, r2.w, r4
dp3 r2.w, r2, r4
dp3 r2.y, r1, r1
cmp r4.x, r1.w, c12.z, c12.w
rsq r3.x, r2.y
dp3 r2.x, r1, v3
mul r3.xyz, r3.x, r1
mul r2.xyz, r1, r2.x
mad r1.xyz, -r2, c12.x, v3
dp3_pp r3.w, r1, r3
max r3.x, r2.w, c12.z
pow r2, r3.x, c7.x
texldp r3.x, v6, s2
mul r3.xyz, r3.x, c11
mov r2.w, r2.x
mul r2.xyz, r3, c6
mul r2.xyz, r2, r2.w
abs_pp r2.w, r4.x
cmp r2.xyz, -r2.w, r2, c12.z
mul r4.xyz, r2, c8.x
mul r2.xyz, r3, c4
max r1.w, r1, c12.z
mul r3.xyz, r2, r1.w
abs_pp_sat r2.w, r3
add_pp r1.w, -r2, c12
dp4 r2.w, r0, r0
mov r2.xyz, c0
mad_sat r3.xyz, c4, r2, r3
texld r2.xyz, v2, s1
dp3 r0.w, v3, v3
mad r2.xyz, r2, r3, r4
rsq r2.w, r2.w
mul r3.xyz, r2.w, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, v3
dp3 r2.w, r0, r3
pow_pp r0, r1.w, c10.x
max r0.y, r2.w, c12.z
mul_pp r0.w, r0.x, c9.x
add_sat r0.y, -r0, c12.w
mad r0.y, r0, c13.x, c13
max r0.y, r0, c12.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s3
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
mov_pp oC0.w, c4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 85 ALU, 4 TEX
PARAM c[14] = { state.lightmodel.ambient,
		program.local[1..11],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[12].x, -c[12].y;
MUL R2.xyz, R1.y, R2;
MOV R1.z, c[12];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[12].y;
RSQ R1.y, R1.z;
DP3 R3.x, c[2], c[2];
RSQ R3.x, R3.x;
MUL R3.xyz, R3.x, c[2];
RCP R1.w, R1.y;
MAD R2.xyz, R1.x, fragment.texcoord[6], R2;
MAD R2.xyz, R1.w, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R1, R1;
DP3 R1.w, R2, R2;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R1.xyz, R2.w, R1;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[12].z, c[12].y;
ABS R2.w, R2;
CMP R2.w, -R2, c[12].z, c[12].y;
MUL R2.xyz, R1.w, R2;
CMP R1.xyz, -R2.w, R1, R3;
DP3 R1.w, R2, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R2, -R1.w;
SLT R2.w, R1, c[12].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[12].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.y, R1, R4;
MAX R3.x, R1.y, c[12].z;
TXP R1.x, fragment.texcoord[7], texture[2], 2D;
MUL R1.xyz, R1.x, c[11];
POW R3.w, R3.x, c[7].x;
MUL R3.xyz, R1, c[6];
MAX R1.w, R1, c[12].z;
MUL R1.xyz, R1, c[4];
MUL R3.xyz, R3, R3.w;
CMP R2.w, -R2, c[12].z, c[12].y;
CMP R3.xyz, -R2.w, R3, c[12].z;
MUL R4.xyz, R3, c[8].x;
MUL R3.xyz, R1, R1.w;
MOV R1.xyz, c[4];
MAD_SAT R3.xyz, R1, c[0], R3;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R3.xyz, R1, R3, R4;
DP3 R1.x, R2, fragment.texcoord[4];
DP3 R1.w, R2, R2;
MUL R1.xyz, R2, R1.x;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xyz, -R1, c[12].x, fragment.texcoord[4];
MUL R4.xyz, R1.w, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[4];
DP3 R0.y, R0, R4;
DP3 R0.x, R1, R2;
MAX R0.y, R0, c[12].z;
ABS_SAT R0.x, R0;
ADD_SAT R0.y, -R0, c[12];
ADD R0.x, -R0, c[12].y;
POW R0.x, R0.x, c[10].x;
MUL R0.w, R0.x, c[9].x;
MUL R0.y, R0, c[12].w;
ADD R0.y, R0, c[13].x;
MAX R0.y, R0, c[12].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R1, texture[3], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R3;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 85 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 82 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c12, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c13, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r3.xy, r0.wyzw, c12.x, c12.y
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r3.y, r1
mov r3.z, c12
dp3 r1.w, r3, r3
add r1.w, -r1, c12
mad r2.xyz, r3.x, v5, r1
rsq r1.w, r1.w
rcp r1.x, r1.w
mad r1.xyz, r1.x, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
add r4.xyz, -v0, c1
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r1.w, r1, r2
mul r3.xyz, r1, -r1.w
dp3 r2.w, r4, r4
rsq r2.w, r2.w
mad r2.xyz, -r3, c12.x, -r2
mul r4.xyz, r2.w, r4
dp3 r2.w, r2, r4
dp3 r2.y, r1, r1
cmp r4.x, r1.w, c12.z, c12.w
rsq r3.x, r2.y
dp3 r2.x, r1, v3
mul r3.xyz, r3.x, r1
mul r2.xyz, r1, r2.x
mad r1.xyz, -r2, c12.x, v3
dp3_pp r3.w, r1, r3
max r3.x, r2.w, c12.z
pow r2, r3.x, c7.x
texldp r3.x, v6, s2
mul r3.xyz, r3.x, c11
mov r2.w, r2.x
mul r2.xyz, r3, c6
mul r2.xyz, r2, r2.w
abs_pp r2.w, r4.x
cmp r2.xyz, -r2.w, r2, c12.z
mul r4.xyz, r2, c8.x
mul r2.xyz, r3, c4
max r1.w, r1, c12.z
mul r3.xyz, r2, r1.w
abs_pp_sat r2.w, r3
add_pp r1.w, -r2, c12
dp4 r2.w, r0, r0
mov r2.xyz, c0
mad_sat r3.xyz, c4, r2, r3
texld r2.xyz, v2, s1
dp3 r0.w, v3, v3
mad r2.xyz, r2, r3, r4
rsq r2.w, r2.w
mul r3.xyz, r2.w, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, v3
dp3 r2.w, r0, r3
pow_pp r0, r1.w, c10.x
max r0.y, r2.w, c12.z
mul_pp r0.w, r0.x, c9.x
add_sat r0.y, -r0, c12.w
mad r0.y, r0, c13.x, c13
max r0.y, r0, c12.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s3
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
mov_pp oC0.w, c4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 85 ALU, 4 TEX
PARAM c[14] = { state.lightmodel.ambient,
		program.local[1..11],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[12].x, -c[12].y;
MUL R2.xyz, R1.y, R2;
MOV R1.z, c[12];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[12].y;
RSQ R1.y, R1.z;
DP3 R3.x, c[2], c[2];
RSQ R3.x, R3.x;
MUL R3.xyz, R3.x, c[2];
RCP R1.w, R1.y;
MAD R2.xyz, R1.x, fragment.texcoord[6], R2;
MAD R2.xyz, R1.w, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R1, R1;
DP3 R1.w, R2, R2;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R1.xyz, R2.w, R1;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[12].z, c[12].y;
ABS R2.w, R2;
CMP R2.w, -R2, c[12].z, c[12].y;
MUL R2.xyz, R1.w, R2;
CMP R1.xyz, -R2.w, R1, R3;
DP3 R1.w, R2, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R2, -R1.w;
SLT R2.w, R1, c[12].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[12].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.y, R1, R4;
MAX R3.x, R1.y, c[12].z;
TXP R1.x, fragment.texcoord[7], texture[2], 2D;
MUL R1.xyz, R1.x, c[11];
POW R3.w, R3.x, c[7].x;
MUL R3.xyz, R1, c[6];
MAX R1.w, R1, c[12].z;
MUL R1.xyz, R1, c[4];
MUL R3.xyz, R3, R3.w;
CMP R2.w, -R2, c[12].z, c[12].y;
CMP R3.xyz, -R2.w, R3, c[12].z;
MUL R4.xyz, R3, c[8].x;
MUL R3.xyz, R1, R1.w;
MOV R1.xyz, c[4];
MAD_SAT R3.xyz, R1, c[0], R3;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R3.xyz, R1, R3, R4;
DP3 R1.x, R2, fragment.texcoord[4];
DP3 R1.w, R2, R2;
MUL R1.xyz, R2, R1.x;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xyz, -R1, c[12].x, fragment.texcoord[4];
MUL R4.xyz, R1.w, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[4];
DP3 R0.y, R0, R4;
DP3 R0.x, R1, R2;
MAX R0.y, R0, c[12].z;
ABS_SAT R0.x, R0;
ADD_SAT R0.y, -R0, c[12];
ADD R0.x, -R0, c[12].y;
POW R0.x, R0.x, c[10].x;
MUL R0.w, R0.x, c[9].x;
MUL R0.y, R0, c[12].w;
ADD R0.y, R0, c[13].x;
MAX R0.y, R0, c[12].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R1, texture[3], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R3;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 85 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FrezPow]
Float 10 [_FrezFalloff]
Vector 11 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 82 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c12, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c13, 0.79627001, 0.20373000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r3.xy, r0.wyzw, c12.x, c12.y
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r3.y, r1
mov r3.z, c12
dp3 r1.w, r3, r3
add r1.w, -r1, c12
mad r2.xyz, r3.x, v5, r1
rsq r1.w, r1.w
rcp r1.x, r1.w
mad r1.xyz, r1.x, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
add r4.xyz, -v0, c1
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r1.w, r1, r2
mul r3.xyz, r1, -r1.w
dp3 r2.w, r4, r4
rsq r2.w, r2.w
mad r2.xyz, -r3, c12.x, -r2
mul r4.xyz, r2.w, r4
dp3 r2.w, r2, r4
dp3 r2.y, r1, r1
cmp r4.x, r1.w, c12.z, c12.w
rsq r3.x, r2.y
dp3 r2.x, r1, v3
mul r3.xyz, r3.x, r1
mul r2.xyz, r1, r2.x
mad r1.xyz, -r2, c12.x, v3
dp3_pp r3.w, r1, r3
max r3.x, r2.w, c12.z
pow r2, r3.x, c7.x
texldp r3.x, v6, s2
mul r3.xyz, r3.x, c11
mov r2.w, r2.x
mul r2.xyz, r3, c6
mul r2.xyz, r2, r2.w
abs_pp r2.w, r4.x
cmp r2.xyz, -r2.w, r2, c12.z
mul r4.xyz, r2, c8.x
mul r2.xyz, r3, c4
max r1.w, r1, c12.z
mul r3.xyz, r2, r1.w
abs_pp_sat r2.w, r3
add_pp r1.w, -r2, c12
dp4 r2.w, r0, r0
mov r2.xyz, c0
mad_sat r3.xyz, c4, r2, r3
texld r2.xyz, v2, s1
dp3 r0.w, v3, v3
mad r2.xyz, r2, r3, r4
rsq r2.w, r2.w
mul r3.xyz, r2.w, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, v3
dp3 r2.w, r0, r3
pow_pp r0, r1.w, c10.x
max r0.y, r2.w, c12.z
mul_pp r0.w, r0.x, c9.x
add_sat r0.y, -r0, c12.w
mad r0.y, r0, c13.x, c13
max r0.y, r0, c12.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s3
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
mov_pp oC0.w, c4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

}

#LINE 248

      }
	  
      Pass {      
         Tags { "LightMode" = "ForwardAdd" } 
            // pass for additional light sources
         Blend One One // additive blending 
 
         Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 32 to 32
//   d3d9 - ALU: 32 to 32
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 32 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0, vertex.normal.y, c[10];
MAD R0, vertex.normal.x, c[9], R0;
MAD R0, vertex.normal.z, c[11], R0;
ADD R1, R0, c[0].x;
MOV R0.xyz, vertex.attrib[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
DP3 R0.x, R2, R2;
DP4 R1.w, R1, R1;
RSQ R0.w, R0.x;
RSQ R0.y, R1.w;
MUL R0.xyz, R0.y, R1;
MUL R1.xyz, R0.w, R2;
MUL R2.xyz, R1.yzxw, R0.zxyw;
MAD R2.xyz, R1.zxyw, R0.yzxw, -R2;
MUL R2.xyz, vertex.attrib[14].w, R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R2;
MOV result.texcoord[2].xyz, R1;
MOV result.texcoord[3].xyz, R0;
MOV result.texcoord[1], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 32 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 32 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_normal0 v2
dcl_tangent0 v3
mul r0, v2.y, c9
mad r0, v2.x, c8, r0
mad r0, v2.z, c10, r0
add r1, r0, c12.x
mov r0.xyz, v3
mov r0.w, c12.x
dp4 r2.z, r0, c6
dp4 r2.x, r0, c4
dp4 r2.y, r0, c5
dp3 r0.x, r2, r2
dp4 r1.w, r1, r1
rsq r0.w, r0.x
rsq r0.y, r1.w
mul r0.xyz, r0.y, r1
mul r1.xyz, r0.w, r2
mul r2.xyz, r1.yzxw, r0.zxyw
mad r2.xyz, r1.zxyw, r0.yzxw, -r2
mul r2.xyz, v3.w, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r2
mov oT2.xyz, r1
mov oT3.xyz, r0
mov oT1, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_Object2World * tmpvar_2).xyz);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_5;
  tmpvar_5 = normalize ((tmpvar_4 * _World2Object));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = _glesMultiTexCoord0;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5.xyz;
  xlv_TEXCOORD4 = normalize ((cross (tmpvar_5.xyz, tmpvar_3) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD1.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2.z = 0.0;
  tmpvar_2.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_2;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_2, tmpvar_2)));
  highp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD2;
  tmpvar_3[1] = xlv_TEXCOORD4;
  tmpvar_3[2] = xlv_TEXCOORD3;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_7)));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), tmpvar_6)), _Shininess));
  };
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = (tmpvar_8 + specularReflection);
  gl_FragData[0] = tmpvar_10;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_Object2World * tmpvar_2).xyz);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_5;
  tmpvar_5 = normalize ((tmpvar_4 * _World2Object));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = _glesMultiTexCoord0;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_5.xyz;
  xlv_TEXCOORD4 = normalize ((cross (tmpvar_5.xyz, tmpvar_3) * _glesTANGENT.w));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 localCoords;
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD1.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_1;
  highp vec3 tmpvar_2;
  tmpvar_2.z = 0.0;
  tmpvar_2.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_2;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_2, tmpvar_2)));
  highp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD2;
  tmpvar_3[1] = xlv_TEXCOORD4;
  tmpvar_3[2] = xlv_TEXCOORD3;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_7)));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), tmpvar_6)), _Shininess));
  };
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = (tmpvar_8 + specularReflection);
  gl_FragData[0] = tmpvar_10;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "normal" Normal
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaapacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0, a1.y, c9
adaaaaaaabaaapacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1, a1.x, c8
abaaaaaaaaaaapacabaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r1, r0
adaaaaaaacaaapacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2, a1.z, c10
abaaaaaaaaaaapacacaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r2, r0
abaaaaaaabaaapacaaaaaaoeacaaaaaaamaaaaaaabaaaaaa add r1, r0, c12.x
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
aaaaaaaaaaaaaiacamaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c12.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 r2.z, r0, c6
bdaaaaaaacaaabacaaaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 r2.x, r0, c4
bdaaaaaaacaaacacaaaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 r2.y, r0, c5
bcaaaaaaaaaaabacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.x, r2.xyzz, r2.xyzz
bdaaaaaaabaaaiacabaaaaoeacaaaaaaabaaaaoeacaaaaaa dp4 r1.w, r1, r1
akaaaaaaaaaaaiacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.x
akaaaaaaaaaaacacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.y, r1.w
adaaaaaaaaaaahacaaaaaaffacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.y, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r0.w, r2.xyzz
adaaaaaaacaaahacabaaaaajacaaaaaaaaaaaafcacaaaaaa mul r2.xyz, r1.yzxx, r0.zxyy
adaaaaaaadaaahacabaaaafcacaaaaaaaaaaaaajacaaaaaa mul r3.xyz, r1.zxyy, r0.yzxx
acaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa sub r2.xyz, r3.xyzz, r2.xyzz
adaaaaaaacaaahacafaaaappaaaaaaaaacaaaakeacaaaaaa mul r2.xyz, a5.w, r2.xyzz
bcaaaaaaaaaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaacaaaakeacaaaaaa mul v4.xyz, r0.w, r2.xyzz
aaaaaaaaacaaahaeabaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, r1.xyzz
aaaaaaaaadaaahaeaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r0.xyzz
aaaaaaaaabaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v1, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 48 to 48, TEX: 1 to 1
//   d3d9 - ALU: 52 to 52, TEX: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_BumpMap_ST]
Vector 1 [_Color]
Vector 2 [_SpecColor]
Float 3 [_Shininess]
Vector 4 [_WorldSpaceCameraPos]
Vector 5 [_WorldSpaceLightPos0]
Vector 6 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
"!!ARBfp1.0
# 48 ALU, 1 TEX
PARAM c[8] = { program.local[0..6],
		{ 0, 1, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MAD R0.xy, fragment.texcoord[1], c[0], c[0].zwzw;
DP3 R2.x, c[5], c[5];
RSQ R2.x, R2.x;
MOV R0.z, c[7].x;
MUL R2.xyz, R2.x, c[5];
MOV result.color.w, c[7].y;
TEX R0.yw, R0, texture[0], 2D;
MAD R0.xy, R0.wyzw, c[7].z, -c[7].y;
MUL R1.xyz, R0.y, fragment.texcoord[4];
DP3 R0.y, R0, R0;
ADD R0.w, -R0.y, c[7].y;
MAD R1.xyz, R0.x, fragment.texcoord[2], R1;
RSQ R1.w, R0.w;
ADD R0.xyz, -fragment.texcoord[0], c[5];
RCP R1.w, R1.w;
MAD R1.xyz, R1.w, fragment.texcoord[3], R1;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
DP3 R2.w, R1, R1;
RSQ R2.w, R2.w;
ABS R0.w, -c[5];
CMP R0.w, -R0, c[7].x, c[7].y;
ABS R0.w, R0;
CMP R0.w, -R0, c[7].x, c[7].y;
MUL R0.xyz, R1.w, R0;
CMP R0.xyz, -R0.w, R0, R2;
MUL R1.xyz, R2.w, R1;
DP3 R2.w, R1, R0;
ADD R2.xyz, -fragment.texcoord[0], c[4];
DP3 R3.x, R2, R2;
MUL R1.xyz, -R2.w, R1;
RSQ R3.x, R3.x;
MAD R0.xyz, -R1, c[7].z, -R0;
MUL R2.xyz, R3.x, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[7];
POW R2.x, R0.x, c[3].x;
CMP R0.x, -R0.w, R1.w, c[7].y;
MUL R0.xyz, R0.x, c[6];
MUL R1.xyz, R0, c[2];
SLT R0.w, R2, c[7].x;
ABS R0.w, R0;
CMP R0.w, -R0, c[7].x, c[7].y;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[7].x;
MAX R0.w, R2, c[7].x;
MUL R0.xyz, R0, c[1];
MAD result.color.xyz, R0, R0.w, R1;
END
# 48 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_BumpMap_ST]
Vector 1 [_Color]
Vector 2 [_SpecColor]
Float 3 [_Shininess]
Vector 4 [_WorldSpaceCameraPos]
Vector 5 [_WorldSpaceLightPos0]
Vector 6 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
"ps_2_0
; 52 ALU, 1 TEX
dcl_2d s0
def c7, 1.00000000, 0.00000000, 2.00000000, -1.00000000
dcl t0.xyz
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
add r5.xyz, -t0, c4
mov r2.z, c7.y
mov r0.y, c0.w
mov r0.x, c0.z
mad r0.xy, t1, c0, r0
texld r0, r0, s0
mov r0.x, r0.w
mad r2.xy, r0, c7.z, c7.w
dp3 r0.x, r2, r2
mul r1.xyz, r2.y, t4
mad r1.xyz, r2.x, t2, r1
add r0.x, -r0, c7
rsq r0.x, r0.x
rcp r0.x, r0.x
mad r3.xyz, r0.x, t3, r1
add r2.xyz, -t0, c5
dp3 r0.x, r2, r2
dp3 r1.x, r3, r3
rsq r1.x, r1.x
mul r4.xyz, r1.x, r3
rsq r0.x, r0.x
mul r3.xyz, r0.x, r2
dp3 r2.x, c5, c5
rsq r2.x, r2.x
abs r1.x, -c5.w
cmp r1.x, -r1, c7, c7.y
mul r6.xyz, r2.x, c5
abs_pp r2.x, r1
cmp r6.xyz, -r2.x, r3, r6
dp3 r1.x, r4, r6
cmp r0.x, -r2, r0, c7
dp3 r3.x, r5, r5
mul r4.xyz, -r1.x, r4
rsq r3.x, r3.x
mul r3.xyz, r3.x, r5
mad r4.xyz, -r4, c7.z, -r6
dp3 r3.x, r4, r3
max r4.x, r3, c7.y
pow r5.x, r4.x, c3.x
mul r2.xyz, r0.x, c6
cmp r3.x, r1, c7.y, c7
mov r0.x, r5.x
mul r4.xyz, r2, c2
mul r4.xyz, r4, r0.x
abs_pp r0.x, r3
cmp r3.xyz, -r0.x, r4, c7.y
max r0.x, r1, c7.y
mul r1.xyz, r2, c1
mov r0.w, c7.x
mad r0.xyz, r1, r0.x, r3
mov oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

}

#LINE 384

      }
	  
	  
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}