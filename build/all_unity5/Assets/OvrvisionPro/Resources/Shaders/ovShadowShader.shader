// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Ovrvision/ovShadowShader" {
Properties { 
	_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
} 
SubShader { 
	Tags {"RenderType"="Opaque" "Queue" = "Geometry" "LightMode" = "ForwardBase"}
	LOD 100
	Pass {
		Blend SrcAlpha OneMinusSrcAlpha 
		CGPROGRAM 
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			#include "AutoLight.cginc"

			struct v2f { 
				float2 uv_MainTex : TEXCOORD1;
				float4 pos : SV_POSITION;
				SHADOW_COORDS(3)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata_base v) {
				v2f o;
				o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.pos = UnityObjectToClipPos (v.vertex);
				TRANSFER_SHADOW(o);
				return o;
			}

			float4 frag (v2f i) : COLOR {
				half4 c = tex2D(_MainTex, i.uv_MainTex);
				c.rgb = 0.0;
				c.a *= (1 - min(SHADOW_ATTENUATION(i), 1));
				return c;
			}
		ENDCG
		}
	}
	Fallback "VertexLit"
}