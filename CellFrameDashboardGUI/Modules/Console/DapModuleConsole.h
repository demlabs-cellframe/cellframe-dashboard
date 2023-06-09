#ifndef DAPMODULECONSOLE_H
#define DAPMODULECONSOLE_H

#include <QObject>
#include <QQmlContext>
#include "../DapAbstractModule.h"

class DapModuleConsole : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleConsole(QQmlContext *context, QObject *parent);

    Q_INVOKABLE void runCommand(const QString &command);

private slots:
    void getAnswer(const QVariant &answer);

private:
    QQmlContext *s_context;

    QVariantList model;
};

#endif // DAPMODULECONSOLE_H
