# 20141230 - Create a github repo...
# 20140425 - pause_for root CMakeLists.txt
cmake_minimum_required( VERSION 2.6 )

project( pause_for )

string(COMPARE EQUAL ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} INSOURCE_BUILD)
if (INSOURCE_BUILD)
    message(FATAL_ERROR "\nIt is NOT recomended you build in the source folder!\n"
        "It is better to change to the 'build' directory!")
endif ()
# The version number.
set( pf_MAJOR 1 )
set( pf_MINOR 0 )
set( pf_POINT 3 )

# to distinguish between debug and release lib
if (MSVC)
    set( CMAKE_DEBUG_POSTFIX "d" )
endif ()    

# pass the version and date into application
add_definitions( -DVERSION="${pf_MAJOR}.${pf_MINOR}.${pf_POINT}" )
add_definitions( -DVER_DATE="21041220" )

if(CMAKE_COMPILER_IS_GNUCXX)
    set( WARNING_FLAGS -Wall )
endif(CMAKE_COMPILER_IS_GNUCXX)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang") 
   set( WARNING_FLAGS "-Wall -Wno-overloaded-virtual" )
endif() 

if(WIN32 AND MSVC)
    # turn off various warnings
    set(WARNING_FLAGS "${WARNING_FLAGS} /wd4996")
    # foreach(warning 4244 4251 4267 4275 4290 4786 4305)
    #     set(WARNING_FLAGS "${WARNING_FLAGS} /wd${warning}")
    # endforeach(warning)
    # opts -DNOMINMAX -D_USE_MATH_DEFINES -D_SCL_SECURE_NO_WARNINGS -D__CRT_NONSTDC_NO_WARNINGS
    set( MSVC_FLAGS "-D_CRT_SECURE_NO_WARNINGS " )
    #------------------------------------------------------------------------
    # Static Windows Runtime
    #   Option to statically link to the Windows runtime. Maybe only 
    #   applies to WIN32/MSVC.
    #------------------------------------------------------------------------
    option( USE_STATIC_RUNTIME "Set ON to change /MD(DLL) to /MT(static)" ON )
    if (USE_STATIC_RUNTIME)
        set(CompilerFlags
            CMAKE_CXX_FLAGS
            CMAKE_CXX_FLAGS_DEBUG
            CMAKE_CXX_FLAGS_RELEASE
            CMAKE_C_FLAGS
            CMAKE_C_FLAGS_DEBUG
            CMAKE_C_FLAGS_RELEASE
            )
        foreach(CompilerFlag ${CompilerFlags})
            string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
        endforeach()    
        message(STATUS "Using /MT STATIC runtime")
    else ()
        message(STATUS "Using /MD DYNAMIC runtime")
    endif ()
else()
    if (NOT WIN32)
        message(FATAL_ERROR "At present this is a Windows ONLY application.\nWould need porting to other systems, if needed")
    endif ()
endif()

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${WARNING_FLAGS} ${MSVC_FLAGS} -D_REENTRANT" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNING_FLAGS} ${MSVC_FLAGS} -D_REENTRANT" )
set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MSVC_LD_FLAGS}" )

set(name pause_for)
set(dir src)
set(${name}_SRCS
    ${dir}/${name}.cpp
    )
set(${name}_HDRS
    ${dir}/${name}.h
    )
add_executable( ${name} ${${name}_SRCS} ${${name}_HDRS} )
if (MSVC)
    set_target_properties( ${name} PROPERTIES DEBUG_POSTFIX d )
endif ()
# add library dependence, if any...
if (add_LIBS)
    target_link_libraries( ${name} ${add_LIBS} )
endif ()
# if needed, deal with install
#install(TARGETS ${name} DESTINATION bin )

# eof
