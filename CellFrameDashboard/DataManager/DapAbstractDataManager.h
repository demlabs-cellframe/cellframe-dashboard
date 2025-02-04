#pragma once

#include <QObject>

class DapModulesController;
class DapApplication;

class DapAbstractDataManager : public QObject
{
    Q_OBJECT
public:
    explicit DapAbstractDataManager(DapModulesController* moduleController);
protected:
    virtual void initManager();
protected:
    DapModulesController* m_modulesController = nullptr;
};
