@echo off
setlocal EnableDelayedExpansion

set "THIS_DIR=%~dp0"
set "THIS_DIR=%THIS_DIR:~0,-1%"
set "EXIT_STATUS=0"
set "FORCE=0"

for %%a in (%*) do (
    if /i "%%~a"=="/f" set "FORCE=1"
    if /i "%%~a"=="--force" set "FORCE=1"
    if "%%~a"=="-f" set "FORCE=1"
)

echo Creating symlinks...

for /f "skip=1 tokens=1-3" %%a in ("%THIS_DIR%\mappings.txt") do (
    call :create_symlink "%%b" "%%a" "%%c"
)

exit /b %EXIT_STATUS%

:create_symlink
set "target=%~1"
set "src=%~2"
set "link_type=%~3"
set "target_path=%USERPROFILE%\%target%"
set "src_path=%THIS_DIR%\%src%"
set "current_link="

if exist "%target_path%" (
    for %%I in ("%target_path%") do set "attrs=%%~aI"
    if "!attrs:~8,1!"=="l" (
        for /f "usebackq tokens=*" %%a in (`dir /al "%target_path%" 2^>nul ^| findstr "SYMLINK"`) do (
            for /f "tokens=3" %%b in ("%%a") do (
                set "current_link=%%b"
                if "!current_link!"=="%src_path%" (
                    echo   [OK]     %target%
                    exit /b 0
                )
            )
        )
        if "!FORCE!"=="1" (
            rmdir "%target_path%" 2>nul
            if errorlevel 1 (
                echo   [FAIL]   %target% (failed to remove old symlink)
                set "EXIT_STATUS=1"
                exit /b 1
            )
        ) else (
            echo   [FAIL]   %target% (points to: !current_link!, expected: %src_path%)
            set "EXIT_STATUS=1"
            exit /b 1
        )
    ) else (
        if "!FORCE!"=="1" (
            if "%link_type%"=="dir" (
                rmdir /s /q "%target_path%" 2>nul
            ) else (
                del /f /q "%target_path%" 2>nul
            )
            if errorlevel 1 (
                echo   [FAIL]   %target% (failed to remove existing file/directory)
                set "EXIT_STATUS=1"
                exit /b 1
            )
        ) else (
            echo   [FAIL]   %target% (exists and is not a symlink)
            set "EXIT_STATUS=1"
            exit /b 1
        )
    )
)

for %%I in ("%target_path%") do set "target_dir=%%~dpI"
if not exist "%target_dir%" (
    mkdir "%target_dir%" 2>nul
    if errorlevel 1 (
        echo   [FAIL]   %target% (failed to create parent directory)
        set "EXIT_STATUS=1"
        exit /b 1
    )
)

if "%link_type%"=="dir" (
    mklink /D "%target_path%" "%src_path%" >nul 2>&1
) else (
    mklink "%target_path%" "%src_path%" >nul 2>&1
)

if errorlevel 1 (
    echo   [FAIL]   %target% (failed to create symlink - may need admin rights)
    set "EXIT_STATUS=1"
    exit /b 1
) else (
    if "!FORCE!"=="1" if defined current_link (
        echo   [!]      %target% (removed old and recreated)
    ) else (
        echo   [OK]     %target%
    )
    exit /b 0
)
