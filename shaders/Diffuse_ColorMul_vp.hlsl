#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float4 colorMul;

void main(float4 position : POSITION,
          float3 color : COLOR0,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float3 oColor : COLOR0,
          out float3 oUv : TEXCOORD0)
{
	oPosition = GLClip(mul(worldViewProj, position));
	oColor = color * colorMul.xyz;
	oUv = uv;
}
