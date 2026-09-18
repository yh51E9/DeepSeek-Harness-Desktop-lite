:find_panel replaced 556..561
:close_panel replaced 550..554
@echo off
rem ============================================================================
rem  DSH Æô¶¯Æ÷ ¡ª¡ª DeepSeek Harness Web UI Ò»¼üÆô¶¯
rem ============================================================================
rem
rem  ¡¾±£´æ¸ñÊ½ ¡¤ ¸Ä¶¯Ç°±Ø¶Á¡¿
rem    ±¾ÎÄ¼ş±ØĞë±£´æÎª ANSI / GBK(936) ±àÂë + CRLF »»ĞĞ£¬ÇÒ²»ÄÜ´ø BOM¡£
rem      ¡¤ ´æ³É UTF-8  -> ÖĞÎÄÂÒÂë
rem      ¡¤ ´æ³É LF »»ĞĞ -> cmd »á³ÔµôÃ¿ĞĞ¿ªÍ·Ò»¸ö×Ö·û£¨Èç chcp ±ä hcp£©£¬
rem                       ½ø¶ø½âÎö´íÂÒ¡¢Æô¶¯Ê§°Ü
rem
rem  ¡¾ÉúÃüÖÜÆÚ ¡¤ Éè¼ÆÒâÍ¼¡¿
rem    dsh ÊÇ¡°±¾¿ØÖÆÌ¨´°¿ÚµÄ×Ó½ø³Ì¡±£¬Òò´Ë£º
rem      ¡¤ ¹Ø±Õ¿ØÖÆÌ¨´°¿Ú  -> dsh Ò»²¢½áÊø£¨ÏëÍ£·şÎñ£¬¹Øµô¿ØÖÆÌ¨¼´¿É£©
rem      ¡¤ ¹Ø±Õ Edge ´°¿Ú  -> dsh ¼ÌĞøÔËĞĞ£¬¿ØÖÆÌ¨Ãæ°åÈÔÔÚ
rem      ¡¤ ¿ØÖÆÌ¨×îĞ¡»¯    -> dsh ¼ÌĞøÔËĞĞ£¨×îĞ¡»¯²»µÈÓÚ¹Ø±Õ£©
rem
rem  ¡¾¹¦ÄÜÒ»ÀÀ¡¿
rem    1. ÓÅÏÈÔÚ Windows Terminal ÖĞÔËĞĞ£»ÎŞ wt Ê±ÍË»ØÔ­Éú cmd
rem    2. ¿ØÖÆÌ¨Óë Edge ´°¿Ú¶¼¡°Ò»´ò¿ª¾ÍÔÚÆÁÄ»ÕıÖĞ¡±£¬²»»áÏÈ³öÏÖÔÙÌøÎ»
rem    3. ÖØ¸´Ë«»÷£ºÒÑÓĞÃæ°åÔòÖ»ÖØ¿ª½çÃæ£¬²»ÖØ¸´Æô¶¯ dsh
rem    4. ¿ØÖÆÌ¨ÔÚ´ò¿ª Edge ºó×Ô¶¯×îĞ¡»¯µ½ÈÎÎñÀ¸
rem    5. Ãæ°å´øÏñËØ¾¨ÓãÍ¼±êÓëÅäÉ«£¨½öÔÚ Windows Terminal ÏÂÉÏÉ«£©
rem    6. Ãæ°å°´¼ü£ºR ÖØ¿ª½çÃæ / C ¸´ÖÆ´ø token µØÖ· / Q Í£Ö¹·şÎñ
rem
rem  ¡¾ÒÑÖªÏŞÖÆ ¡¤ Edge ´°¿Ú±êÌâ¡¿
rem    dsh Ç°¶Ë»áÖ´ĞĞ document.title = "<»á»°Ãû> ¡ª DeepSeek Harness"£¬
rem    ¶ø Edge µÄ --app ´°¿Ú±êÌâÓÀÔ¶¸úËæÍøÒ³±êÌâ£¬Òò´ËËü»áËæ»°Ìâ±ä»¯¡¢
rem    ÇÒÎŞ·¨ÏÔÊ¾°æ±¾ºÅ¡£°æ±¾ºÅÖ»ÄÜ·ÅÔÚ¿ØÖÆÌ¨´°¿ÚµÄ±êÌâÉÏ¡£
rem ============================================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"
chcp 936 >nul 2>&1

rem ============================== ÅäÖÃÇø ======================================
set "SELF=%~f0"                        rem ±¾½Å±¾ÍêÕûÂ·¾¶£¨½»¸ø wt ÖØ¿ª×Ô¼ºÓÃ£©

set "LOG=%TEMP%\dsh-web.log"           rem dsh ±ê×¼Êä³öÈÕÖ¾£¨½Å±¾¿¿Ëü×¥µØÖ·£©
set "ERR=%TEMP%\dsh-web.err"           rem dsh ´íÎóÊä³öÈÕÖ¾
set "STATE=%TEMP%\dsh-web.state"       rem ÉÏ´Î´ø token µÄµØÖ·£¬¹©ÖØ¿ª½çÃæ¸´ÓÃ
set "PROBE=%TEMP%\dsh-web.probe"      rem Ì½²â 3080 ·şÎñÀàĞÍµÄÁÙÊ±ÎÄ¼ş
set "SLEEPVBS=%TEMP%\dsh-sleep.vbs"    rem Æô¶¯¶¯»­µÄÖ¡¼ä¸ô¼ÆÊ±Æ÷

set "PORT=3080"                        rem dsh ¼àÌı¶Ë¿Ú
set "URLBASE=http://127.0.0.1:3080/"   rem ÎŞ token Ê±µÄ¶µµ×µØÖ·£¨¿¿ 30 Ìì cookie£©

rem ×¨ÓÃ Edge ÅäÖÃÄ¿Â¼£ºÖ»ÓĞÓÃ¶ÀÁ¢ profile£¬--window-position ²Å»á±» Edge ²ÉÄÉ£¬
rem ´Ó¶ø×öµ½¡°´°¿ÚÒ»³öÏÖ¾ÍÔÚÕıÈ·Î»ÖÃ¡±¡£É¾µô¸ÃÄ¿Â¼²»Ó°ÏìÊ¹ÓÃ£¨»áÖØĞÂÉú³É£©¡£
set "EDGEPROFILE=%LOCALAPPDATA%\dsh-web-edge-profile"

rem Edge ´°¿Ú³ß´ç£ºÈ¡¹¤×÷ÇøµÄ 68%% ¿í / 72%% ¸ß£¬ÉÏÏŞ 1280x760
set "UI_W_RATIO=0.68"
set "UI_H_RATIO=0.72"
set "UI_MAX_W=1280"
set "UI_MAX_H=760"

rem ¿ØÖÆÌ¨´°¿Ú³ß´ç£¨µ¥Î»£º×Ö·ûĞĞÁĞ£©Óë WT µÄÏñËØ»»Ëã²ÎÊı
rem ×¢Òâ£ºÏÂÃæ 4 ¸öÏñËØ²ÎÊıÓÉ±¾»ú WT ×ÖÌå²âµÃ£¨Ã¿ÁĞ 10px¡¢Ã¿ĞĞ 21px¡¢
rem       ±ß¿ò 49x65£©¡£ÈôÄã¸Ä¹ı Windows Terminal µÄ×ÖÌå´óĞ¡£¬ĞèÖØĞÂ²âÁ¿¡£
set "CON_COLS=110"
set "CON_ROWS=31"
set "WT_CELL_W=10"
set "WT_CELL_H=21"
set "WT_FRAME_W=49"
set "WT_FRAME_H=65"
set "WT_POS_DX=8"                      rem wt --pos µÄÂäµã±È´«ÈëÖµĞ¡ 8£¬ÕâÀï²¹³¥
rem ============================================================================

rem ---------- ÑÕÉ«ÓëÍ¼±ê£º½öÔÚ Windows Terminal ÏÂÆôÓÃ ----------
rem ÏÈÓÃ prompt/$E ¼¼ÇÉÈ¡³ö ESC(0x1B) ×Ö½Ú£»È¡²»µ½¾Í×Ô¶¯½µ¼¶ÎªÎŞÑÕÉ«£¬
rem Òò´ËÏÂÃæËùÓĞ !C_xx! ±äÁ¿¶¼¿ÉÄÜÎª¿Õ£¬¿ÕÖµµÈ¼ÛÓÚ¡°²»ÉÏÉ«¡±¡£
call :init_colors

rem ---------- ¶ÁÈ¡°æ±¾ºÅ£¨ÓÃÓÚ´°¿Ú±êÌâÓëºá·ù£© ----------
set "VER=unknown"
for /f "delims=" %%v in ('dsh --version 2^>nul') do set "VER=%%v"

rem ============================================================================
rem  ½×¶Î 0 ¡¤ ¾ö¶¨´°¿ÚĞÎÌ¬
rem    ²»ÔÚ wt ÖĞÔËĞĞÊ±£ºÒÑÓĞÃæ°å -> Ö»ÖØ¿ª½çÃæ£»·ñÔòÓÃ wt ´ø¶¨Î»²ÎÊıÖØ¿ª×Ô¼º£»
rem    Á½Õß¶¼²»Âú×ãÊ±£¬Ô­µØÓÃÔ­Éú cmd Ãæ°å¼ÌĞø¡£
rem    £¨ÓÃ goto ¶ø·ÇÇ¶Ì× if£¬±ÜÃâÀ¨ºÅ¿éÄÚµÄÑÓ³ÙÕ¹¿ªÏİÚå£©
rem ============================================================================
if defined WT_SESSION goto panel_start
rem ½×¶Î 0 ¡¤ ¾ö¶¨´°¿ÚĞÎÌ¬
rem   1) dsh ÔÚÅÜÇÒÃæ°åÔÚ   -> ¸´ÓÃ£¬Ö»ÖØ¿ª½çÃæ
rem   2) dsh ÔÚÅÜ¡¢Ã»Ãæ°å   -> ¿ªÒ»¸öÃæ°å
rem   3) dsh Ã»ÔÚÅÜ         -> ¹Øµô²ĞÁôÃæ°å£¬ÓÉĞÂÃæ°åÆô¶¯ dsh
rem ×¢Òâ£º dsh ²»ÄÜÔÚÍâ²ã£¨Ë«»÷µÄ£©¿ØÖÆÌ¨ÀïÆô¶¯£¬·ñÔòËü»áËæÍâ²ãÍË³ö¶ø±»½áÊø
rem ¾ÉÃæ°åÈô»¹ÔÚÏÈ¹Øµô£¬±ÜÃâ¿ª³öÁ½¸ö´°¿Ú
call :get_pid
if not defined PID3080 goto need_new_panel
call :find_panel
if "!PANEL!"=="FOUND" goto reuse_panel
call :find_wt
if defined WTEXE goto launch_wt
goto panel_start

:reuse_panel
call :load_url
call :open_ui
exit /b 0

:launch_wt
call :spawn_console
exit /b 0

:need_new_panel
call :close_panel
call :find_wt
if defined WTEXE goto launch_wt
goto panel_start
:panel_start
title DeepSeek Harness !VER!

rem Ô­Éú cmd ¶µµ×£ºÎŞ·¨ÔÚÆô¶¯²ÎÊıÀï¶¨Î»£¬Ö»ÄÜ¿ªÍêÔÙÅ²Ò»´Î
if not defined WT_SESSION call :center_console

rem ÔËĞĞ»·¾³×Ô¼ì£ºÃ»ÓĞ node / dsh ¾ÍµØÒıµ¼£¬²»½øÈëÕı³£Á÷³Ì
call :check_runtime
if defined RUNTIME_ERR goto runtime_guide

call :get_pid
if not defined PID3080 goto start_dsh

call :probe_service
if not "!ISDSH!"=="DSH" goto occupied

call :load_url
goto show_menu

rem ============================================================================
rem  ½×¶Î 1.5 ¡¤ ÔËĞĞ»·¾³×Ô¼ì£ºnode / npm / dsh
rem ============================================================================
:check_runtime
set "RUNTIME_ERR="
rem npm/dsh µÄ shim ÊÇ .cmd Åú´¦Àí£ºÅúÄÚÂãÖ´ĞĞ»áÒÆ½»¿ØÖÆÈ¨²¢Ìø¹ıÊ£ÓàĞĞ£¬
rem ËùÒÔ×Ô¼ìÒ»ÂÉÓÃ where Ì½²â´æÔÚĞÔ£¬¾ø²»ÕæÕıÔËĞĞËüÃÇ¡£
where node >nul 2>&1
if errorlevel 1 (
    set "RUNTIME_ERR=node"
    exit /b 0
)
where npm >nul 2>&1
if errorlevel 1 (
    set "RUNTIME_ERR=npm"
    exit /b 0
)
where dsh >nul 2>&1
if errorlevel 1 set "RUNTIME_ERR=dsh"
exit /b 0

rem ×Ô¼ìÃ»¹ı£º°´È±Ê²Ã´¸øÊ²Ã´Ö¸Òı£¬¿´Íê°´ÈÎÒâ¼üÍË³ö
:runtime_guide
call :banner "»·¾³×Ô¼ìÎ´Í¨¹ı"
echo.
if "!RUNTIME_ERR!"=="node" (
    echo   !C_WARN![È±ÉÙ Node.js] ±¾½Å±¾ÒÀÀµ Node.js ÔËĞĞ dsh¡£!C_OFF!
    echo   !C_DIM!1. ´ò¿ª https://nodejs.org ÏÂÔØ LTS£¨ÎÈ¶¨°æ£©²¢°²×°£»!C_OFF!
    echo   !C_DIM!2. °²×°Íê³ÉºóÖØĞÂÔËĞĞ±¾½Å±¾¡£!C_OFF!
    echo   !C_DIM!½ø½×Íæ¼ÒÒ²¿ÉÒÔÓÃ nvm-windows ¹ÜÀí¶à°æ±¾ Node£¨¿ÉÑ¡£¬ÆÕÍ¨ÓÃ»§¿ÉºöÂÔ£©¡£!C_OFF!
) else if "!RUNTIME_ERR!"=="npm" (
    echo   !C_WARN![Node.js ²»ÍêÕû] ¼ì²âµ½ node µ«È±ÉÙ npm£¬½¨ÒéÖØ×° Node.js LTS¡£!C_OFF!
    echo   !C_DIM!ÏÂÔØµØÖ·£ºhttps://nodejs.org £¡C_OFF!
) else (
    echo   !C_WARN![È±ÉÙ dsh] ÒÑ¼ì²âµ½ Node.js£¬µ«»¹Ã»ÓĞ°²×° dsh¡£!C_OFF!
    echo   !C_DIM!Çë´ò¿ªÒ»¸öÃüÁîĞĞ´°¿Ú£¨Win+R ÊäÈë cmd »Ø³µ£©£¬Ö´ĞĞ£º!C_OFF!
    echo.
    echo   !C_KEY!npm install -g @deepseek-ai/dsh!C_OFF!
    echo.
    echo   !C_DIM!Íê³ÉºóÖØĞÂÔËĞĞ±¾½Å±¾¼´¿É¡£!C_OFF!
)
echo.
echo   !C_DIM!°´ÈÎÒâ¼ü¹Ø±Õ±¾´°¿Ú...!C_OFF!
pause >nul
exit /b 1

rem ============================================================================
rem  ½×¶Î 2 ¡¤ Æô¶¯ dsh
rem    ÓÃ start /b ÈÃ dsh ÁôÔÚ¡°±¾¿ØÖÆÌ¨¡±Àï£º¿ØÖÆÌ¨Ò»¹Ø£¬dsh ËæÖ®½áÊø¡£
rem    ÖØ¶¨ÏòĞ´ÔÚ×îÍâ²ã£¬ÕâÑù dsh µÄÊä³öÄÜÂäµ½ÈÕÖ¾ÎÄ¼ş¹©½Å±¾½âÎö¡£
rem ============================================================================
:start_dsh
rem Çå¿ÕÔËĞĞ×´Ì¬£ºbanner ÊıÖµÁĞ¹Ì¶¨£¬spinner Ö»¸²Ğ´ÊıÖµÇø
set "RUNSTATE="
call :banner ""
del "%LOG%" "%ERR%" 2>nul
echo WScript.Sleep WScript.Arguments(0)>"%SLEEPVBS%"
start /b "" cmd /c dsh web --no-open >"%LOG%" 2>&1

set "URL="
set /a tries=0
set /a fr=0

:wait_ready
for /f "tokens=3" %%u in ('findstr /b /c:"dsh web: http" "%LOG%" 2^>nul') do set "URL=%%u"
if defined URL goto launched
findstr /c:"EADDRINUSE" "%ERR%" "%LOG%" >nul 2>&1 && goto port_busy
set /a tries+=1
if !tries! geq 320 goto wait_timeout
call :start_spin
cscript //nologo "%SLEEPVBS%" 300 >nul 2>&1
goto wait_ready

:launched
call :get_pid
> "%STATE%" echo !URL!
goto show_menu

:port_busy
call :banner "Æô¶¯Ê§°Ü"
echo.
echo [´íÎó] 3080 ¶Ë¿ÚÒÑ±»Õ¼ÓÃ£¨EADDRINUSE£©£¬dsh ÎŞ·¨Æô¶¯¡£
echo         Í¨³£ËµÃ÷ÒÑÓĞÒ»¸ö dsh web ÔÚÔËĞĞ¡£
echo ------------------------------------------------------------
findstr /c:"EADDRINUSE" "%ERR%" 2>nul
echo ------------------------------------------------------------
pause
exit /b 1

:wait_timeout
call :banner "Æô¶¯Ê§°Ü"
echo.
echo [´íÎó] µÈ´ı 120 ÃëÈÔÎ´È¡µÃµØÖ·£¬dsh Æô¶¯Ê§°Ü¡£ÈÕÖ¾Î²²¿£º
echo ------------------------------------------------------------
powershell -NoProfile -Command "if (Test-Path -LiteralPath '%LOG%') { Get-Content -LiteralPath '%LOG%' -Tail 20 -Encoding UTF8 } else { Write-Output '(ÎŞÈÕÖ¾)' }"
if exist "%ERR%" powershell -NoProfile -Command "Get-Content -LiteralPath '%ERR%' -Tail 20 -Encoding UTF8"
echo ------------------------------------------------------------
pause
exit /b 1

:occupied
call :banner "¶Ë¿Ú±»Õ¼ÓÃ"
echo.
echo [´íÎó] 3080 ÒÑ±»¡°·Ç dsh ³ÌĞò¡±Õ¼ÓÃ ^(PID !PID3080!^)£¬±¾½Å±¾²»¸ÒÂÒ¶¯¡£
echo         ÇëÏÈÊÍ·Å 3080£¬»ò¸ÄÓÃ dsh web --port ^<ÆäËü¶Ë¿Ú^>¡£
echo.
pause
exit /b 1

rem ============================================================================
rem  ½×¶Î 3 ¡¤ ´ò¿ª½çÃæ£¨¸úËæÄ¬ÈÏä¯ÀÀÆ÷£¬¿ªÔÚÕıÖĞ£©+ ¿ØÖÆÌ¨×îĞ¡»¯ + ¿ØÖÆÃæ°å
rem ============================================================================
:show_menu
rem ±êÌâ±ØĞëÔÚÕâÀï£¨¶ø²»ÊÇ¸üÔç£©ÔÙÉèÒ»´Î£º
rem start /b À­ÆğµÄ×Ó cmd£¨ÅÜ dsh£©»áÇÀÕ¼¿ØÖÆÌ¨±êÌâ²¢°ÑËü¸Ä³É cmd.exe£¬
rem Ò»µ©±»¸Ä¾ÍÔÙÒ²»Ø²»À´£»Êµ²âÖ»ÓĞÔÚ dsh ÆğÀ´Ö®ºóÔÙ title ²ÅÎÈ¶¨ÉúĞ§¡£
title DeepSeek Harness !VER!
call :load_url
call :open_ui
if defined WT_SESSION call :minimize_panel

:menu_loop
call :get_pid
set "RUNSTATE=ÒÑÍ£Ö¹"
if defined PID3080 set "RUNSTATE=ÔËĞĞÖĞ"
call :banner ""

rem ---- interactive input ----
rem ½»»¥ÊäÈë£ºWindows Terminal ÏÂÓÃÄÚÇ¶¸¨Öú½Å±¾¶ÁÕæÊµÊó±êµã»÷£»ÆäËüÖÕ¶ËÍË»Ø choice ÌáÊ¾¡£
set "DSHACT="
if not defined WT_SESSION goto plain_choice
call :ensure_panel
powershell -NoProfile -ExecutionPolicy Bypass -File "!PANELPS!" -RowUrl 19 -RowR 22 -RowC 23 -RowV 24 -RowU 25 -RowQ 26 -RowEnd 30 2>nul
set "DSHACT=!errorlevel!"
if not defined DSHACT set "DSHACT=0"
if "!DSHACT!"=="0" goto menu_loop
rem ÍË³öÂë < 10 ËµÃ÷ÖúÊÖ½Å±¾±¾ÉíÊ§°Ü£¨±ÀÀ£/²ÎÊı´í£©£¬¾ø²»ÄÜµ±³É²Ëµ¥¶¯×÷
if !DSHACT! lss 10 goto menu_loop
if "!DSHACT!"=="14" goto open_url
if "!DSHACT!"=="16" goto do_update
if "!DSHACT!"=="15" goto check_update
if "!DSHACT!"=="13" goto quit
if "!DSHACT!"=="12" goto copy_link
if "!DSHACT!"=="11" goto reopen
goto menu_loop
goto menu_loop

:plain_choice
choice /c RCUVQ /n /m "ÇëÑ¡Ôñ (R/C/V/U/Q): "
if errorlevel 5 goto quit
if errorlevel 4 goto do_update
if errorlevel 3 goto check_update
if errorlevel 2 goto copy_link
if errorlevel 1 goto reopen
rem µã»÷µØÖ·ĞĞ£ºÓÃÆÕÍ¨ Edge ´°¿Ú´ò¿ª£¨·Ç¾«¼ò°æ£©
:open_url
rem ÆÕÍ¨´°¿Ú´ò¿ª£º²»¼Ó --app£¬±£ÁôµØÖ·À¸ºÍ±êÇ©À¸
start "" "!URL!"
goto menu_loop
:reopen
call :get_pid
if not defined PID3080 (
    echo.
    echo   !C_DIM!dsh ÒÑ²»ÔÚÔËĞĞ£¬½«ÖØĞÂÆô¶¯...!C_OFF!
    ping -n 3 127.0.0.1 >nul
    goto start_dsh
)
call :open_ui
goto menu_loop

:copy_link
echo !URL!| clip
echo.
echo   !C_OK!ÒÑ¸´ÖÆµ½¼ôÌù°å!C_OFF!  !C_CYAN!!URL!!C_OFF!
ping -n 3 127.0.0.1 >nul
goto menu_loop

:quit
echo.
call :get_pid
if defined PID3080 (
    echo   ÕıÔÚÍ£Ö¹ dsh ^(PID !PID3080!^) ...
    taskkill /pid !PID3080! /f >nul 2>&1
)
del "%STATE%" 2>nul
echo   ÒÑÍ£Ö¹¡£
ping -n 3 127.0.0.1 >nul
exit /b 0

rem ============================================================================
rem  ºá·ù£ºÏñËØ¾¨ÓãÍ¼±ê + ×´Ì¬ĞÅÏ¢
rem    %1 = ¿ÉÑ¡¸±±êÌâ£¬ÏÔÊ¾ÔÚÍ¼±êÏÂ·½
rem    Í¼±êÑÕÉ« C_ART¡¢ÎÄ×ÖÑÕÉ« C_* ÓÉ :init_colors ¾ö¶¨£»·Ç wt ÏÂÈ«Îª¿Õ£¬
rem    ´ËÊ±µÈÍ¬ÓÚ´¿ÎÄ±¾ºá·ù£¬²»»á³öÏÖ×ªÒå×Ö·ûÂÒÂë¡£
rem ============================================================================
:banner
rem Re-assert GBK codepage: dsh 0.1.6 pwsh tool shell flips the console to UTF-8 (65001),
rem and this script is GBK-encoded -- without this every banner redraw shows mojibake.
chcp 936 >nul
cls
rem ÔËĞĞ×´Ì¬ÅäÉ«£ºÔËĞĞÖĞ=ÂÌ£¬ÆäÓà=À¶»Ò¡£´Ë´¦Ã¿´ÎÖØËã£¬
rem ²»ÄÜ·Å½ø :init_colors ¡ª¡ª ÄÇÊ± RUNSTATE »¹Ã»±»¸³Öµ¡£
rem Í¼±êÈ¡×Ô ascii-art.txt£¬ÆäÖĞµÄ + ÔÚ¹¹½¨Ê±Ìæ»»ÎªÊµĞÄ¿é£¨¸üºñÊµ£©¡£
set "C_RUNSTATE=!C_OK!"
if not "!RUNSTATE!"=="ÔËĞĞÖĞ" set "C_RUNSTATE=!C_DIM!"
echo.
echo   !C_L0!                          ¨€           !C_OFF!
echo   !C_L1!       ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€      ¨€¨€¨€          !C_OFF!   !C_G0!¨V¨T¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨[ ¨V¨T¨T¨[!C_OFF!
echo   !C_L2!    ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€     ¨€¨€¨€¨€¨€¨€ ¨€¨€¨€¨€¨€¨€!C_OFF!   !C_G1!©¸©´ ¨W©¤©´ ¨U ©¦ ¨W©¤©¤©¤¨` ©¦ ¨W©¤©¤©¤¨` ©¦ ¨W©¤©´ ¨U ©¦ ¨W©¤©¤©¤¨` ©¦ ¨W©¤©¤©¤¨` ©¦ ¨W©¤©¤©¤¨` ©¦ ¨U¨V¨_ ¨W¨`!C_OFF!
echo   !C_L3!  ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€    ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€ !C_OFF!   !C_G2! ©¦ ¨U ©¦ ¨U ©¦ ¨^¨T¨[   ©¦ ¨^¨T¨[   ©¦ ¨^¨T¨_ ¨U ©¦ ¨^¨T¨T¨T¨[ ©¦ ¨^¨T¨[   ©¦ ¨^¨T¨[   ©¦ ¨^¨_ ¨^¨T¨[!C_OFF!
echo   !C_L4! ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€    ¨€¨€¨€¨€¨€¨€¨€¨€  !C_OFF!   !C_G3! ©¦ ¨U ©¦ ¨U ©¦ ¨W©¤¨`   ©¦ ¨W©¤¨`   ©¦ ¨W©¤©¤©¤¨` ©¸©¤©¤©¤©´ ¨U ©¦ ¨W©¤¨`   ©¦ ¨W©¤¨`   ©¦ ¨W©¤©¤©´ ¨U!C_OFF!
echo   !C_L5!¨€¨€¨€    ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€ ¨€¨€¨€¨€      !C_OFF!   !C_G4!¨V¨_ ¨^¨T¨_ ¨U ©¦ ¨^¨T¨T¨T¨[ ©¦ ¨^¨T¨T¨T¨[ ©¦ ¨U     ¨V¨T¨T¨T¨_ ¨U ©¦ ¨^¨T¨T¨T¨[ ©¦ ¨^¨T¨T¨T¨[ ©¦ ¨U  ©¦ ¨U!C_OFF!
echo   !C_L6!¨€¨€¨€         ¨€¨€¨€¨€¨€¨€¨€¨€   ¨€¨€¨€¨€¨€¨€¨€¨€¨€      !C_OFF!   !C_G5!©¸©¤©¤©¤©¤©¤©¤¨` ©¸©¤©¤©¤©¤©¤¨` ©¸©¤©¤©¤©¤©¤¨` ©¸©¤¨`     ©¸©¤©¤©¤©¤©¤¨` ©¸©¤©¤©¤©¤©¤¨` ©¸©¤©¤©¤©¤©¤¨` ©¸©¤¨`  ©¸©¤¨`!C_OFF!
echo   !C_L7!¨€¨€¨€           ¨€¨€¨€¨€¨€¨€¨€¨€   ¨€¨€¨€¨€¨€¨€       !C_OFF!   !C_G0!¨V¨T¨[ ¨V¨T¨[ ¨V¨T¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨[  ¨V¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[ ¨V¨T¨T¨T¨T¨T¨[     !C_OFF!
echo   !C_L8!¨€¨€¨€¨€            ¨€¨€¨€¨€¨€¨€¨€ ¨€¨€¨€¨€¨€¨€¨€       !C_OFF!   !C_G1!©¦ ¨U ©¦ ¨U ©¦ ¨W©¤©¤©´ ¨U ©¦ ¨W©¤©¤©´ ¨U ©¦   ¨^¨[ ©¦ ¨U ©¦ ¨W©¤©¤©¤¨` ©¦ ¨W©¤©¤©¤¨` ©¦ ¨W©¤©¤©¤¨`     !C_OFF!
echo   !C_L9! ¨€¨€¨€¨€            ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€        !C_OFF!   !C_G2!©¦ ¨^¨T¨_ ¨U ©¦ ¨^¨T¨T¨_ ¨U ©¦ ¨^¨T¨T¨_ ¨U ©¦ ¨c©´ ¨^¨[©¦ ¨U ©¦ ¨^¨T¨[   ©¦ ¨^¨T¨T¨T¨[ ©¦ ¨^¨T¨T¨T¨[     !C_OFF!
echo   !C_L10!  ¨€¨€¨€¨€             ¨€¨€¨€¨€¨€¨€¨€¨€¨€          !C_OFF!   !C_G3!©¦ ¨W©¤©´ ¨U ©¦ ¨W©¤©¤©´ ¨U ©¦ ¨W©¤©´ ¨W¨` ©¦ ¨U©¸©´ ¨^¨e ¨U ©¦ ¨W©¤¨`   ©¸©¤©¤©¤©´ ¨U ©¸©¤©¤©¤©´ ¨U     !C_OFF!
echo   !C_L11!   ¨€¨€¨€¨€¨€     ¨€¨€¨€    ¨€¨€¨€¨€¨€¨€¨€           !C_OFF!   !C_G4!©¦ ¨U ©¦ ¨U ©¦ ¨U  ©¦ ¨U ©¦ ¨U ©¦ ¨^¨[ ©¦ ¨U ©¸©´   ¨U ©¦ ¨^¨T¨T¨T¨[ ¨V¨T¨T¨T¨_ ¨U ¨V¨T¨T¨T¨_ ¨U     !C_OFF!
echo   !C_L12!     ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€   ¨€¨€¨€¨€¨€¨€¨€¨€        !C_OFF!   !C_G5!©¸©¤¨` ©¸©¤¨` ©¸©¤¨`  ©¸©¤¨` ©¸©¤¨` ©¸©¤©¤¨` ©¸©¤¨`  ©¸©¤©¤©¤¨` ©¸©¤©¤©¤©¤©¤¨` ©¸©¤©¤©¤©¤©¤¨` ©¸©¤©¤©¤©¤©¤¨`     !C_OFF!
echo   !C_L13!        ¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€¨€                !C_OFF!
echo.
echo   !C_LINE!©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤!C_OFF!
echo   !C_BOLD!!C_TITLE!DeepSeek!C_OFF! !C_BOLD!!C_VER!Harness!C_OFF!   !C_VER!v!VER!!C_OFF!
echo   !C_LBL!×´Ì¬!C_OFF!  !C_RUNSTATE!!RUNSTATE!!C_OFF!    !C_LBL!¶Ë¿Ú!C_OFF!  !C_VAL!%PORT%!C_OFF!    !C_LBL!PID!C_OFF!  !C_VAL!!PID3080!!C_OFF!
echo   !C_LBL!µØÖ·!C_OFF!  !C_URL!!URL!!C_OFF!
echo   !C_LINE!©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤!C_OFF!
echo.
echo   !C_KEY![R]!C_OFF! !C_MENU!ÖØĞÂ´ò¿ª½çÃæ!C_OFF!
echo   !C_KEY![C]!C_OFF! !C_MENU!¸´ÖÆ´ø token µÄµØÖ·!C_OFF!
echo   !C_KEY![V]!C_OFF! !C_MENU!¼ì²éĞÂ°æ±¾!C_OFF!
echo   !C_KEY![U]!C_OFF! !C_MENU!¸üĞÂ/»ØÍËµ½×îĞÂÎÈ¶¨°æ!C_OFF!
echo   !C_KEY![Q]!C_OFF! !C_MENU!Í£Ö¹·şÎñ²¢ÍË³ö!C_OFF!
echo.
echo   !C_DIM!ÌáÊ¾£º¹Ø±Õ±¾¿ØÖÆÌ¨»áÍ¬Ê±½áÊø dsh£»Ö»¹Ø½çÃæ´°¿ÚÔò dsh ¼ÌĞøÔÚºóÌ¨ÔËĞĞ¡£!C_OFF!
echo   !C_WARN!%~1!C_OFF!
exit /b 0

rem ============================================================================
rem  ×Ó¹ı³Ì
rem ============================================================================

rem ³õÊ¼»¯ÑÕÉ«±äÁ¿¡£Ö»ÓĞÔËĞĞÔÚ Windows Terminal ÏÂ²ÅÉÏÉ«£¬ÆäËüÖÕ¶ËÒ»ÂÉÁô¿Õ£¬
rem ÕâÑùÔÚ¾É cmd ÀïÒ²²»»á³öÏÖ ^[[38;5;..m ÕâÀà×ªÒåÂÒÂë¡£
rem ÓÃ 256 É«ºÅ£¬ÉîÇ³´îÅä±£Ö¤ÔÚÉîÉ«±³¾°ÉÏ¿É¶Á¡£
:init_colors
set "ESC="
if not defined WT_SESSION goto init_colors_done
for /f "delims=#" %%E in ('"prompt #$E# & echo on & for %%F in (1) do rem"') do if not defined ESC set "ESC=%%E"
if not defined ESC goto init_colors_done
set "C_G0=%ESC%[38;2;28;88;255m"
set "C_G1=%ESC%[38;2;74;128;255m"
set "C_G2=%ESC%[38;2;136;176;255m"
set "C_G3=%ESC%[38;2;198;217;252m"
set "C_G4=%ESC%[38;2;236;238;240m"
set "C_G5=%ESC%[38;2;250;249;246m"
set "C_L0=%ESC%[38;2;28;88;255m"
set "C_L1=%ESC%[38;2;46;103;255m"
set "C_L2=%ESC%[38;2;63;119;255m"
set "C_L3=%ESC%[38;2;84;135;255m"
set "C_L4=%ESC%[38;2;107;154;255m"
set "C_L5=%ESC%[38;2;131;172;255m"
set "C_L6=%ESC%[38;2;155;189;254m"
set "C_L7=%ESC%[38;2;179;204;253m"
set "C_L8=%ESC%[38;2;201;219;251m"
set "C_L9=%ESC%[38;2;216;227;246m"
set "C_L10=%ESC%[38;2;230;235;242m"
set "C_L11=%ESC%[38;2;239;241;241m"
set "C_L12=%ESC%[38;2;245;245;244m"
set "C_L13=%ESC%[38;2;250;249;246m"
set "C_TITLE=%ESC%[38;2;96;152;255m"
set "C_VER=%ESC%[38;2;244;246;252m"
set "C_LBL=%ESC%[38;2;142;172;232m"
set "C_VAL=%ESC%[38;2;228;238;255m"
set "C_URL=%ESC%[4;38;2;108;160;255m"
set "C_KEY=%ESC%[1;38;2;122;170;255m"
set "C_MENU=%ESC%[38;2;198;214;245m"
set "C_LINE=%ESC%[38;2;64;100;176m"
set "C_DIM=%ESC%[38;2;126;152;200m"
set "C_OK=%ESC%[38;2;88;216;138m"
set "C_WARN=%ESC%[38;2;236;188;118m"
set "C_SPIN=%ESC%[1;38;2;120;180;255m"
set "C_BOLD=%ESC%[1m"
set "C_OFF=%ESC%[0m"
:init_colors_done
exit /b 0

rem Æô¶¯¶¯»­£ºÔÚ×´Ì¬ĞĞÔ­µØË¢ĞÂÒ»Ö¡£¬±ÜÃâË¢ÆÁ
:start_spin
rem ÕûĞĞÖØ»æ×´Ì¬ĞĞ£¨¶¨Î» + ÇåĞĞ£©£¬Ö¡ÄÚÈİ = ×ªÂÖ + ÕıÔÚÆô¶¯¡£
if not defined WT_SESSION exit /b 1
set /a fr+=1
if !fr! gtr 8 set /a fr=1
set "SP=|"
if !fr!==2 set "SP=/"
if !fr!==3 set "SP=-"
if !fr!==4 set "SP=\"
if !fr!==5 set "SP=|"
if !fr!==6 set "SP=/"
if !fr!==7 set "SP=-"
if !fr!==8 set "SP=\"
echo [19;10H[K!C_SPIN!!SP! ÕıÔÚÆô¶¯!C_OFF!
exit /b 0


rem ============================================================================
rem  °æ±¾¼ì²é / ¸üĞÂ£¨°üÃû @deepseek-ai/dsh£¬È«¾Ö npm °²×°£©
rem ============================================================================
:check_update
cls
call :banner ""
echo.
echo   !C_LBL!±¾µØ°æ±¾!C_OFF!     !C_VAL!!VER!!C_OFF!
set "LATEST="
set "NEXTAG="
for /f "delims=" %%v in ('npm view @deepseek-ai/dsh version 2^>nul') do set "LATEST=%%v"
for /f "delims=" %%v in ('npm view @deepseek-ai/dsh dist-tags.next 2^>nul') do set "NEXTAG=%%v"
rem npm »á¸Äµô¿ØÖÆÌ¨±êÌâ£¬ÕâÀï»Ö¸´£¨·ñÔò find_panel / minimize_panel ÕÒ²»µ½±¾´°¿Ú£©
title DeepSeek Harness !VER!
if not defined LATEST goto chk_offline
echo   !C_LBL!×îĞÂ°æ±¾!C_OFF!     !C_VAL!!LATEST!!C_OFF!
if defined NEXTAG echo   !C_LBL!Ô¤·¢²¼ next!C_OFF!  !C_DIM!!NEXTAG!!C_OFF!
if /i "!LATEST!"=="!VER!" goto chk_same
echo.
echo   !C_WARN!·¢ÏÖĞÂ°æ±¾£º!VER! --^> !LATEST!!C_OFF!
echo   !C_DIM!°´ U ¿É¸üĞÂ/»ØÍËµ½×îĞÂÎÈ¶¨°æ!C_OFF!
goto chk_wait
:chk_same
echo.
echo   !C_OK!ÒÑ¾­ÊÇ×îĞÂ°æ±¾!C_OFF!
echo   !C_DIM!Ïë³¢ÏÊ²âÊÔ°æ£ºnpm install -g @deepseek-ai/dsh@next!C_OFF!
goto chk_wait
:chk_offline
echo.
echo   !C_WARN!ÎŞ·¨²éÑ¯¸üĞÂ£¨ÍøÂç²»¿ÉÓÃ»ò npm ÕÒ²»µ½£©!C_OFF!
:chk_wait
echo.
echo   !C_DIM!°´ÈÎÒâ¼ü·µ»Ø²Ëµ¥...!C_OFF!
pause >nul
goto menu_loop

:do_update
cls
call :banner ""
echo.
echo   !C_WARN!ÕıÔÚ´Ó npm °²×°×îĞÂÎÈ¶¨°æ£¨Èôµ±Ç°ÊÇ²âÊÔ°æÔò»ØÍË£©£¬ÇëÉÔºò...!C_OFF!
echo.
call npm install -g @deepseek-ai/dsh@latest
set "UPDRC=!errorlevel!"
echo.
set "NEWVER=unknown"
for /f "delims=" %%v in ('dsh --version 2^>nul') do set "NEWVER=%%v"
title DeepSeek Harness !VER!
if not "!UPDRC!"=="0" goto upd_failed
if /i "!NEWVER!"=="!VER!" goto upd_nochange
echo   !C_OK!¸üĞÂÍê³É£º!VER! --^> !NEWVER!!C_OFF!
set "VER=!NEWVER!"
goto upd_tail
:upd_nochange
echo   !C_OK!ÒÑ´¦ÓÚ×îĞÂÎÈ¶¨°æ£¬ÎŞĞè¸üĞÂ/»ØÍË!C_OFF!
echo   !C_DIM!Ïë³¢ÏÊ²âÊÔ°æ£ºnpm install -g @deepseek-ai/dsh@next!C_OFF!
goto upd_tail
:upd_failed
echo   !C_WARN!¸üĞÂÊ§°Ü£¬Çë²é¿´ÉÏÃæµÄ npm Êä³ö!C_OFF!
:upd_tail
echo.
echo   !C_DIM!ÌáÊ¾£ºdsh ÕıÔÚÔËĞĞÖĞ£¬°´ Q ÍË³öºóÖØĞÂË«»÷½Å±¾¼´¿ÉÓÃÉÏĞÂ°æ±¾¡£!C_OFF!
echo.
echo   !C_DIM!°´ÈÎÒâ¼ü·µ»Ø²Ëµ¥...!C_OFF!
pause >nul
goto menu_loop
rem °ÑÄÚÇ¶µÄ½»»¥Ãæ°å½Å±¾ÊÍ·Åµ½ %TEMP%£¬Ö»ĞèÊÍ·ÅÒ»´Î
:ensure_panel
set "PANELPS=%TEMP%\dsh-panel.ps1"
if not exist "!PANELPS!" goto panel_write
findstr /c:"DSHPANELVER11" "!PANELPS!" >nul 2>&1 && exit /b 0
:panel_write
set "PANELB64=%TEMP%\dsh-panel.b64"
del "!PANELB64!" 2>nul
> "!PANELB64!" echo IyA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CiMgIGRzaC1wYW5lbC5wczEgLS0gaW50ZXJhY3RpdmUgaW5wdXQgbGF5ZXIgZm9yIHRoZSBEU0ggbGF1bmNoZXIgcGFuZWwuCiMKIyAgUmV0dXJucyBhbiBhY3Rpb24gY29kZSBhcyBpdHMgZXhpdCBjb2RlOgojICAgICAgMCA9IG5vdGhpbmcgICAxID0gUiAocmVvcGVuKSAgIDIgPSBDIChjb3B5KSAgICAgMyA9IFEgKHF1aXQpCiMgICAgICA0ID0gVVJMIHJvdyBjbGlja2VkICAgICAgICAgICAgNSA9IFYgKGNoZWNrIHZlcnNpb24pCiMgICAgICA2ID0gVSAodXBkYXRlIHRvIGxhdGVzdCkKIwojICBjbWQuZXhlIGNhbm5vdCByZWFkIG1vdXNlIGV2ZW50cywgc28gdGhpcyBoZWxwZXIgZG9lcyBpdCB2aWEgdGhlIFdpbjMyCiMgIGNvbnNvbGUgQVBJLiBXaW5kb3dzIFRlcm1pbmFsIHJlcG9ydHMgbW91c2UgcG9zaXRpb25zIGluIENIQVJBQ1RFUiBjZWxscywKIyAgd2hpY2ggaXMgZXhhY3RseSB3aGF0IHdlIG5lZWQgdG8gaGl0LXRlc3QgdGhlIHJvd3Mgd2UgZHJldy4KIwojICBJTVBPUlRBTlQgLS0gYSBjbGljayBtdXN0IGJlIGRldGVjdGVkIGJ5IGEgKmZyZXNoIHByZXNzKiwgbm90IGJ5IHRoZSBidXR0b24KIyAgYml0IGFsb25lLiBXaW5kb3dz
>> "!PANELB64!" echo IFRlcm1pbmFsIHNldHMgTU9VU0VfTU9WRUQgKDB4MDAwMSkgb24gbW92ZW1lbnQgZXZlbnRzLAojICBhbmQgaWYgdGhlIGJ1dHRvbiBpcyBoZWxkIChvciBpdHMgc3RhdGUgZ29lcyBzdGFsZSkgdGhvc2UgbW92ZXMgYWxzbyBjYXJyeQojICB0aGUgImJ1dHRvbiBkb3duIiBiaXQuIEFjdGluZyBvbiB0aGUgYml0IGFsb25lIHRoZXJlZm9yZSBtYWtlcyBhY3Rpb25zIGZpcmUKIyAgb24gbWVyZSBob3Zlci4gU28gd2UgcmVxdWlyZToKIyAgICAgIC0gdGhlIGJ1dHRvbiBpcyBkb3duLAojICAgICAgLSBpdCB3YXMgdXAgb24gdGhlIHByZXZpb3VzIGV2ZW50IChhIHJlYWwgcHJlc3MgdHJhbnNpdGlvbiksCiMgICAgICAtIHRoZSBldmVudCBpcyBOT1QgZmxhZ2dlZCBNT1VTRV9NT1ZFRC4KIyAgQWZ0ZXIgZmlyaW5nIHdlIGFsc28gZHJhaW4gdW50aWwgdGhlIGJ1dHRvbiBpcyByZWxlYXNlZCwgc28gdGhlIHRlcm1pbmFsJ3MKIyAgYnV0dG9uIHN0YXRlIHN0YXlzIGluIHN5bmMgZm9yIHRoZSBuZXh0IGludm9jYXRpb24uCiMKIyAgUm93IG51bWJlcnMgYXJlIHBhc3NlZCBpbiBhcyBhcmd1bWVudHMgYnkgdGhlIGxhdW5jaGVyLCBzbyB0aGlzIGZpbGUgaXMKIyAgc3RhdGljIGFuZCBjYW4gYmUgZW1iZWRkZWQgdmVyYmF0aW0gKGJhc2U2NCkgaW5zaWRlIHRoZSAuYmF0LgojID09PT09PT09
>> "!PANELB64!" echo PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KIyBEU0hQQU5FTFZFUjExDQpwYXJhbSgKICBbUGFyYW1ldGVyKE1hbmRhdG9yeT0kdHJ1ZSldW2ludF0kUm93VXJsLAogIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSR0cnVlKV1baW50XSRSb3dSLAogIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSR0cnVlKV1baW50XSRSb3dDLAogIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSR0cnVlKV1baW50XSRSb3dWLAogIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSR0cnVlKV1baW50XSRSb3dVLAogIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSR0cnVlKV1baW50XSRSb3dRLAogIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSR0cnVlKV1baW50XSRSb3dFbmQKKQoKIyBTaW5nbGUtaW5zdGFuY2UgZ3VhcmQ6IG9ubHkgb25lIGhlbHBlciBtYXkgcmVhZCBjb25zb2xlIGlucHV0LiBBIGxpbmdlcmluZwojIGhlbHBlciAoZS5nLiBvbmUgd2hvc2UgY21kIHdhcyBraWxsZWQpIHdvdWxkIHNpbGVudGx5IHN3YWxsb3cgb3VyIGNsaWNrcywKIyBzbyBvbiBjb250ZW50aW9uIHdlIHRlcm1pbmF0ZSB0aGUgc3RhbGUgb25lcyBhbmQgdGFrZSBvdmVyLgokbXR4ID0gTmV3LU9iamVjdCBTeXN0ZW0uVGhyZWFkaW5nLk11dGV4KCRmYWxzZSwgJ0xvY2FsXGRzaC1wYW5lbC1p
>> "!PANELB64!" echo bnB1dCcpCiMgV2FpdE9uZSB0aHJvd3MgQWJhbmRvbmVkTXV0ZXhFeGNlcHRpb24gd2hlbiB0aGUgcHJldmlvdXMgb3duZXIgZGllZCB3aXRob3V0CiMgcmVsZWFzaW5nIHRoZSBtdXRleCAtLSB3aGljaCBpcyBleGFjdGx5IHdoYXQgb3VyIG93biBzdGFsZS1oZWxwZXIgY2xlYW51cAojIGRvZXMsIHNvIHRoaXMgaXMgYSBub3JtYWwgcGF0aCwgbm90IGFuIGVycm9yLiBXaGVuIGl0IHRocm93cyB3ZSBETyBhbHJlYWR5CiMgb3duIHRoZSBtdXRleCwgc28gdHJlYXQgaXQgYXMgc3VjY2VzcyBpbnN0ZWFkIG9mIGxldHRpbmcgdGhlIHNjcmlwdCBjcmFzaC4KJGhhdmVNdXRleCA9ICRmYWxzZQp0cnkgeyAkaGF2ZU11dGV4ID0gJG10eC5XYWl0T25lKDE1MDApIH0KY2F0Y2ggW1N5c3RlbS5UaHJlYWRpbmcuQWJhbmRvbmVkTXV0ZXhFeGNlcHRpb25dIHsgJGhhdmVNdXRleCA9ICR0cnVlIH0KY2F0Y2ggeyAkaGF2ZU11dGV4ID0gJGZhbHNlIH0KaWYgKC1ub3QgJGhhdmVNdXRleCkgewogIEdldC1DaW1JbnN0YW5jZSBXaW4zMl9Qcm9jZXNzIC1GaWx0ZXIgIk5hbWU9J3Bvd2Vyc2hlbGwuZXhlJyIgLUVycm9yQWN0aW9uIFNpbGVudGx5Q29udGludWUgfAogICAgV2hlcmUtT2JqZWN0IHsgJF8uQ29tbWFuZExpbmUgLWxpa2UgJypkc2gtcGFuZWwucHMxKicgLWFuZCAkXy5Qcm9jZXNzSWQgLW5l
>> "!PANELB64!" echo ICRQSUQgfSB8CiAgICBGb3JFYWNoLU9iamVjdCB7IFN0b3AtUHJvY2VzcyAtSWQgJF8uUHJvY2Vzc0lkIC1Gb3JjZSAtRXJyb3JBY3Rpb24gU2lsZW50bHlDb250aW51ZSB9CiAgU3RhcnQtU2xlZXAgLU1pbGxpc2Vjb25kcyA0MDAKICB0cnkgeyAkaGF2ZU11dGV4ID0gJG10eC5XYWl0T25lKDMwMDApIH0gY2F0Y2ggeyAkaGF2ZU11dGV4ID0gJHRydWUgfQp9CgojIFNhZmV0eSBuZXQgZGVjbGFyZWQgYmVmb3JlIGFueXRoaW5nIGNhbiBmYWlsOyAkaEluLyRvbGRNb2RlIGFyZSBzZWVkZWQgc28gdGhlCiMgdHJhcCBpcyBzYWZlIGV2ZW4gaWYgaXQgZmlyZXMgZHVyaW5nIHN0YXJ0dXAuIEFuIHVuZXhwZWN0ZWQgZXJyb3IgbXVzdCBuZXZlcgojIHNwYW0gdGhlIHBhbmVsIG5vciBsb29rIGxpa2UgYSBtZW51IGNob2ljZTogcmVzdG9yZSB0aGUgY29uc29sZSwgZXhpdCAwLgokaEluID0gW0ludFB0cl06Olplcm8KJG9sZE1vZGUgPSAwCnRyYXAgewogIHRyeSB7IGlmICgkaEluIC1uZSBbSW50UHRyXTo6WmVybykgeyBbdm9pZF1bQ29uXTo6U2V0Q29uc29sZU1vZGUoJGhJbiwgJG9sZE1vZGUpIH0gfSBjYXRjaCB7IH0KICB0cnkgeyBpZiAoJGhhdmVNdXRleCkgeyAkbXR4LlJlbGVhc2VNdXRleCgpIH0gfSBjYXRjaCB7IH0KICBleGl0IDAKfQoKQWRkLVR5cGUgLVR5cGVEZWZpbml0aW9u
>> "!PANELB64!" echo IEAnCnVzaW5nIFN5c3RlbTt1c2luZyBTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXM7CnB1YmxpYyBzdGF0aWMgY2xhc3MgQ29uewogW0RsbEltcG9ydCgia2VybmVsMzIuZGxsIixTZXRMYXN0RXJyb3I9dHJ1ZSldcHVibGljIHN0YXRpYyBleHRlcm4gSW50UHRyIEdldFN0ZEhhbmRsZShpbnQgbik7CiBbRGxsSW1wb3J0KCJrZXJuZWwzMi5kbGwiLFNldExhc3RFcnJvcj10cnVlKV1wdWJsaWMgc3RhdGljIGV4dGVybiBib29sIEdldENvbnNvbGVNb2RlKEludFB0ciBoLG91dCB1aW50IG0pOwogW0RsbEltcG9ydCgia2VybmVsMzIuZGxsIixTZXRMYXN0RXJyb3I9dHJ1ZSldcHVibGljIHN0YXRpYyBleHRlcm4gYm9vbCBTZXRDb25zb2xlTW9kZShJbnRQdHIgaCx1aW50IG0pOwogW0RsbEltcG9ydCgia2VybmVsMzIuZGxsIixTZXRMYXN0RXJyb3I9dHJ1ZSxDaGFyU2V0PUNoYXJTZXQuVW5pY29kZSldcHVibGljIHN0YXRpYyBleHRlcm4gYm9vbCBSZWFkQ29uc29sZUlucHV0VyhJbnRQdHIgaCxbT3V0XUlSW10gYix1aW50IG4sb3V0IHVpbnQgcik7CiBbU3RydWN0TGF5b3V0KExheW91dEtpbmQuU2VxdWVudGlhbCldcHVibGljIHN0cnVjdCBDT3twdWJsaWMgc2hvcnQgWDtwdWJsaWMgc2hvcnQgWTt9CiBbU3RydWN0TGF5b3V0KExheW91dEtpbmQuRXhwbGljaXQpXXB1YmxpYyBz
>> "!PANELB64!" echo dHJ1Y3QgTUV7W0ZpZWxkT2Zmc2V0KDApXXB1YmxpYyBDTyBQO1tGaWVsZE9mZnNldCg0KV1wdWJsaWMgdWludCBCO1tGaWVsZE9mZnNldCg4KV1wdWJsaWMgdWludCBLO1tGaWVsZE9mZnNldCgxMildcHVibGljIHVpbnQgRjt9CiBbU3RydWN0TGF5b3V0KExheW91dEtpbmQuRXhwbGljaXQsQ2hhclNldD1DaGFyU2V0LlVuaWNvZGUpXXB1YmxpYyBzdHJ1Y3QgS0V7W0ZpZWxkT2Zmc2V0KDApXXB1YmxpYyBpbnQgRDtbRmllbGRPZmZzZXQoMTApXXB1YmxpYyBjaGFyIFU7fQogW1N0cnVjdExheW91dChMYXlvdXRLaW5kLkV4cGxpY2l0KV1wdWJsaWMgc3RydWN0IElSe1tGaWVsZE9mZnNldCgwKV1wdWJsaWMgdXNob3J0IFQ7W0ZpZWxkT2Zmc2V0KDQpXXB1YmxpYyBNRSBNO1tGaWVsZE9mZnNldCg0KV1wdWJsaWMgS0UgRTt9Cn0KJ0AKCiRFU0MgPSBbY2hhcl0yNwokaEluID0gW0Nvbl06OkdldFN0ZEhhbmRsZSgtMTApClt2b2lkXVtDb25dOjpHZXRDb25zb2xlTW9kZSgkaEluLCBbcmVmXSRvbGRNb2RlKQojIGV4dGVuZGVkIGZsYWdzICsgbW91c2UgKyB3aW5kb3cgaW5wdXQ7IHF1aWNrLWVkaXQgT0ZGIChpdCB3b3VsZCBlYXQgdGhlIGNsaWNrcykKJG5ld01vZGUgPSAoKCRvbGRNb2RlIC1ib3IgMHgwMDgwIC1ib3IgMHgwMDEwIC1ib3IgMHgwMDA4KSAtYmFuZCAoLWJub3QgMHgwMDQw
>> "!PANELB64!" echo KSkKW3ZvaWRdW0Nvbl06OlNldENvbnNvbGVNb2RlKCRoSW4sICRuZXdNb2RlKQoKIyBjdXJyZW50IFVSTCAodGhlIGxhdW5jaGVyIGtlZXBzIGl0IGluIHRoZSBzdGF0ZSBmaWxlKQokdXJsID0gJ2h0dHA6Ly8xMjcuMC4wLjE6MzA4MC8nCiRzZiA9IEpvaW4tUGF0aCAkZW52OlRFTVAgJ2RzaC13ZWIuc3RhdGUnCmlmIChUZXN0LVBhdGggLUxpdGVyYWxQYXRoICRzZikgewogICR2ID0gKEdldC1Db250ZW50IC1MaXRlcmFsUGF0aCAkc2YgLVJhdyAtRXJyb3JBY3Rpb24gU2lsZW50bHlDb250aW51ZSkKICBpZiAoJHYpIHsgJHYgPSAkdi5UcmltKCkgfQogIGlmICgkdiAtbGlrZSAnaHR0cConKSB7ICR1cmwgPSAkdiB9Cn0KCiRPRkYgID0gIiRFU0NbMG0iDQokQkxOICA9ICIkRVNDWzQ7Mzg7MjsxMDg7MTYwOzI1NW0iICAgICMgbGluaywgbm9ybWFsICAoPSBiYW5uZXIgQ19VUkwpDQokQkxIICA9ICIkRVNDWzQ7Mzg7MjsxNTA7MTk1OzI1NW0iICAgICAjIGxpbmssIGhvdmVyIChubyBib2xkOiBXVCBzeW50aGV0aWMgYm9sZCBzaGlmdHMgZ2x5cGhzKQ0KJE1WSCAgPSAiJEVTQ1szODsyOzE4NjsyMjA7MjU1bSIgICAgICAjIG1lbnUsIGhvdmVyIHRleHQgKG5vIGJvbGQ6IFdUIHN5bnRoZXRpYyBib2xkIHNoaWZ0cyBnbHlwaHMpDQokUlYgICA9ICIkRVNDWzdtIiAgICAgICAgICAgICAg
>> "!PANELB64!" echo ICAgICAgICMgcmV2ZXJzZS12aWRlbyBiYWNraW5nIGZvciB0aGUgaG92ZXJlZCByb3cNCiRMQkwgID0gIiRFU0NbMzg7MjsxNDI7MTcyOzIzMm0iICAgICAgIyBsYWJlbCAgKD0gYmFubmVyIENfTEJMKQ0KJEtFWSAgPSAiJEVTQ1sxOzM4OzI7MTIyOzE3MDsyNTVtIiAgICAjIGtleSAgICAoPSBiYW5uZXIgQ19LRVkpDQokTUVOVSA9ICIkRVNDWzM4OzI7MTk4OzIxNDsyNDVtIiAgICAgICMgdGV4dCAgICg9IGJhbm5lciBDX01FTlUpDQoNCiRsYWJlbHMgPSBAe30KJGxhYmVsc1skUm93Ul0gPSAnW1JdIOmHjeaWsOaJk+W8gOeVjOmdoicKJGxhYmVsc1skUm93Q10gPSAnW0NdIOWkjeWItuW4piB0b2tlbiDnmoTlnLDlnYAnCiRsYWJlbHNbJFJvd1ZdID0gJ1tWXSDmo4Dmn6XmlrDniYjmnKwnCiRsYWJlbHNbJFJvd1VdID0gJ1tVXSDmm7TmlrDliLDmnIDmlrDniYjmnKwnCiRsYWJlbHNbJFJvd1FdID0gJ1tRXSDlgZzmraLmnI3liqHlubbpgIDlh7onCgpmdW5jdGlvbiBQYWludChbaW50XSRyb3csIFtib29sXSRob3QpIHsNCiAgIyDlj6rlnKjooYzpppbnqbrnmb3lpITnlLsv5pOm5LiA5Liq5qCH6K6w5Z2X77yM57ud5LiN6YeN5YaZ6KGM5YaF5paH5a2X77yaDQogICMgV1Qg5a+54oCc5a6a5L2N5ZCO6YeN5YaZ55qE6KGM4oCd5LiO4oCcY21kIGVjaG8g5Y6f55Sf5YaZ5Ye655qE6KGM
>> "!PANELB64!" echo 4oCd5a2X5b2i5riy5p+T5pyJ57uG5b6u5beu5byC77yMDQogICMg6YeN5YaZ5paH5a2X5Lya6K6p6KGM55yL6LW35p2l5q2q5o6J77yb5LiN6YeN5YaZ5paH5a2X5YiZ54mp55CG5LiK5LiN5Y+v6IO95q2q44CCDQogIFtDb25zb2xlXTo6V3JpdGUoIiRFU0NbJCgkcm93KzEpOzFIIikNCiAgaWYgKCRob3QpIHsgW0NvbnNvbGVdOjpXcml0ZSgkTVZIICsgW2NoYXJdMHgyNThDICsgJE9GRikgfQ0KICBlbHNlICAgICAgeyBbQ29uc29sZV06OldyaXRlKCcgICcpIH0NCiAgW0NvbnNvbGVdOjpXcml0ZSgiJEVTQ1skKCRSb3dFbmQrMSk7MUgiKQ0KfQ0KDQokTU9VU0VfTU9WRUQgPSAweDAwMDEKJGJ1ZiA9IE5ldy1PYmplY3QgJ0NvbitJUltdJyAzMgokZHJhaW4gPSBOZXctT2JqZWN0ICdDb24rSVJbXScgMzIKJGhvdmVyID0gLTEKJGFjdGlvbiA9IDAKJHByZXZEb3duID0gJGZhbHNlCiRzdyA9IFtEaWFnbm9zdGljcy5TdG9wd2F0Y2hdOjpTdGFydE5ldygpCgp3aGlsZSAoJHRydWUpIHsKICAkcmVhZCA9IDAKICBpZiAoLW5vdCBbQ29uXTo6UmVhZENvbnNvbGVJbnB1dFcoJGhJbiwgJGJ1ZiwgMzIsIFtyZWZdJHJlYWQpKSB7IFN0YXJ0LVNsZWVwIC1NaWxsaXNlY29uZHMgNDA7IGNvbnRpbnVlIH0KICBpZiAoJHJlYWQgLWVxIDApIHsgU3RhcnQtU2xlZXAgLU1pbGxpc2Vjb25kcyAyNTsg
>> "!PANELB64!" echo Y29udGludWUgfQoKICBmb3IgKCRpID0gMDsgJGkgLWx0ICRyZWFkOyAkaSsrKSB7CiAgICAkcmVjID0gJGJ1ZlskaV0KCiAgICBpZiAoJHJlYy5UIC1lcSAxKSB7ICAgICAgICAgICAgICAgICAgICAgICAgICAjIGtleWJvYXJkCiAgICAgIGlmICgkcmVjLkUuRCAtZXEgMCkgeyBjb250aW51ZSB9CiAgICAgICRjaCA9IChbc3RyaW5nXSRyZWMuRS5VKS5Ub0xvd2VyKCkKICAgICAgaWYgKCRjaCAtZXEgJ3InKSB7ICRhY3Rpb24gPSAxOyBicmVhayB9CiAgICAgIGlmICgkY2ggLWVxICdjJykgeyAkYWN0aW9uID0gMjsgYnJlYWsgfQogICAgICBpZiAoJGNoIC1lcSAndicpIHsgJGFjdGlvbiA9IDU7IGJyZWFrIH0KICAgICAgaWYgKCRjaCAtZXEgJ3UnKSB7ICRhY3Rpb24gPSA2OyBicmVhayB9CiAgICAgIGlmICgkY2ggLWVxICdxJykgeyAkYWN0aW9uID0gMzsgYnJlYWsgfQogICAgfQogICAgZWxzZWlmICgkcmVjLlQgLWVxIDIpIHsgICAgICAgICAgICAgICAgICAgICAgIyBtb3VzZQogICAgICAkbXkgICA9IFtpbnRdJHJlYy5NLlAuWQogICAgICAkYnRuICA9IFtpbnRdJHJlYy5NLkIKICAgICAgJGZsYWcgPSBbaW50XSRyZWMuTS5GCgogICAgICAkZG93biAgID0gKCRidG4gLWJhbmQgMSkgLW5lIDAKICAgICAgJGlzTW92ZSA9ICgkZmxhZyAtYmFuZCAkTU9VU0VfTU9WRUQpIC1uZSAw
>> "!PANELB64!" echo CgogICAgICAjIGhvdmVyIGhpZ2hsaWdodCAobW92ZW1lbnQgb25seSkKICAgICAgaWYgKCRpc01vdmUpIHsKICAgICAgICAkeiA9IC0xCiAgICAgICAgaWYgICAgICgkbXkgLWVxICRSb3dVcmwpIHsgJHogPSAkUm93VXJsIH0KICAgICAgICBlbHNlaWYgKCRteSAtZXEgJFJvd1IpICAgeyAkeiA9ICRSb3dSIH0KICAgICAgICBlbHNlaWYgKCRteSAtZXEgJFJvd0MpICAgeyAkeiA9ICRSb3dDIH0KICAgICAgICBlbHNlaWYgKCRteSAtZXEgJFJvd1YpICAgeyAkeiA9ICRSb3dWIH0KICAgICAgICBlbHNlaWYgKCRteSAtZXEgJFJvd1UpICAgeyAkeiA9ICRSb3dVIH0KICAgICAgICBlbHNlaWYgKCRteSAtZXEgJFJvd1EpICAgeyAkeiA9ICRSb3dRIH0KICAgICAgICBpZiAoJHogLW5lICRob3ZlcikgewogICAgICAgICAgaWYgKCRob3ZlciAtbmUgLTEpIHsgUGFpbnQgJGhvdmVyICRmYWxzZSB9CiAgICAgICAgICBpZiAoJHogLW5lIC0xKSAgICAgeyBQYWludCAkeiAkdHJ1ZSB9CiAgICAgICAgICAkaG92ZXIgPSAkegogICAgICAgIH0KICAgICAgfQoKICAgICAgIyBhIGNsaWNrID0gZnJlc2ggcHJlc3Mgb24gYSByb3csIG5vdCBhIG1vdmUKICAgICAgaWYgKCRkb3duIC1hbmQgKC1ub3QgJHByZXZEb3duKSAtYW5kICgtbm90ICRpc01vdmUpKSB7CiAgICAgICAgJGFjdCA9IDAKICAgICAg
>> "!PANELB64!" echo ICBpZiAgICAgKCRteSAtZXEgJFJvd1VybCkgeyAkYWN0ID0gNCB9CiAgICAgICAgZWxzZWlmICgkbXkgLWVxICRSb3dSKSAgIHsgJGFjdCA9IDEgfQogICAgICAgIGVsc2VpZiAoJG15IC1lcSAkUm93QykgICB7ICRhY3QgPSAyIH0KICAgICAgICBlbHNlaWYgKCRteSAtZXEgJFJvd1YpICAgeyAkYWN0ID0gNSB9CiAgICAgICAgZWxzZWlmICgkbXkgLWVxICRSb3dVKSAgIHsgJGFjdCA9IDYgfQogICAgICAgIGVsc2VpZiAoJG15IC1lcSAkUm93USkgICB7ICRhY3QgPSAzIH0KICAgICAgICBpZiAoJGFjdCAtbmUgMCkgewogICAgICAgICAgJGFjdGlvbiA9ICRhY3QKICAgICAgICAgICMgRHJhaW4gdW50aWwgcmVsZWFzZTogaWYgd2UgcmV0dXJuIHdoaWxlIHRoZSBidXR0b24gaXMgc3RpbGwgaGVsZCwKICAgICAgICAgICMgdGhlIHRlcm1pbmFsIGtlZXBzIHJlcG9ydGluZyAicHJlc3NlZCIgYW5kIHRoZSBuZXh0IG1vdmVzIHdvdWxkIGJlCiAgICAgICAgICAjIG1pc3Rha2VuIGZvciBjbGlja3MuCiAgICAgICAgICAkZHcgPSBbRGlhZ25vc3RpY3MuU3RvcHdhdGNoXTo6U3RhcnROZXcoKQogICAgICAgICAgd2hpbGUgKCRkdy5FbGFwc2VkLlRvdGFsTWlsbGlzZWNvbmRzIC1sdCAxNTAwKSB7CiAgICAgICAgICAgICRybiA9IDAKICAgICAgICAgICAgaWYgKFtDb25dOjpSZWFkQ29uc29s
>> "!PANELB64!" echo ZUlucHV0VygkaEluLCAkZHJhaW4sIDMyLCBbcmVmXSRybikgLWFuZCAkcm4gLWd0IDApIHsKICAgICAgICAgICAgICAkcmVsZWFzZWQgPSAkZmFsc2UKICAgICAgICAgICAgICBmb3IgKCRqID0gMDsgJGogLWx0ICRybjsgJGorKykgewogICAgICAgICAgICAgICAgJGRkID0gJGRyYWluWyRqXQogICAgICAgICAgICAgICAgaWYgKCRkZC5UIC1lcSAyIC1hbmQgKChbaW50XSRkZC5NLkIgLWJhbmQgMSkgLWVxIDApKSB7ICRyZWxlYXNlZCA9ICR0cnVlIH0KICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgaWYgKCRyZWxlYXNlZCkgeyBicmVhayB9CiAgICAgICAgICAgIH0gZWxzZSB7IFN0YXJ0LVNsZWVwIC1NaWxsaXNlY29uZHMgMjAgfQogICAgICAgICAgfQogICAgICAgICAgYnJlYWsKICAgICAgICB9CiAgICAgIH0KCiAgICAgICRwcmV2RG93biA9ICRkb3duCiAgICB9CiAgfQoKICBpZiAoJGFjdGlvbiAtbmUgMCkgeyBicmVhayB9CiAgaWYgKCRzdy5FbGFwc2VkLlRvdGFsU2Vjb25kcyAtZ3QgMzYwMCkgeyBicmVhayB9ICAgIyBzYWZldHkgbmV0Cn0KCmlmICgkaG92ZXIgLW5lIC0xKSB7IFBhaW50ICRob3ZlciAkZmFsc2UgfQpbdm9pZF1bQ29uXTo6U2V0Q29uc29sZU1vZGUoJGhJbiwgJG9sZE1vZGUpCnRyeSB7IGlmICgkaGF2ZU11dGV4KSB7ICRtdHguUmVsZWFzZU11dGV4
>> "!PANELB64!" echo KCkgfSB9IGNhdGNoIHsgfQpleGl0ICgkYWN0aW9uICsgMTApCg==
powershell -NoProfile -Command "$b = (Get-Content -Raw '%TEMP%\dsh-panel.b64') -replace '\s',''; [IO.File]::WriteAllText('%TEMP%\dsh-panel.ps1', [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b)), (New-Object Text.UTF8Encoding($true)))"
del "!PANELB64!" 2>nul
exit /b 0










rem È¡µ±Ç°¼àÌı 3080 µÄ½ø³ÌºÅ -> PID3080
:get_pid
set "PID3080="
for /f "tokens=5" %%p in ('netstat -ano ^| findstr /c:":%PORT% " ^| findstr /c:"LISTENING"') do set "PID3080=%%p"
exit /b 0

rem ÅĞ¶Ï 3080 ÉÏÊÇ²»ÊÇ dsh£ºdsh Î´ÈÏÖ¤Ê±·µ»Ø 401 -> ISDSH
rem ×¢Òâ£º±ØĞë -ErrorAction Stop ÇÒÅĞ¿Õ£¬·ñÔòÁ¬½ÓÊ§°ÜÊ±
rem        [int]$null.StatusCode »á¶ş´ÎÅ×´í£¬µ¼ÖÂ½á¹ûÎÄ¼şĞ´²»³öÀ´¡£
:probe_service
set "ISDSH="
powershell -NoProfile -Command "$v = 'NONE'; try { $r = Invoke-WebRequest -Uri '%URLBASE%' -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop; $v = if ($r.StatusCode -eq 200) { 'DSH' } else { 'CODE' + $r.StatusCode } } catch { $resp = $_.Exception.Response; if ($resp -and [int]$resp.StatusCode -eq 401) { $v = 'DSH' } elseif ($resp) { $v = 'CODE' + [int]$resp.StatusCode } }; Set-Content -LiteralPath '%PROBE%' -Value $v -Encoding ASCII" 2>nul
if exist "%PROBE%" set /p ISDSH=<"%PROBE%"
del "%PROBE%" 2>nul
exit /b 0

rem ¶ÁÈ¡ÉÏ´Î±£´æµÄ´ø token µØÖ· -> URL / DSHURL
rem ¶Á²»µ½ÔòÓÃ²»´ø token µÄ¶µµ×µØÖ·£¨Ê×´Î´ò¿ªºóä¯ÀÀÆ÷ cookie ÓĞĞ§ 30 Ìì£©
rem Í¬Ê±µ¼³ö DSHURL / EDGEPROFILE »·¾³±äÁ¿¹© PowerShell ¶ÁÈ¡£¬
rem ±ÜÃâ URL ÀïµÄ ? ºÍ & ÔÚ cmd ²ÎÊıÀï±»Îó½âÎö¡£
:load_url
set "URL="
if exist "%STATE%" for /f "usebackq delims=" %%a in ("%STATE%") do if not defined URL set "URL=%%a"
if defined URL if not "!URL:~0,4!"=="http" set "URL="
if not defined URL set "URL=%URLBASE%"
set "DSHURL=!URL!"
set "EDGEPROFILE=%EDGEPROFILE%"
exit /b 0

rem ÓÃ wt ´ò¿ªÒ»¸ö¡°ÒÑ¾ÓÖĞ¡±µÄ¿ØÖÆÌ¨´°¿Ú£¬²¢ÔÚÆäÖĞÖØ¿ª±¾½Å±¾
rem ¹Ø¼ü£ºÎ»ÖÃºÍ³ß´ç¶¼ÔÚÆô¶¯²ÎÊıÀï¸ø¶¨£¨--pos / --size£©£¬
rem       ËùÒÔ´°¿ÚÒ»³öÏÖ¾ÍÒÑ¾­ÔÚÕıÈ·Î»ÖÃ£¬²»»áÔÙÌø¡£
rem ÓÃ PowerShell µÄ & µ÷ÓÃÔËËã·û´«²Î£¬ÓÉ PS ¸ºÔğ¸øº¬¿Õ¸ñµÄÂ·¾¶¼ÓÒıºÅ£¬
rem ±ÜÃâ cmd ²ã¶à²ãÒıºÅÇ¶Ì×³ö´í¡£
:spawn_console
powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea; $cW = !CON_COLS! * !WT_CELL_W! + !WT_FRAME_W!; $cH = !CON_ROWS! * !WT_CELL_H! + !WT_FRAME_H!; $x = $wa.X + [int](($wa.Width - $cW) / 2) + !WT_POS_DX!; $y = $wa.Y + [int](($wa.Height - $cH) / 2); & '!WTEXE!' '-w' '-1' '--pos' ($x.ToString() + ',' + $y.ToString()) '--size' ('!CON_COLS!,' + '!CON_ROWS!') 'cmd.exe' '/c' 'call' $env:SELF" >nul 2>&1
exit /b 0

rem ----------------------------------------------------------------------------
rem  ½âÎöÖ¸¶¨ ProgId µÄä¯ÀÀÆ÷ exe -> UIEXE£¨Ê§°ÜÖÃ¿Õ£©
rem    ProgId µÄ shell\open\command ĞÎÈç "C:\...\xx.exe" --single-argument %1£¬
rem    ¾­»·¾³±äÁ¿´«¸ø PS ÌáÈ¡ exe Â·¾¶£¬±Ü¿ª cmd ÒıºÅÇ¶Ì×£»Test-Path È·ÈÏ´æÔÚ¡£
rem ----------------------------------------------------------------------------
:resolve_progid_exe
set "UIEXE="
set "OPENFN="
for /f "tokens=2*" %%a in ('reg query "HKCR\%~1\shell\open\command" /ve 2^>nul ^| findstr /i "REG_SZ"') do set "OPENFN=%%b"
if not defined OPENFN exit /b 0
for /f "delims=" %%x in ('powershell -NoProfile -Command "$q = [char]34; $c = $env:OPENFN; $m = $null; if ($c.StartsWith($q)) { $j = $c.IndexOf($q, 1); if ($j -gt 1) { $m = $c.Substring(1, $j - 1) } }; if ($m) { if (Test-Path -LiteralPath $m) { Write-Output $m } }" 2^>nul') do set "UIEXE=%%x"
exit /b 0

rem ----------------------------------------------------------------------------
rem  Ñ¡¶¨½çÃæä¯ÀÀÆ÷ -> UIEXE / UINAME£¨Edge ÓÅÏÈ£¬Æä´Î Chrome£¬×îºóÄ¬ÈÏä¯ÀÀÆ÷£©
rem    Edge/Chrome£º×¢²á±í ProgId ½âÎö°²×°Â·¾¶£¬Ê§°ÜÔÙÊÔ³£¼û°²×°Î»ÖÃ£»
rem    ¶¼Ã»ÓĞÊ±¼ì²éÏµÍ³Ä¬ÈÏä¯ÀÀÆ÷ÊÇ·ñ´æÔÚ£¨Ö»ÄÜÆÕÍ¨´°¿Ú´ò¿ª£¬²»±£Ö¤¾«¼ò
rem    Ä£Ê½Ğ§¹û£¬¿ä¿ËµÈ·ÇÖ÷Á÷ Chromium µÄ --app Ğ§¹û²»¿É¿Ø£©£»Á¬Ä¬ÈÏä¯ÀÀÆ÷
rem    ¶¼Ã»ÓĞÔòÁ½ÕßÖÃ¿Õ£¬:open_ui ±¨´í¡£
rem ----------------------------------------------------------------------------
:find_ui_browser
set "UIEXE="
set "UINAME="
set "UIFALLBACK="
call :resolve_progid_exe MSEdgeHTM
if not defined UIEXE for %%p in ("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "C:\Program Files\Microsoft\Edge\Application\msedge.exe") do if not defined UIEXE if exist "%%~p" set "UIEXE=%%~p"
if defined UIEXE (
    set "UINAME=msedge"
    exit /b 0
)
call :resolve_progid_exe ChromeHTML
if not defined UIEXE for %%p in ("C:\Program Files\Google\Chrome\Application\chrome.exe" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") do if not defined UIEXE if exist "%%~p" set "UIEXE=%%~p"
if defined UIEXE (
    set "UINAME=chrome"
    exit /b 0
)
set "PROGID="
for /f "tokens=2*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice" /v ProgId 2^>nul ^| findstr /i "ProgId"') do set "PROGID=%%b"
if defined PROGID set "UIFALLBACK=1"
exit /b 0

rem ----------------------------------------------------------------------------
rem  ´ò¿ª½çÃæ´°¿Ú¡£
rem    Edge/Chrome£º×¨ÓÃ user-data-dir£¨°´ä¯ÀÀÆ÷¶ÀÁ¢£©+ --app ¾«¼òÄ£Ê½ + ¾ÓÖĞ£»
rem    ×¨ÓÃ profile ÈÃ --window-position/size ÔÚä¯ÀÀÆ÷ÒÑÓĞÊµÀıÔËĞĞÊ±Ò²ÉúĞ§£¬
rem    ´°¿ÚÒ»³öÏÖ¾ÍÔÚÕıÖĞ£¨±ÜÃâ¡°ÏÈ´íÎ»ÔÙÌøÕı¡±£©¡£
rem    ÆäËü£ºÍË»ØÏµÍ³Ä¬ÈÏä¯ÀÀÆ÷ÆÕÍ¨´ò¿ª£»Á¬Ä¬ÈÏä¯ÀÀÆ÷¶¼Ã»ÓĞÔò±¨´í¡£
rem ----------------------------------------------------------------------------
:open_ui
call :find_ui_browser
if defined UIEXE (
    set "UIPROFILE=%LOCALAPPDATA%\dsh-web-ui-profile-!UINAME!"
    powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea; $w = [Math]::Min(!UI_MAX_W!, [int]($wa.Width * !UI_W_RATIO!)); $h = [Math]::Min(!UI_MAX_H!, [int]($wa.Height * !UI_H_RATIO!)); $x = $wa.X + [int](($wa.Width - $w) / 2); $y = $wa.Y + [int](($wa.Height - $h) / 2); & '!UIEXE!' ('--user-data-dir=' + $env:UIPROFILE) '--no-first-run' '--no-default-browser-check' ('--window-position=' + $x + ',' + $y) ('--window-size=' + $w + ',' + $h) ('--app=' + $env:DSHURL)" >nul 2>&1
    exit /b 0
)
if defined UIFALLBACK (
    start "" "!URL!"
    exit /b 0
)
call :banner "Æô¶¯Ê§°Ü"
echo.
echo   !C_WARN![´íÎó] Ã»ÓĞÕÒµ½¿ÉÓÃµÄä¯ÀÀÆ÷¡£!C_OFF!
echo   !C_DIM!ÍÆ¼ö°²×° Microsoft Edge »ò Google Chrome ºóÖØĞÂÔËĞĞ±¾½Å±¾¡£!C_OFF!
echo.
pause
exit /b 1

rem °Ñ¿ØÖÆÌ¨´°¿Ú×îĞ¡»¯µ½ÈÎÎñÀ¸£¨½ö wt ÏÂÓĞĞ§£©
:minimize_panel
powershell -NoProfile -Command "$p = Get-Process WindowsTerminal -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like 'DeepSeek Harness*' } | Select-Object -First 1; if ($p) { Add-Type -MemberDefinition '[DllImport(@\"user32.dll\")]public static extern bool ShowWindowAsync(IntPtr h, int n);' -Name DshMin -Namespace DshWin; [void][DshWin.DshMin]::ShowWindowAsync($p.MainWindowHandle, 2) }" >nul 2>&1
exit /b 0

rem Ô­Éú cmd ¶µµ×£º°Ñ¿ØÖÆÌ¨Å²µ½ÆÁÄ»ÕıÖĞ£¨±£³ÖÔ­³ß´ç£©
rem Ö»ÔÚÃ»ÓĞ wt Ê±²Å»á×ßµ½ÕâÀï£¬Òò´ËÔÊĞí¡°¿ªÍêÔÙÅ²¡±µÄÇáÎ¢Ìø¶¯¡£
rem ÓÃ -TypeDefinition ¶¨Òå¶¥²ã½á¹¹Ìå£ºÇ¶Ì× struct µÄ DshWin+Type Ğ´·¨
rem ÔÚ powershell -Command Àï»á±»´íÎó½âÎö£¬Îñ±Ø±£³ÖÕâÖÖĞ´·¨¡£
:center_console
powershell -NoProfile -Command "$ErrorActionPreference='SilentlyContinue'; Add-Type -AssemblyName System.Windows.Forms; Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public struct TWR { public int L; public int T; public int R; public int B; } public class TwApi { [DllImport(@\"user32.dll\")] public static extern bool GetWindowRect(IntPtr h, ref TWR r); [DllImport(@\"user32.dll\", CharSet=CharSet.Unicode)] public static extern IntPtr FindWindowW(string c, string t); [DllImport(@\"user32.dll\")] public static extern bool SetWindowPos(IntPtr h, IntPtr a, int x, int y, int cx, int cy, uint f); }'; $h = [TwApi]::FindWindowW($null, 'DeepSeek Harness !VER!'); if ($h -ne [IntPtr]::Zero) { $wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea; $r = New-Object TWR; [void][TwApi]::GetWindowRect($h, [ref]$r); $w = $r.R - $r.L; $ht = $r.B - $r.T; $x = $wa.X + [int](($wa.Width - $w) / 2); $y = $wa.Y + [int](($wa.Height - $ht) / 2); [void][TwApi]::SetWindowPos($h, [IntPtr]::Zero, $x, $y, 0, 0, 0x15) }" >nul 2>&1
exit /b 0


rem ¹Øµô¾ÉÃæ°å£ºÖ»¹Ø±êÌâÆ¥ÅäµÄÄÇ¸ö´°¿Ú£¬¾ø²»ÄÜÈ¥É±ËùÓĞ WindowsTerminal£¨·ñÔò»áÉ±µô±¾½Å±¾×Ô¼ºµÄ¿ØÖÆÌ¨£©
:close_panel
powershell -NoProfile -Command "$p = Get-Process WindowsTerminal -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like 'DeepSeek Harness*' } | Select-Object -First 1; if ($p) { Add-Type -MemberDefinition '[DllImport(@\"user32.dll\")] public static extern IntPtr SendMessageW(IntPtr h, uint m, IntPtr w, IntPtr l);' -Name DshClose -Namespace DshWin; [void][DshWin.DshClose]::SendMessageW($p.MainWindowHandle, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); for ($i = 0; $i -lt 40; $i++) { if ($p.HasExited) { break }; Start-Sleep -Milliseconds 200 } }" >nul 2>&1
ping -n 2 127.0.0.1 >nul
exit /b 0
rem Ö»Æ¥ÅäÎÒÃÇ×Ô¼ºÉè¹ı±êÌâµÄÃæ°å´°¿Ú¡£²»ÄÜÆ¥ÅäÈÎÒâ WindowsTerminal ¡ª¡ªÔÚ Win11 ÉÏË«»÷µÄ .bat ±¾Éí¾ÍÅÜÔÚ Windows Terminal Àï£¬»á°Ñ×Ô¼ºÎóµ±³ÉÃæ°å
:find_panel
set "PANEL="
powershell -NoProfile -Command "$p = Get-Process WindowsTerminal -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like 'DeepSeek Harness*' } | Select-Object -First 1; if ($p) { Add-Type -MemberDefinition '[DllImport(@\"user32.dll\")] public static extern bool ShowWindowAsync(IntPtr h, int n); [DllImport(@\"user32.dll\")] public static extern bool SetForegroundWindow(IntPtr h);' -Name DshFg -Namespace DshWin; [void][DshWin.DshFg]::ShowWindowAsync($p.MainWindowHandle, 9); [void][DshWin.DshFg]::SetForegroundWindow($p.MainWindowHandle); exit 0 } else { exit 1 }" 2>nul
if not errorlevel 1 set "PANEL=FOUND"
exit /b 0

rem ¶¨Î» wt.exe Â·¾¶ -> WTEXE
:find_wt
set "WTEXE="
for /f "delims=" %%w in ('where wt.exe 2^>nul') do if not defined WTEXE set "WTEXE=%%w"
exit /b 0
