@echo off
REM Pass program name on command line, e.g.: s_build.bat prog1
REM Defaults to prog3 if no argument is given
if "%~1"=="" (
    set "PROG=prog3"
) else (
    set "PROG=%~1"
)

if not exist "%PROG%.s" (
    echo ERROR: Source file "%PROG%.s" not found.
    exit /b 1
)

echo [1/3] Compiling %PROG%.s to ELF...
xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-gcc.exe -march=rv32im -mabi=ilp32 -nostdlib -Ttext 0x0 -o %PROG%.elf %PROG%.s
if errorlevel 1 goto error

echo [2/3] Extracting binary to %PROG%.bin...
xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-objcopy.exe -O binary %PROG%.elf %PROG%.bin
if errorlevel 1 goto error

echo [3/3] Converting %PROG%.bin to %PROG%.mif...
python bin_to_mif.py %PROG%.bin %PROG%.mif
if errorlevel 1 goto error

echo ========================================
echo Build complete: %PROG%.mif generated successfully!
echo ========================================
goto end

:error
echo ========================================
echo ERROR: Build failed during execution.
echo ========================================
exit /b 1

:end