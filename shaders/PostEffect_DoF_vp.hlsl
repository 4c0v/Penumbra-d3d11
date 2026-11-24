#include "d3d11_common.hlsli"

float4x4 worldViewProj;

void main(float4 position : POSITION,

          out float4 oPosition : SV_Position,
          out float oDepth : TEXCOORD0)
{
	float4 p = mul(worldViewProj, position);
	oDepth = p.z;
	oPosition = GLClip(p);
}
