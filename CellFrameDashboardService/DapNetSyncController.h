#ifndef DAPNETSYNCCONTROLLER_H
#define DAPNETSYNCCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QVariant>
#include <QDebug>
#include <QStringList>
#include <QProcess>

class DapNetSyncController : public QObject
{
    Q_OBJECT
public:
    explicit DapNetSyncController(QObject *parent = nullptr);


private:
    QTimer* m_timerSync;

private:
    QStringList getNetworkList();
    void goSyncNet(QString net);

private slots:
    void updateTick();

signals:

};

#endif // DAPNETSYNCCONTROLLER_H
