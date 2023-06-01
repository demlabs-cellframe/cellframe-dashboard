#ifndef DAPABSTRACTMODULE_H
#define DAPABSTRACTMODULE_H

#include <QObject>

#include "DapServiceController.h"

class DapAbstractModule : public QObject
{
    Q_OBJECT
public:

    explicit DapAbstractModule(QObject *parent = nullptr);

    Q_PROPERTY(bool statusInit READ statusInit NOTIFY statusInitChanged)
    Q_INVOKABLE bool statusInit(){return m_statusInit;};

    bool m_statusProcessing;
    bool m_statusInit{false};
    QString m_name;
    DapServiceController *s_serviceCtrl;

public:
    void setStatusInit(bool status);

    void setStatusProcessing(bool status);
    bool getStatusProcessing();

    //QML
    void setName(QString name);
    QString getName();

signals:
    void initDone(const QString &name, bool status);
    void statusChanged();
    void statusInitChanged();
};

#endif // DAPABSTRACTMODULE_H
