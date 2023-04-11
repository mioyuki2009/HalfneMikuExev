
#ifdef USING_DX12
#include "graphicBackends/MDx12.h"
#endif
std::shared_ptr<GraphImpl> GGraphImpl = nullptr;

std::shared_ptr<GraphImpl>& GraphImpl::Get()
{
	if (!GGraphImpl)
	{
#ifdef USING_DX12
		GGraphImpl = std::make_shared<MDx12>();
#endif
	}
	return GGraphImpl;
}