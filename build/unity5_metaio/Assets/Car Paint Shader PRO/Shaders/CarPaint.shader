Shader "RedDotGames/Car Paint" {
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
//   opengl - ALU: 37 to 102
//   d3d9 - ALU: 37 to 102
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
# 37 ALU
PARAM c[14] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, vertex.normal.y, c[10];
DP4 R1.w, vertex.position, c[8];
DP4 R1.z, vertex.position, c[7];
DP4 R1.y, vertex.position, c[6];
DP4 R1.x, vertex.position, c[5];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MOV R0.xyz, c[13];
MOV R0.w, c[0].y;
ADD R0, R1, -R0;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R3.z, R0, c[7];
DP4 R3.y, R0, c[6];
DP4 R3.x, R0, c[5];
MAD R0.xyz, vertex.normal.z, c[11], R2;
DP3 R0.w, R3, R3;
RSQ R2.x, R0.w;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[6].xyz, R2.x, R3;
MOV result.texcoord[0], R1;
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
# 37 instructions, 4 R-regs
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
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r2.xyz, v1.y, c9
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mad r2.xyz, v1.x, c8, r2
mov r0.xyz, c12
mov r0.w, c13.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r3.z, r0, c6
dp4 r3.y, r0, c5
dp4 r3.x, r0, c4
mad r0.xyz, v1.z, c10, r2
dp3 r0.w, r3, r3
rsq r2.x, r0.w
add r0.xyz, r0, c13.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mul o7.xyz, r2.x, r3
mov o1, r1
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
# 37 ALU
PARAM c[14] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, vertex.normal.y, c[10];
DP4 R1.w, vertex.position, c[8];
DP4 R1.z, vertex.position, c[7];
DP4 R1.y, vertex.position, c[6];
DP4 R1.x, vertex.position, c[5];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MOV R0.xyz, c[13];
MOV R0.w, c[0].y;
ADD R0, R1, -R0;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R3.z, R0, c[7];
DP4 R3.y, R0, c[6];
DP4 R3.x, R0, c[5];
MAD R0.xyz, vertex.normal.z, c[11], R2;
DP3 R0.w, R3, R3;
RSQ R2.x, R0.w;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[6].xyz, R2.x, R3;
MOV result.texcoord[0], R1;
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
# 37 instructions, 4 R-regs
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
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r2.xyz, v1.y, c9
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mad r2.xyz, v1.x, c8, r2
mov r0.xyz, c12
mov r0.w, c13.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r3.z, r0, c6
dp4 r3.y, r0, c5
dp4 r3.x, r0, c4
mad r0.xyz, v1.z, c10, r2
dp3 r0.w, r3, r3
rsq r2.x, r0.w
add r0.xyz, r0, c13.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mul o7.xyz, r2.x, r3
mov o1, r1
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
# 37 ALU
PARAM c[14] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, vertex.normal.y, c[10];
DP4 R1.w, vertex.position, c[8];
DP4 R1.z, vertex.position, c[7];
DP4 R1.y, vertex.position, c[6];
DP4 R1.x, vertex.position, c[5];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MOV R0.xyz, c[13];
MOV R0.w, c[0].y;
ADD R0, R1, -R0;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R3.z, R0, c[7];
DP4 R3.y, R0, c[6];
DP4 R3.x, R0, c[5];
MAD R0.xyz, vertex.normal.z, c[11], R2;
DP3 R0.w, R3, R3;
RSQ R2.x, R0.w;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[6].xyz, R2.x, R3;
MOV result.texcoord[0], R1;
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
# 37 instructions, 4 R-regs
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
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r2.xyz, v1.y, c9
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mad r2.xyz, v1.x, c8, r2
mov r0.xyz, c12
mov r0.w, c13.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r3.z, r0, c6
dp4 r3.y, r0, c5
dp4 r3.x, r0, c4
mad r0.xyz, v1.z, c10, r2
dp3 r0.w, r3, r3
rsq r2.x, r0.w
add r0.xyz, r0, c13.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mul o7.xyz, r2.x, r3
mov o1, r1
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_5)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
# 42 ALU
PARAM c[15] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.xyz, c[14];
MOV R1.w, c[0].y;
ADD R2, R0, -R1;
MOV result.texcoord[0], R0;
MOV R1.xyz, vertex.attrib[14];
MOV R1.w, c[0].x;
DP4 R3.z, R1, c[7];
DP4 R3.x, R1, c[5];
DP4 R3.y, R1, c[6];
DP4 R2.w, R2, R2;
RSQ R1.x, R2.w;
MUL result.texcoord[4].xyz, R1.x, R2;
DP3 R1.y, R3, R3;
RSQ R1.y, R1.y;
MUL result.texcoord[6].xyz, R1.y, R3;
MUL R2.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MAD R2.xyz, vertex.normal.z, c[11], R2;
ADD R2.xyz, R2, c[0].x;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R3.xyz, R1.xyww, c[0].z;
MUL R3.y, R3, c[13].x;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
DP3 R2.w, R2, R2;
MOV result.position, R1;
RSQ R1.x, R2.w;
ADD result.texcoord[7].xy, R3, R3.z;
MUL result.texcoord[1].xyz, R1.x, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MOV result.texcoord[2].xyz, c[0].x;
END
# 42 instructions, 4 R-regs
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
; 42 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c15.y
add r2, r0, -r1
mov o1, r0
mov r1.xyz, v3
mov r1.w, c15.x
dp4 r3.z, r1, c6
dp4 r3.x, r1, c4
dp4 r3.y, r1, c5
dp4 r2.w, r2, r2
rsq r1.x, r2.w
mul o5.xyz, r1.x, r2
dp3 r1.y, r3, r3
rsq r1.y, r1.y
mul o7.xyz, r1.y, r3
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c15.x
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c15.z
mul r3.y, r3, c12.x
mov r0.w, c15.x
mov r0.xyz, v1
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o8.xy, r3.z, c13.zwzw, r3
mul o2.xyz, r1.x, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
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
# 42 ALU
PARAM c[15] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.xyz, c[14];
MOV R1.w, c[0].y;
ADD R2, R0, -R1;
MOV result.texcoord[0], R0;
MOV R1.xyz, vertex.attrib[14];
MOV R1.w, c[0].x;
DP4 R3.z, R1, c[7];
DP4 R3.x, R1, c[5];
DP4 R3.y, R1, c[6];
DP4 R2.w, R2, R2;
RSQ R1.x, R2.w;
MUL result.texcoord[4].xyz, R1.x, R2;
DP3 R1.y, R3, R3;
RSQ R1.y, R1.y;
MUL result.texcoord[6].xyz, R1.y, R3;
MUL R2.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MAD R2.xyz, vertex.normal.z, c[11], R2;
ADD R2.xyz, R2, c[0].x;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R3.xyz, R1.xyww, c[0].z;
MUL R3.y, R3, c[13].x;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
DP3 R2.w, R2, R2;
MOV result.position, R1;
RSQ R1.x, R2.w;
ADD result.texcoord[7].xy, R3, R3.z;
MUL result.texcoord[1].xyz, R1.x, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MOV result.texcoord[2].xyz, c[0].x;
END
# 42 instructions, 4 R-regs
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
; 42 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c15.y
add r2, r0, -r1
mov o1, r0
mov r1.xyz, v3
mov r1.w, c15.x
dp4 r3.z, r1, c6
dp4 r3.x, r1, c4
dp4 r3.y, r1, c5
dp4 r2.w, r2, r2
rsq r1.x, r2.w
mul o5.xyz, r1.x, r2
dp3 r1.y, r3, r3
rsq r1.y, r1.y
mul o7.xyz, r1.y, r3
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c15.x
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c15.z
mul r3.y, r3, c12.x
mov r0.w, c15.x
mov r0.xyz, v1
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o8.xy, r3.z, c13.zwzw, r3
mul o2.xyz, r1.x, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
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
# 42 ALU
PARAM c[15] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.xyz, c[14];
MOV R1.w, c[0].y;
ADD R2, R0, -R1;
MOV result.texcoord[0], R0;
MOV R1.xyz, vertex.attrib[14];
MOV R1.w, c[0].x;
DP4 R3.z, R1, c[7];
DP4 R3.x, R1, c[5];
DP4 R3.y, R1, c[6];
DP4 R2.w, R2, R2;
RSQ R1.x, R2.w;
MUL result.texcoord[4].xyz, R1.x, R2;
DP3 R1.y, R3, R3;
RSQ R1.y, R1.y;
MUL result.texcoord[6].xyz, R1.y, R3;
MUL R2.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MAD R2.xyz, vertex.normal.z, c[11], R2;
ADD R2.xyz, R2, c[0].x;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R3.xyz, R1.xyww, c[0].z;
MUL R3.y, R3, c[13].x;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
DP3 R2.w, R2, R2;
MOV result.position, R1;
RSQ R1.x, R2.w;
ADD result.texcoord[7].xy, R3, R3.z;
MUL result.texcoord[1].xyz, R1.x, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MOV result.texcoord[2].xyz, c[0].x;
END
# 42 instructions, 4 R-regs
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
; 42 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c15.y
add r2, r0, -r1
mov o1, r0
mov r1.xyz, v3
mov r1.w, c15.x
dp4 r3.z, r1, c6
dp4 r3.x, r1, c4
dp4 r3.y, r1, c5
dp4 r2.w, r2, r2
rsq r1.x, r2.w
mul o5.xyz, r1.x, r2
dp3 r1.y, r3, r3
rsq r1.y, r1.y
mul o7.xyz, r1.y, r3
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c15.x
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c15.z
mul r3.y, r3, c12.x
mov r0.w, c15.x
mov r0.xyz, v1
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o8.xy, r3.z, c13.zwzw, r3
mul o2.xyz, r1.x, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
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
# 97 ALU
PARAM c[23] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MAD R2.xyz, vertex.normal.z, c[11], R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
ADD R2.xyz, R2, c[0].x;
MOV R1.x, c[14];
MOV R1.z, c[16].x;
MOV R1.y, c[15].x;
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R1;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, R1;
MUL R1.w, R1, c[17].x;
ADD R1.w, R1, c[0].y;
MAX R0.w, R0, c[0].x;
RCP R1.w, R1.w;
MOV R3.x, c[14].y;
MOV R3.z, c[16].y;
MOV R3.y, c[15];
ADD R3.xyz, -R0, R3;
DP3 R2.w, R3, R3;
RSQ R1.x, R2.w;
MUL R1.xyz, R1.x, R3;
MUL R3.xyz, R1.w, c[18];
MUL R3.xyz, R3, c[22];
DP3 R1.y, R2, R1;
MUL R2.w, R2, c[17].y;
ADD R1.x, R2.w, c[0].y;
MAX R2.w, R1.y, c[0].x;
RCP R1.x, R1.x;
MUL R1.xyz, R1.x, c[19];
MUL R1.xyz, R1, c[22];
MUL R4.xyz, R1, R2.w;
MAD R4.xyz, R3, R0.w, R4;
MOV R1.x, c[14].z;
MOV R1.z, c[16];
MOV R1.y, c[15].z;
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R2.w, R1.w;
MUL R0.w, R1, c[17].z;
MUL R1.xyz, R2.w, R1;
DP3 R1.y, R2, R1;
ADD R0.w, R0, c[0].y;
RCP R1.x, R0.w;
MAX R0.w, R1.y, c[0].x;
MUL R1.xyz, R1.x, c[20];
MUL R1.xyz, R1, c[22];
MAD R4.xyz, R1, R0.w, R4;
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MOV R3.x, c[14].w;
MOV R3.z, c[16].w;
MOV R3.y, c[15].w;
ADD R3.xyz, -R0, R3;
DP3 R2.w, R3, R3;
RSQ R3.w, R2.w;
MUL R3.xyz, R3.w, R3;
MUL R4.w, R2, c[17];
ADD R2.w, R4, c[0].y;
DP3 R3.w, R2, R3;
RCP R2.w, R2.w;
MUL R3.xyz, R2.w, c[21];
MAX R2.w, R3, c[0].x;
MUL R3.xyz, R3, c[22];
MAD result.texcoord[2].xyz, R3, R2.w, R4;
MOV R3.w, c[0].x;
MOV R3.xyz, vertex.attrib[14];
DP4 R4.z, R3, c[7];
DP4 R4.x, R3, c[5];
DP4 R4.y, R3, c[6];
DP3 R2.w, R4, R4;
RSQ R2.w, R2.w;
MOV R1.xyz, c[13];
MOV R1.w, c[0].y;
ADD R1, R0, -R1;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[4].xyz, R1.w, R1;
MUL result.texcoord[6].xyz, R2.w, R4;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 97 instructions, 5 R-regs
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
; 97 ALU
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
mul r2.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r2
mad r2.xyz, v1.z, c10, r2
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
add r2.xyz, r2, c22.x
mov r1.x, c13
mov r1.z, c15.x
mov r1.y, c14.x
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r0.w, r1.w
mul r1.xyz, r0.w, r1
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
dp3 r0.w, r2, r1
mul r1.w, r1, c16.x
add r1.w, r1, c22.y
max r0.w, r0, c22.x
rcp r1.w, r1.w
mov r3.x, c13.y
mov r3.z, c15.y
mov r3.y, c14
add r3.xyz, -r0, r3
dp3 r2.w, r3, r3
rsq r1.x, r2.w
mul r1.xyz, r1.x, r3
mul r3.xyz, r1.w, c17
mul r3.xyz, r3, c21
dp3 r1.y, r2, r1
mul r2.w, r2, c16.y
add r1.x, r2.w, c22.y
max r2.w, r1.y, c22.x
rcp r1.x, r1.x
mul r1.xyz, r1.x, c18
mul r1.xyz, r1, c21
mul r4.xyz, r1, r2.w
mad r4.xyz, r3, r0.w, r4
mov r1.x, c13.z
mov r1.z, c15
mov r1.y, c14.z
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r2.w, r1.w
mul r0.w, r1, c16.z
mul r1.xyz, r2.w, r1
dp3 r1.y, r2, r1
add r0.w, r0, c22.y
rcp r1.x, r0.w
max r0.w, r1.y, c22.x
mul r1.xyz, r1.x, c19
mul r1.xyz, r1, c21
mad r4.xyz, r1, r0.w, r4
dp4 r0.w, v0, c7
mov o1, r0
mov r3.x, c13.w
mov r3.z, c15.w
mov r3.y, c14.w
add r3.xyz, -r0, r3
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
mul r4.w, r2, c16
add r2.w, r4, c22.y
dp3 r3.w, r2, r3
rcp r2.w, r2.w
mul r3.xyz, r2.w, c20
max r2.w, r3, c22.x
mul r3.xyz, r3, c21
mad o3.xyz, r3, r2.w, r4
mov r3.w, c22.x
mov r3.xyz, v3
dp4 r4.z, r3, c6
dp4 r4.x, r3, c4
dp4 r4.y, r3, c5
dp3 r2.w, r4, r4
rsq r2.w, r2.w
mov r1.xyz, c12
mov r1.w, c22.y
add r1, r0, -r1
dp4 r1.w, r1, r1
rsq r1.w, r1.w
mov r0.w, c22.x
mov r0.xyz, v1
mul o5.xyz, r1.w, r1
mul o7.xyz, r2.w, r4
mov o2.xyz, r2
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
  tmpvar_11 = (tmpvar_10.xyz - tmpvar_4.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_11))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.y;
  tmpvar_12.y = unity_4LightPosY0.y;
  tmpvar_12.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_13)))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.z;
  tmpvar_14.y = unity_4LightPosY0.z;
  tmpvar_14.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.w;
  tmpvar_16.y = unity_4LightPosY0.w;
  tmpvar_16.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_17)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = tmpvar_7;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_8)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
  tmpvar_11 = (tmpvar_10.xyz - tmpvar_4.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_11))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.y;
  tmpvar_12.y = unity_4LightPosY0.y;
  tmpvar_12.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_13)))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.z;
  tmpvar_14.y = unity_4LightPosY0.z;
  tmpvar_14.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.w;
  tmpvar_16.y = unity_4LightPosY0.w;
  tmpvar_16.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_17)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = tmpvar_7;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_8)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_9;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  highp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_13), 0.0, 1.0);
  highp vec4 tmpvar_18;
  tmpvar_18 = ((pow ((tmpvar_17 * tmpvar_17), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_16 * -((tmpvar_12 + vec3(0.0, 0.0, 1.0))))), tmpvar_13), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = (frez * _FrezPow);
  frez = tmpvar_23;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_23), 0.0, 1.0));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_7) + tmpvar_8), 0.0, 1.0)) + tmpvar_11);
  color = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (color + (paintColor * _FlakePower));
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + reflTex);
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + (tmpvar_23 * reflTex));
  color = tmpvar_27;
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
# 102 ALU
PARAM c[24] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R2;
MAD R2.xyz, vertex.normal.z, c[11], R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
ADD R2.xyz, R2, c[0].x;
MOV R1.x, c[15];
MOV R1.z, c[17].x;
MOV R1.y, c[16].x;
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, R1;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.w, R2, R1;
MUL R1.w, R1, c[18].x;
ADD R1.w, R1, c[0].y;
MAX R0.w, R0, c[0].x;
RCP R1.w, R1.w;
MOV R3.x, c[15].y;
MOV R3.z, c[17].y;
MOV R3.y, c[16];
ADD R3.xyz, -R0, R3;
DP3 R2.w, R3, R3;
RSQ R1.x, R2.w;
MUL R1.xyz, R1.x, R3;
DP3 R1.y, R2, R1;
MUL R2.w, R2, c[18].y;
ADD R1.x, R2.w, c[0].y;
MAX R2.w, R1.y, c[0].x;
RCP R1.x, R1.x;
MUL R1.xyz, R1.x, c[20];
MUL R1.xyz, R1, c[23];
MUL R3.xyz, R1, R2.w;
MOV R1.x, c[15].z;
MOV R1.z, c[17];
MOV R1.y, c[16].z;
ADD R4.xyz, -R0, R1;
MUL R1.xyz, R1.w, c[19];
MUL R1.xyz, R1, c[23];
MAD R1.xyz, R1, R0.w, R3;
DP3 R1.w, R4, R4;
MUL R0.w, R1, c[18].z;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, R4;
ADD R0.w, R0, c[0].y;
DP3 R1.w, R2, R3;
RCP R0.w, R0.w;
MUL R3.xyz, R0.w, c[21];
MAX R0.w, R1, c[0].x;
MUL R3.xyz, R3, c[23];
MAD R4.xyz, R3, R0.w, R1;
DP4 R0.w, vertex.position, c[8];
MOV R1.x, c[15].w;
MOV R1.z, c[17].w;
MOV R1.y, c[16].w;
ADD R3.xyz, -R0, R1;
DP3 R2.w, R3, R3;
RSQ R3.w, R2.w;
MUL R3.xyz, R3.w, R3;
MUL R4.w, R2, c[18];
ADD R2.w, R4, c[0].y;
DP3 R3.w, R2, R3;
RCP R2.w, R2.w;
MUL R3.xyz, R2.w, c[22];
MAX R2.w, R3, c[0].x;
MUL R3.xyz, R3, c[23];
MAD result.texcoord[2].xyz, R3, R2.w, R4;
MOV R3.xyz, vertex.attrib[14];
MOV R3.w, c[0].x;
DP4 R4.z, R3, c[7];
DP4 R4.x, R3, c[5];
DP4 R4.y, R3, c[6];
MOV result.texcoord[0], R0;
MOV R1.xyz, c[14];
MOV R1.w, c[0].y;
ADD R1, R0, -R1;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL result.texcoord[4].xyz, R1.w, R1;
DP3 R2.w, R4, R4;
RSQ R1.z, R2.w;
MUL result.texcoord[6].xyz, R1.z, R4;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R3.xyz, R1.xyww, c[0].z;
MUL R3.y, R3, c[13].x;
ADD result.texcoord[7].xy, R3, R3.z;
MOV result.position, R1;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
END
# 102 instructions, 5 R-regs
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
; 102 ALU
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
mov r3.xyz, v3
mov r3.w, c24.x
dp4 r4.z, r3, c6
dp4 r4.x, r3, c4
dp4 r4.y, r3, c5
mov o1, r0
mov r1.xyz, c14
mov r1.w, c24.y
add r1, r0, -r1
dp4 r1.w, r1, r1
rsq r1.w, r1.w
mul o5.xyz, r1.w, r1
dp3 r2.w, r4, r4
rsq r1.z, r2.w
mul o7.xyz, r1.z, r4
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mov r0.w, c24.x
mov r0.xyz, v1
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c24.z
mul r3.y, r3, c12.x
mad o8.xy, r3.z, c13.zwzw, r3
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
  tmpvar_12 = (tmpvar_11.xyz - tmpvar_4.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17.xyz - tmpvar_4.xyz);
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_9)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
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
  tmpvar_12 = (tmpvar_11.xyz - tmpvar_4.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz - tmpvar_4.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17.xyz - tmpvar_4.xyz);
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
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_9)).xyz;
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
varying highp vec3 xlv_TEXCOORD2;
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
  highp vec3 specularReflection;
  highp float attenuation;
  highp vec3 lightDirection;
  highp vec4 textureColor;
  highp vec3 vFlakesNormal;
  lowp vec3 tmpvar_2;
  tmpvar_2 = texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz;
  vFlakesNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  textureColor = tmpvar_5;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_6;
    tmpvar_6 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_6;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0.xyz - xlv_TEXCOORD0.xyz));
  };
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = clamp (((gl_LightModel.ambient.xyz * _Color.xyz) * _Color.xyz), 0.0, 1.0);
  highp vec3 tmpvar_9;
  tmpvar_9 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_3), tmpvar_4)), _Shininess));
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((2.0 * vFlakesNormal) - 1.0);
  vFlakesNormal = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD4);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_10;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
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
  highp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + (4.0 * vec3(0.0, 0.0, 1.0)))))), tmpvar_14), 0.0, 1.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = ((pow ((tmpvar_18 * tmpvar_18), _OuterFlakePower) * _paintColor2) + (pow (clamp (dot (normalize ((tmpvar_17 * -((tmpvar_13 + vec3(0.0, 0.0, 1.0))))), tmpvar_14), 0.0, 1.0), _InterFlakePower) * _flakeLayerColor));
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, tmpvar_3);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, xlv_TEXCOORD1)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (reflTex.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + tmpvar_8) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (color + (paintColor * _FlakePower));
  color = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27 = (color + reflTex);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28 = (color + (tmpvar_24 * reflTex));
  color = tmpvar_28;
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 99 to 100, TEX: 3 to 4
//   d3d9 - ALU: 105 to 106, TEX: 3 to 4
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 99 ALU, 3 TEX
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
TEMP R9;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[17], c[17].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, -R0.w, R4;
MAD R0.xyz, -R0, c[17].z, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[17];
POW R0.y, R0.x, c[6].x;
SLT R0.x, R0.w, c[17];
MOV R1.xyz, c[5];
ABS R0.x, R0;
MUL R1.xyz, R1, c[16];
MUL R1.xyz, R1, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
CMP R5.xyz, -R0.x, R1, c[17].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[0], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R6.xyz, R7, c[18].xxyw;
MOV R2.y, R0.x;
MOV R1.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R6;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R0.x, -R6, R2;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.x, fragment.texcoord[6].y;
DP3 R0.y, -R6, R1;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R8.xyz, R1.w, R0;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R2.w;
MUL R9.xyz, R1.w, fragment.texcoord[4];
MUL R6.xyz, R5, c[7].x;
MOV R0.xyz, c[3];
MUL R5.xyz, R0, c[0];
MUL_SAT R5.xyz, R5, c[3];
DP3_SAT R1.w, R8, R9;
MAX R0.w, R0, c[17].x;
MUL R0.xyz, R0, c[16];
ADD R5.xyz, fragment.texcoord[2], R5;
MAD_SAT R5.xyz, R0, R0.w, R5;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R5, R6;
ADD R5.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R5;
DP3 R3.y, R1, -R5;
DP3 R3.x, R2, -R5;
DP3 R1.x, R4, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R9, R2;
MUL R1.xyz, R4, R1.x;
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
# 99 instructions, 10 R-regs
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 106 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c17, 0.00000000, 1.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
dp3 r0.x, c2, c2
dp3 r2.w, v4, v4
mov r8.xyz, c0
mul r8.xyz, c3, r8
mul_sat r8.xyz, r8, c3
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r1.w, r4, r1
mul r0.xyz, -r1.w, r4
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r0.w, r2
dp3 r0.x, r0, r2
max r1.x, r0, c17
pow r0, r1.x, c6.x
cmp r0.w, r1, c17.x, c17.y
mov r1.x, r0
mov r0.xyz, c16
mul r0.xyz, c5, r0
mul r1.xyz, r0, r1.x
abs_pp r0.x, r0.w
cmp r5.xyz, -r0.x, r1, c17.x
mul r0.zw, v3.xyxy, c8.x
mul r1.xy, r0.zwzw, c17.w
texld r1.xyz, r1, s0
mad r6.xyz, r1, c18.x, c18.y
add r7.xyz, r6, c18.zzww
mov r0.xyz, v6
mul r2.xyz, v1.zxyw, r0.yzxw
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
mov r2.y, r0
mov r1.y, r0.x
mov r3.y, r0.z
mov r2.z, v5.y
mov r2.x, v6.y
dp3 r0.y, -r7, r2
mov r1.z, v5.x
mov r1.x, v6
dp3 r0.x, -r7, r1
add r6.xyz, r6, c17.xxyw
mov r3.x, v6.z
mov r3.z, v5
dp3 r0.z, r3, -r7
dp3 r0.w, r0, r0
rsq r2.w, r2.w
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul r7.xyz, r2.w, v4
dp3_sat r0.x, r0, r7
mul r2.w, r0.x, r0.x
pow r0, r2.w, c11.x
mov r0.yzw, c16.xxyz
max r1.w, r1, c17.x
add r8.xyz, v2, r8
mul r0.yzw, c3.xxyz, r0
mad_sat r0.yzw, r0, r1.w, r8.xxyz
mov r1.w, r0.x
dp3 r0.x, r1, -r6
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c17.z, v4
mul r5.xyz, r5, c7.x
texld r8.xyz, v3, s1
mad r5.xyz, r8, r0.yzww, r5
dp3 r0.y, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_sat r0.x, r7, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17
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
add_pp r1.xyz, r5, r2
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 99 ALU, 3 TEX
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
TEMP R9;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[17], c[17].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, -R0.w, R4;
MAD R0.xyz, -R0, c[17].z, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[17];
POW R0.y, R0.x, c[6].x;
SLT R0.x, R0.w, c[17];
MOV R1.xyz, c[5];
ABS R0.x, R0;
MUL R1.xyz, R1, c[16];
MUL R1.xyz, R1, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
CMP R5.xyz, -R0.x, R1, c[17].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[0], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R6.xyz, R7, c[18].xxyw;
MOV R2.y, R0.x;
MOV R1.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R6;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R0.x, -R6, R2;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.x, fragment.texcoord[6].y;
DP3 R0.y, -R6, R1;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R8.xyz, R1.w, R0;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R2.w;
MUL R9.xyz, R1.w, fragment.texcoord[4];
MUL R6.xyz, R5, c[7].x;
MOV R0.xyz, c[3];
MUL R5.xyz, R0, c[0];
MUL_SAT R5.xyz, R5, c[3];
DP3_SAT R1.w, R8, R9;
MAX R0.w, R0, c[17].x;
MUL R0.xyz, R0, c[16];
ADD R5.xyz, fragment.texcoord[2], R5;
MAD_SAT R5.xyz, R0, R0.w, R5;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R5, R6;
ADD R5.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R5;
DP3 R3.y, R1, -R5;
DP3 R3.x, R2, -R5;
DP3 R1.x, R4, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R9, R2;
MUL R1.xyz, R4, R1.x;
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
# 99 instructions, 10 R-regs
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 106 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c17, 0.00000000, 1.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
dp3 r0.x, c2, c2
dp3 r2.w, v4, v4
mov r8.xyz, c0
mul r8.xyz, c3, r8
mul_sat r8.xyz, r8, c3
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r1.w, r4, r1
mul r0.xyz, -r1.w, r4
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r0.w, r2
dp3 r0.x, r0, r2
max r1.x, r0, c17
pow r0, r1.x, c6.x
cmp r0.w, r1, c17.x, c17.y
mov r1.x, r0
mov r0.xyz, c16
mul r0.xyz, c5, r0
mul r1.xyz, r0, r1.x
abs_pp r0.x, r0.w
cmp r5.xyz, -r0.x, r1, c17.x
mul r0.zw, v3.xyxy, c8.x
mul r1.xy, r0.zwzw, c17.w
texld r1.xyz, r1, s0
mad r6.xyz, r1, c18.x, c18.y
add r7.xyz, r6, c18.zzww
mov r0.xyz, v6
mul r2.xyz, v1.zxyw, r0.yzxw
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
mov r2.y, r0
mov r1.y, r0.x
mov r3.y, r0.z
mov r2.z, v5.y
mov r2.x, v6.y
dp3 r0.y, -r7, r2
mov r1.z, v5.x
mov r1.x, v6
dp3 r0.x, -r7, r1
add r6.xyz, r6, c17.xxyw
mov r3.x, v6.z
mov r3.z, v5
dp3 r0.z, r3, -r7
dp3 r0.w, r0, r0
rsq r2.w, r2.w
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul r7.xyz, r2.w, v4
dp3_sat r0.x, r0, r7
mul r2.w, r0.x, r0.x
pow r0, r2.w, c11.x
mov r0.yzw, c16.xxyz
max r1.w, r1, c17.x
add r8.xyz, v2, r8
mul r0.yzw, c3.xxyz, r0
mad_sat r0.yzw, r0, r1.w, r8.xxyz
mov r1.w, r0.x
dp3 r0.x, r1, -r6
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c17.z, v4
mul r5.xyz, r5, c7.x
texld r8.xyz, v3, s1
mad r5.xyz, r8, r0.yzww, r5
dp3 r0.y, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_sat r0.x, r7, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17
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
add_pp r1.xyz, r5, r2
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 99 ALU, 3 TEX
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
TEMP R9;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[17], c[17].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, -R0.w, R4;
MAD R0.xyz, -R0, c[17].z, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[17];
POW R0.y, R0.x, c[6].x;
SLT R0.x, R0.w, c[17];
MOV R1.xyz, c[5];
ABS R0.x, R0;
MUL R1.xyz, R1, c[16];
MUL R1.xyz, R1, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
CMP R5.xyz, -R0.x, R1, c[17].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[0], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R6.xyz, R7, c[18].xxyw;
MOV R2.y, R0.x;
MOV R1.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R6;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R0.x, -R6, R2;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.x, fragment.texcoord[6].y;
DP3 R0.y, -R6, R1;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R8.xyz, R1.w, R0;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R2.w;
MUL R9.xyz, R1.w, fragment.texcoord[4];
MUL R6.xyz, R5, c[7].x;
MOV R0.xyz, c[3];
MUL R5.xyz, R0, c[0];
MUL_SAT R5.xyz, R5, c[3];
DP3_SAT R1.w, R8, R9;
MAX R0.w, R0, c[17].x;
MUL R0.xyz, R0, c[16];
ADD R5.xyz, fragment.texcoord[2], R5;
MAD_SAT R5.xyz, R0, R0.w, R5;
MUL R0.w, R1, R1;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R5, R6;
ADD R5.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R5;
DP3 R3.y, R1, -R5;
DP3 R3.x, R2, -R5;
DP3 R1.x, R4, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R9, R2;
MUL R1.xyz, R4, R1.x;
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
# 99 instructions, 10 R-regs
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 106 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c17, 0.00000000, 1.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
dp3 r0.x, c2, c2
dp3 r2.w, v4, v4
mov r8.xyz, c0
mul r8.xyz, c3, r8
mul_sat r8.xyz, r8, c3
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r1.w, r4, r1
mul r0.xyz, -r1.w, r4
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r0.w, r2
dp3 r0.x, r0, r2
max r1.x, r0, c17
pow r0, r1.x, c6.x
cmp r0.w, r1, c17.x, c17.y
mov r1.x, r0
mov r0.xyz, c16
mul r0.xyz, c5, r0
mul r1.xyz, r0, r1.x
abs_pp r0.x, r0.w
cmp r5.xyz, -r0.x, r1, c17.x
mul r0.zw, v3.xyxy, c8.x
mul r1.xy, r0.zwzw, c17.w
texld r1.xyz, r1, s0
mad r6.xyz, r1, c18.x, c18.y
add r7.xyz, r6, c18.zzww
mov r0.xyz, v6
mul r2.xyz, v1.zxyw, r0.yzxw
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
mov r2.y, r0
mov r1.y, r0.x
mov r3.y, r0.z
mov r2.z, v5.y
mov r2.x, v6.y
dp3 r0.y, -r7, r2
mov r1.z, v5.x
mov r1.x, v6
dp3 r0.x, -r7, r1
add r6.xyz, r6, c17.xxyw
mov r3.x, v6.z
mov r3.z, v5
dp3 r0.z, r3, -r7
dp3 r0.w, r0, r0
rsq r2.w, r2.w
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul r7.xyz, r2.w, v4
dp3_sat r0.x, r0, r7
mul r2.w, r0.x, r0.x
pow r0, r2.w, c11.x
mov r0.yzw, c16.xxyz
max r1.w, r1, c17.x
add r8.xyz, v2, r8
mul r0.yzw, c3.xxyz, r0
mad_sat r0.yzw, r0, r1.w, r8.xxyz
mov r1.w, r0.x
dp3 r0.x, r1, -r6
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c17.z, v4
mul r5.xyz, r5, c7.x
texld r8.xyz, v3, s1
mad r5.xyz, r8, r0.yzww, r5
dp3 r0.y, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_sat r0.x, r7, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17
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
add_pp r1.xyz, r5, r2
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 4 TEX
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
TEMP R9;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[17], c[17].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
SLT R0.y, R0.w, c[17].x;
MAX R0.x, R0, c[17];
POW R0.z, R0.x, c[6].x;
TXP R0.x, fragment.texcoord[7], texture[2], 2D;
MUL R4.xyz, R0.x, c[16];
MUL R1.xyz, R4, c[5];
ABS R0.x, R0.y;
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R6.xyz, -R0.x, R1, c[17].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[0], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0.x;
MOV R1.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R0.x, -R8, R2;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R8.xyz, R1.w, R0;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R2.w;
MUL R9.xyz, R1.w, fragment.texcoord[4];
MOV R0.xyz, c[3];
MUL R0.xyz, R0, c[0];
MUL_SAT R0.xyz, R0, c[3];
DP3_SAT R1.w, R8, R9;
MAX R0.w, R0, c[17].x;
ADD R0.xyz, fragment.texcoord[2], R0;
MUL R4.xyz, R4, c[3];
MAD_SAT R4.xyz, R4, R0.w, R0;
MUL R0.w, R1, R1;
POW R0.w, R0.w, c[11].x;
MUL R6.xyz, R6, c[7].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.y, R1, -R4;
DP3 R3.x, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R9, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
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
# 100 instructions, 10 R-regs
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 105 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c17, 0.00000000, 1.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
dp3 r0.x, c2, c2
dp3 r2.w, v4, v4
rsq r2.w, r2.w
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r0.w, r2
dp3 r0.x, r0, r2
max r1.x, r0, c17
pow r0, r1.x, c6.x
mov r0.y, r0.x
texldp r1.x, v7, s2
mul r4.xyz, r1.x, c16
mul r1.xyz, r4, c5
cmp r0.x, r1.w, c17, c17.y
mul r1.xyz, r1, r0.y
abs_pp r0.x, r0
cmp r0.xyz, -r0.x, r1, c17.x
mul r7.xyz, r0, c7.x
mov r0.xyz, v6
mul r2.xyz, v1.zxyw, r0.yzxw
mul r1.xy, v3, c8.x
mul r1.xy, r1, c17.w
texld r1.xyz, r1, s0
mad r8.xyz, r1, c18.x, c18.y
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
add r6.xyz, r8, c18.zzww
mov r2.y, r0
mov r1.y, r0.x
mov r3.y, r0.z
mov r2.z, v5.y
mov r2.x, v6.y
dp3 r0.y, -r6, r2
mov r1.z, v5.x
mov r1.x, v6
dp3 r0.x, -r6, r1
mul r9.xyz, r2.w, v4
mov r3.x, v6.z
mov r3.z, v5
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_sat r0.w, r0, r9
mov r0.xyz, c0
mul r6.xyz, c3, r0
mul r2.w, r0, r0
pow r0, r2.w, c11.x
max r0.y, r1.w, c17.x
mul_sat r6.xyz, r6, c3
mov r1.w, r0.x
mul r4.xyz, r4, c3
add r6.xyz, v2, r6
mad_sat r6.xyz, r4, r0.y, r6
texld r4.xyz, v3, s1
mad r4.xyz, r4, r6, r7
add r6.xyz, r8, c17.xxyw
dp3 r0.x, r1, -r6
dp3 r1.x, r5, v4
mul r1.xyz, r5, r1.x
dp3 r0.y, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v4
dp3_sat r0.x, r9, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 4 TEX
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
TEMP R9;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[17], c[17].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
SLT R0.y, R0.w, c[17].x;
MAX R0.x, R0, c[17];
POW R0.z, R0.x, c[6].x;
TXP R0.x, fragment.texcoord[7], texture[2], 2D;
MUL R4.xyz, R0.x, c[16];
MUL R1.xyz, R4, c[5];
ABS R0.x, R0.y;
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R6.xyz, -R0.x, R1, c[17].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[0], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0.x;
MOV R1.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R0.x, -R8, R2;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R8.xyz, R1.w, R0;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R2.w;
MUL R9.xyz, R1.w, fragment.texcoord[4];
MOV R0.xyz, c[3];
MUL R0.xyz, R0, c[0];
MUL_SAT R0.xyz, R0, c[3];
DP3_SAT R1.w, R8, R9;
MAX R0.w, R0, c[17].x;
ADD R0.xyz, fragment.texcoord[2], R0;
MUL R4.xyz, R4, c[3];
MAD_SAT R4.xyz, R4, R0.w, R0;
MUL R0.w, R1, R1;
POW R0.w, R0.w, c[11].x;
MUL R6.xyz, R6, c[7].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.y, R1, -R4;
DP3 R3.x, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R9, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
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
# 100 instructions, 10 R-regs
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 105 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c17, 0.00000000, 1.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
dp3 r0.x, c2, c2
dp3 r2.w, v4, v4
rsq r2.w, r2.w
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r0.w, r2
dp3 r0.x, r0, r2
max r1.x, r0, c17
pow r0, r1.x, c6.x
mov r0.y, r0.x
texldp r1.x, v7, s2
mul r4.xyz, r1.x, c16
mul r1.xyz, r4, c5
cmp r0.x, r1.w, c17, c17.y
mul r1.xyz, r1, r0.y
abs_pp r0.x, r0
cmp r0.xyz, -r0.x, r1, c17.x
mul r7.xyz, r0, c7.x
mov r0.xyz, v6
mul r2.xyz, v1.zxyw, r0.yzxw
mul r1.xy, v3, c8.x
mul r1.xy, r1, c17.w
texld r1.xyz, r1, s0
mad r8.xyz, r1, c18.x, c18.y
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
add r6.xyz, r8, c18.zzww
mov r2.y, r0
mov r1.y, r0.x
mov r3.y, r0.z
mov r2.z, v5.y
mov r2.x, v6.y
dp3 r0.y, -r6, r2
mov r1.z, v5.x
mov r1.x, v6
dp3 r0.x, -r6, r1
mul r9.xyz, r2.w, v4
mov r3.x, v6.z
mov r3.z, v5
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_sat r0.w, r0, r9
mov r0.xyz, c0
mul r6.xyz, c3, r0
mul r2.w, r0, r0
pow r0, r2.w, c11.x
max r0.y, r1.w, c17.x
mul_sat r6.xyz, r6, c3
mov r1.w, r0.x
mul r4.xyz, r4, c3
add r6.xyz, v2, r6
mad_sat r6.xyz, r4, r0.y, r6
texld r4.xyz, v3, s1
mad r4.xyz, r4, r6, r7
add r6.xyz, r8, c17.xxyw
dp3 r0.x, r1, -r6
dp3 r1.x, r5, v4
mul r1.xyz, r5, r1.x
dp3 r0.y, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v4
dp3_sat r0.x, r9, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 4 TEX
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
TEMP R9;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[17], c[17].y;
ABS R0.x, R0;
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[17], c[17].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R5.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R5, R1;
MUL R0.xyz, -R0.w, R5;
MAD R0.xyz, -R0, c[17].z, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
SLT R0.y, R0.w, c[17].x;
MAX R0.x, R0, c[17];
POW R0.z, R0.x, c[6].x;
TXP R0.x, fragment.texcoord[7], texture[2], 2D;
MUL R4.xyz, R0.x, c[16];
MUL R1.xyz, R4, c[5];
ABS R0.x, R0.y;
MUL R1.xyz, R1, R0.z;
CMP R0.x, -R0, c[17], c[17].y;
CMP R6.xyz, -R0.x, R1, c[17].x;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[17].w;
TEX R1.xyz, R1, texture[0], 2D;
MAD R7.xyz, R1, c[17].z, -c[17].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[18].xxyw;
MOV R2.y, R0.x;
MOV R1.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R0.z, R3, -R8;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R0.x, -R8, R2;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.x, fragment.texcoord[6].y;
DP3 R0.y, -R8, R1;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R8.xyz, R1.w, R0;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R2.w;
MUL R9.xyz, R1.w, fragment.texcoord[4];
MOV R0.xyz, c[3];
MUL R0.xyz, R0, c[0];
MUL_SAT R0.xyz, R0, c[3];
DP3_SAT R1.w, R8, R9;
MAX R0.w, R0, c[17].x;
ADD R0.xyz, fragment.texcoord[2], R0;
MUL R4.xyz, R4, c[3];
MAD_SAT R4.xyz, R4, R0.w, R0;
MUL R0.w, R1, R1;
POW R0.w, R0.w, c[11].x;
MUL R6.xyz, R6, c[7].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R4, R6;
ADD R4.xyz, R7, c[17].xxyw;
DP3 R3.z, R3, -R4;
DP3 R3.y, R1, -R4;
DP3 R3.x, R2, -R4;
DP3 R1.x, R5, fragment.texcoord[4];
DP3 R1.w, R3, R3;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R3;
DP3_SAT R1.w, R9, R2;
MUL R1.xyz, R5, R1.x;
MAD R1.xyz, -R1, c[17].z, fragment.texcoord[4];
DP3 R2.w, fragment.texcoord[1], R1;
ABS_SAT R2.x, R2.w;
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
# 100 instructions, 10 R-regs
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
SetTexture 0 [_SparkleTex] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 105 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c17, 0.00000000, 1.00000000, 2.00000000, 20.00000000
def c18, 2.00000000, -1.00000000, 0.00000000, 4.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
add r1.xyz, -v0, c2
dp3 r0.y, r1, r1
rsq r0.y, r0.y
dp3 r0.x, c2, c2
dp3 r2.w, v4, v4
rsq r2.w, r2.w
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r5.xyz, r0.x, v1
dp3 r1.w, r5, r1
mul r0.xyz, -r1.w, r5
mad r0.xyz, -r0, c17.z, -r1
mul r2.xyz, r0.w, r2
dp3 r0.x, r0, r2
max r1.x, r0, c17
pow r0, r1.x, c6.x
mov r0.y, r0.x
texldp r1.x, v7, s2
mul r4.xyz, r1.x, c16
mul r1.xyz, r4, c5
cmp r0.x, r1.w, c17, c17.y
mul r1.xyz, r1, r0.y
abs_pp r0.x, r0
cmp r0.xyz, -r0.x, r1, c17.x
mul r7.xyz, r0, c7.x
mov r0.xyz, v6
mul r2.xyz, v1.zxyw, r0.yzxw
mul r1.xy, v3, c8.x
mul r1.xy, r1, c17.w
texld r1.xyz, r1, s0
mad r8.xyz, r1, c18.x, c18.y
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
add r6.xyz, r8, c18.zzww
mov r2.y, r0
mov r1.y, r0.x
mov r3.y, r0.z
mov r2.z, v5.y
mov r2.x, v6.y
dp3 r0.y, -r6, r2
mov r1.z, v5.x
mov r1.x, v6
dp3 r0.x, -r6, r1
mul r9.xyz, r2.w, v4
mov r3.x, v6.z
mov r3.z, v5
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_sat r0.w, r0, r9
mov r0.xyz, c0
mul r6.xyz, c3, r0
mul r2.w, r0, r0
pow r0, r2.w, c11.x
max r0.y, r1.w, c17.x
mul_sat r6.xyz, r6, c3
mov r1.w, r0.x
mul r4.xyz, r4, c3
add r6.xyz, v2, r6
mad_sat r6.xyz, r4, r0.y, r6
texld r4.xyz, v3, s1
mad r4.xyz, r4, r6, r7
add r6.xyz, r8, c17.xxyw
dp3 r0.x, r1, -r6
dp3 r1.x, r5, v4
mul r1.xyz, r5, r1.x
dp3 r0.y, r2, -r6
dp3 r0.z, r3, -r6
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad r1.xyz, -r1, c17.z, v4
dp3_sat r0.x, r9, r0
dp3_pp r0.w, v1, r1
pow r2, r0.x, c10.x
abs_pp_sat r0.y, r0.w
add_pp r2.y, -r0, c17
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

#LINE 291

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}