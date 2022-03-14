#include "ImportCertificate.h"

ImportCertificate::ImportCertificate(QString pathCert, QWidget *parent) : QWidget(parent)
{
#if !defined(Q_OS_WIN)
    m_filePrefix = "file://";
#else
    m_filePrefix = "file:///";
#endif

    m_pathCert = pathCert + "/";
}

void ImportCertificate::import(QString path)
{
    QString name = path.split("/").last();
    path.remove(m_filePrefix);
    QVariant status = QFile::copy(path,m_pathCert+name);
    emit signalImportFinished(status);
}
