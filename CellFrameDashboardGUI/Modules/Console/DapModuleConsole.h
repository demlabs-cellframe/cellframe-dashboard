#ifndef DAPMODULECONSOLE_H
#define DAPMODULECONSOLE_H

#include <QObject>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleConsole : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleConsole(DapModulesController *parent);

    Q_INVOKABLE void runCommand(const QString &command);
    Q_INVOKABLE void clearModel();

private slots:
    void getAnswer(const QVariant &answer);

private:
    DapModulesController* m_modulesCtrl;

    QVariantList model;
};

#endif // DAPMODULECONSOLE_H
