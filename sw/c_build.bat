@echo off
REM Pass program name on command line, e.g.: c_build.bat c_test
REM Defaults to c_test if no argument is given
if "%~1"=="" (
    set "PROG=c_test"
) else (
    set "PROG=%~1"
)

if not exist "%PROG%.c" (
    echo ERROR: Source file "%PROG%.s" not found.
    exit /b 1
)

echo [1/3] Compiling %PROG%.c to ELF...
xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-gcc.exe -march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -O1 -T link.ld -o %PROG%.elf %PROG%.c
if errorlevel 1 goto error

echo [2/3] Extracting binary to %PROG%.bin...
xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-objcopy.exe -O binary %PROG%.elf %PROG%.bin
if errorlevel 1 goto error

echo [3/3] Converting %PROG%.bin to %PROG%.mif...
python bin_to_mif.py %PROG%.bin %PROG%.mif
if errorlevel 1 goto error

echo Build complete: %PROG%.mif generated!
goto end

:error
echo Build failed!
exit /b 1

:end