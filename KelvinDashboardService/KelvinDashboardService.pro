QT += core network widgets
QT += gui

CONFIG += c++11
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
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
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
        main.cpp \
    DapChainDashboardService.cpp \
    DapChainNode.cpp \
    DapChainNodeCache.cpp \
    DapLogReader.cpp \
    DapChainWalletHandler.cpp

HEADERS += \
    DapChainDashboardService.h \
    DapChainNode.h \
    DapChainNodeCache.h \
    DapLogReader.h \
    DapChainWalletHandler.h

include (../kelvin-node/kelvin-node.pri)
include (../libKelvinDashboardCommon/libKelvinDashboardCommon.pri)
include (../DapRPCProtocol/DapRPCProtocol.pri)

INCLUDEPATH += $$_PRO_FILE_PWD_/../libKelvinDashboardCommon/
               $$_PRO_FILE_PWD_/../DapRPCProtocol/
                $$_PRO_FILE_PWD_/../kelvin-node/

RESOURCES += \
    KelvinDashboardService.qrc
