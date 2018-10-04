#-------------------------------------------------
#
# Project created by QtCreator 2018-09-25T15:52:05
#
#-------------------------------------------------

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

QT += quick quickwidgets

SOURCES +=\
    $$PWD/DapCommand.cpp \
    $$PWD/DapLocalServer.cpp \
    $$PWD/DapLocalClient.cpp \
    $$PWD/DapHalper.cpp \
    $$PWD/DapSettings.cpp \
    $$PWD/DapSettingsCipher.cpp

HEADERS +=\
    $$PWD/DapCommand.h \
    $$PWD/DapLocalServer.h \
    $$PWD/DapLocalClient.h \
    $$PWD/DapHalper.h \
    $$PWD/DapSettings.h \
    $$PWD/DapSettingsCipher.h
