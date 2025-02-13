#ifndef DAPGUIAPPLICATION_H
#define DAPGUIAPPLICATION_H

#include <QApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSettings>
#include <QClipboard>
#include <QSettings>
#include <QStringLiteral>
#include <QUrl>

#include "Translator/qmltranslator.h"
#include "resizeimageprovider.h"
#include "windowframerect.h"

class DapGuiApplication : public QApplication
{
    Q_OBJECT
public:
    DapGuiApplication(int &argc, char **argv, int restartCode, int defaultWidth, int defaultHeight, int minWidth, int minHeight);
    ~DapGuiApplication();

    QQmlApplicationEngine *qmlEngine();
    void loadUrl();
    QUrl m_url;

private:
    QString getSkinUrl();

    QQmlApplicationEngine m_engine;
    QMLTranslator * translator;

    int m_restartCode{12345};
    int m_defaultWidth{1280};
    int m_defaultHeight{720};
    int m_minWidth{1280};
    int m_minHeight{720};
};

#endif // DAPGUIAPPLICATION_H
