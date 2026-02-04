@echo off
setlocal enabledelayedexpansion

REM ################################################################################
REM CONFIGURATION - QRdecode Windows Installation Script
REM ################################################################################

REM Application information
set "APP_NAME=QRdecode"
set "APP_DESCRIPTION=QR code decoder from screen"
set "APP_COMMENT=Detect and decode QR codes on screen"

REM GitHub repository URL (without trailing /)
set "GITHUB_REPO_URL=https://raw.githubusercontent.com/vtflosa/QRdecode/main"

REM List of files to download from GitHub (space-separated)
set "DOWNLOAD_FILES=main.py requirements.txt QRdecode.png"

REM Main Python file to execute
set "MAIN_PYTHON_FILE=main.py"

REM Icon file
set "ICON_FILE=QRdecode.ico"

REM Python dependencies
set "NEEDS_TKINTER=true"

REM ################################################################################
REM END OF CONFIGURATION - Do not modify below this line
REM ################################################################################

echo ============================================================
echo      Installing %APP_NAME%
echo      %APP_DESCRIPTION%
echo ============================================================
echo.

REM Check if Python 3 is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python 3 is not installed!
    echo Please install Python 3 from https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

echo [INFO] Python detected
python --version

REM Check if pip is available
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] pip is not available!
    echo Please reinstall Python with pip included
    pause
    exit /b 1
)

echo [INFO] pip is available

REM Check if tkinter is available (if needed)
if "%NEEDS_TKINTER%"=="true" (
    python -c "import tkinter" >nul 2>&1
    if errorlevel 1 (
        echo [WARNING] tkinter is not available
        echo Please reinstall Python and make sure to include tkinter/tk
        pause
        exit /b 1
    )
    echo [INFO] tkinter is available
)

REM Create installation directory
set "INSTALL_DIR=%LOCALAPPDATA%\QRdecode"
echo [INFO] Creating installation folder: %INSTALL_DIR%
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
cd /d "%INSTALL_DIR%"

REM Download files from GitHub
echo [INFO] Downloading files from GitHub...

for %%f in (%DOWNLOAD_FILES%) do (
    set "file_entry=%%f"
    
    REM Check if format is "remote:local"
    echo !file_entry! | findstr ":" >nul
    if errorlevel 1 (
        set "remote_file=!file_entry!"
        set "local_file=!file_entry!"
    ) else (
        for /f "tokens=1,2 delims=:" %%a in ("!file_entry!") do (
            set "remote_file=%%a"
            set "local_file=%%b"
        )
    )
    
    echo [INFO] Downloading !remote_file!...
    powershell -Command "try { Invoke-WebRequest -Uri '%GITHUB_REPO_URL%/!remote_file!' -OutFile '!local_file!' -UseBasicParsing } catch { exit 1 }"
    if errorlevel 1 (
        echo [ERROR] Failed to download !remote_file!
        pause
        exit /b 1
    )
)

echo [INFO] All files have been successfully downloaded

REM Create virtual environment
echo [INFO] Creating Python virtual environment...
python -m venv venv
if errorlevel 1 (
    echo [ERROR] Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate virtual environment and install dependencies
echo [INFO] Installing Python dependencies...
call venv\Scripts\activate.bat

python -m pip install --upgrade pip
if errorlevel 1 (
    echo [ERROR] Failed to upgrade pip
    call venv\Scripts\deactivate.bat
    pause
    exit /b 1
)

python -m pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install Python dependencies from requirements.txt
    echo Check the content of requirements.txt and your internet connection
    call venv\Scripts\deactivate.bat
    pause
    exit /b 1
)

call venv\Scripts\deactivate.bat
echo [INFO] Dependencies installed

REM Create launcher script
echo [INFO] Creating launcher script...
(
    echo @echo off
    echo cd /d "%INSTALL_DIR%"
    echo call venv\Scripts\activate.bat
    echo python %MAIN_PYTHON_FILE%
    echo call venv\Scripts\deactivate.bat
) > "%INSTALL_DIR%\launch_QRdecode.bat"

echo [INFO] Launcher script created

REM Create desktop shortcut
echo [INFO] Creating desktop shortcut...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=%DESKTOP%\%APP_NAME%.lnk"

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT%'); $Shortcut.TargetPath = '%INSTALL_DIR%\launch_QRdecode.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\%ICON_FILE%'; $Shortcut.Description = '%APP_COMMENT%'; $Shortcut.Save()"

if exist "%SHORTCUT%" (
    echo [INFO] Desktop shortcut created
) else (
    echo [WARNING] Could not create desktop shortcut
)

REM Create Start Menu shortcut
echo [INFO] Creating Start Menu shortcut...
set "START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
set "START_SHORTCUT=%START_MENU%\%APP_NAME%.lnk"

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%START_SHORTCUT%'); $Shortcut.TargetPath = '%INSTALL_DIR%\launch_QRdecode.bat'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\%ICON_FILE%'; $Shortcut.Description = '%APP_COMMENT%'; $Shortcut.Save()"

if exist "%START_SHORTCUT%" (
    echo [INFO] Start Menu shortcut created
) else (
    echo [WARNING] Could not create Start Menu shortcut
)

REM Create uninstall script
echo [INFO] Creating uninstall script...
(
    echo @echo off
    echo echo Uninstalling %APP_NAME%...
    echo rmdir /s /q "%INSTALL_DIR%"
    echo del "%DESKTOP%\%APP_NAME%.lnk" 2^>nul
    echo del "%START_MENU%\%APP_NAME%.lnk" 2^>nul
    echo echo %APP_NAME% has been uninstalled.
    echo pause
) > "%INSTALL_DIR%\uninstall.bat"

echo [INFO] Uninstall script created

echo.
echo ============================================================
echo      Installation completed successfully!
echo ============================================================
echo.
echo [INFO] %APP_NAME% has been installed in: %INSTALL_DIR%
echo [INFO] You can now launch the application from:
echo   - The desktop shortcut
echo   - The Start Menu
echo   - Running: %INSTALL_DIR%\launch_QRdecode.bat
echo.
echo [INFO] To uninstall cleanly, run: %INSTALL_DIR%\uninstall.bat
echo.
echo Thank you!
echo.
pause
