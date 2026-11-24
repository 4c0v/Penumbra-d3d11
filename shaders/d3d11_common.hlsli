#ifndef HPL_D3D11_COMMON_HLSLI
#define HPL_D3D11_COMMON_HLSLI
#pragma pack_matrix(row_major)

#define SAMPLER2D(name, unit)   Texture2D   name : register(t##unit); SamplerState name##_ss : register(s##unit)
#define SAMPLER1D(name, unit)   Texture2D   name : register(t##unit); SamplerState name##_ss : register(s##unit)
#define SAMPLERCUBE(name, unit) TextureCube name : register(t##unit); SamplerState name##_ss : register(s##unit)

#define SAMPLERRECT(name, unit) Texture2D   name : register(t##unit); SamplerState name##_ss : register(s##unit)
float4 SampleRect(Texture2D t, SamplerState s, float2 pixel)
{
	uint w, h;
	t.GetDimensions(w, h);
	return t.SampleLevel(s, pixel / float2(w, h), 0);
}
#define TEXRECT(name, pixel)  SampleRect(name, name##_ss, pixel)

float2 GLWPos(float4 svPos, float screenHeight)
{
	return float2(svPos.x, screenHeight - svPos.y);
}

#define TEX2D(name, uv)       name.Sample(name##_ss, uv)
#define TEX1D(name, u)        name.Sample(name##_ss, float2(u, 0.5))
#define TEXCUBE(name, dir)    name.Sample(name##_ss, dir)
#define TEX2DPROJ(name, uvw)  name.Sample(name##_ss, (uvw).xy / (uvw).z)

float4 GLClip(float4 p)
{
	p.z = 0.5 * (p.z + p.w);
	return p;
}

#endif
