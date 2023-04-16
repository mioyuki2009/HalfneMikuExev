#pragma once
#include <vector>
#include <memory>
class Texture2D
{
protected:
	Texture2D(char* filename, int posX, int posY, float scale);
public:
	virtual ~Texture2D();
	virtual void Release() = 0;
private:
	float scale = 0;
	int height = 0;
	int width = 0;
	int posX = 0;
	int posY = 0;
};

class Texture2DManager
{
	Texture2DManager();
public:
	static bool CreateTexture2D(char* filename, int posX = 0, int posY = 0, float scale = 1.0f);
	void Release();
	void DeleteTexture(const std::shared_ptr<Texture2D>& texture, bool releaseMem = true);
	~Texture2DManager();
private:
	std::vector<std::shared_ptr<Texture2D>> Textures;
};