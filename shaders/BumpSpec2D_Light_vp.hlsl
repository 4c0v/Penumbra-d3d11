#include "d3d11_common.hlsli"

float4x4 worldViewProj;
float3 LightPos;
float3 EyePos;
float LightRadius;
float4 LightColor;

void main(float4 position : POSITION,
          float3 normal : NORMAL,
          float3 uv : TEXCOORD0,

          out float4 oPosition : SV_Position,
          out float4 oColor : COLOR0,
          out float3 oUv : TEXCOORD0,
          out float3 oLightDir : TEXCOORD1,
          out float3 oHalfVec : TEXCOORD2,
          out float2 oScreenPos : TEXCOORD3)
{
	float2 toLight = position.xy - LightPos.xy;
	oScreenPos = (toLight + LightRadius) / (LightRadius * 2);

	float3 lightDir;
	lightDir.x = normal.x * toLight.x + normal.y * toLight.y;
	lightDir.y = normal.x * toLight.y - normal.y * toLight.x;
	lightDir.x *= normal.z / abs(normal.z);
	lightDir.y *= abs(normal.z) - 2;
	lightDir.z = -LightPos.z;
	lightDir = normalize(lightDir);
	oLightDir = lightDir;

	float2 toEye = position.xy - EyePos.xy;
	float3 halfVec;
	halfVec.x = normal.x * toEye.x + normal.y * toEye.y;
	halfVec.y = normal.x * toEye.y - normal.y * toEye.x;
	halfVec.x *= normal.z / abs(normal.z);
	halfVec.y *= abs(normal.z) - 2;
	halfVec.z = -EyePos.y;
	halfVec = normalize(halfVec);
	oHalfVec = normalize(halfVec + lightDir);

	oPosition = GLClip(mul(worldViewProj, position));
	oColor = LightColor;
	oUv = uv;
}
