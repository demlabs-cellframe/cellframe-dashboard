QT += core network

include (../config.pri)
TARGET = $${BRAND}Service
DEFINES += SIMULATOR_DEX
win32 {
    CONFIG -= console
}

include (../cellframe-ui-sdk/DapTypes/DapTypes.pri)

INCLUDEPATH +=  $$SDK_INSTALL_PATH/include/dap/core/ \
                $$SDK_INSTALL_PATH/include/dap/crypto/ \
                $$SDK_INSTALL_PATH/include/dap/crypto/XKCP \
                $$SDK_INSTALL_PATH/include/dap/net/client/ \
                $$SDK_INSTALL_PATH/include/dap/io/ \
                $$SDK_INSTALL_PATH/include/dap/net/server/enc_server/ \
                $$SDK_INSTALL_PATH/include/dap/net/server/http_server/ \
                $$SDK_INSTALL_PATH/include/dap/net/server/json_rpc/ \
                $$SDK_INSTALL_PATH/include/dap/net/server/notify_server/ \
                $$SDK_INSTALL_PATH/include/dap/crypto/XKCP/lib/high/Keccak/FIPS202/ \
                $$SDK_INSTALL_PATH/include/dap/crypto/XKCP/lib/high/common \
                $$SDK_INSTALL_PATH/include/dap/crypto/rand/ \
                $$SDK_INSTALL_PATH/include/dap/net/stream/ch/ \
                $$SDK_INSTALL_PATH/include/dap/net/stream/stream/ \
                $$SDK_INSTALL_PATH/include/dap/net/stream/session/ \
                $$SDK_INSTALL_PATH/include/dap/net/server/http_server/http_client \
                $$SDK_INSTALL_PATH/include/dap/global_db/ \
                $$SDK_INSTALL_PATH/include/json-c/ \
                $$SDK_INSTALL_PATH/include/modules/common/ \
                $$SDK_INSTALL_PATH/include/modules/net/ \
                $$SDK_INSTALL_PATH/include/modules/chain/ \
                $$PWD/../cellframe-sdk/dap-sdk/3rdparty/ \


LIBS += $$SDK_INSTALL_PATH/lib/dap/core/libdap_core.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/crypto/libdap_crypto.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/core/libdap_core.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/crypto/libdap_crypto_kyber512.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/net/client/libdap_client.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/io/libdap_io.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/crypto/libdap_crypto.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/crypto/libdap-XKCP*.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/core/libdap_core.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/crypto/libdap_crypto_kyber512.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/net/server/enc_server/libdap_enc_server.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/net/server/http_server/libdap_http_server.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/net/server/json_rpc/libdap_json_rpc.a
LIBS += $$SDK_INSTALL_PATH/lib/dap/net/server/notify_server/libdap_notify_srv.a
LIBS += $$SDK_INSTALL_PATH/lib/modules/common/libdap_chain_common.a
LIBS += $$SDK_INSTALL_PATH/lib/libdap_json-c.a

include (../dap-ui-sdk/core/libdap-qt.pri)

include(../NodeConfigManager/NodeConfigManager.pri)

include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)

include (../web3_api/web3_api.pri)


INCLUDEPATH += $$_PRO_FILE_PWD_/../dapRPCProtocol/


SOURCES += \
    $$PWD/DapServiceController.cpp \
    $$PWD/main.cpp \
    DapNotificationWatcher.cpp \
    DapRegularRequestsController.cpp

HEADERS += \
    $$PWD/DapServiceController.h \
    DapNotificationWatcher.h \
    DapRegularRequestsController.h

linux-* {
    BUILD_FLAG = static
    service_target.files = $$OUT_PWD/$$TARGET
    service_target.path = /opt/$${BRAND_LO}/bin/
    service_target.CONFIG += no_check_exist
    INSTALLS += service_target
    DEFINES += DAP_OS_LINUX
}

win32 {
    INCLUDEPATH += $$PWD/platforms/win32/service/
    HEADERS += platforms/win32/service/Service.h
    SOURCES += platforms/win32/service/Service.cpp
    LIBS += -lntdll -lpsapi -lmagic -lmqrt -lshlwapi -lregex -ltre -lintl -liconv -lbcrypt -lcrypt32 -lsecur32 -luser32 -lws2_32 -lole32

    CONFIG(debug, debug|release) {
        TARGET_PATH = $$OUT_PWD/debug/$${TARGET}.exe
    }
    CONFIG(release, debug|release) {
        TARGET_PATH = $$OUT_PWD/release/$${TARGET}.exe
    }

   service_target.files = $$TARGET_PATH
   service_target.path = /opt/$${BRAND_LO}/bin/
   #force qmake generate installs in makefiles for unbuilded targets
   service_target.CONFIG += no_check_exist
   INSTALLS += service_target

   CONFIG -= embed_manifest_exe
   RC_FILE = ../os/windows/resources.rc
}

mac {
    QMAKE_LFLAGS += -F /System/Library/Frameworks/Security.framework/
    QMAKE_LFLAGS_SONAME  = -Wl,-install_name,@executable_path/../Frameworks/
    LIBS += -framework Security -framework Carbon -lobjc 
    QMAKE_LIBDIR += /usr/local/lib

    service_target.files = $${OUT_PWD}/$${TARGET}.app
    service_target.path = /
    service_target.CONFIG += no_check_exist

    INSTALLS += service_target
}

unix: !mac {
    LIBS += -lrt
}

RESOURCES += \
    $$PWD/CellFrameDashboardService.qrc

DISTFILES += \
    classdiagram.qmodel

win32: nsis_build {
    DESTDIR = $$shell_path($$_PRO_FILE_PWD_/../build_win32/)
}


linux-* {
    share_target.files = $$PWD/../os/debian/share/
    share_target.path = /opt/cellframe-dashboard/
    INSTALLS += share_target
}
