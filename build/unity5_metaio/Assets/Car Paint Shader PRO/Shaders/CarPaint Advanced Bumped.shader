Shader "RedDotGames/Car Paint Advanced Bumped" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _Color2 ("Diffuse Material Color2 (RGB)", Color) = (1,1,1,1) 
	  _duoPower ("DuoColor Falloff",Range(1,64)) = 32	  
	  _duoInt ("DuoColor Power",Range(0.0,1.0)) = 0.0
	  
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _BonusAmbient ("Additional Ambient (RGB)", Color) = (0,0,0,1) 
	  _VertexLightningFactor("Vertex Lightning Power", Range(0.0,1.0)) = 1.0
	  _Shininess ("Shininess", Range (0.01, 128)) = 10
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
      _BumpMap ("Normalmap", 2D) = "bump" {}
	  _Cube("Reflection Map", Cube) = "" {}
	  
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0.0
	  _threshold ("Reflection PowerUp Threshold ", Range(0,1)) = 0.5
	  _thresholdInt ("Reflection PowerUp Power", Range(0,20)) = 0
	  
	  _Refraction("Paint Refraction", Range (0.0, 0.5)) = 0.01
	  
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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
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
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
mov o4.xy, v2
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 340
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 332
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 321
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 327
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 366
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    #line 368
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    #line 372
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 378
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 385
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 389
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 393
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 399
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 403
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 407
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 411
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 415
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 419
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 423
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 427
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:116(44): error: too few components to construct `mat3'
0:116(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:116(14): error: cannot construct `float' from a non-numeric data type
*/


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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 343
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 335
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 324
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 330
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 369
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    #line 371
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    #line 375
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 381
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 388
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 392
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 396
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 402
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 406
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 410
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 414
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 418
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 422
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 426
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 430
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:116(44): error: too few components to construct `mat3'
0:116(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:116(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 38 ALU
PARAM c[15] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..14] };
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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[14].xyxy, c[14];
MOV result.texcoord[3].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_LightmapST]
"vs_3_0
; 38 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c14, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mul r2.xyz, v1.y, c9
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mad r2.xyz, v1.x, c8, r2
mov r0.xyz, c12
mov r0.w, c14.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c14.x
mov r0.xyz, v4
dp4 r3.z, r0, c6
dp4 r3.y, r0, c5
dp4 r3.x, r0, c4
mad r0.xyz, v1.z, c10, r2
dp3 r0.w, r3, r3
rsq r2.x, r0.w
add r0.xyz, r0, c14.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
mov r0.w, c14.x
mov r0.xyz, v1
mul o7.xyz, r2.x, r3
mov o1, r1
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c14.x
mad o4.zw, v3.xyxy, c13.xyxy, c13
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 343
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 334
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 323
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 329
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return (2.00000 * color.xyz);
}
#line 370
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    #line 372
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    #line 376
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    #line 380
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    textureColor = texture2D( _MainTex, i.tex.xy);
    #line 384
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 390
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 394
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 398
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 402
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 406
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 410
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 414
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 418
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 422
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 426
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:115(44): error: too few components to construct `mat3'
0:115(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:115(14): error: cannot construct `float' from a non-numeric data type
*/


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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 346
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 337
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 326
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 332
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return ((8.00000 * color.w) * color.xyz);
}
#line 373
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    #line 375
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    #line 379
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    #line 383
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    textureColor = texture2D( _MainTex, i.tex.xy);
    #line 387
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 393
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 397
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 401
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 405
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 409
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 413
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 417
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 421
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 425
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 429
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:115(44): error: too few components to construct `mat3'
0:115(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:115(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 38 ALU
PARAM c[15] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..14] };
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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[14].xyxy, c[14];
MOV result.texcoord[3].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_LightmapST]
"vs_3_0
; 38 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c14, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mul r2.xyz, v1.y, c9
dp4 r1.w, v0, c7
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mad r2.xyz, v1.x, c8, r2
mov r0.xyz, c12
mov r0.w, c14.y
add r0, r1, -r0
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c14.x
mov r0.xyz, v4
dp4 r3.z, r0, c6
dp4 r3.y, r0, c5
dp4 r3.x, r0, c4
mad r0.xyz, v1.z, c10, r2
dp3 r0.w, r3, r3
rsq r2.x, r0.w
add r0.xyz, r0, c14.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o2.xyz, r0.w, r0
mov r0.w, c14.x
mov r0.xyz, v1
mul o7.xyz, r2.x, r3
mov o1, r1
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c14.x
mad o4.zw, v3.xyxy, c13.xyxy, c13
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_ON 1
#define SHADOWS_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 343
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 334
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 323
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 329
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return (2.00000 * color.xyz);
}
#line 370
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    #line 372
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    #line 376
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    #line 380
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    textureColor = texture2D( _MainTex, i.tex.xy);
    #line 384
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 390
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 394
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 398
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 402
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 406
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 410
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 414
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 418
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 422
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 426
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:115(44): error: too few components to construct `mat3'
0:115(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:115(14): error: cannot construct `float' from a non-numeric data type
*/


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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_2.xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_5 * _World2Object).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_6)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_ON 1
#define SHADOWS_OFF 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 346
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 337
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 326
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 332
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 162
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 164
    return ((8.00000 * color.w) * color.xyz);
}
#line 373
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    #line 375
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    #line 379
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    #line 383
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    textureColor = texture2D( _MainTex, i.tex.xy);
    #line 387
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 393
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 397
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 401
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 405
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 409
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 413
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 417
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 421
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 425
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 429
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:115(44): error: too few components to construct `mat3'
0:115(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:115(14): error: cannot construct `float' from a non-numeric data type
*/


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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
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
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
mov o3.xyz, c15.x
mov o4.xy, v2
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
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
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_SCREEN 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 347
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 339
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 328
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 334
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 375
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    #line 377
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    #line 381
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 387
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 394
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 398
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 402
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 408
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 412
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 416
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 420
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 424
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 428
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 432
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 436
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:125(44): error: too few components to construct `mat3'
0:125(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:125(14): error: cannot construct `float' from a non-numeric data type
*/


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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
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
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_SCREEN 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 350
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 342
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 331
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 337
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 378
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    #line 380
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    #line 384
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 390
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 397
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 401
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 405
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 411
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 415
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 419
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 423
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 427
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 431
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 435
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 439
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:125(44): error: too few components to construct `mat3'
0:125(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:125(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 43 ALU
PARAM c[16] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[15].xyxy, c[15];
MOV result.texcoord[3].xy, vertex.texcoord[0];
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_LightmapST]
"vs_3_0
; 43 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c16, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c16.y
add r2, r0, -r1
mov o1, r0
mov r1.xyz, v4
mov r1.w, c16.x
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
add r2.xyz, r2, c16.x
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c16.z
mul r3.y, r3, c12.x
mov r0.w, c16.x
mov r0.xyz, v1
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o8.xy, r3.z, c13.zwzw, r3
mul o2.xyz, r1.x, r2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
mov o3.xyz, c16.x
mad o4.zw, v3.xyxy, c15.xyxy, c15
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
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
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_SCREEN 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 350
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 341
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 330
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 336
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 169
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 171
    return (2.00000 * color.xyz);
}
#line 379
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    #line 383
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    #line 387
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 392
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 399
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 403
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 407
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 411
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 415
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 419
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 423
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 427
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 431
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 435
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:124(44): error: too few components to construct `mat3'
0:124(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:124(14): error: cannot construct `float' from a non-numeric data type
*/


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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
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
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_SCREEN 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 353
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 344
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 333
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 339
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 169
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 171
    return ((8.00000 * color.w) * color.xyz);
}
#line 382
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    #line 386
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    #line 390
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 395
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 402
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 406
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 410
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 414
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 418
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 422
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 426
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 430
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 434
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 438
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:124(44): error: too few components to construct `mat3'
0:124(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:124(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 43 ALU
PARAM c[16] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[15].xyxy, c[15];
MOV result.texcoord[3].xy, vertex.texcoord[0];
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_LightmapST]
"vs_3_0
; 43 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c16, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.xyz, c14
mov r1.w, c16.y
add r2, r0, -r1
mov o1, r0
mov r1.xyz, v4
mov r1.w, c16.x
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
add r2.xyz, r2, c16.x
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r3.xyz, r1.xyww, c16.z
mul r3.y, r3, c12.x
mov r0.w, c16.x
mov r0.xyz, v1
dp3 r2.w, r2, r2
mov o0, r1
rsq r1.x, r2.w
mad o8.xy, r3.z, c13.zwzw, r3
mul o2.xyz, r1.x, r2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
mov o3.xyz, c16.x
mad o4.zw, v3.xyxy, c15.xyxy, c15
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
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
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_ON 1
#define SHADOWS_SCREEN 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 350
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 341
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 330
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 336
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 169
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 171
    return (2.00000 * color.xyz);
}
#line 379
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    #line 383
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    #line 387
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 392
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 399
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 403
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 407
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 411
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 415
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 419
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 423
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 427
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 431
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 435
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:124(44): error: too few components to construct `mat3'
0:124(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:124(14): error: cannot construct `float' from a non-numeric data type
*/


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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = tmpvar_1;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = tmpvar_1;
  tmpvar_3.xy = _glesMultiTexCoord0.xy;
  tmpvar_3.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
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
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_7)).xyz;
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

#define DIRECTIONAL 1
#define LIGHTMAP_ON 1
#define DIRLIGHTMAP_ON 1
#define SHADOWS_SCREEN 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 353
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 344
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _SparkleTex;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform sampler2D unity_Lightmap;
uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
lowp vec3 DecodeLightmap( in lowp vec4 color );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 333
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 339
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 169
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 171
    return ((8.00000 * color.w) * color.xyz);
}
#line 382
highp vec4 frag( in v2f i ) {
    lowp vec3 lm;
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    highp vec3 specularReflection;
    lowp vec4 color;
    lm = DecodeLightmap( texture2D( unity_Lightmap, i.tex.zw)).xyz;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    #line 386
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    #line 390
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 395
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 402
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 406
    attenuation = float( lm);
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    diffuseReflection = (lm * _Color.xyz);
    #line 410
    dotLN = dot( lightDirection, i.normalDir);
    vNormal = ((2.00000 * vNormal) - 1.00000);
    #line 414
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    vView = normalize(i.viewDir);
    #line 418
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    #line 422
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    #line 426
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    #line 430
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    xlat_mutable__Reflection += frez;
    #line 434
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( (textureColor.xyz * xll_saturate((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + diffuseReflection)).xyz), 1.00000);
    color += reflTex;
    #line 438
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:124(44): error: too few components to construct `mat3'
0:124(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:124(14): error: cannot construct `float' from a non-numeric data type
*/


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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[3].xy, vertex.texcoord[0];
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
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o4.xy, v2
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
  highp vec4 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
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
  tmpvar_12 = (tmpvar_11.xyz - tmpvar_5.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_18, tmpvar_18))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_18)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_8;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_9)).xyz;
  xlv_TEXCOORD5 = (_Object2World * tmpvar_6).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_10).xyz);
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_OFF 1
#define VERTEXLIGHT_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 340
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 332
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 321
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 327
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 378
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    #line 380
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    #line 384
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 390
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 397
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 401
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 405
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 411
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 415
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 419
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 423
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 427
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 431
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 435
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 439
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:117(44): error: too few components to construct `mat3'
0:117(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:117(14): error: cannot construct `float' from a non-numeric data type
*/


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
  highp vec4 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
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
  tmpvar_12 = (tmpvar_11.xyz - tmpvar_5.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_12, tmpvar_12))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_12))));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = unity_4LightPosX0.y;
  tmpvar_13.y = unity_4LightPosY0.y;
  tmpvar_13.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_14, tmpvar_14))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_14)))));
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.x = unity_4LightPosX0.z;
  tmpvar_15.y = unity_4LightPosY0.z;
  tmpvar_15.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_16, tmpvar_16))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_16)))));
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.x = unity_4LightPosX0.w;
  tmpvar_17.y = unity_4LightPosY0.w;
  tmpvar_17.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_17.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_18, tmpvar_18))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_18)))));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_8;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_9)).xyz;
  xlv_TEXCOORD5 = (_Object2World * tmpvar_6).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_10).xyz);
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_OFF 1
#define VERTEXLIGHT_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 343
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
};
#line 335
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 324
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 330
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 381
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    #line 383
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    #line 387
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 393
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 400
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = 1.00000;
    #line 404
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 408
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 414
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 418
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 422
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 426
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 430
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 434
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 438
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 442
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:117(44): error: too few components to construct `mat3'
0:117(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:117(14): error: cannot construct `float' from a non-numeric data type
*/


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
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MOV result.texcoord[3].xy, vertex.texcoord[0];
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
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
mov o4.xy, v2
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
  highp vec4 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.x;
  tmpvar_12.y = unity_4LightPosY0.x;
  tmpvar_12.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xyz - tmpvar_5.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_13))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.y;
  tmpvar_14.y = unity_4LightPosY0.y;
  tmpvar_14.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.z;
  tmpvar_16.y = unity_4LightPosY0.z;
  tmpvar_16.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_17)))));
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.w;
  tmpvar_18.y = unity_4LightPosY0.w;
  tmpvar_18.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_18.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_19, tmpvar_19))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_19)))));
  highp vec4 o_i0;
  highp vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20.x;
  tmpvar_21.y = (tmpvar_20.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_21 + tmpvar_20.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_8;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_10)).xyz;
  xlv_TEXCOORD5 = (_Object2World * tmpvar_6).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_11).xyz);
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_SCREEN 1
#define VERTEXLIGHT_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_MOBILE 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 347
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 339
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 328
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 334
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 387
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    #line 391
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    #line 395
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 399
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 406
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 410
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 414
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 420
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 424
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 428
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 432
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 436
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 440
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 444
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 448
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:126(44): error: too few components to construct `mat3'
0:126(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:126(14): error: cannot construct `float' from a non-numeric data type
*/


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
  highp vec4 tmpvar_5;
  tmpvar_5 = (_Object2World * _glesVertex);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.x;
  tmpvar_12.y = unity_4LightPosY0.x;
  tmpvar_12.z = unity_4LightPosZ0.x;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xyz - tmpvar_5.xyz);
  tmpvar_3 = ((((1.0/((1.0 + (unity_4LightAtten0.x * dot (tmpvar_13, tmpvar_13))))) * unity_LightColor[0].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_13))));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.x = unity_4LightPosX0.y;
  tmpvar_14.y = unity_4LightPosY0.y;
  tmpvar_14.z = unity_4LightPosZ0.y;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.y * dot (tmpvar_15, tmpvar_15))))) * unity_LightColor[1].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_15)))));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.z;
  tmpvar_16.y = unity_4LightPosY0.z;
  tmpvar_16.z = unity_4LightPosZ0.z;
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_16.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.z * dot (tmpvar_17, tmpvar_17))))) * unity_LightColor[2].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_17)))));
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.w;
  tmpvar_18.y = unity_4LightPosY0.w;
  tmpvar_18.z = unity_4LightPosZ0.w;
  highp vec3 tmpvar_19;
  tmpvar_19 = (tmpvar_18.xyz - tmpvar_5.xyz);
  tmpvar_3 = (tmpvar_3 + ((((1.0/((1.0 + (unity_4LightAtten0.w * dot (tmpvar_19, tmpvar_19))))) * unity_LightColor[3].xyz) * _Color.xyz) * max (0.0, dot (tmpvar_8, normalize (tmpvar_19)))));
  highp vec4 o_i0;
  highp vec4 tmpvar_20;
  tmpvar_20 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_20;
  highp vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_20.x;
  tmpvar_21.y = (tmpvar_20.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_21 + tmpvar_20.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_8;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = normalize (((_Object2World * _glesVertex) - tmpvar_10)).xyz;
  xlv_TEXCOORD5 = (_Object2World * tmpvar_6).xyz;
  xlv_TEXCOORD6 = normalize ((_Object2World * tmpvar_11).xyz);
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

#define DIRECTIONAL 1
#define LIGHTMAP_OFF 1
#define DIRLIGHTMAP_OFF 1
#define SHADOWS_SCREEN 1
#define VERTEXLIGHT_ON 1
#define SHADER_API_GLES 1
#define SHADER_API_DESKTOP 1
mat2 xll_transpose(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
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
#line 143
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 179
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 173
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 350
struct v2f {
    highp vec4 pos;
    highp vec4 posWorld;
    highp vec3 normalDir;
    highp vec3 vertexLighting;
    highp vec4 tex;
    highp vec3 viewDir;
    highp vec3 worldNormal;
    highp vec3 tangentWorld;
    highp vec4 _ShadowCoord;
};
#line 342
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 tangent;
};
uniform lowp vec4 _BonusAmbient;
uniform sampler2D _BumpMap;
uniform highp vec4 _BumpMap_ST;
uniform lowp vec4 _Color;
uniform lowp vec4 _Color2;
uniform samplerCube _Cube;
uniform highp float _FlakePower;
uniform highp float _FlakeScale;
uniform mediump float _FrezFalloff;
uniform lowp float _FrezPow;
uniform highp float _Gloss;
uniform highp float _InterFlakePower;
uniform highp vec4 _LightColor0;
uniform sampler2D _MainTex;
uniform highp float _OuterFlakePower;
uniform sampler2D _ShadowMapTexture;
uniform highp float _Shininess;
uniform sampler2D _SparkleTex;
uniform lowp vec4 _SpecColor;
uniform lowp float _VertexLightningFactor;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp float _duoInt;
uniform highp float _duoPower;
uniform lowp vec4 _flakeLayerColor;
uniform lowp vec4 _paintColor2;
uniform mediump float _threshold;
uniform mediump float _thresholdInt;

uniform highp float _Reflection;
highp float xlat_mutable__Reflection;
lowp float unitySampleShadow( in highp vec4 shadowCoord );
lowp vec3 highpass( in lowp vec3 sample );
highp vec4 frag( in v2f i );
#line 13
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow;
    shadow = texture2DProj( _ShadowMapTexture, shadowCoord).x;
    return shadow;
}
#line 331
lowp vec3 highpass( in lowp vec3 sample ) {
    highp vec3 luminanceFilter = vec3(0.298900, 0.586600, 0.114500);
    highp float normalizationFactor;
    highp float greyLevel;
    highp vec3 desaturated;
    #line 337
    normalizationFactor = (1.00000 / (1.00000 - _threshold));
    greyLevel = float( xll_saturate((sample * mat3( luminanceFilter))));
    desaturated = mix( sample, vec3( greyLevel), vec3( _threshold));
    return xll_saturate(((desaturated - vec3( _threshold, _threshold, _threshold)) * normalizationFactor)).xyz;
}
#line 390
highp vec4 frag( in v2f i ) {
    highp vec4 encodedNormal;
    highp vec3 localCoords;
    highp vec3 vFlakesNormal;
    highp vec3 binormalDirection;
    highp mat3 local2WorldTranspose;
    highp vec3 normalDirection;
    highp vec3 viewDirection;
    highp vec4 textureColor;
    highp vec3 lightDirection;
    highp vec3 vertexToLightSource;
    highp float attenuation;
    highp vec3 ambientLighting;
    highp vec3 diffuseReflection;
    highp float dotLN;
    highp vec3 specularReflection;
    highp vec3 vNormal = vec3(0.500000, 0.500000, 1.00000);
    highp vec3 vNp1;
    highp vec3 vNp2;
    highp vec3 vView;
    highp mat3 mTangentToWorld;
    highp vec3 vNormalWorld;
    highp vec3 vNp1World;
    highp float fFresnel1;
    highp vec3 vNp2World;
    highp float fFresnel2;
    highp float fFresnel1Sq;
    lowp vec4 paintColor;
    lowp vec3 reflectedDir;
    highp vec4 reflTex;
    lowp float SurfAngle;
    lowp float frez;
    lowp vec4 duoColor;
    lowp vec4 color;
    encodedNormal = texture2D( _BumpMap, ((_BumpMap_ST.xy * i.tex.xy) + _BumpMap_ST.zw));
    localCoords = vec3( ((2.00000 * encodedNormal.wy) - vec2( 1.00000, 1.00000)), 0.000000);
    #line 394
    localCoords.z = sqrt((1.00000 - dot( localCoords, localCoords)));
    vFlakesNormal = texture2D( _SparkleTex, ((i.tex.xy * 20.0000) * _FlakeScale)).xyz;
    binormalDirection = cross( i.normalDir, i.tangentWorld).xyz;
    local2WorldTranspose = xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal));
    #line 398
    normalDirection = normalize((localCoords * local2WorldTranspose));
    viewDirection = normalize((_WorldSpaceCameraPos.xyz - i.posWorld.xyz));
    #line 402
    textureColor = texture2D( _MainTex, i.tex.xy);
    if ((0.000000 == _WorldSpaceLightPos0.w)){
        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    }
    else{
        #line 409
        vertexToLightSource = (_WorldSpaceLightPos0.xyz - i.posWorld.xyz);
        lightDirection = normalize(vertexToLightSource);
    }
    attenuation = unitySampleShadow( i._ShadowCoord);
    #line 413
    ambientLighting = xll_saturate(((gl_LightModel.ambient.xyz * _Color.xyz) + (_BonusAmbient.xyz * _Color.xyz)));
    diffuseReflection = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max( 0.000000, dot( normalDirection, lightDirection)));
    dotLN = dot( lightDirection, i.normalDir);
    #line 417
    if ((dot( normalDirection, lightDirection) < 0.000000)){
        specularReflection = vec3( 0.000000, 0.000000, 0.000000);
    }
    else{
        #line 423
        specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow( max( 0.000000, dot( reflect( (-lightDirection), normalDirection), viewDirection)), _Shininess));
    }
    specularReflection *= _Gloss;
    #line 427
    vNormal = ((2.00000 * vNormal) - 1.00000);
    vFlakesNormal = ((2.00000 * vFlakesNormal) - 1.00000);
    vNp1 = (vFlakesNormal + (4.00000 * vNormal));
    vNp2 = (vFlakesNormal + vNormal);
    #line 431
    vView = normalize(i.viewDir);
    mTangentToWorld = xll_transpose(xll_transpose(mat3( i.tangentWorld, binormalDirection, i.worldNormal)));
    vNormalWorld = normalize((mTangentToWorld * vNormal)).xyz;
    vNp1World = normalize((mTangentToWorld * (-vNp1))).xyz;
    #line 435
    fFresnel1 = xll_saturate(dot( vNp1World, vView));
    vNp2World = normalize((mTangentToWorld * (-vNp2))).xyz;
    fFresnel2 = xll_saturate(dot( vNp2World, vView));
    fFresnel1Sq = (fFresnel1 * fFresnel1);
    #line 439
    paintColor = ((pow( fFresnel1Sq, _OuterFlakePower) * _paintColor2) + (pow( fFresnel2, _InterFlakePower) * _flakeLayerColor));
    reflectedDir = reflect( i.viewDir, normalDirection).xyz;
    reflTex = textureCube( _Cube, reflectedDir);
    SurfAngle = clamp( abs(dot( reflectedDir, i.normalDir)), 0.000000, 1.00000);
    #line 443
    frez = pow( (1.00000 - SurfAngle), _FrezFalloff);
    frez *= _FrezPow;
    duoColor = (pow( SurfAngle, _duoPower) * _Color2);
    reflTex.xyz += (highpass( reflTex.xyz) * _thresholdInt);
    #line 447
    xlat_mutable__Reflection += frez;
    specularReflection += vec3( clamp( ((pow( fFresnel2, _InterFlakePower) * _FlakePower) * paintColor), vec4( 0.000000), vec4( 1.00000)));
    reflTex.xyz *= xlat_mutable__Reflection;
    color = vec4( ((textureColor.xyz * xll_saturate(((((i.vertexLighting * _VertexLightningFactor) + ambientLighting) + (duoColor.xyz * _duoInt)) + diffuseReflection)).xyz) + specularReflection), 1.00000);
    #line 451
    color += reflTex;
    color += (frez * reflTex);
    color.w = _Color.w;
    return color;
}
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main() {
    highp vec4 xl_retval;
    xlat_mutable__Reflection = _Reflection;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.posWorld = vec4( xlv_TEXCOORD0);
    xlt_i.normalDir = vec3( xlv_TEXCOORD1);
    xlt_i.vertexLighting = vec3( xlv_TEXCOORD2);
    xlt_i.tex = vec4( xlv_TEXCOORD3);
    xlt_i.viewDir = vec3( xlv_TEXCOORD4);
    xlt_i.worldNormal = vec3( xlv_TEXCOORD5);
    xlt_i.tangentWorld = vec3( xlv_TEXCOORD6);
    xlt_i._ShadowCoord = vec4( xlv_TEXCOORD7);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4( xl_retval);
}
/* NOTE: GLSL optimization failed
0:126(44): error: too few components to construct `mat3'
0:126(66): error: Operands to arithmetic operators must be numeric
0:0(0): error: no matching function for call to `xll_saturate()'
0:0(0): error: candidates are: float xll_saturate(float)
0:0(0): error:                 vec2 xll_saturate(vec2)
0:0(0): error:                 vec3 xll_saturate(vec3)
0:0(0): error:                 vec4 xll_saturate(vec4)
0:0(0): error:                 mat2 xll_saturate(mat2)
0:0(0): error:                 mat3 xll_saturate(mat3)
0:0(0): error:                 mat4 xll_saturate(mat4)
0:126(14): error: cannot construct `float' from a non-numeric data type
*/


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 56 to 127, TEX: 4 to 5
//   d3d9 - ALU: 56 to 134, TEX: 4 to 5
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_Color2]
Vector 7 [_BonusAmbient]
Float 8 [_Reflection]
Vector 9 [_SpecColor]
Float 10 [_Shininess]
Float 11 [_Gloss]
Float 12 [_FlakeScale]
Float 13 [_FlakePower]
Float 14 [_InterFlakePower]
Float 15 [_OuterFlakePower]
Float 16 [_duoPower]
Float 17 [_duoInt]
Vector 18 [_paintColor2]
Vector 19 [_flakeLayerColor]
Float 20 [_FrezPow]
Float 21 [_FrezFalloff]
Float 22 [_threshold]
Float 23 [_thresholdInt]
Vector 24 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 126 ALU, 4 TEX
PARAM c[28] = { state.lightmodel.ambient,
		program.local[1..24],
		{ 2, 1, 0, 20 },
		{ 0, 4, 0.11450195, 0.29882813 },
		{ 0.58642578 } };
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
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
MAD R0.xy, fragment.texcoord[3], c[4], c[4].zwzw;
TEX R0.yw, R0, texture[0], 2D;
MAD R0.xy, R0.wyzw, c[25].x, -c[25].y;
MUL R2.xyz, R0.y, R1;
MOV R0.z, c[25];
DP3 R0.z, R0, R0;
ADD R0.z, -R0, c[25].y;
MAD R2.xyz, R0.x, fragment.texcoord[6], R2;
RSQ R0.y, R0.z;
RCP R0.x, R0.y;
MAD R0.xyz, R0.x, fragment.texcoord[5], R2;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R5.xyz, R0.w, R0;
DP3 R0.x, R5, fragment.texcoord[4];
MUL R0.xyz, R5, R0.x;
MAD R6.xyz, -R0, c[25].x, fragment.texcoord[4];
TEX R0.xyz, R6, texture[3], CUBE;
MUL R0.w, R0.y, c[27].x;
MAD R0.w, R0.x, c[26], R0;
MAD_SAT R0.w, R0.z, c[26].z, R0;
ADD R8.xyz, -R0, R0.w;
MUL R2.xy, fragment.texcoord[3], c[12].x;
MUL R2.xy, R2, c[25].w;
TEX R2.xyz, R2, texture[1], 2D;
MAD R7.xyz, R2, c[25].x, -c[25].y;
ADD R9.xyz, R7, c[25].zzyw;
MOV R4.y, R1.z;
MOV R3.y, R1.x;
MOV R2.y, R1;
MOV R4.x, fragment.texcoord[6].z;
MOV R4.z, fragment.texcoord[5];
DP3 R1.z, R4, -R9;
ADD R7.xyz, R7, c[26].xxyw;
DP3 R4.z, R4, -R7;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R4.x, R3, -R7;
DP3 R1.x, -R9, R3;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R4.y, R2, -R7;
DP3 R1.y, -R9, R2;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
DP3 R1.w, R4, R4;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, fragment.texcoord[4];
MUL R3.xyz, R1.w, R4;
DP3_SAT R0.w, R1, R2;
DP3_SAT R1.w, R2, R3;
MUL R1.x, R1.w, R1.w;
POW R1.w, R0.w, c[14].x;
POW R0.w, R1.x, c[15].x;
MUL R2.xyz, R1.w, c[19];
MAD R2.xyz, R0.w, c[18], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R1, R1;
MUL R1.w, R1, c[13].x;
MUL_SAT R3.xyz, R1.w, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
ABS R0.w, -c[2];
DP3 R1.w, c[2], c[2];
RSQ R1.w, R1.w;
CMP R0.w, -R0, c[25].z, c[25].y;
ABS R0.w, R0;
MUL R2.xyz, R1.w, c[2];
CMP R0.w, -R0, c[25].z, c[25].y;
CMP R1.xyz, -R0.w, R1, R2;
DP3 R0.w, R5, R1;
MUL R4.xyz, -R0.w, R5;
SLT R1.w, R0, c[25].z;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
MAD R1.xyz, -R4, c[25].x, -R1;
DP3 R1.x, R1, R2;
MAX R2.x, R1, c[25].z;
ABS R1.w, R1;
MOV R1.xyz, c[9];
DP3 R2.w, fragment.texcoord[1], R6;
MAD R8.xyz, R8, c[22].x, R0;
POW R2.x, R2.x, c[10].x;
MUL R1.xyz, R1, c[24];
MUL R1.xyz, R1, R2.x;
CMP R1.w, -R1, c[25].z, c[25].y;
CMP R1.xyz, -R1.w, R1, c[25].z;
MOV R1.w, c[25].y;
ADD R1.w, R1, -c[22].x;
MAD R1.xyz, R1, c[11].x, R3;
ABS_SAT R2.w, R2;
ADD R3.x, -R2.w, c[25].y;
RCP R1.w, R1.w;
ADD R2.xyz, R8, -c[22].x;
MUL_SAT R2.xyz, R2, R1.w;
POW R3.x, R3.x, c[21].x;
MUL R1.w, R3.x, c[20].x;
MUL R2.xyz, R2, c[23].x;
ADD R0.xyz, R0, R2;
ADD R3.x, R1.w, c[8];
MUL R3.xyz, R0, R3.x;
MOV R0.xyz, c[5];
MOV R2.xyz, c[5];
MUL R0.xyz, R0, c[7];
MAD_SAT R0.xyz, R2, c[0], R0;
MAD R4.xyz, fragment.texcoord[2], c[3].x, R0;
POW R2.w, R2.w, c[16].x;
MUL R0.xyz, R2.w, c[6];
MAD R0.xyz, R0, c[17].x, R4;
MAX R0.w, R0, c[25].z;
MUL R2.xyz, R2, c[24];
MAD_SAT R2.xyz, R2, R0.w, R0;
TEX R0.xyz, fragment.texcoord[3], texture[2], 2D;
MAD R0.xyz, R0, R2, R1;
MUL R1.xyz, R3, R1.w;
ADD R0.xyz, R0, R3;
ADD result.color.xyz, R0, R1;
MOV result.color.w, c[5];
END
# 126 instructions, 10 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_Color2]
Vector 7 [_BonusAmbient]
Float 8 [_Reflection]
Vector 9 [_SpecColor]
Float 10 [_Shininess]
Float 11 [_Gloss]
Float 12 [_FlakeScale]
Float 13 [_FlakePower]
Float 14 [_InterFlakePower]
Float 15 [_OuterFlakePower]
Float 16 [_duoPower]
Float 17 [_duoInt]
Vector 18 [_paintColor2]
Vector 19 [_flakeLayerColor]
Float 20 [_FrezPow]
Float 21 [_FrezFalloff]
Float 22 [_threshold]
Float 23 [_thresholdInt]
Vector 24 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 134 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c25, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c26, 20.00000000, 0.00000000, 4.00000000, 0.58642578
def c27, 0.29882813, 0.11450195, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad r0.xy, v3, c4, c4.zwzw
texld r0.yw, r0, s0
mad r1.xy, r0.wyzw, c25.x, c25.y
mov r1.z, c25
dp3 r0.w, r1, r1
mov r2.xyz, v6
add r0.w, -r0, c25
rsq r0.w, r0.w
mul r2.xyz, v1.zxyw, r2.yzxw
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
mul r2.xyz, r1.y, r0
mad r1.xyz, r1.x, v6, r2
rcp r0.w, r0.w
mad r2.xyz, r0.w, v5, r1
add r1.xyz, -v0, c2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r3.xyz, r0.w, r2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
dp3 r0.w, c2, c2
mul r2.xyz, r1.w, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp r1.xyz, -r0.w, r1, r2
dp3 r1.w, r3, r1
mul r2.xyz, -r1.w, r3
add r4.xyz, -v0, c1
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r4.xyz, r0.w, r4
mad r1.xyz, -r2, c25.x, -r1
dp3 r0.w, r1, r4
max r0.w, r0, c25.z
pow r2, r0.w, c10.x
cmp r0.w, r1, c25.z, c25
mov r2.w, r2.x
mov r1.xyz, c24
mul r2.xyz, c9, r1
mul r4.xy, v3, c12.x
mul r1.xy, r4, c26.x
texld r1.xyz, r1, s1
mad r5.xyz, r1, c25.x, c25.y
add r7.xyz, r5, c26.yyzw
mov r1.y, r0.x
mul r2.xyz, r2, r2.w
abs_pp r0.w, r0
cmp r4.xyz, -r0.w, r2, c25.z
mov r2.y, r0.z
dp3 r0.w, v4, v4
mov r2.x, v6.z
mov r2.z, v5
dp3 r6.z, r2, -r7
add r5.xyz, r5, c25.zzww
dp3 r2.z, r2, -r5
mov r1.z, v5.x
mov r1.x, v6
dp3 r6.x, r1, -r7
dp3 r2.x, -r5, r1
mov r0.z, v5.y
mov r0.x, v6.y
dp3 r6.y, r0, -r7
dp3 r2.y, -r5, r0
dp3 r2.w, r6, r6
rsq r2.w, r2.w
mul r7.xyz, r2.w, r6
rsq r0.w, r0.w
mul r6.xyz, r0.w, v4
dp3_sat r0.w, r6, r7
mul r2.w, r0, r0
pow r0, r2.w, c15.x
dp3 r1.x, r2, r2
rsq r0.y, r1.x
mul r1.xyz, r0.y, r2
dp3_sat r1.y, r1, r6
mov r2.w, r0.x
pow r0, r1.y, c14.x
dp3 r1.x, r3, v4
mul r1.xyz, r3, r1.x
mad r1.xyz, -r1, c25.x, v4
texld r2.xyz, r1, s3
mov r0.w, r0.x
mul r0.xyz, r0.w, c19
mul_pp r3.x, r2.y, c26.w
mad r0.xyz, r2.w, c18, r0
mul r0.w, r0, c13.x
mul_sat r0.xyz, r0.w, r0
mad_pp r2.w, r2.x, c27.x, r3.x
mad_pp_sat r0.w, r2.z, c27.y, r2
add_pp r3.xyz, -r2, r0.w
dp3_pp r0.w, v1, r1
mad r0.xyz, r4, c11.x, r0
abs_pp_sat r4.x, r0.w
mad_pp r1.xyz, r3, c22.x, r2
add_pp r2.w, -r4.x, c25
pow_pp r3, r2.w, c21.x
mov_pp r2.w, r3.x
mov_pp r0.w, c22.x
add_pp r0.w, c25, -r0
mov_pp r3.xyz, c7
rcp_pp r0.w, r0.w
add r1.xyz, r1, -c22.x
mul_sat r1.xyz, r1, r0.w
mul_pp r0.w, r2, c20.x
mul_pp r1.xyz, r1, c23.x
add r2.w, r0, c8.x
add r1.xyz, r2, r1
mul r1.xyz, r1, r2.w
pow_pp r2, r4.x, c16.x
mov_pp r2.w, r2.x
mul_pp r3.xyz, c5, r3
mov r2.xyz, c0
mad_sat r2.xyz, c5, r2, r3
mad r4.xyz, v2, c3.x, r2
mul_pp r3.xyz, r2.w, c6
mov r2.xyz, c24
mul r2.xyz, c5, r2
max r1.w, r1, c25.z
mad r3.xyz, r3, c17.x, r4
mad_sat r3.xyz, r2, r1.w, r3
texld r2.xyz, v3, s2
mad r0.xyz, r2, r3, r0
mul r2.xyz, r1, r0.w
add_pp r0.xyz, r0, r1
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c5
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
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_BonusAmbient]
Float 7 [_Reflection]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Float 15 [_threshold]
Float 16 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 56 ALU, 4 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 8, 2, 1, 0 },
		{ 0.11450195, 0.29882813, 0.58642578 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R0.xy, fragment.texcoord[3], c[4], c[4].zwzw;
TEX R0.yw, R0, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[17].y, -c[17].z;
MAD R1.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
MUL R1.xyz, R0.y, R1;
MOV R0.z, c[17].w;
DP3 R0.z, R0, R0;
ADD R0.z, -R0, c[17];
MAD R1.xyz, R0.x, fragment.texcoord[6], R1;
RSQ R0.y, R0.z;
RCP R0.x, R0.y;
MAD R0.xyz, R0.x, fragment.texcoord[5], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, -R0, c[17].y, fragment.texcoord[4];
TEX R0.xyz, R1, texture[4], CUBE;
DP3 R1.x, R1, fragment.texcoord[1];
MUL R0.w, R0.y, c[18].z;
MAD R0.w, R0.x, c[18].y, R0;
MAD_SAT R0.w, R0.z, c[18].x, R0;
ADD R2.xyz, -R0, R0.w;
MAD R2.xyz, R2, c[15].x, R0;
ABS_SAT R1.x, R1;
MOV R0.w, c[17].z;
ADD R0.w, R0, -c[15].x;
ADD R2.xyz, R2, -c[15].x;
ADD R1.w, -R1.x, c[17].z;
RCP R0.w, R0.w;
MUL_SAT R1.xyz, R2, R0.w;
POW R0.w, R1.w, c[14].x;
MUL R1.xyz, R1, c[16].x;
ADD R0.xyz, R0, R1;
MUL R0.w, R0, c[13].x;
ADD R2.x, R0.w, c[7];
MUL R3.xyz, R0, R2.x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
MOV R0.xyz, c[5];
MUL R2.xyz, R1, c[5];
MUL R1.xyz, R0, c[6];
MOV R0.xyz, c[5];
MAD_SAT R0.xyz, R0, c[0], R1;
MAD R0.xyz, fragment.texcoord[2], c[3].x, R0;
MUL R1.xyz, R2, c[17].x;
ADD_SAT R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R3, R0.w;
ADD R0.xyz, R0, R3;
ADD result.color.xyz, R0, R1;
MOV result.color.w, c[5];
END
# 56 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Float 1 [_VertexLightningFactor]
Vector 2 [_BumpMap_ST]
Vector 3 [_Color]
Vector 4 [_BonusAmbient]
Float 5 [_Reflection]
Float 6 [_FrezPow]
Float 7 [_FrezFalloff]
Float 8 [_threshold]
Float 9 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 56 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s4
def c10, 8.00000000, 2.00000000, -1.00000000, 0.00000000
def c11, 0.58642578, 0.29882813, 0.11450195, 1.00000000
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad r0.xy, v3, c2, c2.zwzw
texld r0.yw, r0, s1
mov r1.xyz, v6
mul r2.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v6
mad r0.xy, r0.wyzw, c10.y, c10.z
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r0.y, r1
mov r0.z, c10.w
dp3 r0.z, r0, r0
add r0.z, -r0, c11.w
mad r1.xyz, r0.x, v6, r1
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v5, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r0, v4
mul r0.xyz, r0, r0.w
mad r1.xyz, -r0, c10.y, v4
texld r0.xyz, r1, s4
mul_pp r0.w, r0.y, c11.x
mad_pp r0.w, r0.x, c11.y, r0
mad_pp_sat r0.w, r0.z, c11.z, r0
add_pp r2.xyz, -r0, r0.w
dp3_pp r0.w, r1, v1
abs_pp_sat r1.x, r0.w
mad_pp r2.xyz, r2, c8.x, r0
mov_pp r0.w, c8.x
add_pp r2.w, -r1.x, c11
pow_pp r1, r2.w, c7.x
add_pp r0.w, c11, -r0
rcp_pp r0.w, r0.w
add r2.xyz, r2, -c8.x
mul_sat r2.xyz, r2, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r2, c9.x
add r0.xyz, r0, r1
mul_pp r0.w, r0, c6.x
add r2.x, r0.w, c5
mul r3.xyz, r0, r2.x
texld r1, v3.zwzw, s0
mul_pp r1.xyz, r1.w, r1
mov_pp r0.xyz, c4
mul_pp r2.xyz, r1, c3
mul_pp r1.xyz, c3, r0
mov r0.xyz, c0
mad_sat r0.xyz, c3, r0, r1
mad r0.xyz, v2, c1.x, r0
mul_pp r1.xyz, r2, c10.x
add_sat r1.xyz, r0, r1
texld r0.xyz, v3, s3
mul r0.xyz, r0, r1
mul r1.xyz, r3, r0.w
add_pp r0.xyz, r0, r3
add_pp oC0.xyz, r0, r1
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
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_BonusAmbient]
Float 7 [_Reflection]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Float 15 [_threshold]
Float 16 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 56 ALU, 4 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 8, 2, 1, 0 },
		{ 0.11450195, 0.29882813, 0.58642578 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R0.xy, fragment.texcoord[3], c[4], c[4].zwzw;
TEX R0.yw, R0, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[17].y, -c[17].z;
MAD R1.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
MUL R1.xyz, R0.y, R1;
MOV R0.z, c[17].w;
DP3 R0.z, R0, R0;
ADD R0.z, -R0, c[17];
MAD R1.xyz, R0.x, fragment.texcoord[6], R1;
RSQ R0.y, R0.z;
RCP R0.x, R0.y;
MAD R0.xyz, R0.x, fragment.texcoord[5], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, -R0, c[17].y, fragment.texcoord[4];
TEX R0.xyz, R1, texture[4], CUBE;
DP3 R1.x, R1, fragment.texcoord[1];
MUL R0.w, R0.y, c[18].z;
MAD R0.w, R0.x, c[18].y, R0;
MAD_SAT R0.w, R0.z, c[18].x, R0;
ADD R2.xyz, -R0, R0.w;
MAD R2.xyz, R2, c[15].x, R0;
ABS_SAT R1.x, R1;
MOV R0.w, c[17].z;
ADD R0.w, R0, -c[15].x;
ADD R2.xyz, R2, -c[15].x;
ADD R1.w, -R1.x, c[17].z;
RCP R0.w, R0.w;
MUL_SAT R1.xyz, R2, R0.w;
POW R0.w, R1.w, c[14].x;
MUL R1.xyz, R1, c[16].x;
ADD R0.xyz, R0, R1;
MUL R0.w, R0, c[13].x;
ADD R2.x, R0.w, c[7];
MUL R3.xyz, R0, R2.x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
MOV R0.xyz, c[5];
MUL R2.xyz, R1, c[5];
MUL R1.xyz, R0, c[6];
MOV R0.xyz, c[5];
MAD_SAT R0.xyz, R0, c[0], R1;
MAD R0.xyz, fragment.texcoord[2], c[3].x, R0;
MUL R1.xyz, R2, c[17].x;
ADD_SAT R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R3, R0.w;
ADD R0.xyz, R0, R3;
ADD result.color.xyz, R0, R1;
MOV result.color.w, c[5];
END
# 56 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Float 1 [_VertexLightningFactor]
Vector 2 [_BumpMap_ST]
Vector 3 [_Color]
Vector 4 [_BonusAmbient]
Float 5 [_Reflection]
Float 6 [_FrezPow]
Float 7 [_FrezFalloff]
Float 8 [_threshold]
Float 9 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 56 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s4
def c10, 8.00000000, 2.00000000, -1.00000000, 0.00000000
def c11, 0.58642578, 0.29882813, 0.11450195, 1.00000000
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad r0.xy, v3, c2, c2.zwzw
texld r0.yw, r0, s1
mov r1.xyz, v6
mul r2.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v6
mad r0.xy, r0.wyzw, c10.y, c10.z
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r0.y, r1
mov r0.z, c10.w
dp3 r0.z, r0, r0
add r0.z, -r0, c11.w
mad r1.xyz, r0.x, v6, r1
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v5, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r0, v4
mul r0.xyz, r0, r0.w
mad r1.xyz, -r0, c10.y, v4
texld r0.xyz, r1, s4
mul_pp r0.w, r0.y, c11.x
mad_pp r0.w, r0.x, c11.y, r0
mad_pp_sat r0.w, r0.z, c11.z, r0
add_pp r2.xyz, -r0, r0.w
dp3_pp r0.w, r1, v1
abs_pp_sat r1.x, r0.w
mad_pp r2.xyz, r2, c8.x, r0
mov_pp r0.w, c8.x
add_pp r2.w, -r1.x, c11
pow_pp r1, r2.w, c7.x
add_pp r0.w, c11, -r0
rcp_pp r0.w, r0.w
add r2.xyz, r2, -c8.x
mul_sat r2.xyz, r2, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r2, c9.x
add r0.xyz, r0, r1
mul_pp r0.w, r0, c6.x
add r2.x, r0.w, c5
mul r3.xyz, r0, r2.x
texld r1, v3.zwzw, s0
mul_pp r1.xyz, r1.w, r1
mov_pp r0.xyz, c4
mul_pp r2.xyz, r1, c3
mul_pp r1.xyz, c3, r0
mov r0.xyz, c0
mad_sat r0.xyz, c3, r0, r1
mad r0.xyz, v2, c1.x, r0
mul_pp r1.xyz, r2, c10.x
add_sat r1.xyz, r0, r1
texld r0.xyz, v3, s3
mul r0.xyz, r0, r1
mul r1.xyz, r3, r0.w
add_pp r0.xyz, r0, r3
add_pp oC0.xyz, r0, r1
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
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_Color2]
Vector 7 [_BonusAmbient]
Float 8 [_Reflection]
Vector 9 [_SpecColor]
Float 10 [_Shininess]
Float 11 [_Gloss]
Float 12 [_FlakeScale]
Float 13 [_FlakePower]
Float 14 [_InterFlakePower]
Float 15 [_OuterFlakePower]
Float 16 [_duoPower]
Float 17 [_duoInt]
Vector 18 [_paintColor2]
Vector 19 [_flakeLayerColor]
Float 20 [_FrezPow]
Float 21 [_FrezFalloff]
Float 22 [_threshold]
Float 23 [_thresholdInt]
Vector 24 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 127 ALU, 5 TEX
PARAM c[28] = { state.lightmodel.ambient,
		program.local[1..24],
		{ 2, 1, 0, 20 },
		{ 0, 4, 0.11450195, 0.29882813 },
		{ 0.58642578 } };
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
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
MAD R0.xy, fragment.texcoord[3], c[4], c[4].zwzw;
TEX R0.yw, R0, texture[0], 2D;
MAD R0.xy, R0.wyzw, c[25].x, -c[25].y;
MUL R2.xyz, R0.y, R1;
MOV R0.z, c[25];
DP3 R0.z, R0, R0;
ADD R0.z, -R0, c[25].y;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
MAD R2.xyz, R0.x, fragment.texcoord[6], R2;
RSQ R0.y, R0.z;
RCP R0.x, R0.y;
MAD R0.xyz, R0.x, fragment.texcoord[5], R2;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R5.xyz, R0.w, R0;
DP3 R0.x, R5, fragment.texcoord[4];
MUL R0.xyz, R5, R0.x;
MAD R6.xyz, -R0, c[25].x, fragment.texcoord[4];
TEX R0.xyz, R6, texture[4], CUBE;
MUL R0.w, R0.y, c[27].x;
MAD R0.w, R0.x, c[26], R0;
MAD_SAT R0.w, R0.z, c[26].z, R0;
ADD R8.xyz, -R0, R0.w;
MUL R2.xy, fragment.texcoord[3], c[12].x;
MUL R2.xy, R2, c[25].w;
TEX R2.xyz, R2, texture[1], 2D;
MAD R7.xyz, R2, c[25].x, -c[25].y;
ADD R9.xyz, R7, c[26].xxyw;
MOV R4.y, R1.z;
MOV R3.y, R1.x;
MOV R2.y, R1;
MOV R4.x, fragment.texcoord[6].z;
MOV R4.z, fragment.texcoord[5];
DP3 R1.z, R4, -R9;
ADD R7.xyz, R7, c[25].zzyw;
DP3 R4.z, R4, -R7;
MOV R3.z, fragment.texcoord[5].x;
MOV R3.x, fragment.texcoord[6];
DP3 R4.x, -R7, R3;
DP3 R1.x, R3, -R9;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R1.y, R2, -R9;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R4.y, -R7, R2;
MUL R1.xyz, R0.w, R1;
DP3 R0.w, R4, R4;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R2, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R4;
DP3_SAT R0.w, R1, R2;
POW R2.w, R0.w, c[14].x;
ADD R1.xyz, -fragment.texcoord[0], c[2];
MUL R1.w, R1, R1;
MUL R2.xyz, R2.w, c[19];
POW R1.w, R1.w, c[15].x;
MAD R3.xyz, R1.w, c[18], R2;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R0.w, R2, c[13].x;
MUL R1.xyz, R1.w, R1;
ABS R1.w, -c[2];
DP3 R2.x, c[2], c[2];
CMP R1.w, -R1, c[25].z, c[25].y;
RSQ R2.x, R2.x;
ABS R1.w, R1;
MUL_SAT R3.xyz, R0.w, R3;
MAD R8.xyz, R8, c[22].x, R0;
MUL R2.xyz, R2.x, c[2];
CMP R1.w, -R1, c[25].z, c[25].y;
CMP R1.xyz, -R1.w, R1, R2;
DP3 R0.w, R5, R1;
MUL R4.xyz, -R0.w, R5;
SLT R1.w, R0, c[25].z;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
ABS R1.w, R1;
MAD R1.xyz, -R4, c[25].x, -R1;
MUL R2.xyz, R2.w, R2;
DP3 R1.y, R1, R2;
MAX R2.x, R1.y, c[25].z;
TXP R1.x, fragment.texcoord[7], texture[3], 2D;
POW R2.w, R2.x, c[10].x;
MUL R1.xyz, R1.x, c[24];
MUL R2.xyz, R1, c[9];
MUL R2.xyz, R2, R2.w;
CMP R1.w, -R1, c[25].z, c[25].y;
CMP R2.xyz, -R1.w, R2, c[25].z;
MAD R2.xyz, R2, c[11].x, R3;
DP3 R2.w, fragment.texcoord[1], R6;
ABS_SAT R2.w, R2;
ADD R3.w, -R2, c[25].y;
MOV R1.w, c[25].y;
ADD R1.w, R1, -c[22].x;
RCP R1.w, R1.w;
ADD R3.xyz, R8, -c[22].x;
MUL_SAT R3.xyz, R3, R1.w;
POW R3.w, R3.w, c[21].x;
MUL R1.w, R3, c[20].x;
MUL R3.xyz, R3, c[23].x;
ADD R0.xyz, R0, R3;
ADD R3.w, R1, c[8].x;
MUL R3.xyz, R0, R3.w;
MOV R0.xyz, c[5];
MUL R4.xyz, R0, c[7];
MOV R0.xyz, c[5];
MAD_SAT R0.xyz, R0, c[0], R4;
MAD R4.xyz, fragment.texcoord[2], c[3].x, R0;
POW R2.w, R2.w, c[16].x;
MUL R0.xyz, R2.w, c[6];
MAD R0.xyz, R0, c[17].x, R4;
MAX R0.w, R0, c[25].z;
MUL R1.xyz, R1, c[5];
MAD_SAT R1.xyz, R1, R0.w, R0;
TEX R0.xyz, fragment.texcoord[3], texture[2], 2D;
MAD R0.xyz, R0, R1, R2;
MUL R1.xyz, R3, R1.w;
ADD R0.xyz, R0, R3;
ADD result.color.xyz, R0, R1;
MOV result.color.w, c[5];
END
# 127 instructions, 10 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_Color2]
Vector 7 [_BonusAmbient]
Float 8 [_Reflection]
Vector 9 [_SpecColor]
Float 10 [_Shininess]
Float 11 [_Gloss]
Float 12 [_FlakeScale]
Float 13 [_FlakePower]
Float 14 [_InterFlakePower]
Float 15 [_OuterFlakePower]
Float 16 [_duoPower]
Float 17 [_duoInt]
Vector 18 [_paintColor2]
Vector 19 [_flakeLayerColor]
Float 20 [_FrezPow]
Float 21 [_FrezFalloff]
Float 22 [_threshold]
Float 23 [_thresholdInt]
Vector 24 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_MainTex] 2D
SetTexture 3 [_ShadowMapTexture] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 131 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c25, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c26, 20.00000000, 0.00000000, 4.00000000, 0.58642578
def c27, 0.29882813, 0.11450195, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mad r0.xy, v3, c4, c4.zwzw
texld r0.yw, r0, s0
mad r1.xy, r0.wyzw, c25.x, c25.y
mov r1.z, c25
dp3 r0.w, r1, r1
mov r2.xyz, v6
add r0.w, -r0, c25
rsq r0.w, r0.w
mul r2.xyz, v1.zxyw, r2.yzxw
mov r0.xyz, v6
mad r0.xyz, v1.yzxw, r0.zxyw, -r2
mul r2.xyz, r1.y, r0
mad r1.xyz, r1.x, v6, r2
rcp r0.w, r0.w
mad r2.xyz, r0.w, v5, r1
add r1.xyz, -v0, c2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r4.xyz, r0.w, r2
dp3 r1.w, r1, r1
rsq r1.w, r1.w
dp3 r0.w, c2, c2
mul r2.xyz, r1.w, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp r1.xyz, -r0.w, r1, r2
dp3 r1.w, r4, r1
mul r2.xyz, -r1.w, r4
add r3.xyz, -v0, c1
dp3 r0.w, r3, r3
rsq r0.w, r0.w
mad r1.xyz, -r2, c25.x, -r1
mul r3.xyz, r0.w, r3
dp3 r0.w, r1, r3
max r1.x, r0.w, c25.z
pow r2, r1.x, c10.x
cmp r0.w, r1, c25.z, c25
texldp r1.x, v7, s3
mul r3.xyz, r1.x, c24
mov r2.z, r2.x
mul r2.xy, v3, c12.x
mul r5.xy, r2, c26.x
mul r1.xyz, r3, c9
mul r2.xyz, r1, r2.z
texld r1.xyz, r5, s1
mad r6.xyz, r1, c25.x, c25.y
add r8.xyz, r6, c26.yyzw
mov r1.y, r0.x
abs_pp r0.w, r0
cmp r5.xyz, -r0.w, r2, c25.z
mov r2.y, r0.z
dp3 r0.w, v4, v4
mov r2.x, v6.z
mov r2.z, v5
dp3 r7.z, r2, -r8
add r6.xyz, r6, c25.zzww
dp3 r2.z, r2, -r6
mov r1.z, v5.x
mov r1.x, v6
dp3 r7.x, r1, -r8
dp3 r2.x, -r6, r1
mov r0.z, v5.y
mov r0.x, v6.y
dp3 r7.y, r0, -r8
dp3 r2.y, -r6, r0
dp3 r2.w, r7, r7
rsq r2.w, r2.w
mul r8.xyz, r2.w, r7
rsq r0.w, r0.w
mul r7.xyz, r0.w, v4
dp3_sat r0.w, r7, r8
mul r2.w, r0, r0
pow r0, r2.w, c15.x
dp3 r1.x, r2, r2
rsq r0.y, r1.x
mul r1.xyz, r0.y, r2
dp3_sat r1.y, r1, r7
mov r2.w, r0.x
pow r0, r1.y, c14.x
mov r0.w, r0.x
mul r2.xyz, r0.w, c19
dp3 r1.x, r4, v4
mul r1.xyz, r4, r1.x
mad r1.xyz, -r1, c25.x, v4
texld r0.xyz, r1, s4
mul_pp r3.w, r0.y, c26
mad r2.xyz, r2.w, c18, r2
mul r0.w, r0, c13.x
mul_sat r2.xyz, r0.w, r2
mad_pp r2.w, r0.x, c27.x, r3
mad_pp_sat r0.w, r0.z, c27.y, r2
mad r4.xyz, r5, c11.x, r2
add_pp r2.xyz, -r0, r0.w
dp3_pp r0.w, v1, r1
abs_pp_sat r3.w, r0
mad_pp r1.xyz, r2, c22.x, r0
add_pp r4.w, -r3, c25
pow_pp r2, r4.w, c21.x
mul_pp r2.w, r2.x, c20.x
mov_pp r2.xyz, c7
mul_pp r5.xyz, c5, r2
mov_pp r0.w, c22.x
add_pp r0.w, c25, -r0
mov r2.xyz, c0
mad_sat r2.xyz, c5, r2, r5
rcp_pp r0.w, r0.w
add r1.xyz, r1, -c22.x
mul_sat r1.xyz, r1, r0.w
mul_pp r1.xyz, r1, c23.x
add r0.xyz, r0, r1
add r0.w, r2, c8.x
mul r1.xyz, r0, r0.w
pow_pp r0, r3.w, c16.x
mad r2.xyz, v2, c3.x, r2
mul_pp r0.xyz, r0.x, c6
mad r0.xyz, r0, c17.x, r2
max r1.w, r1, c25.z
mul r2.xyz, r3, c5
mad_sat r2.xyz, r2, r1.w, r0
texld r0.xyz, v3, s2
mad r0.xyz, r0, r2, r4
mul r2.xyz, r1, r2.w
add_pp r0.xyz, r0, r1
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c5
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
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_BonusAmbient]
Float 7 [_Reflection]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Float 15 [_threshold]
Float 16 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 5 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 56 ALU, 4 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 8, 2, 1, 0 },
		{ 0.11450195, 0.29882813, 0.58642578 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R0.xy, fragment.texcoord[3], c[4], c[4].zwzw;
TEX R0.yw, R0, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[17].y, -c[17].z;
MAD R1.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
MUL R1.xyz, R0.y, R1;
MOV R0.z, c[17].w;
DP3 R0.z, R0, R0;
ADD R0.z, -R0, c[17];
MAD R1.xyz, R0.x, fragment.texcoord[6], R1;
RSQ R0.y, R0.z;
RCP R0.x, R0.y;
MAD R0.xyz, R0.x, fragment.texcoord[5], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, -R0, c[17].y, fragment.texcoord[4];
TEX R0.xyz, R1, texture[5], CUBE;
DP3 R1.x, R1, fragment.texcoord[1];
MUL R0.w, R0.y, c[18].z;
MAD R0.w, R0.x, c[18].y, R0;
MAD_SAT R0.w, R0.z, c[18].x, R0;
ADD R2.xyz, -R0, R0.w;
MAD R2.xyz, R2, c[15].x, R0;
ABS_SAT R1.x, R1;
MOV R0.w, c[17].z;
ADD R0.w, R0, -c[15].x;
ADD R2.xyz, R2, -c[15].x;
ADD R1.w, -R1.x, c[17].z;
RCP R0.w, R0.w;
MUL_SAT R1.xyz, R2, R0.w;
POW R0.w, R1.w, c[14].x;
MUL R1.xyz, R1, c[16].x;
ADD R0.xyz, R0, R1;
MUL R0.w, R0, c[13].x;
ADD R2.x, R0.w, c[7];
MUL R3.xyz, R0, R2.x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
MOV R0.xyz, c[5];
MUL R2.xyz, R1, c[5];
MUL R1.xyz, R0, c[6];
MOV R0.xyz, c[5];
MAD_SAT R0.xyz, R0, c[0], R1;
MAD R0.xyz, fragment.texcoord[2], c[3].x, R0;
MUL R1.xyz, R2, c[17].x;
ADD_SAT R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R3, R0.w;
ADD R0.xyz, R0, R3;
ADD result.color.xyz, R0, R1;
MOV result.color.w, c[5];
END
# 56 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Float 1 [_VertexLightningFactor]
Vector 2 [_BumpMap_ST]
Vector 3 [_Color]
Vector 4 [_BonusAmbient]
Float 5 [_Reflection]
Float 6 [_FrezPow]
Float 7 [_FrezFalloff]
Float 8 [_threshold]
Float 9 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 5 [_Cube] CUBE
"ps_3_0
; 56 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s5
def c10, 8.00000000, 2.00000000, -1.00000000, 0.00000000
def c11, 0.58642578, 0.29882813, 0.11450195, 1.00000000
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad r0.xy, v3, c2, c2.zwzw
texld r0.yw, r0, s1
mov r1.xyz, v6
mul r2.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v6
mad r0.xy, r0.wyzw, c10.y, c10.z
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r0.y, r1
mov r0.z, c10.w
dp3 r0.z, r0, r0
add r0.z, -r0, c11.w
mad r1.xyz, r0.x, v6, r1
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v5, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r0, v4
mul r0.xyz, r0, r0.w
mad r1.xyz, -r0, c10.y, v4
texld r0.xyz, r1, s5
mul_pp r0.w, r0.y, c11.x
mad_pp r0.w, r0.x, c11.y, r0
mad_pp_sat r0.w, r0.z, c11.z, r0
add_pp r2.xyz, -r0, r0.w
dp3_pp r0.w, r1, v1
abs_pp_sat r1.x, r0.w
mad_pp r2.xyz, r2, c8.x, r0
mov_pp r0.w, c8.x
add_pp r2.w, -r1.x, c11
pow_pp r1, r2.w, c7.x
add_pp r0.w, c11, -r0
rcp_pp r0.w, r0.w
add r2.xyz, r2, -c8.x
mul_sat r2.xyz, r2, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r2, c9.x
add r0.xyz, r0, r1
mul_pp r0.w, r0, c6.x
add r2.x, r0.w, c5
mul r3.xyz, r0, r2.x
texld r1, v3.zwzw, s0
mul_pp r1.xyz, r1.w, r1
mov_pp r0.xyz, c4
mul_pp r2.xyz, r1, c3
mul_pp r1.xyz, c3, r0
mov r0.xyz, c0
mad_sat r0.xyz, c3, r0, r1
mad r0.xyz, v2, c1.x, r0
mul_pp r1.xyz, r2, c10.x
add_sat r1.xyz, r0, r1
texld r0.xyz, v3, s3
mul r0.xyz, r0, r1
mul r1.xyz, r3, r0.w
add_pp r0.xyz, r0, r3
add_pp oC0.xyz, r0, r1
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
Float 3 [_VertexLightningFactor]
Vector 4 [_BumpMap_ST]
Vector 5 [_Color]
Vector 6 [_BonusAmbient]
Float 7 [_Reflection]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Float 15 [_threshold]
Float 16 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 5 [_Cube] CUBE
"3.0-!!ARBfp1.0
# 56 ALU, 4 TEX
PARAM c[19] = { state.lightmodel.ambient,
		program.local[1..16],
		{ 8, 2, 1, 0 },
		{ 0.11450195, 0.29882813, 0.58642578 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R0.xy, fragment.texcoord[3], c[4], c[4].zwzw;
TEX R0.yw, R0, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[17].y, -c[17].z;
MAD R1.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
MUL R1.xyz, R0.y, R1;
MOV R0.z, c[17].w;
DP3 R0.z, R0, R0;
ADD R0.z, -R0, c[17];
MAD R1.xyz, R0.x, fragment.texcoord[6], R1;
RSQ R0.y, R0.z;
RCP R0.x, R0.y;
MAD R0.xyz, R0.x, fragment.texcoord[5], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, -R0, c[17].y, fragment.texcoord[4];
TEX R0.xyz, R1, texture[5], CUBE;
DP3 R1.x, R1, fragment.texcoord[1];
MUL R0.w, R0.y, c[18].z;
MAD R0.w, R0.x, c[18].y, R0;
MAD_SAT R0.w, R0.z, c[18].x, R0;
ADD R2.xyz, -R0, R0.w;
MAD R2.xyz, R2, c[15].x, R0;
ABS_SAT R1.x, R1;
MOV R0.w, c[17].z;
ADD R0.w, R0, -c[15].x;
ADD R2.xyz, R2, -c[15].x;
ADD R1.w, -R1.x, c[17].z;
RCP R0.w, R0.w;
MUL_SAT R1.xyz, R2, R0.w;
POW R0.w, R1.w, c[14].x;
MUL R1.xyz, R1, c[16].x;
ADD R0.xyz, R0, R1;
MUL R0.w, R0, c[13].x;
ADD R2.x, R0.w, c[7];
MUL R3.xyz, R0, R2.x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
MOV R0.xyz, c[5];
MUL R2.xyz, R1, c[5];
MUL R1.xyz, R0, c[6];
MOV R0.xyz, c[5];
MAD_SAT R0.xyz, R0, c[0], R1;
MAD R0.xyz, fragment.texcoord[2], c[3].x, R0;
MUL R1.xyz, R2, c[17].x;
ADD_SAT R1.xyz, R0, R1;
TEX R0.xyz, fragment.texcoord[3], texture[3], 2D;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R3, R0.w;
ADD R0.xyz, R0, R3;
ADD result.color.xyz, R0, R1;
MOV result.color.w, c[5];
END
# 56 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Float 1 [_VertexLightningFactor]
Vector 2 [_BumpMap_ST]
Vector 3 [_Color]
Vector 4 [_BonusAmbient]
Float 5 [_Reflection]
Float 6 [_FrezPow]
Float 7 [_FrezFalloff]
Float 8 [_threshold]
Float 9 [_thresholdInt]
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_MainTex] 2D
SetTexture 5 [_Cube] CUBE
"ps_3_0
; 56 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s3
dcl_cube s5
def c10, 8.00000000, 2.00000000, -1.00000000, 0.00000000
def c11, 0.58642578, 0.29882813, 0.11450195, 1.00000000
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad r0.xy, v3, c2, c2.zwzw
texld r0.yw, r0, s1
mov r1.xyz, v6
mul r2.xyz, v1.zxyw, r1.yzxw
mov r1.xyz, v6
mad r0.xy, r0.wyzw, c10.y, c10.z
mad r1.xyz, v1.yzxw, r1.zxyw, -r2
mul r1.xyz, r0.y, r1
mov r0.z, c10.w
dp3 r0.z, r0, r0
add r0.z, -r0, c11.w
mad r1.xyz, r0.x, v6, r1
rsq r0.y, r0.z
rcp r0.x, r0.y
mad r0.xyz, r0.x, v5, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.w, r0, v4
mul r0.xyz, r0, r0.w
mad r1.xyz, -r0, c10.y, v4
texld r0.xyz, r1, s5
mul_pp r0.w, r0.y, c11.x
mad_pp r0.w, r0.x, c11.y, r0
mad_pp_sat r0.w, r0.z, c11.z, r0
add_pp r2.xyz, -r0, r0.w
dp3_pp r0.w, r1, v1
abs_pp_sat r1.x, r0.w
mad_pp r2.xyz, r2, c8.x, r0
mov_pp r0.w, c8.x
add_pp r2.w, -r1.x, c11
pow_pp r1, r2.w, c7.x
add_pp r0.w, c11, -r0
rcp_pp r0.w, r0.w
add r2.xyz, r2, -c8.x
mul_sat r2.xyz, r2, r0.w
mov_pp r0.w, r1.x
mul_pp r1.xyz, r2, c9.x
add r0.xyz, r0, r1
mul_pp r0.w, r0, c6.x
add r2.x, r0.w, c5
mul r3.xyz, r0, r2.x
texld r1, v3.zwzw, s0
mul_pp r1.xyz, r1.w, r1
mov_pp r0.xyz, c4
mul_pp r2.xyz, r1, c3
mul_pp r1.xyz, c3, r0
mov r0.xyz, c0
mad_sat r0.xyz, c3, r0, r1
mad r0.xyz, v2, c1.x, r0
mul_pp r1.xyz, r2, c10.x
add_sat r1.xyz, r0, r1
texld r0.xyz, v3, s3
mul r0.xyz, r0, r1
mul r1.xyz, r3, r0.w
add_pp r0.xyz, r0, r3
add_pp oC0.xyz, r0, r1
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

#LINE 387

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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
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
uniform highp float _Gloss;
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
  highp vec3 tmpvar_7;
  tmpvar_7 = (specularReflection * _Gloss);
  specularReflection = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_5 + tmpvar_7);
  gl_FragData[0] = tmpvar_8;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 41 to 41, TEX: 0 to 0
//   d3d9 - ALU: 42 to 42
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"3.0-!!ARBfp1.0
# 41 ALU, 0 TEX
PARAM c[8] = { program.local[0..6],
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
CMP R1.w, -R1.x, c[7].y, c[7].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[7].y, c[7].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[7].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[7].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[7];
MUL R0.x, R0, c[7].z;
SLT R0.w, R2, c[7].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[7];
MUL R0.xyz, R0.x, c[6];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[7].y, c[7].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[7].y;
MUL R1.xyz, R1, c[5].x;
MAX R0.w, R2, c[7].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[7].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"ps_3_0
; 42 ALU
def c7, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c7.x, c7.y
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
mad r0.xyz, -r0, c7.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c7
max r0.y, r0, c7
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c7.z
cmp r0.x, -r0.w, r0, c7
cmp r0.w, r2, c7.y, c7.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c6
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c7.y
mul r1.xyz, r1, c5.x
max r0.w, r2, c7.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c7.x
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
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"3.0-!!ARBfp1.0
# 41 ALU, 0 TEX
PARAM c[8] = { program.local[0..6],
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
CMP R1.w, -R1.x, c[7].y, c[7].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[7].y, c[7].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[7].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[7].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[7];
MUL R0.x, R0, c[7].z;
SLT R0.w, R2, c[7].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[7];
MUL R0.xyz, R0.x, c[6];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[7].y, c[7].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[7].y;
MUL R1.xyz, R1, c[5].x;
MAX R0.w, R2, c[7].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[7].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"ps_3_0
; 42 ALU
def c7, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c7.x, c7.y
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
mad r0.xyz, -r0, c7.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c7
max r0.y, r0, c7
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c7.z
cmp r0.x, -r0.w, r0, c7
cmp r0.w, r2, c7.y, c7.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c6
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c7.y
mul r1.xyz, r1, c5.x
max r0.w, r2, c7.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c7.x
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
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"3.0-!!ARBfp1.0
# 41 ALU, 0 TEX
PARAM c[8] = { program.local[0..6],
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
CMP R1.w, -R1.x, c[7].y, c[7].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[7].y, c[7].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[7].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[7].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[7];
MUL R0.x, R0, c[7].z;
SLT R0.w, R2, c[7].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[7];
MUL R0.xyz, R0.x, c[6];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[7].y, c[7].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[7].y;
MUL R1.xyz, R1, c[5].x;
MAX R0.w, R2, c[7].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[7].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"ps_3_0
; 42 ALU
def c7, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c7.x, c7.y
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
mad r0.xyz, -r0, c7.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c7
max r0.y, r0, c7
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c7.z
cmp r0.x, -r0.w, r0, c7
cmp r0.w, r2, c7.y, c7.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c6
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c7.y
mul r1.xyz, r1, c5.x
max r0.w, r2, c7.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c7.x
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
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"3.0-!!ARBfp1.0
# 41 ALU, 0 TEX
PARAM c[8] = { program.local[0..6],
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
CMP R1.w, -R1.x, c[7].y, c[7].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[7].y, c[7].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[7].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[7].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[7];
MUL R0.x, R0, c[7].z;
SLT R0.w, R2, c[7].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[7];
MUL R0.xyz, R0.x, c[6];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[7].y, c[7].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[7].y;
MUL R1.xyz, R1, c[5].x;
MAX R0.w, R2, c[7].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[7].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"ps_3_0
; 42 ALU
def c7, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c7.x, c7.y
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
mad r0.xyz, -r0, c7.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c7
max r0.y, r0, c7
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c7.z
cmp r0.x, -r0.w, r0, c7
cmp r0.w, r2, c7.y, c7.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c6
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c7.y
mul r1.xyz, r1, c5.x
max r0.w, r2, c7.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c7.x
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
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"3.0-!!ARBfp1.0
# 41 ALU, 0 TEX
PARAM c[8] = { program.local[0..6],
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
CMP R1.w, -R1.x, c[7].y, c[7].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[7].y, c[7].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[7].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[7].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[7];
MUL R0.x, R0, c[7].z;
SLT R0.w, R2, c[7].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[7];
MUL R0.xyz, R0.x, c[6];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[7].y, c[7].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[7].y;
MUL R1.xyz, R1, c[5].x;
MAX R0.w, R2, c[7].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[7].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"ps_3_0
; 42 ALU
def c7, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c7.x, c7.y
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
mad r0.xyz, -r0, c7.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c7
max r0.y, r0, c7
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c7.z
cmp r0.x, -r0.w, r0, c7
cmp r0.w, r2, c7.y, c7.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c6
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c7.y
mul r1.xyz, r1, c5.x
max r0.w, r2, c7.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c7.x
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
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"3.0-!!ARBfp1.0
# 41 ALU, 0 TEX
PARAM c[8] = { program.local[0..6],
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
CMP R1.w, -R1.x, c[7].y, c[7].x;
DP3 R1.y, c[1], c[1];
RSQ R1.y, R1.y;
ABS R1.w, R1;
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
CMP R1.w, -R1, c[7].y, c[7].x;
MUL R1.xyz, R1.y, c[1];
CMP R1.xyz, -R1.w, R0, R1;
RSQ R0.x, R2.x;
ADD R2.xyz, -fragment.texcoord[0], c[0];
MUL R0.xyz, R0.x, fragment.texcoord[1];
DP3 R2.w, R0, R1;
DP3 R3.x, R2, R2;
MUL R0.xyz, -R2.w, R0;
MAD R0.xyz, -R0, c[7].z, -R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R2;
DP3 R0.y, R0, R1;
ADD R0.w, R0, c[7].x;
RCP R0.x, R0.w;
MAX R0.y, R0, c[7];
MUL R0.x, R0, c[7].z;
SLT R0.w, R2, c[7].y;
ABS R0.w, R0;
POW R2.x, R0.y, c[4].x;
CMP R0.x, -R1.w, R0, c[7];
MUL R0.xyz, R0.x, c[6];
MUL R1.xyz, R0, c[3];
CMP R0.w, -R0, c[7].y, c[7].x;
MUL R1.xyz, R1, R2.x;
CMP R1.xyz, -R0.w, R1, c[7].y;
MUL R1.xyz, R1, c[5].x;
MAX R0.w, R2, c[7].y;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[7].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_Color]
Vector 3 [_SpecColor]
Float 4 [_Shininess]
Float 5 [_Gloss]
Vector 6 [_LightColor0]
"ps_3_0
; 42 ALU
def c7, 1.00000000, 0.00000000, 2.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
add r0.xyz, -v0, c1
dp3 r1.w, r0, r0
rsq r0.w, r1.w
mul r0.xyz, r0.w, r0
dp3 r1.x, c1, c1
abs_pp r0.w, -c1
rsq r1.x, r1.x
cmp_pp r0.w, -r0, c7.x, c7.y
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
mad r0.xyz, -r0, c7.z, -r2
mul r1.xyz, r3.x, r1
dp3 r0.y, r0, r1
add r0.x, r1.w, c7
max r0.y, r0, c7
pow r1, r0.y, c4.x
rcp r0.x, r0.x
mul r0.x, r0, c7.z
cmp r0.x, -r0.w, r0, c7
cmp r0.w, r2, c7.y, c7.x
mov r1.w, r1.x
mul r0.xyz, r0.x, c6
mul r1.xyz, r0, c3
abs_pp r0.w, r0
mul r1.xyz, r1, r1.w
cmp r1.xyz, -r0.w, r1, c7.y
mul r1.xyz, r1, c5.x
max r0.w, r2, c7.y
mul r0.xyz, r0, c2
mad oC0.xyz, r0, r0.w, r1
mov oC0.w, c7.x
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

#LINE 502

      }
      
      
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Specular"
}