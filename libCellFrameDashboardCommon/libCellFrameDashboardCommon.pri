#-------------------------------------------------
#
# Project created by QtCreator 2018-09-25T15:52:05
#
#-------------------------------------------------

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

QT += qml quick quickwidgets gui
CONFIG += c++11

SOURCES +=\
    $$PWD/DapChainConvertor.cpp \
    $$PWD/DapHalper.cpp \
    $$PWD/DapHistoryType.cpp \
    $$PWD/DapSettings.cpp \
    $$PWD/DapLogMessage.cpp \
    $$PWD/DapSystemTrayIcon.cpp \
    $$PWD/DapWallet.cpp \
    $$PWD/DapWalletToken.cpp \
    $$PWD/DapWalletHistoryEvent.cpp \
    $$PWD/Handlers/DapAbstractCommand.cpp \
    $$PWD/Handlers/DapActivateClientCommand.cpp \
    $$PWD/Handlers/DapGetHistoryExecutedCmdCommand.cpp \
    $$PWD/Handlers/DapGetListNetworksCommand.cpp \
    $$PWD/Handlers/DapGetListWalletsCommand.cpp \
    $$PWD/Handlers/DapExportLogCommand.cpp \
    $$PWD/Handlers/DapGetWalletAddressesCommand.cpp \
    $$PWD/Handlers/DapGetWalletHistoryCommand.cpp \
    $$PWD/Handlers/DapGetWalletTokenInfoCommand.cpp \
    $$PWD/Handlers/DapCreateTransactionCommand.cpp \
    $$PWD/Handlers/DapMempoolProcessCommand.cpp \
    $$PWD/Handlers/DapQuitApplicationCommand.cpp \
    $$PWD/Handlers/DapAddWalletCommand.cpp \
    $$PWD/Handlers/DapRunCmdCommand.cpp \
    $$PWD/Handlers/DapSaveHistoryExecutedCmdCommand.cpp \
    $$PWD/Handlers/DapUpdateLogsCommand.cpp \
    $$PWD/Models/DapWalletModel.cpp

HEADERS +=\
    $$PWD/DapChainConvertor.h \
    $$PWD/DapHalper.h \
    $$PWD/DapHistoryType.h \
    $$PWD/DapSettings.h \
    $$PWD/DapLogMessage.h \
    $$PWD/DapNodeType.h \
    $$PWD/DapSystemTrayIcon.h \
    $$PWD/DapWallet.h \
    $$PWD/DapWalletToken.h \
    $$PWD/DapWalletHistoryEvent.h\
    $$PWD/Handlers/DapAbstractCommand.h \
    $$PWD/Handlers/DapActivateClientCommand.h \
    $$PWD/Handlers/DapGetHistoryExecutedCmdCommand.h \
    $$PWD/Handlers/DapGetListNetworksCommand.h \
    $$PWD/Handlers/DapGetListWalletsCommand.h \
    $$PWD/Handlers/DapExportLogCommand.h \
    $$PWD/Handlers/DapGetWalletAddressesCommand.h \
    $$PWD/Handlers/DapGetWalletHistoryCommand.h \
    $$PWD/Handlers/DapGetWalletTokenInfoCommand.h \
    $$PWD/Handlers/DapCreateTransactionCommand.h \
    $$PWD/Handlers/DapMempoolProcessCommand.h \
    $$PWD/Handlers/DapQuitApplicationCommand.h \
    $$PWD/Handlers/DapAddWalletCommand.h \
    $$PWD/Handlers/DapRunCmdCommand.h \
    $$PWD/Handlers/DapSaveHistoryExecutedCmdCommand.h \
    $$PWD/Handlers/DapUpdateLogsCommand.h \
    $$PWD/Models/DapWalletModel.h
