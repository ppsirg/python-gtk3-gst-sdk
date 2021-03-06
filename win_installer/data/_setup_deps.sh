
function setup_deps {
    echo "create the icon theme caches"
    wine "$DEPS"/gtk-update-icon-cache.exe "$DEPS"/share/icons/Adwaita
    wine "$DEPS"/gtk-update-icon-cache.exe "$DEPS"/share/icons/hicolor
    wine "$DEPS"/gtk-update-icon-cache.exe "$DEPS"/share/icons/HighContrast

    echo "compile glib schemas"
    wine "$DEPS"/glib-compile-schemas.exe "$DEPS"/share/glib-2.0/schemas

    # copy libmodplug
    cp "$BUILD_ENV/bin/libmodplug-1.dll" "$DEPS"

    # copy old libgstopus
    # https://github.com/quodlibet/quodlibet/issues/1511
    cp "$BUILD_ENV/bin/libgstopus.dll" "$DEPS"/lib/gstreamer-1.0
}

function install_python {
    wine msiexec /a "$BUILD_ENV"/bin/${PYTHON_MSI} /qb
    PYDIR="$WINEPREFIX"/drive_c/Python27

    # install the python packages
    local SITEPACKAGES="$PYDIR"/Lib/site-packages
    cp -R "$PYGI"/binding/py2.7-32/cairo "$SITEPACKAGES"
    cp -R "$PYGI"/binding/py2.7-32/gi "$SITEPACKAGES"
    cp "$PYGI"/binding/py2.7-32/*.pyd "$SITEPACKAGES"
}

function install_git {

    local DISPLAY_OLD=$DISPLAY
    export DISPLAY=$DISPLAY_SAVED
    # this needs a valid DISPLAY..
    wine "$BUILD_ENV"/bin/Git-2.6.3-32-bit.exe /verysilent;
    export DISPLAY=$DISPLAY_OLD
    GITDIR="$(winepath -u "$(wine cmd.exe /c 'echo | set /p=%ProgramFiles%')")/Git";
}

function install_7zip {
    wine msiexec /a "$BUILD_ENV"/bin/${SZIP_MSI} /qb
    SZIPDIR="$WINEPREFIX/drive_c/Program Files/7-Zip/"
}

function install_nsis {
    wine "$BUILD_ENV"/bin/${NSIS_EXE} /S
}

install_git;
install_python;
install_7zip;
install_nsis;

