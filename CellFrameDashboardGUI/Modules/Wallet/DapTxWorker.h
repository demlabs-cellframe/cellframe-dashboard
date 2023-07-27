#ifndef DAPTXWORKER_H
#define DAPTXWORKER_H

#include <QObject>

class DapTxWorker : public QObject
{
    Q_OBJECT
public:
    explicit DapTxWorker(QObject *parent = nullptr);


    void getFee(QString net);
//    void

signals:

};

#endif // DAPTXWORKER_H
