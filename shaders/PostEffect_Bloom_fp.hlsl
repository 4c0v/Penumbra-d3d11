#include "d3d11_common.hlsli"

SAMPLER2D(blurTex, 0);
SAMPLERRECT(screenTex, 1);

void main(float4 pos : SV_Position,
          float4 color : COLOR0,
          float2 uv0 : TEXCOORD0,
          float2 uv1 : TEXCOORD1,

          out float4 oColor : SV_Target)
{
	float4 blurCol = TEX2D(blurTex, uv0);
	float4 screenCol = TEXRECT(screenTex, uv1);
	const float BLOOM_GAIN = 1.35;
	blurCol *= blurCol;
	float lum = dot(blurCol.xyz, float3(0.3, 0.58, 0.12));
	float knee = smoothstep(0.02, 0.5, lum);
	oColor.xyz = blurCol.xyz * lum * knee * BLOOM_GAIN + screenCol.xyz;
	oColor.w = 1;
}
