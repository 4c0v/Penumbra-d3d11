#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float3 fogColor;
float fogStart;
float fogEnd;

void main(float4 position : POSITION,
          float3 color : COLOR0,

          out float4 oPosition : SV_Position,
          out float4 oColor : COLOR0,
          out float oUv : TEXCOORD0)
{
	float4 p = mul(worldViewProj, position);
	oUv = (fogEnd - p.z) / (fogEnd - fogStart);
	oColor.xyz = fogColor;
	oColor.w = 1;
	oPosition = GLClip(p);
}
