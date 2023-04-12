#include <d3d12.h>
#include <dxgi1_4.h>
#include "Assets/GraphImpl.h"
struct FrameContext
{
    ID3D12CommandAllocator* CommandAllocator;
    UINT64                  FenceValue;
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
protected:
	virtual void Init(const HWND& hwnd) override final;
	virtual bool Vaild() override final;

	bool CreateDeviceD3D(const HWND& hwnd);
	void CleanupDeviceD3D();
	void CreateRenderTarget();
	void CleanupRenderTarget();
};