#ifndef IMPORTCERTIFICATE_H
#define IMPORTCERTIFICATE_H

#include <QWidget>
#include <QFile>
#include <QDebug>
//#include <QRegExp>

class ImportCertificate : public QWidget
{
    Q_OBJECT
public:
    explicit ImportCertificate(QString pathCert, QWidget *parent = nullptr);

private:
    QString m_pathCert;
    QString m_filePrefix;

public slots:
    void import(QString);

signals:
    void signalImportFinished(QVariant status);
};

#endif // IMPORTCERTIFICATE_H
