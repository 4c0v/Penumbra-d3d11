#include "d3d11_common.hlsli"

SAMPLER2D(diffuseMap, 0);
SAMPLER2D(normalMap, 1);
SAMPLERCUBE(normalCubeMap, 2);
SAMPLER1D(falloffMap, 3);

void main(float4 pos : SV_Position,
          float4 lightColor : COLOR0,
          float2 uv : TEXCOORD0,
          float3 lightDir : TEXCOORD1,

          out float4 oColor : SV_Target)
{
	float attenuation = TEX1D(falloffMap, dot(lightDir, lightDir)).x;
	float3 bumpVec = (2 * TEX2D(normalMap, uv) - 1).xyz;
	float3 lightVec = normalize(lightDir);
	oColor.xyz = TEX2D(diffuseMap, uv).xyz * lightColor.xyz * attenuation * saturate(dot(lightVec, bumpVec));
	oColor.w = 0;
}
