#include "d3d11_common.hlsli"

SAMPLERRECT(screenMap, 0);
SAMPLER2D(refractMap, 1);

float2 screenSize;
float scale;

void main(float4 inPos : SV_Position,
          float4 color : COLOR0,
          float2 uv : TEXCOORD0,

          out float4 oColor : SV_Target)
{
	float2 wpos = GLWPos(inPos, screenSize.y);
	float3 offset = ((TEX2D(refractMap, uv).xyz * 2) - 1) * color.w;

	oColor = TEXRECT(screenMap, wpos - (offset.xy * scale) / inPos.z);
}
