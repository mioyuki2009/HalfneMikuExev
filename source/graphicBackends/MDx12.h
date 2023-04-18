#pragma once
#include <d3d12.h>
#include <dxgi1_4.h>
#include "Assets/GraphImpl.h"
#include <vector>
struct FrameContext
{
    ID3D12CommandAllocator* CommandAllocator;
    UINT64                  FenceValue;
};

class PrimitiveDX12
{
public:
	virtual void ProcessCommandList(ID3D12GraphicsCommandList* pCommandList, ID3D12Resource* pRenderTarget, ID3D12DescriptorHeap* pDescriptorHeap,
		unsigned int frameIndex, unsigned int rtvDescriptorSize) = 0;
};

class MDx12 : public GraphImpl
{
	friend class GraphImpl;
	MDx12(const HWND& hwnd);
public:
	virtual ~MDx12();

public:
	virtual bool RegisterImGui(MImGui* pImGui) override final;
	virtual void StartNewFrame(MImGui* pImGui) override final;
	virtual void RenderImGui(MImGui* pImGui) override final;
	virtual void UnRegisterImGui(MImGui* pImGui) override final;
	virtual void Release() override final;
	virtual void Resize(int width, int height) override final;
public:
	ID3D12Device* GetDevice();
	ID3D12CommandQueue* GetCommandQueue();
	ID3D12GraphicsCommandList* GetCommandList();
	static FrameContext* WaitForNextFrameResources();
	static void WaitForLastSubmittedFrame();
	void Register(PrimitiveDX12* primitive) { Primitives.push_back(primitive); }
protected:
	virtual void Init(const HWND& hwnd) override final;
	virtual bool Vaild() override final;
	virtual void Render() override final;

	void ProcessCommandList();

	bool CreateDeviceD3D(const HWND& hwnd);
	void CleanupDeviceD3D();
	void CreateRenderTarget();
	void CleanupRenderTarget();

private:
	std::vector<PrimitiveDX12*> Primitives;
};

