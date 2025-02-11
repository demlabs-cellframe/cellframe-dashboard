#ifndef DAPGUIAPPLICATION_H
#define DAPGUIAPPLICATION_H

#include <QApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QSettings>
#include <QClipboard>

#include "Translator/qmltranslator.h"

class DapGuiApplication : public QApplication
{
    Q_OBJECT
public:
    DapGuiApplication(int &argc, char **argv);
    ~DapGuiApplication();

    QQmlApplicationEngine *qmlEngine();

private:
    QQmlApplicationEngine m_engine;
    QMLTranslator * translator;
};

#endif // DAPGUIAPPLICATION_H
