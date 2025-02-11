#ifndef DAPMODULETOKENS_H
#define DAPMODULETOKENS_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"


class DapModuleTokens : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleTokens(DapModulesController *parent = nullptr);

private:
};

#endif // DAPMODULETOKENS_H
