#pragma once

#include <QObject>

class DapModulesController;

class DapAbstractDataManager : public QObject
{
    Q_OBJECT
public:
    explicit DapAbstractDataManager(DapModulesController* moduleController);

protected:
    DapModulesController* m_modulesController = nullptr;
};
