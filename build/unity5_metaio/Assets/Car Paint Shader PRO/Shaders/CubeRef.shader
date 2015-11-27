Shader "TexGen/CubeReflect" {
Properties {
    _Cube ("Cubemap", Cube) = "" { /* used to be TexGen CubeReflect */ }
}
SubShader {
	Tags {"Queue"="Transparent+1" "RenderType"="Transparent"}
	Alphatest Greater 0 ZWrite Off ColorMask RGB
	Blend SrcAlpha OneMinusSrcAlpha
	
    Pass { 
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        
        struct v2f {
            float4 pos : SV_POSITION;
            float3 uv : TEXCOORD0;
        };

        v2f vert (float4 v : POSITION, float3 n : NORMAL)
        {
            v2f o;
            o.pos = mul(UNITY_MATRIX_MVP, v);

            // TexGen CubeReflect:
            // reflect view direction along the normal,
            // in view space
            float3 viewDir = normalize(ObjSpaceViewDir(v));
            o.uv = reflect(-viewDir, n);
            o.uv = mul(UNITY_MATRIX_MV, float4(o.uv,0));
            return o;
        }

        samplerCUBE _Cube;
        half4 frag (v2f i) : SV_Target
        {
			float4 color = texCUBE(_Cube, i.uv);
			color.rgb *= 0.5f;
			color.a = 0.5;
            return color;
        }
        ENDCG 
    } 
}
}