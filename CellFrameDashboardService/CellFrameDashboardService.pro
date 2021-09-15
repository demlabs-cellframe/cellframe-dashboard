QT += core network

CONFIG += c++11 console
CONFIG -= app_bundle


LIBS += -ldl
#LIBS+=-lz #-lz -lrt -lm -lpthread   -lrt -lm -lpthread
#+LIBS+=-lrt


!defined(BRAND,var){
#  Default brand
    BRAND = CellFrameDashboard
}
DEFINES += DAP_BRAND=\\\"$$BRAND\\\"

TARGET = $${BRAND}Service

VER_MAJ = 2
VER_MIN = 0
VER_PAT = 9

win32 {
    CONFIG -= console
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += CLI_PATH=\\\"cellframe-node-cli.exe\\\"
    DEFINES += TOOLS_PATH=\\\"cellframe-node-tool.exe\\\"
    DEFINES += HAVE_STRNDUP
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/opt/cellframe-node/bin/cellframe-node-cli\\\"
    DEFINES += TOOLS_PATH=\\\"/opt/cellframe-node/bin/cellframe-node-tool\\\"
    DEFINES += LOG_FILE=\\\"/opt/cellframe-node/var/log/cellframe-node.log\\\"
    DEFINES += CMD_HISTORY=\\\"/opt/cellframe-dashboard/data/cmd_history.txt\\\"
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

DEFINES += DAP_VERSION=\\\"$$VERSION\\\"

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    $$PWD/DapServiceController.cpp \
    $$PWD/main.cpp

HEADERS += \
    $$PWD/DapServiceController.h \

include (../dap-ui-sdk/core/libdap-qt.pri)
include (../cellframe-sdk/dap-sdk/core/libdap.pri)
include (../cellframe-sdk/dap-sdk/net/libdap-net.pri)
include (../cellframe-sdk/dap-sdk/crypto/libdap-crypto.pri)
include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)

INCLUDEPATH += $$_PRO_FILE_PWD_/../cellframe-node/
               $$_PRO_FILE_PWD_/../dapRPCProtocol/

unix: !mac : !android {
    service_target.files = $${BRAND}Service
    service_target.path = /opt/cellframe-dashboard/bin/
    INSTALLS += service_target
    BUILD_FLAG = static
}

defined(BUILD_FLAG,var){
    LIBS += -L/usr/lib/icu-static -licuuc -licui18n -licudata
}

RESOURCES += \
    $$PWD/CellFrameDashboardService.qrc

DISTFILES += \
    classdiagram.qmodel
