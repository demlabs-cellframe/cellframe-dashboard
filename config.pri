CONFIG += c++17
QMAKE_CFLAGS += -std=gnu11
QMAKE_CFLAGS_DEBUG += -DDAP_DEBUG
QMAKE_CXXFLAGS_DEBUG += -DDAP_DEBUG

! win32 {
        LIBS += -ldl
}


# version.mk should look just-like .pro file (and it does if there is only variables`)
VER_MAJ = $$fromfile(version.mk, VERSION_MAJOR)
VER_MIN = $$fromfile(version.mk, VERSION_MINOR)
VER_PAT = $$fromfile(version.mk, VERSION_PATCH)

DEFINES += MIN_NODE_VERSION=\\\"5.3-343\\\"
DEFINES += MAX_NODE_VERSION=\\\"5.3-345\\\"

BRAND_BASE = Cellframe
BRAND_BASE_LO = cellframe
BRAND = Cellframe-Dashboard
BRAND_LO = cellframe-dashboard

DEFINES += QT_DEPRECATED_WARNINGS \
    DAP_BRAND=\\\"$$BRAND\\\" \
    DAP_BRAND_BASE_LO=\\\"$$BRAND_BASE_LO\\\" \
    DAP_BRAND_LO=\\\"$$BRAND_LO\\\"


unix {
    DEFINES += DAP_OS_UNIX
    linux-* {
        VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT

        CONFIG(release, debug|release) SDK_INSTALL_PATH = $$OUT_PWD/../cellframe-sdk/build_linux_release/dist/
        CONFIG(debug, debug|release): SDK_INSTALL_PATH = $$OUT_PWD/../cellframe-sdk/build_linux_rwd/dist/

        DEFINES += DAP_OS_LINUX _GNU_SOURCE \
	    CMD_HISTORY=\\\"/opt/$${BRAND_LO}/data/cmd_history.txt\\\" \
	    DAP_PATH_PREFIX=\\\"/opt/$${BRAND_BASE_LO}\\\" \
	    LOG_FILE=\\\"/opt/$${BRAND_BASE_LO}-node/var/log/$${BRAND_BASE_LO}-node.log\\\" \
	    DATA_PATH=\\\"/opt/$${BRAND_LO}/data/\\\" \
	    DAP_VERSION=\\\"$$VERSION\\\"


        QMAKE_CXXFLAGS_DEBUG += -Wall \
	    -Wno-deprecated-declarations \
	    -Wno-unused-local-typedefs \
	    -Wno-unused-function \
	    -Wno-implicit-fallthrough \
	    -Wno-unused-variable \
	    -Wno-unused-parameter \
	    -Wno-unused-but-set-variable \
	    -pg \
	    -g3 \
	    -ggdb \
	    -fno-eliminate-unused-debug-symbols \
	    -fno-strict-aliasing

        QMAKE_LFLAGS_DEBUG += -pg
    }
    darwin {
        QMAKE_CXXFLAGS += -Wno-deprecated-declarations \
	    -Wno-unused-local-typedefs \
	    -Wno-unused-function \
	    -Wno-implicit-fallthrough \
	    -Wno-unused-variable \
        -Wno-unused-parameter 

        QMAKE_CFLAGS_DEBUG += -Wall -g3 -ggdb -fno-strict-aliasing -gdwarf-2
	QMAKE_CXXFLAGS_DEBUG += -Wall -g3 -ggdb -fno-strict-aliasing -gdwarf-2
	DEFINES += DAP_OS_DARWIN DAP_OS_BSD

    }
    mac {
        VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT

        CONFIG(release, debug | release): SDK_INSTALL_PATH = $$OUT_PWD/../cellframe-sdk/build_osx_release/dist/
        CONFIG(debug, debug | release): SDK_INSTALL_PATH = $$OUT_PWD/../cellframe-sdk/build_osx_rwd/dist/

        DEFINES += DAP_VERSION=\\\"$$VERSION\\\"

    }
}

win32 {
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += DAP_OS_WINDOWS \
        DAP_VERSION=\\\"$${VER_MAJ}.$${VER_MIN}-$$VER_PAT\\\" \
	HAVE_STRNDUP

    CONFIG(debug, debug | release): SDK_INSTALL_PATH = $$OUT_PWD/../cellframe-sdk/build_windows_rwd/dist/
    CONFIG(release, debug | release): SDK_INSTALL_PATH = $$OUT_PWD/../cellframe-sdk/build_windows_release/dist/


    QMAKE_CFLAGS_DEBUG += -Wall -g3 -ggdb
    QMAKE_CXXFLAGS_DEBUG += -Wall -ggdb -g3
}
