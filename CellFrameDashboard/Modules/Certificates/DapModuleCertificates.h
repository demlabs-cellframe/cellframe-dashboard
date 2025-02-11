#ifndef DAPMODULECERTIFICATES_H
#define DAPMODULECERTIFICATES_H

#include <QObject>
#include <QWidget>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleCertificates : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleCertificates(DapModulesController *parent);
    Q_INVOKABLE void import(QString);


private:
    QString m_pathCert;
    QString m_filePrefix;

//public slots:

signals:
    void signalImportFinished(QVariant status);
};

#endif // DAPMODULECERTIFICATES_H
