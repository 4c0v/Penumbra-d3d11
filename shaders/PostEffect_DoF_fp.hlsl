#include "d3d11_common.hlsli"

SAMPLERRECT(screenMap, 0);
SAMPLER2D(blurMap, 1);

float3 planes;
float maxBlur;
float2 screenSize;

void main(float4 inPos : SV_Position,
          float inDepth : TEXCOORD0,

          out float4 oColor : SV_Target)
{
	float2 wpos = GLWPos(inPos, screenSize.y);
	float blur = 0;

	if(inDepth < planes.y)
	{
		blur = (planes.y - inDepth) / (planes.y - planes.x);
	}
	else
	{
		blur = (inDepth - planes.y) / (planes.z - planes.y);
	}

	blur = clamp(blur, 0, maxBlur);

	oColor = TEXRECT(screenMap, wpos) * (1 - blur) + TEX2D(blurMap, wpos / screenSize) * blur;
}
