QT += qml quick widgets svg network

include(../config.pri)

TARGET = $${BRAND}

DEFINES += DAP_SERVICE_NAME=\\\"$${BRAND}Service\\\" \
    DAP_SETTINGS_FILE=\\\"settings.json\\\"

HEADERS += $$PWD/DapServiceController.h \
    Autocomplete/CommandCmdController.h \
    ConfigWorker/configfile.h \
    ConfigWorker/configworker.h \
    DapApplication.h \
    DapMath.h \
    DiagnosticWorker/DiagnosticWorker.h \
    DiagnosticWorker/AbstractDiagnostic.h \
    DiagnosticWorker/models/AbstractNodeModel.h \
    DiagnosticWorker/models/NodeModel.h \
    HistoryWorker/historymodel.h \
    HistoryWorker/historyworker.h \
    ImportCertificate/ImportCertificate.h \
    Modules/Certificates/DapModuleCertificates.h \
    Modules/Console/DapModuleConsole.h \
    Modules/DapAbstractModule.h \
    Modules/DapModulesController.h \
    Modules/Dex/DapModuleDex.h \
    Modules/Diagnostics/DapModuledDiagnostics.h \
    Modules/Logs/DapModuleLogs.h \
    Modules/Settings/DapModuleSettings.h \
    Modules/Test/DapModuleTest.h \
    Modules/Tokens/DapModuleTokens.h \
    Modules/TxExplorer/DapModuleTxExplorer.h \
    Modules/Wallet/DapModuleWallet.h \
    Modules/dApps/DapModuledApps.h \
    NotifyController/DapNotifyController.h \
    PluginsController/DapNetworkManager.h \
    PluginsController/DapPluginsController.h \
    StockDataWorker/candlechartworker.h \
    StockDataWorker/candleinfo.h \
    StockDataWorker/orderbookworker.h \
    StockDataWorker/orderinfo.h \
    StockDataWorker/priceinfo.h \
    StockDataWorker/stockdataworker.h \
    StockDataWorker/tokenpairinfo.h \
    StockDataWorker/tokenpairsworker.h \
    WalletRestore/randomfile.h \
    WalletRestore/randomwords.h \
    WalletRestore/wallethashmanager.h \
    Workers/stringworker.h \
    dapvpnorderscontroller.h \
    mobile/QMLClipboard.h \
    mobile/testcontroller.h \
    quickcontrols/qrcodequickitem.h \
    resizeimageprovider.h \
    serviceimitator.h \
    systemtray.h \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.h \
    windowframerect.h

SOURCES += $$PWD/main.cpp \
    $$PWD/DapServiceController.cpp \
    Autocomplete/CommandCmdController.cpp \
    ConfigWorker/configfile.cpp \
    ConfigWorker/configworker.cpp \
    DapApplication.cpp \
    DapMath.cpp \
    DiagnosticWorker/DiagnosticWorker.cpp \
    DiagnosticWorker/AbstractDiagnostic.cpp \
    DiagnosticWorker/models/AbstractNodeModel.cpp \
    DiagnosticWorker/models/NodeModel.cpp \
    HistoryWorker/historymodel.cpp \
    HistoryWorker/historyworker.cpp \
    ImportCertificate/ImportCertificate.cpp \
    Modules/Certificates/DapModuleCertificates.cpp \
    Modules/Console/DapModuleConsole.cpp \
    Modules/DapAbstractModule.cpp \
    Modules/DapModulesController.cpp \
    Modules/Dex/DapModuleDex.cpp \
    Modules/Diagnostics/DapModuledDiagnostics.cpp \
    Modules/Logs/DapModuleLogs.cpp \
    Modules/Settings/DapModuleSettings.cpp \
    Modules/Test/DapModuleTest.cpp \
    Modules/Tokens/DapModuleTokens.cpp \
    Modules/TxExplorer/DapModuleTxExplorer.cpp \
    Modules/Wallet/DapModuleWallet.cpp \
    Modules/dApps/DapModuledApps.cpp \
    NotifyController/DapNotifyController.cpp \
    PluginsController/DapFilesFunctions.cpp \
    PluginsController/DapNetworkManager.cpp \
    PluginsController/DapPluginsController.cpp \
    StockDataWorker/candlechartworker.cpp \
    StockDataWorker/orderbookworker.cpp \
    StockDataWorker/stockdataworker.cpp \
    StockDataWorker/tokenpairsworker.cpp \
    WalletRestore/randomfile.cpp \
    WalletRestore/randomwords.cpp \
    WalletRestore/wallethashmanager.cpp \
    Workers/stringworker.cpp \
    dapvpnorderscontroller.cpp \
    mobile/testcontroller.cpp \
    quickcontrols/qrcodequickitem.cpp \
    resizeimageprovider.cpp \
    serviceimitator.cpp \
    systemtray.cpp \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.cpp

win32 {
    RC_ICONS = $$PWD/Resources/icon_win32.ico
    HEADERS += $$PWD/DiagnosticWorker/WinDiagnostic.h
    SOURCES += $$PWD/DiagnosticWorker/WinDiagnostic.cpp
}

mac {
    ICON = Resources/CellframeDashboard.icns
    HEADERS += $$PWD/DiagnosticWorker/MacDiagnostic.h
    SOURCES += $$PWD/DiagnosticWorker/MacDiagnostic.cpp
}
else: !win32 {
    ICON = qrc:/Resources/icon.ico

    HEADERS += $$PWD/DiagnosticWorker/LinuxDiagnostic.h
    SOURCES += $$PWD/DiagnosticWorker/LinuxDiagnostic.cpp
}


!android {
    MOC_DIR = moc
    OBJECTS_DIR = obj
    RCC_DIR = rcc
    UI_DIR = uic
}

INCLUDEPATH += $$_PRO_FILE_PWD_/../dapRPCProtocol/

OTHER_FILES += libdap-qt-ui-qml \
               libdap-qt-ui-chain-wallet

RESOURCES += $$PWD/qml.qrc
RESOURCES += $$PWD/../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: !mac: target.path = /opt/$${BRAND_LO}/bin
!isEmpty(target.path): INSTALLS += target

include (../dap-ui-sdk/qml/libdap-qt-ui-qml.pri)
include (../dap-ui-sdk/core/libdap-qt.pri)

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/core/ -ldap_core
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/core/libdap_core.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/3rdparty/uthash/src/

unix {
    INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/src/unix/
}

win32 {
    LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/core/src/win32/ -ldap_core_win32
    INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/include/ \
        $$PWD/../cellframe-node/cellframe-sdk/3rdparty/uthash/src/ \
	$$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/src/win32/ \
	$$PWD/../cellframe-node/cellframe-sdk/3rdparty/wepoll/
}

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/client/ -ldap_client \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/core/ -ldap_server_core \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/enc_server/ -ldap_enc_server \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/http_server/ -ldap_http_server \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/json_rpc/ -ldap_json_rpc \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/notify_server/ -ldap_notify_srv

#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/client/libdap_client.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/core/libdap_server_core.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/enc_server/libdap_enc_server.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/http_server/libdap_http_server.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/json_rpc/libdap_json_rpc.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/notify_server/libdap_notify_srv.a


INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/client/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/core/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/enc_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/http_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/http_server/http_client/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/json_rpc/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/notify_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/ch/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/stream/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/session/include/

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/modules/common/ -ldap_chain_common
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/modules/common/libdap_chain_common.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/modules/common/include/

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/crypto/ -ldap_crypto
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/crypto/libdap_crypto.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/rand/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/Keccak/FIPS202 \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/common \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/common

INCLUDEPATH += $$NODE_BUILD_PATH/cellframe-sdk/deps/include/json-c/
LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/deps/lib/ -ldap_json-c
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/deps/lib/libdap_json-c.a

include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)
include (../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.pri)

linux-* {
    LIBS += -lrt -lmagic
    gui_target.files = $$OUT_PWD/$${BRAND}
    gui_target.path = /opt/$${BRAND_LO}/bin/
    INSTALLS += gui_target
    BUILD_FLAG = static
}

win32  {
    LIBS += -lntdll -lpsapi -ljson-c -lmagic -lmqrt -lshlwapi -lregex -ltre -lintl -liconv -lbcrypt -lcrypt32 -lsecur32 -luser32 -lws2_32 -lole32
    CONFIG(debug, debug|release) {
            TARGET_PATH = $$OUT_PWD/debug/$${TARGET}.exe
    }
    CONFIG(release, debug|release) {
            TARGET_PATH = $$OUT_PWD/release/$${TARGET}.exe
    }

    gui_target.files = $$TARGET_PATH
    gui_target.path = /opt/$${BRAND_LO}/bin/
    #force qmake generate installs in makefiles for unbuilded targets
    gui_target.CONFIG += no_check_exist
    INSTALLS += gui_target

    nsisfmt.commands += (echo !define APP_NAME \"$$BRAND\" && \
                        echo !define APP_VERSION \"$${VERSION}.0\" && \
			echo !define APP_VER \"$${VER_MAJ}.$${VER_MIN}-$${VER_PAT}\") \
			> $$shell_path($$OUT_PWD/nsis.defines.nsh)

    QMAKE_EXTRA_TARGETS += nsisfmt
    POST_TARGETDEPS += nsisfmt

    nsisfmt_target.files = $$OUT_PWD/nsis.defines.nsh
    nsisfmt_target.path = /
    nsisfmt_target.CONFIG += no_check_exist

    nsis_target.files = $$PWD/../os/windows/*
    nsis_target.path = /

    icon_target.files = $$RC_ICONS
    icon_target.path = /

    INSTALLS += nsis_target nsisfmt_target icon_target
}

mac {
    QMAKE_LFLAGS += -F /System/Library/Frameworks/Security.framework/
    QMAKE_LFLAGS_SONAME  = -Wl,-install_name,@executable_path/../Frameworks/
    LIBS += -framework Security -framework Carbon -lobjc
        
    QMAKE_INFO_PLIST = $$_PRO_FILE_PWD_/../os/macos/Info.plist
    QMAKE_PROVISIONING_PROFILE=1677e600-eb71-4cab-a38f-13b4aa7bd976
    QMAKE_DEVELOPMENT_TEAM=5W95PVWDQ3
        
    gui_target.files = $${OUT_PWD}/$${TARGET}.app
    gui_target.path = /
    gui_target.CONFIG += no_check_exist
    INSTALLS += gui_target


    DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/cellframe-uninstaller \
        $$_PRO_FILE_PWD_/../os/macos/com.demlabs.Cellframe-DashboardService.plist \
	$$_PRO_FILE_PWD_/../os/macos/com.demlabs.cellframe-node.plist \
	$$_PRO_FILE_PWD_/../os/macos/uninstall \
	$$_PRO_FILE_PWD_/../os/macos/uninstall_icon.rsrc
    DASHBOARD_RESOURCES.path = Contents/Resources

    DASHBOARD_CLEANUP_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/cleanup/
    DASHBOARD_CLEANUP_RESOURCES.path = Contents/Resources/cleunup/
        
    QMAKE_BUNDLE_DATA += DASHBOARD_RESOURCES DASHBOARD_CLEANUP_RESOURCES

    pkginstall.files = $$_PRO_FILE_PWD_/../os/macos/PKGINSTALL/
    pkginstall.path = /
    INSTALLS += pkginstall
}

#android {
#    QT += androidextras

#    DISTFILES += \
#        android/AndroidManifest.xml \
#        android/build.gradle \
#        android/gradle/wrapper/gradle-wrapper.jar \
#        android/gradle/wrapper/gradle-wrapper.properties \
#        android/gradlew \
#        android/gradlew.bat \
#        android/res/values/libs.xml \
#        qzip/zlib/zlib-1.2.5.zip \
#        qzip/zlib/zlib125dll.zip \
#        android/src/com/Cellframe/Dashboard/*.java

#    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

#    gui_data_static.path = /
#    gui_data_static.files = android/*
#    INSTALLS += gui_data_static

#include($$(OPENSSL_LIB)/openssl.pri)
#}
