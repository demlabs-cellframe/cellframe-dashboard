#ifndef DAPMODULETXEXPLORERADDITION_H
#define DAPMODULETXEXPLORERADDITION_H

#include <QObject>
#include <QDebug>

#include "DapModuleTxExplorer.h"

class DapModuleTxExplorerAddition : public DapModuleTxExplorer
{
    Q_OBJECT


public:
    explicit DapModuleTxExplorerAddition(DapModulesController * modulesCtrl);
    //~DapModuleTxExplorerAddition();

    // Q_PROPERTY(bool isRequest     READ isRequest      WRITE isRequestChanged)
    // bool isRequest(){return m_isRequest;}
    // void setIsRequest(bool isRequest);

    // Q_INVOKABLE void typeScreenChange(const QString &screen);

private:
    // bool m_isRequest = false;

signals:
    // void historyModelChanged();
    // void isRequestChanged(bool isRequest);

private slots:


public slots:

private:


};

#endif // DAPMODULETXEXPLORERADDITION_H
