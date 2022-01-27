!defined(BRAND,var){
#  Default brand
    BRAND_BASE = Cellframe
    BRAND_BASE_LO = cellframe
    BRAND = Cellframe-Dashboard
    BRAND_LO = cellframe-dashboard
}

VER_MAJ = 2
VER_MIN = 2
VER_PAT = 2

DEFINES += DAP_BRAND=\\\"$$BRAND\\\"
DEFINES += DAP_BRAND_BASE_LO=\\\"$$BRAND_BASE_LO\\\"
DEFINES += DAP_BRAND_LO=\\\"$$BRAND_LO\\\"
DEFINES += DAP_VERSION=\\\"$$VERSION\\\"

#BUILD_TYPE = static

unix: !mac: !android {
    defined(BUILD_TYPE,var) {
        LIBS += -L/usr/lib/json-static -ljson-c
    }
}

win32 {
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += CLI_PATH=\\\"$${BRAND_BASE_LO}-node-cli.exe\\\"
    DEFINES += TOOLS_PATH=\\\"$${BRAND_BASE_LO}-node-tool.exe\\\"
    DEFINES += HAVE_STRNDUP
}
macx {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/Applications/$${BRAND}.app/Contents/MacOS/$${BRAND_BASE_LO}-node-cli\\\"
    DEFINES += TOOLS_PATH=\\\"/Applications/$${BRAND}.app/Contents/MacOS/$${BRAND_BASE_LO}-node-tool\\\"
    DEFINES += CMD_HISTORY=\\\"/opt/$${BRAND_BASE_LO}/data/cmd_history.txt\\\"
#    DEFINES += LOG_FILE=\\\"/opt/$${BRAND_BASE_LO}-node/var/log/$${BRAND_BASE_LO}-node.log\\\"
}
else: !win32 {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/opt/$${BRAND_BASE_LO}-node/bin/$${BRAND_BASE_LO}-node-cli\\\"
    DEFINES += TOOLS_PATH=\\\"/opt/$${BRAND_BASE_LO}-node/bin/$${BRAND_BASE_LO}-node-tool\\\"
    #DEFINES += CMD_HISTORY=\\\"/opt/$${BRAND_BASE_LO}/var/log/cmd_history.txt\\\"
    DEFINES += CMD_HISTORY=\\\"/opt/$${BRAND_LO}/data/cmd_history.txt\\\"
    DEFINES += DAP_PATH_PREFIX=\\\"/opt/$${BRAND_BASE_LO}\\\"
    DEFINES += LOG_FILE=\\\"/opt/$${BRAND_BASE_LO}-node/var/log/$${BRAND_BASE_LO}-node.log\\\"
}
