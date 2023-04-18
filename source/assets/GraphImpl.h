#pragma once
#include <memory>
#include <Windows.h>
class MImGui;
class GraphImpl
{
	virtual void Init(const HWND& hwnd) = 0;
	virtual bool Vaild() = 0;
	
public:
	static std::shared_ptr<GraphImpl>& Get(HWND hwnd = nullptr);

public:
	virtual bool RegisterImGui(MImGui* pImGui) = 0;
	virtual void UnRegisterImGui(MImGui* pImGui) = 0;
	virtual void StartNewFrame(MImGui* pImGui) = 0;
	virtual void RenderImGui(MImGui* pImGui) = 0;
	virtual void Release() = 0;
	virtual void Render() = 0;
public:
	virtual void Resize(int width, int height) = 0;

};
