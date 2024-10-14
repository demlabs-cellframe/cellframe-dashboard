#ifndef DAPMODULETXEXPLORERADDITION_H
#define DAPMODULETXEXPLORERADDITION_H

#include <QObject>
#include <QDebug>

#include "DapModuleTxExplorer.h"

class DapModuleTxExplorerAddition : public DapModuleTxExplorer
{
    Q_OBJECT

    Q_PROPERTY(bool isLastActions     READ isLastActions   WRITE setLastActions)
public:
    explicit DapModuleTxExplorerAddition(DapModulesController * modulesCtrl);

    Q_PROPERTY(bool isRequest     READ isRequest      WRITE isRequestChanged)
    bool isRequest(){return m_isRequest;}
    void setIsRequest(bool isRequest);

    Q_INVOKABLE bool isLastActions() const { return m_isLastActions; }

private:
     bool m_isRequest = false;

signals:
    void historyModelChanged();
    void isRequestChanged(bool isRequest);

public slots:
    void setHistoryModel(const QVariant &rcvData);
    void setWalletName(QString str);
    void setLastActions(bool flag);

private:
    bool m_isLastActions {true};

};

#endif // DAPMODULETXEXPLORERADDITION_H
