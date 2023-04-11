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
	MDx12();
public:
	virtual ~MDx12();

public:
	virtual bool RegisterImGui(MImGui* pImGui) override final;

protected:
	virtual void Init() override final;
	virtual void Release() override final;
	virtual bool Vaild() override final;

};