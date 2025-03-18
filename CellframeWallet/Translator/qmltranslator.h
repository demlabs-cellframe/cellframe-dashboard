#ifndef QMLTRANSLATOR_H
#define QMLTRANSLATOR_H

#include <QObject>
#include <QTranslator>
#include <QQmlEngine>

class QMLTranslator : public QObject
{
    Q_OBJECT
public:
    explicit QMLTranslator(QQmlEngine *engine, QObject *parent = 0);

    Q_INVOKABLE void setLanguage(QString language);

signals:
    void languageChanged();

private:
    QTranslator _translator;
    QQmlEngine *_engine;
};

#endif // QMLTRANSLATOR_H
