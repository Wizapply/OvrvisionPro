// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Ovrvision/ovChromaticMask" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color_maxh ("Max Hue",Range (0.0,1.0)) = 1.0
		_Color_minh ("Min Hue",Range (0.0,1.0)) = 0.0
		_Color_maxs ("Max Saturation",Range (0.0,1.0)) = 1.0
		_Color_mins ("Min Saturation",Range (0.0,1.0)) = 0.0
		_Color_maxv ("Max Brightness",Range (0.0,1.0)) = 1.0
		_Color_minv ("Min Brightness",Range (0.0,1.0)) = 0.0
	}
	SubShader {
		Tags { "Queue" = "Overlay+1" "RenderType"="Overlay" }
		LOD 0
		
		Pass {
			Lighting Off
			ZWrite Off
			ZTest Always
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float _Color_maxh;
			float _Color_minh;
			float _Color_maxs;
			float _Color_mins;
			float _Color_maxv;
			float _Color_minv;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv_MainTex : TEXCOORD1;
			};
			
			float3 RGBtoHSV(float3 RGB)
			{
				float3 HSV = 0;
				float M = min(RGB.r, min(RGB.g, RGB.b));
				HSV.z = max(RGB.r, max(RGB.g, RGB.b));
				float C = HSV.z - M;
				if (C != 0)
				{
					HSV.y = C / HSV.z;
					float3 D = (((HSV.z - RGB) / 6) + (C / 2)) / C;
					if (RGB.r == HSV.z)
						HSV.x = D.b - D.g;
					else if (RGB.g == HSV.z)
						HSV.x = (1.0/3.0) + D.r - D.b;
					else if (RGB.b == HSV.z)
						HSV.x = (2.0/3.0) + D.g - D.r;
					if ( HSV.x < 0.0 ) { HSV.x += 1.0; }
					if ( HSV.x > 1.0 ) { HSV.x -= 1.0; }
				}
				return HSV;
			}

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float4 frag (v2f i) : COLOR0
			{
				float3 colors = tex2D(_MainTex, i.uv_MainTex).rgb;
				float3 hsvcolor = RGBtoHSV(colors);
				
				if(hsvcolor.r >= _Color_minh && hsvcolor.r <= _Color_maxh) {
					if(hsvcolor.g >= _Color_mins && hsvcolor.g <= _Color_maxs) {
						if(hsvcolor.b >= _Color_minv && hsvcolor.b <= _Color_maxv)
							discard;
					}
				}
						
				return float4(colors,1.0); 
			}
			ENDCG
		}
	} 
	FallBack Off
}
