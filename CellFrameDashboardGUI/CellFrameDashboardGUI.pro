QT += qml quick widgets svg

TEMPLATE = app
CONFIG += c++11

LIBS += -ldl

!defined(BRAND,var){
#  Default brand
    BRAND = CellFrameDashboard
}

TARGET = $$BRAND

VER_MAJ = 2
VER_MIN = 0
VER_PAT = 4

win32 {
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += CLI_PATH=\\\"cellframe-node-cli.exe\\\"
    DEFINES += TOOLS_PATH=\\\"cellframe-node-tool.exe\\\"
    DEFINES += HAVE_STRNDUP
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/opt/cellframe-node/bin/cellframe-node-cli\\\"
    DEFINES += TOOLS_PATH=\\\"/opt/cellframe-node/bin/cellframe-node-tool\\\"
    DEFINES += CONFIG_PATH=\\\"/opt/cellframe-node/bin/cellframe-node-cli\\\"
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
    ICON = resources/icons/dashboard.icns
}
else {
    ICON = qrc:/resources/icons/icon.ico
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

INCLUDEPATH += $$_PRO_FILE_PWD_/../dapRPCProtocol/

OTHER_FILES += libdap-qt-ui-qml \
               libdap-qt-ui-chain-wallet

SOURCES += \
    $$PWD/main.cpp \
    $$PWD/DapServiceController.cpp \
    DapApplication.cpp \
    quickcontrols/qrcodequickitem.cpp \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.cpp

RESOURCES += $$PWD/qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/cellframe-dashboard/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    $$PWD/DapServiceController.h \
    DapApplication.h \
    quickcontrols/qrcodequickitem.h \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.h

include (../dap-ui-sdk/qml/libdap-qt-ui-qml.pri)
include (../dap-ui-sdk/core/libdap-qt.pri)
include (../cellframe-sdk/dap-sdk/core/libdap.pri)
include (../cellframe-sdk/dap-sdk/crypto/libdap-crypto.pri)
include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)
include (../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.pri)

unix: !mac : !android {
    gui_target.files = $${BRAND}
    gui_target.path = /opt/cellframe-dashboard/bin/
    INSTALLS += gui_target
}
