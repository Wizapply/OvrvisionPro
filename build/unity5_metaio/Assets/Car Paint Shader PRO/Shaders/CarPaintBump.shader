Shader "RedDotGames/Car Paint with Bump" {
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
  };
  highp vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * _Gloss);
  specularReflection = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_19;
  tmpvar_19[0] = xlv_TEXCOORD6;
  tmpvar_19[1] = tmpvar_4;
  tmpvar_19[2] = xlv_TEXCOORD5;
  mat3 tmpvar_20;
  tmpvar_20[0].x = tmpvar_19[0].x;
  tmpvar_20[0].y = tmpvar_19[1].x;
  tmpvar_20[0].z = tmpvar_19[2].x;
  tmpvar_20[1].x = tmpvar_19[0].y;
  tmpvar_20[1].y = tmpvar_19[1].y;
  tmpvar_20[1].z = tmpvar_19[2].y;
  tmpvar_20[2].x = tmpvar_19[0].z;
  tmpvar_20[2].y = tmpvar_19[1].z;
  tmpvar_20[2].z = tmpvar_19[2].z;
  mat3 tmpvar_21;
  tmpvar_21[0].x = tmpvar_20[0].x;
  tmpvar_21[0].y = tmpvar_20[1].x;
  tmpvar_21[0].z = tmpvar_20[2].x;
  tmpvar_21[1].x = tmpvar_20[0].y;
  tmpvar_21[1].y = tmpvar_20[1].y;
  tmpvar_21[1].z = tmpvar_20[2].y;
  tmpvar_21[2].x = tmpvar_20[0].z;
  tmpvar_21[2].y = tmpvar_20[1].z;
  tmpvar_21[2].z = tmpvar_20[2].z;
  highp float tmpvar_22;
  tmpvar_22 = clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_18), 0.0, 1.0);
  highp vec4 tmpvar_23;
  tmpvar_23 = ((pow ((tmpvar_22 * tmpvar_22), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_21 * -((tmpvar_17 + vec3(0.0, 0.0, 1.0))))), tmpvar_18), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = (frez * _FrezPow);
  frez = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_25.xyz * ((_Reflection + tmpvar_28) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
  reflTex.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((textureColor.xyz * clamp ((tmpvar_12 + tmpvar_13), 0.0, 1.0)) + tmpvar_15);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (paintColor * _FlakePower));
  color = tmpvar_31;
  color = ((color + reflTex) + (tmpvar_28 * reflTex));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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
uniform sampler2D _BumpMap;
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
  highp vec4 encodedNormal;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw));
  encodedNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3.z = 0.0;
  tmpvar_3.xy = ((2.0 * encodedNormal.wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_3;
  localCoords.z = sqrt ((1.0 - dot (tmpvar_3, tmpvar_3)));
  highp vec3 tmpvar_4;
  tmpvar_4 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp mat3 tmpvar_5;
  tmpvar_5[0] = xlv_TEXCOORD6;
  tmpvar_5[1] = tmpvar_4;
  tmpvar_5[2] = xlv_TEXCOORD5;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((localCoords * tmpvar_6));
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_MainTex, tmpvar_9);
  textureColor = tmpvar_10;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_11;
    tmpvar_11 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_11;
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_12)));
    lightDirection = normalize (tmpvar_12);
  };
  lowp float tmpvar_13;
  tmpvar_13 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, lightDirection)));
  highp float tmpvar_16;
  tmpvar_16 = dot (tmpvar_7, lightDirection);
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_7), tmpvar_8)), _Shininess));
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
  tmpvar_21[1] = tmpvar_4;
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
  tmpvar_26 = reflect (xlv_TEXCOORD4, tmpvar_7);
  reflectedDir = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (abs (dot (reflectedDir, normalize (tmpvar_7))), 0.0, 1.0);
  SurfAngle = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = (frez * _FrezPow);
  frez = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_27.xyz * ((_Reflection + tmpvar_30) * max ((0.20373 + ((1.0 - 0.20373) * pow (clamp ((1.0 - max (dot (normalize (xlv_TEXCOORD4), normalize (encodedNormal).xyz), 0.0)), 0.0, 1.0), 1.0))), 0.0)));
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

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 120 to 121, TEX: 4 to 5
//   d3d9 - ALU: 122 to 123, TEX: 4 to 5
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 120 ALU, 4 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 20, 0, 4 } };
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
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R1.xy, R0.wyzw, c[18].x, -c[18].y;
MUL R3.xyz, R1.y, R2;
MOV R1.z, c[18];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[18].y;
RSQ R1.y, R1.z;
MAD R3.xyz, R1.x, fragment.texcoord[6], R3;
RCP R1.x, R1.y;
MAD R3.xyz, R1.x, fragment.texcoord[5], R3;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
DP3 R2.w, R1, R1;
RSQ R1.w, R1.w;
MUL R6.xyz, R1.w, R3;
RSQ R2.w, R2.w;
MUL R1.xyz, R2.w, R1;
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[18].z, c[18].y;
ABS R1.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[18].z, c[18].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R6, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R6, -R1.w;
SLT R2.w, R1, c[18].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[18].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.x, R1, R4;
MAX R3.x, R1, c[18].z;
MUL R4.xy, fragment.texcoord[3], c[9].x;
MOV R1.xyz, c[6];
MUL R5.xy, R4, c[19].y;
POW R3.x, R3.x, c[7].x;
MUL R1.xyz, R1, c[17];
MUL R1.xyz, R1, R3.x;
CMP R2.w, -R2, c[18].z, c[18].y;
CMP R1.xyz, -R2.w, R1, c[18].z;
MOV R3.xyz, c[4];
MUL R8.xyz, R1, c[8].x;
MUL R1.xyz, R3, c[17];
MAX R1.w, R1, c[18].z;
MUL R4.xyz, R1, R1.w;
MAD_SAT R7.xyz, R3, c[0], R4;
TEX R1.xyz, R5, texture[2], 2D;
MAD R9.xyz, R1, c[18].x, -c[18].y;
MOV R5.y, R2.z;
ADD R1.xyz, R9, c[19].zzww;
MOV R3.y, R2.x;
MOV R4.y, R2;
MOV R5.x, fragment.texcoord[6].z;
MOV R5.z, fragment.texcoord[5];
DP3 R2.z, R5, -R1;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R2.x, -R1, R3;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R1, R4;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R1.xyz, R1, R7, R8;
ADD R7.xyz, R9, c[18].zzyw;
DP3 R5.z, R5, -R7;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R5.x, R3, -R7;
DP3 R5.y, R4, -R7;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R2;
DP3 R2.w, R5, R5;
RSQ R2.w, R2.w;
MUL R4.xyz, R2.w, R5;
DP3_SAT R2.w, R3, R4;
POW R2.x, R2.w, c[11].x;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[12].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R1.w, c[13], R2;
MUL R4.xyz, R2, c[10].x;
DP3 R1.w, R6, fragment.texcoord[4];
MUL R2.xyz, R6, R1.w;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
DP3 R0.w, R6, R6;
MAX R0.y, R0, c[18].z;
ADD_SAT R0.y, -R0, c[18];
MUL R0.y, R0, c[18].w;
ADD R0.y, R0, c[19].x;
ADD R1.xyz, R1, R4;
RSQ R0.w, R0.w;
MAD R2.xyz, -R2, c[18].x, fragment.texcoord[4];
MUL R4.xyz, R0.w, R6;
DP3 R0.x, R2, R4;
ABS_SAT R0.x, R0;
ADD R0.x, -R0, c[18].y;
POW R0.x, R0.x, c[16].x;
MUL R0.w, R0.x, c[15].x;
MAX R0.y, R0, c[18].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R2, texture[3], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 120 instructions, 10 R-regs
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 123 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c18, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c19, 0.79627001, 0.20373000, 20.00000000, 0
def c20, 0.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mad r2.xy, r0.wyzw, c18.x, c18.y
mov r2.z, c18
dp3 r1.w, r2, r2
mul r3.xyz, r2.y, r1
add r1.w, -r1, c18
rsq r1.w, r1.w
mad r2.xyz, r2.x, v5, r3
rcp r1.w, r1.w
mad r3.xyz, r1.w, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r3, r3
rsq r1.w, r1.w
mul r5.xyz, r1.w, r3
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r2.w, r5, r2
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r3.xyz, r5, -r2.w
mul r4.xyz, r1.w, r4
mad r2.xyz, -r3, c18.x, -r2
dp3 r1.w, r2, r4
max r2.x, r1.w, c18.z
pow r3, r2.x, c7.x
mov r3.w, r3.x
cmp r1.w, r2, c18.z, c18
mul r2.xy, v2, c9.x
mul r2.xy, r2, c19.z
texld r2.xyz, r2, s2
mad r7.xyz, r2, c18.x, c18.y
add r8.xyz, r7, c20.xxyw
mov r3.xyz, c17
mul r3.xyz, c6, r3
mul r6.xyz, r3, r3.w
abs_pp r1.w, r1
mov r4.y, r1.z
mov r3.y, r1.x
mov r2.y, r1
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r8
add r7.xyz, r7, c18.zzww
dp3 r4.z, r4, -r7
mov r3.z, v4.x
mov r3.x, v5
dp3 r4.x, r3, -r7
dp3 r1.x, -r8, r3
mov r2.z, v4.y
mov r2.x, v5.y
dp3 r1.y, -r8, r2
dp3 r4.y, r2, -r7
dp3 r2.x, r4, r4
rsq r2.x, r2.x
mul r3.xyz, r2.x, r4
mov r4.xyz, c17
dp3 r3.w, r1, r1
cmp r6.xyz, -r1.w, r6, c18.z
rsq r1.w, r3.w
mul r1.xyz, r1.w, r1
dp3 r1.w, v3, v3
rsq r1.w, r1.w
mul r2.xyz, r1.w, v3
dp3_sat r3.y, r2, r3
dp3_sat r3.x, r2, r1
pow r1, r3.y, c11.x
mul r1.y, r3.x, r3.x
pow r3, r1.y, c12.x
mov r1.w, r3.x
mul r1.xyz, r1.x, c14
mad r3.xyz, r1.w, c13, r1
mul r1.xyz, r6, c8.x
max r1.w, r2, c18.z
mul r4.xyz, c4, r4
mul r6.xyz, r4, r1.w
mov r4.xyz, c0
mad_sat r6.xyz, c4, r4, r6
texld r4.xyz, v2, s1
dp3 r1.w, r5, r5
mad r1.xyz, r4, r6, r1
rsq r1.w, r1.w
mul r4.xyz, r1.w, r5
dp4 r1.w, r0, r0
rsq r1.w, r1.w
mul r0.xyz, r1.w, r0
mul r3.xyz, r3, c10.x
add_pp r3.xyz, r1, r3
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
mad r1.xyz, -r1, c18.x, v3
dp3_pp r0.w, r1, r4
abs_pp_sat r0.w, r0
add_pp r1.w, -r0, c18
dp3 r2.x, r2, r0
pow_pp r0, r1.w, c16.x
max r0.y, r2.x, c18.z
mul_pp r0.w, r0.x, c15.x
add_sat r0.y, -r0, c18.w
mad r0.y, r0, c19.x, c19
max r0.y, r0, c18.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s3
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r3
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 120 ALU, 4 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 20, 0, 4 } };
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
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R1.xy, R0.wyzw, c[18].x, -c[18].y;
MUL R3.xyz, R1.y, R2;
MOV R1.z, c[18];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[18].y;
RSQ R1.y, R1.z;
MAD R3.xyz, R1.x, fragment.texcoord[6], R3;
RCP R1.x, R1.y;
MAD R3.xyz, R1.x, fragment.texcoord[5], R3;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
DP3 R2.w, R1, R1;
RSQ R1.w, R1.w;
MUL R6.xyz, R1.w, R3;
RSQ R2.w, R2.w;
MUL R1.xyz, R2.w, R1;
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[18].z, c[18].y;
ABS R1.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[18].z, c[18].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R6, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R6, -R1.w;
SLT R2.w, R1, c[18].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[18].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.x, R1, R4;
MAX R3.x, R1, c[18].z;
MUL R4.xy, fragment.texcoord[3], c[9].x;
MOV R1.xyz, c[6];
MUL R5.xy, R4, c[19].y;
POW R3.x, R3.x, c[7].x;
MUL R1.xyz, R1, c[17];
MUL R1.xyz, R1, R3.x;
CMP R2.w, -R2, c[18].z, c[18].y;
CMP R1.xyz, -R2.w, R1, c[18].z;
MOV R3.xyz, c[4];
MUL R8.xyz, R1, c[8].x;
MUL R1.xyz, R3, c[17];
MAX R1.w, R1, c[18].z;
MUL R4.xyz, R1, R1.w;
MAD_SAT R7.xyz, R3, c[0], R4;
TEX R1.xyz, R5, texture[2], 2D;
MAD R9.xyz, R1, c[18].x, -c[18].y;
MOV R5.y, R2.z;
ADD R1.xyz, R9, c[19].zzww;
MOV R3.y, R2.x;
MOV R4.y, R2;
MOV R5.x, fragment.texcoord[6].z;
MOV R5.z, fragment.texcoord[5];
DP3 R2.z, R5, -R1;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R2.x, -R1, R3;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R1, R4;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R1.xyz, R1, R7, R8;
ADD R7.xyz, R9, c[18].zzyw;
DP3 R5.z, R5, -R7;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R5.x, R3, -R7;
DP3 R5.y, R4, -R7;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R2;
DP3 R2.w, R5, R5;
RSQ R2.w, R2.w;
MUL R4.xyz, R2.w, R5;
DP3_SAT R2.w, R3, R4;
POW R2.x, R2.w, c[11].x;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[12].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R1.w, c[13], R2;
MUL R4.xyz, R2, c[10].x;
DP3 R1.w, R6, fragment.texcoord[4];
MUL R2.xyz, R6, R1.w;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
DP3 R0.w, R6, R6;
MAX R0.y, R0, c[18].z;
ADD_SAT R0.y, -R0, c[18];
MUL R0.y, R0, c[18].w;
ADD R0.y, R0, c[19].x;
ADD R1.xyz, R1, R4;
RSQ R0.w, R0.w;
MAD R2.xyz, -R2, c[18].x, fragment.texcoord[4];
MUL R4.xyz, R0.w, R6;
DP3 R0.x, R2, R4;
ABS_SAT R0.x, R0;
ADD R0.x, -R0, c[18].y;
POW R0.x, R0.x, c[16].x;
MUL R0.w, R0.x, c[15].x;
MAX R0.y, R0, c[18].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R2, texture[3], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 120 instructions, 10 R-regs
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 123 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c18, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c19, 0.79627001, 0.20373000, 20.00000000, 0
def c20, 0.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mad r2.xy, r0.wyzw, c18.x, c18.y
mov r2.z, c18
dp3 r1.w, r2, r2
mul r3.xyz, r2.y, r1
add r1.w, -r1, c18
rsq r1.w, r1.w
mad r2.xyz, r2.x, v5, r3
rcp r1.w, r1.w
mad r3.xyz, r1.w, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r3, r3
rsq r1.w, r1.w
mul r5.xyz, r1.w, r3
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r2.w, r5, r2
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r3.xyz, r5, -r2.w
mul r4.xyz, r1.w, r4
mad r2.xyz, -r3, c18.x, -r2
dp3 r1.w, r2, r4
max r2.x, r1.w, c18.z
pow r3, r2.x, c7.x
mov r3.w, r3.x
cmp r1.w, r2, c18.z, c18
mul r2.xy, v2, c9.x
mul r2.xy, r2, c19.z
texld r2.xyz, r2, s2
mad r7.xyz, r2, c18.x, c18.y
add r8.xyz, r7, c20.xxyw
mov r3.xyz, c17
mul r3.xyz, c6, r3
mul r6.xyz, r3, r3.w
abs_pp r1.w, r1
mov r4.y, r1.z
mov r3.y, r1.x
mov r2.y, r1
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r8
add r7.xyz, r7, c18.zzww
dp3 r4.z, r4, -r7
mov r3.z, v4.x
mov r3.x, v5
dp3 r4.x, r3, -r7
dp3 r1.x, -r8, r3
mov r2.z, v4.y
mov r2.x, v5.y
dp3 r1.y, -r8, r2
dp3 r4.y, r2, -r7
dp3 r2.x, r4, r4
rsq r2.x, r2.x
mul r3.xyz, r2.x, r4
mov r4.xyz, c17
dp3 r3.w, r1, r1
cmp r6.xyz, -r1.w, r6, c18.z
rsq r1.w, r3.w
mul r1.xyz, r1.w, r1
dp3 r1.w, v3, v3
rsq r1.w, r1.w
mul r2.xyz, r1.w, v3
dp3_sat r3.y, r2, r3
dp3_sat r3.x, r2, r1
pow r1, r3.y, c11.x
mul r1.y, r3.x, r3.x
pow r3, r1.y, c12.x
mov r1.w, r3.x
mul r1.xyz, r1.x, c14
mad r3.xyz, r1.w, c13, r1
mul r1.xyz, r6, c8.x
max r1.w, r2, c18.z
mul r4.xyz, c4, r4
mul r6.xyz, r4, r1.w
mov r4.xyz, c0
mad_sat r6.xyz, c4, r4, r6
texld r4.xyz, v2, s1
dp3 r1.w, r5, r5
mad r1.xyz, r4, r6, r1
rsq r1.w, r1.w
mul r4.xyz, r1.w, r5
dp4 r1.w, r0, r0
rsq r1.w, r1.w
mul r0.xyz, r1.w, r0
mul r3.xyz, r3, c10.x
add_pp r3.xyz, r1, r3
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
mad r1.xyz, -r1, c18.x, v3
dp3_pp r0.w, r1, r4
abs_pp_sat r0.w, r0
add_pp r1.w, -r0, c18
dp3 r2.x, r2, r0
pow_pp r0, r1.w, c16.x
max r0.y, r2.x, c18.z
mul_pp r0.w, r0.x, c15.x
add_sat r0.y, -r0, c18.w
mad r0.y, r0, c19.x, c19
max r0.y, r0, c18.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s3
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r3
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 120 ALU, 4 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 20, 0, 4 } };
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
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R1.xy, R0.wyzw, c[18].x, -c[18].y;
MUL R3.xyz, R1.y, R2;
MOV R1.z, c[18];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[18].y;
RSQ R1.y, R1.z;
MAD R3.xyz, R1.x, fragment.texcoord[6], R3;
RCP R1.x, R1.y;
MAD R3.xyz, R1.x, fragment.texcoord[5], R3;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
DP3 R2.w, R1, R1;
RSQ R1.w, R1.w;
MUL R6.xyz, R1.w, R3;
RSQ R2.w, R2.w;
MUL R1.xyz, R2.w, R1;
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[18].z, c[18].y;
ABS R1.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[18].z, c[18].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R6, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R6, -R1.w;
SLT R2.w, R1, c[18].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[18].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.x, R1, R4;
MAX R3.x, R1, c[18].z;
MUL R4.xy, fragment.texcoord[3], c[9].x;
MOV R1.xyz, c[6];
MUL R5.xy, R4, c[19].y;
POW R3.x, R3.x, c[7].x;
MUL R1.xyz, R1, c[17];
MUL R1.xyz, R1, R3.x;
CMP R2.w, -R2, c[18].z, c[18].y;
CMP R1.xyz, -R2.w, R1, c[18].z;
MOV R3.xyz, c[4];
MUL R8.xyz, R1, c[8].x;
MUL R1.xyz, R3, c[17];
MAX R1.w, R1, c[18].z;
MUL R4.xyz, R1, R1.w;
MAD_SAT R7.xyz, R3, c[0], R4;
TEX R1.xyz, R5, texture[2], 2D;
MAD R9.xyz, R1, c[18].x, -c[18].y;
MOV R5.y, R2.z;
ADD R1.xyz, R9, c[19].zzww;
MOV R3.y, R2.x;
MOV R4.y, R2;
MOV R5.x, fragment.texcoord[6].z;
MOV R5.z, fragment.texcoord[5];
DP3 R2.z, R5, -R1;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R2.x, -R1, R3;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R1, R4;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R1.xyz, R1, R7, R8;
ADD R7.xyz, R9, c[18].zzyw;
DP3 R5.z, R5, -R7;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R5.x, R3, -R7;
DP3 R5.y, R4, -R7;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R2;
DP3 R2.w, R5, R5;
RSQ R2.w, R2.w;
MUL R4.xyz, R2.w, R5;
DP3_SAT R2.w, R3, R4;
POW R2.x, R2.w, c[11].x;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[12].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R1.w, c[13], R2;
MUL R4.xyz, R2, c[10].x;
DP3 R1.w, R6, fragment.texcoord[4];
MUL R2.xyz, R6, R1.w;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
DP3 R0.w, R6, R6;
MAX R0.y, R0, c[18].z;
ADD_SAT R0.y, -R0, c[18];
MUL R0.y, R0, c[18].w;
ADD R0.y, R0, c[19].x;
ADD R1.xyz, R1, R4;
RSQ R0.w, R0.w;
MAD R2.xyz, -R2, c[18].x, fragment.texcoord[4];
MUL R4.xyz, R0.w, R6;
DP3 R0.x, R2, R4;
ABS_SAT R0.x, R0;
ADD R0.x, -R0, c[18].y;
POW R0.x, R0.x, c[16].x;
MUL R0.w, R0.x, c[15].x;
MAX R0.y, R0, c[18].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R2, texture[3], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 120 instructions, 10 R-regs
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 123 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c18, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c19, 0.79627001, 0.20373000, 20.00000000, 0
def c20, 0.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mad r2.xy, r0.wyzw, c18.x, c18.y
mov r2.z, c18
dp3 r1.w, r2, r2
mul r3.xyz, r2.y, r1
add r1.w, -r1, c18
rsq r1.w, r1.w
mad r2.xyz, r2.x, v5, r3
rcp r1.w, r1.w
mad r3.xyz, r1.w, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r3, r3
rsq r1.w, r1.w
mul r5.xyz, r1.w, r3
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r2.w, r5, r2
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r3.xyz, r5, -r2.w
mul r4.xyz, r1.w, r4
mad r2.xyz, -r3, c18.x, -r2
dp3 r1.w, r2, r4
max r2.x, r1.w, c18.z
pow r3, r2.x, c7.x
mov r3.w, r3.x
cmp r1.w, r2, c18.z, c18
mul r2.xy, v2, c9.x
mul r2.xy, r2, c19.z
texld r2.xyz, r2, s2
mad r7.xyz, r2, c18.x, c18.y
add r8.xyz, r7, c20.xxyw
mov r3.xyz, c17
mul r3.xyz, c6, r3
mul r6.xyz, r3, r3.w
abs_pp r1.w, r1
mov r4.y, r1.z
mov r3.y, r1.x
mov r2.y, r1
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r8
add r7.xyz, r7, c18.zzww
dp3 r4.z, r4, -r7
mov r3.z, v4.x
mov r3.x, v5
dp3 r4.x, r3, -r7
dp3 r1.x, -r8, r3
mov r2.z, v4.y
mov r2.x, v5.y
dp3 r1.y, -r8, r2
dp3 r4.y, r2, -r7
dp3 r2.x, r4, r4
rsq r2.x, r2.x
mul r3.xyz, r2.x, r4
mov r4.xyz, c17
dp3 r3.w, r1, r1
cmp r6.xyz, -r1.w, r6, c18.z
rsq r1.w, r3.w
mul r1.xyz, r1.w, r1
dp3 r1.w, v3, v3
rsq r1.w, r1.w
mul r2.xyz, r1.w, v3
dp3_sat r3.y, r2, r3
dp3_sat r3.x, r2, r1
pow r1, r3.y, c11.x
mul r1.y, r3.x, r3.x
pow r3, r1.y, c12.x
mov r1.w, r3.x
mul r1.xyz, r1.x, c14
mad r3.xyz, r1.w, c13, r1
mul r1.xyz, r6, c8.x
max r1.w, r2, c18.z
mul r4.xyz, c4, r4
mul r6.xyz, r4, r1.w
mov r4.xyz, c0
mad_sat r6.xyz, c4, r4, r6
texld r4.xyz, v2, s1
dp3 r1.w, r5, r5
mad r1.xyz, r4, r6, r1
rsq r1.w, r1.w
mul r4.xyz, r1.w, r5
dp4 r1.w, r0, r0
rsq r1.w, r1.w
mul r0.xyz, r1.w, r0
mul r3.xyz, r3, c10.x
add_pp r3.xyz, r1, r3
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
mad r1.xyz, -r1, c18.x, v3
dp3_pp r0.w, r1, r4
abs_pp_sat r0.w, r0
add_pp r1.w, -r0, c18
dp3 r2.x, r2, r0
pow_pp r0, r1.w, c16.x
max r0.y, r2.x, c18.z
mul_pp r0.w, r0.x, c15.x
add_sat r0.y, -r0, c18.w
mad r0.y, r0, c19.x, c19
max r0.y, r0, c18.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s3
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r3
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 121 ALU, 5 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 20, 0, 4 } };
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
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[18].x, -c[18].y;
MUL R3.xyz, R1.y, R2;
MOV R1.z, c[18];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[18].y;
RSQ R1.y, R1.z;
DP3 R3.w, c[2], c[2];
RSQ R3.w, R3.w;
MOV R5.y, R2.z;
RCP R1.w, R1.y;
MAD R3.xyz, R1.x, fragment.texcoord[6], R3;
MAD R3.xyz, R1.w, fragment.texcoord[5], R3;
DP3 R1.w, R3, R3;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R1, R1;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R1.xyz, R2.w, R1;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[18].z, c[18].y;
ABS R2.w, R2;
MUL R6.xyz, R1.w, R3;
MUL R4.xyz, R3.w, c[2];
CMP R2.w, -R2, c[18].z, c[18].y;
CMP R1.xyz, -R2.w, R1, R4;
DP3 R1.w, R6, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R6, -R1.w;
SLT R2.w, R1, c[18].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[18].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.y, R1, R4;
MAX R3.x, R1.y, c[18].z;
TXP R1.x, fragment.texcoord[7], texture[2], 2D;
MOV R5.x, fragment.texcoord[6].z;
MUL R1.xyz, R1.x, c[17];
POW R3.w, R3.x, c[7].x;
MUL R3.xyz, R1, c[6];
CMP R2.w, -R2, c[18].z, c[18].y;
MUL R3.xyz, R3, R3.w;
CMP R3.xyz, -R2.w, R3, c[18].z;
MUL R8.xyz, R3, c[8].x;
MUL R3.xy, fragment.texcoord[3], c[9].x;
MAX R1.w, R1, c[18].z;
MUL R1.xyz, R1, c[4];
MUL R4.xyz, R1, R1.w;
MUL R3.xy, R3, c[19].y;
TEX R1.xyz, R3, texture[3], 2D;
MOV R3.xyz, c[4];
MAD_SAT R7.xyz, R3, c[0], R4;
MAD R9.xyz, R1, c[18].x, -c[18].y;
ADD R1.xyz, R9, c[19].zzww;
MOV R5.z, fragment.texcoord[5];
DP3 R2.z, R5, -R1;
MOV R3.y, R2.x;
MOV R4.y, R2;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R2.x, -R1, R3;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R1, R4;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R1.xyz, R1, R7, R8;
ADD R7.xyz, R9, c[18].zzyw;
DP3 R5.z, R5, -R7;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R5.x, R3, -R7;
DP3 R5.y, R4, -R7;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R2;
DP3 R2.w, R5, R5;
RSQ R2.w, R2.w;
MUL R4.xyz, R2.w, R5;
DP3_SAT R2.w, R3, R4;
POW R2.x, R2.w, c[11].x;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[12].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R1.w, c[13], R2;
MUL R4.xyz, R2, c[10].x;
DP3 R1.w, R6, fragment.texcoord[4];
MUL R2.xyz, R6, R1.w;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
DP3 R0.w, R6, R6;
MAX R0.y, R0, c[18].z;
ADD_SAT R0.y, -R0, c[18];
MUL R0.y, R0, c[18].w;
ADD R0.y, R0, c[19].x;
ADD R1.xyz, R1, R4;
RSQ R0.w, R0.w;
MAD R2.xyz, -R2, c[18].x, fragment.texcoord[4];
MUL R4.xyz, R0.w, R6;
DP3 R0.x, R2, R4;
ABS_SAT R0.x, R0;
ADD R0.x, -R0, c[18].y;
POW R0.x, R0.x, c[16].x;
MUL R0.w, R0.x, c[15].x;
MAX R0.y, R0, c[18].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R2, texture[4], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 121 instructions, 10 R-regs
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 122 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c18, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c19, 0.79627001, 0.20373000, 20.00000000, 0
def c20, 0.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mad r2.xy, r0.wyzw, c18.x, c18.y
mov r2.z, c18
dp3 r1.w, r2, r2
mul r3.xyz, r2.y, r1
add r1.w, -r1, c18
rsq r1.w, r1.w
mad r2.xyz, r2.x, v5, r3
rcp r1.w, r1.w
mad r3.xyz, r1.w, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r3, r3
rsq r1.w, r1.w
mul r5.xyz, r1.w, r3
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r3.w, r5, r2
mul r3.xyz, r5, -r3.w
mad r2.xyz, -r3, c18.x, -r2
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
dp3 r1.w, r2, r4
max r1.w, r1, c18.z
pow r2, r1.w, c7.x
mov r2.w, r2.x
texldp r3.x, v6, s2
mul r6.xyz, r3.x, c17
mul r3.xyz, r6, c6
mul r7.xyz, r3, r2.w
cmp r1.w, r3, c18.z, c18
abs_pp r1.w, r1
mul r2.xy, v2, c9.x
mul r2.xy, r2, c19.z
texld r2.xyz, r2, s3
mad r8.xyz, r2, c18.x, c18.y
add r9.xyz, r8, c20.xxyw
mov r4.y, r1.z
mov r3.y, r1.x
mov r2.y, r1
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c18.zzww
dp3 r4.z, r4, -r8
mov r3.z, v4.x
mov r3.x, v5
dp3 r4.x, r3, -r8
dp3 r1.x, -r9, r3
mov r2.z, v4.y
mov r2.x, v5.y
dp3 r1.y, -r9, r2
dp3 r4.y, r2, -r8
dp3 r2.x, r4, r4
rsq r2.x, r2.x
mul r2.xyz, r2.x, r4
dp3 r2.w, r1, r1
cmp r7.xyz, -r1.w, r7, c18.z
rsq r1.w, r2.w
mul r1.xyz, r1.w, r1
dp3 r1.w, v3, v3
rsq r1.w, r1.w
mul r3.xyz, r1.w, v3
dp3_sat r2.y, r3, r2
dp3_sat r2.x, r3, r1
pow r1, r2.y, c11.x
mul r1.y, r2.x, r2.x
pow r2, r1.y, c12.x
mov r1.w, r2.x
mul r1.xyz, r1.x, c14
mad r1.xyz, r1.w, c13, r1
mul r1.xyz, r1, c10.x
mul r4.xyz, r6, c4
max r1.w, r3, c18.z
mul r6.xyz, r4, r1.w
mov r4.xyz, c0
mad_sat r6.xyz, c4, r4, r6
dp3 r1.w, r5, r5
texld r4.xyz, v2, s1
mul r2.xyz, r7, c8.x
mad r2.xyz, r4, r6, r2
add_pp r2.xyz, r2, r1
rsq r1.w, r1.w
mul r4.xyz, r1.w, r5
dp4 r1.w, r0, r0
rsq r1.w, r1.w
mul r0.xyz, r1.w, r0
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
mad r1.xyz, -r1, c18.x, v3
dp3_pp r0.w, r1, r4
abs_pp_sat r0.w, r0
add_pp r1.w, -r0, c18
dp3 r2.w, r3, r0
pow_pp r0, r1.w, c16.x
max r0.y, r2.w, c18.z
mul_pp r0.w, r0.x, c15.x
add_sat r0.y, -r0, c18.w
mad r0.y, r0, c19.x, c19
max r0.y, r0, c18.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s4
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 121 ALU, 5 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 20, 0, 4 } };
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
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[18].x, -c[18].y;
MUL R3.xyz, R1.y, R2;
MOV R1.z, c[18];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[18].y;
RSQ R1.y, R1.z;
DP3 R3.w, c[2], c[2];
RSQ R3.w, R3.w;
MOV R5.y, R2.z;
RCP R1.w, R1.y;
MAD R3.xyz, R1.x, fragment.texcoord[6], R3;
MAD R3.xyz, R1.w, fragment.texcoord[5], R3;
DP3 R1.w, R3, R3;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R1, R1;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R1.xyz, R2.w, R1;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[18].z, c[18].y;
ABS R2.w, R2;
MUL R6.xyz, R1.w, R3;
MUL R4.xyz, R3.w, c[2];
CMP R2.w, -R2, c[18].z, c[18].y;
CMP R1.xyz, -R2.w, R1, R4;
DP3 R1.w, R6, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R6, -R1.w;
SLT R2.w, R1, c[18].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[18].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.y, R1, R4;
MAX R3.x, R1.y, c[18].z;
TXP R1.x, fragment.texcoord[7], texture[2], 2D;
MOV R5.x, fragment.texcoord[6].z;
MUL R1.xyz, R1.x, c[17];
POW R3.w, R3.x, c[7].x;
MUL R3.xyz, R1, c[6];
CMP R2.w, -R2, c[18].z, c[18].y;
MUL R3.xyz, R3, R3.w;
CMP R3.xyz, -R2.w, R3, c[18].z;
MUL R8.xyz, R3, c[8].x;
MUL R3.xy, fragment.texcoord[3], c[9].x;
MAX R1.w, R1, c[18].z;
MUL R1.xyz, R1, c[4];
MUL R4.xyz, R1, R1.w;
MUL R3.xy, R3, c[19].y;
TEX R1.xyz, R3, texture[3], 2D;
MOV R3.xyz, c[4];
MAD_SAT R7.xyz, R3, c[0], R4;
MAD R9.xyz, R1, c[18].x, -c[18].y;
ADD R1.xyz, R9, c[19].zzww;
MOV R5.z, fragment.texcoord[5];
DP3 R2.z, R5, -R1;
MOV R3.y, R2.x;
MOV R4.y, R2;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R2.x, -R1, R3;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R1, R4;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R1.xyz, R1, R7, R8;
ADD R7.xyz, R9, c[18].zzyw;
DP3 R5.z, R5, -R7;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R5.x, R3, -R7;
DP3 R5.y, R4, -R7;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R2;
DP3 R2.w, R5, R5;
RSQ R2.w, R2.w;
MUL R4.xyz, R2.w, R5;
DP3_SAT R2.w, R3, R4;
POW R2.x, R2.w, c[11].x;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[12].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R1.w, c[13], R2;
MUL R4.xyz, R2, c[10].x;
DP3 R1.w, R6, fragment.texcoord[4];
MUL R2.xyz, R6, R1.w;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
DP3 R0.w, R6, R6;
MAX R0.y, R0, c[18].z;
ADD_SAT R0.y, -R0, c[18];
MUL R0.y, R0, c[18].w;
ADD R0.y, R0, c[19].x;
ADD R1.xyz, R1, R4;
RSQ R0.w, R0.w;
MAD R2.xyz, -R2, c[18].x, fragment.texcoord[4];
MUL R4.xyz, R0.w, R6;
DP3 R0.x, R2, R4;
ABS_SAT R0.x, R0;
ADD R0.x, -R0, c[18].y;
POW R0.x, R0.x, c[16].x;
MUL R0.w, R0.x, c[15].x;
MAX R0.y, R0, c[18].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R2, texture[4], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 121 instructions, 10 R-regs
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 122 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c18, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c19, 0.79627001, 0.20373000, 20.00000000, 0
def c20, 0.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mad r2.xy, r0.wyzw, c18.x, c18.y
mov r2.z, c18
dp3 r1.w, r2, r2
mul r3.xyz, r2.y, r1
add r1.w, -r1, c18
rsq r1.w, r1.w
mad r2.xyz, r2.x, v5, r3
rcp r1.w, r1.w
mad r3.xyz, r1.w, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r3, r3
rsq r1.w, r1.w
mul r5.xyz, r1.w, r3
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r3.w, r5, r2
mul r3.xyz, r5, -r3.w
mad r2.xyz, -r3, c18.x, -r2
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
dp3 r1.w, r2, r4
max r1.w, r1, c18.z
pow r2, r1.w, c7.x
mov r2.w, r2.x
texldp r3.x, v6, s2
mul r6.xyz, r3.x, c17
mul r3.xyz, r6, c6
mul r7.xyz, r3, r2.w
cmp r1.w, r3, c18.z, c18
abs_pp r1.w, r1
mul r2.xy, v2, c9.x
mul r2.xy, r2, c19.z
texld r2.xyz, r2, s3
mad r8.xyz, r2, c18.x, c18.y
add r9.xyz, r8, c20.xxyw
mov r4.y, r1.z
mov r3.y, r1.x
mov r2.y, r1
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c18.zzww
dp3 r4.z, r4, -r8
mov r3.z, v4.x
mov r3.x, v5
dp3 r4.x, r3, -r8
dp3 r1.x, -r9, r3
mov r2.z, v4.y
mov r2.x, v5.y
dp3 r1.y, -r9, r2
dp3 r4.y, r2, -r8
dp3 r2.x, r4, r4
rsq r2.x, r2.x
mul r2.xyz, r2.x, r4
dp3 r2.w, r1, r1
cmp r7.xyz, -r1.w, r7, c18.z
rsq r1.w, r2.w
mul r1.xyz, r1.w, r1
dp3 r1.w, v3, v3
rsq r1.w, r1.w
mul r3.xyz, r1.w, v3
dp3_sat r2.y, r3, r2
dp3_sat r2.x, r3, r1
pow r1, r2.y, c11.x
mul r1.y, r2.x, r2.x
pow r2, r1.y, c12.x
mov r1.w, r2.x
mul r1.xyz, r1.x, c14
mad r1.xyz, r1.w, c13, r1
mul r1.xyz, r1, c10.x
mul r4.xyz, r6, c4
max r1.w, r3, c18.z
mul r6.xyz, r4, r1.w
mov r4.xyz, c0
mad_sat r6.xyz, c4, r4, r6
dp3 r1.w, r5, r5
texld r4.xyz, v2, s1
mul r2.xyz, r7, c8.x
mad r2.xyz, r4, r6, r2
add_pp r2.xyz, r2, r1
rsq r1.w, r1.w
mul r4.xyz, r1.w, r5
dp4 r1.w, r0, r0
rsq r1.w, r1.w
mul r0.xyz, r1.w, r0
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
mad r1.xyz, -r1, c18.x, v3
dp3_pp r0.w, r1, r4
abs_pp_sat r0.w, r0
add_pp r1.w, -r0, c18
dp3 r2.w, r3, r0
pow_pp r0, r1.w, c16.x
max r0.y, r2.w, c18.z
mul_pp r0.w, r0.x, c15.x
add_sat r0.y, -r0, c18.w
mad r0.y, r0, c19.x, c19
max r0.y, r0, c18.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s4
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 121 ALU, 5 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 0.79627001 },
		{ 0.20373, 20, 0, 4 } };
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
MOV R2.xyz, fragment.texcoord[6];
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R2.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0, R0, texture[0], 2D;
MAD R1.xy, R0.wyzw, c[18].x, -c[18].y;
MUL R3.xyz, R1.y, R2;
MOV R1.z, c[18];
DP3 R1.z, R1, R1;
ADD R1.z, -R1, c[18].y;
RSQ R1.y, R1.z;
DP3 R3.w, c[2], c[2];
RSQ R3.w, R3.w;
MOV R5.y, R2.z;
RCP R1.w, R1.y;
MAD R3.xyz, R1.x, fragment.texcoord[6], R3;
MAD R3.xyz, R1.w, fragment.texcoord[5], R3;
DP3 R1.w, R3, R3;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R2.w, R1, R1;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R1.xyz, R2.w, R1;
ABS R2.w, -c[2];
CMP R2.w, -R2, c[18].z, c[18].y;
ABS R2.w, R2;
MUL R6.xyz, R1.w, R3;
MUL R4.xyz, R3.w, c[2];
CMP R2.w, -R2, c[18].z, c[18].y;
CMP R1.xyz, -R2.w, R1, R4;
DP3 R1.w, R6, R1;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
MUL R3.xyz, R6, -R1.w;
SLT R2.w, R1, c[18].z;
ABS R2.w, R2;
MAD R1.xyz, -R3, c[18].x, -R1;
MUL R4.xyz, R3.w, R4;
DP3 R1.y, R1, R4;
MAX R3.x, R1.y, c[18].z;
TXP R1.x, fragment.texcoord[7], texture[2], 2D;
MOV R5.x, fragment.texcoord[6].z;
MUL R1.xyz, R1.x, c[17];
POW R3.w, R3.x, c[7].x;
MUL R3.xyz, R1, c[6];
CMP R2.w, -R2, c[18].z, c[18].y;
MUL R3.xyz, R3, R3.w;
CMP R3.xyz, -R2.w, R3, c[18].z;
MUL R8.xyz, R3, c[8].x;
MUL R3.xy, fragment.texcoord[3], c[9].x;
MAX R1.w, R1, c[18].z;
MUL R1.xyz, R1, c[4];
MUL R4.xyz, R1, R1.w;
MUL R3.xy, R3, c[19].y;
TEX R1.xyz, R3, texture[3], 2D;
MOV R3.xyz, c[4];
MAD_SAT R7.xyz, R3, c[0], R4;
MAD R9.xyz, R1, c[18].x, -c[18].y;
ADD R1.xyz, R9, c[19].zzww;
MOV R5.z, fragment.texcoord[5];
DP3 R2.z, R5, -R1;
MOV R3.y, R2.x;
MOV R4.y, R2;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R2.x, -R1, R3;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R1, R4;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
TEX R1.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R1.xyz, R1, R7, R8;
ADD R7.xyz, R9, c[18].zzyw;
DP3 R5.z, R5, -R7;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R5.x, R3, -R7;
DP3 R5.y, R4, -R7;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R2;
DP3 R2.w, R5, R5;
RSQ R2.w, R2.w;
MUL R4.xyz, R2.w, R5;
DP3_SAT R2.w, R3, R4;
POW R2.x, R2.w, c[11].x;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[12].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R1.w, c[13], R2;
MUL R4.xyz, R2, c[10].x;
DP3 R1.w, R6, fragment.texcoord[4];
MUL R2.xyz, R6, R1.w;
DP4 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
DP3 R0.w, R6, R6;
MAX R0.y, R0, c[18].z;
ADD_SAT R0.y, -R0, c[18];
MUL R0.y, R0, c[18].w;
ADD R0.y, R0, c[19].x;
ADD R1.xyz, R1, R4;
RSQ R0.w, R0.w;
MAD R2.xyz, -R2, c[18].x, fragment.texcoord[4];
MUL R4.xyz, R0.w, R6;
DP3 R0.x, R2, R4;
ABS_SAT R0.x, R0;
ADD R0.x, -R0, c[18].y;
POW R0.x, R0.x, c[16].x;
MUL R0.w, R0.x, c[15].x;
MAX R0.y, R0, c[18].z;
ADD R0.x, R0.w, c[5];
MUL R1.w, R0.x, R0.y;
TEX R0.xyz, R2, texture[4], CUBE;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R1;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[4];
END
# 121 instructions, 10 R-regs
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
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_InterFlakePower]
Float 12 [_OuterFlakePower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 122 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c18, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c19, 0.79627001, 0.20373000, 20.00000000, 0
def c20, 0.00000000, 4.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mad r0.xy, v2, c3, c3.zwzw
texld r0, r0, s0
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mad r2.xy, r0.wyzw, c18.x, c18.y
mov r2.z, c18
dp3 r1.w, r2, r2
mul r3.xyz, r2.y, r1
add r1.w, -r1, c18
rsq r1.w, r1.w
mad r2.xyz, r2.x, v5, r3
rcp r1.w, r1.w
mad r3.xyz, r1.w, v4, r2
add r2.xyz, -v0, c2
dp3 r1.w, r3, r3
rsq r1.w, r1.w
mul r5.xyz, r1.w, r3
dp3 r2.w, r2, r2
rsq r2.w, r2.w
dp3 r1.w, c2, c2
mul r3.xyz, r2.w, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, c2
abs_pp r1.w, -c2
cmp r2.xyz, -r1.w, r2, r3
dp3 r3.w, r5, r2
mul r3.xyz, r5, -r3.w
mad r2.xyz, -r3, c18.x, -r2
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
dp3 r1.w, r2, r4
max r1.w, r1, c18.z
pow r2, r1.w, c7.x
mov r2.w, r2.x
texldp r3.x, v6, s2
mul r6.xyz, r3.x, c17
mul r3.xyz, r6, c6
mul r7.xyz, r3, r2.w
cmp r1.w, r3, c18.z, c18
abs_pp r1.w, r1
mul r2.xy, v2, c9.x
mul r2.xy, r2, c19.z
texld r2.xyz, r2, s3
mad r8.xyz, r2, c18.x, c18.y
add r9.xyz, r8, c20.xxyw
mov r4.y, r1.z
mov r3.y, r1.x
mov r2.y, r1
mov r4.x, v5.z
mov r4.z, v4
dp3 r1.z, r4, -r9
add r8.xyz, r8, c18.zzww
dp3 r4.z, r4, -r8
mov r3.z, v4.x
mov r3.x, v5
dp3 r4.x, r3, -r8
dp3 r1.x, -r9, r3
mov r2.z, v4.y
mov r2.x, v5.y
dp3 r1.y, -r9, r2
dp3 r4.y, r2, -r8
dp3 r2.x, r4, r4
rsq r2.x, r2.x
mul r2.xyz, r2.x, r4
dp3 r2.w, r1, r1
cmp r7.xyz, -r1.w, r7, c18.z
rsq r1.w, r2.w
mul r1.xyz, r1.w, r1
dp3 r1.w, v3, v3
rsq r1.w, r1.w
mul r3.xyz, r1.w, v3
dp3_sat r2.y, r3, r2
dp3_sat r2.x, r3, r1
pow r1, r2.y, c11.x
mul r1.y, r2.x, r2.x
pow r2, r1.y, c12.x
mov r1.w, r2.x
mul r1.xyz, r1.x, c14
mad r1.xyz, r1.w, c13, r1
mul r1.xyz, r1, c10.x
mul r4.xyz, r6, c4
max r1.w, r3, c18.z
mul r6.xyz, r4, r1.w
mov r4.xyz, c0
mad_sat r6.xyz, c4, r4, r6
dp3 r1.w, r5, r5
texld r4.xyz, v2, s1
mul r2.xyz, r7, c8.x
mad r2.xyz, r4, r6, r2
add_pp r2.xyz, r2, r1
rsq r1.w, r1.w
mul r4.xyz, r1.w, r5
dp4 r1.w, r0, r0
rsq r1.w, r1.w
mul r0.xyz, r1.w, r0
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
mad r1.xyz, -r1, c18.x, v3
dp3_pp r0.w, r1, r4
abs_pp_sat r0.w, r0
add_pp r1.w, -r0, c18
dp3 r2.w, r3, r0
pow_pp r0, r1.w, c16.x
max r0.y, r2.w, c18.z
mul_pp r0.w, r0.x, c15.x
add_sat r0.y, -r0, c18.w
mad r0.y, r0, c19.x, c19
max r0.y, r0, c18.z
add r0.x, r0.w, c5
mul r1.w, r0.x, r0.y
texld r0.xyz, r1, s4
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

#LINE 322

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

#LINE 458

      }
	  
	  
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}