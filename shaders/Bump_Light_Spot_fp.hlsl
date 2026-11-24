#include "d3d11_common.hlsli"

SAMPLER2D(diffuseMap, 0);
SAMPLER2D(normalMap, 1);
SAMPLERCUBE(normalCubeMap, 2);
SAMPLER1D(falloffMap, 3);
SAMPLER2D(spotlightMap, 4);
SAMPLER1D(spotNegRejectMap, 5);

void main(float4 pos : SV_Position,
          float4 lightColor : COLOR0,
          float2 uv : TEXCOORD0,
          float3 lightDir : TEXCOORD1,
          float3 spotlightUv : TEXCOORD2,

          out float4 oColor : SV_Target)
{
	float3 diffuse = TEX2D(diffuseMap, uv).xyz;
	float3 bumpVec = (2 * TEX2D(normalMap, uv) - 1).xyz;
	float3 lightVec = normalize(lightDir);
	float attenuation = TEX1D(falloffMap, dot(lightDir, lightDir)).x;
	float3 spotColor = TEX2DPROJ(spotlightMap, spotlightUv).xyz;
	float rejectNeg = TEX1D(spotNegRejectMap, spotlightUv.z + 0.5).x;
	oColor.xyz = diffuse * saturate(dot(lightVec, bumpVec)) * attenuation * lightColor.xyz * spotColor * rejectNeg;
	oColor.w = 0;
}
