#pragma once
#include "Assets/Texture2D.h"
#include "MDx12.h"
class MaterialTexture2D : public PrimitiveDX12
{
public:
	MaterialTexture2D();
	virtual ~MaterialTexture2D() {};

public:
	virtual void ProcessCommandList(ID3D12GraphicsCommandList* pCommandList, ID3D12Resource* pRenderTarget, ID3D12DescriptorHeap* pDescriptorHeap,
		unsigned int frameIndex, unsigned int rtvDescriptorSize) override final;

public:
	//static std::shared_ptr<MaterialTexture2D>& Get();
	ID3DBlob* vertexShader = nullptr;
	ID3DBlob* pixelShader = nullptr;
};


class Texture2DDx12 : public Texture2D
{
	Texture2DDx12(char* filename, int posX, int posY, float scale);



};