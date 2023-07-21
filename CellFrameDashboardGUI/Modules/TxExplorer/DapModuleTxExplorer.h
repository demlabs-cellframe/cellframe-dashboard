#ifndef DAPMODULETXEXPLORER_H
#define DAPMODULETXEXPLORER_H

#include <QObject>
#include <QDebug>

#include "../DapModulesController.h"
#include "Models/DapHistoryModel.h"

class DapModuleTxExplorer : public DapAbstractModule
{
    Q_OBJECT

    Q_PROPERTY(bool isLastActions     READ isLastActions   WRITE setLastActions)
    Q_PROPERTY(QString walletName     READ walletName      WRITE setWalletName)
    Q_PROPERTY(QString currentStatus  READ currentStatus   WRITE setCurrentStatus)
    Q_PROPERTY(QString filterString   READ filterString    WRITE setFilterString)
    Q_PROPERTY(QString currentPeriod  READ currentPeriod   WRITE setCurrentPeriod)
    Q_PROPERTY(bool historyMore15     READ historyMore15   NOTIFY historyMore15Changed)
    Q_PROPERTY(int sectionNumber      READ sectionNumber)
    Q_PROPERTY(int elementNumber      READ elementNumber)
public:
    explicit DapModuleTxExplorer(DapModulesController * modulesCtrl);

    bool isLastActions() const
        { return m_isLastActions; }
    QString walletName() const
        { return m_walletName; }
    QString filterString() const
        { return m_filterString; }
    QString currentStatus() const
        { return m_currentStatus; }
    QString currentPeriod() const
        { return m_currentPeriod; }
    bool historyMore15() const
        { return m_historyMore15; }
    int sectionNumber() const
        { return m_sectionNumber; }
    int elementNumber() const
        { return m_elementNumber; }

    Q_INVOKABLE void clearHistory();
    Q_INVOKABLE void updateHistory(bool flag);

private:
    DapModulesController  *m_modulesCtrl;
    QTimer *m_timerHistoryUpdate;
    bool isSendReqeust{false};

signals:
    void updateHistoryModel();
    void historyMore15Changed(bool flag);

private slots:
    void slotHistoryUpdate();

public slots:
    void setHistoryModel(const QVariant &rcvData);

    void setLastActions(bool flag);
    void setWalletName(QString str);
    void setCurrentStatus(QString str);
    void setFilterString(QString str);
    void setCurrentPeriod(QVariant str);

private:
    void sendCurrentHistoryModel();
    void initConnect();

private:
    QQmlContext *context;

    DapHistoryModel fullModel;

    QVariantList model;

    bool m_isLastActions {true};
    QString m_walletName {""};
    QString m_currentStatus {"All statuses"};
    QString m_filterString {""};
    QString m_currentPeriod {"All time"};
    bool m_isRange {false};
    bool m_historyMore15 {false};
    int m_sectionNumber {0};
    int m_elementNumber {0};
};

#endif // DAPMODULETXEXPLORER_H
