#include "d3d11_common.hlsli"

SAMPLERRECT(screenMap, 0);
SAMPLER2D(refractMap, 1);
SAMPLER2D(alphaMap, 2);

float2 screenSize;
float t;
float scale;

void main(float4 inPos : SV_Position,
          float4 color : COLOR0,
          float2 uv : TEXCOORD0,

          out float4 oColor : SV_Target)
{
	float2 wpos = GLWPos(inPos, screenSize.y);
	float alpha = TEX2D(alphaMap, uv).x;
	float2 uv2 = wpos / screenSize;
	uv2.x += sin(t + uv2.y * 10) * 0.001 * scale;
	uv2.y += sin(t + uv2.x * 10) * 0.001 * scale;
	float3 offset = ((TEX2D(refractMap, uv2).xyz * 2) - 1) * alpha * color.w;

	oColor.xyz = TEXRECT(screenMap, wpos - offset.xy * scale).xyz;
	oColor.w = 1;
}
