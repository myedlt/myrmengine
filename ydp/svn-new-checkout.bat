@set AD_HOME=D:\ADeveloper
@set PATH=%AD_HOME%

@rem ----------- cvs cvs cvs cvs cvs cvs ------------
@set PATH=%AD_HOME%\cvs-1.11.22;%PATH%

@rem ----------- SVN SVN SVN SVN SVN SVN------------
@set PATH=%PATH%;%AD_HOME%\Subversion
@set SVN_EDITOR=notepad.exe
@set APR_ICONV_PATH=%AD_HOME%\Subversion\iconv
@rem set LANG=zh_CN.UTF8

mkdir checkoutAuto
cd checkoutAuto
svn co http://svn.ydp.com.pl/oss/projects/minipublisher/editor/trunk minipublisher\editor\trunk
svn co http://svn.ydp.com.pl/oss/projects/minipublisher/player/trunk minipublisher\player\trunk
