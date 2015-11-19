Shader "Ovrvision/ovHandMaskRev" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color_maxh ("Max Hue",Range (0.0,1.0)) = 1.0
		_Color_minh ("Min Hue",Range (0.0,1.0)) = 0.0
		_Color_maxs ("Max Saturation",Range (0.0,1.0)) = 1.0
		_Color_mins ("Min Saturation",Range (0.0,1.0)) = 0.0
		_Color_maxv ("Max Brightness",Range (0.0,1.0)) = 1.0
		_Color_minv ("Min Brightness",Range (0.0,1.0)) = 0.0
		
		_Color_maxY ("Max Y",Range (0.0,1.0)) = 1.0
		_Color_minY ("Min Y",Range (0.0,1.0)) = 0.0
		_Color_maxCb ("Max Cb",Range (0.0,1.0)) = 1.0
		_Color_minCb ("Min Cb",Range (0.0,1.0)) = 0.0
		_Color_maxCr ("Max Cr",Range (0.0,1.0)) = 1.0
		_Color_minCr ("Min Cr",Range (0.0,1.0)) = 0.0
	}
	SubShader {
		Tags { "Queue" = "Overlay+1" "RenderType"="Overlay" }
		LOD 0
		
		Pass {
			Lighting Off
			ZWrite Off
			ZTest Off
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
			
			float _Color_maxY;
			float _Color_minY;
			float _Color_maxCB;
			float _Color_minCB;
			float _Color_maxCR;
			float _Color_minCR;
			
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
			
			float3 RGBtoYCbCr(float3 RGB) //0.0-1.0
			{
				float3 YCbCr = 0;
				
				YCbCr.x = (0.299 * RGB.x + 0.587 * RGB.y + 0.114 * RGB.z);
				YCbCr.y = 0.5 + (-0.16874 * RGB.x - 0.33126 * RGB.y + 0.5 * RGB.z);
				YCbCr.z = 0.5 + (0.5 * RGB.x - 0.41869 * RGB.y - 0.08131 * RGB.z);
				
				return YCbCr;
			}
			
			float4 detectColor(float2 imageUv)
			{
				float alpha = 0.0;
				float3 colors = tex2D(_MainTex, imageUv).rgb;
				float3 hsvcolor = RGBtoHSV(colors);
				float3 ycbcrcolor = RGBtoYCbCr(colors);
				
				//HSV
				if(hsvcolor.r <= _Color_minh || hsvcolor.r >= _Color_maxh) {
					if(hsvcolor.g >= _Color_mins && hsvcolor.g <= _Color_maxs) {
						if(hsvcolor.b >= _Color_minv && hsvcolor.b <= _Color_maxv)
							alpha=1.0;
					}
				}

				//YCbCr
				if(ycbcrcolor.r >= _Color_minY && ycbcrcolor.r <= _Color_maxY) {
					if(ycbcrcolor.g >= _Color_minCB && ycbcrcolor.g <= _Color_maxCB) {
						if(ycbcrcolor.b >= _Color_minCR && ycbcrcolor.b <= _Color_maxCR)
							alpha=0.0;
					}
				}
				
				return float4(colors,alpha);
			}

			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float4 frag (v2f i) : COLOR0
			{
				float4 resColor = detectColor(i.uv_MainTex);
				float alpha = 0.0;
				alpha += detectColor(i.uv_MainTex + float2( 0.005, 0.00)).w;
				alpha += detectColor(i.uv_MainTex + float2(-0.005, 0.00)).w;
				alpha += detectColor(i.uv_MainTex + float2( 0.00, 0.005)).w;
				alpha += detectColor(i.uv_MainTex + float2( 0.00,-0.005)).w;
				if(alpha < 3.0)
					resColor.w = 0.0f;
				return resColor; 
			}
			ENDCG
		}
	} 
	FallBack Off
}
