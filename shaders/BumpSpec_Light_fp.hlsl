#include "d3d11_common.hlsli"
#include "d3d11_ggx.hlsli"

SAMPLER2D(diffuseMap, 0);
SAMPLER2D(normalMap, 1);
SAMPLERCUBE(normalCubeMap, 2);
SAMPLER1D(falloffMap, 3);

void main(float4 pos : SV_Position,
          float4 lightColor : COLOR0,
          float2 uv : TEXCOORD0,
          float3 lightDir : TEXCOORD1,
          float3 halfVec : TEXCOORD2,

          out float4 oColor : SV_Target)
{
	float attenuation = TEX1D(falloffMap, dot(lightDir, lightDir)).x;
	float4 bumpVec = TEX2D(normalMap, uv);
	bumpVec.xyz = (2 * bumpVec.xyz) - 1;
	float3 lightNormal = normalize(lightDir);
	float3 halfNormal = normalize(halfVec);
	float specular = saturate(dot(halfNormal, bumpVec.xyz));
	specular = GGXSpec(bumpVec.xyz, lightNormal, halfNormal) * lightColor.w * saturate(bumpVec.w);
	oColor.xyz = TEX2D(diffuseMap, uv).xyz * lightColor.xyz * saturate(dot(lightNormal, bumpVec.xyz)) + specular;
	oColor.xyz *= attenuation;
	oColor.w = 0;
}
