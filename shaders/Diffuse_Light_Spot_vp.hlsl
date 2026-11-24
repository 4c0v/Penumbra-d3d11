#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float4x4 spotViewProj;
float3 LightPos;
float4 LightColor;
float3 LightDirMul;

void main(float4 position : POSITION,
          float3 normal : NORMAL,
          float3 uv : TEXCOORD0,
          float4 tangent : TEXCOORD1,

          out float4 oPosition : SV_Position,
          out float4 oLightColor : COLOR0,
          out float3 oUv : TEXCOORD0,
          out float3 oLightDir : TEXCOORD1,
          out float4 oSpotlightUv : TEXCOORD2)
{
	oPosition = GLClip(mul(worldViewProj, position));
	oUv = uv;
	oSpotlightUv = mul(spotViewProj, position);
	float3 lightDir = (LightPos - position.xyz) * LightDirMul;
	float3 binormal = cross(normal, tangent.xyz) * tangent.w;
	float3x3 rotation = float3x3(tangent.xyz, binormal, normal);
	oLightDir = mul(rotation, lightDir);
	oLightColor = LightColor;
}
