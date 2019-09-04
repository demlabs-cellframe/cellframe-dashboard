QT += core network
QT -= gui

CONFIG += c++11 console
CONFIG -= app_bundle

!defined(BRAND,var){
#  Default brand
    BRAND = KelvinDashboard
}
DEFINES += DAP_BRAND=\\\"$$BRAND\\\"

TARGET = $${BRAND}Service

VER_MAJ = 1
VER_MIN = 0
VER_PAT = 0

ICON = icon.ico

win32 {
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += CLI_PATH=\\\"./kelvin-node-cli.exe\\\"
#    DEFINES += LOG_FILE=\\\"./opt/kelvin-node/bin/kelvin-node_logs.txt\\\"
    DEFINES += LOG_FILE=\\\"./kelvin-node_logs.txt\\\"
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/opt/kelvin-node/bin/kelvin-node-cli\\\"
    DEFINES += LOG_FILE=\\\"/opt/kelvin-node/kelvin-node_logs.txt\\\"
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    $$PWD/DapChainHistoryHandler.cpp \
    $$PWD/DapChainNodeNetworkHandler.cpp \
    $$PWD/main.cpp \
    $$PWD/DapChainDashboardService.cpp \
    $$PWD/DapChainNode.cpp \
    $$PWD/DapChainNodeCache.cpp \
    $$PWD/DapChainWalletHandler.cpp \
    $$PWD/DapChainLogHandler.cpp

HEADERS += \
    $$PWD/DapChainDashboardService.h \
    $$PWD/DapChainHistoryHandler.h \
    $$PWD/DapChainNode.h \
    $$PWD/DapChainNodeCache.h \
    $$PWD/DapChainNodeNetworkHandler.h \
    $$PWD/DapChainWalletHandler.h \
    $$PWD/DapChainLogHandler.h

include (../libdap/libdap.pri)
include (../libdap-crypto/libdap-crypto.pri)
include (../libdap-qt/libdap-qt.pri)
include (../libKelvinDashboardCommon/libKelvinDashboardCommon.pri)
include (../DapRPCProtocol/DapRPCProtocol.pri)

INCLUDEPATH += $$_PRO_FILE_PWD_/../libKelvinDashboardCommon/
               $$_PRO_FILE_PWD_/../DapRPCProtocol/
                $$_PRO_FILE_PWD_/../kelvin-node/

unix: !mac : !android {
    service_target.files = $${BRAND}Service
    service_target.path = /opt/kelvin-dashboard/bin/
    INSTALLS += service_target
}

RESOURCES += \
    $$PWD/KelvinDashboardService.qrc
