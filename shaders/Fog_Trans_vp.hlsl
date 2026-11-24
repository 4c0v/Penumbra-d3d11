#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float fogStart;
float fogEnd;

void main(float4 position : POSITION,
          float4 color : COLOR0,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float4 oColor : COLOR0,
          out float3 oUv : TEXCOORD0,
          out float oFogUv : TEXCOORD1)
{
	float4 p = mul(worldViewProj, position);
	oUv = uv;
	oFogUv = (fogEnd - p.z) / (fogEnd - fogStart);
	oColor = color;
	oPosition = GLClip(p);
}
