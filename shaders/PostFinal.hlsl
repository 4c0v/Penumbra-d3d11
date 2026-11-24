#define USE_FXAA        1
#define USE_SHARPEN     1
#define USE_GRADE       1
#define USE_VIGNETTE    1
#define USE_DITHER      1

static const float SHARPEN_AMT    = 0.45;
static const float GRADE_STRENGTH = 0.55;
static const float SATURATION     = 1.06;
static const float VIGNETTE_AMT   = 0.28;
static const float VIGNETTE_SOFT  = 0.75;

cbuffer G : register(b0) { float4 gInvGamma; };
Texture2D gTex : register(t0);
SamplerState gSmp : register(s0);

struct VSOut { float4 pos : SV_Position; float2 uv : TEXCOORD0; };

VSOut VSMain(uint id : SV_VertexID)
{
	VSOut o;
	float2 t = float2((id << 1) & 2, id & 2);
	o.uv = t;
	o.pos = float4(t * float2(2, -2) + float2(-1, 1), 0, 1);
	return o;
}

float Luma(float3 c) { return dot(c, float3(0.299, 0.587, 0.114)); }
static const float SHOULDER_START = 0.75;
float3 Shoulder(float3 c)
{
	float3 over = max(c - SHOULDER_START, 0.0);
	float w = 1.0 - SHOULDER_START;
	return min(c, SHOULDER_START) + w * (1.0 - exp(-over / w));
}
float3 S(float2 uv) { return Shoulder(max(gTex.SampleLevel(gSmp, uv, 0).rgb, 0.0)); }
float3 FXAA(float2 uv, float2 px)
{
	float3 rgbNW = S(uv + float2(-1, -1) * px);
	float3 rgbNE = S(uv + float2( 1, -1) * px);
	float3 rgbSW = S(uv + float2(-1,  1) * px);
	float3 rgbSE = S(uv + float2( 1,  1) * px);
	float3 rgbM  = S(uv);
	float lNW = Luma(rgbNW), lNE = Luma(rgbNE), lSW = Luma(rgbSW), lSE = Luma(rgbSE), lM = Luma(rgbM);
	float lMin = min(lM, min(min(lNW, lNE), min(lSW, lSE)));
	float lMax = max(lM, max(max(lNW, lNE), max(lSW, lSE)));

	float2 dir;
	dir.x = -((lNW + lNE) - (lSW + lSE));
	dir.y =  ((lNW + lSW) - (lNE + lSE));
	float dirReduce = max((lNW + lNE + lSW + lSE) * (0.25 * (1.0 / 8.0)), 1.0 / 128.0);
	float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
	dir = clamp(dir * rcpDirMin, -8.0, 8.0) * px;

	float3 rgbA = 0.5 * (S(uv + dir * (1.0 / 3.0 - 0.5)) + S(uv + dir * (2.0 / 3.0 - 0.5)));
	float3 rgbB = rgbA * 0.5 + 0.25 * (S(uv + dir * -0.5) + S(uv + dir * 0.5));
	float lB = Luma(rgbB);
	return (lB < lMin || lB > lMax) ? rgbA : rgbB;
}

float Hash(float2 p)
{
	return frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

float4 PSMain(VSOut i) : SV_Target
{
	uint w, h;
	gTex.GetDimensions(w, h);
	float2 px = 1.0 / float2(w, h);

#if USE_FXAA
	float3 c = FXAA(i.uv, px);
#else
	float3 c = S(i.uv);
#endif
	c = saturate(c);

#if USE_SHARPEN
	{
		float3 n0 = S(i.uv + float2(0, -1) * px);
		float3 n1 = S(i.uv + float2(0,  1) * px);
		float3 n2 = S(i.uv + float2(-1, 0) * px);
		float3 n3 = S(i.uv + float2( 1, 0) * px);
		float3 mn = min(c, min(min(n0, n1), min(n2, n3)));
		float3 mx = max(c, max(max(n0, n1), max(n2, n3)));
		float3 avg = (n0 + n1 + n2 + n3) * 0.25;
		c = clamp(c + (c - avg) * SHARPEN_AMT * 2.0, mn, mx);
	}
#endif

#if USE_GRADE
	float3 x = c * 1.15;
	float3 f = ((x * (0.22 * x + 0.03) + 0.002) / (x * (0.22 * x + 0.30) + 0.06)) - 0.033;
	f /= 0.8;
	c = lerp(c, saturate(f), GRADE_STRENGTH);
	float l = Luma(c);
	c = lerp(float3(l, l, l), c, SATURATION);
#endif

#if USE_VIGNETTE
	float2 d = i.uv - 0.5;
	float r = length(d) * 1.4142;
	c *= 1.0 - VIGNETTE_AMT * smoothstep(VIGNETTE_SOFT * 0.5, 1.0, r);
#endif

	c = pow(saturate(c), gInvGamma.x);

#if USE_DITHER
	c += (Hash(i.pos.xy) + Hash(i.pos.xy + 17.0) - 1.0) / 255.0;
#endif
	return float4(saturate(c), 1);
}
