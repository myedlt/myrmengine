@echo off
echo // > tempPublish.jsfl
:start
echo %1
echo filename = "file:///%1"; >> tempPublish.jsfl
echo fl.openDocument(filename); >> tempPublish.jsfl
echo curr_doc = fl.getDocumentDOM(); >> tempPublish.jsfl
echo curr_doc.publish(); >> tempPublish.jsfl
echo curr_doc.close(false); >> tempPublish.jsfl
shift
if "%1" == "" goto end
goto start
:end
echo fl.quit(true); >> tempPublish.jsfl
start "C:\Program Files\Adobe\Adobe Flash CS3\Flash.exe" tempPublish.jsfl

rem usage: flapublish a.fla