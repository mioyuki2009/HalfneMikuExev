#pragma once
#include <memory>
#include <windows.h>

class MWindows
{
	MWindows();
public:
	virtual ~MWindows();

	static LRESULT WINAPI WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
	static std::shared_ptr<MWindows>& Get();

public:
	void Show();
	const HWND& GetHwnd() { return hwnd; }
	bool Run();
	void Release();
protected:
	void Init();
private:
	WNDCLASSEXW wc;
	HWND hwnd = nullptr;
};