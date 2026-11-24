#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float3 LightPos;
float LightRadius;
float4 LightColor;

void main(float4 position : POSITION,
          float3 normal : NORMAL,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float4 oColor : COLOR0,
          out float3 oUv : TEXCOORD0,
          out float3 oLightDir : TEXCOORD1,
          out float2 oScreenPos : TEXCOORD2)
{
	float2 toLight = position.xy - LightPos.xy;
	oScreenPos = (toLight + LightRadius) / (LightRadius * 2);

	float3 lightDir;
	lightDir.x = normal.x * toLight.x + normal.y * toLight.y;
	lightDir.y = normal.x * toLight.y - normal.y * toLight.x;
	lightDir.x *= normal.z / abs(normal.z);
	lightDir.y *= abs(normal.z) - 2;
	lightDir.z = -LightPos.z;
	oLightDir = normalize(lightDir);

	oPosition = GLClip(mul(worldViewProj, position));
	oColor = LightColor;
	oUv = uv;
}
