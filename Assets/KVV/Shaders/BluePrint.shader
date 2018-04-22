Shader "Kronal/BluePrint" {
Properties {
	_MainTex ("Base (RGB)", Rect) = "white" {}
	_Color ("Base Color (RGB)", Color) = (0.0, 0.192, 0.325, 1.0)
	_MidColor ("Mid Color (RGB)", Color) = (0.0, 0.447, 0.733, 1.0)
	_Gamma ("Gamma", Range(0.0, 3.0)) = 1.0
}

SubShader {
	Pass {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest 
#include "UnityCG.cginc"

uniform sampler2D _MainTex;
uniform float4 _MainTex_TexelSize;
uniform float4 _Color;
uniform float4 _MidColor;
uniform float _Gamma;

struct v2f {
	float4 pos : POSITION;
	float2 uv : TEXCOORD0;
	float2 screenPos : TEXCOORD1;
	float4 wpos : TEXCOORD2;
};

v2f vert( appdata_img v )
{
	v2f i;
	i.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	i.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
	i.screenPos = i.pos.xy / i.pos.z;
	i.wpos = mul(_Object2World, v.vertex);
	return i;
}

float rand(float2 co){
    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
    //return frac(sin(dot(co.xy, float2(_ScaleX, _ScaleY))) * 43758.5453);
}

float grid(float2 co) {
	float2 spacing = float2(0.01, 0.01);
	float2 smallspacing = float2(0.1, 0.1);
	
	return saturate((abs(frac(co.x * spacing.x) - .5) < spacing.x ? 1. : 0.) +
	                (abs(frac(co.y * spacing.y) - .5) < spacing.y ? 1. : 0.) +
	                (abs(frac(co.x * smallspacing.x + smallspacing.x * 4.) - .5) < smallspacing.x * 0.5 ? 1. : 0.) +
	                (abs(frac(co.y * smallspacing.y + smallspacing.y * 4.) - .5) < smallspacing.y * 0.5 ? 1. : 0.));
}

half4 frag (v2f i) : COLOR
{
	float4 original = tex2D(_MainTex, i.uv);
	if (original.a < 0.0001) {	
		//float n = rand(i.uv);
		//return half4(pow(lerp(_Color, _MidColor, n), _Gamma).rgb, 1.0);
		float g = grid(i.wpos.xy);
		return half4(pow(abs(_Color + 0.15 * g * _MidColor), _Gamma).rgb, 1.0);
	} else {
		return original;
	}
}
ENDCG
		}
	}
	Fallback off
}
