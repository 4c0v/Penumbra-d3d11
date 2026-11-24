#include "d3d11_common.hlsli"

float4x4 worldViewProj;

void main(float4 position : POSITION,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float3 oUv : TEXCOORD0)
{
	oPosition = GLClip(mul(worldViewProj, position));
	oUv = uv;
}
