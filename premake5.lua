workspace "HalfneMikuExev"
   configurations { "Debug", "Release" }
   platforms {"Win64"}

project "HalfneMikuExev"
   kind "ConsoleApp"
   language "C++"
   targetdir "bin/%{cfg.buildcfg}"
   local SOURCEPATH = "source"
   local IMGUIPATH = "vendor/imgui"
   local WINDOWSBACKENDSPATH = IMGUIPATH.."/backends/imgui_impl_win32.*"
   local DX12BACKENDSPATH = IMGUIPATH.."/backends/imgui_impl_dx12.*"

   files { IMGUIPATH.."/imgui*.h", IMGUIPATH.."/imgui*.cpp", 
           WINDOWSBACKENDSPATH, DX12BACKENDSPATH ,SOURCEPATH.."/*",SOURCEPATH.."/*/*"}

   includedirs {SOURCEPATH, IMGUIPATH, IMGUIPATH.."/backends"}
   
   links {"d3d12", "dxgi"}

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"