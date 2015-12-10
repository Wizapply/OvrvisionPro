Shader "Ovrvision/ovTexture" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue" = "Background+1" "RenderType"="Background" }
		LOD 200
		
		Pass {
			Lighting Off
			ZWrite Off
			ZTest Always
			Blend SrcAlpha OneMinusSrcAlpha
			SetTexture [_MainTex] {combine texture}
		}
	} 
	FallBack Off
}
