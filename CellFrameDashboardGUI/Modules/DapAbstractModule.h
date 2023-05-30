#ifndef DAPABSTRACTMODULE_H
#define DAPABSTRACTMODULE_H

#include <QObject>

#include "DapServiceController.h"

class DapAbstractModule : public QObject
{
    Q_OBJECT
public:

    explicit DapAbstractModule(QObject *parent = nullptr);

    void setStatusProcessing(bool status);
    bool getStatusProcessing();

    void setName(QString name);
    QString getName();

    bool m_statusProcessing;
    QString m_name;
    DapServiceController *s_serviceCtrl;

signals:
    void initDone(const QString &name, bool status);
};

#endif // DAPABSTRACTMODULE_H
