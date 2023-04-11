#include "MImGui.h"
#include "imgui.h"
#include "imgui_impl_win32.h"

#include "GraphicBackends/MDx12.h"
#include "Windows/MWindow.h"

#include "assert.h"
std::shared_ptr<MImGui> GImGui = nullptr;

MImGui::MImGui()
{
    Init();
}

MImGui::~MImGui()
{
    Release();
}

void MImGui::Init()
{
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();

    ImGuiIO& io = ImGui::GetIO(); (void)io;
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;     // Enable Keyboard Controls
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad;      // Enable Gamepad Controls
    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;         // Enable Docking
    io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;       // Enable Multi-Viewport / Platform Windows
    //io.ConfigViewportsNoAutoMerge = true;
    //io.ConfigViewportsNoTaskBarIcon = true;

    // Setup Dear ImGui style
    ImGui::StyleColorsDark();
    //ImGui::StyleColorsLight();

    // When viewports are enabled we tweak WindowRounding/WindowBg so platform windows can look identical to regular ones.
    ImGuiStyle& style = ImGui::GetStyle();
    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable)
    {
        style.WindowRounding = 0.0f;
        style.Colors[ImGuiCol_WindowBg].w = 1.0f;
    }

    auto& Window = MWindows::Get();
    assert(Window);
    auto& Hwnd = Window->GetHwnd();
    assert(Hwnd);
    // Setup Platform/Renderer backends
    ImGui_ImplWin32_Init(Hwnd);

    auto& GraphImpl = GraphImpl::Get();
    GraphImpl->RegisterImGui(this);
}

void MImGui::Release()
{
}

std::shared_ptr<MImGui>& MImGui::Get()
{
    if (!GImGui) {
        GImGui = std::make_shared<MImGui>();
    }
    return GImGui;
}
