#pragma once
#include <memory>

class MImGui
{
	MImGui();
public:
	virtual ~MImGui();

public:
	static std::shared_ptr<MImGui>& Get();

protected:
	void Init();
	void Release();

private:
};