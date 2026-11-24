#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float yOffset;
float xOffset;
float amount;

void main(float4 position : POSITION,
          float3 color : COLOR0,
          float2 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float3 oColor : COLOR0,
          out float2 oUv0 : TEXCOORD0,
          out float2 oUv1 : TEXCOORD1,
          out float2 oUv2 : TEXCOORD2,
          out float2 oUv3 : TEXCOORD3)
{
	oPosition = GLClip(mul(worldViewProj, position));
	oColor = color;

	oUv0 = uv + float2(xOffset, yOffset) * amount;
	oUv1 = uv + float2(xOffset, yOffset) * 2 * amount;
	oUv2 = uv - float2(xOffset, yOffset) * amount;
	oUv3 = uv - float2(xOffset, yOffset) * 2 * amount;
}
