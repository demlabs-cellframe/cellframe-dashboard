QT += core network gui

CONFIG += c++11 console
CONFIG -= app_bundle

!defined(BRAND,var){
#  Default brand
    BRAND = CellFrameDashboard
}
DEFINES += DAP_BRAND=\\\"$$BRAND\\\"

TARGET = $${BRAND}Service

VER_MAJ = 1
VER_MIN = 6
VER_PAT = 4

win32 {
    CONFIG -= console
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += CLI_PATH=\\\"./cellframe-node-cli.exe\\\"
    DEFINES += LOG_FILE=\\\"./opt/cellframe-node/var/log/cellframe-node_logs.txt\\\"
    DEFINES += CMD_LOG=\\\"./opt/cellframe-dashboard/data/cellframe-cmd_log.txt\\\"
    DEFINES += HAVE_STRNDUP
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/opt/cellframe-node/bin/cellframe-node-cli\\\"
    DEFINES += LOG_FILE=\\\"/opt/cellframe-node/var/log/cellframe-node_logs.txt\\\"
    DEFINES += CMD_LOG=\\\"/opt/cellframe-dashboard/data/cellframe-cmd_log.txt\\\"
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
    $$PWD/DapServiceController.cpp \
    $$PWD/DapToolTipWidget.cpp \
    $$PWD/main.cpp \


HEADERS += \
    $$PWD/DapServiceController.h \
    $$PWD/DapToolTipWidget.h




include (../libdap/libdap.pri)
include (../libdap-crypto/libdap-crypto.pri)
include (../libdap-qt/libdap-qt.pri)

include (../libCellFrameDashboardCommon/libCellFrameDashboardCommon.pri)
include (../DapRPCProtocol/DapRPCProtocol.pri)

INCLUDEPATH += $$_PRO_FILE_PWD_/../libCellFrameDashboardCommon/
               $$_PRO_FILE_PWD_/../DapRPCProtocol/
               $$_PRO_FILE_PWD_/../cellframe-node/

unix: !mac : !android {
    service_target.files = $${BRAND}Service
    service_target.path = /opt/cellframe-dashboard/bin/
    INSTALLS += service_target
}

RESOURCES += \
    $$PWD/CellFrameDashboardService.qrc
