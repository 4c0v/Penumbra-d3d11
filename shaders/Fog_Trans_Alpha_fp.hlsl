#include "d3d11_common.hlsli"

SAMPLER2D(diffuseMap, 0);
SAMPLER1D(fogMap, 1);

void main(float4 pos : SV_Position,
          float4 color : COLOR0,
          float2 uv : TEXCOORD0,
          float fogUv : TEXCOORD1,

          out float4 oColor : SV_Target)
{
	oColor = TEX2D(diffuseMap, uv) * TEX1D(fogMap, fogUv) * color;
}
