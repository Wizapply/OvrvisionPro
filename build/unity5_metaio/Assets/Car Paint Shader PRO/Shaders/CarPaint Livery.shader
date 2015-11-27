Shader "RedDotGames/Car Paint Livery" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
      _DecalMap ("Livery Texture", 2D) = "white" {}
      _decalPower ("Livery Power", Range (0.0, 1.0)) = 0.5
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
//   opengl - ALU: 35 to 96
//   d3d9 - ALU: 35 to 96
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
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
"3.0-!!ARBvp1.0
# 91 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.x, c[14];
MOV R1.z, c[16].x;
MOV R1.y, c[15].x;
ADD R2.xyz, -R0, R1;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
MUL R0.w, R0, c[17].x;
ADD R0.w, R0, c[0].y;
MUL R2.xyz, R1.w, R2;
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.w, R1, R2;
MAX R1.w, R1, c[0].x;
RCP R0.w, R0.w;
MOV R3.x, c[14].y;
MOV R3.z, c[16].y;
MOV R3.y, c[15];
ADD R3.xyz, -R0, R3;
DP3 R2.w, R3, R3;
RSQ R3.w, R2.w;
MUL R2.xyz, R3.w, R3;
DP3 R2.y, R1, R2;
MUL R2.x, R2.w, c[17].y;
ADD R2.x, R2, c[0].y;
MAX R2.w, R2.y, c[0].x;
RCP R2.x, R2.x;
MUL R2.xyz, R2.x, c[19];
MUL R4.xyz, R2, R2.w;
MOV R3.w, c[0].x;
MOV R2.x, c[14].w;
MOV R2.z, c[16].w;
MOV R2.y, c[15].w;
ADD R3.xyz, -R0, R2;
MUL R2.xyz, R0.w, c[18];
MAD R4.xyz, R2, R1.w, R4;
DP3 R0.w, R3, R3;
RSQ R2.w, R0.w;
MUL R3.xyz, R2.w, R3;
MOV R2.x, c[14].z;
MOV R2.z, c[16];
MOV R2.y, c[15].z;
ADD R2.xyz, -R0, R2;
DP3 R1.w, R2, R2;
RSQ R2.w, R1.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, R1, R2;
MUL R1.w, R1, c[17].z;
ADD R1.w, R1, c[0].y;
MAX R2.w, R2.x, c[0].x;
RCP R1.w, R1.w;
MUL R2.xyz, R1.w, c[20];
MAD R2.xyz, R2, R2.w, R4;
DP3 R2.w, R1, R3;
MOV R3.xyz, vertex.attrib[14];
MUL R1.w, R0, c[17];
MAX R0.w, R2, c[0].x;
ADD R2.w, R1, c[0].y;
DP4 R4.z, R3, c[7];
DP4 R4.x, R3, c[5];
DP4 R4.y, R3, c[6];
DP3 R1.w, R4, R4;
RCP R2.w, R2.w;
RSQ R1.w, R1.w;
MUL R3.xyz, R2.w, c[21];
MAD result.texcoord[2].xyz, R3, R0.w, R2;
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[6].xyz, R1.w, R4;
MOV result.texcoord[1].xyz, R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 91 instructions, 5 R-regs
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
"vs_3_0
; 91 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c13
mov r1.z, c15.x
mov r1.y, c14.x
add r2.xyz, -r0, r1
dp3 r0.w, r2, r2
rsq r1.w, r0.w
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
mul r0.w, r0, c16.x
add r0.w, r0, c21.y
mul r2.xyz, r1.w, r2
add r1.xyz, r1, c21.x
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.w, r1, r2
max r1.w, r1, c21.x
rcp r0.w, r0.w
mov r3.x, c13.y
mov r3.z, c15.y
mov r3.y, c14
add r3.xyz, -r0, r3
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r2.xyz, r3.w, r3
dp3 r2.y, r1, r2
mul r2.x, r2.w, c16.y
add r2.x, r2, c21.y
max r2.w, r2.y, c21.x
rcp r2.x, r2.x
mul r2.xyz, r2.x, c18
mul r4.xyz, r2, r2.w
mov r3.w, c21.x
mov r2.x, c13.w
mov r2.z, c15.w
mov r2.y, c14.w
add r3.xyz, -r0, r2
mul r2.xyz, r0.w, c17
mad r4.xyz, r2, r1.w, r4
dp3 r0.w, r3, r3
rsq r2.w, r0.w
mul r3.xyz, r2.w, r3
mov r2.x, c13.z
mov r2.z, c15
mov r2.y, c14.z
add r2.xyz, -r0, r2
dp3 r1.w, r2, r2
rsq r2.w, r1.w
mul r2.xyz, r2.w, r2
dp3 r2.x, r1, r2
mul r1.w, r1, c16.z
add r1.w, r1, c21.y
max r2.w, r2.x, c21.x
rcp r1.w, r1.w
mul r2.xyz, r1.w, c19
mad r2.xyz, r2, r2.w, r4
dp3 r2.w, r1, r3
mov r3.xyz, v3
mul r1.w, r0, c16
max r0.w, r2, c21.x
add r2.w, r1, c21.y
dp4 r4.z, r3, c6
dp4 r4.x, r3, c4
dp4 r4.y, r3, c5
dp3 r1.w, r4, r4
rcp r2.w, r2.w
rsq r1.w, r1.w
mul r3.xyz, r2.w, c20
mad o3.xyz, r3, r0.w, r2
dp4 r0.w, v0, c7
mov o1, r0
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c21.x
mov r0.xyz, v1
mul o7.xyz, r1.w, r4
mov o2.xyz, r1
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
  tmpvar_3 = (((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[0].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_11))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.y;
  tmpvar_12.y = unity_4LightPosY0.y;
  tmpvar_12.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[1].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_13)))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.z;
  tmpvar_14.y = unity_4LightPosY0.z;
  tmpvar_14.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[2].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.w;
  tmpvar_16.y = unity_4LightPosY0.w;
  tmpvar_16.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[3].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_17)))));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
  tmpvar_3 = (((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_11, tmpvar_11))))) * unity_LightColor[0].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_11))));
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.y;
  tmpvar_12.y = unity_4LightPosY0.y;
  tmpvar_12.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[1].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_13)))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.z;
  tmpvar_14.y = unity_4LightPosY0.z;
  tmpvar_14.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[2].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.w;
  tmpvar_16.y = unity_4LightPosY0.w;
  tmpvar_16.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[3].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_17)))));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  highp vec3 vFlakesNormal;
  highp vec3 specularReflection;
  highp vec3 lightDirection;
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    lightDirection = normalize ((_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (_LightColor0.xyz * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_23 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp ((_Reflection + tmpvar_25), 0.0, 1.0);
  reflTex.xyz = (tmpvar_22.xyz * tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  color = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_9), 0.0, 1.0)) + tmpvar_12);
  det = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (color + (paintColor * _FlakePower));
  color = tmpvar_30;
  color = ((color + reflTex) + (tmpvar_25 * reflTex));
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
"3.0-!!ARBvp1.0
# 96 ALU
PARAM c[23] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R2.xyz, vertex.normal.z, c[11], R0;
ADD R2.xyz, R2, c[0].x;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.x, c[15].z;
MOV R1.z, c[17];
MOV R1.y, c[16].z;
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R2.w, R0.w;
MUL R1.xyz, R2.w, R1;
DP3 R1.w, R2, R1;
MOV R1.x, c[15];
MOV R1.z, c[17].x;
MOV R1.y, c[16].x;
ADD R3.xyz, -R0, R1;
DP3 R2.w, R3, R3;
RSQ R4.y, R2.w;
MUL R3.xyz, R4.y, R3;
DP3 R3.x, R2, R3;
MAX R1.w, R1, c[0].x;
MUL R0.w, R0, c[18].z;
MOV R1.x, c[15].y;
MOV R1.z, c[17].y;
MOV R1.y, c[16];
ADD R1.xyz, -R0, R1;
DP3 R3.w, R1, R1;
RSQ R4.x, R3.w;
MUL R1.xyz, R4.x, R1;
DP3 R1.x, R2, R1;
MAX R4.x, R3, c[0];
MAX R3.x, R1, c[0];
MUL R1.x, R2.w, c[18];
ADD R1.x, R1, c[0].y;
MUL R1.y, R3.w, c[18];
ADD R1.y, R1, c[0];
RCP R2.w, R1.x;
RCP R1.y, R1.y;
MUL R1.xyz, R1.y, c[20];
MUL R3.xyz, R1, R3.x;
MUL R1.xyz, R2.w, c[19];
MAD R4.xyz, R1, R4.x, R3;
ADD R2.w, R0, c[0].y;
RCP R3.x, R2.w;
MUL R3.xyz, R3.x, c[21];
MAD R3.xyz, R3, R1.w, R4;
MOV R1.w, c[0].x;
MOV R1.x, c[15].w;
MOV R1.z, c[17].w;
MOV R1.y, c[16].w;
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R2.w, R0.w;
MUL R1.xyz, R2.w, R1;
DP3 R1.y, R2, R1;
MUL R0.w, R0, c[18];
ADD R1.x, R0.w, c[0].y;
MAX R0.w, R1.y, c[0].x;
RCP R2.w, R1.x;
MOV R1.xyz, vertex.attrib[14];
DP4 R4.z, R1, c[7];
DP4 R4.x, R1, c[5];
DP4 R4.y, R1, c[6];
MUL R1.xyz, R2.w, c[22];
MAD result.texcoord[2].xyz, R1, R0.w, R3;
DP3 R1.w, R4, R4;
RSQ R0.w, R1.w;
MUL result.texcoord[6].xyz, R0.w, R4;
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
# 96 instructions, 5 R-regs
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
"vs_3_0
; 96 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c23, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r2.xyz, v1.z, c10, r0
add r2.xyz, r2, c23.x
dp3 r1.w, r2, r2
rsq r1.w, r1.w
mul r2.xyz, r1.w, r2
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c15.z
mov r1.z, c17
mov r1.y, c16.z
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r2.w, r0.w
mul r1.xyz, r2.w, r1
dp3 r1.w, r2, r1
mov r1.x, c15
mov r1.z, c17.x
mov r1.y, c16.x
add r3.xyz, -r0, r1
dp3 r2.w, r3, r3
rsq r4.y, r2.w
mul r3.xyz, r4.y, r3
dp3 r3.x, r2, r3
max r1.w, r1, c23.x
mul r0.w, r0, c18.z
mov r1.x, c15.y
mov r1.z, c17.y
mov r1.y, c16
add r1.xyz, -r0, r1
dp3 r3.w, r1, r1
rsq r4.x, r3.w
mul r1.xyz, r4.x, r1
dp3 r1.x, r2, r1
max r4.x, r3, c23
max r3.x, r1, c23
mul r1.x, r2.w, c18
add r1.x, r1, c23.y
mul r1.y, r3.w, c18
add r1.y, r1, c23
rcp r2.w, r1.x
rcp r1.y, r1.y
mul r1.xyz, r1.y, c20
mul r3.xyz, r1, r3.x
mul r1.xyz, r2.w, c19
mad r4.xyz, r1, r4.x, r3
add r2.w, r0, c23.y
rcp r3.x, r2.w
mul r3.xyz, r3.x, c21
mad r3.xyz, r3, r1.w, r4
mov r1.w, c23.x
mov r1.x, c15.w
mov r1.z, c17.w
mov r1.y, c16.w
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r2.w, r0.w
mul r1.xyz, r2.w, r1
dp3 r1.y, r2, r1
mul r0.w, r0, c18
add r1.x, r0.w, c23.y
max r0.w, r1.y, c23.x
rcp r2.w, r1.x
mov r1.xyz, v3
dp4 r4.z, r1, c6
dp4 r4.x, r1, c4
dp4 r4.y, r1, c5
mul r1.xyz, r2.w, c22
mad o3.xyz, r1, r0.w, r3
dp3 r1.w, r4, r4
rsq r0.w, r1.w
mul o7.xyz, r0.w, r4
dp4 r0.w, v0, c7
mov o1, r0
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mov r0.w, c23.x
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c23.z
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
  tmpvar_3 = (((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_18, tmpvar_18))))) * unity_LightColor[3].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_18)))));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
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
  tmpvar_3 = (((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17 - tmpvar_4).xyz;
  tmpvar_3 = (tmpvar_3 + (((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_18, tmpvar_18))))) * unity_LightColor[3].xyz) * max (0.0, dot (tmpvar_7, normalize (tmpvar_18)))));
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
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _flakeLayerColor;
uniform highp float _decalPower;
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
uniform sampler2D _DecalMap;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  highp vec4 tmpvar_1;
  lowp vec4 det;
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
  highp vec4 detail;
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
  highp vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_DecalMap, tmpvar_6);
  detail = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lowp vec3 tmpvar_8;
    tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
    lightDirection = tmpvar_8;
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_9)));
    lightDirection = normalize (tmpvar_9);
  };
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  attenuation = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  highp vec3 tmpvar_12;
  tmpvar_12 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_2), tmpvar_3)), _Shininess));
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
  tmpvar_25 = abs (dot (reflectedDir, xlv_TEXCOORD1));
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp ((_Reflection + tmpvar_27), 0.0, 1.0);
  reflTex.xyz = (tmpvar_24.xyz * tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((textureColor.xyz * _Color.xyz) * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  color = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((detail.xyz * clamp (((xlv_TEXCOORD2 + gl_LightModel.ambient.xyz) + tmpvar_11), 0.0, 1.0)) + tmpvar_14);
  det = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = mix (color.xyz, det.xyz, vec3((detail.w * _decalPower)));
  color.xyz = tmpvar_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (color + (paintColor * _FlakePower));
  color = tmpvar_32;
  color = ((color + reflTex) + (tmpvar_27 * reflTex));
  color.w = _Color.w;
  tmpvar_1 = color;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 100 to 101, TEX: 4 to 5
//   d3d9 - ALU: 104 to 104, TEX: 4 to 5
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 4 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 20 },
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
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
ABS R0.x, R0;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R3.xyz, R3, c[3];
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, R4, -R0.w;
MAD R0.xyz, -R0, c[18].x, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[18].z;
POW R0.y, R0.x, c[6].x;
SLT R0.x, R0.w, c[18].z;
MOV R1.xyz, c[5];
ABS R0.x, R0;
MUL R1.xyz, R1, c[17];
MUL R1.xyz, R1, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R0.xyz, -R0.x, R1, c[18].z;
MUL R2.xyz, R0, c[7].x;
MAX R0.x, R0.w, c[18].z;
ADD R1.xyz, fragment.texcoord[2], c[0];
MAD_SAT R1.xyz, R0.x, c[17], R1;
MAD R5.xyz, R1, R3, R2;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R1, R2;
ADD R6.xyz, R0, -R5;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[18].w;
TEX R1.xyz, R1, texture[2], 2D;
MAD R7.xyz, R1, c[18].x, -c[18].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[19].xxyw;
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
RSQ R1.w, R1.w;
RSQ R2.w, R2.w;
MUL R0.xyz, R1.w, R0;
MUL R8.xyz, R2.w, fragment.texcoord[4];
DP3_SAT R1.w, R0, R8;
MUL R0.x, R0.w, c[12];
MAD R0.xyz, R0.x, R6, R5;
ADD R5.xyz, R7, c[18].zzyw;
DP3 R3.z, R3, -R5;
DP3 R3.x, R1, -R5;
MUL R0.w, R1, R1;
DP3 R3.y, R2, -R5;
DP3 R1.y, R3, R3;
RSQ R1.w, R1.y;
MUL R2.xyz, R1.w, R3;
DP3_SAT R2.x, R8, R2;
DP3 R1.x, R4, fragment.texcoord[4];
MUL R1.xyz, R4, R1.x;
MAD R1.xyz, -R1, c[18].x, fragment.texcoord[4];
DP3 R1.w, R1, fragment.texcoord[1];
POW R2.x, R2.x, c[10].x;
ABS R1.w, R1;
POW R0.w, R0.w, c[11].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R0.w, c[13], R2;
ADD R1.w, -R1, c[18].y;
POW R0.w, R1.w, c[16].x;
MUL R0.w, R0, c[15].x;
MUL R2.xyz, R2, c[9].x;
ADD R2.xyz, R0, R2;
TEX R0.xyz, R1, texture[3], CUBE;
ADD_SAT R1.w, R0, c[4].x;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R2;
MAD result.color.xyz, R0.w, R0, R1;
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 104 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c18, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c19, 2.00000000, -1.00000000, 0.00000000, 4.00000000
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
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r1.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r0.w, r4, r1
mul r0.xyz, r4, -r0.w
mad r0.xyz, -r0, c18.x, -r1
mul r2.xyz, r1.w, r2
dp3 r0.x, r0, r2
max r0.x, r0, c18.z
pow r1, r0.x, c6.x
mov r1.y, r1.x
cmp r1.x, r0.w, c18.z, c18.y
mov r0.xyz, c17
mul r0.xyz, c5, r0
mul r2.xyz, r0, r1.y
abs_pp r0.x, r1
cmp r0.xyz, -r0.x, r2, c18.z
mul r6.xyz, r0, c7.x
mul r1.xy, v3, c8.x
mul r0.xy, r1, c18.w
mov r1.xyz, v6
mul r2.xyz, v1.zxyw, r1.yzxw
texld r0.xyz, r0, s2
mad r7.xyz, r0, c19.x, c19.y
mov r1.xyz, v6
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mov r3.y, r1.z
mov r2.y, r1.x
add r0.xyz, r7, c19.zzww
mov r3.x, v6.z
mov r3.z, v5
dp3 r9.z, r3, -r0
mov r2.z, v5.x
mov r2.x, v6
dp3 r9.x, -r0, r2
mov r1.z, v5.y
mov r1.x, v6.y
dp3 r9.y, -r0, r1
dp3 r1.w, r9, r9
add r0.xyz, v2, c0
max r0.w, r0, c18.z
mad_sat r5.xyz, r0.w, c17, r0
texld r0, v3, s1
mad r8.xyz, r0, r5, r6
rsq r0.x, r1.w
dp3 r0.y, v4, v4
rsq r1.w, r0.y
mul r9.xyz, r0.x, r9
mul r10.xyz, r1.w, v4
texld r0.xyz, v3, s0
mul r0.xyz, r0, c3
mad r0.xyz, r5, r0, r6
dp3_sat r1.w, r9, r10
mul r1.w, r1, r1
pow r5, r1.w, c11.x
add_pp r6.xyz, r8, -r0
mul r0.w, r0, c12.x
mad_pp r0.xyz, r0.w, r6, r0
add r6.xyz, r7, c18.zzyw
dp3 r3.z, r3, -r6
dp3 r3.y, r1, -r6
dp3 r3.x, r2, -r6
dp3 r1.y, r3, r3
rsq r1.w, r1.y
mul r2.xyz, r1.w, r3
dp3_sat r3.x, r10, r2
pow r2, r3.x, c10.x
mov r3.x, r2
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c18.x, v4
dp3_pp r1.w, r1, v1
abs_pp r1.w, r1
add_pp r1.w, -r1, c18.y
pow_pp r2, r1.w, c16.x
mov r0.w, r5.x
mul r3.xyz, r3.x, c14
mad r3.xyz, r0.w, c13, r3
mov_pp r0.w, r2.x
mul_pp r0.w, r0, c15.x
mul r2.xyz, r3, c9.x
add_pp r2.xyz, r0, r2
texld r0.xyz, r1, s3
add_sat r1.w, r0, c4.x
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 4 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 20 },
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
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
ABS R0.x, R0;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R3.xyz, R3, c[3];
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, R4, -R0.w;
MAD R0.xyz, -R0, c[18].x, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[18].z;
POW R0.y, R0.x, c[6].x;
SLT R0.x, R0.w, c[18].z;
MOV R1.xyz, c[5];
ABS R0.x, R0;
MUL R1.xyz, R1, c[17];
MUL R1.xyz, R1, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R0.xyz, -R0.x, R1, c[18].z;
MUL R2.xyz, R0, c[7].x;
MAX R0.x, R0.w, c[18].z;
ADD R1.xyz, fragment.texcoord[2], c[0];
MAD_SAT R1.xyz, R0.x, c[17], R1;
MAD R5.xyz, R1, R3, R2;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R1, R2;
ADD R6.xyz, R0, -R5;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[18].w;
TEX R1.xyz, R1, texture[2], 2D;
MAD R7.xyz, R1, c[18].x, -c[18].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[19].xxyw;
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
RSQ R1.w, R1.w;
RSQ R2.w, R2.w;
MUL R0.xyz, R1.w, R0;
MUL R8.xyz, R2.w, fragment.texcoord[4];
DP3_SAT R1.w, R0, R8;
MUL R0.x, R0.w, c[12];
MAD R0.xyz, R0.x, R6, R5;
ADD R5.xyz, R7, c[18].zzyw;
DP3 R3.z, R3, -R5;
DP3 R3.x, R1, -R5;
MUL R0.w, R1, R1;
DP3 R3.y, R2, -R5;
DP3 R1.y, R3, R3;
RSQ R1.w, R1.y;
MUL R2.xyz, R1.w, R3;
DP3_SAT R2.x, R8, R2;
DP3 R1.x, R4, fragment.texcoord[4];
MUL R1.xyz, R4, R1.x;
MAD R1.xyz, -R1, c[18].x, fragment.texcoord[4];
DP3 R1.w, R1, fragment.texcoord[1];
POW R2.x, R2.x, c[10].x;
ABS R1.w, R1;
POW R0.w, R0.w, c[11].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R0.w, c[13], R2;
ADD R1.w, -R1, c[18].y;
POW R0.w, R1.w, c[16].x;
MUL R0.w, R0, c[15].x;
MUL R2.xyz, R2, c[9].x;
ADD R2.xyz, R0, R2;
TEX R0.xyz, R1, texture[3], CUBE;
ADD_SAT R1.w, R0, c[4].x;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R2;
MAD result.color.xyz, R0.w, R0, R1;
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 104 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c18, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c19, 2.00000000, -1.00000000, 0.00000000, 4.00000000
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
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r1.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r0.w, r4, r1
mul r0.xyz, r4, -r0.w
mad r0.xyz, -r0, c18.x, -r1
mul r2.xyz, r1.w, r2
dp3 r0.x, r0, r2
max r0.x, r0, c18.z
pow r1, r0.x, c6.x
mov r1.y, r1.x
cmp r1.x, r0.w, c18.z, c18.y
mov r0.xyz, c17
mul r0.xyz, c5, r0
mul r2.xyz, r0, r1.y
abs_pp r0.x, r1
cmp r0.xyz, -r0.x, r2, c18.z
mul r6.xyz, r0, c7.x
mul r1.xy, v3, c8.x
mul r0.xy, r1, c18.w
mov r1.xyz, v6
mul r2.xyz, v1.zxyw, r1.yzxw
texld r0.xyz, r0, s2
mad r7.xyz, r0, c19.x, c19.y
mov r1.xyz, v6
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mov r3.y, r1.z
mov r2.y, r1.x
add r0.xyz, r7, c19.zzww
mov r3.x, v6.z
mov r3.z, v5
dp3 r9.z, r3, -r0
mov r2.z, v5.x
mov r2.x, v6
dp3 r9.x, -r0, r2
mov r1.z, v5.y
mov r1.x, v6.y
dp3 r9.y, -r0, r1
dp3 r1.w, r9, r9
add r0.xyz, v2, c0
max r0.w, r0, c18.z
mad_sat r5.xyz, r0.w, c17, r0
texld r0, v3, s1
mad r8.xyz, r0, r5, r6
rsq r0.x, r1.w
dp3 r0.y, v4, v4
rsq r1.w, r0.y
mul r9.xyz, r0.x, r9
mul r10.xyz, r1.w, v4
texld r0.xyz, v3, s0
mul r0.xyz, r0, c3
mad r0.xyz, r5, r0, r6
dp3_sat r1.w, r9, r10
mul r1.w, r1, r1
pow r5, r1.w, c11.x
add_pp r6.xyz, r8, -r0
mul r0.w, r0, c12.x
mad_pp r0.xyz, r0.w, r6, r0
add r6.xyz, r7, c18.zzyw
dp3 r3.z, r3, -r6
dp3 r3.y, r1, -r6
dp3 r3.x, r2, -r6
dp3 r1.y, r3, r3
rsq r1.w, r1.y
mul r2.xyz, r1.w, r3
dp3_sat r3.x, r10, r2
pow r2, r3.x, c10.x
mov r3.x, r2
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c18.x, v4
dp3_pp r1.w, r1, v1
abs_pp r1.w, r1
add_pp r1.w, -r1, c18.y
pow_pp r2, r1.w, c16.x
mov r0.w, r5.x
mul r3.xyz, r3.x, c14
mad r3.xyz, r0.w, c13, r3
mov_pp r0.w, r2.x
mul_pp r0.w, r0, c15.x
mul r2.xyz, r3, c9.x
add_pp r2.xyz, r0, r2
texld r0.xyz, r1, s3
add_sat r1.w, r0, c4.x
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 100 ALU, 4 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 20 },
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
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
ABS R0.x, R0;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R3.xyz, R3, c[3];
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, R4, -R0.w;
MAD R0.xyz, -R0, c[18].x, -R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[18].z;
POW R0.y, R0.x, c[6].x;
SLT R0.x, R0.w, c[18].z;
MOV R1.xyz, c[5];
ABS R0.x, R0;
MUL R1.xyz, R1, c[17];
MUL R1.xyz, R1, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R0.xyz, -R0.x, R1, c[18].z;
MUL R2.xyz, R0, c[7].x;
MAX R0.x, R0.w, c[18].z;
ADD R1.xyz, fragment.texcoord[2], c[0];
MAD_SAT R1.xyz, R0.x, c[17], R1;
MAD R5.xyz, R1, R3, R2;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R1, R2;
ADD R6.xyz, R0, -R5;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[18].w;
TEX R1.xyz, R1, texture[2], 2D;
MAD R7.xyz, R1, c[18].x, -c[18].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[19].xxyw;
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
RSQ R1.w, R1.w;
RSQ R2.w, R2.w;
MUL R0.xyz, R1.w, R0;
MUL R8.xyz, R2.w, fragment.texcoord[4];
DP3_SAT R1.w, R0, R8;
MUL R0.x, R0.w, c[12];
MAD R0.xyz, R0.x, R6, R5;
ADD R5.xyz, R7, c[18].zzyw;
DP3 R3.z, R3, -R5;
DP3 R3.x, R1, -R5;
MUL R0.w, R1, R1;
DP3 R3.y, R2, -R5;
DP3 R1.y, R3, R3;
RSQ R1.w, R1.y;
MUL R2.xyz, R1.w, R3;
DP3_SAT R2.x, R8, R2;
DP3 R1.x, R4, fragment.texcoord[4];
MUL R1.xyz, R4, R1.x;
MAD R1.xyz, -R1, c[18].x, fragment.texcoord[4];
DP3 R1.w, R1, fragment.texcoord[1];
POW R2.x, R2.x, c[10].x;
ABS R1.w, R1;
POW R0.w, R0.w, c[11].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R0.w, c[13], R2;
ADD R1.w, -R1, c[18].y;
POW R0.w, R1.w, c[16].x;
MUL R0.w, R0, c[15].x;
MUL R2.xyz, R2, c[9].x;
ADD R2.xyz, R0, R2;
TEX R0.xyz, R1, texture[3], CUBE;
ADD_SAT R1.w, R0, c[4].x;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R2;
MAD result.color.xyz, R0.w, R0, R1;
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 104 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c18, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c19, 2.00000000, -1.00000000, 0.00000000, 4.00000000
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
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r1.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r0.w, r4, r1
mul r0.xyz, r4, -r0.w
mad r0.xyz, -r0, c18.x, -r1
mul r2.xyz, r1.w, r2
dp3 r0.x, r0, r2
max r0.x, r0, c18.z
pow r1, r0.x, c6.x
mov r1.y, r1.x
cmp r1.x, r0.w, c18.z, c18.y
mov r0.xyz, c17
mul r0.xyz, c5, r0
mul r2.xyz, r0, r1.y
abs_pp r0.x, r1
cmp r0.xyz, -r0.x, r2, c18.z
mul r6.xyz, r0, c7.x
mul r1.xy, v3, c8.x
mul r0.xy, r1, c18.w
mov r1.xyz, v6
mul r2.xyz, v1.zxyw, r1.yzxw
texld r0.xyz, r0, s2
mad r7.xyz, r0, c19.x, c19.y
mov r1.xyz, v6
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mov r3.y, r1.z
mov r2.y, r1.x
add r0.xyz, r7, c19.zzww
mov r3.x, v6.z
mov r3.z, v5
dp3 r9.z, r3, -r0
mov r2.z, v5.x
mov r2.x, v6
dp3 r9.x, -r0, r2
mov r1.z, v5.y
mov r1.x, v6.y
dp3 r9.y, -r0, r1
dp3 r1.w, r9, r9
add r0.xyz, v2, c0
max r0.w, r0, c18.z
mad_sat r5.xyz, r0.w, c17, r0
texld r0, v3, s1
mad r8.xyz, r0, r5, r6
rsq r0.x, r1.w
dp3 r0.y, v4, v4
rsq r1.w, r0.y
mul r9.xyz, r0.x, r9
mul r10.xyz, r1.w, v4
texld r0.xyz, v3, s0
mul r0.xyz, r0, c3
mad r0.xyz, r5, r0, r6
dp3_sat r1.w, r9, r10
mul r1.w, r1, r1
pow r5, r1.w, c11.x
add_pp r6.xyz, r8, -r0
mul r0.w, r0, c12.x
mad_pp r0.xyz, r0.w, r6, r0
add r6.xyz, r7, c18.zzyw
dp3 r3.z, r3, -r6
dp3 r3.y, r1, -r6
dp3 r3.x, r2, -r6
dp3 r1.y, r3, r3
rsq r1.w, r1.y
mul r2.xyz, r1.w, r3
dp3_sat r3.x, r10, r2
pow r2, r3.x, c10.x
mov r3.x, r2
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c18.x, v4
dp3_pp r1.w, r1, v1
abs_pp r1.w, r1
add_pp r1.w, -r1, c18.y
pow_pp r2, r1.w, c16.x
mov r0.w, r5.x
mul r3.xyz, r3.x, c14
mad r3.xyz, r0.w, c13, r3
mov_pp r0.w, r2.x
mul_pp r0.w, r0, c15.x
mul r2.xyz, r3, c9.x
add_pp r2.xyz, r0, r2
texld r0.xyz, r1, s3
add_sat r1.w, r0, c4.x
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 101 ALU, 5 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 20 },
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
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
ABS R0.x, R0;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R3.xyz, R3, c[3];
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, R4, -R0.w;
MAD R0.xyz, -R0, c[18].x, -R1;
SLT R1.x, R0.w, c[18].z;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[18].z;
POW R1.y, R0.x, c[6].x;
TXP R0.x, fragment.texcoord[7], texture[2], 2D;
MUL R0.xyz, R0.x, c[17];
MUL R2.xyz, R0, c[5];
ABS R1.x, R1;
MUL R2.xyz, R2, R1.y;
CMP R1.x, -R1, c[18].z, c[18].y;
CMP R1.xyz, -R1.x, R2, c[18].z;
MUL R2.xyz, R1, c[7].x;
MAX R0.w, R0, c[18].z;
ADD R1.xyz, fragment.texcoord[2], c[0];
MAD_SAT R1.xyz, R0, R0.w, R1;
MAD R5.xyz, R1, R3, R2;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R1, R2;
ADD R6.xyz, R0, -R5;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[18].w;
TEX R1.xyz, R1, texture[3], 2D;
MAD R7.xyz, R1, c[18].x, -c[18].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[19].xxyw;
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
RSQ R1.w, R1.w;
RSQ R2.w, R2.w;
MUL R0.xyz, R1.w, R0;
MUL R8.xyz, R2.w, fragment.texcoord[4];
DP3_SAT R1.w, R0, R8;
MUL R0.x, R0.w, c[12];
MAD R0.xyz, R0.x, R6, R5;
ADD R5.xyz, R7, c[18].zzyw;
DP3 R3.z, R3, -R5;
DP3 R3.x, R1, -R5;
MUL R0.w, R1, R1;
DP3 R3.y, R2, -R5;
DP3 R1.y, R3, R3;
RSQ R1.w, R1.y;
MUL R2.xyz, R1.w, R3;
DP3_SAT R2.x, R8, R2;
DP3 R1.x, R4, fragment.texcoord[4];
MUL R1.xyz, R4, R1.x;
MAD R1.xyz, -R1, c[18].x, fragment.texcoord[4];
DP3 R1.w, R1, fragment.texcoord[1];
POW R2.x, R2.x, c[10].x;
ABS R1.w, R1;
POW R0.w, R0.w, c[11].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R0.w, c[13], R2;
ADD R1.w, -R1, c[18].y;
POW R0.w, R1.w, c[16].x;
MUL R0.w, R0, c[15].x;
MUL R2.xyz, R2, c[9].x;
ADD R2.xyz, R0, R2;
TEX R0.xyz, R1, texture[4], CUBE;
ADD_SAT R1.w, R0, c[4].x;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R2;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[3];
END
# 101 instructions, 9 R-regs
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 104 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c18, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c19, 2.00000000, -1.00000000, 0.00000000, 4.00000000
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
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r1.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r0.w, r4, r1
mul r0.xyz, r4, -r0.w
mad r0.xyz, -r0, c18.x, -r1
mul r2.xyz, r1.w, r2
dp3 r0.x, r0, r2
max r0.x, r0, c18.z
pow r1, r0.x, c6.x
mov r1.y, r1.x
cmp r1.x, r0.w, c18.z, c18.y
texldp r0.x, v7, s2
mul r0.xyz, r0.x, c17
mul r2.xyz, r0, c5
mul r2.xyz, r2, r1.y
abs_pp r1.x, r1
cmp r1.xyz, -r1.x, r2, c18.z
mul r6.xyz, r1, c7.x
mov r1.xyz, v6
mul r3.xyz, v1.zxyw, r1.yzxw
mul r2.xy, v3, c8.x
mul r2.xy, r2, c18.w
texld r2.xyz, r2, s3
mad r7.xyz, r2, c19.x, c19.y
mov r1.xyz, v6
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r3.y, r1.z
mov r2.y, r1.x
add r5.xyz, r7, c19.zzww
mov r3.x, v6.z
mov r3.z, v5
dp3 r9.z, r3, -r5
mov r2.z, v5.x
mov r2.x, v6
dp3 r9.x, -r5, r2
mov r1.z, v5.y
mov r1.x, v6.y
dp3 r9.y, -r5, r1
dp3 r1.w, r9, r9
max r0.w, r0, c18.z
add r5.xyz, v2, c0
mad_sat r5.xyz, r0, r0.w, r5
texld r0, v3, s1
mad r8.xyz, r0, r5, r6
rsq r0.x, r1.w
dp3 r0.y, v4, v4
rsq r1.w, r0.y
mul r9.xyz, r0.x, r9
mul r10.xyz, r1.w, v4
texld r0.xyz, v3, s0
mul r0.xyz, r0, c3
mad r0.xyz, r5, r0, r6
dp3_sat r1.w, r9, r10
mul r1.w, r1, r1
pow r5, r1.w, c11.x
add_pp r6.xyz, r8, -r0
mul r0.w, r0, c12.x
mad_pp r0.xyz, r0.w, r6, r0
add r6.xyz, r7, c18.zzyw
dp3 r3.z, r3, -r6
dp3 r3.y, r1, -r6
dp3 r3.x, r2, -r6
dp3 r1.y, r3, r3
rsq r1.w, r1.y
mul r2.xyz, r1.w, r3
dp3_sat r3.x, r10, r2
pow r2, r3.x, c10.x
mov r3.x, r2
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c18.x, v4
dp3_pp r1.w, r1, v1
abs_pp r1.w, r1
add_pp r1.w, -r1, c18.y
pow_pp r2, r1.w, c16.x
mov r0.w, r5.x
mul r3.xyz, r3.x, c14
mad r3.xyz, r0.w, c13, r3
mov_pp r0.w, r2.x
mul_pp r0.w, r0, c15.x
mul r2.xyz, r3, c9.x
add_pp r2.xyz, r0, r2
texld r0.xyz, r1, s4
add_sat r1.w, r0, c4.x
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 101 ALU, 5 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 20 },
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
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
ABS R0.x, R0;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R3.xyz, R3, c[3];
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, R4, -R0.w;
MAD R0.xyz, -R0, c[18].x, -R1;
SLT R1.x, R0.w, c[18].z;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[18].z;
POW R1.y, R0.x, c[6].x;
TXP R0.x, fragment.texcoord[7], texture[2], 2D;
MUL R0.xyz, R0.x, c[17];
MUL R2.xyz, R0, c[5];
ABS R1.x, R1;
MUL R2.xyz, R2, R1.y;
CMP R1.x, -R1, c[18].z, c[18].y;
CMP R1.xyz, -R1.x, R2, c[18].z;
MUL R2.xyz, R1, c[7].x;
MAX R0.w, R0, c[18].z;
ADD R1.xyz, fragment.texcoord[2], c[0];
MAD_SAT R1.xyz, R0, R0.w, R1;
MAD R5.xyz, R1, R3, R2;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R1, R2;
ADD R6.xyz, R0, -R5;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[18].w;
TEX R1.xyz, R1, texture[3], 2D;
MAD R7.xyz, R1, c[18].x, -c[18].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[19].xxyw;
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
RSQ R1.w, R1.w;
RSQ R2.w, R2.w;
MUL R0.xyz, R1.w, R0;
MUL R8.xyz, R2.w, fragment.texcoord[4];
DP3_SAT R1.w, R0, R8;
MUL R0.x, R0.w, c[12];
MAD R0.xyz, R0.x, R6, R5;
ADD R5.xyz, R7, c[18].zzyw;
DP3 R3.z, R3, -R5;
DP3 R3.x, R1, -R5;
MUL R0.w, R1, R1;
DP3 R3.y, R2, -R5;
DP3 R1.y, R3, R3;
RSQ R1.w, R1.y;
MUL R2.xyz, R1.w, R3;
DP3_SAT R2.x, R8, R2;
DP3 R1.x, R4, fragment.texcoord[4];
MUL R1.xyz, R4, R1.x;
MAD R1.xyz, -R1, c[18].x, fragment.texcoord[4];
DP3 R1.w, R1, fragment.texcoord[1];
POW R2.x, R2.x, c[10].x;
ABS R1.w, R1;
POW R0.w, R0.w, c[11].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R0.w, c[13], R2;
ADD R1.w, -R1, c[18].y;
POW R0.w, R1.w, c[16].x;
MUL R0.w, R0, c[15].x;
MUL R2.xyz, R2, c[9].x;
ADD R2.xyz, R0, R2;
TEX R0.xyz, R1, texture[4], CUBE;
ADD_SAT R1.w, R0, c[4].x;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R2;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[3];
END
# 101 instructions, 9 R-regs
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 104 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c18, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c19, 2.00000000, -1.00000000, 0.00000000, 4.00000000
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
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r1.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r0.w, r4, r1
mul r0.xyz, r4, -r0.w
mad r0.xyz, -r0, c18.x, -r1
mul r2.xyz, r1.w, r2
dp3 r0.x, r0, r2
max r0.x, r0, c18.z
pow r1, r0.x, c6.x
mov r1.y, r1.x
cmp r1.x, r0.w, c18.z, c18.y
texldp r0.x, v7, s2
mul r0.xyz, r0.x, c17
mul r2.xyz, r0, c5
mul r2.xyz, r2, r1.y
abs_pp r1.x, r1
cmp r1.xyz, -r1.x, r2, c18.z
mul r6.xyz, r1, c7.x
mov r1.xyz, v6
mul r3.xyz, v1.zxyw, r1.yzxw
mul r2.xy, v3, c8.x
mul r2.xy, r2, c18.w
texld r2.xyz, r2, s3
mad r7.xyz, r2, c19.x, c19.y
mov r1.xyz, v6
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r3.y, r1.z
mov r2.y, r1.x
add r5.xyz, r7, c19.zzww
mov r3.x, v6.z
mov r3.z, v5
dp3 r9.z, r3, -r5
mov r2.z, v5.x
mov r2.x, v6
dp3 r9.x, -r5, r2
mov r1.z, v5.y
mov r1.x, v6.y
dp3 r9.y, -r5, r1
dp3 r1.w, r9, r9
max r0.w, r0, c18.z
add r5.xyz, v2, c0
mad_sat r5.xyz, r0, r0.w, r5
texld r0, v3, s1
mad r8.xyz, r0, r5, r6
rsq r0.x, r1.w
dp3 r0.y, v4, v4
rsq r1.w, r0.y
mul r9.xyz, r0.x, r9
mul r10.xyz, r1.w, v4
texld r0.xyz, v3, s0
mul r0.xyz, r0, c3
mad r0.xyz, r5, r0, r6
dp3_sat r1.w, r9, r10
mul r1.w, r1, r1
pow r5, r1.w, c11.x
add_pp r6.xyz, r8, -r0
mul r0.w, r0, c12.x
mad_pp r0.xyz, r0.w, r6, r0
add r6.xyz, r7, c18.zzyw
dp3 r3.z, r3, -r6
dp3 r3.y, r1, -r6
dp3 r3.x, r2, -r6
dp3 r1.y, r3, r3
rsq r1.w, r1.y
mul r2.xyz, r1.w, r3
dp3_sat r3.x, r10, r2
pow r2, r3.x, c10.x
mov r3.x, r2
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c18.x, v4
dp3_pp r1.w, r1, v1
abs_pp r1.w, r1
add_pp r1.w, -r1, c18.y
pow_pp r2, r1.w, c16.x
mov r0.w, r5.x
mul r3.xyz, r3.x, c14
mad r3.xyz, r0.w, c13, r3
mov_pp r0.w, r2.x
mul_pp r0.w, r0, c15.x
mul r2.xyz, r3, c9.x
add_pp r2.xyz, r0, r2
texld r0.xyz, r1, s4
add_sat r1.w, r0, c4.x
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 101 ALU, 5 TEX
PARAM c[20] = { state.lightmodel.ambient,
		program.local[1..17],
		{ 2, 1, 0, 20 },
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
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
ABS R0.x, -c[2].w;
DP3 R0.y, c[2], c[2];
RSQ R0.y, R0.y;
CMP R0.x, -R0, c[18].z, c[18].y;
ABS R0.x, R0;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
DP3 R2.w, fragment.texcoord[4], fragment.texcoord[4];
MUL R3.xyz, R3, c[3];
MUL R2.xyz, R0.y, c[2];
CMP R0.x, -R0, c[18].z, c[18].y;
CMP R1.xyz, -R0.x, R1, R2;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R1.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.w, R4, R1;
MUL R0.xyz, R4, -R0.w;
MAD R0.xyz, -R0, c[18].x, -R1;
SLT R1.x, R0.w, c[18].z;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[18].z;
POW R1.y, R0.x, c[6].x;
TXP R0.x, fragment.texcoord[7], texture[2], 2D;
MUL R0.xyz, R0.x, c[17];
MUL R2.xyz, R0, c[5];
ABS R1.x, R1;
MUL R2.xyz, R2, R1.y;
CMP R1.x, -R1, c[18].z, c[18].y;
CMP R1.xyz, -R1.x, R2, c[18].z;
MUL R2.xyz, R1, c[7].x;
MAX R0.w, R0, c[18].z;
ADD R1.xyz, fragment.texcoord[2], c[0];
MAD_SAT R1.xyz, R0, R0.w, R1;
MAD R5.xyz, R1, R3, R2;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R1, R2;
ADD R6.xyz, R0, -R5;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[18].w;
TEX R1.xyz, R1, texture[3], 2D;
MAD R7.xyz, R1, c[18].x, -c[18].y;
MOV R3.y, R0.z;
ADD R8.xyz, R7, c[19].xxyw;
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
RSQ R1.w, R1.w;
RSQ R2.w, R2.w;
MUL R0.xyz, R1.w, R0;
MUL R8.xyz, R2.w, fragment.texcoord[4];
DP3_SAT R1.w, R0, R8;
MUL R0.x, R0.w, c[12];
MAD R0.xyz, R0.x, R6, R5;
ADD R5.xyz, R7, c[18].zzyw;
DP3 R3.z, R3, -R5;
DP3 R3.x, R1, -R5;
MUL R0.w, R1, R1;
DP3 R3.y, R2, -R5;
DP3 R1.y, R3, R3;
RSQ R1.w, R1.y;
MUL R2.xyz, R1.w, R3;
DP3_SAT R2.x, R8, R2;
DP3 R1.x, R4, fragment.texcoord[4];
MUL R1.xyz, R4, R1.x;
MAD R1.xyz, -R1, c[18].x, fragment.texcoord[4];
DP3 R1.w, R1, fragment.texcoord[1];
POW R2.x, R2.x, c[10].x;
ABS R1.w, R1;
POW R0.w, R0.w, c[11].x;
MUL R2.xyz, R2.x, c[14];
MAD R2.xyz, R0.w, c[13], R2;
ADD R1.w, -R1, c[18].y;
POW R0.w, R1.w, c[16].x;
MUL R0.w, R0, c[15].x;
MUL R2.xyz, R2, c[9].x;
ADD R2.xyz, R0, R2;
TEX R0.xyz, R1, texture[4], CUBE;
ADD_SAT R1.w, R0, c[4].x;
MUL R0.xyz, R0, R1.w;
ADD R1.xyz, R0, R2;
MAD result.color.xyz, R0.w, R0, R1;
MOV result.color.w, c[3];
END
# 101 instructions, 9 R-regs
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
Float 12 [_decalPower]
Vector 13 [_paintColor2]
Vector 14 [_flakeLayerColor]
Float 15 [_FrezPow]
Float 16 [_FrezFalloff]
Vector 17 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 104 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c18, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c19, 2.00000000, -1.00000000, 0.00000000, 4.00000000
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
mul r2.xyz, r0.y, r1
rsq r0.x, r0.x
mul r1.xyz, r0.x, c2
abs_pp r0.x, -c2.w
cmp r1.xyz, -r0.x, r1, r2
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r1.w, r0.y
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r4.xyz, r0.x, v1
dp3 r0.w, r4, r1
mul r0.xyz, r4, -r0.w
mad r0.xyz, -r0, c18.x, -r1
mul r2.xyz, r1.w, r2
dp3 r0.x, r0, r2
max r0.x, r0, c18.z
pow r1, r0.x, c6.x
mov r1.y, r1.x
cmp r1.x, r0.w, c18.z, c18.y
texldp r0.x, v7, s2
mul r0.xyz, r0.x, c17
mul r2.xyz, r0, c5
mul r2.xyz, r2, r1.y
abs_pp r1.x, r1
cmp r1.xyz, -r1.x, r2, c18.z
mul r6.xyz, r1, c7.x
mov r1.xyz, v6
mul r3.xyz, v1.zxyw, r1.yzxw
mul r2.xy, v3, c8.x
mul r2.xy, r2, c18.w
texld r2.xyz, r2, s3
mad r7.xyz, r2, c19.x, c19.y
mov r1.xyz, v6
mad r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r3.y, r1.z
mov r2.y, r1.x
add r5.xyz, r7, c19.zzww
mov r3.x, v6.z
mov r3.z, v5
dp3 r9.z, r3, -r5
mov r2.z, v5.x
mov r2.x, v6
dp3 r9.x, -r5, r2
mov r1.z, v5.y
mov r1.x, v6.y
dp3 r9.y, -r5, r1
dp3 r1.w, r9, r9
max r0.w, r0, c18.z
add r5.xyz, v2, c0
mad_sat r5.xyz, r0, r0.w, r5
texld r0, v3, s1
mad r8.xyz, r0, r5, r6
rsq r0.x, r1.w
dp3 r0.y, v4, v4
rsq r1.w, r0.y
mul r9.xyz, r0.x, r9
mul r10.xyz, r1.w, v4
texld r0.xyz, v3, s0
mul r0.xyz, r0, c3
mad r0.xyz, r5, r0, r6
dp3_sat r1.w, r9, r10
mul r1.w, r1, r1
pow r5, r1.w, c11.x
add_pp r6.xyz, r8, -r0
mul r0.w, r0, c12.x
mad_pp r0.xyz, r0.w, r6, r0
add r6.xyz, r7, c18.zzyw
dp3 r3.z, r3, -r6
dp3 r3.y, r1, -r6
dp3 r3.x, r2, -r6
dp3 r1.y, r3, r3
rsq r1.w, r1.y
mul r2.xyz, r1.w, r3
dp3_sat r3.x, r10, r2
pow r2, r3.x, c10.x
mov r3.x, r2
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c18.x, v4
dp3_pp r1.w, r1, v1
abs_pp r1.w, r1
add_pp r1.w, -r1, c18.y
pow_pp r2, r1.w, c16.x
mov r0.w, r5.x
mul r3.xyz, r3.x, c14
mad r3.xyz, r0.w, c13, r3
mov_pp r0.w, r2.x
mul_pp r0.w, r0, c15.x
mul r2.xyz, r3, c9.x
add_pp r2.xyz, r0, r2
texld r0.xyz, r1, s4
add_sat r1.w, r0, c4.x
mul_pp r0.xyz, r0, r1.w
add_pp r1.xyz, r0, r2
mad_pp oC0.xyz, r0.w, r0, r1
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

#LINE 319

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}