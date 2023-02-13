#ifndef HISTORYWORKER_H
#define HISTORYWORKER_H

#include <QObject>
#include <QVector>
#include <QQmlContext>

#include "historymodel.h"

class HistoryWorker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isLastActions READ isLastActions WRITE setLastActions)
    Q_PROPERTY(QString walletName READ walletName WRITE setWalletName)
    Q_PROPERTY(QString currentStatus READ currentStatus WRITE setCurrentStatus)
    Q_PROPERTY(QString currentPeriod READ currentPeriod WRITE setCurrentPeriod)
    Q_PROPERTY(bool historyMore15 READ historyMore15 NOTIFY historyMore15Changed)
    Q_PROPERTY(int sectionNumber READ sectionNumber)
    Q_PROPERTY(int elementNumber READ elementNumber)

public:
    explicit HistoryWorker(QQmlContext *cont, QObject *parent = nullptr);

    bool isLastActions() const
        { return m_isLastActions; }
    QString walletName() const
        { return m_walletName; }
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

signals:
    void updateHistoryModel();

    void historyMore15Changed(bool flag);

public slots:
    void setHistoryModel(const QVariant &rcvData);

    void setLastActions(bool flag);
    void setWalletName(QString str);
    void setCurrentStatus(QString str);
    void setCurrentPeriod(QString str);

private:
    void sendCurrentHistoryModel();

private:
    QQmlContext *context;

    HistoryModel fullModel;

    QVariantList model;

    bool m_isLastActions {true};
    QString m_walletName {""};
    QString m_currentStatus {"All statuses"};
    QString m_currentPeriod {"All time"};
    bool m_historyMore15 {false};
    int m_sectionNumber {0};
    int m_elementNumber {0};
};


#endif // HISTORYWORKER_H
