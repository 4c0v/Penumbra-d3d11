#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float4x4 objectWorldMatrix;
float3 eyeWorldPos;

void main(float4 position : POSITION,
          float3 normal : NORMAL,
          float3 color : COLOR0,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float3 oColor : COLOR0,
          out float3 oUv : TEXCOORD0,
          out float3 oUv2 : TEXCOORD1)
{
	oPosition = GLClip(mul(worldViewProj, position));
	oColor = color;
	float3x3 rotation = (float3x3)objectWorldMatrix;
	float3 worldPos = mul(objectWorldMatrix, position).xyz;
	float3 worldNormal = mul(rotation, normal);
	float3 eyeDir = worldPos - eyeWorldPos;

	oUv = uv;
	oUv2 = reflect(eyeDir, worldNormal);
}
