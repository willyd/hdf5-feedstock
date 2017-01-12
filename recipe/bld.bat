mkdir build
cd build

REM set environement variables
set HDF5_EXT_ZLIB=z.lib

REM configure step
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE:STRING=RELEASE -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% -DHDF5_BUILD_CPP_LIB=ON -DBUILD_SHARED_LIBS:BOOL=ON -DHDF5_BUILD_HL_LIB=ON -DHDF5_BUILD_TOOLS:BOOL=ON -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON %SRC_DIR%
if errorlevel 1 exit 1

REM Build C libraries and tools
cmake --build .
if errorlevel 1 exit 1

REM Install step
cmake --build . --target install

REM Patch the cmake targets to avoid hard-coded path to z.lib
"%PYTHON%" "%RECIPE_DIR%\patch_cmake_targets.py" ^
           "%LIBRARY_PREFIX%\cmake\hdf5-targets.cmake" ^
           "%LIBRARY_PREFIX:\=/%/lib/z.lib" ^
           "${_IMPORT_PREFIX}/lib/z.lib"
if errorlevel 1 exit 1
