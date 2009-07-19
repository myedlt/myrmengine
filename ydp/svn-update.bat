@set AD_HOME=D:\ADeveloper
@set PATH=%AD_HOME%

@rem ----------- cvs cvs cvs cvs cvs cvs ------------
@set PATH=%AD_HOME%\cvs-1.11.22;%PATH%

@rem ----------- SVN SVN SVN SVN SVN SVN------------
@set PATH=%PATH%;%AD_HOME%\Subversion
@set SVN_EDITOR=notepad.exe
@set APR_ICONV_PATH=%AD_HOME%\Subversion\iconv
@rem set LANG=zh_CN.UTF8


@set SVNREPO_HOME=D:\ATemp\svnExtractor\ydp

@rem ------------------------------------------------
cd %SVNREPO_HOME%\minipublisher\editor
svn update

@rem ------------------------------------------------
cd %SVNREPO_HOME%\minipublisher\incubator
svn update

@rem ------------------------------------------------
cd %SVNREPO_HOME%\minipublisher\player\tags
svn update
cd %SVNREPO_HOME%\minipublisher\player\trunk
svn update

cd %SVNREPO_HOME%\minipublisher\player\branches\1.2.x
svn update

cd %SVNREPO_HOME%\minipublisher\player\branches\recording
svn update

@rem ------------------------------------------------
cd %SVNREPO_HOME%\minipublisher\tools
svn update

@rem ------------------------------------------------
cd %SVNREPO_HOME%\qtiplayer
svn update