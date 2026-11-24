#include "d3d11_common.hlsli"

SAMPLER1D(diffuseMap, 0);

void main(float4 pos : SV_Position,
          float4 color : COLOR0,
          float uv : TEXCOORD0,

          out float4 oColor : SV_Target)
{
	oColor = TEX1D(diffuseMap, uv) * color;
}
