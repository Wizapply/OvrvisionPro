//plane.cpp

// Include DirectX
#include "Win32_DirectXAppUtil.h"

// Include the Oculus SDK
#include "OVR_CAPI_D3D.h"

//Shader
const char* g_planeShader =
	"	Texture2D g_texDecal : register(t0);//テクスチャー\n"
	"	SamplerState g_samLinear : register(s0);//サンプラー\n"
	"\n"
	"	struct VS_OUTPUT\n"
	"	{\n"
	"		float4 Pos : SV_POSITION;\n"
	"		float2 Tex : TEXCOORD;\n"
	"	};\n"
	"\n"
	"	VS_OUTPUT VS(float4 Pos : POSITION, float2 Tex : TEXCOORD)\n"
	"	{\n"
	"		VS_OUTPUT output = (VS_OUTPUT)0;\n"
	"		output.Pos = Pos;\n"
	"		output.Tex = Tex;\n"
	"\n"
	"		return output;\n"
	"	}\n"
	"\n"
	"	float4 PS(VS_OUTPUT input) : SV_Target\n"
	"	{\n"
	"		return g_texDecal.Sample(g_samLinear, input.Tex);\n"
	"	}\n"
;

//ベクタークラス
class VECTOR2
{
public:
	VECTOR2(float, float);
	float u;
	float v;
};
VECTOR2::VECTOR2(float a, float b)
{
	u = a; v = b;
}
class VECTOR3
{
public:
	VECTOR3(float, float, float);
	float x;
	float y;
	float z;
};
VECTOR3::VECTOR3(float a, float b, float c)
{
	x = a; y = b; z = c;
}

//頂点の構造体
struct SimpleVertex
{
	VECTOR3 Pos;  //位置
	VECTOR2 Uv; //UV座標
};

int InitializeCamPlane()
{
	//hlslファイル読み込み
	ID3DBlob *pCompiledShader = NULL;
	ID3DBlob *pErrors = NULL;

	/*
	//ブロブから頂点シェーダー作成
	if (D3DX11CompileFromFile(L"shader.hlsl", NULL, NULL, "VS", "vs_5_0", 0, 0, NULL, &pCompiledShader, &pErrors, NULL))
	{
		MessageBox(0, L"頂点シェーダー読み込み失敗", NULL, MB_OK);
		return E_FAIL;
	}
	Release(pErrors);

	if (FAILED(Device->CreateVertexShader(pCompiledShader->GetBufferPointer(), pCompiledShader->GetBufferSize(), NULL, &VertexShader)))
	{
		SAFE_RELEASE(pCompiledShader);
		MessageBox(0, L"頂点シェーダー作成失敗", NULL, MB_OK);
		return E_FAIL;
	}
	//頂点インプットレイアウトを定義 
	D3D11_INPUT_ELEMENT_DESC layout[] =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D11_INPUT_PER_VERTEX_DATA, 0 },
		{ "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT, 0, 12, D3D11_INPUT_PER_VERTEX_DATA, 0 },
	};
	UINT numElements = sizeof(layout) / sizeof(layout[0]);

	//頂点インプットレイアウトを作成
	if (FAILED(Device->CreateInputLayout(layout, numElements, pCompiledShader->GetBufferPointer(), pCompiledShader->GetBufferSize(), &VertexLayout)))
		return FALSE;
	//頂点インプットレイアウトをセット
	DeviceContext->IASetInputLayout(VertexLayout);

	//ブロブからピクセルシェーダー作成
	if (FAILED(D3DX11CompileFromFile(L"shader.hlsl", NULL, NULL, "PS", "ps_5_0", 0, 0, NULL, &pCompiledShader, &pErrors, NULL)))
	{
		MessageBox(0, L"ピクセルシェーダー読み込み失敗", NULL, MB_OK);
		return E_FAIL;
	}
	Release(pErrors);
	if (FAILED(Device->CreatePixelShader(pCompiledShader->GetBufferPointer(), pCompiledShader->GetBufferSize(), NULL, &PixelShader)))
	{
		SAFE_RELEASE(pCompiledShader);
		MessageBox(0, L"ピクセルシェーダー作成失敗", NULL, MB_OK);
		return E_FAIL;
	}
	Release(pCompiledShader);
	*/

	return 0;
}
