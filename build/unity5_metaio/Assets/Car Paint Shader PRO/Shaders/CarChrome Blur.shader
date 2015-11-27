Shader "RedDotGames/Car Chrome Blur" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (0,0,0,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 0
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
	  _Cube("Reflection Map", Cube) = "" {}
	  _CubeLod("Reflection Map Lod", Range (0.0, 8.0)) = 1.0
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0.5
	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="False"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" }
 
         Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 24 to 90
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_2)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec3 tmpvar_4;
  tmpvar_4 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_5;
  tmpvar_5 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  vec4 tmpvar_8;
  tmpvar_8.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_8.w = _CubeLod;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, tmpvar_8.xyz);
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_4) + tmpvar_5), 0.0, 1.0)) + tmpvar_7);
  color = (tmpvar_10 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c13, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r0
mad r2.xyz, v1.z, c10, r2
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
add r2.xyz, r2, c13.x
mov r0.xyz, c12
mov r0.w, c13.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r2.w, r0.w
dp3 r0.w, r2, r2
mul o5.xyz, r2.w, r0
rsq r0.x, r0.w
mov o1, r1
mul o2.xyz, r0.x, r2
mov o4, v2
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

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_2)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
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

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_2)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_2)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec3 tmpvar_4;
  tmpvar_4 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_5;
  tmpvar_5 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  vec4 tmpvar_8;
  tmpvar_8.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_8.w = _CubeLod;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, tmpvar_8.xyz);
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_4) + tmpvar_5), 0.0, 1.0)) + tmpvar_7);
  color = (tmpvar_10 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c13, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r0
mad r2.xyz, v1.z, c10, r2
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
add r2.xyz, r2, c13.x
mov r0.xyz, c12
mov r0.w, c13.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r2.w, r0.w
dp3 r0.w, r2, r2
mul o5.xyz, r2.w, r0
rsq r0.x, r0.w
mov o1, r1
mul o2.xyz, r0.x, r2
mov o4, v2
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

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_2)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
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

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_2)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_2)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec3 tmpvar_4;
  tmpvar_4 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_5;
  tmpvar_5 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  vec4 tmpvar_8;
  tmpvar_8.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_8.w = _CubeLod;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, tmpvar_8.xyz);
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_4) + tmpvar_5), 0.0, 1.0)) + tmpvar_7);
  color = (tmpvar_10 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 24 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c13, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r0
mad r2.xyz, v1.z, c10, r2
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
add r2.xyz, r2, c13.x
mov r0.xyz, c12
mov r0.w, c13.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r2.w, r0.w
dp3 r0.w, r2, r2
mul o5.xyz, r2.w, r0
rsq r0.x, r0.w
mov o1, r1
mul o2.xyz, r0.x, r2
mov o4, v2
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

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_2)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
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

varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_2)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (((tmpvar_4.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_4.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  vec4 tmpvar_9;
  tmpvar_9.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_9.w = _CubeLod;
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_Cube, tmpvar_9.xyz);
  reflTex = tmpvar_10;
  reflTex.xyz = (tmpvar_10.xyz * _Reflection);
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_5) + tmpvar_6), 0.0, 1.0)) + tmpvar_8);
  color = (tmpvar_11 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord7 o6
def c15, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c15.y
add r1, r0, -r1
dp4 r1.w, r1, r1
rsq r1.w, r1.w
mul o5.xyz, r1.w, r1
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c15.z
mul r3.y, r3, c12.x
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o6.xy, r3.z, c13.zwzw, r3
mov o1, r0
mul o2.xyz, r1.x, r2
mov o4, v2
mov o6.zw, r1
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (((tmpvar_4.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_4.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  vec4 tmpvar_9;
  tmpvar_9.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_9.w = _CubeLod;
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_Cube, tmpvar_9.xyz);
  reflTex = tmpvar_10;
  reflTex.xyz = (tmpvar_10.xyz * _Reflection);
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_5) + tmpvar_6), 0.0, 1.0)) + tmpvar_8);
  color = (tmpvar_11 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord7 o6
def c15, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c15.y
add r1, r0, -r1
dp4 r1.w, r1, r1
rsq r1.w, r1.w
mul o5.xyz, r1.w, r1
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c15.z
mul r3.y, r3, c12.x
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o6.xy, r3.z, c13.zwzw, r3
mov o1, r0
mul o2.xyz, r1.x, r2
mov o4, v2
mov o6.zw, r1
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = gl_Normal;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * gl_Vertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (((tmpvar_4.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_4.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  vec4 tmpvar_9;
  tmpvar_9.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_9.w = _CubeLod;
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_Cube, tmpvar_9.xyz);
  reflTex = tmpvar_10;
  reflTex.xyz = (tmpvar_10.xyz * _Reflection);
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_5) + tmpvar_6), 0.0, 1.0)) + tmpvar_8);
  color = (tmpvar_11 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord7 o6
def c15, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c15.y
add r1, r0, -r1
dp4 r1.w, r1, r1
rsq r1.w, r1.w
mul o5.xyz, r1.w, r1
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c15.z
mul r3.y, r3, c12.x
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o6.xy, r3.z, c13.zwzw, r3
mov o1, r0
mul o2.xyz, r1.x, r2
mov o4, v2
mov o6.zw, r1
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_3)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex);
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = gl_Normal;
  vec3 tmpvar_4;
  tmpvar_4 = normalize ((tmpvar_3 * _World2Object).xyz);
  vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.x = unity_4LightPosX0.x;
  tmpvar_6.y = unity_4LightPosY0.x;
  tmpvar_6.z = unity_4LightPosZ0.x;
  vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz - tmpvar_2.xyz);
  tmpvar_1 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_7, tmpvar_7))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_7))));
  vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.x = unity_4LightPosX0.y;
  tmpvar_8.y = unity_4LightPosY0.y;
  tmpvar_8.z = unity_4LightPosZ0.y;
  vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_9, tmpvar_9))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_9)))));
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.x = unity_4LightPosX0.z;
  tmpvar_10.y = unity_4LightPosY0.z;
  tmpvar_10.z = unity_4LightPosZ0.z;
  vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_11)))));
  vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.w;
  tmpvar_12.y = unity_4LightPosY0.w;
  tmpvar_12.z = unity_4LightPosZ0.w;
  vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_13)))));
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_5)).xyz;
}


#endif
#ifdef FRAGMENT
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec3 tmpvar_4;
  tmpvar_4 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_5;
  tmpvar_5 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  vec4 tmpvar_8;
  tmpvar_8.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_8.w = _CubeLod;
  vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, tmpvar_8.xyz);
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_4) + tmpvar_5), 0.0, 1.0)) + tmpvar_7);
  color = (tmpvar_10 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
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
; 84 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
add r3.xyz, r2, c22.x
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c13
mov r1.z, c15.x
mov r1.y, c14.x
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r0.w, r1.w
mul r1.xyz, r0.w, r1
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3 r0.w, r3, r1
mul r1.w, r1, c16.x
add r1.w, r1, c22.y
max r0.w, r0, c22.x
rcp r1.w, r1.w
mov r2.x, c13.y
mov r2.z, c15.y
mov r2.y, c14
add r2.xyz, -r0, r2
dp3 r2.w, r2, r2
rsq r1.x, r2.w
mul r1.xyz, r1.x, r2
mul r2.x, r2.w, c16.y
dp3 r1.y, r3, r1
add r1.x, r2, c22.y
max r2.x, r1.y, c22
rcp r1.x, r1.x
mul r1.xyz, r1.x, c18
mul r1.xyz, r1, c21
mul r2.xyz, r1, r2.x
mov r1.x, c13.z
mov r1.z, c15
mov r1.y, c14.z
add r4.xyz, -r0, r1
mul r1.xyz, r1.w, c17
mul r1.xyz, r1, c21
mad r1.xyz, r1, r0.w, r2
dp3 r1.w, r4, r4
mul r0.w, r1, c16.z
rsq r1.w, r1.w
mul r2.xyz, r1.w, r4
add r0.w, r0, c22.y
dp3 r1.w, r3, r2
rcp r0.w, r0.w
mul r2.xyz, r0.w, c19
max r0.w, r1, c22.x
mul r2.xyz, r2, c21
mad r4.xyz, r2, r0.w, r1
dp4 r0.w, v0, c7
mov r1.xyz, c12
mov r1.w, c22.y
add r1, r0, -r1
dp4 r1.w, r1, r1
rsq r1.w, r1.w
mov r2.x, c13.w
mov r2.z, c15.w
mov r2.y, c14.w
add r2.xyz, -r0, r2
dp3 r2.w, r2, r2
rsq r3.w, r2.w
mul r2.xyz, r3.w, r2
mul r4.w, r2, c16
add r2.w, r4, c22.y
rcp r2.w, r2.w
dp3 r3.w, r3, r2
mul r2.xyz, r2.w, c20
max r2.w, r3, c22.x
mul r2.xyz, r2, c21
mad o3.xyz, r2, r2.w, r4
mul o5.xyz, r1.w, r1
mov o1, r0
mov o2.xyz, r3
mov o4, v2
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
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((tmpvar_3 * _World2Object).xyz);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.x = unity_4LightPosX0.x;
  tmpvar_6.y = unity_4LightPosY0.x;
  tmpvar_6.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz - tmpvar_2.xyz);
  tmpvar_1 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_7, tmpvar_7))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_7))));
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.x = unity_4LightPosX0.y;
  tmpvar_8.y = unity_4LightPosY0.y;
  tmpvar_8.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_9, tmpvar_9))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_9)))));
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.x = unity_4LightPosX0.z;
  tmpvar_10.y = unity_4LightPosY0.z;
  tmpvar_10.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_11)))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.w;
  tmpvar_12.y = unity_4LightPosY0.w;
  tmpvar_12.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_13)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
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
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((tmpvar_3 * _World2Object).xyz);
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.x = unity_4LightPosX0.x;
  tmpvar_6.y = unity_4LightPosY0.x;
  tmpvar_6.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6.xyz - tmpvar_2.xyz);
  tmpvar_1 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_7, tmpvar_7))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_7))));
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.x = unity_4LightPosX0.y;
  tmpvar_8.y = unity_4LightPosY0.y;
  tmpvar_8.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_9, tmpvar_9))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_9)))));
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.x = unity_4LightPosX0.z;
  tmpvar_10.y = unity_4LightPosY0.z;
  tmpvar_10.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_11)))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.w;
  tmpvar_12.y = unity_4LightPosY0.w;
  tmpvar_12.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_13)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (specularReflection * _Gloss);
  specularReflection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = reflectedDir;
  tmpvar_11.w = _CubeLod;
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCubeLod (_Cube, tmpvar_11.xyz, tmpvar_11.w);
  reflTex = tmpvar_12;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_6) + tmpvar_7), 0.0, 1.0)) + tmpvar_9);
  color = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (color + reflTex);
  color = tmpvar_14;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_LightColor[4];
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;

uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * gl_Vertex);
  vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = gl_Normal;
  vec3 tmpvar_4;
  tmpvar_4 = normalize ((tmpvar_3 * _World2Object).xyz);
  vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.x = unity_4LightPosX0.x;
  tmpvar_7.y = unity_4LightPosY0.x;
  tmpvar_7.z = unity_4LightPosZ0.x;
  vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7.xyz - tmpvar_2.xyz);
  tmpvar_1 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_8, tmpvar_8))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_8))));
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.x = unity_4LightPosX0.y;
  tmpvar_9.y = unity_4LightPosY0.y;
  tmpvar_9.z = unity_4LightPosZ0.y;
  vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_10, tmpvar_10))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_10)))));
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.x = unity_4LightPosX0.z;
  tmpvar_11.y = unity_4LightPosY0.z;
  tmpvar_11.z = unity_4LightPosZ0.z;
  vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_12)))));
  vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.w;
  tmpvar_13.y = unity_4LightPosY0.w;
  tmpvar_13.z = unity_4LightPosZ0.w;
  vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_14)))));
  vec4 o_i0;
  vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_15;
  vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = gl_MultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * gl_Vertex) - tmpvar_6)).xyz;
  xlv_TEXCOORD7 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD7;
varying vec3 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec4 _WorldSpaceLightPos0;
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform float _Reflection;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Gloss;
uniform float _CubeLod;
uniform samplerCube _Cube;
uniform vec4 _Color;
void main ()
{
  vec4 color;
  vec4 reflTex;
  vec3 specularReflection;
  vec3 lightDirection;
  vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  vec3 tmpvar_6;
  tmpvar_6 = (((tmpvar_4.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_4.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  vec4 tmpvar_9;
  tmpvar_9.xyz = reflect (xlv_TEXCOORD4, tmpvar_1);
  tmpvar_9.w = _CubeLod;
  vec4 tmpvar_10;
  tmpvar_10 = textureCube (_Cube, tmpvar_9.xyz);
  reflTex = tmpvar_10;
  reflTex.xyz = (tmpvar_10.xyz * _Reflection);
  vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_5) + tmpvar_6), 0.0, 1.0)) + tmpvar_8);
  color = (tmpvar_11 + reflTex);
  color.w = _Color.w;
  gl_FragData[0] = color;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
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
; 90 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord7 o6
def c24, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
add r2.xyz, r2, c24.x
mov r1.x, c15
mov r1.z, c17.x
mov r1.y, c16.x
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r0.w, r1.w
mul r1.xyz, r0.w, r1
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
dp3 r0.w, r2, r1
mul r1.w, r1, c18.x
add r1.w, r1, c24.y
max r0.w, r0, c24.x
rcp r1.w, r1.w
mov r3.x, c15.y
mov r3.z, c17.y
mov r3.y, c16
add r3.xyz, -r0, r3
dp3 r2.w, r3, r3
rsq r1.x, r2.w
mul r1.xyz, r1.x, r3
dp3 r1.y, r2, r1
mul r2.w, r2, c18.y
add r1.x, r2.w, c24.y
max r2.w, r1.y, c24.x
rcp r1.x, r1.x
mul r1.xyz, r1.x, c20
mul r1.xyz, r1, c23
mul r3.xyz, r1, r2.w
mov r1.x, c15.z
mov r1.z, c17
mov r1.y, c16.z
add r4.xyz, -r0, r1
mul r1.xyz, r1.w, c19
mul r1.xyz, r1, c23
mad r1.xyz, r1, r0.w, r3
dp3 r1.w, r4, r4
mul r0.w, r1, c18.z
rsq r1.w, r1.w
mul r3.xyz, r1.w, r4
add r0.w, r0, c24.y
dp3 r1.w, r2, r3
rcp r0.w, r0.w
mul r3.xyz, r0.w, c21
max r0.w, r1, c24.x
mul r3.xyz, r3, c23
mad r4.xyz, r3, r0.w, r1
dp4 r0.w, v0, c7
mov r1.x, c15.w
mov r1.z, c17.w
mov r1.y, c16.w
add r3.xyz, -r0, r1
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
mul r4.w, r2, c18
add r2.w, r4, c24.y
dp3 r3.w, r2, r3
rcp r2.w, r2.w
mul r3.xyz, r2.w, c22
max r2.w, r3, c24.x
mul r3.xyz, r3, c23
mad o3.xyz, r3, r2.w, r4
dp4 r3.w, v0, c3
dp4 r3.z, v0, c2
dp4 r3.x, v0, c0
dp4 r3.y, v0, c1
mul r4.xyz, r3.xyww, c24.z
mov r1.xyz, c14
mov r1.w, c24.y
add r1, r0, -r1
dp4 r1.w, r1, r1
rsq r1.w, r1.w
mul o5.xyz, r1.w, r1
mov r1.x, r4
mul r1.y, r4, c12.x
mad o6.xy, r4.z, c13.zwzw, r1
mov o0, r3
mov o1, r0
mov o2.xyz, r2
mov o4, v2
mov o6.zw, r3
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
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((tmpvar_3 * _World2Object).xyz);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.x = unity_4LightPosX0.x;
  tmpvar_7.y = unity_4LightPosY0.x;
  tmpvar_7.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7.xyz - tmpvar_2.xyz);
  tmpvar_1 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_8, tmpvar_8))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_8))));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.x = unity_4LightPosX0.y;
  tmpvar_9.y = unity_4LightPosY0.y;
  tmpvar_9.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_10, tmpvar_10))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_10)))));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.x = unity_4LightPosX0.z;
  tmpvar_11.y = unity_4LightPosY0.z;
  tmpvar_11.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_12)))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.w;
  tmpvar_13.y = unity_4LightPosY0.w;
  tmpvar_13.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_14)))));
  highp vec4 o_i0;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
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
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((tmpvar_3 * _World2Object).xyz);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.x = unity_4LightPosX0.x;
  tmpvar_7.y = unity_4LightPosY0.x;
  tmpvar_7.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7.xyz - tmpvar_2.xyz);
  tmpvar_1 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_8, tmpvar_8))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_8))));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.x = unity_4LightPosX0.y;
  tmpvar_9.y = unity_4LightPosY0.y;
  tmpvar_9.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_10, tmpvar_10))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_10)))));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.x = unity_4LightPosX0.z;
  tmpvar_11.y = unity_4LightPosY0.z;
  tmpvar_11.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_12)))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.w;
  tmpvar_13.y = unity_4LightPosY0.w;
  tmpvar_13.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13.xyz - tmpvar_2.xyz);
  tmpvar_1 = (tmpvar_1 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_4, normalize (tmpvar_14)))));
  highp vec4 o_i0;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_16 + tmpvar_15.w);
  o_i0.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT

#extension GL_ARB_shader_texture_lod : enable
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
varying highp vec3 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform highp float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Reflection;
uniform sampler2D _MainTex;
uniform highp vec4 _LightColor0;
uniform highp float _Gloss;
uniform highp float _CubeLod;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_4;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_5;
    tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_5;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = reflectedDir;
  tmpvar_12.w = _CubeLod;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCubeLod (_Cube, tmpvar_12.xyz, tmpvar_12.w);
  reflTex = tmpvar_13;
  reflTex.xyz = (reflTex.xyz * _Reflection);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_10);
  color = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (color + reflTex);
  color = tmpvar_15;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   d3d9 - ALU: 45 to 46, TEX: 3 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_CubeLod]
Vector 9 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_3_0
; 46 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
add r3.xyz, -v0, c1
dp3 r1.w, r3, r3
rsq r1.w, r1.w
dp3 r0.x, c2, c2
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.w, r0, r1
mul r2.xyz, r0, -r0.w
mad r1.xyz, -r2, c10.z, -r1
mul r3.xyz, r1.w, r3
dp3 r1.x, r1, r3
max r2.x, r1, c10
pow r1, r2.x, c6.x
cmp r1.w, r0, c10.x, c10.y
mov r2.x, r1
mov r1.xyz, c9
mul r1.xyz, c5, r1
mul r1.xyz, r1, r2.x
abs_pp r1.w, r1
cmp r1.xyz, -r1.w, r1, c10.x
mul r3.xyz, r1, c7.x
dp3 r1.x, r0, v4
mul r0.xyz, r0, r1.x
mov r2.xyz, c0
mad r1.xyz, -r0, c10.z, v4
mov r1.w, c8.x
texldl r0.xyz, r1, s1
mov r1.xyz, c9
mad r2.xyz, c3, r2, v2
max r0.w, r0, c10.x
mul r1.xyz, c3, r1
mad_sat r1.xyz, r1, r0.w, r2
mul r2.xyz, r0, c4.x
texld r0.xyz, v3, s0
mad r0.xyz, r0, r1, r3
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c3
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
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_CubeLod]
Vector 9 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_3_0
; 46 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
add r3.xyz, -v0, c1
dp3 r1.w, r3, r3
rsq r1.w, r1.w
dp3 r0.x, c2, c2
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.w, r0, r1
mul r2.xyz, r0, -r0.w
mad r1.xyz, -r2, c10.z, -r1
mul r3.xyz, r1.w, r3
dp3 r1.x, r1, r3
max r2.x, r1, c10
pow r1, r2.x, c6.x
cmp r1.w, r0, c10.x, c10.y
mov r2.x, r1
mov r1.xyz, c9
mul r1.xyz, c5, r1
mul r1.xyz, r1, r2.x
abs_pp r1.w, r1
cmp r1.xyz, -r1.w, r1, c10.x
mul r3.xyz, r1, c7.x
dp3 r1.x, r0, v4
mul r0.xyz, r0, r1.x
mov r2.xyz, c0
mad r1.xyz, -r0, c10.z, v4
mov r1.w, c8.x
texldl r0.xyz, r1, s1
mov r1.xyz, c9
mad r2.xyz, c3, r2, v2
max r0.w, r0, c10.x
mul r1.xyz, c3, r1
mad_sat r1.xyz, r1, r0.w, r2
mul r2.xyz, r0, c4.x
texld r0.xyz, v3, s0
mad r0.xyz, r0, r1, r3
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c3
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
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_CubeLod]
Vector 9 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_3_0
; 46 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
add r3.xyz, -v0, c1
dp3 r1.w, r3, r3
rsq r1.w, r1.w
dp3 r0.x, c2, c2
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r0.w, r0, r1
mul r2.xyz, r0, -r0.w
mad r1.xyz, -r2, c10.z, -r1
mul r3.xyz, r1.w, r3
dp3 r1.x, r1, r3
max r2.x, r1, c10
pow r1, r2.x, c6.x
cmp r1.w, r0, c10.x, c10.y
mov r2.x, r1
mov r1.xyz, c9
mul r1.xyz, c5, r1
mul r1.xyz, r1, r2.x
abs_pp r1.w, r1
cmp r1.xyz, -r1.w, r1, c10.x
mul r3.xyz, r1, c7.x
dp3 r1.x, r0, v4
mul r0.xyz, r0, r1.x
mov r2.xyz, c0
mad r1.xyz, -r0, c10.z, v4
mov r1.w, c8.x
texldl r0.xyz, r1, s1
mov r1.xyz, c9
mad r2.xyz, c3, r2, v2
max r0.w, r0, c10.x
mul r1.xyz, c3, r1
mad_sat r1.xyz, r1, r0.w, r2
mul r2.xyz, r0, c4.x
texld r0.xyz, v3, s0
mad r0.xyz, r0, r1, r3
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c3
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
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_CubeLod]
Vector 9 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 45 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord7 v5
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
add r3.xyz, -v0, c1
dp3 r1.w, r3, r3
rsq r1.w, r1.w
dp3 r0.x, c2, c2
dp3 r0.w, v1, v1
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r0.xyz, -r0.x, r1, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
dp3 r0.w, r1, r0
mul r2.xyz, r1, -r0.w
mul r3.xyz, r1.w, r3
cmp r1.w, r0, c10.x, c10.y
mad r0.xyz, -r2, c10.z, -r0
dp3 r0.x, r0, r3
max r0.x, r0, c10
pow r2, r0.x, c6.x
texldp r0.x, v5, s1
mov r2.w, r2.x
mul r0.xyz, r0.x, c9
mul r2.xyz, r0, c5
abs_pp r1.w, r1
mul r2.xyz, r2, r2.w
cmp r2.xyz, -r1.w, r2, c10.x
dp3 r1.w, r1, v4
mul r1.xyz, r1, r1.w
mul r3.xyz, r2, c7.x
mov r2.xyz, c0
mad r2.xyz, c3, r2, v2
max r0.w, r0, c10.x
mul r0.xyz, r0, c3
mad_sat r0.xyz, r0, r0.w, r2
mad r1.xyz, -r1, c10.z, v4
mov r1.w, c8.x
texldl r1.xyz, r1, s2
mul r2.xyz, r1, c4.x
texld r1.xyz, v3, s0
mad r0.xyz, r1, r0, r3
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c3
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
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_CubeLod]
Vector 9 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 45 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord7 v5
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
add r3.xyz, -v0, c1
dp3 r1.w, r3, r3
rsq r1.w, r1.w
dp3 r0.x, c2, c2
dp3 r0.w, v1, v1
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r0.xyz, -r0.x, r1, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
dp3 r0.w, r1, r0
mul r2.xyz, r1, -r0.w
mul r3.xyz, r1.w, r3
cmp r1.w, r0, c10.x, c10.y
mad r0.xyz, -r2, c10.z, -r0
dp3 r0.x, r0, r3
max r0.x, r0, c10
pow r2, r0.x, c6.x
texldp r0.x, v5, s1
mov r2.w, r2.x
mul r0.xyz, r0.x, c9
mul r2.xyz, r0, c5
abs_pp r1.w, r1
mul r2.xyz, r2, r2.w
cmp r2.xyz, -r1.w, r2, c10.x
dp3 r1.w, r1, v4
mul r1.xyz, r1, r1.w
mul r3.xyz, r2, c7.x
mov r2.xyz, c0
mad r2.xyz, c3, r2, v2
max r0.w, r0, c10.x
mul r0.xyz, r0, c3
mad_sat r0.xyz, r0, r0.w, r2
mad r1.xyz, -r1, c10.z, v4
mov r1.w, c8.x
texldl r1.xyz, r1, s2
mul r2.xyz, r1, c4.x
texld r1.xyz, v3, s0
mad r0.xyz, r1, r0, r3
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c3
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
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_CubeLod]
Vector 9 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 45 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c10, 0.00000000, 1.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord7 v5
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
add r3.xyz, -v0, c1
dp3 r1.w, r3, r3
rsq r1.w, r1.w
dp3 r0.x, c2, c2
dp3 r0.w, v1, v1
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r0.xyz, -r0.x, r1, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
dp3 r0.w, r1, r0
mul r2.xyz, r1, -r0.w
mul r3.xyz, r1.w, r3
cmp r1.w, r0, c10.x, c10.y
mad r0.xyz, -r2, c10.z, -r0
dp3 r0.x, r0, r3
max r0.x, r0, c10
pow r2, r0.x, c6.x
texldp r0.x, v5, s1
mov r2.w, r2.x
mul r0.xyz, r0.x, c9
mul r2.xyz, r0, c5
abs_pp r1.w, r1
mul r2.xyz, r2, r2.w
cmp r2.xyz, -r1.w, r2, c10.x
dp3 r1.w, r1, v4
mul r1.xyz, r1, r1.w
mul r3.xyz, r2, c7.x
mov r2.xyz, c0
mad r2.xyz, c3, r2, v2
max r0.w, r0, c10.x
mul r0.xyz, r0, c3
mad_sat r0.xyz, r0, r0.w, r2
mad r1.xyz, -r1, c10.z, v4
mov r1.w, c8.x
texldl r1.xyz, r1, s2
mul r2.xyz, r1, c4.x
texld r1.xyz, v3, s0
mad r0.xyz, r1, r0, r3
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c3
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

#LINE 184

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}