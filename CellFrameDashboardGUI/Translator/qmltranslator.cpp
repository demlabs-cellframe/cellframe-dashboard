#include "qmltranslator.h"

#include <QDebug>
#include <QGuiApplication>

#define TRANSLATION_DEBUG

QMLTranslator::QMLTranslator(QQmlEngine *engine, QObject *parent) :
    QObject(parent),
    _engine(engine)
{

}

void QMLTranslator::setLanguage(QString language)
{
    QString fileName(QString("Translation_%1").arg(language));

    qDebug() << "QMLTranslator::setLanguage" << language << fileName;

#ifndef TRANSLATION_DEBUG
    QString filePath(":/Resources/Translations/");
#else
    QString filePath("./");
#endif

    if (!_translator.load(fileName, filePath) )
    {
        qDebug() << "Failed to load" << fileName << ", switch to English";
    }

    qApp->installTranslator(&_translator);
    _engine->retranslate();

    emit languageChanged();
}
