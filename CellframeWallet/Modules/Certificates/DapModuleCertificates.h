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
    enum Commands{                         //maybe need class
        UnknownCommand = 0,                //return by default and in error case
        GetSertificateList,
        CreateCertificate,
        DumpCertifiacate,                  //получение информации о сертификате
        ImportCertificate,
        ExportPublicCertificateToFile,
        ExportPublicCertificateToMempool,
        AddSignatureToCertificate,      //WARNING нереализовано
        DeleteCertificate,
        UpdateCertificateList,           //уведомление только если изменяется папка сертификатов вручную
        PkeyShow,
        MoveCertificate
    };
    Q_ENUM(Commands);

    explicit DapModuleCertificates(DapModulesController *parent);
    Q_INVOKABLE void import(QString);

    Q_INVOKABLE void requestCommand(const QVariantMap& request);
private:
    QString m_pathCert;
    QString m_filePrefix;

//public slots:

signals:
    void signalImportFinished(QVariant status);
};

#endif // DAPMODULECERTIFICATES_H
