Shader "RedDotGames/Car Paint per-pixel lighting" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
      //_BumpMap ("Normalmap", 2D) = "bump" {}
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_10;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_15), 0.0, 1.0);
  highp vec4 tmpvar_20;
  tmpvar_20 = ((pow ((tmpvar_19 * tmpvar_19), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_18 * -((tmpvar_14 + vec3(0.0, 0.0, 1.0))))), tmpvar_15), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp ((tmpvar_8 + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (paintColor * _FlakePower));
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + reflTex);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (tmpvar_25 * reflTex));
  color = tmpvar_29;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
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
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  highp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec4 textureColor;
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  highp vec2 tmpvar_4;
  tmpvar_4 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    highp vec3 tmpvar_7;
    tmpvar_7 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/((1.0 + dot (tmpvar_7, tmpvar_7))));
    lightDirection = normalize (tmpvar_7);
  };
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp float tmpvar_9;
  tmpvar_9 = (attenuation * tmpvar_8.x);
  attenuation = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9 * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((tmpvar_9 * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
  };
  highp vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = xlv_TEXCOORD6;
  tmpvar_18[1] = tmpvar_12;
  tmpvar_18[2] = xlv_TEXCOORD5;
  mat3 tmpvar_19;
  tmpvar_19[0].x = tmpvar_18[0].x;
  tmpvar_19[0].y = tmpvar_18[1].x;
  tmpvar_19[0].z = tmpvar_18[2].x;
  tmpvar_19[1].x = tmpvar_18[0].y;
  tmpvar_19[1].y = tmpvar_18[1].y;
  tmpvar_19[1].z = tmpvar_18[2].y;
  tmpvar_19[2].x = tmpvar_18[0].z;
  tmpvar_19[2].y = tmpvar_18[1].z;
  tmpvar_19[2].z = tmpvar_18[2].z;
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
  highp float tmpvar_21;
  tmpvar_21 = clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_17), 0.0, 1.0);
  highp vec4 tmpvar_22;
  tmpvar_22 = ((pow ((tmpvar_21 * tmpvar_21), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_20 * -((tmpvar_16 + vec3(0.0, 0.0, 1.0))))), tmpvar_17), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_2);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_27), 0.0, 1.0));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((textureColor.xyz * clamp ((tmpvar_10 + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_28;
  highp vec4 tmpvar_29;
  tmpvar_29 = (color + (paintColor * _FlakePower));
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + reflTex);
  color = tmpvar_30;
  highp vec4 tmpvar_31;
  tmpvar_31 = (color + (tmpvar_27 * reflTex));
  color = tmpvar_31;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 100 to 102, TEX: 3 to 4
//   d3d9 - ALU: 107 to 108, TEX: 3 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 3 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 0, 1, 2, 20 },
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
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R0, R0;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
CMP R2.w, -R0.x, c[17].x, c[17].y;
MUL R2.xyz, R0.y, c[2];
CMP R1.xyz, -R2.w, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.x, R0.y;
MUL R2.xyz, R3.x, R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
DP3 R0.y, R0, R2;
ADD R0.x, R1.w, c[17].y;
MAX R0.y, R0, c[17].x;
POW R0.z, R0.y, c[6].x;
SLT R0.y, R0.w, c[17].x;
RCP R0.x, R0.x;
CMP R0.x, -R2.w, R0, c[17].y;
MUL R4.xyz, R0.x, c[16];
ABS R0.x, R0.y;
MUL R1.xyz, R4, c[5];
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R0.xyz, -R0.x, R1, c[17].x;
MUL R6.xyz, R0, c[7].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[1], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R2;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R8.xyz, R2.w, fragment.texcoord[4];
MUL R0.xyz, R1.w, R0;
DP3_SAT R1.w, R0, R8;
MUL R0.xyz, R4, c[3];
MAX R0.w, R0, c[17].x;
MUL R4.xyz, R0, R0.w;
MOV R0.xyz, c[3];
MAD_SAT R4.xyz, R0, c[0], R4;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.x, R1, -R4;
DP3 R3.y, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R8, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
POW R0.w, R0.w, c[11].x;
POW R1.w, R1.w, c[10].x;
ADD R2.w, -R2.x, c[17].y;
MUL R2.xyz, R1.w, c[13];
MAD R2.xyz, R0.w, c[12], R2;
POW R1.w, R2.w, c[15].x;
MUL R0.w, R1, c[14].x;
MUL R2.xyz, R2, c[9].x;
ADD R0.xyz, R0, R2;
ADD_SAT R1.w, R0, c[4].x;
TEX R1.xyz, R1, texture[2], CUBE;
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R1, R0.w;
ADD R0.xyz, R0, R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[3];
END
# 100 instructions, 9 R-regs
"
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 107 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c17, 1.00000000, 0.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
add r0.xyz, -v0, c2
dp3 r0.w, r0, r0
rsq r1.x, r0.w
mul r1.xyz, r1.x, r0
dp3 r0.y, c2, c2
rsq r0.y, r0.y
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c17, c17.y
abs_pp r2.w, r0.x
mul r2.xyz, r0.y, c2
cmp r1.xyz, -r2.w, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r3.x, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r3.x, r2
dp3 r0.y, r0, r2
add r0.x, r0.w, c17
max r1.y, r0, c17
rcp r1.x, r0.x
pow r0, r1.y, c6.x
cmp r0.y, -r2.w, r1.x, c17.x
mul r1.xy, v2, c8.x
mul r2.xy, r1, c17.w
texld r2.xyz, r2, s1
mad r7.xyz, r2, c18.x, c18.y
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r2.y, r1.x
mov r3.y, r1.z
dp3 r2.w, v3, v3
add r8.xyz, r7, c18.zzww
mul r4.xyz, r0.y, c16
mov r0.w, r0.x
mul r0.xyz, r4, c5
mul r0.xyz, r0, r0.w
mov r2.z, v4.x
mov r2.x, v5
dp3 r6.x, -r8, r2
mov r1.z, v4.y
mov r1.x, v5.y
dp3 r6.y, -r8, r1
mov r3.x, v5.z
mov r3.z, v4
dp3 r6.z, r3, -r8
dp3 r0.w, r6, r6
rsq r0.w, r0.w
mul r6.xyz, r0.w, r6
rsq r2.w, r2.w
mul r8.xyz, r2.w, v3
cmp r0.w, r1, c17.y, c17.x
dp3_sat r2.w, r6, r8
abs_pp r0.w, r0
cmp r0.xyz, -r0.w, r0, c17.y
mul r6.xyz, r0, c7.x
mul r2.w, r2, r2
pow r0, r2.w, c11.x
max r0.y, r1.w, c17
mul r4.xyz, r4, c3
mul r0.yzw, r4.xxyz, r0.y
mov r4.xyz, c0
mad_sat r0.yzw, c3.xxyz, r4.xxyz, r0
texld r4.xyz, v2, s0
mad r4.xyz, r4, r0.yzww, r6
add r6.xyz, r7, c17.yyxw
dp3 r0.y, r1, -r6
mov r1.w, r0.x
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
dp3 r0.x, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v3
dp3_sat r0.x, r8, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17.x
pow_pp r0, r2.y, c15.x
mov r0.y, r2.x
mov_pp r0.w, r0.x
mul r2.xyz, r0.y, c13
mad r0.xyz, r1.w, c12, r2
mul r2.xyz, r0, c9.x
mul_pp r0.w, r0, c14.x
texld r0.xyz, r1, s2
add_sat r1.w, r0, c4.x
mul r0.xyz, r0, r1.w
add_pp r1.xyz, r4, r2
mul r2.xyz, r0, r0.w
add_pp r0.xyz, r1, r0
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
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 3 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 0, 1, 2, 20 },
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
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R0, R0;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
CMP R2.w, -R0.x, c[17].x, c[17].y;
MUL R2.xyz, R0.y, c[2];
CMP R1.xyz, -R2.w, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.x, R0.y;
MUL R2.xyz, R3.x, R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
DP3 R0.y, R0, R2;
ADD R0.x, R1.w, c[17].y;
MAX R0.y, R0, c[17].x;
POW R0.z, R0.y, c[6].x;
SLT R0.y, R0.w, c[17].x;
RCP R0.x, R0.x;
CMP R0.x, -R2.w, R0, c[17].y;
MUL R4.xyz, R0.x, c[16];
ABS R0.x, R0.y;
MUL R1.xyz, R4, c[5];
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R0.xyz, -R0.x, R1, c[17].x;
MUL R6.xyz, R0, c[7].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[1], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R2;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R8.xyz, R2.w, fragment.texcoord[4];
MUL R0.xyz, R1.w, R0;
DP3_SAT R1.w, R0, R8;
MUL R0.xyz, R4, c[3];
MAX R0.w, R0, c[17].x;
MUL R4.xyz, R0, R0.w;
MOV R0.xyz, c[3];
MAD_SAT R4.xyz, R0, c[0], R4;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.x, R1, -R4;
DP3 R3.y, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R8, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
POW R0.w, R0.w, c[11].x;
POW R1.w, R1.w, c[10].x;
ADD R2.w, -R2.x, c[17].y;
MUL R2.xyz, R1.w, c[13];
MAD R2.xyz, R0.w, c[12], R2;
POW R1.w, R2.w, c[15].x;
MUL R0.w, R1, c[14].x;
MUL R2.xyz, R2, c[9].x;
ADD R0.xyz, R0, R2;
ADD_SAT R1.w, R0, c[4].x;
TEX R1.xyz, R1, texture[2], CUBE;
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R1, R0.w;
ADD R0.xyz, R0, R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[3];
END
# 100 instructions, 9 R-regs
"
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 107 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c17, 1.00000000, 0.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
add r0.xyz, -v0, c2
dp3 r0.w, r0, r0
rsq r1.x, r0.w
mul r1.xyz, r1.x, r0
dp3 r0.y, c2, c2
rsq r0.y, r0.y
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c17, c17.y
abs_pp r2.w, r0.x
mul r2.xyz, r0.y, c2
cmp r1.xyz, -r2.w, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r3.x, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r3.x, r2
dp3 r0.y, r0, r2
add r0.x, r0.w, c17
max r1.y, r0, c17
rcp r1.x, r0.x
pow r0, r1.y, c6.x
cmp r0.y, -r2.w, r1.x, c17.x
mul r1.xy, v2, c8.x
mul r2.xy, r1, c17.w
texld r2.xyz, r2, s1
mad r7.xyz, r2, c18.x, c18.y
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r2.y, r1.x
mov r3.y, r1.z
dp3 r2.w, v3, v3
add r8.xyz, r7, c18.zzww
mul r4.xyz, r0.y, c16
mov r0.w, r0.x
mul r0.xyz, r4, c5
mul r0.xyz, r0, r0.w
mov r2.z, v4.x
mov r2.x, v5
dp3 r6.x, -r8, r2
mov r1.z, v4.y
mov r1.x, v5.y
dp3 r6.y, -r8, r1
mov r3.x, v5.z
mov r3.z, v4
dp3 r6.z, r3, -r8
dp3 r0.w, r6, r6
rsq r0.w, r0.w
mul r6.xyz, r0.w, r6
rsq r2.w, r2.w
mul r8.xyz, r2.w, v3
cmp r0.w, r1, c17.y, c17.x
dp3_sat r2.w, r6, r8
abs_pp r0.w, r0
cmp r0.xyz, -r0.w, r0, c17.y
mul r6.xyz, r0, c7.x
mul r2.w, r2, r2
pow r0, r2.w, c11.x
max r0.y, r1.w, c17
mul r4.xyz, r4, c3
mul r0.yzw, r4.xxyz, r0.y
mov r4.xyz, c0
mad_sat r0.yzw, c3.xxyz, r4.xxyz, r0
texld r4.xyz, v2, s0
mad r4.xyz, r4, r0.yzww, r6
add r6.xyz, r7, c17.yyxw
dp3 r0.y, r1, -r6
mov r1.w, r0.x
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
dp3 r0.x, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v3
dp3_sat r0.x, r8, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17.x
pow_pp r0, r2.y, c15.x
mov r0.y, r2.x
mov_pp r0.w, r0.x
mul r2.xyz, r0.y, c13
mad r0.xyz, r1.w, c12, r2
mul r2.xyz, r0, c9.x
mul_pp r0.w, r0, c14.x
texld r0.xyz, r1, s2
add_sat r1.w, r0, c4.x
mul r0.xyz, r0, r1.w
add_pp r1.xyz, r4, r2
mul r2.xyz, r0, r0.w
add_pp r0.xyz, r1, r0
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
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 3 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 0, 1, 2, 20 },
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
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R0, R0;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
CMP R2.w, -R0.x, c[17].x, c[17].y;
MUL R2.xyz, R0.y, c[2];
CMP R1.xyz, -R2.w, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.x, R0.y;
MUL R2.xyz, R3.x, R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
DP3 R0.y, R0, R2;
ADD R0.x, R1.w, c[17].y;
MAX R0.y, R0, c[17].x;
POW R0.z, R0.y, c[6].x;
SLT R0.y, R0.w, c[17].x;
RCP R0.x, R0.x;
CMP R0.x, -R2.w, R0, c[17].y;
MUL R4.xyz, R0.x, c[16];
ABS R0.x, R0.y;
MUL R1.xyz, R4, c[5];
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R0.xyz, -R0.x, R1, c[17].x;
MUL R6.xyz, R0, c[7].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[1], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R2;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R8.xyz, R2.w, fragment.texcoord[4];
MUL R0.xyz, R1.w, R0;
DP3_SAT R1.w, R0, R8;
MUL R0.xyz, R4, c[3];
MAX R0.w, R0, c[17].x;
MUL R4.xyz, R0, R0.w;
MOV R0.xyz, c[3];
MAD_SAT R4.xyz, R0, c[0], R4;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.x, R1, -R4;
DP3 R3.y, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R8, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
POW R0.w, R0.w, c[11].x;
POW R1.w, R1.w, c[10].x;
ADD R2.w, -R2.x, c[17].y;
MUL R2.xyz, R1.w, c[13];
MAD R2.xyz, R0.w, c[12], R2;
POW R1.w, R2.w, c[15].x;
MUL R0.w, R1, c[14].x;
MUL R2.xyz, R2, c[9].x;
ADD R0.xyz, R0, R2;
ADD_SAT R1.w, R0, c[4].x;
TEX R1.xyz, R1, texture[2], CUBE;
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R1, R0.w;
ADD R0.xyz, R0, R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[3];
END
# 100 instructions, 9 R-regs
"
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 107 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c17, 1.00000000, 0.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
add r0.xyz, -v0, c2
dp3 r0.w, r0, r0
rsq r1.x, r0.w
mul r1.xyz, r1.x, r0
dp3 r0.y, c2, c2
rsq r0.y, r0.y
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c17, c17.y
abs_pp r2.w, r0.x
mul r2.xyz, r0.y, c2
cmp r1.xyz, -r2.w, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r3.x, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r3.x, r2
dp3 r0.y, r0, r2
add r0.x, r0.w, c17
max r1.y, r0, c17
rcp r1.x, r0.x
pow r0, r1.y, c6.x
cmp r0.y, -r2.w, r1.x, c17.x
mul r1.xy, v2, c8.x
mul r2.xy, r1, c17.w
texld r2.xyz, r2, s1
mad r7.xyz, r2, c18.x, c18.y
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r2.y, r1.x
mov r3.y, r1.z
dp3 r2.w, v3, v3
add r8.xyz, r7, c18.zzww
mul r4.xyz, r0.y, c16
mov r0.w, r0.x
mul r0.xyz, r4, c5
mul r0.xyz, r0, r0.w
mov r2.z, v4.x
mov r2.x, v5
dp3 r6.x, -r8, r2
mov r1.z, v4.y
mov r1.x, v5.y
dp3 r6.y, -r8, r1
mov r3.x, v5.z
mov r3.z, v4
dp3 r6.z, r3, -r8
dp3 r0.w, r6, r6
rsq r0.w, r0.w
mul r6.xyz, r0.w, r6
rsq r2.w, r2.w
mul r8.xyz, r2.w, v3
cmp r0.w, r1, c17.y, c17.x
dp3_sat r2.w, r6, r8
abs_pp r0.w, r0
cmp r0.xyz, -r0.w, r0, c17.y
mul r6.xyz, r0, c7.x
mul r2.w, r2, r2
pow r0, r2.w, c11.x
max r0.y, r1.w, c17
mul r4.xyz, r4, c3
mul r0.yzw, r4.xxyz, r0.y
mov r4.xyz, c0
mad_sat r0.yzw, c3.xxyz, r4.xxyz, r0
texld r4.xyz, v2, s0
mad r4.xyz, r4, r0.yzww, r6
add r6.xyz, r7, c17.yyxw
dp3 r0.y, r1, -r6
mov r1.w, r0.x
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
dp3 r0.x, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v3
dp3_sat r0.x, r8, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17.x
pow_pp r0, r2.y, c15.x
mov r0.y, r2.x
mov_pp r0.w, r0.x
mul r2.xyz, r0.y, c13
mad r0.xyz, r1.w, c12, r2
mul r2.xyz, r0, c9.x
mul_pp r0.w, r0, c14.x
texld r0.xyz, r1, s2
add_sat r1.w, r0, c4.x
mul r0.xyz, r0, r1.w
add_pp r1.xyz, r4, r2
mul r2.xyz, r0, r0.w
add_pp r0.xyz, r1, r0
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
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 102 ALU, 4 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 0, 1, 2, 20 },
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
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R0, R0;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
CMP R2.w, -R0.x, c[17].x, c[17].y;
MUL R2.xyz, R0.y, c[2];
CMP R1.xyz, -R2.w, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.x, R0.y;
MUL R2.xyz, R3.x, R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
DP3 R0.x, R0, R2;
MAX R0.y, R0.x, c[17].x;
ADD R0.x, R1.w, c[17].y;
POW R0.z, R0.y, c[6].x;
RCP R0.y, R0.x;
CMP R0.y, -R2.w, R0, c[17];
TXP R0.x, fragment.texcoord[7], texture[1], 2D;
MUL R0.x, R0.y, R0;
MUL R4.xyz, R0.x, c[16];
SLT R0.y, R0.w, c[17].x;
ABS R0.x, R0.y;
MUL R1.xyz, R4, c[5];
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R0.xyz, -R0.x, R1, c[17].x;
MUL R6.xyz, R0, c[7].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[2], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R2;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R8.xyz, R2.w, fragment.texcoord[4];
MUL R0.xyz, R1.w, R0;
DP3_SAT R1.w, R0, R8;
MUL R0.xyz, R4, c[3];
MAX R0.w, R0, c[17].x;
MUL R4.xyz, R0, R0.w;
MOV R0.xyz, c[3];
MAD_SAT R4.xyz, R0, c[0], R4;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.x, R1, -R4;
DP3 R3.y, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R8, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
POW R0.w, R0.w, c[11].x;
POW R1.w, R1.w, c[10].x;
ADD R2.w, -R2.x, c[17].y;
MUL R2.xyz, R1.w, c[13];
MAD R2.xyz, R0.w, c[12], R2;
POW R1.w, R2.w, c[15].x;
MUL R0.w, R1, c[14].x;
MUL R2.xyz, R2, c[9].x;
ADD R0.xyz, R0, R2;
ADD_SAT R1.w, R0, c[4].x;
TEX R1.xyz, R1, texture[3], CUBE;
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R1, R0.w;
ADD R0.xyz, R0, R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[3];
END
# 102 instructions, 9 R-regs
"
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 108 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c17, 1.00000000, 0.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
add r0.xyz, -v0, c2
dp3 r0.w, r0, r0
rsq r1.x, r0.w
mul r1.xyz, r1.x, r0
dp3 r0.y, c2, c2
rsq r0.y, r0.y
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c17, c17.y
abs_pp r2.w, r0.x
mul r2.xyz, r0.y, c2
cmp r1.xyz, -r2.w, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r3.x, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r3.x, r2
dp3 r0.x, r0, r2
max r1.y, r0.x, c17
add r1.x, r0.w, c17
pow r0, r1.y, c6.x
rcp r0.y, r1.x
cmp r0.y, -r2.w, r0, c17.x
texldp r1.x, v6, s1
mul r0.y, r0, r1.x
mul r1.xy, v2, c8.x
mul r2.xy, r1, c17.w
texld r2.xyz, r2, s2
mad r7.xyz, r2, c18.x, c18.y
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r2.y, r1.x
mov r3.y, r1.z
dp3 r2.w, v3, v3
add r8.xyz, r7, c18.zzww
mul r4.xyz, r0.y, c16
mov r0.w, r0.x
mul r0.xyz, r4, c5
mul r0.xyz, r0, r0.w
mov r2.z, v4.x
mov r2.x, v5
dp3 r6.x, -r8, r2
mov r1.z, v4.y
mov r1.x, v5.y
dp3 r6.y, -r8, r1
mov r3.x, v5.z
mov r3.z, v4
dp3 r6.z, r3, -r8
dp3 r0.w, r6, r6
rsq r0.w, r0.w
mul r6.xyz, r0.w, r6
rsq r2.w, r2.w
mul r8.xyz, r2.w, v3
cmp r0.w, r1, c17.y, c17.x
dp3_sat r2.w, r6, r8
abs_pp r0.w, r0
cmp r0.xyz, -r0.w, r0, c17.y
mul r6.xyz, r0, c7.x
mul r2.w, r2, r2
pow r0, r2.w, c11.x
max r0.y, r1.w, c17
mul r4.xyz, r4, c3
mul r0.yzw, r4.xxyz, r0.y
mov r4.xyz, c0
mad_sat r0.yzw, c3.xxyz, r4.xxyz, r0
texld r4.xyz, v2, s0
mad r4.xyz, r4, r0.yzww, r6
add r6.xyz, r7, c17.yyxw
dp3 r0.y, r1, -r6
mov r1.w, r0.x
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
dp3 r0.x, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v3
dp3_sat r0.x, r8, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17.x
pow_pp r0, r2.y, c15.x
mov r0.y, r2.x
mov_pp r0.w, r0.x
mul r2.xyz, r0.y, c13
mad r0.xyz, r1.w, c12, r2
mul r2.xyz, r0, c9.x
mul_pp r0.w, r0, c14.x
texld r0.xyz, r1, s3
add_sat r1.w, r0, c4.x
mul r0.xyz, r0, r1.w
add_pp r1.xyz, r4, r2
mul r2.xyz, r0, r0.w
add_pp r0.xyz, r1, r0
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
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 102 ALU, 4 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 0, 1, 2, 20 },
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
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R0, R0;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
CMP R2.w, -R0.x, c[17].x, c[17].y;
MUL R2.xyz, R0.y, c[2];
CMP R1.xyz, -R2.w, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.x, R0.y;
MUL R2.xyz, R3.x, R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
DP3 R0.x, R0, R2;
MAX R0.y, R0.x, c[17].x;
ADD R0.x, R1.w, c[17].y;
POW R0.z, R0.y, c[6].x;
RCP R0.y, R0.x;
CMP R0.y, -R2.w, R0, c[17];
TXP R0.x, fragment.texcoord[7], texture[1], 2D;
MUL R0.x, R0.y, R0;
MUL R4.xyz, R0.x, c[16];
SLT R0.y, R0.w, c[17].x;
ABS R0.x, R0.y;
MUL R1.xyz, R4, c[5];
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R0.xyz, -R0.x, R1, c[17].x;
MUL R6.xyz, R0, c[7].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[2], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R2;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R8.xyz, R2.w, fragment.texcoord[4];
MUL R0.xyz, R1.w, R0;
DP3_SAT R1.w, R0, R8;
MUL R0.xyz, R4, c[3];
MAX R0.w, R0, c[17].x;
MUL R4.xyz, R0, R0.w;
MOV R0.xyz, c[3];
MAD_SAT R4.xyz, R0, c[0], R4;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.x, R1, -R4;
DP3 R3.y, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R8, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
POW R0.w, R0.w, c[11].x;
POW R1.w, R1.w, c[10].x;
ADD R2.w, -R2.x, c[17].y;
MUL R2.xyz, R1.w, c[13];
MAD R2.xyz, R0.w, c[12], R2;
POW R1.w, R2.w, c[15].x;
MUL R0.w, R1, c[14].x;
MUL R2.xyz, R2, c[9].x;
ADD R0.xyz, R0, R2;
ADD_SAT R1.w, R0, c[4].x;
TEX R1.xyz, R1, texture[3], CUBE;
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R1, R0.w;
ADD R0.xyz, R0, R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[3];
END
# 102 instructions, 9 R-regs
"
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 108 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c17, 1.00000000, 0.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
add r0.xyz, -v0, c2
dp3 r0.w, r0, r0
rsq r1.x, r0.w
mul r1.xyz, r1.x, r0
dp3 r0.y, c2, c2
rsq r0.y, r0.y
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c17, c17.y
abs_pp r2.w, r0.x
mul r2.xyz, r0.y, c2
cmp r1.xyz, -r2.w, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r3.x, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r3.x, r2
dp3 r0.x, r0, r2
max r1.y, r0.x, c17
add r1.x, r0.w, c17
pow r0, r1.y, c6.x
rcp r0.y, r1.x
cmp r0.y, -r2.w, r0, c17.x
texldp r1.x, v6, s1
mul r0.y, r0, r1.x
mul r1.xy, v2, c8.x
mul r2.xy, r1, c17.w
texld r2.xyz, r2, s2
mad r7.xyz, r2, c18.x, c18.y
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r2.y, r1.x
mov r3.y, r1.z
dp3 r2.w, v3, v3
add r8.xyz, r7, c18.zzww
mul r4.xyz, r0.y, c16
mov r0.w, r0.x
mul r0.xyz, r4, c5
mul r0.xyz, r0, r0.w
mov r2.z, v4.x
mov r2.x, v5
dp3 r6.x, -r8, r2
mov r1.z, v4.y
mov r1.x, v5.y
dp3 r6.y, -r8, r1
mov r3.x, v5.z
mov r3.z, v4
dp3 r6.z, r3, -r8
dp3 r0.w, r6, r6
rsq r0.w, r0.w
mul r6.xyz, r0.w, r6
rsq r2.w, r2.w
mul r8.xyz, r2.w, v3
cmp r0.w, r1, c17.y, c17.x
dp3_sat r2.w, r6, r8
abs_pp r0.w, r0
cmp r0.xyz, -r0.w, r0, c17.y
mul r6.xyz, r0, c7.x
mul r2.w, r2, r2
pow r0, r2.w, c11.x
max r0.y, r1.w, c17
mul r4.xyz, r4, c3
mul r0.yzw, r4.xxyz, r0.y
mov r4.xyz, c0
mad_sat r0.yzw, c3.xxyz, r4.xxyz, r0
texld r4.xyz, v2, s0
mad r4.xyz, r4, r0.yzww, r6
add r6.xyz, r7, c17.yyxw
dp3 r0.y, r1, -r6
mov r1.w, r0.x
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
dp3 r0.x, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v3
dp3_sat r0.x, r8, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17.x
pow_pp r0, r2.y, c15.x
mov r0.y, r2.x
mov_pp r0.w, r0.x
mul r2.xyz, r0.y, c13
mad r0.xyz, r1.w, c12, r2
mul r2.xyz, r0, c9.x
mul_pp r0.w, r0, c14.x
texld r0.xyz, r1, s3
add_sat r1.w, r0, c4.x
mul r0.xyz, r0, r1.w
add_pp r1.xyz, r4, r2
mul r2.xyz, r0, r0.w
add_pp r0.xyz, r1, r0
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
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 102 ALU, 4 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 0, 1, 2, 20 },
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
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R0, R0;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
CMP R2.w, -R0.x, c[17].x, c[17].y;
MUL R2.xyz, R0.y, c[2];
CMP R1.xyz, -R2.w, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.x, R0.y;
MUL R2.xyz, R3.x, R2;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
DP3 R0.x, R0, R2;
MAX R0.y, R0.x, c[17].x;
ADD R0.x, R1.w, c[17].y;
POW R0.z, R0.y, c[6].x;
RCP R0.y, R0.x;
CMP R0.y, -R2.w, R0, c[17];
TXP R0.x, fragment.texcoord[7], texture[1], 2D;
MUL R0.x, R0.y, R0;
MUL R4.xyz, R0.x, c[16];
SLT R0.y, R0.w, c[17].x;
ABS R0.x, R0.y;
MUL R1.xyz, R4, c[5];
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R0.xyz, -R0.x, R1, c[17].x;
MUL R6.xyz, R0, c[7].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[2], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0;
MOV R1.y, R0.x;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R2;
MOV R1.z, fragment.texcoord[5].x;
MOV R1.x, fragment.texcoord[6];
DP3 R0.x, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R8.xyz, R2.w, fragment.texcoord[4];
MUL R0.xyz, R1.w, R0;
DP3_SAT R1.w, R0, R8;
MUL R0.xyz, R4, c[3];
MAX R0.w, R0, c[17].x;
MUL R4.xyz, R0, R0.w;
MOV R0.xyz, c[3];
MAD_SAT R4.xyz, R0, c[0], R4;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.x, R1, -R4;
DP3 R3.y, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R8, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
POW R0.w, R0.w, c[11].x;
POW R1.w, R1.w, c[10].x;
ADD R2.w, -R2.x, c[17].y;
MUL R2.xyz, R1.w, c[13];
MAD R2.xyz, R0.w, c[12], R2;
POW R1.w, R2.w, c[15].x;
MUL R0.w, R1, c[14].x;
MUL R2.xyz, R2, c[9].x;
ADD R0.xyz, R0, R2;
ADD_SAT R1.w, R0, c[4].x;
TEX R1.xyz, R1, texture[3], CUBE;
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R1, R0.w;
ADD R0.xyz, R0, R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[3];
END
# 102 instructions, 9 R-regs
"
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_InterFlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Vector 13 [_flakeLayerColor]
Float 14 [_FrezPow]
Float 15 [_FrezFalloff]
Vector 16 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 108 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c17, 1.00000000, 0.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord3 v2.xy
dcl_texcoord4 v3.xyz
dcl_texcoord5 v4.xyz
dcl_texcoord6 v5.xyz
dcl_texcoord7 v6
add r0.xyz, -v0, c2
dp3 r0.w, r0, r0
rsq r1.x, r0.w
mul r1.xyz, r1.x, r0
dp3 r0.y, c2, c2
rsq r0.y, r0.y
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c17, c17.y
abs_pp r2.w, r0.x
mul r2.xyz, r0.y, c2
cmp r1.xyz, -r2.w, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r3.x, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r3.x, r2
dp3 r0.x, r0, r2
max r1.y, r0.x, c17
add r1.x, r0.w, c17
pow r0, r1.y, c6.x
rcp r0.y, r1.x
cmp r0.y, -r2.w, r0, c17.x
texldp r1.x, v6, s1
mul r0.y, r0, r1.x
mul r1.xy, v2, c8.x
mul r2.xy, r1, c17.w
texld r2.xyz, r2, s2
mad r7.xyz, r2, c18.x, c18.y
mov r1.xyz, v5
mul r3.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v5
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r2.y, r1.x
mov r3.y, r1.z
dp3 r2.w, v3, v3
add r8.xyz, r7, c18.zzww
mul r4.xyz, r0.y, c16
mov r0.w, r0.x
mul r0.xyz, r4, c5
mul r0.xyz, r0, r0.w
mov r2.z, v4.x
mov r2.x, v5
dp3 r6.x, -r8, r2
mov r1.z, v4.y
mov r1.x, v5.y
dp3 r6.y, -r8, r1
mov r3.x, v5.z
mov r3.z, v4
dp3 r6.z, r3, -r8
dp3 r0.w, r6, r6
rsq r0.w, r0.w
mul r6.xyz, r0.w, r6
rsq r2.w, r2.w
mul r8.xyz, r2.w, v3
cmp r0.w, r1, c17.y, c17.x
dp3_sat r2.w, r6, r8
abs_pp r0.w, r0
cmp r0.xyz, -r0.w, r0, c17.y
mul r6.xyz, r0, c7.x
mul r2.w, r2, r2
pow r0, r2.w, c11.x
max r0.y, r1.w, c17
mul r4.xyz, r4, c3
mul r0.yzw, r4.xxyz, r0.y
mov r4.xyz, c0
mad_sat r0.yzw, c3.xxyz, r4.xxyz, r0
texld r4.xyz, v2, s0
mad r4.xyz, r4, r0.yzww, r6
add r6.xyz, r7, c17.yyxw
dp3 r0.y, r1, -r6
mov r1.w, r0.x
dp3 r1.x, r5, v3
mul r1.xyz, r5, r1.x
dp3 r0.x, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v3
dp3_sat r0.x, r8, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17.x
pow_pp r0, r2.y, c15.x
mov r0.y, r2.x
mov_pp r0.w, r0.x
mul r2.xyz, r0.y, c13
mad r0.xyz, r1.w, c12, r2
mul r2.xyz, r0, c9.x
mul_pp r0.w, r0, c14.x
texld r0.xyz, r1, s3
add_sat r1.w, r0, c4.x
mul r0.xyz, r0, r1.w
add_pp r1.xyz, r4, r2
mul r2.xyz, r0, r0.w
add_pp r0.xyz, r1, r0
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

#LINE 277

      }
	  
	  Pass {    
         Tags { "LightMode" = "ForwardAdd" } 
            // pass for additional light sources
         Blend One One // additive blending 
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 15 to 20
//   d3d9 - ALU: 15 to 20
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 15 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 15 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 15 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 15 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 15 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 15 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 15 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 15 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 15 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_ProjectionParams]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[14] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R2.xyz, R1.xyww, c[0].y;
MUL R2.y, R2, c[13].x;
ADD result.texcoord[2].xy, R2, R2.z;
MOV result.position, R1;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[2].zw, R1;
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c14, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c14.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c14.y
mul r2.y, r2, c12.x
mad o3.xy, r2.z, c13.zwzw, r2
mov o0, r1
mul o2.xyz, r0.w, r0
mov o3.zw, r1
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_ProjectionParams]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[14] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R2.xyz, R1.xyww, c[0].y;
MUL R2.y, R2, c[13].x;
ADD result.texcoord[2].xy, R2, R2.z;
MOV result.position, R1;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[2].zw, R1;
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c14, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c14.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c14.y
mul r2.y, r2, c12.x
mad o3.xy, r2.z, c13.zwzw, r2
mov o0, r1
mul o2.xyz, r0.w, r0
mov o3.zw, r1
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_ProjectionParams]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[14] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R2.xyz, R1.xyww, c[0].y;
MUL R2.y, R2, c[13].x;
ADD result.texcoord[2].xy, R2, R2.z;
MOV result.position, R1;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[2].zw, R1;
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c14, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c14.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c14.y
mul r2.y, r2, c12.x
mad o3.xy, r2.z, c13.zwzw, r2
mov o0, r1
mul o2.xyz, r0.w, r0
mov o3.zw, r1
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 15 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 15 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 15 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [_ProjectionParams]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[14] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R2.xyz, R1.xyww, c[0].y;
MUL R2.y, R2, c[13].x;
ADD result.texcoord[2].xy, R2, R2.z;
MOV result.position, R1;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[2].zw, R1;
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c14, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c14.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r2.xyz, r1.xyww, c14.y
mul r2.y, r2, c12.x
mad o3.xy, r2.z, c13.zwzw, r2
mov o0, r1
mul o2.xyz, r0.w, r0
mov o3.zw, r1
dp4 o1.w, v0, c7
dp4 o1.z, v0, c6
dp4 o1.y, v0, c5
dp4 o1.x, v0, c4
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
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

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 0.0;
  tmpvar_1.xyz = normalize (_glesNormal);
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_1 * _World2Object).xyz);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _SpecColor;
uniform highp float _Shininess;
uniform highp vec4 _LightColor0;
uniform highp vec4 _Color;
void main ()
{
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp float attenuation;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_3;
    tmpvar_3 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_3;
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (2.0 * (1.0/((1.0 + dot (tmpvar_4, tmpvar_4)))));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_6 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), tmpvar_2)), _Shininess));
  };
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_5 + specularReflection);
  gl_FragData[0] = tmpvar_7;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 40 to 40, TEX: 0 to 0
//   d3d9 - ALU: 41 to 41
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"3.0-!!ARBfp1.0
# 40 ALU, 0 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R0.w, R0, R0;
RSQ R1.x, R0.w;
MUL R0.xyz, R1.x, R0;
ABS R1.x, -c[1].w;
CMP R1.w, -R1.x, c[6].y, c[6].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[6].y, c[6].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[6].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[6].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[6];
MUL R0.x, R0, c[6].z;
SLT R0.w, R2, c[6].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[6];
MUL R0.xyz, R0.x, c[5];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[6].y, c[6].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[6].y;
MAX R0.w, R2, c[6].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[6].x;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"ps_3_0
; 41 ALU
def c6, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c6.x, c6.y
abs_pp r0.w, r0
mul r1.xyz, r1.x, c1
cmp r2.xyz, -r0.w, r0, r1
add r1.xyz, -v0, c0
dp3 r3.x, r1, r1
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r2.w, r0, r2
rsq r3.x, r3.x
mul r0.xyz, r0, -r2.w
mad r0.xyz, -r0, c6.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c6
max r0.y, r0, c6
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c6.z
cmp r0.x, -r0.w, r0, c6
cmp r0.w, r2, c6.y, c6.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c5
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c6.y
max r0.w, r2, c6.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c6.x
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
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"3.0-!!ARBfp1.0
# 40 ALU, 0 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R0.w, R0, R0;
RSQ R1.x, R0.w;
MUL R0.xyz, R1.x, R0;
ABS R1.x, -c[1].w;
CMP R1.w, -R1.x, c[6].y, c[6].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[6].y, c[6].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[6].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[6].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[6];
MUL R0.x, R0, c[6].z;
SLT R0.w, R2, c[6].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[6];
MUL R0.xyz, R0.x, c[5];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[6].y, c[6].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[6].y;
MAX R0.w, R2, c[6].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[6].x;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"ps_3_0
; 41 ALU
def c6, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c6.x, c6.y
abs_pp r0.w, r0
mul r1.xyz, r1.x, c1
cmp r2.xyz, -r0.w, r0, r1
add r1.xyz, -v0, c0
dp3 r3.x, r1, r1
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r2.w, r0, r2
rsq r3.x, r3.x
mul r0.xyz, r0, -r2.w
mad r0.xyz, -r0, c6.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c6
max r0.y, r0, c6
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c6.z
cmp r0.x, -r0.w, r0, c6
cmp r0.w, r2, c6.y, c6.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c5
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c6.y
max r0.w, r2, c6.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c6.x
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
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"3.0-!!ARBfp1.0
# 40 ALU, 0 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R0.w, R0, R0;
RSQ R1.x, R0.w;
MUL R0.xyz, R1.x, R0;
ABS R1.x, -c[1].w;
CMP R1.w, -R1.x, c[6].y, c[6].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[6].y, c[6].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[6].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[6].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[6];
MUL R0.x, R0, c[6].z;
SLT R0.w, R2, c[6].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[6];
MUL R0.xyz, R0.x, c[5];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[6].y, c[6].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[6].y;
MAX R0.w, R2, c[6].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[6].x;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"ps_3_0
; 41 ALU
def c6, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c6.x, c6.y
abs_pp r0.w, r0
mul r1.xyz, r1.x, c1
cmp r2.xyz, -r0.w, r0, r1
add r1.xyz, -v0, c0
dp3 r3.x, r1, r1
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r2.w, r0, r2
rsq r3.x, r3.x
mul r0.xyz, r0, -r2.w
mad r0.xyz, -r0, c6.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c6
max r0.y, r0, c6
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c6.z
cmp r0.x, -r0.w, r0, c6
cmp r0.w, r2, c6.y, c6.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c5
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c6.y
max r0.w, r2, c6.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c6.x
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
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"3.0-!!ARBfp1.0
# 40 ALU, 0 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R0.w, R0, R0;
RSQ R1.x, R0.w;
MUL R0.xyz, R1.x, R0;
ABS R1.x, -c[1].w;
CMP R1.w, -R1.x, c[6].y, c[6].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[6].y, c[6].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[6].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[6].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[6];
MUL R0.x, R0, c[6].z;
SLT R0.w, R2, c[6].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[6];
MUL R0.xyz, R0.x, c[5];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[6].y, c[6].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[6].y;
MAX R0.w, R2, c[6].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[6].x;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"ps_3_0
; 41 ALU
def c6, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c6.x, c6.y
abs_pp r0.w, r0
mul r1.xyz, r1.x, c1
cmp r2.xyz, -r0.w, r0, r1
add r1.xyz, -v0, c0
dp3 r3.x, r1, r1
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r2.w, r0, r2
rsq r3.x, r3.x
mul r0.xyz, r0, -r2.w
mad r0.xyz, -r0, c6.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c6
max r0.y, r0, c6
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c6.z
cmp r0.x, -r0.w, r0, c6
cmp r0.w, r2, c6.y, c6.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c5
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c6.y
max r0.w, r2, c6.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c6.x
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
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"3.0-!!ARBfp1.0
# 40 ALU, 0 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R0.w, R0, R0;
RSQ R1.x, R0.w;
MUL R0.xyz, R1.x, R0;
ABS R1.x, -c[1].w;
CMP R1.w, -R1.x, c[6].y, c[6].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[6].y, c[6].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[6].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[6].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[6];
MUL R0.x, R0, c[6].z;
SLT R0.w, R2, c[6].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[6];
MUL R0.xyz, R0.x, c[5];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[6].y, c[6].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[6].y;
MAX R0.w, R2, c[6].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[6].x;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"ps_3_0
; 41 ALU
def c6, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c6.x, c6.y
abs_pp r0.w, r0
mul r1.xyz, r1.x, c1
cmp r2.xyz, -r0.w, r0, r1
add r1.xyz, -v0, c0
dp3 r3.x, r1, r1
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r2.w, r0, r2
rsq r3.x, r3.x
mul r0.xyz, r0, -r2.w
mad r0.xyz, -r0, c6.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c6
max r0.y, r0, c6
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c6.z
cmp r0.x, -r0.w, r0, c6
cmp r0.w, r2, c6.y, c6.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c5
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c6.y
max r0.w, r2, c6.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c6.x
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
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"3.0-!!ARBfp1.0
# 40 ALU, 0 TEX
PARAM c[7] = { program.local[0..5],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R0.w, R0, R0;
RSQ R1.x, R0.w;
MUL R0.xyz, R1.x, R0;
ABS R1.x, -c[1].w;
CMP R1.w, -R1.x, c[6].y, c[6].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[6].y, c[6].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[6].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[6].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[6];
MUL R0.x, R0, c[6].z;
SLT R0.w, R2, c[6].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[6];
MUL R0.xyz, R0.x, c[5];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[6].y, c[6].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[6].y;
MAX R0.w, R2, c[6].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[6].x;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Vector 5 [_LightColor0]
"ps_3_0
; 41 ALU
def c6, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c6.x, c6.y
abs_pp r0.w, r0
mul r1.xyz, r1.x, c1
cmp r2.xyz, -r0.w, r0, r1
add r1.xyz, -v0, c0
dp3 r3.x, r1, r1
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
dp3 r2.w, r0, r2
rsq r3.x, r3.x
mul r0.xyz, r0, -r2.w
mad r0.xyz, -r0, c6.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c6
max r0.y, r0, c6
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c6.z
cmp r0.x, -r0.w, r0, c6
cmp r0.w, r2, c6.y, c6.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c5
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c6.y
max r0.w, r2, c6.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c6.x
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

#LINE 389

      }
     
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}