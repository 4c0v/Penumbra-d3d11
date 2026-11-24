#include "d3d11_common.hlsli"

SAMPLER2D(srcTex, 0);

void main(float4 pos : SV_Position,
          float4 color : COLOR0,
          float2 uv0 : TEXCOORD0,
          float2 uv1 : TEXCOORD1,
          float2 uv2 : TEXCOORD2,
          float2 uv3 : TEXCOORD3,

          out float4 oColor : SV_Target)
{
	float4 col5 = TEX2D(srcTex, (uv0 + uv2) / 2) * 0.35;

	float4 col1 = TEX2D(srcTex, uv0) * 0.15;
	float4 col3 = TEX2D(srcTex, uv2) * 0.15;

	float4 col6 = TEX2D(srcTex, (uv2 + uv3) / 2) * 0.1;
	float4 col7 = TEX2D(srcTex, (uv0 + uv1) / 2) * 0.1;

	float4 col2 = TEX2D(srcTex, uv1) * 0.075;
	float4 col4 = TEX2D(srcTex, uv3) * 0.075;

	oColor = col1 + col2 + col3 + col4 + col5 + col6 + col7;
}
