#include "d3d11_common.hlsli"

float4x4 modelView;
float4x4 prevModelView;
float4x4 worldViewProj;
float4x4 prevWorldViewProj;
float blurScale;

void main(float4 position : POSITION,
          float3 normal : NORMAL,
          float3 color : COLOR0,

          out float4 oPosition : SV_Position,
          out float3 oColor : COLOR0,
          out float4 oVtxPos : TEXCOORD0,
          out float4 oPrevVtxPos : TEXCOORD1)
{
	float4 pos = mul(worldViewProj, position);
	float4 prevPos = mul(prevWorldViewProj, position);
	prevPos = lerp(pos, prevPos, blurScale);

	oPosition = GLClip(pos);
	oVtxPos = pos;
	oPrevVtxPos = prevPos;
	oColor = 0.5;
}
