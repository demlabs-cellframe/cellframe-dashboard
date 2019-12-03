QT += qml quick widgets

TEMPLATE = app
CONFIG += c++11


!defined(BRAND,var){
#  Default brand
    BRAND = CellFrameDashboard
}

TARGET = $$BRAND

VER_MAJ = 1
VER_MIN = 6
VER_PAT = 4

win32 {
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += CLI_PATH=\\\"./cellframe-node-cli.exe\\\"
    DEFINES += HAVE_STRNDUP
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/opt/cellframe-node/bin/cellframe-node-cli\\\"
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += DAP_BRAND=\\\"$$BRAND\\\"
DEFINES += DAP_SERVICE_NAME=\\\"CellFrameDashboardService\\\"
DEFINES += DAP_VERSION=\\\"$$VERSION\\\"
DEFINES += DAP_SETTINGS_FILE=\\\"settings.json\\\"
macx {
ICON = res/icons/dashboard.icns
}
else {
ICON = res/icons/icon.ico
}

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

MOC_DIR = moc
OBJECTS_DIR = obj
RCC_DIR = rcc
UI_DIR = uic

CONFIG(debug, debug|release) {
    DESTDIR = bin/debug
} else {
    DESTDIR = bin/release
}

SRC_PATH = $$PWD/src/
INCLUDE_PATH = $${SRC_PATH}/include/
QML_PATH = $$PWD/screen/

INCLUDEPATH += $$_PRO_FILE_PWD_/../libCellFrameDashboardCommon/ \
               $$_PRO_FILE_PWD_/../DapRPCProtocol/ \
               $${INCLUDE_PATH}/ \
               $${SRC_PATH}/

SOURCES += \
    $${SRC_PATH}/DapChainNodeNetworkExplorer.cpp \
    $${SRC_PATH}/DapChainNodeNetworkModel.cpp \
    $${SRC_PATH}/DapChainWalletModel.cpp \
    $${SRC_PATH}/DapClipboard.cpp \
    $${SRC_PATH}/DapConsoleModel.cpp \
    $${SRC_PATH}/DapScreenHistoryFilterModel.cpp \
    $${SRC_PATH}/DapScreenHistoryModel.cpp \
    $${SRC_PATH}/DapSettingsNetworkModel.cpp \
    $${SRC_PATH}/DapWalletFilterModel.cpp \
    $${SRC_PATH}/main.cpp \
    $${SRC_PATH}/DapScreenDialog.cpp \
    $${SRC_PATH}/DapScreenDialogChangeWidget.cpp \
    $${SRC_PATH}/DapServiceClient.cpp \
    $${SRC_PATH}/DapServiceController.cpp \
    $${SRC_PATH}/DapCommandController.cpp \
    $${SRC_PATH}/DapServiceClientNativeAbstract.cpp \
    $${SRC_PATH}/DapServiceClientNativeLinux.cpp \
    $${SRC_PATH}/DapServiceClientNativeWin.cpp \
    $${SRC_PATH}/DapServiceClientNativeMacOS.cpp \
    $${SRC_PATH}/DapChainWalletsModel.cpp

RESOURCES += $$PWD/qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/cellframe-dashboard/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    $${INCLUDE_PATH}/DapChainNodeNetworkExplorer.h \
    $${INCLUDE_PATH}/DapChainNodeNetworkModel.h \
    $${INCLUDE_PATH}/DapChainWalletModel.h \
    $${INCLUDE_PATH}/DapClipboard.h \
    $${INCLUDE_PATH}/DapConsoleModel.h \
    $${INCLUDE_PATH}/DapScreenHistoryFilterModel.h \
    $${INCLUDE_PATH}/DapScreenHistoryModel.h \
    $${INCLUDE_PATH}/DapSettingsNetworkModel.h \
    $${INCLUDE_PATH}/DapScreenDialog.h \
    $${INCLUDE_PATH}/DapScreenDialogChangeWidget.h \
    $${INCLUDE_PATH}/DapServiceClient.h \
    $${INCLUDE_PATH}/DapServiceController.h \
    $${INCLUDE_PATH}/DapCommandController.h \
    $${INCLUDE_PATH}/DapServiceClientNativeAbstract.h \
    $${INCLUDE_PATH}/DapServiceClientNativeLinux.h \
    $${INCLUDE_PATH}/DapServiceClientNativeWin.h \
    $${INCLUDE_PATH}/DapChainWalletsModel.h \
    $${INCLUDE_PATH}/DapWalletFilterModel.h

include (../libdap/libdap.pri)
include (../libdap-crypto/libdap-crypto.pri)
include (../libdap-qt/libdap-qt.pri)
include (../libdap-qt-ui-qml/libdap-qt-ui-qml.pri)

include (../libCellFrameDashboardCommon/libCellFrameDashboardCommon.pri)
include (../DapRPCProtocol/DapRPCProtocol.pri)

unix: !mac : !android {
    gui_target.files = $${BRAND}
    gui_target.path = /opt/cellframe-dashboard/bin/
    INSTALLS += gui_target
}
