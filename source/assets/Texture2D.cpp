#include "Texture2D.h"
#include "assert.h"


bool Texture2DManager::CreateTexture2D(char* filename, int posX, int posY, float scale)
{
	
}

void Texture2DManager::DeleteTexture(const std::shared_ptr<Texture2D>& texture, bool releaseMem)
{
	if (releaseMem)
	{
		texture->Release();
	}
	Textures.erase(std::find(Textures.begin(), Textures.end(), texture));
}

void Texture2DManager::Release()
{
	for (const auto& texture : Textures)
	{
		texture->Release();
	}
	Textures.clear();
}

Texture2DManager::~Texture2DManager()
{
	assert(Textures.size() == 0);
	Release();
}