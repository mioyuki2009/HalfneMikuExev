#pragma once
#include <memory>
#include <Windows.h>
#include "imgui.h"
#include "imgui_impl_win32.h"
class GraphImpl;
class MWindows;
class MImGui
{
	MImGui(const HWND& hwnd);
public:
	virtual ~MImGui();

public:
	static std::shared_ptr<MImGui>& Get(HWND hwnd = nullptr);
public:
	void StartNewFrame();
	void DrawDefaultLayout();
	void Render();

	const auto& GetClearColor() { return clear_color; };
	void Release();
protected:
	void Init(const HWND& hwnd);

private:
	ImVec4 clear_color = {0.45f, 0.55f, 0.60f, 1.00f};
};

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
