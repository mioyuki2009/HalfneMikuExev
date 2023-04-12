
#include <assert.h>
#ifdef USING_DX12
#include "graphicBackends/MDx12.h"
#endif
std::shared_ptr<GraphImpl> GGraphImpl = nullptr;

std::shared_ptr<GraphImpl>& GraphImpl::Get(HWND hwnd)
{
	assert(hwnd || GGraphImpl);
	if (!GGraphImpl)
	{
#ifdef USING_DX12
		GGraphImpl = std::shared_ptr<MDx12>(new MDx12(hwnd));
#endif
	}
	return GGraphImpl;
}