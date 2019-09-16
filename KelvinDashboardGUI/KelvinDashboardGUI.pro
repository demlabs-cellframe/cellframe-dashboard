QT += qml quick widgets

TEMPLATE = app
CONFIG += c++11


!defined(BRAND,var){
#  Default brand
    BRAND = KelvinDashboard
}

TARGET = $$BRAND

VER_MAJ = 1
VER_MIN = 2
VER_PAT = 0


win32 {
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
    DEFINES += CLI_PATH=\\\"./kelvin-node-cli.exe\\\"
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
    DEFINES += CLI_PATH=\\\"/opt/kelvin-node/bin/kelvin-node-cli\\\"
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += DAP_BRAND=\\\"$$BRAND\\\"
DEFINES += DAP_SERVICE_NAME=\\\"KelvinDashboardService\\\"
DEFINES += DAP_VERSION=\\\"$$VERSION\\\"
ICON = icon.ico
# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    DapChainNodeNetworkExplorer.cpp \
    DapChainNodeNetworkModel.cpp \
    DapConsoleModel.cpp \
    DapScreenHistoryFilterModel.cpp \
    DapScreenHistoryModel.cpp \
    DapUiQmlWidgetChainTransactions.cpp \
        main.cpp \
    DapUiQmlWidgetChainBallance.cpp \
    DapUiQmlWidgetChainBlockExplorer.cpp \
    DapUiQmlWidgetChainNodeLogs.cpp \
    DapUiQmlWidgetChainOperations.cpp \
    DapUiQmlWidgetModel.cpp \
    DapUiQmlWidget.cpp \
    DapScreenDialog.cpp \
    DapScreenDialogChangeWidget.cpp \
    DapServiceClient.cpp \
    DapServiceController.cpp \
    DapCommandController.cpp \
    DapServiceClientNativeAbstract.cpp \
    DapServiceClientNativeLinux.cpp \
    DapServiceClientNativeWin.cpp \
    DapChainWalletsModel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/kelvin-dashboard/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    DapChainNodeNetworkExplorer.h \
    DapChainNodeNetworkModel.h \
    DapConsoleModel.h \
    DapScreenHistoryFilterModel.h \
    DapScreenHistoryModel.h \
    DapUiQmlWidgetChainBallance.h \
    DapUiQmlWidgetChainBlockExplorer.h \
    DapUiQmlWidgetChainNodeLogs.h \
    DapUiQmlScreenDashboard.h \
    DapUiQmlWidgetChainOperations.h \
    DapUiQmlWidgetChainTransactions.h \
    DapUiQmlWidgetModel.h \
    DapUiQmlWidget.h \
    DapScreenDialog.h \
    DapScreenDialogChangeWidget.h \
    DapServiceClient.h \
    DapServiceController.h \
    DapCommandController.h \
    DapServiceClientNativeAbstract.h \
    DapServiceClientNativeLinux.h \
    DapServiceClientNativeWin.h \
    DapChainWalletsModel.h

include (../libdap/libdap.pri)
include (../libdap-crypto/libdap-crypto.pri)
include (../libdap-qt/libdap-qt.pri)

include (../libKelvinDashboardCommon/libKelvinDashboardCommon.pri)
include (../DapRPCProtocol/DapRPCProtocol.pri)

INCLUDEPATH += $$_PRO_FILE_PWD_/../libKelvinDashboardCommon/
               $$_PRO_FILE_PWD_/../DapRPCProtocol/


unix: !mac : !android {
    gui_target.files = $${BRAND}
    gui_target.path = /opt/kelvin-dashboard/bin/
    INSTALLS += gui_target
}

DISTFILES +=
