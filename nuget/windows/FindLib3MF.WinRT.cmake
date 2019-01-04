cmake_minimum_required(VERSION 3.9)

# Try to determine whether we should include the ARM, x64, or x86 versions of the libraries
# There is no good way (yet?) to generically determine the architecture of a build
# The caller must specify the architecture as a component of the package
# Examples:
#
# find_package(Lib3MF.WinRT COMPONENTS ARM) will find the ARM(32) libraries.
# find_package(Lib3MF.WinRT COMPONENTS x64) will find the x64 libraries.
# find_package(Lib3MF.WinRT) will find the x86 (aka Win32) libraries.

if ("ARM" IN_LIST Lib3MF.WinRT_FIND_COMPONENTS)
    set(LIB3MF_WINRT_ARCHITECTURE "ARM")
elseif ("ARM64" IN_LIST Lib3MF.WinRT_FIND_COMPONENTS)
    set(LIB3MF_WINRT_ARCHITECTURE "ARM64")
elseif("x64" IN_LIST Lib3MF.WinRT_FIND_COMPONENTS)
    set(LIB3MF_WINRT_ARCHITECTURE "x64")
else()
    set(LIB3MF_WINRT_ARCHITECTURE "Win32")
endif()

if (NOT Lib3MF_WINRT_FOUND)
    set(Lib3MF_WINRT_FOUND TRUE)
    add_library(Lib3MF STATIC IMPORTED GLOBAL)
    set_target_properties(Lib3MF PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/build/native/include")
    set_target_properties(Lib3MF PROPERTIES IMPORTED_LOCATION_DEBUG "${CMAKE_CURRENT_LIST_DIR}/build/uap10.0/lib/${LIB3MF_WINRT_ARCHITECTURE}/Debug/lib3MF_s.lib")
    set_target_properties(Lib3MF PROPERTIES IMPORTED_LOCATION_RELEASE "${CMAKE_CURRENT_LIST_DIR}/build/uap10.0/lib/${LIB3MF_WINRT_ARCHITECTURE}/Release/lib3MF_s.lib")
    set_target_properties(Lib3MF PROPERTIES IMPORTED_LOCATION_RELWITHDEBINFO "${CMAKE_CURRENT_LIST_DIR}/build/uap10.0/lib/${LIB3MF_WINRT_ARCHITECTURE}/Release/lib3MF_s.lib")
    set_target_properties(Lib3MF PROPERTIES IMPORTED_LOCATION_MINSIZEREL "${CMAKE_CURRENT_LIST_DIR}/build/uap10.0/lib/${LIB3MF_WINRT_ARCHITECTURE}/Release/lib3MF_s.lib")
    set_target_properties(Lib3MF PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/build/uap10.0/lib/${LIB3MF_WINRT_ARCHITECTURE}/Debug/lib3MF_s.lib")
endif()