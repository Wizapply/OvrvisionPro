Shader "Ovrvision/ovTextureOR" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue" = "Overlay+1" "RenderType"="Overlay" }
		LOD 0
		
		Pass {
			Lighting Off
			ZWrite Off
			ZTest Off
			Blend SrcAlpha OneMinusSrcAlpha
			SetTexture [_MainTex] {combine texture}
		}
	} 
	FallBack Off
}
