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
    Q_INVOKABLE bool statusInit(){return m_statusInit;}

    bool m_statusProcessing{false};
    bool m_statusInit{false};
    QString m_name;

public:
    void setStatusInit(bool status);

    Q_PROPERTY (bool statusProcessing READ statusProcessing WRITE setStatusProcessing NOTIFY statusProcessingChanged)
    bool statusProcessing();
    virtual void setStatusProcessing(bool status);


    //QML
    void setName(QString name);
    QString getName();

protected:
    DapServiceController *s_serviceCtrl;

signals:
    void initDone(const QString &name, bool status);
    void statusInitChanged();
    void statusProcessingChanged();
};

#endif // DAPABSTRACTMODULE_H
