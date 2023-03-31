QT += qml quick widgets svg network
!android {
    TEMPLATE = app
}
CONFIG += c++11

LIBS += -ldl
include(../config.pri)

TARGET = $${BRAND}

win32 {
    DEFINES += HAVE_STRNDUP
    RC_ICONS = $$PWD/Resources/icon_win32.ico
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += DAP_SERVICE_NAME=\\\"$${BRAND}Service\\\"
DEFINES += DAP_SETTINGS_FILE=\\\"settings.json\\\"

mac {
    ICON = Resources/CellframeDashboard.icns
}
else: !win32 {
    ICON = qrc:/Resources/icon.ico
}

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

!android {
    MOC_DIR = moc
    OBJECTS_DIR = obj
    RCC_DIR = rcc
    UI_DIR = uic
}

INCLUDEPATH += $$_PRO_FILE_PWD_/../dapRPCProtocol/

OTHER_FILES += libdap-qt-ui-qml \
               libdap-qt-ui-chain-wallet

SOURCES += \
    $$PWD/main.cpp \
    $$PWD/DapServiceController.cpp \
    Autocomplete/CommandCmdController.cpp \
    DapApplication.cpp \
    DapMath.cpp \
    HistoryWorker/historymodel.cpp \
    HistoryWorker/historyworker.cpp \
    ImportCertificate/ImportCertificate.cpp \
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
    dapvpnorderscontroller.cpp \
    mobile/testcontroller.cpp \
    quickcontrols/qrcodequickitem.cpp \
    resizeimageprovider.cpp \
    serviceimitator.cpp \
    systemtray.cpp \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.cpp

RESOURCES += $$PWD/qml.qrc
RESOURCES += $$PWD/../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: !mac: target.path = /opt/$${BRAND_LO}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    $$PWD/DapServiceController.h \
    Autocomplete/CommandCmdController.h \
    DapApplication.h \
    DapMath.h \
    HistoryWorker/historymodel.h \
    HistoryWorker/historyworker.h \
    ImportCertificate/ImportCertificate.h \
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
    dapvpnorderscontroller.h \
    mobile/QMLClipboard.h \
    mobile/testcontroller.h \
    quickcontrols/qrcodequickitem.h \
    resizeimageprovider.h \
    serviceimitator.h \
    systemtray.h \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.h \
    windowframerect.h

include (../dap-ui-sdk/qml/libdap-qt-ui-qml.pri)
include (../dap-ui-sdk/core/libdap-qt.pri)
include (../cellframe-node/cellframe-sdk/dap-sdk/core/libdap.pri)

LIBS += -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/core/ -ldap_core
PRE_TARGETDEPS += $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/core/libdap_core.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/3rdparty/uthash/src/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/src/unix/
DEPENDPATH += INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/3rdparty/uthash/src/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/src/unix/

LIBS += -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/client/ -ldap_client \
    -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/core/ -ldap_server_core \
    -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/enc_server/ -ldap_enc_server \
    -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/http_server/ -ldap_http_server \
    -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/json_rpc/ -ldap_json_rpc \
    -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/notify_server/ -ldap_notify_srv

PRE_TARGETDEPS += $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/client/libdap_client.a \
    $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/core/libdap_server_core.a \
    $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/enc_server/libdap_enc_server.a \
    $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/http_server/libdap_http_server.a \
    $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/json_rpc/libdap_json_rpc.a \
    $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/net/server/notify_server/libdap_notify_srv.a


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


DEPENDPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/client/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/core/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/enc_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/http_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/http_server/http_client/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/json_rpc/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/notify_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/ch/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/stream/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/session/include/

LIBS += -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/modules/common/ -ldap_chain_common
PRE_TARGETDEPS += $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/modules/common/libdap_chain_common.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/modules/common/include/
DEPENDPATH += $$PWD/../cellframe-node/cellframe-sdk/modules/common/include/

LIBS += -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/crypto/ -ldap_crypto
PRE_TARGETDEPS += $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/dap-sdk/crypto/libdap_crypto.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/rand/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/Keccak/FIPS202 \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/common \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/common

DEPENDPATH += += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/rand/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/Keccak/FIPS202 \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/common \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/common

unix: !mac  {
    INCLUDEPATH += $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/deps/include/json-c/
    DEPENDPATH += $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/deps/include/json-c/
    LIBS += -L$$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/deps/lib/ -ldap_json-c
    PRE_TARGETDEPS += $$OUT_PWD/../CellFrameNode/build_linux_release/build/cellframe-sdk/deps/lib/libdap_json-c.a
}

win32 {
    INCLUDEPATH += ../CellFrameNode/build_windows_release/build/cellframe-sdk/deps/include/json-c/
    LIBS += ../CellFrameNode/build_windows_release/build/cellframe-sdk/deps/lib/libdap_json-c.a
}

mac {
    INCLUDEPATH += ../CellFrameNode/build_osx_release/build/cellframe-sdk/deps/include/json-c/
    LIBS += ../CellFrameNode/build_osx_release/build/cellframe-sdk/deps/lib/libdap_json-c.a
}

include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)
include (../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.pri)

unix: !mac : !android {
    gui_target.files = $$OUT_PWD/$${BRAND}
    gui_target.path = /opt/$${BRAND_LO}/bin/
    INSTALLS += gui_target
    BUILD_FLAG = static
}


#it always win32 even if build with 64bit mingw
win32  { 
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
   
}

win32 {
    
    nsisfmt.commands +=   (echo !define APP_NAME       \"$$BRAND\" && \
                        echo !define APP_VERSION    \"$${VERSION}.0\" && \
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


        DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/cellframe-uninstaller
        DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/com.demlabs.Cellframe-DashboardService.plist
        DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/com.demlabs.cellframe-node.plist
        DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/uninstall
        DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/uninstall_icon.rsrc
        DASHBOARD_RESOURCES.path = Contents/Resources 

        DASHBOARD_CLEANUP_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/cleanup/
        DASHBOARD_CLEANUP_RESOURCES.path = Contents/Resources/cleunup/
        
        QMAKE_BUNDLE_DATA += DASHBOARD_RESOURCES DASHBOARD_CLEANUP_RESOURCES

        pkginstall.files = $$_PRO_FILE_PWD_/../os/macos/PKGINSTALL/
        pkginstall.path = /
        
        INSTALLS += pkginstall

}

android {
    QT += androidextras

    DISTFILES += \
        android/AndroidManifest.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/res/values/libs.xml \
        qzip/zlib/zlib-1.2.5.zip \
        qzip/zlib/zlib125dll.zip \
        android/src/com/Cellframe/Dashboard/*.java

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    gui_data_static.path = /
    gui_data_static.files = android/*
    INSTALLS += gui_data_static

include($$(OPENSSL_LIB)/openssl.pri)
}
