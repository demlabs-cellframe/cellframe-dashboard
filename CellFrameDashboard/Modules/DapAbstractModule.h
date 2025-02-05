#ifndef DAPABSTRACTMODULE_H
#define DAPABSTRACTMODULE_H

#include <QObject>

#include "DapServiceController.h"
#include "node_globals/NodeGlobals.h"

class DapModulesController;

class DapAbstractModule : public QObject
{
    Q_OBJECT
public:

    explicit DapAbstractModule(DapModulesController *parent);
    ~DapAbstractModule();
    Q_PROPERTY(bool statusInit READ statusInit NOTIFY statusInitChanged)
    Q_INVOKABLE bool statusInit(){return m_statusInit;}
    void setStatusInit(bool status);

    Q_PROPERTY (bool statusProcessing READ statusProcessing WRITE setStatusProcessing NOTIFY statusProcessingChanged)
    bool statusProcessing();
    virtual void setStatusProcessing(bool status);

    //QML
    void setName(QString name);
    QString getName();


    QByteArray convertJsonResult(const QByteArray &data);
protected:
    DapServiceController *s_serviceCtrl = nullptr;
    DapModulesController  *m_modulesCtrl = nullptr;
signals:
    void initDone(const QString &name, bool status);
    void statusInitChanged();
    void statusProcessingChanged();

private slots:
    virtual void slotUpdateData(){}

public:
    bool m_statusProcessing{false};
    bool m_statusInit{false};
    QString m_name;
};

#endif // DAPABSTRACTMODULE_H
