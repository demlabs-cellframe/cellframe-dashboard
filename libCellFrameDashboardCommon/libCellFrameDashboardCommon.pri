#-------------------------------------------------
#
# Project created by QtCreator 2018-09-25T15:52:05
#
#-------------------------------------------------

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

QT += qml quick quickwidgets
CONFIG += c++11

SOURCES +=\
    $$PWD/DapChainConvertor.cpp \
    $$PWD/DapHalper.cpp \
    $$PWD/DapHistoryType.cpp \
    $$PWD/DapSettings.cpp \
    $$PWD/DapLogMessage.cpp \
    $$PWD/DapChainWallet.cpp \
    $$PWD/Handlers/DapAbstractCommand.cpp \
    $$PWD/Handlers/DapAddWalletCommand.cpp \
    $$PWD/Handlers/DapUpdateLogsCommand.cpp

HEADERS +=\
    $$PWD/DapChainConvertor.h \
    $$PWD/DapHalper.h \
    $$PWD/DapHistoryType.h \
    $$PWD/DapSettings.h \
    $$PWD/DapLogMessage.h \
    $$PWD/DapChainWallet.h \
    $$PWD/DapNodeType.h \
    $$PWD/Handlers/DapAbstractCommand.h \
    $$PWD/Handlers/DapAddWalletCommand.h \
    $$PWD/Handlers/DapUpdateLogsCommand.h
