#include "MWindow.h"
#include "Layout/MImGui.h"
#include "Assets/GraphImpl.h"

std::shared_ptr<MWindows> GWindow = nullptr;

void MWindows::Show()
{
    // Show the window
    ::ShowWindow(hwnd, SW_SHOWDEFAULT);
    ::UpdateWindow(hwnd);
}

bool MWindows::Run()
{
    const auto& ImGui = MImGui::Get();
    bool done = false;
    while (!done)
    {
        // Poll and handle messages (inputs, window resize, etc.)
        // See the WndProc() function below for our to dispatch events to the Win32 backend.
        MSG msg;
        while (::PeekMessage(&msg, NULL, 0U, 0U, PM_REMOVE))
        {
            ::TranslateMessage(&msg);
            ::DispatchMessage(&msg);
            if (msg.message == WM_QUIT)
                done = true;
        }
        if (done)
            break;

        // Start the Dear ImGui frame
        ImGui->StartNewFrame();

        ImGui->DrawDefaultLayout();

        ImGui->Render();
    }

    return true;
}

MWindows::MWindows()
{
    memset(&wc, 0, sizeof(WNDCLASSEXW));
    Init();
}

MWindows::~MWindows()
{
    //Release();
}

void MWindows::Init()
{
    wc = { sizeof(wc), CS_CLASSDC, WndProc, 0L, 0L, GetModuleHandle(NULL), NULL, NULL, NULL, NULL, L"ImGui Example", NULL };
    ::RegisterClassExW(&wc);
    hwnd = ::CreateWindowW(wc.lpszClassName, L"Dear ImGui DirectX12 Example", WS_OVERLAPPEDWINDOW, 100, 100, 1280, 800, NULL, NULL, wc.hInstance, NULL);
    
    GraphImpl::Get(hwnd);
    MImGui::Get(hwnd);
}

void MWindows::Release()
{
    GraphImpl::Get()->Release();
    MImGui::Get()->Release();
    if (hwnd)
    {
        ::DestroyWindow(hwnd);
    }
    ::UnregisterClassW(wc.lpszClassName, wc.hInstance);
}

std::shared_ptr<MWindows>& MWindows::Get()
{
	if (!GWindow) {
		GWindow = std::shared_ptr<MWindows>(new MWindows());
	}
	return GWindow;
}

LRESULT WINAPI MWindows::WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    if (ImGui_ImplWin32_WndProcHandler(hWnd, msg, wParam, lParam))
        return true;

    switch (msg)
    {
    case WM_SIZE:
        if (wParam != SIZE_MINIMIZED)
        {
            GraphImpl::Get()->Resize((int)LOWORD(lParam), (int)HIWORD(lParam));
        }
        return 0;
    case WM_SYSCOMMAND:
        if ((wParam & 0xfff0) == SC_KEYMENU) // Disable ALT application menu
            return 0;
        break;
    case WM_DESTROY:
        ::PostQuitMessage(0);
        return 0;
    }
    return ::DefWindowProcW(hWnd, msg, wParam, lParam);
}