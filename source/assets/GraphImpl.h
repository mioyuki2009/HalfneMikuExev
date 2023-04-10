#include <memory>

class GraphImpl
{
	virtual void Init() = 0;
	virtual void Release() = 0;
	static std::shared_ptr<GraphImpl> Get();
};