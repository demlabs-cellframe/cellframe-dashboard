#include "qmltranslator.h"

#include <QDebug>
#include <QGuiApplication>

QMLTranslator::QMLTranslator(QQmlEngine *engine, QObject *parent) :
    QObject(parent),
    _engine(engine)
{

}

void QMLTranslator::setLanguage(QString language)
{
    QString fileName(QString("Translation_%1").arg(language));

    qDebug() << "QMLTranslator::setLanguage" << language << fileName;

    if (!_translator.load(fileName, ":/Resources/Translations/") )
    {
        qDebug() << "Failed to load" << fileName << ", switch to English";
    }

    qApp->installTranslator(&_translator);
    _engine->retranslate();

    emit languageChanged();
}
