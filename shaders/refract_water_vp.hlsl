#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float3 EyePos;

void main(float4 position : POSITION,
          float4 color : COLOR0,
          float2 uv : TEXCOORD0,
          float3 normal : NORMAL,

          out float4 oPosition : SV_Position,
          out float4 oColor : COLOR0,
          out float2 oUv : TEXCOORD0,
          out float3 oNormal : TEXCOORD1,
          out float3 oEyePos : TEXCOORD2)
{
	oPosition = GLClip(mul(worldViewProj, position));
	oColor = color;
	oUv = uv;
	oNormal = normal;
	oEyePos = normalize(EyePos - position.xyz);
}
