#include "Windows/MWindow.h"
// Main code
int main()
{
    const auto& Window = MWindows::Get();
    Window->Show();

    Window->Run();
    
    Window->Release();
    return 0;
}