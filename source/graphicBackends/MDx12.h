#include <d3d12.h>
#include <dxgi1_4.h>
#include "assets/GraphImpl.h"
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


};