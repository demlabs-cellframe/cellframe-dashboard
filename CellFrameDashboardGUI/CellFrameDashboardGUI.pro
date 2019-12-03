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
ICON = Resources/Icons/dashboard.icns
}
else {
ICON = Resources/Icons/icon.ico
}

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

#DESTDIR = bin
#MOC_DIR = moc
#OBJECTS_DIR = obj
#RCC_DIR = rcc
#UI_DIR = uic

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

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH += $$PWD/screen \
#                   $$PWD/screen/Dashboard

# Additional import path used to resolve QML modules just for Qt Quick Designer
#QML_DESIGNER_IMPORT_PATH += $$PWD/screen/ \
#                            $$PWD/screen/Dashboard

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

#DISTFILES += \
#    $${QML_PATH}/DapUiQmlScreen.qml \
#    $${QML_PATH}/DapUiQmlScreenMainWindow.qml \
#    $${QML_PATH}/DapUiQmlScreenMainWindowForm.ui.qml \
#    $${QML_PATH}/main.qml \
#    $${QML_PATH}/DapUiQmlWidgetStatusBarComboBoxDelegate.qml \
#    $${QML_PATH}/DapUiQmlWidgetStatusBarComboBox.qml \
#    $${QML_PATH}/DapUiQmlWidgetStatusBarContentItem.qml \
#    $${QML_PATH}/Dashboard/DapUiQmlScreenDashboard.qml \
#    $${QML_PATH}/Console/DapUiQmlWidgetConsoleForm.ui.qml \
#    $${QML_PATH}/Console/DapUiQmlWidgetConsole.qml \
#    $${QML_PATH}/Console/DapUiQmlScreenConsoleForm.ui.qml \
#    $${QML_PATH}/Console/DapUiQmlWidgetConsoleLastActionsDelegateForm.qml \
#    $${QML_PATH}/Console/DapUiQmlWidgetConsoleLastActionsForm.qml \
#    $${QML_PATH}/Exchange/DapUiQmlScreenExchangeForm.ui.qml \
#    $${QML_PATH}/Exchange/DapUiQmlWidgetChainExchanges.ui.qml \
#    $${QML_PATH}/Exchange/DapUiQmlWidgetExchangeOrderButtonForm.ui.qml \
#    $${QML_PATH}/Exchange/DapUiQmlWidgetExchangeOrderContentForm.ui.qml \
#    $${QML_PATH}/Exchange/DapUiQmlWidgetExchangeOrderForm.ui.qml \
#    $${QML_PATH}/Exchange/DapUiQmlWidgetExchangeOrderTitleForm.ui.qml \
#    $${QML_PATH}/Explorer/DapUiQmlWidgetNodeNetworkExplorer.qml \
#    $${QML_PATH}/History/DapUiQmlScreenHistory.qml \
#    $${QML_PATH}/History/DapUiQmlScreenHistoryForm.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlRecoveryNotesForm.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlRecoveryQrForm.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlScreenDialogAddWallet.qml \
#    $${QML_PATH}/LastAction/DapUiQmlScreenDialogAddWalletForm.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlScreenDialogAddWalletHeader.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWalletCreated.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWalletCreatedForm.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWalletCreatedHeader.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetHistoryLastActions.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetLastActions.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetLastActionsButtonForm.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetLastActionsDelegateForm.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetLastActionsForm.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetLastActionsHeaderForm.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetLastActionsSectionForm.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetRightPanel.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetRightPanelForm.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetScreenDialogAddWallet.ui.qml \
#    $${QML_PATH}/LastAction/DapUiQmlWidgetSignatureTypeComboBox.qml \
#    $${QML_PATH}/Log/DapUiQmlWidgetChainNodeLogs.qml \
#    $${QML_PATH}/Log/DapUiQmlWidgetChainNodeLogsForm.ui.qml \
#    $${QML_PATH}/Settings/DapUiQmlScreenSettings.qml \
#    $${QML_PATH}/Settings/DapUiQmlScreenSettingsForm.ui.qml \
#    $${QML_PATH}/Settings/DapUiQmlScreenSettingsSection.qml \
#    $${QML_PATH}/Settings/DapUiQmlWidgetSettingsNetwork.qml \
#    $${QML_PATH}/Settings/DapUiQmlWidgetSettingsNetworkForm.ui.qml \
#    $${QML_PATH}/StatusBar/DapUiQmlWidgetStatusBar.qml \
#    $${QML_PATH}/StatusBar/DapUiQmlWidgetStatusBarButton.ui.qml \
#    $${QML_PATH}/StatusBar/DapUiQmlWidgetStatusBarComboBoxWallet.qml \
#    $${QML_PATH}/StatusBar/DapUiQmlWidgetStatusBarComboBoxWalletForm.ui.qml \
#    $${QML_PATH}/VPN/DapUiQmlScreenVpn.qml \
#    $${QML_PATH}/VPN/DapUiQmlScreenVpnForm.ui.qml \
#    $${QML_PATH}/VPN/DapUiQmlWidgetSettingsVpn.qml \
#    $${QML_PATH}/VPN/DapUiQmlWidgetSettingsVpnComboBox.qml \
#    $${QML_PATH}/VPN/DapUiQmlWidgetSettingsVpnComboBoxForm.ui.qml \
#    $${QML_PATH}/VPN/DapUiQmlWidgetSettingsVpnForm.ui.qml

include (../libdap/libdap.pri)
include (../libdap-crypto/libdap-crypto.pri)
include (../libdap-qt/libdap-qt.pri)
include (../libdap-qt-ui-qml/libdap-qt-ui-qml.pri)

include (../libCellFrameDashboardCommon/libCellFrameDashboardCommon.pri)
include (../DapRPCProtocol/DapRPCProtocol.pri)

#copy_to_build.path = $$DESTDIR/screens
#copy_to_build.files = $${QML_PATH}/*

#INSTALLS += copy_to_build

unix: !mac : !android {
    gui_target.files = $${BRAND}
    gui_target.path = /opt/cellframe-dashboard/bin/
    INSTALLS += gui_target
}
