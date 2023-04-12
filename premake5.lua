local function has_value (tab, val)
   for index, value in pairs(tab) do
         if value == val then
            return true
         end
   end
   return false
end

workspace "HalfneMikuExev"
   configurations { "Debug", "Release" }
   platforms {"Win64"}

project "HalfneMikuExev"
   kind "ConsoleApp"
   language "C++"
   targetdir "bin/%{cfg.buildcfg}"
   local GRAPHBACKENDARRAY = { dx11 = 0, dx12 = 0 }
   local GRAPHBACKEND = GRAPHBACKENDARRAY.dx11;
   local SOURCEPATH = "source"
   local IMGUIPATH = "vendor/imgui"
   local NANOSVGPATH = "vendor/nanosvg/src"
   local WINDOWSBACKENDSPATH = ""
   local GRAPHBACKENDSPATH = ""
   if has_value(_ARGS, "-dx12")
   then  
      GRAPHBACKEND = GRAPHBACKENDARRAY.dx12
   end
   if GRAPHBACKEND == GRAPHBACKENDARRAY.dx12
   then
      WINDOWSBACKENDSPATH = IMGUIPATH.."/backends/imgui_impl_win32.*"
      GRAPHBACKENDSPATH = IMGUIPATH.."/backends/imgui_impl_dx12.*"
      links {"d3d12", "dxgi"}
      defines { "USING_DX12" }
   end
   files { IMGUIPATH.."/imgui*.h", IMGUIPATH.."/imgui*.cpp", 
           WINDOWSBACKENDSPATH, GRAPHBACKENDSPATH ,
           NANOSVGPATH.."nanosvg.h",
           SOURCEPATH.."/*",SOURCEPATH.."/*/*"}


   includedirs {SOURCEPATH, IMGUIPATH, IMGUIPATH.."/backends", NANOSVGPATH}
   
   

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"


