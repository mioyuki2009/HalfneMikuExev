#include <memory>
class MImGui;
class GraphImpl
{
	virtual void Init() = 0;
	virtual void Release() = 0;
	virtual bool Vaild() = 0;
	
public:
	static std::shared_ptr<GraphImpl>& Get();

public:
	virtual bool RegisterImGui(MImGui* pImGui) = 0;
};
