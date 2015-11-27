Shader "RedDotGames/Car Paint with Double Bump" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
      _BumpMap ("Normalmap", 2D) = "bump" {}
      _BumpMap2 ("Normalmap2", 2D) = "white" {}
      _BumeMap2Scale ("Normalmap2 Scale", float) = 1
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0.0
	  _FrezPow("Fresnel Power",Range(0,2)) = 0.0
	  _FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
	  
	  _SparkleTex ("Sparkle Texture", 2D) = "white" {} 

	  _FlakeScale ("Flake Scale", float) = 1
	  _FlakePower ("Flake Alpha",Range(0,1)) = 0
	  _InterFlakePower ("Flake Inter Power",Range(1,256)) = 128
	  _OuterFlakePower ("Flake Outer Power",Range(1,16)) = 2

	  //normalPerturbation ("Normal Perturbation", Range(1,4)) = 2
	  
	  //_paintColor0 ("_paintColor0", Color) = (1,1,1,1) 
	  //_paintColorMid ("_paintColorMid", Color) = (1,1,1,1) 
	  _paintColor2 ("Outer Flake Color (RGB)", Color) = (1,1,1,1) 
	  _flakeLayerColor ("Inter Flake Color (RGB)", Color) = (1,1,1,1) 
	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="False"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 34 to 39
//   d3d9 - ALU: 34 to 39
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
# 34 ALU
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
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 2 R-regs
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
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
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
mul o6.xyz, r0.w, r0
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
mul o4.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
# 34 ALU
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
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 2 R-regs
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
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
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
mul o6.xyz, r0.w, r0
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
mul o4.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
# 34 ALU
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
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 2 R-regs
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
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
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
mul o6.xyz, r0.w, r0
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
mul o4.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
# 39 ALU
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
END
# 39 instructions, 3 R-regs
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
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
dcl_texcoord7 o7
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
mul o6.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o7.xy, r1.z, c13.zwzw, r1
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
mul o4.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
mov o7.zw, r2
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
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
# 39 ALU
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
END
# 39 instructions, 3 R-regs
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
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
dcl_texcoord7 o7
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
mul o6.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o7.xy, r1.z, c13.zwzw, r1
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
mul o4.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
mov o7.zw, r2
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
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
# 39 ALU
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
END
# 39 instructions, 3 R-regs
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
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
dcl_texcoord7 o7
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
mul o6.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o7.xy, r1.z, c13.zwzw, r1
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
mul o4.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
mov o7.zw, r2
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
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
"3.0-!!ARBvp1.0
# 34 ALU
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
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 2 R-regs
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
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
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
mul o6.xyz, r0.w, r0
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
mul o4.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_7).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_17;
  tmpvar_17 = (specularReflection * _Gloss);
  specularReflection = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_21;
  tmpvar_21[0] = xlv_TEXCOORD6;
  tmpvar_21[1] = tmpvar_6;
  tmpvar_21[2] = xlv_TEXCOORD5;
  mat3 tmpvar_22;
  tmpvar_22[0].x = tmpvar_21[0].x;
  tmpvar_22[0].y = tmpvar_21[1].x;
  tmpvar_22[0].z = tmpvar_21[2].x;
  tmpvar_22[1].x = tmpvar_21[0].y;
  tmpvar_22[1].y = tmpvar_21[1].y;
  tmpvar_22[1].z = tmpvar_21[2].y;
  tmpvar_22[2].x = tmpvar_21[0].z;
  tmpvar_22[2].y = tmpvar_21[1].z;
  tmpvar_22[2].z = tmpvar_21[2].z;
  mat3 tmpvar_23;
  tmpvar_23[0].x = tmpvar_22[0].x;
  tmpvar_23[0].y = tmpvar_22[1].x;
  tmpvar_23[0].z = tmpvar_22[2].x;
  tmpvar_23[1].x = tmpvar_22[0].y;
  tmpvar_23[1].y = tmpvar_22[1].y;
  tmpvar_23[1].z = tmpvar_22[2].y;
  tmpvar_23[2].x = tmpvar_22[0].z;
  tmpvar_23[2].y = tmpvar_22[1].z;
  tmpvar_23[2].z = tmpvar_22[2].z;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_20), 0.0, 1.0);
  highp vec4 tmpvar_25;
  tmpvar_25 = ((pow ((tmpvar_24 * tmpvar_24), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_23 * -((tmpvar_19 + vec3(0.0, 0.0, 1.0))))), tmpvar_20), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = ((textureColor.xyz * clamp ((tmpvar_14 + tmpvar_15), 0.0, 1.0)) + tmpvar_17);
  color = tmpvar_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (color + (paintColor * _FlakePower));
  color = tmpvar_33;
  color = ((color + reflTex) + (tmpvar_30 * reflTex));
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
"3.0-!!ARBvp1.0
# 39 ALU
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
END
# 39 instructions, 3 R-regs
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
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord3 o3
dcl_texcoord4 o4
dcl_texcoord5 o5
dcl_texcoord6 o6
dcl_texcoord7 o7
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
mul o6.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o7.xy, r1.z, c13.zwzw, r1
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
mul o4.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o3, v2
dp4 o5.z, r0, c6
dp4 o5.y, r0, c5
dp4 o5.x, r0, c4
mov o7.zw, r2
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
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
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_2.xyz;
  highp vec4 o_i0;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_6 * 0.5);
  o_i0 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = tmpvar_9.x;
  tmpvar_10.y = (tmpvar_9.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_10 + tmpvar_9.w);
  o_i0.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7).xyz);
  xlv_TEXCOORD5 = (_Object2World * tmpvar_4).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_8).xyz);
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

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _InterFlakePower;
uniform highp float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform highp float _FlakeScale;
uniform highp float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform highp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5)));
  highp vec3 tmpvar_5;
  tmpvar_5.z = 0.0;
  tmpvar_5.xy = ((2.0 * tmpvar_4.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_5;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_5, tmpvar_5)));
  highp vec3 tmpvar_6;
  tmpvar_6 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_7;
  tmpvar_7[0] = xlv_TEXCOORD6;
  tmpvar_7[1] = tmpvar_6;
  tmpvar_7[2] = xlv_TEXCOORD5;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((localCoords * tmpvar_8));
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_11;
  tmpvar_11 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, tmpvar_11);
  textureColor = tmpvar_12;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_13;
    tmpvar_13 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_13;
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_14)));
    lightDirection = normalize (tmpvar_14);
  };
  lowp float tmpvar_15;
  tmpvar_15 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_9, lightDirection)));
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_9, lightDirection);
  if ((tmpvar_18 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_9), tmpvar_10)), _Shininess));
  };
  highp vec3 tmpvar_19;
  tmpvar_19 = (specularReflection * _Gloss);
  specularReflection = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_23;
  tmpvar_23[0] = xlv_TEXCOORD6;
  tmpvar_23[1] = tmpvar_6;
  tmpvar_23[2] = xlv_TEXCOORD5;
  mat3 tmpvar_24;
  tmpvar_24[0].x = tmpvar_23[0].x;
  tmpvar_24[0].y = tmpvar_23[1].x;
  tmpvar_24[0].z = tmpvar_23[2].x;
  tmpvar_24[1].x = tmpvar_23[0].y;
  tmpvar_24[1].y = tmpvar_23[1].y;
  tmpvar_24[1].z = tmpvar_23[2].y;
  tmpvar_24[2].x = tmpvar_23[0].z;
  tmpvar_24[2].y = tmpvar_23[1].z;
  tmpvar_24[2].z = tmpvar_23[2].z;
  mat3 tmpvar_25;
  tmpvar_25[0].x = tmpvar_24[0].x;
  tmpvar_25[0].y = tmpvar_24[1].x;
  tmpvar_25[0].z = tmpvar_24[2].x;
  tmpvar_25[1].x = tmpvar_24[0].y;
  tmpvar_25[1].y = tmpvar_24[1].y;
  tmpvar_25[1].z = tmpvar_24[2].y;
  tmpvar_25[2].x = tmpvar_24[0].z;
  tmpvar_25[2].y = tmpvar_24[1].z;
  tmpvar_25[2].z = tmpvar_24[2].z;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_22), 0.0, 1.0);
  highp vec4 tmpvar_27;
  tmpvar_27 = ((pow ((tmpvar_26 * tmpvar_26), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_25 * -((tmpvar_21 + vec3(0.0, 0.0, 1.0))))), tmpvar_22), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = reflect (xlv_TEXCOORD4, tmpvar_9);
  reflectedDir = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (abs (dot (reflectedDir, normalize (tmpvar_9))), 0.0, 1.0);
  SurfAngle = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = (frez * _FrezPow);
  frez = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_29.xyz * ((_Reflection + tmpvar_32) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (tmpvar_4).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_33;
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((textureColor.xyz * clamp ((tmpvar_16 + tmpvar_17), 0.0, 1.0)) + tmpvar_19);
  color = tmpvar_34;
  highp vec4 tmpvar_35;
  tmpvar_35 = (color + (paintColor * _FlakePower));
  color = tmpvar_35;
  color = ((color + reflTex) + (tmpvar_32 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 126 to 127, TEX: 5 to 6
//   d3d9 - ALU: 129 to 130, TEX: 5 to 6
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 126 ALU, 5 TEX
PARAM c[22] = { state.lightmodel.ambient,
		program.local[1..18],
		{ 0.5, 2, 1, 0 },
		{ 0.79627001, 0.20373, 20 },
		{ 0, 4 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
TEMP R10;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
DP3 R3.w, c[2], c[2];
TEX R1, R0, texture[0], 2D;
MUL R0.zw, R0.xyxy, c[9].x;
TEX R0, R0.zwzw, texture[1], 2D;
ADD R0, R0, -R1;
MAD R0, R0, c[19].x, R1;
DP4 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R1, R1.x, R0;
MAD R2.xy, R1.wyzw, c[19].y, -c[19].z;
MOV R0.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R3;
MOV R2.z, c[19].w;
DP3 R0.w, R2, R2;
MUL R3.xyz, R2.y, R0;
ADD R0.w, -R0, c[19].z;
RSQ R0.w, R0.w;
DP4 R1.w, R1, R1;
MAD R2.xyz, R2.x, fragment.texcoord[6], R3;
RCP R0.w, R0.w;
MAD R2.xyz, R0.w, fragment.texcoord[5], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R4.xyz, R2, R0.w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
MAD R5.xyz, -R4, c[19].y, fragment.texcoord[4];
DP3 R0.w, R5, R3;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
RSQ R3.w, R3.w;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[19].z;
POW R0.w, R0.w, c[17].x;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[19], c[19].z;
ABS R2.w, R2;
ADD R6.xyz, -fragment.texcoord[0], c[1];
MUL R4.xyz, R3.w, c[2];
CMP R2.w, -R2, c[19], c[19].z;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R2.w, R2, R3;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[19].y, -R3;
MUL R0.w, R0, c[16].x;
DP3 R3.w, R6, R6;
RSQ R3.w, R3.w;
MUL R4.xyz, R3.w, R6;
DP3 R2.x, R2, R4;
MAX R2.x, R2, c[19].w;
POW R3.y, R2.x, c[7].x;
RSQ R2.x, R1.w;
MUL R1.xyz, R2.x, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R6.xyz, R1.w, fragment.texcoord[4];
DP3 R1.w, R6, R1;
MOV R2.xyz, c[6];
MUL R1.xyz, R2, c[18];
SLT R2.x, R2.w, c[19].w;
MUL R1.xyz, R1, R3.y;
MAX R1.w, R1, c[19];
ADD_SAT R1.w, -R1, c[19].z;
ABS R2.x, R2;
CMP R2.x, -R2, c[19].w, c[19].z;
CMP R1.xyz, -R2.x, R1, c[19].w;
MUL R8.xyz, R1, c[8].x;
MOV R4.xyz, c[4];
MAD R1.w, R1, c[20].x, c[20].y;
MUL R1.xy, fragment.texcoord[3], c[10].x;
MUL R1.xy, R1, c[20].z;
TEX R1.xyz, R1, texture[3], 2D;
MAD R9.xyz, R1, c[19].y, -c[19].z;
ADD R10.xyz, R9, c[19].wwzw;
MUL R2.xyz, R4, c[18];
MAX R2.w, R2, c[19];
MUL R7.xyz, R2, R2.w;
MOV R3.y, R0.z;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, R2, -R10;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, R1, -R10;
ADD R9.xyz, R9, c[21].xxyw;
ADD R3.x, R0.w, c[5];
MAX R1.w, R1, c[19];
MUL R1.w, R3.x, R1;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R10;
DP3 R3.z, R3, -R9;
DP3 R3.x, -R9, R1;
DP3 R3.y, -R9, R2;
DP3 R2.w, R0, R0;
RSQ R1.y, R2.w;
MUL R0.xyz, R1.y, R0;
DP3_SAT R0.y, R6, R0;
DP3 R1.x, R3, R3;
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, R3;
DP3_SAT R0.x, R6, R1;
MUL R1.x, R0, R0;
POW R0.y, R0.y, c[12].x;
POW R1.x, R1.x, c[13].x;
MUL R0.xyz, R0.y, c[15];
MAD R0.xyz, R1.x, c[14], R0;
MUL R2.xyz, R0, c[11].x;
MAD_SAT R1.xyz, R4, c[0], R7;
TEX R0.xyz, fragment.texcoord[3], texture[2], 2D;
MAD R0.xyz, R0, R1, R8;
ADD R1.xyz, R0, R2;
TEX R0.xyz, R5, texture[4], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 126 instructions, 11 R-regs
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 130 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c19, 0.50000000, 2.00000000, -1.00000000, 0.00000000
def c20, 1.00000000, 0.79627001, 0.20373000, 0.00000000
def c21, 20.00000000, 0.00000000, 4.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mad r1.xy, v2, c3, c3.zwzw
mul r0.xy, r1, c9.x
texld r1, r1, s0
texld r0, r0, s1
add r0, r0, -r1
mad r0, r0, c19.x, r1
dp4 r1.x, r0, r0
add r5.xyz, -v0, c2
rsq r1.x, r1.x
mul r3, r1.x, r0
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
dp3 r1.w, r5, r5
rsq r1.w, r1.w
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mad r0.xy, r3.wyzw, c19.y, c19.z
mul r2.xyz, r0.y, r1
mov r0.z, c19.w
dp3 r0.z, r0, r0
add r0.z, -r0, c20.x
mul r6.xyz, r1.w, r5
mad r2.xyz, r0.x, v5, r2
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v4, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
dp3 r0.y, r4, r4
rsq r0.w, r0.y
dp3 r0.x, r4, v3
mul r0.xyz, r4, r0.x
mul r2.xyz, r0.w, r4
mad r0.xyz, -r0, c19.y, v3
dp3_pp r0.w, r0, r2
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c20.x
pow_pp r2, r0.w, c17.x
dp3 r0.w, c2, c2
rsq r0.w, r0.w
mul r5.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp r5.xyz, -r0.w, r5, r6
dp3 r1.w, r4, r5
add r7.xyz, -v0, c1
mul r4.xyz, r4, -r1.w
dp3 r0.w, r7, r7
rsq r0.w, r0.w
mad r4.xyz, -r4, c19.y, -r5
mul r6.xyz, r0.w, r7
dp3 r0.w, r4, r6
mov r4.y, r1.z
max r4.x, r0.w, c19.w
mov_pp r0.w, r2.x
pow r2, r4.x, c7.x
dp4 r2.y, r3, r3
mov r4.x, r2
mul_pp r0.w, r0, c16.x
dp3 r2.x, v3, v3
rsq r3.w, r2.x
rsq r2.y, r2.y
mul r2.xyz, r2.y, r3
cmp r3.y, r1.w, c20.w, c20.x
mul r5.xyz, r3.w, v3
dp3 r3.x, r5, r2
mov r2.xyz, c18
max r3.x, r3, c19.w
mul r2.xyz, c6, r2
mul r2.xyz, r2, r4.x
abs_pp r3.y, r3
cmp r2.xyz, -r3.y, r2, c19.w
mul r7.xyz, r2, c8.x
add_sat r3.x, -r3, c20
mad r3.x, r3, c20.y, c20.z
mul r2.xy, v2, c10.x
mul r2.xy, r2, c21.x
texld r2.xyz, r2, s3
mad r8.xyz, r2, c19.y, c19.z
add r9.xyz, r8, c20.wwxw
mov r2.y, r1.x
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c21.yyzw
dp3 r4.z, r4, -r8
mov r2.z, v4.x
mov r2.x, v5
dp3 r1.x, r2, -r9
dp3 r4.x, -r8, r2
add r2.w, r0, c5.x
max r3.x, r3, c19.w
mul r3.w, r2, r3.x
mov r3.xyz, c18
texld r0.xyz, r0, s4
mul r3.xyz, c4, r3
max r1.w, r1, c19
mul r6.xyz, r3, r1.w
mov r3.y, r1
mov r3.z, v4.y
mov r3.x, v5.y
dp3 r1.y, r3, -r9
dp3 r1.w, r1, r1
dp3 r4.y, -r8, r3
rsq r2.y, r1.w
mul r1.xyz, r2.y, r1
dp3 r2.x, r4, r4
rsq r1.w, r2.x
mul r2.xyz, r1.w, r4
dp3_sat r2.w, r5, r1
pow r1, r2.w, c12.x
dp3_sat r2.x, r5, r2
mul r1.y, r2.x, r2.x
pow r2, r1.y, c13.x
mul r1.xyz, r1.x, c15
mov r1.w, r2.x
mad r2.xyz, r1.w, c14, r1
mul r3.xyz, r2, c11.x
mov r1.xyz, c0
mul_pp r0.xyz, r0, r3.w
mad_sat r1.xyz, c4, r1, r6
texld r2.xyz, v2, s2
mad r1.xyz, r2, r1, r7
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r0, r1
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 126 ALU, 5 TEX
PARAM c[22] = { state.lightmodel.ambient,
		program.local[1..18],
		{ 0.5, 2, 1, 0 },
		{ 0.79627001, 0.20373, 20 },
		{ 0, 4 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
TEMP R10;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
DP3 R3.w, c[2], c[2];
TEX R1, R0, texture[0], 2D;
MUL R0.zw, R0.xyxy, c[9].x;
TEX R0, R0.zwzw, texture[1], 2D;
ADD R0, R0, -R1;
MAD R0, R0, c[19].x, R1;
DP4 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R1, R1.x, R0;
MAD R2.xy, R1.wyzw, c[19].y, -c[19].z;
MOV R0.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R3;
MOV R2.z, c[19].w;
DP3 R0.w, R2, R2;
MUL R3.xyz, R2.y, R0;
ADD R0.w, -R0, c[19].z;
RSQ R0.w, R0.w;
DP4 R1.w, R1, R1;
MAD R2.xyz, R2.x, fragment.texcoord[6], R3;
RCP R0.w, R0.w;
MAD R2.xyz, R0.w, fragment.texcoord[5], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R4.xyz, R2, R0.w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
MAD R5.xyz, -R4, c[19].y, fragment.texcoord[4];
DP3 R0.w, R5, R3;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
RSQ R3.w, R3.w;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[19].z;
POW R0.w, R0.w, c[17].x;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[19], c[19].z;
ABS R2.w, R2;
ADD R6.xyz, -fragment.texcoord[0], c[1];
MUL R4.xyz, R3.w, c[2];
CMP R2.w, -R2, c[19], c[19].z;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R2.w, R2, R3;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[19].y, -R3;
MUL R0.w, R0, c[16].x;
DP3 R3.w, R6, R6;
RSQ R3.w, R3.w;
MUL R4.xyz, R3.w, R6;
DP3 R2.x, R2, R4;
MAX R2.x, R2, c[19].w;
POW R3.y, R2.x, c[7].x;
RSQ R2.x, R1.w;
MUL R1.xyz, R2.x, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R6.xyz, R1.w, fragment.texcoord[4];
DP3 R1.w, R6, R1;
MOV R2.xyz, c[6];
MUL R1.xyz, R2, c[18];
SLT R2.x, R2.w, c[19].w;
MUL R1.xyz, R1, R3.y;
MAX R1.w, R1, c[19];
ADD_SAT R1.w, -R1, c[19].z;
ABS R2.x, R2;
CMP R2.x, -R2, c[19].w, c[19].z;
CMP R1.xyz, -R2.x, R1, c[19].w;
MUL R8.xyz, R1, c[8].x;
MOV R4.xyz, c[4];
MAD R1.w, R1, c[20].x, c[20].y;
MUL R1.xy, fragment.texcoord[3], c[10].x;
MUL R1.xy, R1, c[20].z;
TEX R1.xyz, R1, texture[3], 2D;
MAD R9.xyz, R1, c[19].y, -c[19].z;
ADD R10.xyz, R9, c[19].wwzw;
MUL R2.xyz, R4, c[18];
MAX R2.w, R2, c[19];
MUL R7.xyz, R2, R2.w;
MOV R3.y, R0.z;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, R2, -R10;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, R1, -R10;
ADD R9.xyz, R9, c[21].xxyw;
ADD R3.x, R0.w, c[5];
MAX R1.w, R1, c[19];
MUL R1.w, R3.x, R1;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R10;
DP3 R3.z, R3, -R9;
DP3 R3.x, -R9, R1;
DP3 R3.y, -R9, R2;
DP3 R2.w, R0, R0;
RSQ R1.y, R2.w;
MUL R0.xyz, R1.y, R0;
DP3_SAT R0.y, R6, R0;
DP3 R1.x, R3, R3;
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, R3;
DP3_SAT R0.x, R6, R1;
MUL R1.x, R0, R0;
POW R0.y, R0.y, c[12].x;
POW R1.x, R1.x, c[13].x;
MUL R0.xyz, R0.y, c[15];
MAD R0.xyz, R1.x, c[14], R0;
MUL R2.xyz, R0, c[11].x;
MAD_SAT R1.xyz, R4, c[0], R7;
TEX R0.xyz, fragment.texcoord[3], texture[2], 2D;
MAD R0.xyz, R0, R1, R8;
ADD R1.xyz, R0, R2;
TEX R0.xyz, R5, texture[4], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 126 instructions, 11 R-regs
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 130 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c19, 0.50000000, 2.00000000, -1.00000000, 0.00000000
def c20, 1.00000000, 0.79627001, 0.20373000, 0.00000000
def c21, 20.00000000, 0.00000000, 4.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mad r1.xy, v2, c3, c3.zwzw
mul r0.xy, r1, c9.x
texld r1, r1, s0
texld r0, r0, s1
add r0, r0, -r1
mad r0, r0, c19.x, r1
dp4 r1.x, r0, r0
add r5.xyz, -v0, c2
rsq r1.x, r1.x
mul r3, r1.x, r0
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
dp3 r1.w, r5, r5
rsq r1.w, r1.w
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mad r0.xy, r3.wyzw, c19.y, c19.z
mul r2.xyz, r0.y, r1
mov r0.z, c19.w
dp3 r0.z, r0, r0
add r0.z, -r0, c20.x
mul r6.xyz, r1.w, r5
mad r2.xyz, r0.x, v5, r2
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v4, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
dp3 r0.y, r4, r4
rsq r0.w, r0.y
dp3 r0.x, r4, v3
mul r0.xyz, r4, r0.x
mul r2.xyz, r0.w, r4
mad r0.xyz, -r0, c19.y, v3
dp3_pp r0.w, r0, r2
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c20.x
pow_pp r2, r0.w, c17.x
dp3 r0.w, c2, c2
rsq r0.w, r0.w
mul r5.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp r5.xyz, -r0.w, r5, r6
dp3 r1.w, r4, r5
add r7.xyz, -v0, c1
mul r4.xyz, r4, -r1.w
dp3 r0.w, r7, r7
rsq r0.w, r0.w
mad r4.xyz, -r4, c19.y, -r5
mul r6.xyz, r0.w, r7
dp3 r0.w, r4, r6
mov r4.y, r1.z
max r4.x, r0.w, c19.w
mov_pp r0.w, r2.x
pow r2, r4.x, c7.x
dp4 r2.y, r3, r3
mov r4.x, r2
mul_pp r0.w, r0, c16.x
dp3 r2.x, v3, v3
rsq r3.w, r2.x
rsq r2.y, r2.y
mul r2.xyz, r2.y, r3
cmp r3.y, r1.w, c20.w, c20.x
mul r5.xyz, r3.w, v3
dp3 r3.x, r5, r2
mov r2.xyz, c18
max r3.x, r3, c19.w
mul r2.xyz, c6, r2
mul r2.xyz, r2, r4.x
abs_pp r3.y, r3
cmp r2.xyz, -r3.y, r2, c19.w
mul r7.xyz, r2, c8.x
add_sat r3.x, -r3, c20
mad r3.x, r3, c20.y, c20.z
mul r2.xy, v2, c10.x
mul r2.xy, r2, c21.x
texld r2.xyz, r2, s3
mad r8.xyz, r2, c19.y, c19.z
add r9.xyz, r8, c20.wwxw
mov r2.y, r1.x
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c21.yyzw
dp3 r4.z, r4, -r8
mov r2.z, v4.x
mov r2.x, v5
dp3 r1.x, r2, -r9
dp3 r4.x, -r8, r2
add r2.w, r0, c5.x
max r3.x, r3, c19.w
mul r3.w, r2, r3.x
mov r3.xyz, c18
texld r0.xyz, r0, s4
mul r3.xyz, c4, r3
max r1.w, r1, c19
mul r6.xyz, r3, r1.w
mov r3.y, r1
mov r3.z, v4.y
mov r3.x, v5.y
dp3 r1.y, r3, -r9
dp3 r1.w, r1, r1
dp3 r4.y, -r8, r3
rsq r2.y, r1.w
mul r1.xyz, r2.y, r1
dp3 r2.x, r4, r4
rsq r1.w, r2.x
mul r2.xyz, r1.w, r4
dp3_sat r2.w, r5, r1
pow r1, r2.w, c12.x
dp3_sat r2.x, r5, r2
mul r1.y, r2.x, r2.x
pow r2, r1.y, c13.x
mul r1.xyz, r1.x, c15
mov r1.w, r2.x
mad r2.xyz, r1.w, c14, r1
mul r3.xyz, r2, c11.x
mov r1.xyz, c0
mul_pp r0.xyz, r0, r3.w
mad_sat r1.xyz, c4, r1, r6
texld r2.xyz, v2, s2
mad r1.xyz, r2, r1, r7
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r0, r1
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 126 ALU, 5 TEX
PARAM c[22] = { state.lightmodel.ambient,
		program.local[1..18],
		{ 0.5, 2, 1, 0 },
		{ 0.79627001, 0.20373, 20 },
		{ 0, 4 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
TEMP R10;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
DP3 R3.w, c[2], c[2];
TEX R1, R0, texture[0], 2D;
MUL R0.zw, R0.xyxy, c[9].x;
TEX R0, R0.zwzw, texture[1], 2D;
ADD R0, R0, -R1;
MAD R0, R0, c[19].x, R1;
DP4 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R1, R1.x, R0;
MAD R2.xy, R1.wyzw, c[19].y, -c[19].z;
MOV R0.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R3;
MOV R2.z, c[19].w;
DP3 R0.w, R2, R2;
MUL R3.xyz, R2.y, R0;
ADD R0.w, -R0, c[19].z;
RSQ R0.w, R0.w;
DP4 R1.w, R1, R1;
MAD R2.xyz, R2.x, fragment.texcoord[6], R3;
RCP R0.w, R0.w;
MAD R2.xyz, R0.w, fragment.texcoord[5], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R4.xyz, R2, R0.w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
MAD R5.xyz, -R4, c[19].y, fragment.texcoord[4];
DP3 R0.w, R5, R3;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
RSQ R3.w, R3.w;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[19].z;
POW R0.w, R0.w, c[17].x;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[19], c[19].z;
ABS R2.w, R2;
ADD R6.xyz, -fragment.texcoord[0], c[1];
MUL R4.xyz, R3.w, c[2];
CMP R2.w, -R2, c[19], c[19].z;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R2.w, R2, R3;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[19].y, -R3;
MUL R0.w, R0, c[16].x;
DP3 R3.w, R6, R6;
RSQ R3.w, R3.w;
MUL R4.xyz, R3.w, R6;
DP3 R2.x, R2, R4;
MAX R2.x, R2, c[19].w;
POW R3.y, R2.x, c[7].x;
RSQ R2.x, R1.w;
MUL R1.xyz, R2.x, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R6.xyz, R1.w, fragment.texcoord[4];
DP3 R1.w, R6, R1;
MOV R2.xyz, c[6];
MUL R1.xyz, R2, c[18];
SLT R2.x, R2.w, c[19].w;
MUL R1.xyz, R1, R3.y;
MAX R1.w, R1, c[19];
ADD_SAT R1.w, -R1, c[19].z;
ABS R2.x, R2;
CMP R2.x, -R2, c[19].w, c[19].z;
CMP R1.xyz, -R2.x, R1, c[19].w;
MUL R8.xyz, R1, c[8].x;
MOV R4.xyz, c[4];
MAD R1.w, R1, c[20].x, c[20].y;
MUL R1.xy, fragment.texcoord[3], c[10].x;
MUL R1.xy, R1, c[20].z;
TEX R1.xyz, R1, texture[3], 2D;
MAD R9.xyz, R1, c[19].y, -c[19].z;
ADD R10.xyz, R9, c[19].wwzw;
MUL R2.xyz, R4, c[18];
MAX R2.w, R2, c[19];
MUL R7.xyz, R2, R2.w;
MOV R3.y, R0.z;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, R2, -R10;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, R1, -R10;
ADD R9.xyz, R9, c[21].xxyw;
ADD R3.x, R0.w, c[5];
MAX R1.w, R1, c[19];
MUL R1.w, R3.x, R1;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R10;
DP3 R3.z, R3, -R9;
DP3 R3.x, -R9, R1;
DP3 R3.y, -R9, R2;
DP3 R2.w, R0, R0;
RSQ R1.y, R2.w;
MUL R0.xyz, R1.y, R0;
DP3_SAT R0.y, R6, R0;
DP3 R1.x, R3, R3;
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, R3;
DP3_SAT R0.x, R6, R1;
MUL R1.x, R0, R0;
POW R0.y, R0.y, c[12].x;
POW R1.x, R1.x, c[13].x;
MUL R0.xyz, R0.y, c[15];
MAD R0.xyz, R1.x, c[14], R0;
MUL R2.xyz, R0, c[11].x;
MAD_SAT R1.xyz, R4, c[0], R7;
TEX R0.xyz, fragment.texcoord[3], texture[2], 2D;
MAD R0.xyz, R0, R1, R8;
ADD R1.xyz, R0, R2;
TEX R0.xyz, R5, texture[4], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 126 instructions, 11 R-regs
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 130 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c19, 0.50000000, 2.00000000, -1.00000000, 0.00000000
def c20, 1.00000000, 0.79627001, 0.20373000, 0.00000000
def c21, 20.00000000, 0.00000000, 4.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mad r1.xy, v2, c3, c3.zwzw
mul r0.xy, r1, c9.x
texld r1, r1, s0
texld r0, r0, s1
add r0, r0, -r1
mad r0, r0, c19.x, r1
dp4 r1.x, r0, r0
add r5.xyz, -v0, c2
rsq r1.x, r1.x
mul r3, r1.x, r0
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
dp3 r1.w, r5, r5
rsq r1.w, r1.w
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mad r0.xy, r3.wyzw, c19.y, c19.z
mul r2.xyz, r0.y, r1
mov r0.z, c19.w
dp3 r0.z, r0, r0
add r0.z, -r0, c20.x
mul r6.xyz, r1.w, r5
mad r2.xyz, r0.x, v5, r2
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v4, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
dp3 r0.y, r4, r4
rsq r0.w, r0.y
dp3 r0.x, r4, v3
mul r0.xyz, r4, r0.x
mul r2.xyz, r0.w, r4
mad r0.xyz, -r0, c19.y, v3
dp3_pp r0.w, r0, r2
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c20.x
pow_pp r2, r0.w, c17.x
dp3 r0.w, c2, c2
rsq r0.w, r0.w
mul r5.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp r5.xyz, -r0.w, r5, r6
dp3 r1.w, r4, r5
add r7.xyz, -v0, c1
mul r4.xyz, r4, -r1.w
dp3 r0.w, r7, r7
rsq r0.w, r0.w
mad r4.xyz, -r4, c19.y, -r5
mul r6.xyz, r0.w, r7
dp3 r0.w, r4, r6
mov r4.y, r1.z
max r4.x, r0.w, c19.w
mov_pp r0.w, r2.x
pow r2, r4.x, c7.x
dp4 r2.y, r3, r3
mov r4.x, r2
mul_pp r0.w, r0, c16.x
dp3 r2.x, v3, v3
rsq r3.w, r2.x
rsq r2.y, r2.y
mul r2.xyz, r2.y, r3
cmp r3.y, r1.w, c20.w, c20.x
mul r5.xyz, r3.w, v3
dp3 r3.x, r5, r2
mov r2.xyz, c18
max r3.x, r3, c19.w
mul r2.xyz, c6, r2
mul r2.xyz, r2, r4.x
abs_pp r3.y, r3
cmp r2.xyz, -r3.y, r2, c19.w
mul r7.xyz, r2, c8.x
add_sat r3.x, -r3, c20
mad r3.x, r3, c20.y, c20.z
mul r2.xy, v2, c10.x
mul r2.xy, r2, c21.x
texld r2.xyz, r2, s3
mad r8.xyz, r2, c19.y, c19.z
add r9.xyz, r8, c20.wwxw
mov r2.y, r1.x
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c21.yyzw
dp3 r4.z, r4, -r8
mov r2.z, v4.x
mov r2.x, v5
dp3 r1.x, r2, -r9
dp3 r4.x, -r8, r2
add r2.w, r0, c5.x
max r3.x, r3, c19.w
mul r3.w, r2, r3.x
mov r3.xyz, c18
texld r0.xyz, r0, s4
mul r3.xyz, c4, r3
max r1.w, r1, c19
mul r6.xyz, r3, r1.w
mov r3.y, r1
mov r3.z, v4.y
mov r3.x, v5.y
dp3 r1.y, r3, -r9
dp3 r1.w, r1, r1
dp3 r4.y, -r8, r3
rsq r2.y, r1.w
mul r1.xyz, r2.y, r1
dp3 r2.x, r4, r4
rsq r1.w, r2.x
mul r2.xyz, r1.w, r4
dp3_sat r2.w, r5, r1
pow r1, r2.w, c12.x
dp3_sat r2.x, r5, r2
mul r1.y, r2.x, r2.x
pow r2, r1.y, c13.x
mul r1.xyz, r1.x, c15
mov r1.w, r2.x
mad r2.xyz, r1.w, c14, r1
mul r3.xyz, r2, c11.x
mov r1.xyz, c0
mul_pp r0.xyz, r0, r3.w
mad_sat r1.xyz, c4, r1, r6
texld r2.xyz, v2, s2
mad r1.xyz, r2, r1, r7
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r0, r1
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_SparkleTex] 2D
SetTexture 5 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 127 ALU, 6 TEX
PARAM c[22] = { state.lightmodel.ambient,
		program.local[1..18],
		{ 0.5, 2, 1, 0 },
		{ 0.79627001, 0.20373, 20 },
		{ 0, 4 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
DP3 R3.w, c[2], c[2];
RSQ R3.w, R3.w;
TEX R1, R0, texture[0], 2D;
MUL R0.zw, R0.xyxy, c[9].x;
TEX R0, R0.zwzw, texture[1], 2D;
ADD R0, R0, -R1;
MAD R0, R0, c[19].x, R1;
DP4 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R1, R1.x, R0;
MAD R2.xy, R1.wyzw, c[19].y, -c[19].z;
MOV R0.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R3;
MOV R2.z, c[19].w;
DP3 R0.w, R2, R2;
MUL R3.xyz, R2.y, R0;
ADD R0.w, -R0, c[19].z;
RSQ R0.w, R0.w;
DP4 R1.w, R1, R1;
MAD R2.xyz, R2.x, fragment.texcoord[6], R3;
RCP R0.w, R0.w;
MAD R2.xyz, R0.w, fragment.texcoord[5], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R4.xyz, R2, R0.w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
MAD R4.xyz, -R4, c[19].y, fragment.texcoord[4];
DP3 R0.w, R4, R3;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[19].z;
POW R0.w, R0.w, c[17].x;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[19], c[19].z;
ABS R2.w, R2;
MUL R5.xyz, R3.w, c[2];
CMP R2.w, -R2, c[19], c[19].z;
CMP R3.xyz, -R2.w, R3, R5;
DP3 R2.w, R2, R3;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[19].y, -R3;
RSQ R3.x, R1.w;
MUL R1.xyz, R3.x, R1;
MUL R0.w, R0, c[16].x;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R5.xyz, R1.w, fragment.texcoord[4];
DP3 R1.x, R5, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.y, R3, R3;
MAX R1.x, R1, c[19].w;
ADD_SAT R1.w, -R1.x, c[19].z;
RSQ R1.y, R1.y;
MUL R1.xyz, R1.y, R3;
DP3 R1.y, R2, R1;
MAD R1.w, R1, c[20].x, c[20].y;
MAX R1.y, R1, c[19].w;
POW R3.y, R1.y, c[7].x;
SLT R1.y, R2.w, c[19].w;
ABS R3.x, R1.y;
MAX R1.x, R1.w, c[19].w;
ADD R3.w, R0, c[5].x;
MUL R1.w, R3, R1.x;
TXP R1.x, fragment.texcoord[7], texture[3], 2D;
MUL R2.xyz, R1.x, c[18];
MUL R1.xyz, R2, c[6];
MUL R2.xyz, R2, c[4];
MAX R2.w, R2, c[19];
MUL R6.xyz, R2, R2.w;
MOV R2.y, R0;
MUL R1.xyz, R1, R3.y;
CMP R3.x, -R3, c[19].w, c[19].z;
CMP R1.xyz, -R3.x, R1, c[19].w;
MUL R3.xy, fragment.texcoord[3], c[10].x;
MUL R7.xyz, R1, c[8].x;
MUL R1.xy, R3, c[20].z;
TEX R1.xyz, R1, texture[4], 2D;
MAD R8.xyz, R1, c[19].y, -c[19].z;
ADD R9.xyz, R8, c[19].wwzw;
MOV R3.y, R0.z;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R9;
ADD R8.xyz, R8, c[21].xxyw;
DP3 R3.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, R2, -R9;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, R1, -R9;
DP3 R3.x, -R8, R1;
DP3 R3.y, -R8, R2;
DP3 R2.w, R0, R0;
RSQ R1.y, R2.w;
MUL R0.xyz, R1.y, R0;
DP3_SAT R0.y, R5, R0;
DP3 R1.x, R3, R3;
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, R3;
DP3_SAT R0.x, R5, R1;
MUL R1.x, R0, R0;
POW R0.y, R0.y, c[12].x;
MUL R0.xyz, R0.y, c[15];
POW R1.x, R1.x, c[13].x;
MAD R1.xyz, R1.x, c[14], R0;
MUL R2.xyz, R1, c[11].x;
MOV R0.xyz, c[4];
TEX R1.xyz, fragment.texcoord[3], texture[2], 2D;
MAD_SAT R0.xyz, R0, c[0], R6;
MAD R0.xyz, R1, R0, R7;
ADD R1.xyz, R0, R2;
TEX R0.xyz, R4, texture[5], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 127 instructions, 10 R-regs
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_SparkleTex] 2D
SetTexture 5 [_Cube] CUBE
"ps_3_0
; 129 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
def c19, 0.50000000, 2.00000000, -1.00000000, 0.00000000
def c20, 1.00000000, 0.79627001, 0.20373000, 0.00000000
def c21, 20.00000000, 0.00000000, 4.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mad r1.xy, v2, c3, c3.zwzw
mul r0.xy, r1, c9.x
texld r1, r1, s0
texld r0, r0, s1
add r0, r0, -r1
mad r0, r0, c19.x, r1
dp4 r1.x, r0, r0
rsq r1.x, r1.x
mul r3, r1.x, r0
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
dp3 r1.w, c2, c2
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mad r0.xy, r3.wyzw, c19.y, c19.z
mul r2.xyz, r0.y, r1
mov r0.z, c19.w
dp3 r0.z, r0, r0
add r0.z, -r0, c20.x
mad r2.xyz, r0.x, v5, r2
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v4, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
dp3 r0.y, r4, r4
rsq r0.w, r0.y
dp3 r0.x, r4, v3
mul r0.xyz, r4, r0.x
mul r2.xyz, r0.w, r4
mad r0.xyz, -r0, c19.y, v3
dp3_pp r0.w, r0, r2
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c20.x
pow_pp r2, r0.w, c17.x
mov_pp r0.w, r2.x
add r2.xyz, -v0, c2
mul_pp r0.w, r0, c16.x
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r5.xyz, r2.w, r2
dp4 r2.w, r3, r3
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r5
dp3 r1.w, r4, r2
mul r4.xyz, r4, -r1.w
mad r2.xyz, -r4, c19.y, -r2
add r4.xyz, -v0, c1
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
dp3 r2.w, v3, v3
rsq r2.w, r2.w
mul r5.xyz, r2.w, v3
dp3 r2.w, r5, r3
dp3 r3.w, r4, r4
rsq r3.x, r3.w
mul r3.xyz, r3.x, r4
dp3 r2.y, r2, r3
max r2.w, r2, c19
add_sat r2.w, -r2, c20.x
mad r2.x, r2.w, c20.y, c20.z
max r3.y, r2, c19.w
max r3.x, r2, c19.w
pow r2, r3.y, c7.x
cmp r2.w, r1, c20, c20.x
add r4.w, r0, c5.x
mul r3.w, r4, r3.x
texldp r3.x, v6, s3
texld r0.xyz, r0, s5
mov r4.x, r2
mul r3.xyz, r3.x, c18
mul r2.xyz, r3, c6
mul r2.xyz, r2, r4.x
abs_pp r2.w, r2
cmp r2.xyz, -r2.w, r2, c19.w
mul r3.xyz, r3, c4
max r1.w, r1, c19
mul r6.xyz, r3, r1.w
mov r3.y, r1
mul r4.xy, v2, c10.x
mul r7.xyz, r2, c8.x
mul r2.xy, r4, c21.x
texld r2.xyz, r2, s4
mad r8.xyz, r2, c19.y, c19.z
add r9.xyz, r8, c20.wwxw
mov r4.y, r1.z
mov r2.y, r1.x
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c21.yyzw
dp3 r4.z, r4, -r8
mov r3.z, v4.y
mov r3.x, v5.y
dp3 r1.y, r3, -r9
mov r2.z, v4.x
mov r2.x, v5
dp3 r1.x, r2, -r9
dp3 r4.x, -r8, r2
dp3 r1.w, r1, r1
dp3 r4.y, -r8, r3
rsq r2.y, r1.w
mul r1.xyz, r2.y, r1
dp3 r2.x, r4, r4
rsq r1.w, r2.x
mul r2.xyz, r1.w, r4
dp3_sat r2.w, r5, r1
pow r1, r2.w, c12.x
dp3_sat r2.x, r5, r2
mul r1.y, r2.x, r2.x
pow r2, r1.y, c13.x
mul r1.xyz, r1.x, c15
mov r1.w, r2.x
mad r2.xyz, r1.w, c14, r1
mul r3.xyz, r2, c11.x
mov r1.xyz, c0
mul_pp r0.xyz, r0, r3.w
mad_sat r1.xyz, c4, r1, r6
texld r2.xyz, v2, s2
mad r1.xyz, r2, r1, r7
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r0, r1
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_SparkleTex] 2D
SetTexture 5 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 127 ALU, 6 TEX
PARAM c[22] = { state.lightmodel.ambient,
		program.local[1..18],
		{ 0.5, 2, 1, 0 },
		{ 0.79627001, 0.20373, 20 },
		{ 0, 4 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
DP3 R3.w, c[2], c[2];
RSQ R3.w, R3.w;
TEX R1, R0, texture[0], 2D;
MUL R0.zw, R0.xyxy, c[9].x;
TEX R0, R0.zwzw, texture[1], 2D;
ADD R0, R0, -R1;
MAD R0, R0, c[19].x, R1;
DP4 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R1, R1.x, R0;
MAD R2.xy, R1.wyzw, c[19].y, -c[19].z;
MOV R0.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R3;
MOV R2.z, c[19].w;
DP3 R0.w, R2, R2;
MUL R3.xyz, R2.y, R0;
ADD R0.w, -R0, c[19].z;
RSQ R0.w, R0.w;
DP4 R1.w, R1, R1;
MAD R2.xyz, R2.x, fragment.texcoord[6], R3;
RCP R0.w, R0.w;
MAD R2.xyz, R0.w, fragment.texcoord[5], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R4.xyz, R2, R0.w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
MAD R4.xyz, -R4, c[19].y, fragment.texcoord[4];
DP3 R0.w, R4, R3;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[19].z;
POW R0.w, R0.w, c[17].x;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[19], c[19].z;
ABS R2.w, R2;
MUL R5.xyz, R3.w, c[2];
CMP R2.w, -R2, c[19], c[19].z;
CMP R3.xyz, -R2.w, R3, R5;
DP3 R2.w, R2, R3;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[19].y, -R3;
RSQ R3.x, R1.w;
MUL R1.xyz, R3.x, R1;
MUL R0.w, R0, c[16].x;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R5.xyz, R1.w, fragment.texcoord[4];
DP3 R1.x, R5, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.y, R3, R3;
MAX R1.x, R1, c[19].w;
ADD_SAT R1.w, -R1.x, c[19].z;
RSQ R1.y, R1.y;
MUL R1.xyz, R1.y, R3;
DP3 R1.y, R2, R1;
MAD R1.w, R1, c[20].x, c[20].y;
MAX R1.y, R1, c[19].w;
POW R3.y, R1.y, c[7].x;
SLT R1.y, R2.w, c[19].w;
ABS R3.x, R1.y;
MAX R1.x, R1.w, c[19].w;
ADD R3.w, R0, c[5].x;
MUL R1.w, R3, R1.x;
TXP R1.x, fragment.texcoord[7], texture[3], 2D;
MUL R2.xyz, R1.x, c[18];
MUL R1.xyz, R2, c[6];
MUL R2.xyz, R2, c[4];
MAX R2.w, R2, c[19];
MUL R6.xyz, R2, R2.w;
MOV R2.y, R0;
MUL R1.xyz, R1, R3.y;
CMP R3.x, -R3, c[19].w, c[19].z;
CMP R1.xyz, -R3.x, R1, c[19].w;
MUL R3.xy, fragment.texcoord[3], c[10].x;
MUL R7.xyz, R1, c[8].x;
MUL R1.xy, R3, c[20].z;
TEX R1.xyz, R1, texture[4], 2D;
MAD R8.xyz, R1, c[19].y, -c[19].z;
ADD R9.xyz, R8, c[19].wwzw;
MOV R3.y, R0.z;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R9;
ADD R8.xyz, R8, c[21].xxyw;
DP3 R3.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, R2, -R9;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, R1, -R9;
DP3 R3.x, -R8, R1;
DP3 R3.y, -R8, R2;
DP3 R2.w, R0, R0;
RSQ R1.y, R2.w;
MUL R0.xyz, R1.y, R0;
DP3_SAT R0.y, R5, R0;
DP3 R1.x, R3, R3;
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, R3;
DP3_SAT R0.x, R5, R1;
MUL R1.x, R0, R0;
POW R0.y, R0.y, c[12].x;
MUL R0.xyz, R0.y, c[15];
POW R1.x, R1.x, c[13].x;
MAD R1.xyz, R1.x, c[14], R0;
MUL R2.xyz, R1, c[11].x;
MOV R0.xyz, c[4];
TEX R1.xyz, fragment.texcoord[3], texture[2], 2D;
MAD_SAT R0.xyz, R0, c[0], R6;
MAD R0.xyz, R1, R0, R7;
ADD R1.xyz, R0, R2;
TEX R0.xyz, R4, texture[5], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 127 instructions, 10 R-regs
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_SparkleTex] 2D
SetTexture 5 [_Cube] CUBE
"ps_3_0
; 129 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
def c19, 0.50000000, 2.00000000, -1.00000000, 0.00000000
def c20, 1.00000000, 0.79627001, 0.20373000, 0.00000000
def c21, 20.00000000, 0.00000000, 4.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mad r1.xy, v2, c3, c3.zwzw
mul r0.xy, r1, c9.x
texld r1, r1, s0
texld r0, r0, s1
add r0, r0, -r1
mad r0, r0, c19.x, r1
dp4 r1.x, r0, r0
rsq r1.x, r1.x
mul r3, r1.x, r0
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
dp3 r1.w, c2, c2
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mad r0.xy, r3.wyzw, c19.y, c19.z
mul r2.xyz, r0.y, r1
mov r0.z, c19.w
dp3 r0.z, r0, r0
add r0.z, -r0, c20.x
mad r2.xyz, r0.x, v5, r2
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v4, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
dp3 r0.y, r4, r4
rsq r0.w, r0.y
dp3 r0.x, r4, v3
mul r0.xyz, r4, r0.x
mul r2.xyz, r0.w, r4
mad r0.xyz, -r0, c19.y, v3
dp3_pp r0.w, r0, r2
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c20.x
pow_pp r2, r0.w, c17.x
mov_pp r0.w, r2.x
add r2.xyz, -v0, c2
mul_pp r0.w, r0, c16.x
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r5.xyz, r2.w, r2
dp4 r2.w, r3, r3
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r5
dp3 r1.w, r4, r2
mul r4.xyz, r4, -r1.w
mad r2.xyz, -r4, c19.y, -r2
add r4.xyz, -v0, c1
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
dp3 r2.w, v3, v3
rsq r2.w, r2.w
mul r5.xyz, r2.w, v3
dp3 r2.w, r5, r3
dp3 r3.w, r4, r4
rsq r3.x, r3.w
mul r3.xyz, r3.x, r4
dp3 r2.y, r2, r3
max r2.w, r2, c19
add_sat r2.w, -r2, c20.x
mad r2.x, r2.w, c20.y, c20.z
max r3.y, r2, c19.w
max r3.x, r2, c19.w
pow r2, r3.y, c7.x
cmp r2.w, r1, c20, c20.x
add r4.w, r0, c5.x
mul r3.w, r4, r3.x
texldp r3.x, v6, s3
texld r0.xyz, r0, s5
mov r4.x, r2
mul r3.xyz, r3.x, c18
mul r2.xyz, r3, c6
mul r2.xyz, r2, r4.x
abs_pp r2.w, r2
cmp r2.xyz, -r2.w, r2, c19.w
mul r3.xyz, r3, c4
max r1.w, r1, c19
mul r6.xyz, r3, r1.w
mov r3.y, r1
mul r4.xy, v2, c10.x
mul r7.xyz, r2, c8.x
mul r2.xy, r4, c21.x
texld r2.xyz, r2, s4
mad r8.xyz, r2, c19.y, c19.z
add r9.xyz, r8, c20.wwxw
mov r4.y, r1.z
mov r2.y, r1.x
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c21.yyzw
dp3 r4.z, r4, -r8
mov r3.z, v4.y
mov r3.x, v5.y
dp3 r1.y, r3, -r9
mov r2.z, v4.x
mov r2.x, v5
dp3 r1.x, r2, -r9
dp3 r4.x, -r8, r2
dp3 r1.w, r1, r1
dp3 r4.y, -r8, r3
rsq r2.y, r1.w
mul r1.xyz, r2.y, r1
dp3 r2.x, r4, r4
rsq r1.w, r2.x
mul r2.xyz, r1.w, r4
dp3_sat r2.w, r5, r1
pow r1, r2.w, c12.x
dp3_sat r2.x, r5, r2
mul r1.y, r2.x, r2.x
pow r2, r1.y, c13.x
mul r1.xyz, r1.x, c15
mov r1.w, r2.x
mad r2.xyz, r1.w, c14, r1
mul r3.xyz, r2, c11.x
mov r1.xyz, c0
mul_pp r0.xyz, r0, r3.w
mad_sat r1.xyz, c4, r1, r6
texld r2.xyz, v2, s2
mad r1.xyz, r2, r1, r7
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r0, r1
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_SparkleTex] 2D
SetTexture 5 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 127 ALU, 6 TEX
PARAM c[22] = { state.lightmodel.ambient,
		program.local[1..18],
		{ 0.5, 2, 1, 0 },
		{ 0.79627001, 0.20373, 20 },
		{ 0, 4 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEMP R9;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
DP3 R3.w, c[2], c[2];
RSQ R3.w, R3.w;
TEX R1, R0, texture[0], 2D;
MUL R0.zw, R0.xyxy, c[9].x;
TEX R0, R0.zwzw, texture[1], 2D;
ADD R0, R0, -R1;
MAD R0, R0, c[19].x, R1;
DP4 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R1, R1.x, R0;
MAD R2.xy, R1.wyzw, c[19].y, -c[19].z;
MOV R0.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R3;
MOV R2.z, c[19].w;
DP3 R0.w, R2, R2;
MUL R3.xyz, R2.y, R0;
ADD R0.w, -R0, c[19].z;
RSQ R0.w, R0.w;
DP4 R1.w, R1, R1;
MAD R2.xyz, R2.x, fragment.texcoord[6], R3;
RCP R0.w, R0.w;
MAD R2.xyz, R0.w, fragment.texcoord[5], R2;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R4.xyz, R2, R0.w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
MAD R4.xyz, -R4, c[19].y, fragment.texcoord[4];
DP3 R0.w, R4, R3;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[19].z;
POW R0.w, R0.w, c[17].x;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[19], c[19].z;
ABS R2.w, R2;
MUL R5.xyz, R3.w, c[2];
CMP R2.w, -R2, c[19], c[19].z;
CMP R3.xyz, -R2.w, R3, R5;
DP3 R2.w, R2, R3;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[19].y, -R3;
RSQ R3.x, R1.w;
MUL R1.xyz, R3.x, R1;
MUL R0.w, R0, c[16].x;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R5.xyz, R1.w, fragment.texcoord[4];
DP3 R1.x, R5, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.y, R3, R3;
MAX R1.x, R1, c[19].w;
ADD_SAT R1.w, -R1.x, c[19].z;
RSQ R1.y, R1.y;
MUL R1.xyz, R1.y, R3;
DP3 R1.y, R2, R1;
MAD R1.w, R1, c[20].x, c[20].y;
MAX R1.y, R1, c[19].w;
POW R3.y, R1.y, c[7].x;
SLT R1.y, R2.w, c[19].w;
ABS R3.x, R1.y;
MAX R1.x, R1.w, c[19].w;
ADD R3.w, R0, c[5].x;
MUL R1.w, R3, R1.x;
TXP R1.x, fragment.texcoord[7], texture[3], 2D;
MUL R2.xyz, R1.x, c[18];
MUL R1.xyz, R2, c[6];
MUL R2.xyz, R2, c[4];
MAX R2.w, R2, c[19];
MUL R6.xyz, R2, R2.w;
MOV R2.y, R0;
MUL R1.xyz, R1, R3.y;
CMP R3.x, -R3, c[19].w, c[19].z;
CMP R1.xyz, -R3.x, R1, c[19].w;
MUL R3.xy, fragment.texcoord[3], c[10].x;
MUL R7.xyz, R1, c[8].x;
MUL R1.xy, R3, c[20].z;
TEX R1.xyz, R1, texture[4], 2D;
MAD R8.xyz, R1, c[19].y, -c[19].z;
ADD R9.xyz, R8, c[19].wwzw;
MOV R3.y, R0.z;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R9;
ADD R8.xyz, R8, c[21].xxyw;
DP3 R3.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, R2, -R9;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, R1, -R9;
DP3 R3.x, -R8, R1;
DP3 R3.y, -R8, R2;
DP3 R2.w, R0, R0;
RSQ R1.y, R2.w;
MUL R0.xyz, R1.y, R0;
DP3_SAT R0.y, R5, R0;
DP3 R1.x, R3, R3;
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, R3;
DP3_SAT R0.x, R5, R1;
MUL R1.x, R0, R0;
POW R0.y, R0.y, c[12].x;
MUL R0.xyz, R0.y, c[15];
POW R1.x, R1.x, c[13].x;
MAD R1.xyz, R1.x, c[14], R0;
MUL R2.xyz, R1, c[11].x;
MOV R0.xyz, c[4];
TEX R1.xyz, fragment.texcoord[3], texture[2], 2D;
MAD_SAT R0.xyz, R0, c[0], R6;
MAD R0.xyz, R1, R0, R7;
ADD R1.xyz, R0, R2;
TEX R0.xyz, R4, texture[5], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 127 instructions, 10 R-regs
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
Float 9 [_BumeMap2Scale]
Float 10 [_FlakeScale]
Float 11 [_FlakePower]
Float 12 [_InterFlakePower]
Float 13 [_OuterFlakePower]
Vector 14 [_paintColor2]
Vector 15 [_flakeLayerColor]
Float 16 [_FrezPow]
Float 17 [_FrezFalloff]
Vector 18 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_SparkleTex] 2D
SetTexture 5 [_Cube] CUBE
"ps_3_0
; 129 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
def c19, 0.50000000, 2.00000000, -1.00000000, 0.00000000
def c20, 1.00000000, 0.79627001, 0.20373000, 0.00000000
def c21, 20.00000000, 0.00000000, 4.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mad r1.xy, v2, c3, c3.zwzw
mul r0.xy, r1, c9.x
texld r1, r1, s0
texld r0, r0, s1
add r0, r0, -r1
mad r0, r0, c19.x, r1
dp4 r1.x, r0, r0
rsq r1.x, r1.x
mul r3, r1.x, r0
mov r1.xyz, v5
mul r2.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
dp3 r1.w, c2, c2
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mad r0.xy, r3.wyzw, c19.y, c19.z
mul r2.xyz, r0.y, r1
mov r0.z, c19.w
dp3 r0.z, r0, r0
add r0.z, -r0, c20.x
mad r2.xyz, r0.x, v5, r2
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v4, r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r4.xyz, r0.w, r0
dp3 r0.y, r4, r4
rsq r0.w, r0.y
dp3 r0.x, r4, v3
mul r0.xyz, r4, r0.x
mul r2.xyz, r0.w, r4
mad r0.xyz, -r0, c19.y, v3
dp3_pp r0.w, r0, r2
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c20.x
pow_pp r2, r0.w, c17.x
mov_pp r0.w, r2.x
add r2.xyz, -v0, c2
mul_pp r0.w, r0, c16.x
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r5.xyz, r2.w, r2
dp4 r2.w, r3, r3
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r5
dp3 r1.w, r4, r2
mul r4.xyz, r4, -r1.w
mad r2.xyz, -r4, c19.y, -r2
add r4.xyz, -v0, c1
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
dp3 r2.w, v3, v3
rsq r2.w, r2.w
mul r5.xyz, r2.w, v3
dp3 r2.w, r5, r3
dp3 r3.w, r4, r4
rsq r3.x, r3.w
mul r3.xyz, r3.x, r4
dp3 r2.y, r2, r3
max r2.w, r2, c19
add_sat r2.w, -r2, c20.x
mad r2.x, r2.w, c20.y, c20.z
max r3.y, r2, c19.w
max r3.x, r2, c19.w
pow r2, r3.y, c7.x
cmp r2.w, r1, c20, c20.x
add r4.w, r0, c5.x
mul r3.w, r4, r3.x
texldp r3.x, v6, s3
texld r0.xyz, r0, s5
mov r4.x, r2
mul r3.xyz, r3.x, c18
mul r2.xyz, r3, c6
mul r2.xyz, r2, r4.x
abs_pp r2.w, r2
cmp r2.xyz, -r2.w, r2, c19.w
mul r3.xyz, r3, c4
max r1.w, r1, c19
mul r6.xyz, r3, r1.w
mov r3.y, r1
mul r4.xy, v2, c10.x
mul r7.xyz, r2, c8.x
mul r2.xy, r4, c21.x
texld r2.xyz, r2, s4
mad r8.xyz, r2, c19.y, c19.z
add r9.xyz, r8, c20.wwxw
mov r4.y, r1.z
mov r2.y, r1.x
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c21.yyzw
dp3 r4.z, r4, -r8
mov r3.z, v4.y
mov r3.x, v5.y
dp3 r1.y, r3, -r9
mov r2.z, v4.x
mov r2.x, v5
dp3 r1.x, r2, -r9
dp3 r4.x, -r8, r2
dp3 r1.w, r1, r1
dp3 r4.y, -r8, r3
rsq r2.y, r1.w
mul r1.xyz, r2.y, r1
dp3 r2.x, r4, r4
rsq r1.w, r2.x
mul r2.xyz, r1.w, r4
dp3_sat r2.w, r5, r1
pow r1, r2.w, c12.x
dp3_sat r2.x, r5, r2
mul r1.y, r2.x, r2.x
pow r2, r1.y, c13.x
mul r1.xyz, r1.x, c15
mov r1.w, r2.x
mad r2.xyz, r1.w, c14, r1
mul r3.xyz, r2, c11.x
mov r1.xyz, c0
mul_pp r0.xyz, r0, r3.w
mad_sat r1.xyz, c4, r1, r6
texld r2.xyz, v2, s2
mad r1.xyz, r2, r1, r7
add_pp r1.xyz, r1, r3
add_pp r1.xyz, r0, r1
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

#LINE 329

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
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD1.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD1.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5))).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD2;
  tmpvar_4[1] = xlv_TEXCOORD4;
  tmpvar_4[2] = xlv_TEXCOORD3;
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
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_8)));
    lightDirection = normalize (tmpvar_8);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (tmpvar_9 + specularReflection);
  gl_FragData[0] = tmpvar_11;
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
uniform sampler2D _BumpMap2;
uniform sampler2D _BumpMap;
uniform highp float _BumeMap2Scale;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 localCoords;
  highp vec4 encodedNormal2;
  highp vec4 encodedNormal1;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD1.xy) + _BumpMap_ST.zw));
  encodedNormal1 = tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap2, (((_BumpMap_ST.xy * xlv_TEXCOORD1.xy) + _BumpMap_ST.zw) * _BumeMap2Scale));
  encodedNormal2 = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * normalize (mix (encodedNormal1, encodedNormal2, vec4(0.5, 0.5, 0.5, 0.5))).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp mat3 tmpvar_4;
  tmpvar_4[0] = xlv_TEXCOORD2;
  tmpvar_4[1] = xlv_TEXCOORD4;
  tmpvar_4[2] = xlv_TEXCOORD3;
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
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_8)));
    lightDirection = normalize (tmpvar_8);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_6, lightDirection)));
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_6, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_6), tmpvar_7)), _Shininess));
  };
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (tmpvar_9 + specularReflection);
  gl_FragData[0] = tmpvar_11;
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
//   opengl - ALU: 55 to 55, TEX: 2 to 2
//   d3d9 - ALU: 58 to 58, TEX: 2 to 2
SubProgram "opengl " {
Keywords { }
Vector 0 [_BumpMap_ST]
Vector 1 [_Color]
Vector 2 [_SpecColor]
Float 3 [_Shininess]
Float 4 [_BumeMap2Scale]
Vector 5 [_WorldSpaceCameraPos]
Vector 6 [_WorldSpaceLightPos0]
Vector 7 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
"!!ARBfp1.0
# 55 ALU, 2 TEX
PARAM c[9] = { program.local[0..7],
		{ 0, 1, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MAD R0.xy, fragment.texcoord[1], c[0], c[0].zwzw;
ADD R3.xyz, -fragment.texcoord[0], c[5];
MUL R0.zw, R0.xyxy, c[4].x;
MOV result.color.w, c[8].y;
TEX R1, R0, texture[0], 2D;
TEX R0, R0.zwzw, texture[1], 2D;
ADD R0, R0, -R1;
MAD R0, R0, c[8].z, R1;
DP4 R0.x, R0, R0;
RSQ R0.x, R0.x;
MUL R0.xy, R0.x, R0.ywzw;
MAD R0.xy, R0.yxzw, c[8].w, -c[8].y;
MUL R1.xyz, R0.y, fragment.texcoord[4];
MOV R0.z, c[8].x;
DP3 R0.z, R0, R0;
ADD R0.z, -R0, c[8].y;
MAD R1.xyz, R0.x, fragment.texcoord[2], R1;
RSQ R0.y, R0.z;
RCP R0.x, R0.y;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
DP3 R1.w, R0, R0;
RSQ R2.x, R1.w;
MUL R0.xyz, R2.x, R0;
ADD R1.xyz, -fragment.texcoord[0], c[6];
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
ABS R0.w, -c[6];
DP3 R2.x, c[6], c[6];
CMP R0.w, -R0, c[8].x, c[8].y;
RSQ R2.x, R2.x;
ABS R0.w, R0;
MUL R2.xyz, R2.x, c[6];
CMP R0.w, -R0, c[8].x, c[8].y;
MUL R1.xyz, R1.w, R1;
CMP R1.xyz, -R0.w, R1, R2;
DP3 R2.w, R0, R1;
DP3 R2.x, R3, R3;
RSQ R2.x, R2.x;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[8].w, -R1;
MUL R2.xyz, R2.x, R3;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[8];
POW R2.x, R0.x, c[3].x;
CMP R0.x, -R0.w, R1.w, c[8].y;
MUL R0.xyz, R0.x, c[7];
MUL R1.xyz, R0, c[2];
SLT R0.w, R2, c[8].x;
ABS R0.w, R0;
CMP R0.w, -R0, c[8].x, c[8].y;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[8].x;
MAX R0.w, R2, c[8].x;
MUL R0.xyz, R0, c[1];
MAD result.color.xyz, R0, R0.w, R1;
END
# 55 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_BumpMap_ST]
Vector 1 [_Color]
Vector 2 [_SpecColor]
Float 3 [_Shininess]
Float 4 [_BumeMap2Scale]
Vector 5 [_WorldSpaceCameraPos]
Vector 6 [_WorldSpaceLightPos0]
Vector 7 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_BumpMap2] 2D
"ps_2_0
; 58 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c8, 1.00000000, 0.00000000, 0.50000000, 2.00000000
def c9, 2.00000000, -1.00000000, 0, 0
dcl t0.xyz
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
mov r2.z, c8.y
add r5.xyz, -t0, c5
mov r0.y, c0.w
mov r0.x, c0.z
mad r0.xy, t1, c0, r0
mul r1.xy, r0, c4.x
texld r0, r0, s0
texld r1, r1, s1
add r1, r1, -r0
mad r0, r1, c8.z, r0
dp4 r0.x, r0, r0
rsq r0.x, r0.x
mul r0.yw, r0.x, r0
mov r0.x, r0.w
mad r2.xy, r0, c9.x, c9.y
dp3 r0.x, r2, r2
mul r1.xyz, r2.y, t4
mad r1.xyz, r2.x, t2, r1
add r0.x, -r0, c8
rsq r0.x, r0.x
rcp r0.x, r0.x
mad r3.xyz, r0.x, t3, r1
add r2.xyz, -t0, c6
dp3 r0.x, r2, r2
dp3 r1.x, r3, r3
rsq r1.x, r1.x
mul r4.xyz, r1.x, r3
rsq r0.x, r0.x
mul r3.xyz, r0.x, r2
dp3 r2.x, c6, c6
rsq r2.x, r2.x
abs r1.x, -c6.w
cmp r1.x, -r1, c8, c8.y
mul r6.xyz, r2.x, c6
abs_pp r2.x, r1
cmp r6.xyz, -r2.x, r3, r6
dp3 r1.x, r4, r6
mul r4.xyz, -r1.x, r4
dp3 r3.x, r5, r5
rsq r3.x, r3.x
mul r3.xyz, r3.x, r5
mad r4.xyz, -r4, c8.w, -r6
dp3 r3.x, r4, r3
max r3.x, r3, c8.y
pow r4.w, r3.x, c3.x
cmp r0.x, -r2, r0, c8
mul r3.xyz, r0.x, c7
mov r2.x, r4.w
cmp r0.x, r1, c8.y, c8
mul r4.xyz, r3, c2
abs_pp r0.x, r0
mul r2.xyz, r4, r2.x
cmp r2.xyz, -r0.x, r2, c8.y
max r0.x, r1, c8.y
mul r1.xyz, r3, c1
mov r0.w, c8.x
mad r0.xyz, r1, r0.x, r2
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

#LINE 471

      }
	  
	  
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}