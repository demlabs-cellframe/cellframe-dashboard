#include "DapModuleCertificates.h"

DapModuleCertificates::DapModuleCertificates(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_pathCert(CellframeNodeConfig::instance()->getDefaultCADir() + "/")
{

#if !defined(Q_OS_WIN)
    m_filePrefix = "file://";
#else
    m_filePrefix = "file:///";
#endif

}

void DapModuleCertificates::import(QString path)
{
    QString name = path.split("/").last();
    path.remove(m_filePrefix);
    QVariant status = QFile::copy(path,m_pathCert+name);
    emit signalImportFinished(status);
}
