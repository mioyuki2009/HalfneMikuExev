#pragma once
#include "Assets/Texture2D.h"
#include "MDx12.h"
class MaterialTexture2D
{
	MaterialTexture2D();
public:
	virtual ~MaterialTexture2D();

public:
	static std::shared_ptr<MaterialTexture2D>& Get();
	ID3DBlob* vertexShader = nullptr;
	ID3DBlob* pixelShader = nullptr;
};


class Texture2DDx12 : public Texture2D
{
	Texture2DDx12(char* filename, int posX, int posY, float scale);



};