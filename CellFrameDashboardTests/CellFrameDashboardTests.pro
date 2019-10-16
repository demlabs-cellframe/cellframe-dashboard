include(gtest_dependency.pri)
include (../libCellFrameDashboardCommon/libCellFrameDashboardCommon.pri)

QT += core network
QT -= gui
QT += qml

TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG += thread
CONFIG += qt

SOURCES += \
        DapSettingsTests.cpp \
        main.cpp

INCLUDEPATH += $$_PRO_FILE_PWD_/../libCellFrameDashboardCommon/
