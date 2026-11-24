#include "d3d11_common.hlsli"

SAMPLERRECT(screenTex, 0);
float2 halfScreenSize;

void main(float4 inPos : SV_Position,
          float3 inColor : COLOR0,
          float4 inVtxPos : TEXCOORD0,
          float4 inPrevVtxPos : TEXCOORD1,

          out float4 oColor : SV_Target)
{
	float2 wpos = GLWPos(inPos, halfScreenSize.y * 2);
	float2 p1 = inVtxPos.xy / inVtxPos.w;
	float2 p2 = inPrevVtxPos.xy / inPrevVtxPos.w;
	float2 velocity = (p2 - p1) * halfScreenSize;
	const float samples = min(max(1, ceil(max(abs(velocity.x), abs(velocity.y)) / 2)), 16);
	const float w = 1.0 / samples;
	const float2 s = velocity / samples;
	float4 a = 0;

	[loop] for(float i = 0; i < samples; i += 1)
	{
		a += TEXRECT(screenTex, wpos) * w;
		wpos += s;
	}

	oColor = a;
}
