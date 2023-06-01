#ifndef DAPMODULETEST_H
#define DAPMODULETEST_H

#include <QObject>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleTest : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleTest(DapModulesController *parent);

    void test();

private:
    DapModulesController* modules;
};

#endif // DAPMODULETEST_H
