#include "d3d11_common.hlsli"

float4x4 worldViewProj;

void main(float4 position : POSITION,
          float3 color : COLOR0,
          float2 uv0 : TEXCOORD0,
          float2 uv1 : TEXCOORD1,

          out float4 oPosition : SV_Position,
          out float3 oColor : COLOR0,
          out float2 oUv0 : TEXCOORD0,
          out float2 oUv1 : TEXCOORD1)
{
	oPosition = GLClip(mul(worldViewProj, position));
	oColor = color;
	oUv0 = uv0;
	oUv1 = uv1;
}
