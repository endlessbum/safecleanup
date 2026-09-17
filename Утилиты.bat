@echo off
chcp 65001 >nul 2>&1
setlocal EnableExtensions EnableDelayedExpansion
title Настройка Windows
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo.
    echo  ОШИБКА: требуются права администратора.
    echo  Щёлкните правой кнопкой -^> "Запуск от имени администратора".
    echo.
    echo Для продолжения нажмите любую клавишу...
    pause >nul
    exit /b 1
)

mode con: cols=72 lines=42 >nul 2>&1

for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "Reset=%ESC%[0m"
set "Bold=%ESC%[1m"
set "Red=%ESC%[31m"
set "Green=%ESC%[32m"
set "Yellow=%ESC%[33m"
set "Cyan=%ESC%[36m"
set "Gray=%ESC%[90m"

set "BACKUP_STARTUP=%~dp0startup_backup"
set "BACKUP_SVC=%~dp0services_backup.txt"
set "LIST_STARTUP=%TEMP%\startup_list.txt"
set "TMPDIR=%TEMP%\DX_VC_Install"
set "RegAdv=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
set "RegExp=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer"
set "RegDeskIcons=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
set "ClsidHome={f874310e-b6b7-47dc-bc84-b9e6b38f5903}"
set "ClsidGallery={e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"
set "ClsidNetwork={F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
set "ClsidRecycle={645FF040-5081-101B-9F08-00AA002F954E}"
set "ClsidMenu={86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

goto MainMenu

:Hdr
cls
echo.
echo  %Bold%%Cyan%%~1%Reset%
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
exit /b

:PauseBack
echo.
echo Для продолжения нажмите любую клавишу...
pause >nul
exit /b

:Ask
set "choice="
set /p "choice=  Выбор: "
exit /b

:Ok
echo  %Green%[OK]%Reset%  %~1
exit /b

:Err
echo  %Red%[ОШИБКА]%Reset%  %~1
exit /b

:Warn
echo  %Yellow%[i]%Reset%  %~1
exit /b

rem ========================================================================
:MainMenu
call :Hdr "НАСТРОЙКА WINDOWS"
echo  %Gray%  1. Осмотр и компоненты%Reset%
echo  %Bold%[ 1]%Reset%  Информация о системе
echo  %Bold%[ 2]%Reset%  Установка DirectX / VC++ / .NET
echo.
echo  %Gray%  2. Очистка%Reset%
echo  %Bold%[ 3]%Reset%  Очистка системы и диска
echo.
echo  %Gray%  3. Приватность и ПО%Reset%
echo  %Bold%[ 4]%Reset%  Удаление мусорного ПО
echo  %Bold%[ 5]%Reset%  Приватность, телеметрия, уведомления
echo.
echo  %Gray%  4. Фон системы%Reset%
echo  %Bold%[ 6]%Reset%  Службы Windows
echo  %Bold%[ 7]%Reset%  Автозагрузка
echo.
echo  %Gray%  5. Производительность%Reset%
echo  %Bold%[ 8]%Reset%  Питание, память, CPU
echo  %Bold%[ 9]%Reset%  Сеть
echo.
echo  %Gray%  6. Интерфейс и ввод%Reset%
echo  %Bold%[10]%Reset%  Интерфейс и проводник
echo  %Bold%[11]%Reset%  Ввод, браузер и игры
echo.
echo  %Gray%  7. Обслуживание%Reset%
echo  %Bold%[12]%Reset%  Поиск и целостность Windows
echo  %Bold%[13]%Reset%  Безопасность  (UAC)
echo  %Bold%[14]%Reset%  Активация Windows
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[ 0]%Reset%  Выход
echo.
call :Ask
if "%choice%"=="1" goto InfoMenu
if "%choice%"=="2" goto InstMenu
if "%choice%"=="3" goto CleanMenu
if "%choice%"=="4" goto BloatMenu
if "%choice%"=="5" goto PrivMenu
if "%choice%"=="6" goto SvcMenu
if "%choice%"=="7" goto StartUpMenu
if "%choice%"=="8" goto PerfMenu
if "%choice%"=="9" goto NetMenu
if "%choice%"=="10" goto UIMenu
if "%choice%"=="11" goto InpMenu
if "%choice%"=="12" goto MaintMenu
if "%choice%"=="13" goto SecMenu
if "%choice%"=="14" goto ActLaunch
if "%choice%"=="0" goto ExitUtil
echo.
echo  %Yellow%Неверный выбор.%Reset%
timeout /t 1 /nobreak >nul
goto MainMenu

:ExitUtil
cls
echo.
echo  %Cyan%Выход.%Reset%
echo.
endlocal
exit /b 0

:ActLaunch
call :Hdr "АКТИВАЦИЯ WINDOWS"
if exist "%~dp0Активатор.bat" (
    echo  %Yellow%Запускаю Активатор.bat...%Reset%
    echo.
    start "Активатор" "%~dp0Активатор.bat"
    call :Ok "Активатор запущен в отдельном окне."
) else (
    call :Err "Файл Активатор.bat не найден рядом с утилитой."
    echo  %Gray%Оставьте Активатор.bat в той же папке.%Reset%
)
call :PauseBack
goto MainMenu

rem ========================================================================
rem  1. ИНФОРМАЦИЯ
rem ========================================================================
:InfoMenu
call :Hdr "ИНФОРМАЦИЯ О КОМПЬЮТЕРЕ"
echo  %Bold%[1]%Reset%  Полный отчёт
echo  %Bold%[2]%Reset%  Система и Windows
echo  %Bold%[3]%Reset%  Процессор и материнская плата
echo  %Bold%[4]%Reset%  Память (ОЗУ)
echo  %Bold%[5]%Reset%  Видеокарта
echo  %Bold%[6]%Reset%  Диски
echo  %Bold%[7]%Reset%  Сеть
echo  %Bold%[8]%Reset%  Периферия
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto InfoAll
if "%choice%"=="2" goto InfoOS
if "%choice%"=="3" goto InfoCPU
if "%choice%"=="4" goto InfoRAM
if "%choice%"=="5" goto InfoGPU
if "%choice%"=="6" goto InfoDisk
if "%choice%"=="7" goto InfoNet
if "%choice%"=="8" goto InfoPeriph
if "%choice%"=="0" goto MainMenu
goto InfoMenu

:InfoAll
call :Hdr "ПОЛНЫЙ ОТЧЁТ"
echo  %Yellow%Сбор данных, подождите...%Reset%
echo.
set "REPORT=%TEMP%\PC_Info_Report.txt"
(
echo ============================================================
echo   ПОЛНЫЙ ОТЧЁТ О КОМПЬЮТЕРЕ
echo   %DATE% %TIME%
echo ============================================================
echo.
) > "%REPORT%"
echo  • Система...
powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | ForEach-Object { '--- СИСТЕМА И WINDOWS ---'; '  ОС:             '+$_.Caption; '  Версия:         '+$_.Version; '  Сборка:         '+$_.BuildNumber; '  Архитектура:    '+$_.OSArchitecture; '  Установка:      '+$_.InstallDate; '  Последний запуск: '+$_.LastBootUpTime }; $cs=Get-CimInstance Win32_ComputerSystem; '  Компьютер:      '+$cs.Name; '  Пользователь:   '+$env:USERNAME; '  Производитель:  '+$cs.Manufacturer; '  Модель:         '+$cs.Model; $b=Get-CimInstance Win32_BIOS; '  BIOS:           '+$b.Manufacturer+' '+$b.SMBIOSBIOSVersion; '  Дата BIOS:      '+$b.ReleaseDate; ''" >> "%REPORT%" 2>nul
echo  • Процессор...
powershell -NoProfile -Command "Get-CimInstance Win32_Processor | ForEach-Object { '--- ПРОЦЕССОР ---'; '  Имя:            '+$_.Name.Trim(); '  Ядра/потоки:    '+$_.NumberOfCores+' / '+$_.NumberOfLogicalProcessors; '  Частота:        '+$_.MaxClockSpeed+' МГц'; '  Сокет:          '+$_.SocketDesignation }; $bb=Get-CimInstance Win32_BaseBoard; '--- МАТЕРИНСКАЯ ПЛАТА ---'; '  Плата:          '+$bb.Manufacturer+' '+$bb.Product; '  Версия:         '+$bb.Version; '  S/N:            '+$bb.SerialNumber; ''" >> "%REPORT%" 2>nul
echo  • Память...
powershell -NoProfile -Command "$cs=Get-CimInstance Win32_ComputerSystem; '--- ОЗУ ---'; '  Всего:          '+[math]::Round($cs.TotalPhysicalMemory/1GB,2)+' ГБ'; $i=1; Get-CimInstance Win32_PhysicalMemory | ForEach-Object { $m=$_.ConfiguredClockSpeed; if(-not $m){$m=$_.Speed}; '  Модуль '+$i+':      '+[math]::Round($_.Capacity/1GB,2)+' ГБ  '+$m+' МГц  '+$_.Manufacturer.Trim()+' '+$_.PartNumber.Trim(); $i++ }; ''" >> "%REPORT%" 2>nul
echo  • Видео...
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | ForEach-Object { '--- ВИДЕО ---'; '  Карта:          '+$_.Name; '  Драйвер:        '+$_.DriverVersion; '  Дата:           '+$_.DriverDate; if($_.CurrentHorizontalResolution){'  Разрешение:     '+$_.CurrentHorizontalResolution+'x'+$_.CurrentVerticalResolution}; '' }" >> "%REPORT%" 2>nul
echo  • Диски...
powershell -NoProfile -Command "Get-CimInstance Win32_DiskDrive | ForEach-Object { '--- ДИСК ---'; '  '+$_.Model.Trim()+'  '+[math]::Round($_.Size/1GB,2)+' ГБ  ('+$_.InterfaceType+')' }; '  Тома:'; Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | ForEach-Object { '    '+$_.DeviceID+'  '+[math]::Round($_.Size/1GB,2)+' ГБ, свободно '+[math]::Round($_.FreeSpace/1GB,2)+' ГБ  '+$_.FileSystem }; ''" >> "%REPORT%" 2>nul
echo  • Сеть...
powershell -NoProfile -Command "Get-CimInstance Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -and $_.MACAddress} | ForEach-Object { '--- СЕТЬ ---'; '  '+$_.Name+'  MAC '+$_.MACAddress }; Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled} | ForEach-Object { $ip=($_.IPAddress -join ', '); $gw=($_.DefaultIPGateway -join ', '); '  '+$_.Description; '    IP: '+$ip+'  Шлюз: '+$gw }; ''" >> "%REPORT%" 2>nul
echo  • Периферия...
powershell -NoProfile -Command "'--- ПЕРИФЕРИЯ ---'; '  Клавиатуры:'; Get-CimInstance Win32_Keyboard -EA 0 | ForEach-Object { '    '+$_.Name }; '  Мыши:'; Get-CimInstance Win32_PointingDevice -EA 0 | ForEach-Object { '    '+$_.Name }; '  Мониторы:'; Get-CimInstance Win32_DesktopMonitor -EA 0 | ForEach-Object { if($_.Name){'    '+$_.Name} }; '  Аудио:'; Get-CimInstance Win32_SoundDevice -EA 0 | ForEach-Object { '    '+$_.Name }; '  Принтеры:'; $p=@(Get-CimInstance Win32_Printer -EA 0); if($p){$p|ForEach-Object{'    '+$_.Name}}else{'    (нет)'}; ''" >> "%REPORT%" 2>nul
echo. >> "%REPORT%"
echo ============================================================ >> "%REPORT%"
cls
echo.
echo  %Bold%%Cyan%ПОЛНЫЙ ОТЧЁТ%Reset%
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
type "%REPORT%"
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[1]%Reset%  Открыть отчёт в Блокноте
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" start notepad "%REPORT%"
goto InfoMenu

:InfoOS
call :Hdr "СИСТЕМА И WINDOWS"
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $cs=Get-CimInstance Win32_ComputerSystem; $bios=Get-CimInstance Win32_BIOS; Write-Host '  Имя компьютера:     ' -NoNewline; Write-Host $cs.Name -ForegroundColor Cyan; Write-Host '  Пользователь:       ' -NoNewline; Write-Host $env:USERNAME -ForegroundColor Cyan; Write-Host '  ОС:                 ' -NoNewline; Write-Host $os.Caption -ForegroundColor Cyan; Write-Host '  Версия:             ' -NoNewline; Write-Host $os.Version -ForegroundColor Cyan; Write-Host '  Сборка:             ' -NoNewline; Write-Host $os.BuildNumber -ForegroundColor Cyan; Write-Host '  Архитектура:        ' -NoNewline; Write-Host $os.OSArchitecture -ForegroundColor Cyan; Write-Host '  Дата установки:     ' -NoNewline; Write-Host $os.InstallDate -ForegroundColor Cyan; Write-Host '  Последний запуск:   ' -NoNewline; Write-Host $os.LastBootUpTime -ForegroundColor Cyan; Write-Host '  Производитель ПК:   ' -NoNewline; Write-Host $cs.Manufacturer -ForegroundColor Cyan; Write-Host '  Модель ПК:          ' -NoNewline; Write-Host $cs.Model -ForegroundColor Cyan; Write-Host '  BIOS:               ' -NoNewline; Write-Host ($bios.Manufacturer+' '+$bios.SMBIOSBIOSVersion) -ForegroundColor Cyan; Write-Host '  Дата BIOS:          ' -NoNewline; Write-Host $bios.ReleaseDate -ForegroundColor Cyan;"
call :PauseBack
goto InfoMenu

:InfoCPU
call :Hdr "ПРОЦЕССОР И МАТЕРИНСКАЯ ПЛАТА"
powershell -NoProfile -Command "$cpu=Get-CimInstance Win32_Processor; $bb=Get-CimInstance Win32_BaseBoard; foreach($c in $cpu){ Write-Host '  Процессор:          ' -NoNewline; Write-Host $c.Name.Trim() -ForegroundColor Cyan; Write-Host '  Ядра / потоки:      ' -NoNewline; Write-Host ($c.NumberOfCores.ToString()+' / '+$c.NumberOfLogicalProcessors) -ForegroundColor Cyan; Write-Host '  Макс. частота:      ' -NoNewline; Write-Host ($c.MaxClockSpeed.ToString()+' МГц') -ForegroundColor Cyan; Write-Host '  Сокет:              ' -NoNewline; Write-Host $c.SocketDesignation -ForegroundColor Cyan }; Write-Host '  Мат. плата:         ' -NoNewline; Write-Host ($bb.Manufacturer+' '+$bb.Product) -ForegroundColor Cyan; Write-Host '  Версия платы:       ' -NoNewline; Write-Host $bb.Version -ForegroundColor Cyan; Write-Host '  Серийный номер:     ' -NoNewline; Write-Host $bb.SerialNumber -ForegroundColor Cyan;"
call :PauseBack
goto InfoMenu

:InfoRAM
call :Hdr "ОПЕРАТИВНАЯ ПАМЯТЬ"
powershell -NoProfile -Command "$cs=Get-CimInstance Win32_ComputerSystem; $total=[math]::Round($cs.TotalPhysicalMemory/1GB,2); Write-Host ('  Всего ОЗУ:          '+$total.ToString()+' ГБ') -ForegroundColor Cyan; $i=1; Get-CimInstance Win32_PhysicalMemory | ForEach-Object { $gb=[math]::Round($_.Capacity/1GB,2); $mhz=$_.ConfiguredClockSpeed; if(-not $mhz){$mhz=$_.Speed}; Write-Host ('  Модуль '+$i+':  '+$gb+' ГБ  '+$mhz+' МГц  '+$_.Manufacturer.Trim()+'  '+$_.PartNumber.Trim()) -ForegroundColor Cyan; $i++ }"
call :PauseBack
goto InfoMenu

:InfoGPU
call :Hdr "ВИДЕОКАРТА"
powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | ForEach-Object { Write-Host '  Видеокарта:         ' -NoNewline; Write-Host $_.Name -ForegroundColor Cyan; Write-Host '  Драйвер:            ' -NoNewline; Write-Host $_.DriverVersion -ForegroundColor Cyan; Write-Host '  Дата драйвера:      ' -NoNewline; Write-Host $_.DriverDate -ForegroundColor Cyan; if($_.CurrentHorizontalResolution){ Write-Host '  Разрешение:         ' -NoNewline; Write-Host ($_.CurrentHorizontalResolution.ToString()+' x '+$_.CurrentVerticalResolution) -ForegroundColor Cyan }; Write-Host '' }"
call :PauseBack
goto InfoMenu

:InfoDisk
call :Hdr "ДИСКИ"
powershell -NoProfile -Command "Get-CimInstance Win32_DiskDrive | ForEach-Object { $gb=[math]::Round($_.Size/1GB,2); Write-Host ('  '+$_.Model.Trim()+'  —  '+$gb+' ГБ  ('+$_.InterfaceType+')') -ForegroundColor Cyan }; Write-Host '  Логические тома:'; Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object { $free=[math]::Round($_.FreeSpace/1GB,2); $total=[math]::Round($_.Size/1GB,2); Write-Host ('    '+$_.DeviceID+'  '+$total+' ГБ (свободно '+$free+' ГБ)  '+$_.FileSystem) -ForegroundColor Cyan }"
call :PauseBack
goto InfoMenu

:InfoNet
call :Hdr "СЕТЬ"
powershell -NoProfile -Command "Get-CimInstance Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true -and $_.MACAddress } | ForEach-Object { Write-Host ('  '+$_.Name+'  MAC: '+$_.MACAddress) -ForegroundColor Cyan }; Write-Host '  IP-адреса:'; Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object { $ip=if($_.IPAddress){$_.IPAddress -join ', '}else{'-'}; $gw=if($_.DefaultIPGateway){$_.DefaultIPGateway -join ', '}else{'-'}; Write-Host ('    '+$_.Description) -ForegroundColor DarkGray; Write-Host ('    IP: '+$ip+'  Шлюз: '+$gw) -ForegroundColor Cyan }"
call :PauseBack
goto InfoMenu

:InfoPeriph
call :Hdr "ПЕРИФЕРИЯ"
powershell -NoProfile -Command "Write-Host '  Клавиатуры:'; Get-CimInstance Win32_Keyboard -EA 0 | ForEach-Object { Write-Host ('    '+$_.Name) -ForegroundColor Cyan }; Write-Host '  Мыши:'; Get-CimInstance Win32_PointingDevice -EA 0 | ForEach-Object { Write-Host ('    '+$_.Name) -ForegroundColor Cyan }; Write-Host '  Мониторы:'; Get-CimInstance Win32_DesktopMonitor -EA 0 | ForEach-Object { if($_.Name){ Write-Host ('    '+$_.Name) -ForegroundColor Cyan } }; Write-Host '  Аудио:'; Get-CimInstance Win32_SoundDevice -EA 0 | ForEach-Object { Write-Host ('    '+$_.Name) -ForegroundColor Cyan }; Write-Host '  Принтеры:'; $p=@(Get-CimInstance Win32_Printer -EA 0); if($p.Count -gt 0){ $p | ForEach-Object { Write-Host ('    '+$_.Name) -ForegroundColor Cyan } } else { Write-Host '    (нет)' -ForegroundColor DarkGray }"
call :PauseBack
goto InfoMenu

rem ========================================================================
rem  2. УСТАНОВКА RUNTIME
rem ========================================================================
:InstMenu
call :Hdr "УСТАНОВКА DIRECTX / VC++ / .NET"
echo  %Bold%[1]%Reset%  Установить всё  (DX + VC++ + .NET)
echo  %Bold%[2]%Reset%  Только DirectX End-User Runtime
echo  %Bold%[3]%Reset%  Только Visual C++ Redistributable
echo  %Bold%[4]%Reset%  Только .NET Desktop Runtime
echo  %Bold%[5]%Reset%  Проверить установленные runtime
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto InstAll
if "%choice%"=="2" goto InstDX
if "%choice%"=="3" goto InstVC
if "%choice%"=="4" goto InstNET
if "%choice%"=="5" goto InstCheck
if "%choice%"=="0" goto MainMenu
goto InstMenu

:InstAll
call :DoDirectX
call :DoVC
call :DoNET
goto InstDone
:InstDX
call :DoDirectX
goto InstDone
:InstVC
call :DoVC
goto InstDone
:InstNET
call :DoNET
goto InstDone

:DoDirectX
call :Hdr "DIRECTX END-USER RUNTIME"
if not exist "%TMPDIR%" mkdir "%TMPDIR%" >nul 2>&1
echo  %Yellow%Скачиваю dxwebsetup.exe...%Reset%
echo.
set "DXFILE=%TMPDIR%\dxwebsetup.exe"
curl -L -o "%DXFILE%" --retry 3 --connect-timeout 15 "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe" 2>nul
if not exist "%DXFILE%" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe' -OutFile '%DXFILE%' -UseBasicParsing } catch { exit 1 }" 2>nul
)
if not exist "%DXFILE%" (
    call :Err "Не удалось скачать DirectX. Проверьте интернет."
    call :PauseBack
    exit /b 1
)
call :Ok "Файл скачан"
echo.
echo  %Yellow%Запускаю установку DirectX...%Reset%
start /wait "" "%DXFILE%" /Q
call :Ok "DirectX End-User Runtime установлен"
echo  %Gray%Пакет добавляет старые компоненты (D3DX) для старых игр.%Reset%
echo.
exit /b 0

:DoVC
call :Hdr "VISUAL C++ REDISTRIBUTABLE"
if not exist "%TMPDIR%" mkdir "%TMPDIR%" >nul 2>&1
echo  %Yellow%Скачиваю последние версии (x86 + x64)...%Reset%
echo.
set "VC64=%TMPDIR%\vc_redist.x64.exe"
set "VC86=%TMPDIR%\vc_redist.x86.exe"
echo  • VC++ x64
curl -L -o "%VC64%" --retry 3 --connect-timeout 15 "https://aka.ms/vc14/vc_redist.x64.exe" 2>nul
if not exist "%VC64%" powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://aka.ms/vc14/vc_redist.x64.exe' -OutFile '%VC64%' -UseBasicParsing } catch { exit 1 }" 2>nul
if exist "%VC64%" (call :Ok "Скачан x64") else (call :Err "Не удалось скачать x64")
echo  • VC++ x86
curl -L -o "%VC86%" --retry 3 --connect-timeout 15 "https://aka.ms/vc14/vc_redist.x86.exe" 2>nul
if not exist "%VC86%" powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://aka.ms/vc14/vc_redist.x86.exe' -OutFile '%VC86%' -UseBasicParsing } catch { exit 1 }" 2>nul
if exist "%VC86%" (call :Ok "Скачан x86") else (call :Err "Не удалось скачать x86")
echo.
if not exist "%VC64%" if not exist "%VC86%" (
    call :Err "Не удалось скачать Visual C++."
    call :PauseBack
    exit /b 1
)
echo  %Yellow%Устанавливаю Visual C++ Redistributable...%Reset%
echo.
if exist "%VC64%" (
    echo  • Установка x64...
    "%VC64%" /install /quiet /norestart
    if !errorlevel! EQU 0 (call :Ok "x64 установлен") else if !errorlevel! EQU 1638 (call :Ok "x64 уже установлен") else if !errorlevel! EQU 3010 (call :Ok "x64 установлен, нужна перезагрузка") else call :Warn "x64 код: !errorlevel!"
)
if exist "%VC86%" (
    echo  • Установка x86...
    "%VC86%" /install /quiet /norestart
    if !errorlevel! EQU 0 (call :Ok "x86 установлен") else if !errorlevel! EQU 1638 (call :Ok "x86 уже установлен") else if !errorlevel! EQU 3010 (call :Ok "x86 установлен, нужна перезагрузка") else call :Warn "x86 код: !errorlevel!"
)
echo.
exit /b 0

:DoNET
call :Hdr ".NET DESKTOP RUNTIME"
if not exist "%TMPDIR%" mkdir "%TMPDIR%" >nul 2>&1
set "NEED8=1"
set "NEED6=1"
dotnet --list-runtimes 2>nul | findstr /i "Microsoft.WindowsDesktop.App 8." >nul 2>&1 && set "NEED8=0"
dotnet --list-runtimes 2>nul | findstr /i "Microsoft.WindowsDesktop.App 6." >nul 2>&1 && set "NEED6=0"
if "%NEED8%"=="0" (call :Ok ".NET 8 Desktop Runtime уже есть") else (call :Warn ".NET 8 Desktop Runtime не найден")
if "%NEED6%"=="0" (call :Ok ".NET 6 Desktop Runtime уже есть") else (call :Warn ".NET 6 Desktop Runtime не найден")
if "%NEED8%"=="0" if "%NEED6%"=="0" (
    echo.
    echo  %Green%Нужные runtime уже установлены.%Reset%
    echo.
    exit /b 0
)
echo.
set "NET8=%TMPDIR%\windowsdesktop-runtime-8-x64.exe"
set "NET6=%TMPDIR%\windowsdesktop-runtime-6-x64.exe"
if "%NEED8%"=="1" (
    echo  • .NET 8 Desktop x64
    curl -L -o "%NET8%" --retry 3 --connect-timeout 20 "https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe" 2>nul
    if not exist "%NET8%" powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%NET8%' -UseBasicParsing } catch { exit 1 }" 2>nul
    if exist "%NET8%" (
        call :Ok "Скачан"
        "%NET8%" /install /quiet /norestart
        if !errorlevel! EQU 0 (call :Ok ".NET 8 установлен") else if !errorlevel! EQU 1638 (call :Ok ".NET 8 уже установлен") else if !errorlevel! EQU 3010 (call :Ok ".NET 8 установлен, нужна перезагрузка") else call :Warn "код: !errorlevel!"
    ) else (
        call :Err "Не удалось скачать .NET 8"
    )
)
if "%NEED6%"=="1" (
    echo  • .NET 6 Desktop x64
    curl -L -o "%NET6%" --retry 3 --connect-timeout 20 "https://aka.ms/dotnet/6.0/windowsdesktop-runtime-win-x64.exe" 2>nul
    if not exist "%NET6%" powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://aka.ms/dotnet/6.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%NET6%' -UseBasicParsing } catch { exit 1 }" 2>nul
    if exist "%NET6%" (
        call :Ok "Скачан"
        "%NET6%" /install /quiet /norestart
        if !errorlevel! EQU 0 (call :Ok ".NET 6 установлен") else if !errorlevel! EQU 1638 (call :Ok ".NET 6 уже установлен") else if !errorlevel! EQU 3010 (call :Ok ".NET 6 установлен, нужна перезагрузка") else call :Warn "код: !errorlevel!"
    ) else (
        call :Err "Не удалось скачать .NET 6"
    )
)
echo.
exit /b 0

:InstCheck
call :Hdr "ПРОВЕРКА RUNTIME"
echo  %Bold%.NET runtimes:%Reset%
dotnet --list-runtimes 2>nul
if errorlevel 1 echo  %Gray%(dotnet не найден в PATH)%Reset%
echo.
echo  %Bold%Visual C++ Redistributable:%Reset%
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Microsoft Visual C++" 2>nul | findstr /i "DisplayName" | findstr /i "Redistributable"
reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Microsoft Visual C++" 2>nul | findstr /i "DisplayName" | findstr /i "Redistributable"
echo.
echo  %Bold%DirectX:%Reset%
if exist "%SystemRoot%\System32\d3dx9_43.dll" (call :Ok "d3dx9_43.dll найден") else (call :Warn "d3dx9_43.dll не найден")
call :PauseBack
goto InstMenu

:InstDone
echo.
echo  %Bold%%Green%ГОТОВО%Reset%
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  Временные файлы: %TMPDIR%
echo  %Yellow%Рекомендуется перезагрузить компьютер.%Reset%
call :PauseBack
goto InstMenu

rem ========================================================================
rem  3. ОЧИСТКА
rem ========================================================================
:CleanMenu
call :Hdr "ОЧИСТКА СИСТЕМЫ И ДИСКА"
echo  %Gray%  Быстрая очистка%Reset%
echo  %Bold%[ 1]%Reset%  Полная очистка  (корзина + temp + браузеры + обновления)
echo  %Bold%[ 2]%Reset%  Корзина
echo  %Bold%[ 3]%Reset%  Папки Temp
echo  %Bold%[ 4]%Reset%  Кэш браузеров
echo  %Bold%[ 5]%Reset%  Старые обновления Windows
echo  %Bold%[ 6]%Reset%  Кэш проводника  (иконки, эскизы, шрифты)
echo  %Bold%[ 7]%Reset%  DNS / Winsock
echo.
echo  %Gray%  Глубокая очистка диска%Reset%
echo  %Bold%[ 8]%Reset%  WinSxS — очистка компонентов
echo  %Bold%[ 9]%Reset%  WinSxS — ResetBase  %Red%(осторожно)%Reset%
echo  %Bold%[10]%Reset%  Файл гибернации hiberfil.sys
echo  %Bold%[11]%Reset%  Точки восстановления
echo  %Bold%[12]%Reset%  Кэш Delivery Optimization
echo  %Bold%[13]%Reset%  Всё безопасное сразу  (8+12)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[ 0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto ClnFull
if "%choice%"=="2" goto ClnRecycle
if "%choice%"=="3" goto ClnTemp
if "%choice%"=="4" goto ClnBrowsers
if "%choice%"=="5" goto ClnWinUpd
if "%choice%"=="6" goto ClnExplorer
if "%choice%"=="7" goto ClnDNSMenu
if "%choice%"=="8" goto ClnWinSxS
if "%choice%"=="9" goto ClnResetBase
if "%choice%"=="10" goto ClnHiber
if "%choice%"=="11" goto ClnRestore
if "%choice%"=="12" goto ClnDelivery
if "%choice%"=="13" goto ClnSafeAll
if "%choice%"=="0" goto MainMenu
goto CleanMenu

:ClnFull
call :CleanRecycle
call :CleanTemp
call :CleanBrowsers
call :CleanWinUpdate
goto ClnDone
:ClnRecycle
call :CleanRecycle
goto ClnDone
:ClnTemp
call :CleanTemp
goto ClnDone
:ClnBrowsers
call :CleanBrowsers
goto ClnDone
:ClnWinUpd
call :CleanWinUpdate
goto ClnDone

:CleanRecycle
call :Hdr "ОЧИСТКА КОРЗИНЫ"
echo  %Yellow%Очищаю корзину...%Reset%
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Clear-RecycleBin -Force -ErrorAction Stop; exit 0 } catch { exit 0 }" >nul 2>&1
call :Ok "Корзина очищена"
echo.
exit /b

:CleanTemp
call :Hdr "ОЧИСТКА ПАПОК TEMP"
echo  %Yellow%Очищаю временные файлы...%Reset%
echo.
echo  • TEMP пользователя
if defined TEMP (
    del /f /s /q "%TEMP%\*" >nul 2>&1
    for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1
)
call :Ok "TEMP"
echo  • Windows\Temp
del /f /s /q "%SystemRoot%\Temp\*" >nul 2>&1
for /d %%i in ("%SystemRoot%\Temp\*") do rd /s /q "%%i" >nul 2>&1
call :Ok "Windows\Temp"
echo  • Prefetch
del /f /q "%SystemRoot%\Prefetch\*.pf" >nul 2>&1
call :Ok "Prefetch"
echo  • Recent
del /f /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1
call :Ok "Recent"
echo  • INetCache
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*" >nul 2>&1
for /d %%i in ("%LOCALAPPDATA%\Microsoft\Windows\INetCache\*") do rd /s /q "%%i" >nul 2>&1
call :Ok "INetCache"
echo.
exit /b

:CleanBrowsers
call :Hdr "ОЧИСТКА БРАУЗЕРОВ"
echo  %Yellow%Очищаю кэш (закладки и пароли не затрагиваются)...%Reset%
echo.
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    echo  • Google Chrome
    for /d %%p in ("%LOCALAPPDATA%\Google\Chrome\User Data\*") do (
        if exist "%%p\Cache" rd /s /q "%%p\Cache" >nul 2>&1
        if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
        if exist "%%p\GPUCache" rd /s /q "%%p\GPUCache" >nul 2>&1
        if exist "%%p\Service Worker\CacheStorage" rd /s /q "%%p\Service Worker\CacheStorage" >nul 2>&1
    )
    call :Ok "Chrome"
)
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    echo  • Microsoft Edge
    for /d %%p in ("%LOCALAPPDATA%\Microsoft\Edge\User Data\*") do (
        if exist "%%p\Cache" rd /s /q "%%p\Cache" >nul 2>&1
        if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
        if exist "%%p\GPUCache" rd /s /q "%%p\GPUCache" >nul 2>&1
        if exist "%%p\Service Worker\CacheStorage" rd /s /q "%%p\Service Worker\CacheStorage" >nul 2>&1
    )
    call :Ok "Edge"
)
if exist "%APPDATA%\Mozilla\Firefox\Profiles" (
    echo  • Mozilla Firefox
    for /d %%p in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do (
        if exist "%%p\cache2" rd /s /q "%%p\cache2" >nul 2>&1
        if exist "%%p\startupCache" rd /s /q "%%p\startupCache" >nul 2>&1
        if exist "%%p\OfflineCache" rd /s /q "%%p\OfflineCache" >nul 2>&1
    )
    call :Ok "Firefox"
)
if exist "%APPDATA%\Opera Software\Opera Stable" (
    echo  • Opera
    if exist "%APPDATA%\Opera Software\Opera Stable\Cache" rd /s /q "%APPDATA%\Opera Software\Opera Stable\Cache" >nul 2>&1
    if exist "%APPDATA%\Opera Software\Opera Stable\GPUCache" rd /s /q "%APPDATA%\Opera Software\Opera Stable\GPUCache" >nul 2>&1
    if exist "%APPDATA%\Opera Software\Opera Stable\Code Cache" rd /s /q "%APPDATA%\Opera Software\Opera Stable\Code Cache" >nul 2>&1
    call :Ok "Opera"
)
if exist "%APPDATA%\Opera Software\Opera GX Stable" (
    echo  • Opera GX
    if exist "%APPDATA%\Opera Software\Opera GX Stable\Cache" rd /s /q "%APPDATA%\Opera Software\Opera GX Stable\Cache" >nul 2>&1
    if exist "%APPDATA%\Opera Software\Opera GX Stable\GPUCache" rd /s /q "%APPDATA%\Opera Software\Opera GX Stable\GPUCache" >nul 2>&1
    if exist "%APPDATA%\Opera Software\Opera GX Stable\Code Cache" rd /s /q "%APPDATA%\Opera Software\Opera GX Stable\Code Cache" >nul 2>&1
    call :Ok "Opera GX"
)
if exist "%LOCALAPPDATA%\Yandex\YandexBrowser\User Data" (
    echo  • Яндекс.Браузер
    for /d %%p in ("%LOCALAPPDATA%\Yandex\YandexBrowser\User Data\*") do (
        if exist "%%p\Cache" rd /s /q "%%p\Cache" >nul 2>&1
        if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
        if exist "%%p\GPUCache" rd /s /q "%%p\GPUCache" >nul 2>&1
    )
    call :Ok "Яндекс"
)
if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data" (
    echo  • Brave
    for /d %%p in ("%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\*") do (
        if exist "%%p\Cache" rd /s /q "%%p\Cache" >nul 2>&1
        if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
        if exist "%%p\GPUCache" rd /s /q "%%p\GPUCache" >nul 2>&1
    )
    call :Ok "Brave"
)
if exist "%LOCALAPPDATA%\Vivaldi\User Data" (
    echo  • Vivaldi
    for /d %%p in ("%LOCALAPPDATA%\Vivaldi\User Data\*") do (
        if exist "%%p\Cache" rd /s /q "%%p\Cache" >nul 2>&1
        if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
        if exist "%%p\GPUCache" rd /s /q "%%p\GPUCache" >nul 2>&1
    )
    call :Ok "Vivaldi"
)
if exist "%LOCALAPPDATA%\Chromium\User Data" (
    echo  • Chromium
    for /d %%p in ("%LOCALAPPDATA%\Chromium\User Data\*") do (
        if exist "%%p\Cache" rd /s /q "%%p\Cache" >nul 2>&1
        if exist "%%p\Code Cache" rd /s /q "%%p\Code Cache" >nul 2>&1
        if exist "%%p\GPUCache" rd /s /q "%%p\GPUCache" >nul 2>&1
    )
    call :Ok "Chromium"
)
echo.
echo  %Green%Кэш браузеров очищен.%Reset%
echo.
exit /b

:CleanWinUpdate
call :Hdr "ОЧИСТКА СТАРЫХ ОБНОВЛЕНИЙ WINDOWS"
echo  %Yellow%Очищаю кэш и старые компоненты обновлений...%Reset%
echo.
echo  • Остановка служб Windows Update
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop cryptsvc >nul 2>&1
net stop msiserver >nul 2>&1
call :Ok "службы остановлены"
echo  • SoftwareDistribution\Download
if exist "%SystemRoot%\SoftwareDistribution\Download" (
    del /f /s /q "%SystemRoot%\SoftwareDistribution\Download\*" >nul 2>&1
    for /d %%i in ("%SystemRoot%\SoftwareDistribution\Download\*") do rd /s /q "%%i" >nul 2>&1
)
call :Ok "кэш загрузок"
echo  • Catroot2
if exist "%SystemRoot%\System32\catroot2" (
    ren "%SystemRoot%\System32\catroot2" catroot2.old >nul 2>&1
    mkdir "%SystemRoot%\System32\catroot2" >nul 2>&1
)
call :Ok "Catroot2"
echo  • Delivery Optimization
if exist "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" (
    del /f /s /q "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" >nul 2>&1
    for /d %%i in ("%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*") do rd /s /q "%%i" >nul 2>&1
)
if exist "%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache" (
    del /f /s /q "%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache\*" >nul 2>&1
    for /d %%i in ("%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache\*") do rd /s /q "%%i" >nul 2>&1
)
call :Ok "Delivery Optimization"
echo  • DISM StartComponentCleanup
echo    %Gray%(может занять несколько минут...)%Reset%
Dism.exe /Online /Cleanup-Image /StartComponentCleanup /Quiet >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "старые компоненты удалены") else (call :Warn "DISM код !errorlevel!")
echo  • Запуск служб Windows Update
net start cryptsvc >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
call :Ok "службы запущены"
if exist "%SystemRoot%\System32\catroot2.old" rd /s /q "%SystemRoot%\System32\catroot2.old" >nul 2>&1
echo.
exit /b

:ClnExplorer
call :Hdr "КЭШ ПРОВОДНИКА"
echo  %Yellow%Останавливаю проводник...%Reset%
taskkill /f /im explorer.exe >nul 2>&1
echo  [1/3]  Кэш эскизов...
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
echo  [2/3]  Кэш иконок...
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
echo  [3/3]  Кэш шрифтов...
net stop FontCache >nul 2>&1
net stop FontCache3.0.0.0 >nul 2>&1
del /f /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.dat" >nul 2>&1
net start FontCache >nul 2>&1
net start FontCache3.0.0.0 >nul 2>&1
start "" explorer.exe
call :Ok "Кэш проводника очищен"
call :PauseBack
goto CleanMenu

:ClnDNSMenu
call :Hdr "ОЧИСТКА DNS"
echo  %Bold%[1]%Reset%  Очистить DNS-кэш
echo  %Bold%[2]%Reset%  Очистить DNS + сброс Winsock / IP
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto ClnDNS
if "%choice%"=="2" goto ClnDNSAll
if "%choice%"=="0" goto CleanMenu
goto ClnDNSMenu

:ClnDNS
call :Hdr "ОЧИСТКА DNS-КЭША"
echo  %Yellow%Выполняю ipconfig /flushdns...%Reset%
echo.
ipconfig /flushdns >nul 2>&1
if %errorlevel% EQU 0 (call :Ok "DNS-кэш очищен") else (call :Err "Не удалось очистить DNS-кэш")
call :PauseBack
goto ClnDNSMenu

:ClnDNSAll
call :Hdr "ОЧИСТКА DNS + СБРОС WINSOCK"
echo  %Yellow%Очищаю DNS-кэш...%Reset%
ipconfig /flushdns >nul 2>&1
if %errorlevel% EQU 0 (call :Ok "DNS-кэш очищен") else (call :Err "DNS")
echo.
echo  %Yellow%Сбрасываю кэш NetBIOS...%Reset%
nbtstat -R >nul 2>&1
nbtstat -RR >nul 2>&1
call :Ok "NetBIOS сброшен"
echo.
echo  %Yellow%Сбрасываю каталог Winsock...%Reset%
netsh winsock reset >nul 2>&1
if %errorlevel% EQU 0 (call :Ok "Winsock сброшен") else (call :Err "Winsock")
echo.
echo  %Yellow%Сбрасываю стек IP...%Reset%
netsh int ip reset >nul 2>&1
call :Ok "IP-стек сброшен"
echo.
echo  %Yellow%Рекомендуется перезагрузить компьютер.%Reset%
call :PauseBack
goto ClnDNSMenu

:ClnWinSxS
call :Hdr "WINSxS — ОЧИСТКА КОМПОНЕНТОВ"
echo  Удаляет заменённые компоненты обновлений.
echo  %Yellow%Может занять 5–30 минут.%Reset%
echo.
set /p "conf=  Продолжить? y/n: "
if /i not "%conf%"=="y" goto CleanMenu
echo.
echo  %Yellow%DISM /StartComponentCleanup...%Reset%
echo.
Dism.exe /Online /Cleanup-Image /StartComponentCleanup
echo.
if %errorlevel% EQU 0 (call :Ok "Очистка WinSxS завершена") else (call :Warn "Код: %errorlevel%")
call :PauseBack
goto CleanMenu

:ClnResetBase
call :Hdr "WINSxS — RESETBASE"
echo  %Red%ВНИМАНИЕ:%Reset%
echo  - Нельзя будет удалить уже установленные обновления
echo  - Операция необратима
echo.
set /p "conf=  Точно продолжить? y/n: "
if /i not "%conf%"=="y" goto CleanMenu
set /p "conf2=  Ещё раз подтвердите (y): "
if /i not "%conf2%"=="y" goto CleanMenu
echo.
Dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
if %errorlevel% EQU 0 (call :Ok "ResetBase выполнен") else (call :Warn "Код: %errorlevel%")
call :PauseBack
goto CleanMenu

:ClnHiber
call :Hdr "ФАЙЛ ГИБЕРНАЦИИ"
echo  hiberfil.sys занимает место ≈ размеру ОЗУ.
echo  %Gray%(Быстрый запуск тоже использует гибернацию.)%Reset%
echo.
echo  %Bold%[1]%Reset%  Выключить гибернацию  (удалить hiberfil.sys)
echo  %Bold%[2]%Reset%  Включить гибернацию
echo  %Bold%[3]%Reset%  Показать статус
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto CleanMenu
if "%choice%"=="1" (
    powercfg /h off
    echo.
    call :Ok "Гибернация выключена, hiberfil.sys удалён"
)
if "%choice%"=="2" (
    powercfg /h on
    echo.
    call :Ok "Гибернация включена"
)
if "%choice%"=="3" (
    echo.
    powercfg /a
    if exist "%SystemDrive%\hiberfil.sys" (
        for %%F in ("%SystemDrive%\hiberfil.sys") do echo  hiberfil.sys: %%~zF байт
    ) else (
        echo  hiberfil.sys: отсутствует
    )
)
call :PauseBack
goto CleanMenu

:ClnRestore
call :Hdr "ТОЧКИ ВОССТАНОВЛЕНИЯ"
echo  %Bold%[1]%Reset%  Показать точки восстановления
echo  %Bold%[2]%Reset%  Удалить ВСЕ точки
echo  %Bold%[3]%Reset%  Удалить все КРОМЕ самой новой
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto CleanMenu
if "%choice%"=="1" (
    echo.
    vssadmin list shadows
)
if "%choice%"=="2" (
    echo.
    echo  %Red%Удалить ВСЕ теневые копии / точки?%Reset%
    set /p "conf=  y/n: "
    if /i "!conf!"=="y" (
        vssadmin delete shadows /all /quiet
        echo.
        call :Ok "Все точки удаления запрошены"
    )
)
if "%choice%"=="3" (
    echo.
        vssadmin delete shadows /for=%SystemDrive% /oldest /quiet 2>nul
        call :Ok "Готово ^(можно повторить, пока не останется одна^)"
)
call :PauseBack
goto CleanMenu

:ClnDelivery
call :Hdr "DELIVERY OPTIMIZATION"
echo  %Yellow%Очищаю кэш оптимизации доставки...%Reset%
echo.
net stop dosvc >nul 2>&1
set "DOC1=%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache"
set "DOC2=%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache"
set "DOC3=%SystemRoot%\SoftwareDistribution\DeliveryOptimization"
if exist "%DOC1%" (
    rd /s /q "%DOC1%" >nul 2>&1
    mkdir "%DOC1%" >nul 2>&1
    call :Ok "NetworkService cache"
) else (
    echo  %Gray%[—]%Reset%  NetworkService cache не найден
)
if exist "%DOC2%" (
    rd /s /q "%DOC2%" >nul 2>&1
    mkdir "%DOC2%" >nul 2>&1
    call :Ok "ProgramData cache"
) else (
    echo  %Gray%[—]%Reset%  ProgramData cache не найден
)
if exist "%DOC3%" (
    del /f /s /q "%DOC3%\*" >nul 2>&1
    call :Ok "SoftwareDistribution\DeliveryOptimization"
)
net start dosvc >nul 2>&1
echo.
call :Ok "Кэш Delivery Optimization очищен"
call :PauseBack
goto CleanMenu

:ClnSafeAll
call :Hdr "БЕЗОПАСНАЯ ОЧИСТКА"
echo  Будет выполнено:
echo    1. WinSxS StartComponentCleanup
echo    2. Delivery Optimization cache
echo.
set /p "conf=  Продолжить? y/n: "
if /i not "%conf%"=="y" goto CleanMenu
echo.
echo  %Yellow%[1/2] WinSxS...%Reset%
Dism.exe /Online /Cleanup-Image /StartComponentCleanup
call :Ok "WinSxS"
echo.
echo  %Yellow%[2/2] Delivery Optimization...%Reset%
net stop dosvc >nul 2>&1
if exist "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" (
    rd /s /q "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" >nul 2>&1
    mkdir "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache" >nul 2>&1
)
if exist "%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache" (
    rd /s /q "%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache" >nul 2>&1
    mkdir "%ProgramData%\Microsoft\Windows\DeliveryOptimization\Cache" >nul 2>&1
)
net start dosvc >nul 2>&1
call :Ok "DO cache"
echo.
echo  %Bold%%Green%ГОТОВО%Reset%
call :PauseBack
goto CleanMenu

:ClnDone
echo.
echo  %Bold%%Green%ГОТОВО%Reset%
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  Для лучшего результата закройте браузеры перед очисткой.
call :PauseBack
goto CleanMenu

rem ========================================================================
rem  4. УДАЛЕНИЕ МУСОРНОГО ПО
rem ========================================================================
:BloatMenu
call :Hdr "УДАЛЕНИЕ МУСОРНОГО ПО"
echo  %Yellow%Сканирование установленных приложений...%Reset%
call :BloatCheck
cls
echo.
echo  %Bold%%Cyan%УДАЛЕНИЕ МУСОРНОГО ПО%Reset%
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
if "!_Cam!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 1]%Reset%  Камера                     : !s!
if "!_Dev!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 2]%Reset%  Центр разработки           : !s!
if "!_Hub!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 3]%Reset%  Центр отзывов              : !s!
if "!_Copilot!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 4]%Reset%  Microsoft 365 Copilot      : !s!
if "!_Bing!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 5]%Reset%  Поиск Microsoft Bing       : !s!
if "!_Clip!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 6]%Reset%  Microsoft Clipchamp        : !s!
if "!_News!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 7]%Reset%  Новости Microsoft          : !s!
if "!_Teams!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 8]%Reset%  Microsoft Teams            : !s!
if "!_ToDo!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[ 9]%Reset%  Microsoft To Do            : !s!
if "!_Outlook!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[10]%Reset%  Outlook                    : !s!
if "!_Power!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[11]%Reset%  Power Automate             : !s!
if "!_Quick!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[12]%Reset%  Быстрая помощь             : !s!
if "!_Sol!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[13]%Reset%  Косынка                    : !s!
if "!_Sound!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[14]%Reset%  Звукозапись                : !s!
if "!_Sticky!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[15]%Reset%  Записки                    : !s!
if "!_Store!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[16]%Reset%  Microsoft Store            : !s!
if "!_Xbox!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[17]%Reset%  Xbox                       : !s!
if "!_Edge!"=="1" (set "s=%Red%Установлено%Reset%") else (set "s=%Green%Удалено%Reset%")
echo  %Bold%[18]%Reset%  Microsoft Edge             : !s!
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[ A]%Reset%  %Green%Удалить всё%Reset%
echo  %Bold%[ 0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" call :RemoveApp "Microsoft.WindowsCamera" & goto BloatMenu
if "%choice%"=="2" call :RemoveApp "Microsoft.Windows.DevHome" & goto BloatMenu
if "%choice%"=="3" call :RemoveApp "Microsoft.WindowsFeedbackHub" & goto BloatMenu
if "%choice%"=="4" goto BloatCopilot
if "%choice%"=="5" goto BloatBing
if "%choice%"=="6" call :RemoveApp "Clipchamp.Clipchamp" & goto BloatMenu
if "%choice%"=="7" call :RemoveApp "Microsoft.BingNews" & goto BloatMenu
if "%choice%"=="8" taskkill /f /im msteams.exe >nul 2>&1 & call :RemoveApp "MSTeams" & goto BloatMenu
if "%choice%"=="9" taskkill /f /im Todo.exe >nul 2>&1 & call :RemoveApp "Microsoft.Todos" & goto BloatMenu
if "%choice%"=="10" taskkill /f /im olk.exe >nul 2>&1 & call :RemoveApp "Microsoft.OutlookForWindows" & goto BloatMenu
if "%choice%"=="11" goto BloatPower
if "%choice%"=="12" call :RemoveApp "MicrosoftCorporationII.QuickAssist" & goto BloatMenu
if "%choice%"=="13" call :RemoveApp "Microsoft.MicrosoftSolitaireCollection" & goto BloatMenu
if "%choice%"=="14" call :RemoveApp "Microsoft.WindowsSoundRecorder" & goto BloatMenu
if "%choice%"=="15" call :RemoveApp "Microsoft.MicrosoftStickyNotes" & goto BloatMenu
if "%choice%"=="16" goto BloatStore
if "%choice%"=="17" goto BloatXbox
if "%choice%"=="18" goto BloatEdge
if /i "%choice%"=="A" goto BloatAll
if "%choice%"=="0" goto MainMenu
goto BloatMenu

:BloatCopilot
echo. & echo  %Red%Удаление Microsoft 365 Copilot...%Reset%
taskkill /f /im msedgewebview2.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f >nul
winget uninstall --name "Microsoft 365 Copilot" --silent --accept-source-agreements >nul 2>&1
winget uninstall --name "Copilot" --silent --accept-source-agreements >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage -AllUsers | Where-Object { $_.Name -match 'Copilot|Windows.Ai' } | ForEach-Object { Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue }" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match 'Copilot|Windows.Ai' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1
timeout /t 2 >nul
goto BloatMenu

:BloatBing
echo. & echo  %Red%Удаление Microsoft Bing...%Reset%
powershell -NoProfile -Command "Get-AppxPackage *BingSearch* -AllUsers | Remove-AppxPackage -AllUsers" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*BingSearch*' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul
timeout /t 1 >nul
goto BloatMenu

:BloatPower
echo. & echo  %Red%Завершение процессов Power Automate...%Reset%
taskkill /f /im PowerAutomate.exe >nul 2>&1
taskkill /f /im PAD.Console.Host.exe >nul 2>&1
taskkill /f /im PAD.DesktopBehavior.exe >nul 2>&1
call :RemoveApp "Microsoft.PowerAutomateDesktop"
goto BloatMenu

:BloatStore
echo. & echo  %Red%Удаление Microsoft Store...%Reset%
call :RemoveApp "Microsoft.WindowsStore"
call :RemoveApp "Microsoft.StorePurchaseApp"
call :RemoveApp "Microsoft.Services.Store.Engagement"
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v RemoveWindowsStore /t REG_DWORD /d 1 /f >nul 2>&1
timeout /t 1 >nul
goto BloatMenu

:BloatXbox
echo. & echo  %Red%Завершение процессов Xbox...%Reset%
taskkill /f /im XboxPcApp.exe >nul 2>&1
taskkill /f /im GameBar.exe >nul 2>&1
taskkill /f /im GameBarFTServer.exe >nul 2>&1
taskkill /f /im GamingServices.exe >nul 2>&1
call :RemoveApp "Microsoft.XboxApp"
call :RemoveApp "Microsoft.GamingApp"
call :RemoveApp "Microsoft.XboxGamingOverlay"
call :RemoveApp "Microsoft.XboxGameOverlay"
call :RemoveApp "Microsoft.XboxIdentityProvider"
call :RemoveApp "Microsoft.XboxSpeechToTextOverlay"
call :RemoveApp "Microsoft.Xbox.TCUI"
timeout /t 1 >nul
goto BloatMenu

:BloatEdge
echo. & echo  %Red%Удаление Microsoft Edge...%Reset%
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im msedgewebview2.exe >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "AllowUninstall" /t REG_DWORD /d 1 /f >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage -Name '*MicrosoftEdge*' -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
winget uninstall --name "Microsoft Edge" --silent --accept-source-agreements >nul 2>&1
powershell -NoProfile -Command "$dirs = @((Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application'), (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application')); $setup = Get-ChildItem -Path $dirs -Filter setup.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1; if ($setup) { Start-Process -FilePath $setup.FullName -ArgumentList '--uninstall','--system-level','--verbose-logging','--force-uninstall' -Wait }" >nul 2>&1
timeout /t 2 >nul
goto BloatMenu

:BloatAll
echo.
echo  %Green%УДАЛЕНИЕ ВСЕХ ПЕРЕЧИСЛЕННЫХ ПРИЛОЖЕНИЙ...%Reset%
echo  %Yellow%Подождите, это займёт около минуты.%Reset%
taskkill /f /im PowerAutomate.exe >nul 2>&1
taskkill /f /im PAD.Console.Host.exe >nul 2>&1
taskkill /f /im PAD.DesktopBehavior.exe >nul 2>&1
taskkill /f /im Todo.exe >nul 2>&1
taskkill /f /im msteams.exe >nul 2>&1
taskkill /f /im olk.exe >nul 2>&1
taskkill /f /im msedgewebview2.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im XboxPcApp.exe >nul 2>&1
taskkill /f /im GameBar.exe >nul 2>&1
taskkill /f /im GameBarFTServer.exe >nul 2>&1
taskkill /f /im GamingServices.exe >nul 2>&1
winget uninstall --name "Microsoft 365 Copilot" --silent --accept-source-agreements >nul 2>&1
winget uninstall --name "Copilot" --silent --accept-source-agreements >nul 2>&1
winget uninstall --name "Microsoft Edge" --silent --accept-source-agreements >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v RemoveWindowsStore /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "AllowUninstall" /t REG_DWORD /d 1 /f >nul 2>&1
powershell -NoProfile -Command "$apps = '*WindowsCamera*,*DevHome*,*WindowsFeedbackHub*,*Clipchamp*,*BingNews*,*MSTeams*,*Todos*,*OutlookForWindows*,*PowerAutomateDesktop*,*QuickAssist*,*SolitaireCollection*,*WindowsSoundRecorder*,*StickyNotes*,*Copilot*,*Windows.Ai*,*BingSearch*,*WindowsStore*,*StorePurchaseApp*,*Xbox*,*MicrosoftEdge*'.Split(','); $prov = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue; foreach($a in $apps){ Get-AppxPackage -Name $a -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; if ($prov) { $prov | Where-Object {$_.DisplayName -like $a} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue } }" >nul 2>&1
powershell -NoProfile -Command "$dirs = @((Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application'), (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application')); $setup = Get-ChildItem -Path $dirs -Filter setup.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1; if ($setup) { Start-Process -FilePath $setup.FullName -ArgumentList '--uninstall','--system-level','--verbose-logging','--force-uninstall' -Wait }" >nul 2>&1
echo.
call :Ok "Готово"
timeout /t 3 >nul
goto BloatMenu

:RemoveApp
echo. & echo  %Red%Удаление %~1...%Reset%
powershell -NoProfile -Command "Get-AppxPackage -Name '*%~1*' -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; $prov = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue; if ($prov) { $prov | Where-Object { $_.DisplayName -like '*%~1*' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue }" >nul 2>&1
exit /b

:BloatCheck
set "_Cam=0" & set "_Dev=0" & set "_Hub=0" & set "_Copilot=0"
set "_Bing=0" & set "_Clip=0" & set "_News=0" & set "_Teams=0"
set "_ToDo=0" & set "_Outlook=0" & set "_Power=0" & set "_Quick=0"
set "_Sol=0" & set "_Sound=0" & set "_Sticky=0"
set "_Store=0" & set "_Xbox=0" & set "_Edge=0"
powershell -NoProfile -Command "Get-AppxPackage -AllUsers | Select-Object -ExpandProperty Name" > "%temp%\apps.txt" 2>nul
if exist "%temp%\apps.txt" (
    findstr /i "WindowsCamera" "%temp%\apps.txt" >nul && set "_Cam=1"
    findstr /i "DevHome" "%temp%\apps.txt" >nul && set "_Dev=1"
    findstr /i "WindowsFeedbackHub" "%temp%\apps.txt" >nul && set "_Hub=1"
    findstr /i "Clipchamp" "%temp%\apps.txt" >nul && set "_Clip=1"
    findstr /i "BingNews" "%temp%\apps.txt" >nul && set "_News=1"
    findstr /i "MSTeams" "%temp%\apps.txt" >nul && set "_Teams=1"
    findstr /i "Todos" "%temp%\apps.txt" >nul && set "_ToDo=1"
    findstr /i "OutlookForWindows" "%temp%\apps.txt" >nul && set "_Outlook=1"
    findstr /i "PowerAutomateDesktop" "%temp%\apps.txt" >nul && set "_Power=1"
    findstr /i "QuickAssist" "%temp%\apps.txt" >nul && set "_Quick=1"
    findstr /i "SolitaireCollection" "%temp%\apps.txt" >nul && set "_Sol=1"
    findstr /i "WindowsSoundRecorder" "%temp%\apps.txt" >nul && set "_Sound=1"
    findstr /i "StickyNotes" "%temp%\apps.txt" >nul && set "_Sticky=1"
    findstr /i "WindowsStore" "%temp%\apps.txt" >nul && set "_Store=1"
    findstr /i "Xbox" "%temp%\apps.txt" >nul && set "_Xbox=1"
    findstr /i "Copilot Windows.Ai" "%temp%\apps.txt" >nul && set "_Copilot=1"
    del "%temp%\apps.txt" >nul 2>&1
)
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "_Edge=1"
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "_Edge=1"
reg query "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions >nul 2>&1
if %errorlevel% EQU 0 (set "_Bing=0") else (set "_Bing=1")
exit /b

rem ========================================================================
rem  5. ПРИВАТНОСТЬ
rem ========================================================================
:PrivMenu
call :Hdr "ПРИВАТНОСТЬ, ТЕЛЕМЕТРИЯ, УВЕДОМЛЕНИЯ"
echo  %Bold%[1]%Reset%  Телеметрия и реклама
echo  %Bold%[2]%Reset%  Уведомления и советы
echo  %Bold%[3]%Reset%  Фоновые UWP-приложения
echo  %Bold%[4]%Reset%  Планировщик: телеметрия / CEIP
echo  %Bold%[5]%Reset%  Windows Copilot AI
echo  %Bold%[6]%Reset%  Оптимизация доставки
echo  %Bold%[7]%Reset%  Тихий режим  (всё сразу)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto TeleMenu
if "%choice%"=="2" goto NotifyMenu
if "%choice%"=="3" goto UWPMenu
if "%choice%"=="4" goto TasksMenu
if "%choice%"=="5" goto CopilotMenu
if "%choice%"=="6" goto DOMenu
if "%choice%"=="7" goto QuietAll
if "%choice%"=="0" goto MainMenu
goto PrivMenu

:TeleMenu
call :Hdr "ТЕЛЕМЕТРИЯ И РЕКЛАМА"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto TeleOff
if "%choice%"=="2" goto TeleOn
if "%choice%"=="0" goto PrivMenu
goto TeleMenu

:TeleOff
echo.
echo  %Yellow%Отключение телеметрии и рекламы...%Reset%
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Input\TIPC" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v PreventHandwritingDataSharing /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v PreventHandwritingErrorReports /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreenCamera /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
call :Ok "Телеметрия и реклама отключены"
call :PauseBack
goto TeleMenu

:TeleOn
echo.
echo  %Yellow%Включение телеметрии и рекламы...%Reset%
sc config DiagTrack start= auto >nul 2>&1
sc start DiagTrack >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v CEIPEnable /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Input\TIPC" /v Enabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v PreventHandwritingDataSharing /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v PreventHandwritingErrorReports /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreenCamera /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /f >nul 2>&1
call :Ok "Телеметрия и реклама включены"
call :PauseBack
goto TeleMenu

:NotifyMenu
call :Hdr "УВЕДОМЛЕНИЯ И СОВЕТЫ"
echo  %Bold%[1]%Reset%  Отключить советы и предложения Windows
echo  %Bold%[2]%Reset%  Включить советы
echo  %Bold%[3]%Reset%  Отключить уведомления приложений
echo  %Bold%[4]%Reset%  Включить уведомления приложений
echo  %Bold%[5]%Reset%  Отключить «Предложить способы завершения настройки»
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PrivMenu
if "%choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul
    echo. & call :Ok "Советы и предложения отключены"
)
if "%choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 1 /f >nul
    echo. & call :Ok "Советы включены"
)
if "%choice%"=="3" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul
    echo. & call :Ok "Уведомления / центр отключены"
    echo  %Yellow%Может потребоваться выход из системы.%Reset%
)
if "%choice%"=="4" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 1 /f >nul
    reg delete "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /f >nul 2>&1
    echo. & call :Ok "Уведомления включены"
)
if "%choice%"=="5" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul
    echo. & call :Ok "«Завершение настройки» отключено"
)
call :PauseBack
goto NotifyMenu

:UWPMenu
call :Hdr "ФОНОВЫЕ UWP-ПРИЛОЖЕНИЯ"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PrivMenu
if "%choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f >nul
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\embeddedmode" /v Start /t REG_DWORD /d 4 /f >nul
    echo. & call :Ok "Фоновые UWP отключены"
)
if "%choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 1 /f >nul
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\embeddedmode" /v Start /t REG_DWORD /d 3 /f >nul
    echo. & call :Ok "Фоновые UWP включены"
)
call :PauseBack
goto UWPMenu

:TasksMenu
call :Hdr "ПЛАНИРОВЩИК — ТЕЛЕМЕТРИЯ / CEIP"
echo  %Bold%[1]%Reset%  Отключить задачи телеметрии и CEIP
echo  %Bold%[2]%Reset%  Включить задачи обратно
echo  %Bold%[3]%Reset%  Показать статус задач
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PrivMenu
if "%choice%"=="1" goto TasksOff
if "%choice%"=="2" goto TasksOn
if "%choice%"=="3" goto TasksShow
goto TasksMenu

:TasksOff
echo.
echo  %Yellow%Отключаю задачи...%Reset%
echo.
call :DisTask "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
call :DisTask "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
call :DisTask "\Microsoft\Windows\Application Experience\StartupAppTask"
call :DisTask "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
call :DisTask "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
call :DisTask "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
call :DisTask "\Microsoft\Windows\Feedback\Siuf\DmClient"
call :DisTask "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
call :DisTask "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
call :DisTask "\Microsoft\Windows\Autochk\Proxy"
call :DisTask "\Microsoft\Windows\PI\Sqm-Tasks"
call :DisTask "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
call :DisTask "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
call :DisTask "\Microsoft\Windows\Maps\MapsUpdateTask"
call :DisTask "\Microsoft\Windows\Maps\MapsToastTask"
echo.
call :Ok "Готово"
call :PauseBack
goto TasksMenu

:TasksOn
echo.
echo  %Yellow%Включаю задачи...%Reset%
echo.
call :EnTask "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
call :EnTask "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
call :EnTask "\Microsoft\Windows\Application Experience\StartupAppTask"
call :EnTask "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
call :EnTask "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
call :EnTask "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
call :EnTask "\Microsoft\Windows\Feedback\Siuf\DmClient"
call :EnTask "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
call :EnTask "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
echo.
call :Ok "Готово"
call :PauseBack
goto TasksMenu

:TasksShow
echo.
schtasks /query /fo LIST 2>nul | findstr /i /c:"Microsoft Compatibility Appraiser" /c:"ProgramDataUpdater" /c:"Consolidator" /c:"UsbCeip" /c:"DmClient" /c:"QueueReporting" /c:"DiskDiagnosticDataCollector" /c:"Status:" /c:"TaskName:"
echo.
echo  %Gray%(полный список — в Планировщике заданий)%Reset%
call :PauseBack
goto TasksMenu

:DisTask
schtasks /Change /TN "%~1" /Disable >nul 2>&1
if errorlevel 1 (echo  %Gray%[нет]%Reset%  %~1) else (echo  %Red%[выкл]%Reset%  %~nx1)
exit /b

:EnTask
schtasks /Change /TN "%~1" /Enable >nul 2>&1
if errorlevel 1 (echo  %Gray%[нет]%Reset%  %~1) else (echo  %Green%[вкл]%Reset%  %~nx1)
exit /b

:CopilotMenu
call :Hdr "WINDOWS COPILOT AI"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PrivMenu
if "%choice%"=="1" (
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1
    echo. & call :Ok "Windows Copilot AI отключён"
)
if "%choice%"=="2" (
    reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /f >nul 2>&1
    reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /f >nul 2>&1
    echo. & call :Ok "Windows Copilot AI включён"
)
call :PauseBack
goto CopilotMenu

:DOMenu
call :Hdr "ОПТИМИЗАЦИЯ ДОСТАВКИ"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PrivMenu
if "%choice%"=="1" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f >nul 2>&1
    sc config DoSvc start= disabled >nul 2>&1
    net stop DoSvc >nul 2>&1
    echo. & call :Ok "Оптимизация доставки отключена"
)
if "%choice%"=="2" (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /f >nul 2>&1
    sc config DoSvc start= demand >nul 2>&1
    net start DoSvc >nul 2>&1
    echo. & call :Ok "Оптимизация доставки включена"
)
call :PauseBack
goto DOMenu

:QuietAll
call :Hdr "ТИХИЙ РЕЖИМ"
echo  Отключит:
echo    - советы и предложения Windows
echo    - фоновые UWP
echo    - задачи телеметрии / CEIP / Feedback
echo    - телеметрию DiagTrack
echo    - Copilot
echo.
set /p "conf=  Продолжить? y/n: "
if /i not "%conf%"=="y" goto PrivMenu
echo.
echo  %Yellow%Советы...%Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul
call :Ok "советы"
echo  %Yellow%Фоновые UWP...%Reset%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
call :Ok "UWP"
echo  %Yellow%Планировщик...%Reset%
call :DisTask "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
call :DisTask "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
call :DisTask "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
call :DisTask "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
call :DisTask "\Microsoft\Windows\Feedback\Siuf\DmClient"
call :DisTask "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
call :DisTask "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
call :DisTask "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
echo  %Yellow%DiagTrack / Copilot...%Reset%
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
call :Ok "DiagTrack / Copilot"
echo.
echo  %Bold%%Green%ГОТОВО%Reset%
call :PauseBack
goto PrivMenu

rem ========================================================================
rem  6. СЛУЖБЫ WINDOWS
rem ========================================================================
:SvcMenu
call :Hdr "СЛУЖБЫ WINDOWS"
echo  %Gray%  %Green%[раб.]%Reset% работает  %Yellow%[ручн.]%Reset% вручную  %Red%[откл.]%Reset% отключена  %Gray%[нет]%Reset%
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
call :PrintStatus 1  SysMain              "SysMain Superfetch"
call :PrintStatus 2  DiagTrack            "DiagTrack телеметрия"
call :PrintStatus 3  dmwappushservice     "dmwappush телеметрия"
call :PrintStatus 4  WSearch              "Windows Search"
call :PrintStatus 5  Fax                  "Факс"
call :PrintStatus 6  XblAuthManager       "Xbox Live Auth"
call :PrintStatus 7  XblGameSave          "Xbox Live Game Save"
call :PrintStatus 8  XboxGipSvc           "Xbox Accessory"
call :PrintStatus 9  XboxNetApiSvc        "Xbox Networking"
call :PrintStatus 10 RemoteRegistry       "Remote Registry"
call :PrintStatus 11 RemoteAccess         "Routing Remote Access"
call :PrintStatus 12 WbioSrvc             "Биометрия"
call :PrintStatus 13 TabletInputService   "Сенсорная клавиатура"
call :PrintStatus 14 MapsBroker           "Карты"
call :PrintStatus 15 RetailDemo           "Retail Demo"
call :PrintStatus 16 wisvc                "Windows Insider"
call :PrintStatus 17 WerSvc               "Отчёты об ошибках"
call :PrintStatus 18 PcaSvc               "Совместимость"
call :PrintStatus 19 PrintNotify          "Уведомления печати"
call :PrintStatus 20 Spooler              "Диспетчер печати"
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[A]%Reset%  Отключить все     %Bold%[B]%Reset%  Включить все
echo  %Bold%[R]%Reset%  Откат             %Bold%[S]%Reset%  Сохранить текущие
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if /i "%choice%"=="0" goto MainMenu
if /i "%choice%"=="A" goto SvcDisableAll
if /i "%choice%"=="B" goto SvcEnableAll
if /i "%choice%"=="R" goto SvcRestore
if /i "%choice%"=="S" goto SvcSaveBackup
if "%choice%"=="1"  call :ToggleSvc SysMain
if "%choice%"=="2"  call :ToggleSvc DiagTrack
if "%choice%"=="3"  call :ToggleSvc dmwappushservice
if "%choice%"=="4"  call :ToggleSvc WSearch
if "%choice%"=="5"  call :ToggleSvc Fax
if "%choice%"=="6"  call :ToggleSvc XblAuthManager
if "%choice%"=="7"  call :ToggleSvc XblGameSave
if "%choice%"=="8"  call :ToggleSvc XboxGipSvc
if "%choice%"=="9"  call :ToggleSvc XboxNetApiSvc
if "%choice%"=="10" call :ToggleSvc RemoteRegistry
if "%choice%"=="11" call :ToggleSvc RemoteAccess
if "%choice%"=="12" call :ToggleSvc WbioSrvc
if "%choice%"=="13" call :ToggleSvc TabletInputService
if "%choice%"=="14" call :ToggleSvc MapsBroker
if "%choice%"=="15" call :ToggleSvc RetailDemo
if "%choice%"=="16" call :ToggleSvc wisvc
if "%choice%"=="17" call :ToggleSvc WerSvc
if "%choice%"=="18" call :ToggleSvc PcaSvc
if "%choice%"=="19" call :ToggleSvc PrintNotify
if "%choice%"=="20" call :ToggleSvc Spooler
goto SvcMenu

:PrintStatus
set "NUM=%~1"
set "SVC=%~2"
set "NAM=%~3"
set "TAG=%Gray%[нет ]%Reset%"
sc query "%SVC%" >nul 2>&1
if errorlevel 1 (
    if %NUM% LSS 10 (echo  %Bold%[ %NUM%]%Reset%  !TAG!  %NAM%) else (echo  %Bold%[%NUM%]%Reset%  !TAG!  %NAM%)
    exit /b
)
set "TAG=%Yellow%[ручн.]%Reset%"
sc qc "%SVC%" 2>nul | findstr /i "DISABLED" >nul 2>&1
if not errorlevel 1 set "TAG=%Red%[откл.]%Reset%"
sc qc "%SVC%" 2>nul | findstr /i "AUTO_START" >nul 2>&1
if not errorlevel 1 (
    sc query "%SVC%" 2>nul | findstr /i "RUNNING" >nul 2>&1
    if not errorlevel 1 (set "TAG=%Green%[раб. ]%Reset%") else (set "TAG=%Yellow%[стоп.]%Reset%")
)
sc query "%SVC%" 2>nul | findstr /i "RUNNING" >nul 2>&1
if not errorlevel 1 (
    sc qc "%SVC%" 2>nul | findstr /i "DISABLED" >nul 2>&1
    if errorlevel 1 set "TAG=%Green%[раб. ]%Reset%"
)
if %NUM% LSS 10 (echo  %Bold%[ %NUM%]%Reset%  !TAG!  %NAM%) else (echo  %Bold%[%NUM%]%Reset%  !TAG!  %NAM%)
exit /b

:ToggleSvc
set "SVC=%~1"
call :EnsureBackup
sc query "%SVC%" >nul 2>&1
if errorlevel 1 (
    echo.
    echo  %Gray%Служба %SVC% отсутствует.%Reset%
    timeout /t 1 >nul
    exit /b
)
sc qc "%SVC%" 2>nul | findstr /i "DISABLED" >nul 2>&1
if not errorlevel 1 (
    sc config "%SVC%" start= demand >nul 2>&1
    sc start "%SVC%" >nul 2>&1
    echo. & echo  %Green%[вкл]%Reset%  %SVC%
) else (
    sc stop "%SVC%" >nul 2>&1
    sc config "%SVC%" start= disabled >nul 2>&1
    echo. & echo  %Red%[откл]%Reset%  %SVC%
)
timeout /t 1 >nul
exit /b

:SvcDisableAll
call :EnsureBackup
call :Hdr "ОТКЛЮЧЕНИЕ СЛУЖБ"
call :DisSvc SysMain
call :DisSvc DiagTrack
call :DisSvc dmwappushservice
call :DisSvc WSearch
call :DisSvc Fax
call :DisSvc XblAuthManager
call :DisSvc XblGameSave
call :DisSvc XboxGipSvc
call :DisSvc XboxNetApiSvc
call :DisSvc RemoteRegistry
call :DisSvc RemoteAccess
call :DisSvc WbioSrvc
call :DisSvc TabletInputService
call :DisSvc MapsBroker
call :DisSvc RetailDemo
call :DisSvc wisvc
call :DisSvc WerSvc
call :DisSvc PcaSvc
call :DisSvc PrintNotify
call :DisSvc Spooler
echo.
call :Ok "Готово"
call :PauseBack
goto SvcMenu

:SvcEnableAll
call :EnsureBackup
call :Hdr "ВКЛЮЧЕНИЕ СЛУЖБ"
call :EnSvc SysMain
call :EnSvc DiagTrack
call :EnSvc dmwappushservice
call :EnSvc WSearch
call :EnSvc Fax
call :EnSvc XblAuthManager
call :EnSvc XblGameSave
call :EnSvc XboxGipSvc
call :EnSvc XboxNetApiSvc
call :EnSvc RemoteRegistry
call :EnSvc RemoteAccess
call :EnSvc WbioSrvc
call :EnSvc TabletInputService
call :EnSvc MapsBroker
call :EnSvc RetailDemo
call :EnSvc wisvc
call :EnSvc WerSvc
call :EnSvc PcaSvc
call :EnSvc PrintNotify
call :EnSvc Spooler
echo.
call :Ok "Готово"
call :PauseBack
goto SvcMenu

:DisSvc
set "SVC=%~1"
sc query "%SVC%" >nul 2>&1
if errorlevel 1 (echo  %Gray%[нет]%Reset%  %SVC% & exit /b)
sc stop "%SVC%" >nul 2>&1
sc config "%SVC%" start= disabled >nul 2>&1
if errorlevel 1 (echo  %Red%[X]%Reset%    %SVC%) else (echo  %Red%[откл]%Reset%  %SVC%)
exit /b

:EnSvc
set "SVC=%~1"
sc query "%SVC%" >nul 2>&1
if errorlevel 1 (echo  %Gray%[нет]%Reset%  %SVC% & exit /b)
sc config "%SVC%" start= demand >nul 2>&1
sc start "%SVC%" >nul 2>&1
echo  %Green%[вкл]%Reset%  %SVC%
exit /b

:EnsureBackup
if exist "%BACKUP_SVC%" exit /b
call :WriteBackup
exit /b

:SvcSaveBackup
call :WriteBackup
echo.
call :Ok "Сохранено: %BACKUP_SVC%"
call :PauseBack
goto SvcMenu

:WriteBackup
if exist "%BACKUP_SVC%" del /f /q "%BACKUP_SVC%" >nul 2>&1
call :BakSvc SysMain
call :BakSvc DiagTrack
call :BakSvc dmwappushservice
call :BakSvc WSearch
call :BakSvc Fax
call :BakSvc XblAuthManager
call :BakSvc XblGameSave
call :BakSvc XboxGipSvc
call :BakSvc XboxNetApiSvc
call :BakSvc RemoteRegistry
call :BakSvc RemoteAccess
call :BakSvc WbioSrvc
call :BakSvc TabletInputService
call :BakSvc MapsBroker
call :BakSvc RetailDemo
call :BakSvc wisvc
call :BakSvc WerSvc
call :BakSvc PcaSvc
call :BakSvc PrintNotify
call :BakSvc Spooler
exit /b

:BakSvc
set "SVC=%~1"
sc query "%SVC%" >nul 2>&1
if errorlevel 1 exit /b
set "ST=demand"
sc qc "%SVC%" 2>nul | findstr /i "DISABLED" >nul 2>&1 && set "ST=disabled"
sc qc "%SVC%" 2>nul | findstr /i "AUTO_START" >nul 2>&1 && set "ST=auto"
sc qc "%SVC%" 2>nul | findstr /i "DEMAND_START" >nul 2>&1 && set "ST=demand"
echo %SVC%=%ST%>>"%BACKUP_SVC%"
exit /b

:SvcRestore
if not exist "%BACKUP_SVC%" (
    echo.
    call :Warn "Нет файла отката. Сначала измените службы или нажмите S."
    call :PauseBack
    goto SvcMenu
)
call :Hdr "ОТКАТ СЛУЖБ"
echo  Файл: %BACKUP_SVC%
echo.
for /f "usebackq tokens=1,2 delims==" %%a in ("%BACKUP_SVC%") do (
    sc config "%%a" start= %%b >nul 2>&1
    if /i "%%b"=="disabled" sc stop "%%a" >nul 2>&1
    if /i "%%b"=="auto" sc start "%%a" >nul 2>&1
    echo  %Green%[OK]%Reset%  %%a  -^>  %%b
)
echo.
call :Ok "Откат выполнен"
call :PauseBack
goto SvcMenu

rem ========================================================================
rem  7. АВТОЗАГРУЗКА
rem ========================================================================
:StartUpMenu
call :Hdr "АВТОЗАГРУЗКА ПРОГРАММ"
echo  %Bold%[1]%Reset%  Показать все элементы автозагрузки
echo  %Bold%[2]%Reset%  Отключить элемент  (по номеру)
echo  %Bold%[3]%Reset%  Включить обратно из резерва
echo  %Bold%[4]%Reset%  Открыть папки Startup
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto SUShow
if "%choice%"=="2" goto SUDisable
if "%choice%"=="3" goto SUEnable
if "%choice%"=="4" goto SUFolders
if "%choice%"=="0" goto MainMenu
goto StartUpMenu

:SUShow
call :Hdr "СПИСОК АВТОЗАГРУЗКИ"
echo  %Yellow%Сканирую реестр и папки Startup...%Reset%
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$n=1; $items=@(); " ^
  "function AddItem($src,$name,$cmd) { $script:items += [PSCustomObject]@{N=$script:n; Src=$src; Name=$name; Cmd=$cmd}; $script:n++ }; " ^
  "$paths=@(" ^
  "  @{Hive='HKCU'; Path='Software\Microsoft\Windows\CurrentVersion\Run'; Label='HKCU Run'}, " ^
  "  @{Hive='HKLM'; Path='Software\Microsoft\Windows\CurrentVersion\Run'; Label='HKLM Run'}, " ^
  "  @{Hive='HKCU'; Path='Software\Microsoft\Windows\CurrentVersion\RunOnce'; Label='HKCU RunOnce'}, " ^
  "  @{Hive='HKLM'; Path='Software\Microsoft\Windows\CurrentVersion\RunOnce'; Label='HKLM RunOnce'}" ^
  "); " ^
  "foreach($p in $paths) { " ^
  "  try { " ^
  "    if($p.Hive -eq 'HKCU') { $key=[Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($p.Path) } " ^
  "    else { $key=[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($p.Path) }; " ^
  "    if($key) { foreach($v in $key.GetValueNames()) { $val=$key.GetValue($v); if($val){ AddItem $p.Label $v $val } }; $key.Close() } " ^
  "  } catch {} " ^
  "}; " ^
  "$folders=@(" ^
  "  @{Path=[Environment]::GetFolderPath('Startup'); Label='Startup User'}, " ^
  "  @{Path=[Environment]::GetFolderPath('CommonStartup'); Label='Startup Common'}" ^
  "); " ^
  "foreach($f in $folders) { " ^
  "  if(Test-Path $f.Path) { " ^
  "    Get-ChildItem $f.Path -Force -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '\.(lnk|exe|bat|cmd)$' -or $_.Name -like '*.lnk' } | ForEach-Object { " ^
  "      AddItem $f.Label $_.Name $_.FullName " ^
  "    } " ^
  "  } " ^
  "}; " ^
  "if($items.Count -eq 0) { Write-Host '  (пусто)' -ForegroundColor DarkGray } " ^
  "else { " ^
  "  foreach($i in $items) { " ^
  "    Write-Host ('  [' + $i.N + '] ') -NoNewline -ForegroundColor White; " ^
  "    Write-Host ($i.Src + '') -NoNewline -ForegroundColor DarkGray; " ^
  "    Write-Host ''; " ^
  "    Write-Host ('      ' + $i.Name) -ForegroundColor Cyan; " ^
  "    $c=$i.Cmd; if($c.Length -gt 70){ $c=$c.Substring(0,67)+'...' }; " ^
  "    Write-Host ('      ' + $c) -ForegroundColor DarkGray; " ^
  "  } " ^
  "}; " ^
  "$items | ForEach-Object { $_.N.ToString() + '|' + $_.Src + '|' + $_.Name + '|' + $_.Cmd } | Out-File -FilePath $env:TEMP\startup_list.txt -Encoding utf8"
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Yellow%[0]%Reset%  Вернуться в меню
echo.
set /p "back=  Выбор: "
goto StartUpMenu

:SUDisable
call :Hdr "ОТКЛЮЧЕНИЕ ЭЛЕМЕНТА"
if not exist "%LIST_STARTUP%" (
    call :Warn "Сначала выполните пункт [1] — показать список."
    call :PauseBack
    goto StartUpMenu
)
echo  %Gray%Введите номер элемента из списка [1].%Reset%
echo.
set /p "num=  Номер: "
if "%num%"=="" goto StartUpMenu
if "%num%"=="0" goto StartUpMenu
set "FOUND="
for /f "usebackq tokens=1,2,3* delims=|" %%a in ("%LIST_STARTUP%") do (
    if "%%a"=="%num%" (
        set "FOUND=1"
        set "SRC=%%b"
        set "NAME=%%c"
        set "CMD=%%d"
    )
)
if not defined FOUND (
    echo.
    call :Err "Номер не найден."
    call :PauseBack
    goto StartUpMenu
)
echo.
echo  Источник:  %SRC%
echo  Имя:       %NAME%
echo.
echo  %Yellow%Отключить этот элемент?%Reset%
set /p "conf=  y/n: "
if /i not "%conf%"=="y" goto StartUpMenu
if not exist "%BACKUP_STARTUP%" mkdir "%BACKUP_STARTUP%" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$src='%SRC%'; $name='%NAME%'; $cmd='%CMD%'; $bak='%BACKUP_STARTUP%'; " ^
  "try { " ^
  "  if($src -eq 'HKCU Run') { " ^
  "    $val=(Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name $name -EA Stop).$name; " ^
  "    $val | Out-File (Join-Path $bak ('HKCU_Run_'+($name -replace '[^\w\-]','_')+'.txt')) -Encoding utf8; " ^
  "    Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name $name -Force; " ^
  "    Write-Host '  OK: удалён из HKCU Run' -ForegroundColor Green " ^
  "  } elseif($src -eq 'HKLM Run') { " ^
  "    $val=(Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name $name -EA Stop).$name; " ^
  "    $val | Out-File (Join-Path $bak ('HKLM_Run_'+($name -replace '[^\w\-]','_')+'.txt')) -Encoding utf8; " ^
  "    Remove-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name $name -Force; " ^
  "    Write-Host '  OK: удалён из HKLM Run' -ForegroundColor Green " ^
  "  } elseif($src -eq 'HKCU RunOnce') { " ^
  "    Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $name -Force -EA Stop; " ^
  "    Write-Host '  OK: удалён из HKCU RunOnce' -ForegroundColor Green " ^
  "  } elseif($src -eq 'HKLM RunOnce') { " ^
  "    Remove-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $name -Force -EA Stop; " ^
  "    Write-Host '  OK: удалён из HKLM RunOnce' -ForegroundColor Green " ^
  "  } elseif($src -match 'Startup') { " ^
  "    if(Test-Path -LiteralPath $cmd) { " ^
  "      $dest=Join-Path $bak (Split-Path $cmd -Leaf); " ^
  "      Move-Item -LiteralPath $cmd -Destination $dest -Force; " ^
  "      Write-Host '  OK: ярлык перемещён в резерв' -ForegroundColor Green " ^
  "    } else { Write-Host '  Файл не найден' -ForegroundColor Yellow } " ^
  "  } else { Write-Host '  Неизвестный источник' -ForegroundColor Yellow } " ^
  "} catch { Write-Host ('  ОШИБКА: '+$_.Exception.Message) -ForegroundColor Red }"
call :PauseBack
goto StartUpMenu

:SUEnable
call :Hdr "ВКЛЮЧЕНИЕ ИЗ РЕЗЕРВА"
if not exist "%BACKUP_STARTUP%" (
    call :Warn "Папка резерва пуста."
    call :PauseBack
    goto StartUpMenu
)
echo  %Yellow%Содержимое резерва:%Reset%
echo.
dir /b "%BACKUP_STARTUP%" 2>nul
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
echo  Восстановить все элементы из резерва?
set /p "conf=  y/n: "
if /i not "%conf%"=="y" goto StartUpMenu
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$bak='%BACKUP_STARTUP%'; " ^
  "Get-ChildItem $bak -File -EA SilentlyContinue | ForEach-Object { " ^
  "  if($_.Name -like 'HKCU_Run_*.txt') { " ^
  "    $name=$_.BaseName -replace '^HKCU_Run_',''; " ^
  "    $val=(Get-Content $_.FullName -Raw).Trim(); " ^
  "    if($val){ Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name $name -Value $val -Force; Write-Host ('  OK HKCU: '+$name) -ForegroundColor Green } " ^
  "  } elseif($_.Name -like 'HKLM_Run_*.txt') { " ^
  "    $name=$_.BaseName -replace '^HKLM_Run_',''; " ^
  "    $val=(Get-Content $_.FullName -Raw).Trim(); " ^
  "    if($val){ Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name $name -Value $val -Force; Write-Host ('  OK HKLM: '+$name) -ForegroundColor Green } " ^
  "  } elseif($_.Extension -eq '.lnk' -or $_.Extension -eq '.exe') { " ^
  "    $dest=Join-Path ([Environment]::GetFolderPath('Startup')) $_.Name; " ^
  "    Move-Item -LiteralPath $_.FullName -Destination $dest -Force -EA SilentlyContinue; " ^
  "    Write-Host ('  OK Startup: '+$_.Name) -ForegroundColor Green " ^
  "  } " ^
  "}; " ^
  "Write-Host ''; Write-Host '  Готово.' -ForegroundColor Cyan"
call :PauseBack
goto StartUpMenu

:SUFolders
explorer shell:startup
explorer shell:common startup
goto StartUpMenu

rem ========================================================================
rem  8. ПИТАНИЕ, ПАМЯТЬ, CPU
rem ========================================================================
:PerfMenu
call :Hdr "ПИТАНИЕ, ПАМЯТЬ, CPU"
echo  %Bold%[1]%Reset%  План электропитания
echo  %Bold%[2]%Reset%  Гибернация
echo  %Bold%[3]%Reset%  Быстрый запуск
echo  %Bold%[4]%Reset%  Файл подкачки
echo  %Bold%[5]%Reset%  Максимум CPU и ОЗУ  (bcdedit)
echo  %Bold%[6]%Reset%  Температура и лимиты питания CPU
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto PowerMenu
if "%choice%"=="2" goto HiberMenu
if "%choice%"=="3" goto FastBootMenu
if "%choice%"=="4" goto PFMenu
if "%choice%"=="5" goto CPUMaxMenu
if "%choice%"=="6" goto CPULimMenu
if "%choice%"=="0" goto MainMenu
goto PerfMenu

:PowerMenu
call :Hdr "ПЛАН ЭЛЕКТРОПИТАНИЯ"
echo  %Bold%[1]%Reset%  Высокая производительность
echo  %Bold%[2]%Reset%  Максимальная производительность
echo  %Bold%[3]%Reset%  Сбалансированный
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PerfMenu
if "%choice%"=="1" (
    echo.
    echo  %Yellow%Включение плана "Высокая производительность"...%Reset%
    powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c|High|\u0412\u044b\u0441\u043e\u043a\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid; $remove = $schemes | Select-Object -Skip 1; if ($remove) { foreach ($s in $remove) { $delGuid = $s -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /delete $delGuid } } }" >nul 2>&1
    call :Ok "План установлен"
)
if "%choice%"=="2" (
    echo.
    echo  %Yellow%Включение плана "Максимальная производительность"...%Reset%
    powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match 'e9a42b02-d5df-448d-aa00-03f14749eb61|Ultimate|\u041c\u0430\u043a\u0441\u0438\u043c\u0430\u043b\u044c\u043d\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid; $remove = $schemes | Select-Object -Skip 1; if ($remove) { foreach ($s in $remove) { $delGuid = $s -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /delete $delGuid } } }" >nul 2>&1
    call :Ok "План установлен"
)
if "%choice%"=="3" (
    echo.
    echo  %Yellow%Включение плана "Сбалансированный"...%Reset%
    powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match '381b4222-f694-41f0-9685-ff5bb260df2e|Balanced|\u0421\u0431\u0430\u043b\u0430\u043d\u0441\u0438\u0440\u043e\u0432\u0430\u043d\u043d\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid; $remove = $schemes | Select-Object -Skip 1; if ($remove) { foreach ($s in $remove) { $delGuid = $s -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /delete $delGuid } } }" >nul 2>&1
    call :Ok "План установлен"
)
call :PauseBack
goto PowerMenu

:HiberMenu
call :Hdr "ГИБЕРНАЦИЯ"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PerfMenu
if "%choice%"=="1" (
    powercfg /h off >nul 2>&1
    echo. & call :Ok "Гибернация отключена"
)
if "%choice%"=="2" (
    powercfg /h on >nul 2>&1
    echo. & call :Ok "Гибернация включена"
)
call :PauseBack
goto HiberMenu

:FastBootMenu
call :Hdr "БЫСТРЫЙ ЗАПУСК"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto PerfMenu
if "%choice%"=="1" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    echo. & call :Ok "Быстрый запуск отключён"
)
if "%choice%"=="2" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f >nul 2>&1
    echo. & call :Ok "Быстрый запуск включён"
)
call :PauseBack
goto FastBootMenu

:PFMenu
call :Hdr "ФАЙЛ ПОДКАЧКИ"
echo  %Bold%[1]%Reset%  4 ГБ ОЗУ   -^>  6144 МБ  %Gray%(6 ГБ)%Reset%
echo  %Bold%[2]%Reset%  8 ГБ ОЗУ   -^>  8192 МБ  %Gray%(8 ГБ)%Reset%
echo  %Bold%[3]%Reset%  16 ГБ ОЗУ  -^>  4096 МБ  %Gray%(4 ГБ)%Reset%
echo  %Bold%[4]%Reset%  32 ГБ ОЗУ  -^>  2048 МБ  %Gray%(2 ГБ)%Reset%
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[5]%Reset%  Показать текущие настройки
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" call :PFApply 6144 & goto PFMenu
if "%choice%"=="2" call :PFApply 8192 & goto PFMenu
if "%choice%"=="3" call :PFApply 4096 & goto PFMenu
if "%choice%"=="4" call :PFApply 2048 & goto PFMenu
if "%choice%"=="5" goto PFShow
if "%choice%"=="0" goto PerfMenu
goto PFMenu

:PFShow
call :Hdr "ТЕКУЩИЕ НАСТРОЙКИ ПОДКАЧКИ"
powershell -NoProfile -Command "try { $pf = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -ErrorAction Stop).PagingFiles; Write-Host ('  PagingFiles : ' + $pf) } catch { Write-Host '  PagingFiles : (не задано)' }; $auto = (Get-CimInstance Win32_ComputerSystem).AutomaticManagedPagefile; Write-Host ('  Automatic   : ' + $auto)"
echo.
echo  %Yellow%Изменения вступают в силу после перезагрузки.%Reset%
call :PauseBack
goto PFMenu

:PFApply
set "Size=%~1"
set "PS1=%TEMP%\setpf_%RANDOM%.ps1"
call :Hdr "УСТАНОВКА ФАЙЛА ПОДКАЧКИ"
echo  %Yellow%Размер: %Size% МБ%Reset%
echo.
echo  Подождите...
echo.
> "%PS1%" echo $ErrorActionPreference = 'Stop'
>> "%PS1%" echo try {
>> "%PS1%" echo   $size = %Size%
>> "%PS1%" echo   $cs = Get-CimInstance -ClassName Win32_ComputerSystem
>> "%PS1%" echo   if ($cs.AutomaticManagedPagefile) {
>> "%PS1%" echo     $cs.AutomaticManagedPagefile = $false
>> "%PS1%" echo     Set-CimInstance -InputObject $cs
>> "%PS1%" echo     Write-Host '  [1/3] Автоматическое управление отключено' -ForegroundColor Green
>> "%PS1%" echo   } else {
>> "%PS1%" echo     Write-Host '  [1/3] Автоматическое управление уже отключено' -ForegroundColor Green
>> "%PS1%" echo   }
>> "%PS1%" echo   $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management'
>> "%PS1%" echo   $value = "C:\pagefile.sys $size $size"
>> "%PS1%" echo   Set-ItemProperty -Path $regPath -Name 'PagingFiles' -Value $value -Type MultiString
>> "%PS1%" echo   Write-Host "  [2/3] Размер установлен: $size МБ" -ForegroundColor Green
>> "%PS1%" echo   try { Set-ItemProperty -Path $regPath -Name 'ExistingPageFiles' -Value @() -Type MultiString -ErrorAction SilentlyContinue } catch {}
>> "%PS1%" echo   Write-Host '  [3/3] Готово' -ForegroundColor Green
>> "%PS1%" echo   Write-Host ''
>> "%PS1%" echo   Write-Host '  УСПЕШНО. Перезагрузите компьютер.' -ForegroundColor Yellow
>> "%PS1%" echo } catch {
>> "%PS1%" echo   Write-Host ('  ОШИБКА: ' + $_.Exception.Message) -ForegroundColor Red
>> "%PS1%" echo   exit 1
>> "%PS1%" echo }
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
set "ERR=!errorlevel!"
del "%PS1%" >nul 2>&1
if !ERR! NEQ 0 (
    echo.
    call :Err "Что-то пошло не так."
)
call :PauseBack
exit /b


:CPUMaxMenu
call :Hdr "МАКСИМУМ CPU И ОЗУ"
echo  %Bold%[1]%Reset%  Выставить максимум  (все ядра + вся ОЗУ)
echo  %Bold%[2]%Reset%  Показать текущие настройки
echo  %Bold%[3]%Reset%  Сбросить ограничения  (удалить numproc/truncatememory)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto CPUMaxApply
if "%choice%"=="2" goto CPUMaxShow
if "%choice%"=="3" goto CPUMaxReset
if "%choice%"=="0" goto PerfMenu
goto CPUMaxMenu

:CPUMaxApply
call :Hdr "ВЫСТАВЛЕНИЕ МАКСИМУМА"
set "CPUCOUNT=0"
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /value 2^>nul ^| find "="') do set "CPUCOUNT=%%a"
if "!CPUCOUNT!"=="0" (
    for /f %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors"') do set "CPUCOUNT=%%a"
)
if "!CPUCOUNT!"=="" set "CPUCOUNT=0"
set "RAMMB=0"
set "RAMBYTES=0"
for /f %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB)"') do set "RAMMB=%%a"
for /f %%a in ('powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory"') do set "RAMBYTES=%%a"
if "!RAMMB!"=="" set "RAMMB=0"
if "!RAMBYTES!"=="" set "RAMBYTES=0"
echo  Обнаружено:
echo  %Cyan%  Процессоров (логических): %Bold%!CPUCOUNT!%Reset%
echo  %Cyan%  Оперативная память:       %Bold%!RAMMB! МБ%Reset%
echo.
echo  %Yellow%Применяю настройки через bcdedit...%Reset%
echo.
if !CPUCOUNT! GTR 0 (
    bcdedit /set {current} numproc !CPUCOUNT! >nul 2>&1
    if !errorlevel! EQU 0 (call :Ok "Число процессоров = !CPUCOUNT!") else (call :Err "Не удалось установить numproc")
) else (
    call :Warn "Не удалось определить число процессоров"
)
if !RAMBYTES! GTR 0 (
    bcdedit /set {current} truncatememory !RAMBYTES! >nul 2>&1
    if !errorlevel! EQU 0 (
        call :Ok "Максимум памяти = !RAMMB! МБ"
    ) else (
        bcdedit /deletevalue {current} truncatememory >nul 2>&1
        bcdedit /set {current} truncatememory !RAMBYTES! >nul 2>&1
        if !errorlevel! EQU 0 (call :Ok "Максимум памяти = !RAMMB! МБ") else (call :Err "Не удалось установить truncatememory")
    )
) else (
    call :Warn "Не удалось определить объём ОЗУ"
)
echo.
echo  %Yellow%Изменения вступят в силу после перезагрузки.%Reset%
call :PauseBack
goto CPUMaxMenu

:CPUMaxShow
call :Hdr "ТЕКУЩИЕ НАСТРОЙКИ ЗАГРУЗКИ"
echo  %Bold%Число задействованных потоков (numproc):%Reset%
echo.
bcdedit /enum {current} | findstr /i "numproc truncatememory description path"
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /value 2^>nul ^| find "="') do echo  Логических процессоров: %%a
for /f %%a in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB)"') do echo  Оперативная память:     %%a МБ
echo.
echo  %Gray%Если numproc / truncatememory отсутствуют — ограничений нет.%Reset%
call :PauseBack
goto CPUMaxMenu

:CPUMaxReset
call :Hdr "СБРОС ОГРАНИЧЕНИЙ"
echo  %Yellow%Удаляю numproc и truncatememory...%Reset%
echo.
bcdedit /deletevalue {current} numproc >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "numproc удалён") else (echo  %Gray%[—]%Reset%  numproc не был задан)
bcdedit /deletevalue {current} truncatememory >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "truncatememory удалён") else (echo  %Gray%[—]%Reset%  truncatememory не был задан)
echo.
echo  %Green%Ограничения сняты. Будет использоваться всё железо.%Reset%
echo  %Yellow%Изменения вступят в силу после перезагрузки.%Reset%
call :PauseBack
goto CPUMaxMenu

:CPULimMenu
call :Hdr "ТЕМПЕРАТУРА И ЛИМИТЫ ПИТАНИЯ CPU"
echo  %Bold%[1]%Reset%  Сбросить ограничения производительности CPU
echo  %Bold%[2]%Reset%  Отключить Core Parking  (все ядра доступны)
echo  %Bold%[3]%Reset%  Показать текущие параметры CPU
echo  %Bold%[4]%Reset%  Выполнить оба сразу
echo  %Bold%[5]%Reset%  Вернуть стандартный Core Parking
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto CPULimReset
if "%choice%"=="2" goto CPUParkOff
if "%choice%"=="3" goto CPULimShow
if "%choice%"=="4" goto CPULimAll
if "%choice%"=="5" goto CPUParkOn
if "%choice%"=="0" goto PerfMenu
goto CPULimMenu

:CPULimReset
call :Hdr "СБРОС ОГРАНИЧЕНИЙ ПРОИЗВОДИТЕЛЬНОСТИ CPU"
echo  %Yellow%Устанавливаю минимальное состояние 5%% и максимум 100%%...%Reset%
echo.
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "от сети: минимум CPU = 5%%") else (call :Err "не удалось установить минимум CPU")
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "от сети: максимум CPU = 100%%") else (call :Err "не удалось установить максимум CPU")
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "от батареи: минимум CPU = 5%%") else (call :Err "не удалось установить минимум CPU от батареи")
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "от батареи: максимум CPU = 100%%") else (call :Err "не удалось установить максимум CPU от батареи")
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo.
call :Ok "Готово"
echo  %Gray%Это параметры Windows, а не разгон и не аппаратные температуры CPU.%Reset%
call :PauseBack
goto CPULimMenu

:CPUParkOff
call :Hdr "ОТКЛЮЧЕНИЕ CORE PARKING"
echo  %Yellow%Устанавливаю минимальное число доступных ядер = 100%%...%Reset%
echo.
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "от сети: Core Parking отключён") else (call :Err "не удалось отключить Core Parking от сети")
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "от батареи: Core Parking отключён") else (call :Err "не удалось отключить Core Parking от батареи")
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo.
call :Ok "Core Parking отключён"
echo  %Gray%Windows будет держать все доступные ядра незапаркованными.%Reset%
call :PauseBack
goto CPULimMenu

:CPULimAll
call :Hdr "ПРИМЕНЕНИЕ ВСЕХ НАСТРОЕК CPU"
echo  %Yellow%1/2  Настраиваю пределы производительности CPU...%Reset%
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "AC: минимум CPU = 5%%") else (call :Err "AC: минимум CPU")
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "AC: максимум CPU = 100%%") else (call :Err "AC: максимум CPU")
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "DC: минимум CPU = 5%%") else (call :Err "DC: минимум CPU")
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "DC: максимум CPU = 100%%") else (call :Err "DC: максимум CPU")
echo.
echo  %Yellow%2/2  Отключаю Core Parking...%Reset%
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "AC: Core Parking отключён") else (call :Err "AC: Core Parking")
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "DC: Core Parking отключён") else (call :Err "DC: Core Parking")
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo.
echo  %Bold%%Green%ГОТОВО%Reset%
echo  %Gray%Настройки применены к текущей схеме питания.%Reset%
call :PauseBack
goto CPULimMenu

:CPULimShow
call :Hdr "ТЕКУЩИЕ ПАРАМЕТРЫ CPU"
echo  %Bold%Активная схема питания:%Reset%
powercfg /getactivescheme
echo.
echo  %Bold%Минимальное состояние CPU:%Reset%
powercfg /query SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN
echo.
echo  %Bold%Максимальное состояние CPU:%Reset%
powercfg /query SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX
echo.
echo  %Bold%Core Parking - минимум доступных ядер:%Reset%
powercfg /query SCHEME_CURRENT SUB_PROCESSOR CPMINCORES
echo.
echo  %Gray%PL1/PL2 и аппаратные температуры через powercfg не меняются.%Reset%
call :PauseBack
goto CPULimMenu

:CPUParkOn
call :Hdr "ВОССТАНОВЛЕНИЕ CORE PARKING"
echo  %Yellow%Возвращаю автоматическое управление парковкой...%Reset%
echo.
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 0 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "AC: Core Parking вернён Windows") else (call :Err "AC: не удалось восстановить Core Parking")
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 0 >nul 2>&1
if !errorlevel! EQU 0 (call :Ok "DC: Core Parking вернён Windows") else (call :Err "DC: не удалось восстановить Core Parking")
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo.
call :Ok "Автоматическое управление Core Parking восстановлено"
call :PauseBack
goto CPULimMenu

rem ========================================================================
rem  9. СЕТЬ
rem ========================================================================
:NetMenu
call :Hdr "СЕТЕВОЙ ТЮНИНГ"
echo  %Bold%[1]%Reset%  Показать текущие настройки TCP/IP
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[2]%Reset%  TCP Auto-Tuning
echo  %Bold%[3]%Reset%  ECN
echo  %Bold%[4]%Reset%  MTU
echo  %Bold%[5]%Reset%  QoS  (ограничение пропускной способности)
echo  %Bold%[6]%Reset%  NetBIOS over TCP/IP
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[7]%Reset%  Рекомендуемый профиль  (игры / низкий пинг)
echo  %Bold%[8]%Reset%  Сброс TCP-параметров к умолчанию
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto NetShow
if "%choice%"=="2" goto NetAuto
if "%choice%"=="3" goto NetECN
if "%choice%"=="4" goto NetMTU
if "%choice%"=="5" goto NetQoS
if "%choice%"=="6" goto NetBIOS
if "%choice%"=="7" goto NetGaming
if "%choice%"=="8" goto NetReset
if "%choice%"=="0" goto MainMenu
goto NetMenu

:NetShow
call :Hdr "ТЕКУЩИЕ НАСТРОЙКИ"
echo  %Bold%TCP Global:%Reset%
netsh int tcp show global
echo.
echo  %Bold%MTU интерфейсов:%Reset%
netsh interface ipv4 show subinterfaces
echo.
echo  %Bold%QoS (Policy):%Reset%
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit 2>nul || echo   (не задано, по умолчанию 20%%)
call :PauseBack
goto NetMenu

:NetAuto
call :Hdr "TCP AUTO-TUNING"
echo  %Bold%[1]%Reset%  normal   (по умолчанию Windows)
echo  %Bold%[2]%Reset%  disabled (выкл. — иногда снижает пинг)
echo  %Bold%[3]%Reset%  highlyrestricted
echo  %Bold%[4]%Reset%  restricted
echo  %Bold%[5]%Reset%  experimental
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto NetMenu
if "%choice%"=="1" netsh int tcp set global autotuninglevel=normal
if "%choice%"=="2" netsh int tcp set global autotuninglevel=disabled
if "%choice%"=="3" netsh int tcp set global autotuninglevel=highlyrestricted
if "%choice%"=="4" netsh int tcp set global autotuninglevel=restricted
if "%choice%"=="5" netsh int tcp set global autotuninglevel=experimental
echo.
call :Ok "Текущий уровень:"
netsh int tcp show global | findstr /i "Auto"
call :PauseBack
goto NetMenu

:NetECN
call :Hdr "ECN - Explicit Congestion Notification"
echo  %Bold%[1]%Reset%  Включить ECN
echo  %Bold%[2]%Reset%  Выключить ECN  (по умолчанию)
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto NetMenu
if "%choice%"=="1" (
    netsh int tcp set global ecncapability=enabled
    echo. & call :Ok "ECN включён"
)
if "%choice%"=="2" (
    netsh int tcp set global ecncapability=disabled
    echo. & call :Ok "ECN выключен"
)
call :PauseBack
goto NetMenu

:NetMTU
call :Hdr "MTU"
echo  Текущие интерфейсы:
netsh interface ipv4 show subinterfaces
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[1]%Reset%  MTU 1500  (стандарт Ethernet)
echo  %Bold%[2]%Reset%  MTU 1472  (часто для VPN/PPPoE)
echo  %Bold%[3]%Reset%  MTU 1400  (проблемные каналы)
echo  %Bold%[4]%Reset%  Задать своё значение
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto NetMenu
set "MTUVAL="
if "%choice%"=="1" set "MTUVAL=1500"
if "%choice%"=="2" set "MTUVAL=1472"
if "%choice%"=="3" set "MTUVAL=1400"
if "%choice%"=="4" set /p "MTUVAL=  MTU: "
if not defined MTUVAL goto NetMenu
echo.
echo  %Yellow%Имя интерфейса как в списке выше (например Ethernet):%Reset%
set /p "IFACE=  Интерфейс: "
if "%IFACE%"=="" goto NetMenu
netsh interface ipv4 set subinterface "%IFACE%" mtu=%MTUVAL% store=persistent
if %errorlevel% EQU 0 (
    echo. & call :Ok "MTU %MTUVAL% для %IFACE%"
) else (
    echo. & call :Err "Проверьте имя интерфейса."
)
call :PauseBack
goto NetMenu

:NetQoS
call :Hdr "QoS — ограничение канала"
echo  Windows по умолчанию может резервировать до 20%% канала для QoS.
echo  Для игр часто ставят 0%%.
echo.
echo  %Bold%[1]%Reset%  Снять ограничение  (0%%)
echo  %Bold%[2]%Reset%  Вернуть по умолчанию  (20%%)
echo  %Bold%[3]%Reset%  Удалить политику
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto NetMenu
if "%choice%"=="1" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul
    echo. & call :Ok "NonBestEffortLimit = 0"
    echo  %Yellow%Может потребоваться перезагрузка.%Reset%
)
if "%choice%"=="2" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 20 /f >nul
    echo. & call :Ok "NonBestEffortLimit = 20"
)
if "%choice%"=="3" (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /f >nul 2>&1
    echo. & call :Ok "Политика удалена"
)
call :PauseBack
goto NetMenu

:NetBIOS
call :Hdr "NetBIOS over TCP/IP"
echo  Отключение NetBIOS уменьшает шум в локальной сети.
echo  Может мешать старым сетевым шарам / принтерам.
echo.
echo  %Bold%[1]%Reset%  Отключить NetBIOS на всех интерфейсах
echo  %Bold%[2]%Reset%  Включить NetBIOS  (по умолчанию DHCP)
echo  %Bold%[3]%Reset%  Сбросить кэш NetBIOS  (nbtstat -R / -RR)
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto NetMenu
if "%choice%"=="1" (
    echo.
    echo  %Yellow%Отключаю NetBIOS...%Reset%
    powershell -NoProfile -Command "Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object { $r=$_.SetTcpipNetbios(2); Write-Host ('  ' + $_.Description + '  ->  код ' + $r.ReturnValue) }"
    echo. & call :Ok "NetBIOS отключён  ^(2 = Disable^)"
)
if "%choice%"=="2" (
    echo.
    echo  %Yellow%Включаю NetBIOS ^(через DHCP^)...%Reset%
    powershell -NoProfile -Command "Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object { $r=$_.SetTcpipNetbios(0); Write-Host ('  ' + $_.Description + '  ->  код ' + $r.ReturnValue) }"
    echo. & call :Ok "NetBIOS = Default ^(DHCP^)"
)
if "%choice%"=="3" (
    nbtstat -R >nul 2>&1
    nbtstat -RR >nul 2>&1
    echo. & call :Ok "Кэш NetBIOS сброшен"
)
call :PauseBack
goto NetMenu

:NetGaming
call :Hdr "ПРОФИЛЬ: ИГРЫ / НИЗКИЙ ПИНГ"
echo  %Yellow%Применяю:%Reset%
echo    - Auto-Tuning = disabled
echo    - ECN = disabled
echo    - QoS limit = 0%%
echo.
set /p "conf=  Продолжить? y/n: "
if /i not "%conf%"=="y" goto NetMenu
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global ecncapability=disabled >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul
echo.
call :Ok "Auto-Tuning disabled"
call :Ok "ECN disabled"
call :Ok "QoS = 0%%"
echo.
echo  %Yellow%DNS/Winsock — в разделе «Очистка». Рекомендуется перезагрузка.%Reset%
call :PauseBack
goto NetMenu

:NetReset
call :Hdr "СБРОС TCP К УМОЛЧАНИЮ"
set /p "conf=  Сбросить TCP global? y/n: "
if /i not "%conf%"=="y" goto NetMenu
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global timestamps=default >nul 2>&1
netsh int tcp set global initialrto=3000 >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=default >nul 2>&1
echo.
call :Ok "Auto-Tuning = normal"
call :Ok "ECN = disabled"
call :Ok "Остальные TCP global сброшены"
call :PauseBack
goto NetMenu

rem ========================================================================
rem  10. ИНТЕРФЕЙС И ПРОВОДНИК
rem ========================================================================
:UIMenu
call :Hdr "ИНТЕРФЕЙС И ПРОВОДНИК"
echo  %Bold%[1]%Reset%  Настройка проводника
echo  %Bold%[2]%Reset%  Визуальные эффекты
echo  %Bold%[3]%Reset%  Задержка меню
echo  %Bold%[4]%Reset%  Сжатие обоев
echo  %Bold%[5]%Reset%  Раздел «Рекомендуем» в меню Пуск
echo  %Bold%[6]%Reset%  Очистить панель задач
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto ExpMenu
if "%choice%"=="2" goto FXMenu
if "%choice%"=="3" goto DelayMenu
if "%choice%"=="4" goto WallMenu
if "%choice%"=="5" goto RecMenu
if "%choice%"=="6" goto TaskbarClean
if "%choice%"=="0" goto MainMenu
goto UIMenu

:ExpMenu
call :Hdr "НАСТРОЙКА ПРОВОДНИКА"
call :ExpStatus
if "!_OpenLoc!"=="1" (set "s=%Green%Этот компьютер%Reset%") else (set "s=%Red%Главная%Reset%")
echo  %Bold%[1]%Reset%  Открывать проводник      : !s!
if "!_HideHome!"=="0" (set "s=%Green%Скрыта%Reset%") else (set "s=%Red%Видна%Reset%")
echo  %Bold%[2]%Reset%  Кнопка «Главная»         : !s!
if "!_HideGallery!"=="0" (set "s=%Green%Скрыта%Reset%") else (set "s=%Red%Видна%Reset%")
echo  %Bold%[3]%Reset%  Кнопка «Галерея»         : !s!
if "!_HideNetwork!"=="0" (set "s=%Green%Скрыта%Reset%") else (set "s=%Red%Видна%Reset%")
echo  %Bold%[4]%Reset%  Кнопка «Сеть»            : !s!
if "!_ShowRecycle!"=="1" (set "s=%Green%Видна%Reset%") else (set "s=%Red%Скрыта%Reset%")
echo  %Bold%[5]%Reset%  Корзина (навигация)      : !s!
if "!_DeskRecycle!"=="0" (set "s=%Red%Видна%Reset%") else (set "s=%Green%Скрыта%Reset%")
echo  %Bold%[6]%Reset%  Корзина на рабочем столе : !s!
if "!_Compact!"=="1" (set "s=%Green%Вкл%Reset%") else (set "s=%Red%Выкл%Reset%")
echo  %Bold%[7]%Reset%  Компактный вид           : !s!
if "!_Privacy!"=="0" (set "s=%Green%Выкл%Reset%") else (set "s=%Red%Вкл%Reset%")
echo  %Bold%[8]%Reset%  Недавние файлы           : !s!
if "!_CtxMenu!"=="1" (set "s=%Green%Классическое%Reset%") else (set "s=%Red%Современное%Reset%")
echo  %Bold%[9]%Reset%  Контекстное меню         : !s!
echo  %Gray%--------------------------------------------------------------------%Reset%
if "!_Ext!"=="0" (set "s=%Green%Видны%Reset%") else (set "s=%Red%Скрыты%Reset%")
echo  %Bold%[E]%Reset%  Расширения файлов       : !s!
if "!_Hidden!"=="1" (set "s=%Green%Видны%Reset%") else (set "s=%Red%Скрыты%Reset%")
echo  %Bold%[H]%Reset%  Скрытые файлы           : !s!
if "!_FullPath!"=="1" (set "s=%Green%Вкл%Reset%") else (set "s=%Red%Выкл%Reset%")
echo  %Bold%[P]%Reset%  Полный путь в заголовке : !s!
if "!_CheckBoxes!"=="1" (set "s=%Green%Вкл%Reset%") else (set "s=%Red%Выкл%Reset%")
echo  %Bold%[C]%Reset%  Флажки элементов        : !s!
if "!_OneDrive!"=="0" (set "s=%Green%Скрыт%Reset%") else (set "s=%Red%Виден%Reset%")
echo  %Bold%[O]%Reset%  OneDrive в навиг.       : !s!
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[R]%Reset%  %Yellow%Перезапустить проводник%Reset%
echo  %Bold%[A]%Reset%  %Green%Применить всё%Reset%
echo  %Bold%[D]%Reset%  %Red%По умолчанию%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if /i "%choice%"=="0" goto UIMenu
if /i "%choice%"=="A" goto ExpApplyAll
if /i "%choice%"=="D" goto ExpDefaults
if /i "%choice%"=="R" goto ExpRestart
if "%choice%"=="1" goto ExpOpen
if "%choice%"=="2" goto ExpHome
if "%choice%"=="3" goto ExpGallery
if "%choice%"=="4" goto ExpNetwork
if "%choice%"=="5" goto ExpRecycle
if "%choice%"=="6" goto ExpDeskRecycle
if "%choice%"=="7" goto ExpCompact
if "%choice%"=="8" goto ExpPrivacy
if "%choice%"=="9" goto ExpCtx
if /i "%choice%"=="E" goto ExpExt
if /i "%choice%"=="H" goto ExpHidden
if /i "%choice%"=="P" goto ExpPath
if /i "%choice%"=="C" goto ExpCheck
if /i "%choice%"=="O" goto ExpOneDrive
goto ExpMenu

:ExpOpen
if "!_OpenLoc!"=="1" (reg add "%RegAdv%" /v LaunchTo /t REG_DWORD /d 2 /f >nul) else (reg add "%RegAdv%" /v LaunchTo /t REG_DWORD /d 1 /f >nul)
goto ExpMenu
:ExpHome
if "!_HideHome!"=="0" (reg add "HKCU\Software\Classes\CLSID\%ClsidHome%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul) else (reg add "HKCU\Software\Classes\CLSID\%ClsidHome%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul)
goto ExpMenu
:ExpGallery
if "!_HideGallery!"=="0" (reg add "HKCU\Software\Classes\CLSID\%ClsidGallery%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul) else (reg add "HKCU\Software\Classes\CLSID\%ClsidGallery%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul)
goto ExpMenu
:ExpNetwork
if "!_HideNetwork!"=="0" (reg add "HKCU\Software\Classes\CLSID\%ClsidNetwork%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul) else (reg add "HKCU\Software\Classes\CLSID\%ClsidNetwork%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul)
goto ExpMenu
:ExpRecycle
if "!_ShowRecycle!"=="1" (reg add "HKCU\Software\Classes\CLSID\%ClsidRecycle%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul) else (reg add "HKCU\Software\Classes\CLSID\%ClsidRecycle%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul)
goto ExpMenu
:ExpDeskRecycle
if "!_DeskRecycle!"=="0" (reg add "%RegDeskIcons%" /v "%ClsidRecycle%" /t REG_DWORD /d 1 /f >nul) else (reg delete "%RegDeskIcons%" /v "%ClsidRecycle%" /f >nul)
goto ExpMenu
:ExpCompact
if "!_Compact!"=="1" (reg add "%RegAdv%" /v UseCompactMode /t REG_DWORD /d 0 /f >nul) else (reg add "%RegAdv%" /v UseCompactMode /t REG_DWORD /d 1 /f >nul)
goto ExpMenu
:ExpPrivacy
if "!_Privacy!"=="0" (
    reg add "%RegExp%" /v ShowRecent /t REG_DWORD /d 1 /f >nul
    reg add "%RegExp%" /v ShowFrequent /t REG_DWORD /d 1 /f >nul
    reg add "%RegExp%" /v ShowCloudFilesInQuickAccess /t REG_DWORD /d 1 /f >nul
    reg add "%RegAdv%" /v Start_TrackDocs /t REG_DWORD /d 1 /f >nul
) else (
    reg add "%RegExp%" /v ShowRecent /t REG_DWORD /d 0 /f >nul
    reg add "%RegExp%" /v ShowFrequent /t REG_DWORD /d 0 /f >nul
    reg add "%RegExp%" /v ShowCloudFilesInQuickAccess /t REG_DWORD /d 0 /f >nul
    reg add "%RegAdv%" /v Start_TrackDocs /t REG_DWORD /d 0 /f >nul
)
goto ExpMenu
:ExpCtx
if "!_CtxMenu!"=="1" (reg delete "HKCU\Software\Classes\CLSID\%ClsidMenu%" /f >nul 2>&1) else (reg add "HKCU\Software\Classes\CLSID\%ClsidMenu%\InprocServer32" /ve /f >nul)
goto ExpMenu
:ExpExt
if "!_Ext!"=="0" (reg add "%RegAdv%" /v HideFileExt /t REG_DWORD /d 1 /f >nul) else (reg add "%RegAdv%" /v HideFileExt /t REG_DWORD /d 0 /f >nul)
goto ExpMenu
:ExpHidden
if "!_Hidden!"=="1" (
    reg add "%RegAdv%" /v Hidden /t REG_DWORD /d 2 /f >nul
    reg add "%RegAdv%" /v ShowSuperHidden /t REG_DWORD /d 0 /f >nul
) else (
    reg add "%RegAdv%" /v Hidden /t REG_DWORD /d 1 /f >nul
    reg add "%RegAdv%" /v ShowSuperHidden /t REG_DWORD /d 1 /f >nul
)
goto ExpMenu
:ExpPath
if "!_FullPath!"=="1" (reg add "%RegAdv%" /v FullPathAddress /t REG_DWORD /d 0 /f >nul) else (reg add "%RegAdv%" /v FullPathAddress /t REG_DWORD /d 1 /f >nul)
goto ExpMenu
:ExpCheck
if "!_CheckBoxes!"=="1" (reg add "%RegAdv%" /v AutoCheckSelect /t REG_DWORD /d 0 /f >nul) else (reg add "%RegAdv%" /v AutoCheckSelect /t REG_DWORD /d 1 /f >nul)
goto ExpMenu
:ExpOneDrive
if "!_OneDrive!"=="0" (
    reg delete "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /f >nul 2>&1
    reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul
) else (
    reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul
)
goto ExpMenu

:ExpApplyAll
reg add "%RegAdv%" /v LaunchTo /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidHome%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidGallery%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidNetwork%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidRecycle%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul
reg add "%RegDeskIcons%" /v "%ClsidRecycle%" /t REG_DWORD /d 1 /f >nul
reg add "%RegAdv%" /v UseCompactMode /t REG_DWORD /d 1 /f >nul
reg add "%RegExp%" /v ShowRecent /t REG_DWORD /d 0 /f >nul
reg add "%RegExp%" /v ShowFrequent /t REG_DWORD /d 0 /f >nul
reg add "%RegExp%" /v ShowCloudFilesInQuickAccess /t REG_DWORD /d 0 /f >nul
reg add "%RegAdv%" /v Start_TrackDocs /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidMenu%\InprocServer32" /ve /f >nul
reg add "%RegAdv%" /v HideFileExt /t REG_DWORD /d 0 /f >nul
reg add "%RegAdv%" /v Hidden /t REG_DWORD /d 1 /f >nul
reg add "%RegAdv%" /v ShowSuperHidden /t REG_DWORD /d 1 /f >nul
reg add "%RegAdv%" /v FullPathAddress /t REG_DWORD /d 1 /f >nul
reg add "%RegAdv%" /v AutoCheckSelect /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul
goto ExpRestart

:ExpDefaults
reg add "%RegAdv%" /v LaunchTo /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidHome%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidGallery%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidNetwork%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Classes\CLSID\%ClsidRecycle%" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f >nul
reg delete "%RegDeskIcons%" /v "%ClsidRecycle%" /f >nul 2>&1
reg add "%RegAdv%" /v UseCompactMode /t REG_DWORD /d 0 /f >nul
reg add "%RegExp%" /v ShowRecent /t REG_DWORD /d 1 /f >nul
reg add "%RegExp%" /v ShowFrequent /t REG_DWORD /d 1 /f >nul
reg add "%RegExp%" /v ShowCloudFilesInQuickAccess /t REG_DWORD /d 1 /f >nul
reg add "%RegAdv%" /v Start_TrackDocs /t REG_DWORD /d 1 /f >nul
reg delete "HKCU\Software\Classes\CLSID\%ClsidMenu%" /f >nul 2>&1
reg add "%RegAdv%" /v HideFileExt /t REG_DWORD /d 1 /f >nul
reg add "%RegAdv%" /v Hidden /t REG_DWORD /d 2 /f >nul
reg add "%RegAdv%" /v ShowSuperHidden /t REG_DWORD /d 0 /f >nul
reg add "%RegAdv%" /v FullPathAddress /t REG_DWORD /d 0 /f >nul
reg add "%RegAdv%" /v AutoCheckSelect /t REG_DWORD /d 0 /f >nul
reg delete "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /f >nul 2>&1
goto ExpRestart

:ExpRestart
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
timeout /t 2 /nobreak >nul
goto ExpMenu

:ExpStatus
call :GetRegValue "%RegAdv%" "LaunchTo" 2 _OpenLoc
call :GetRegValue "HKCU\Software\Classes\CLSID\%ClsidHome%" "System.IsPinnedToNameSpaceTree" 1 _HideHome
call :GetRegValue "HKCU\Software\Classes\CLSID\%ClsidGallery%" "System.IsPinnedToNameSpaceTree" 1 _HideGallery
call :GetRegValue "HKCU\Software\Classes\CLSID\%ClsidNetwork%" "System.IsPinnedToNameSpaceTree" 1 _HideNetwork
call :GetRegValue "HKCU\Software\Classes\CLSID\%ClsidRecycle%" "System.IsPinnedToNameSpaceTree" 0 _ShowRecycle
call :GetRegValue "%RegDeskIcons%" "%ClsidRecycle%" 0 _DeskRecycle
call :GetRegValue "%RegAdv%" "UseCompactMode" 0 _Compact
call :GetRegValue "%RegExp%" "ShowRecent" 1 _Privacy
reg query "HKCU\Software\Classes\CLSID\%ClsidMenu%\InprocServer32" >nul 2>&1
if %errorlevel% EQU 0 (set "_CtxMenu=1") else (set "_CtxMenu=0")
call :GetRegValue "%RegAdv%" "HideFileExt" 1 _Ext
call :GetRegValue "%RegAdv%" "Hidden" 2 _Hidden
call :GetRegValue "%RegAdv%" "FullPathAddress" 0 _FullPath
call :GetRegValue "%RegAdv%" "AutoCheckSelect" 0 _CheckBoxes
call :GetRegValue "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 1 _OneDrive
exit /b

:GetRegValue
set "%4=%3"
for /f "tokens=3" %%a in ('reg query "%~1" /v "%~2" 2^>nul') do (set /a "%4=%%a")
exit /b

:FXMenu
call :Hdr "ВИЗУАЛЬНЫЕ ЭФФЕКТЫ"
echo  %Bold%[1]%Reset%  Наилучшее быстродействие  (всё выкл.)
echo  %Bold%[2]%Reset%  Наилучшее оформление      (всё вкл.)
echo  %Bold%[3]%Reset%  Рекомендуемые Windows
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[4]%Reset%  Анимации окон и меню
echo  %Bold%[5]%Reset%  Прозрачность Win10/11
echo  %Bold%[6]%Reset%  Тени и сглаживание
echo  %Bold%[7]%Reset%  Показать эскизы вместо значков
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[G]%Reset%  Открыть окно Windows  (SystemPropertiesPerformance)
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto FXBestPerf
if "%choice%"=="2" goto FXBestLook
if "%choice%"=="3" goto FXDefault
if "%choice%"=="4" goto FXAnim
if "%choice%"=="5" goto FXTrans
if "%choice%"=="6" goto FXShadows
if "%choice%"=="7" goto FXThumbs
if /i "%choice%"=="G" goto FXGUI
if "%choice%"=="0" goto UIMenu
goto FXMenu

:FXBestPerf
call :Hdr "НАИЛУЧШЕЕ БЫСТРОДЕЙСТВИЕ"
echo  %Yellow%Отключаю все визуальные эффекты...%Reset%
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
call :Ok "VisualFXSetting = 2  (быстродействие)"
call :Ok "Анимации / прозрачность / тени выкл."
echo.
echo  %Yellow%Чтобы применить полностью — выйдите из системы или перезагрузите.%Reset%
call :RestartExplorer
call :PauseBack
goto FXMenu

:FXBestLook
call :Hdr "НАИЛУЧШЕЕ ОФОРМЛЕНИЕ"
echo  %Yellow%Включаю все визуальные эффекты...%Reset%
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9E3E078012000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f >nul 2>&1
call :Ok "VisualFXSetting = 1  (оформление)"
call :RestartExplorer
call :PauseBack
goto FXMenu

:FXDefault
call :Hdr "РЕКОМЕНДУЕМЫЕ WINDOWS"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
call :Ok "VisualFXSetting = 0  (решает Windows)"
echo.
echo  %Yellow%Откройте также пункт [G] для тонкой настройки.%Reset%
call :PauseBack
goto FXMenu

:FXAnim
call :Hdr "АНИМАЦИИ"
echo  %Bold%[1]%Reset%  Выключить анимации
echo  %Bold%[2]%Reset%  Включить анимации
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" (
    reg add "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 0 /f >nul
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul
    echo. & call :Ok "Анимации выключены"
    call :RestartExplorer
)
if "%choice%"=="2" (
    reg add "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 1 /f >nul
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 1 /f >nul
    echo. & call :Ok "Анимации включены"
    call :RestartExplorer
)
call :PauseBack
goto FXMenu

:FXTrans
call :Hdr "ПРОЗРАЧНОСТЬ"
echo  %Bold%[1]%Reset%  Выключить прозрачность
echo  %Bold%[2]%Reset%  Включить прозрачность
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul
    echo. & call :Ok "Прозрачность выключена"
)
if "%choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f >nul
    echo. & call :Ok "Прозрачность включена"
)
call :PauseBack
goto FXMenu

:FXShadows
call :Hdr "ТЕНИ И СГЛАЖИВАНИЕ"
echo  %Bold%[1]%Reset%  Выключить тени / Aero Peek
echo  %Bold%[2]%Reset%  Включить тени / Aero Peek
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul
    echo. & call :Ok "Тени и Aero Peek выключены"
    call :RestartExplorer
)
if "%choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul
    echo. & call :Ok "Тени и Aero Peek включены"
    call :RestartExplorer
)
call :PauseBack
goto FXMenu

:FXThumbs
call :Hdr "ЭСКИЗЫ / ЗНАЧКИ"
echo  %Bold%[1]%Reset%  Значки вместо эскизов  (быстрее)
echo  %Bold%[2]%Reset%  Эскизы вместо значков  (красивее)
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f >nul
    echo. & call :Ok "Показывать значки"
    call :RestartExplorer
)
if "%choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f >nul
    echo. & call :Ok "Показывать эскизы"
    call :RestartExplorer
)
call :PauseBack
goto FXMenu

:FXGUI
start SystemPropertiesPerformance.exe
goto FXMenu

:RestartExplorer
echo.
echo  %Yellow%Перезапустить Проводник сейчас?%Reset%
set /p "r=  y/n: "
if /i "%r%"=="y" (
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
    call :Ok "Explorer перезапущен"
)
exit /b

:DelayMenu
call :Hdr "ЗАДЕРЖКА МЕНЮ"
echo  %Bold%[1]%Reset%  20 мс
echo  %Bold%[2]%Reset%  400 мс
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto UIMenu
if "%choice%"=="1" (
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 20 /f >nul 2>&1
    echo. & call :Ok "Задержка меню: 20 мс"
)
if "%choice%"=="2" (
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1
    echo. & call :Ok "Задержка меню: 400 мс"
)
call :PauseBack
goto DelayMenu

:WallMenu
call :Hdr "СЖАТИЕ ОБОЕВ"
echo  %Bold%[1]%Reset%  Выкл  (качество 100%%)
echo  %Bold%[2]%Reset%  Вкл   (по умолчанию)
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto UIMenu
if "%choice%"=="1" (
    reg add "HKCU\Control Panel\Desktop" /v JPEGImportQuality /t REG_DWORD /d 100 /f >nul 2>&1
    echo. & call :Ok "Сжатие обоев отключено"
)
if "%choice%"=="2" (
    reg delete "HKCU\Control Panel\Desktop" /v JPEGImportQuality /f >nul 2>&1
    echo. & call :Ok "Сжатие обоев включено ^(по умолчанию^)"
)
call :PauseBack
goto WallMenu

:RecMenu
call :Hdr "РАЗДЕЛ «РЕКОМЕНДУЕМ»"
echo  %Bold%[1]%Reset%  Скрыть
echo  %Bold%[2]%Reset%  Показать
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto UIMenu
if "%choice%"=="1" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecommendedSection /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v HideRecommendedSection /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v IsEducationEnvironment /t REG_DWORD /d 1 /f >nul 2>&1
    echo. & call :Ok "Раздел «Рекомендуем» скрыт"
)
if "%choice%"=="2" (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecommendedSection /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v HideRecommendedSection /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v IsEducationEnvironment /f >nul 2>&1
    echo. & call :Ok "Раздел «Рекомендуем» показан"
)
call :PauseBack
goto RecMenu

:TaskbarClean
call :Hdr "ОЧИСТКА ПАНЕЛИ ЗАДАЧ"
echo  %Yellow%Очистка панели задач...%Reset%
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Desktop" /f >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
timeout /t 2 /nobreak >nul
call :Ok "Готово"
call :PauseBack
goto UIMenu

rem ========================================================================
rem  11. ВВОД, БРАУЗЕР И ИГРЫ
rem ========================================================================
:InpMenu
call :Hdr "ВВОД, БРАУЗЕР И ИГРЫ"
echo  %Bold%[1]%Reset%  Ускорение мыши
echo  %Bold%[2]%Reset%  Залипание клавиш
echo  %Bold%[3]%Reset%  Ускорение запуска Edge
echo  %Bold%[4]%Reset%  Game Bar / DVR / Game Mode
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto MouseMenu
if "%choice%"=="2" goto StickyMenu
if "%choice%"=="3" goto EdgeMenu
if "%choice%"=="4" goto GameMenu
if "%choice%"=="0" goto MainMenu
goto InpMenu

:MouseMenu
call :Hdr "УСКОРЕНИЕ МЫШИ"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto InpMenu
if "%choice%"=="1" (
    echo.
    echo  %Yellow%Отключение ускорения мыши...%Reset%
    reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul
    powershell -NoProfile -Command "$code='using System.Runtime.InteropServices; public class W32 { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, int[] c, uint d); }'; Add-Type -TypeDefinition $code; $p=[int[]]@(0,0,0); [W32]::SystemParametersInfo(4,0,$p,3)" >nul 2>&1
    call :Ok "Ускорение мыши отключено"
)
if "%choice%"=="2" (
    echo.
    echo  %Yellow%Включение ускорения мыши...%Reset%
    reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f >nul
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 6 /f >nul
    reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 10 /f >nul
    powershell -NoProfile -Command "$code='using System.Runtime.InteropServices; public class W32 { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, int[] c, uint d); }'; Add-Type -TypeDefinition $code; $p=[int[]]@(6,10,1); [W32]::SystemParametersInfo(4,0,$p,3)" >nul 2>&1
    call :Ok "Ускорение мыши включено"
)
call :PauseBack
goto MouseMenu

:StickyMenu
call :Hdr "ЗАЛИПАНИЕ КЛАВИШ"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto InpMenu
if "%choice%"=="1" (
    reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f >nul 2>&1
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f >nul 2>&1
    reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f >nul 2>&1
    echo. & call :Ok "Залипание клавиш отключено"
)
if "%choice%"=="2" (
    reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 510 /f >nul 2>&1
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 126 /f >nul 2>&1
    reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 62 /f >nul 2>&1
    echo. & call :Ok "Залипание клавиш включено"
)
call :PauseBack
goto StickyMenu

:EdgeMenu
call :Hdr "УСКОРЕНИЕ ЗАПУСКА EDGE"
echo  %Bold%[1]%Reset%  Выкл
echo  %Bold%[2]%Reset%  Вкл
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto InpMenu
if "%choice%"=="1" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    echo. & call :Ok "Ускорение запуска Edge отключено"
)
if "%choice%"=="2" (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /f >nul 2>&1
    echo. & call :Ok "Ускорение запуска Edge включено"
)
call :PauseBack
goto EdgeMenu

:GameMenu
call :Hdr "GAME BAR / DVR / OVERLAY"
echo  %Bold%[1]%Reset%  Отключить всё  (Game Bar, DVR, запись)
echo  %Bold%[2]%Reset%  Включить всё обратно
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[3]%Reset%  Только Game Bar
echo  %Bold%[4]%Reset%  Только фоновая запись / DVR
echo  %Bold%[5]%Reset%  Только Game Mode
echo  %Bold%[6]%Reset%  Показать текущий статус
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto GameOffAll
if "%choice%"=="2" goto GameOnAll
if "%choice%"=="3" goto GameBarOnly
if "%choice%"=="4" goto GameDVROnly
if "%choice%"=="5" goto GameModeOnly
if "%choice%"=="6" goto GameStatus
if "%choice%"=="0" goto InpMenu
goto GameMenu

:GameOffAll
call :Hdr "ОТКЛЮЧЕНИЕ GAME BAR / DVR"
call :SetGameBar 0
call :SetDVR 0
call :SetGameMode 1
echo.
echo  %Green%Game Bar и DVR отключены.%Reset%
echo  %Green%Game Mode оставлен включённым  (полезно для игр).%Reset%
call :PauseBack
goto GameMenu

:GameOnAll
call :Hdr "ВКЛЮЧЕНИЕ GAME BAR / DVR"
call :SetGameBar 1
call :SetDVR 1
call :SetGameMode 1
echo.
echo  %Green%Game Bar, DVR и Game Mode включены.%Reset%
call :PauseBack
goto GameMenu

:GameBarOnly
call :Hdr "GAME BAR"
echo  %Bold%[1]%Reset%  Отключить
echo  %Bold%[2]%Reset%  Включить
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto GameMenu
if "%choice%"=="1" call :SetGameBar 0
if "%choice%"=="2" call :SetGameBar 1
call :PauseBack
goto GameMenu

:GameDVROnly
call :Hdr "ФОНОВАЯ ЗАПИСЬ / DVR"
echo  %Bold%[1]%Reset%  Отключить
echo  %Bold%[2]%Reset%  Включить
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto GameMenu
if "%choice%"=="1" call :SetDVR 0
if "%choice%"=="2" call :SetDVR 1
call :PauseBack
goto GameMenu

:GameModeOnly
call :Hdr "GAME MODE"
echo  Режим игры Windows — обычно лучше оставить ВКЛ.
echo.
echo  %Bold%[1]%Reset%  Включить Game Mode
echo  %Bold%[2]%Reset%  Выключить Game Mode
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto GameMenu
if "%choice%"=="1" call :SetGameMode 1
if "%choice%"=="2" call :SetGameMode 0
call :PauseBack
goto GameMenu

:GameStatus
call :Hdr "СТАТУС GAME BAR / DVR"
echo  %Bold%GameDVR / AppCapture:%Reset%
reg query "HKCU\System\GameConfigStore" /v GameDVR_Enabled 2>nul
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled 2>nul
echo.
echo  %Bold%Game Bar presence:%Reset%
reg query "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled 2>nul
echo.
echo  %Bold%Game Mode:%Reset%
reg query "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled 2>nul
reg query "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode 2>nul
call :PauseBack
goto GameMenu

:SetGameBar
set "VAL=%~1"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d %VAL% /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d %VAL% /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d %VAL% /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v GamePanelStartupTipOpen /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d %VAL% /f >nul
if "%VAL%"=="0" (echo  %Red%[выкл]%Reset%  Game Bar / AppCapture) else (echo  %Green%[вкл ]%Reset%  Game Bar / AppCapture)
exit /b

:SetDVR
set "VAL=%~1"
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d %VAL% /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d %VAL% /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v HistoricalCaptureEnabled /t REG_DWORD /d %VAL% /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul
if "%VAL%"=="0" (echo  %Red%[выкл]%Reset%  Фоновая запись / DVR) else (echo  %Green%[вкл ]%Reset%  Фоновая запись / DVR)
exit /b

:SetGameMode
set "VAL=%~1"
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d %VAL% /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d %VAL% /f >nul
if "%VAL%"=="0" (echo  %Red%[выкл]%Reset%  Game Mode) else (echo  %Green%[вкл ]%Reset%  Game Mode)
exit /b

rem ========================================================================
rem  12. ПОИСК И ЦЕЛОСТНОСТЬ
rem ========================================================================
:MaintMenu
call :Hdr "ПОИСК И ЦЕЛОСТНОСТЬ WINDOWS"
echo  %Bold%[1]%Reset%  Отключение индексации поиска
echo  %Bold%[2]%Reset%  Проверка целостности  (DISM + SFC)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto IdxMenu
if "%choice%"=="2" goto SFCMenu
if "%choice%"=="0" goto MainMenu
goto MaintMenu

:IdxMenu
call :Hdr "ОТКЛЮЧЕНИЕ ИНДЕКСАЦИИ ПОИСКА"
echo  %Gray%Выберите диски, на которых нужно отключить индексацию.%Reset%
echo  %Gray%Можно указать несколько букв через пробел: C D E%Reset%
echo.
echo  %Bold%Доступные диски:%Reset%
echo.
set "DriveList="
for /f "tokens=1" %%D in ('wmic logicaldisk get deviceid 2^>nul ^| find ":"') do (
    set "drv=%%D"
    if defined drv (
        echo  %Bold%[ !drv! ]%Reset%  !drv!\
        set "DriveList=!DriveList! !drv!"
    )
)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
echo  %Bold%[A]%Reset%  Все доступные диски
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if /i "%choice%"=="0" goto MaintMenu
if /i "%choice%"=="A" (
    set "Selected=%DriveList%"
    goto IdxConfirm
)
if not defined choice goto IdxMenu
set "Selected=%choice%"
goto IdxConfirm

:IdxConfirm
call :Hdr "ОТКЛЮЧЕНИЕ ИНДЕКСАЦИИ ПОИСКА"
echo  Выбрано:
for %%D in (%Selected%) do echo    %Bold%%%D\%Reset%
echo.
echo  %Yellow%Внимание:%Reset%
echo  %Gray%Для выбранных дисков файлы и папки будут помечены как%Reset%
echo  %Gray%"не индексировать содержимое". Поиск станет чуть медленнее.%Reset%
echo.
echo  %Bold%[1]%Reset%  Продолжить
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto IdxMenu
if "%choice%"=="1" goto IdxDisable
goto IdxConfirm

:IdxDisable
call :Hdr "ОТКЛЮЧЕНИЕ ИНДЕКСАЦИИ ПОИСКА"
set /a Count=0
for %%D in (%Selected%) do (
    set /a Count+=1
    echo  %Bold%[ !Count! ]%Reset%  Обработка %%D\...
    attrib +I "%%D\" /S /D >nul 2>&1
    if errorlevel 1 (
        echo       %Red%Не удалось обработать %%D\%Reset%
    ) else (
        echo       %Green%Индексация содержимого отключена.%Reset%
    )
    echo.
)
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
call :Ok "Операция завершена"
echo.
echo  %Gray%Windows больше не будет индексировать содержимое указанных%Reset%
echo  %Gray%файлов и папок на выбранных дисках.%Reset%
echo.
echo  %Yellow%Примечание:%Reset%
echo  %Gray%Служба Windows Search не отключается полностью.%Reset%
call :PauseBack
goto IdxMenu

:SFCMenu
call :Hdr "ПРОВЕРКА ЦЕЛОСТНОСТИ WINDOWS"
echo  %Bold%[1]%Reset%  Запустить DISM + SFC
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="1" goto IntegrityCheck
if "%choice%"=="0" goto MaintMenu
goto SFCMenu

:IntegrityCheck
call :Hdr "ПРОВЕРКА ЦЕЛОСТНОСТИ WINDOWS"
echo  Шаг 1 из 2: DISM - восстановление хранилища компонентов
echo.
echo  DISM.exe /Online /Cleanup-Image /RestoreHealth
echo.
DISM.exe /Online /Cleanup-Image /RestoreHealth
set "DISM_CODE=%errorlevel%"
echo.
if "%DISM_CODE%"=="0" (
    call :Ok "DISM выполнен успешно."
) else (
    call :Err "DISM завершился с кодом %DISM_CODE%."
    echo  SFC всё равно будет запущен.
)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo.
echo  Шаг 2 из 2: SFC - проверка системных файлов
echo.
echo  sfc.exe /scannow
echo.
sfc.exe /scannow
set "SFC_CODE=%errorlevel%"
echo.
if "%SFC_CODE%"=="0" (
    call :Ok "SFC выполнен успешно."
) else (
    call :Err "SFC завершился с кодом %SFC_CODE%."
)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  Итог:
echo  Код DISM: %DISM_CODE%
echo  Код SFC:  %SFC_CODE%
call :PauseBack
goto SFCMenu

rem ========================================================================
rem  13. БЕЗОПАСНОСТЬ (UAC)
rem ========================================================================
:SecMenu
call :Hdr "КОНТРОЛЬ УЧЁТНЫХ ЗАПИСЕЙ - UAC"
echo  %Bold%[1]%Reset%  Ослабить
echo  %Bold%[2]%Reset%  Вкл  (стандартный уровень)
echo.
echo  %Gray%--------------------------------------------------------------------%Reset%
echo  %Bold%[0]%Reset%  Назад
echo.
call :Ask
if "%choice%"=="0" goto MainMenu
if "%choice%"=="1" goto SecWeaken
if "%choice%"=="2" goto SecEnable
goto SecMenu

:SecWeaken
echo.
echo  %Yellow%Ослабление контроля учётных записей ^(UAC^)...%Reset%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f >nul 2>&1
call :Ok "UAC ослаблен"
call :PauseBack
goto SecMenu

:SecEnable
echo.
echo  %Yellow%Включение контроля учётных записей ^(UAC^)...%Reset%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f >nul 2>&1
call :Ok "UAC включён"
call :PauseBack
goto SecMenu
