#include "MDx12.h"
#include "imgui_impl_dx12.h"
// Data
int const                    NUM_FRAMES_IN_FLIGHT = 3;
FrameContext                 g_frameContext[NUM_FRAMES_IN_FLIGHT] = {};
UINT                         g_frameIndex = 0;

int const                    NUM_BACK_BUFFERS = 3;
ID3D12Device* g_pd3dDevice = NULL;
ID3D12DescriptorHeap* g_pd3dRtvDescHeap = NULL;
ID3D12DescriptorHeap* g_pd3dSrvDescHeap = NULL;
ID3D12CommandQueue* g_pd3dCommandQueue = NULL;
ID3D12GraphicsCommandList* g_pd3dCommandList = NULL;
ID3D12Fence* g_fence = NULL;
HANDLE                       g_fenceEvent = NULL;
UINT64                       g_fenceLastSignaledValue = 0;
IDXGISwapChain3* g_pSwapChain = NULL;
HANDLE                       g_hSwapChainWaitableObject = NULL;
ID3D12Resource* g_mainRenderTargetResource[NUM_BACK_BUFFERS] = {};
D3D12_CPU_DESCRIPTOR_HANDLE  g_mainRenderTargetDescriptor[NUM_BACK_BUFFERS] = {};

MDx12::MDx12()
{

}

MDx12::~MDx12()
{

}

void MDx12::Init()
{

}

void MDx12::Release()
{
	
}
bool MDx12::Vaild()
{
	return g_pd3dDevice && g_pd3dSrvDescHeap;
}

bool MDx12::RegisterImGui(MImGui* pImGui)
{
	assert(Vaild());
	ImGui_ImplDX12_Init(g_pd3dDevice, NUM_FRAMES_IN_FLIGHT,
		DXGI_FORMAT_R8G8B8A8_UNORM, g_pd3dSrvDescHeap,
		g_pd3dSrvDescHeap->GetCPUDescriptorHandleForHeapStart(),
		g_pd3dSrvDescHeap->GetGPUDescriptorHandleForHeapStart());
	return true;
}