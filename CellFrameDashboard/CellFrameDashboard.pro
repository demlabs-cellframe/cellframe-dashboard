QT += qml quick widgets svg network

include (../config.pri)
TARGET = $${BRAND}

DEFINES += CPPHTTPLIB_OPENSSL_SUPPORT

isEmpty($$[OPENSSL_LINKED]) {
    LIBS += -lssl -lcrypto
}


INCLUDEPATH += $$_PRO_FILE_PWD_/../dapRPCProtocol/

include (../cellframe-ui-sdk/DapTypes/DapTypes.pri)
include (Models/Models.pri)
include (DataManager/DataManager.pri)
include($$PWD/Modules/Modules.pri)

include (../dap-ui-sdk/qml/libdap-qt-ui-qml.pri)
include (../dap-ui-sdk/core/libdap-qt-helpers.pri)
include (../web3_api/web3_api.pri)

include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)
include (../cellframe-ui-sdk/cellframenode/libdap-qt-cellframe-node.pri)
include (../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.pri)

INCLUDEPATH +=  $$SDK_INSTALL_PATH/include/dap/core/ \
                $$SDK_INSTALL_PATH/include/dap/core/win32 \
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
                $$SDK_INSTALL_PATH/include/dap/net/link_manager/ \
                $$SDK_INSTALL_PATH/include/dap/net/stream/ch/ \
                $$SDK_INSTALL_PATH/include/dap/net/stream/stream/ \
                $$SDK_INSTALL_PATH/include/dap/net/stream/session/ \
                $$SDK_INSTALL_PATH/include/dap/net/server/http_server/http_client \
                $$SDK_INSTALL_PATH/include/dap/global_db/ \
                $$SDK_INSTALL_PATH/include/json-c/ \
                $$SDK_INSTALL_PATH/include/modules/wallet/ \
                $$SDK_INSTALL_PATH/include/modules/common/ \
                $$SDK_INSTALL_PATH/include/modules/net/ \
                $$SDK_INSTALL_PATH/include/modules/chain/ \
                $$PWD/../cellframe-sdk/dap-sdk/3rdparty/ \
              
CONFIG += no_lflags_merge

LIBS += $$SDK_INSTALL_PATH/lib/modules/net/libdap_chain_net.a \
    $$SDK_INSTALL_PATH/lib/modules/wallet/libdap_chain_wallet.a \
    $$SDK_INSTALL_PATH/lib/modules/chain/libdap_chain.a \
    $$SDK_INSTALL_PATH/lib/modules/common/libdap_chain_common.a \
    $$SDK_INSTALL_PATH/lib/modules/channel/chain-net-srv/libdap_stream_ch_chain_net_srv.a \
    $$SDK_INSTALL_PATH/lib/modules/net/srv/libdap_chain_net_srv.a \
    $$SDK_INSTALL_PATH/lib/modules/channel/chain-net-srv/libdap_stream_ch_chain_net_srv.a \
    $$SDK_INSTALL_PATH/lib/modules/channel/chain-net/libdap_stream_ch_chain_net.a \
    $$SDK_INSTALL_PATH/lib/modules/net/srv/libdap_chain_net_srv.a \
    $$SDK_INSTALL_PATH/lib/modules/mempool/libdap_chain_mempool.a \
    $$SDK_INSTALL_PATH/lib/modules/service/stake/libdap_chain_net_srv_stake.a \
    $$SDK_INSTALL_PATH/lib/modules/service/xchange/libdap_chain_net_srv_xchange.a \
    $$SDK_INSTALL_PATH/lib/modules/service/voting/libdap_chain_net_srv_voting.a \
    $$SDK_INSTALL_PATH/lib/modules/consensus/esbocs/libdap_chain_cs_esbocs.a \
    $$SDK_INSTALL_PATH/lib/modules/type/blocks/libdap_chain_cs_blocks.a \
    $$SDK_INSTALL_PATH/lib/dap/net/client/libdap_client.a \
    $$SDK_INSTALL_PATH/lib/dap/net/link_manager/libdap_link_manager.a \
    $$SDK_INSTALL_PATH/lib/dap/net/server/enc_server/libdap_enc_server.a \
    $$SDK_INSTALL_PATH/lib/dap/net/server/http_server/libdap_http_server.a \
    $$SDK_INSTALL_PATH/lib/dap/net/server/notify_server/libdap_notify_srv.a \
    $$SDK_INSTALL_PATH/lib/dap/net/server/cli_server/libdap_cli_server.a \
    $$SDK_INSTALL_PATH/lib/dap/net/server/json_rpc/libdap_json_rpc.a \
    $$SDK_INSTALL_PATH/lib/dap/net/server/json_rpc/rpc_core/libdap_json_rpc_core.a \
    $$SDK_INSTALL_PATH/lib/dap/net/stream/ch/libdap_stream_ch.a \
    $$SDK_INSTALL_PATH/lib/dap/net/stream/stream/libdap_stream.a \
    $$SDK_INSTALL_PATH/lib/dap/net/stream/session/libdap_session.a \
    $$SDK_INSTALL_PATH/lib/dap/net/server/notify_server/libdap_notify_srv.a \
    $$SDK_INSTALL_PATH/lib/dap/global_db/libdap_global_db.a \
    $$SDK_INSTALL_PATH/lib/dap/io/libdap_io.a \
    $$SDK_INSTALL_PATH/lib/dap/crypto/libdap_crypto.a \
    $$SDK_INSTALL_PATH/lib/dap/crypto/libdap-XKCP*.a \
    $$SDK_INSTALL_PATH/lib/dap/crypto/libdap_crypto_kyber512.a \
    $$SDK_INSTALL_PATH/lib/dap/core/libdap_core.a \
    $$SDK_INSTALL_PATH/lib/libdap_json-c.a


mac {
    HOMEBREW_PREFIX = $$[HOMEBREW_PREFIX]
    
    isEmpty($$(HOMEBREW_PREFIX)) {
        INCLUDEPATH += /opt/osxcross/macports/pkgs/opt/local/libexec/openssl3/include/

        LIBS += /opt/osxcross/macports/pkgs/opt/local/libexec/openssl3/lib/libssl.a \
                /opt/osxcross/macports/pkgs/opt/local/libexec/openssl3/lib/libcrypto.a

    } else {

        INCLUDEPATH += $$(HOMEBREW_PREFIX)/opt/openssl@3/include    
        LIBS += -L $$(HOMEBREW_PREFIX)/opt/openssl@3/lib/ -lssl -lcrypto
     
    }
}
  

win32 {
    RC_ICONS = $$PWD/Resources/icon_win32.ico
}

mac {
    ICON = Resources/CellframeDashboard.icns
}
else: !win32 {
    ICON = qrc:/Resources/icon.ico
}

!android {
    MOC_DIR = moc
    OBJECTS_DIR = obj
    RCC_DIR = rcc
    UI_DIR = uic
}

HEADERS += $$PWD/DapServiceController.h \
    Autocomplete/CommandHelperController.h \
    DapApplication.h \
    DapGuiApplication.h \
    DapDashboardPathDefines.h \
    NotifyController/DapNotifyController.h \
    Workers/dateworker.h \
    Workers/mathworker.h \
    Workers/stringworker.h \
    Translator/qmltranslator.h \
    dapvpnorderscontroller.h \
    mobile/QMLClipboard.h \
    mobile/testcontroller.h \
    quickcontrols/qrcodequickitem.h \
    resizeimageprovider.h \
    systemtray.h \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.h \
    windowframerect.h

SOURCES += $$PWD/main.cpp \
    $$PWD/DapServiceController.cpp \
    Autocomplete/CommandHelperController.cpp \
    DapApplication.cpp \
    DapGuiApplication.cpp \
    DapDashboardPathDefines.cpp \
    NotifyController/DapNotifyController.cpp \
    Workers/dateworker.cpp \
    Workers/mathworker.cpp \
    Workers/stringworker.cpp \
    Translator/qmltranslator.cpp \
    dapvpnorderscontroller.cpp \
    mobile/testcontroller.cpp \
    quickcontrols/qrcodequickitem.cpp \
    resizeimageprovider.cpp \
    systemtray.cpp \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.cpp

OTHER_FILES += libdap-qt-ui-qml \
               libdap-qt-ui-chain-wallet

RESOURCES += $$PWD/qml.qrc
RESOURCES += $$PWD/../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: !mac: target.path = /opt/$${BRAND_LO}/bin
!isEmpty(target.path): INSTALLS += target


linux-* {
    LIBS += -lrt -lmagic
    gui_target.files = $$OUT_PWD/$${BRAND}
    gui_target.path = /opt/$${BRAND_LO}/bin/
    INSTALLS += gui_target
    BUILD_FLAG = static

    share_target.files = $$PWD/../os/debian/share/
    share_target.path = /opt/cellframe-dashboard/
    INSTALLS += share_target
}

win32  {
    LIBS += -lntdll -lpsapi -lmqrt -lshlwapi -lregex -ltre -lintl -liconv -lbcrypt -lcrypt32 -lsecur32 -luser32 -lws2_32 -lole32
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
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.15

    QMAKE_INFO_PLIST = $$_PRO_FILE_PWD_/../os/macos/Info.plist
    QMAKE_PROVISIONING_PROFILE=1677e600-eb71-4cab-a38f-13b4aa7bd976
    QMAKE_DEVELOPMENT_TEAM=5W95PVWDQ3
        
    gui_target.files = $${OUT_PWD}/$${TARGET}.app
    gui_target.path = /
    gui_target.CONFIG += no_check_exist
    INSTALLS += gui_target

    DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/cellframe-uninstaller \
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
12