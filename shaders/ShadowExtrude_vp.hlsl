#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float3 lightPosition;

void main(float4 position : POSITION,

          out float4 oPosition : SV_Position)
{
	position.xyz -= lightPosition * (1 - position.w);
	oPosition = GLClip(mul(worldViewProj, position));
}
