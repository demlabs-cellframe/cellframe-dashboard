#ifndef DAPUPDATEVERSIONCONTROLLER_H
#define DAPUPDATEVERSIONCONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QRegExp>
#include <QtDebug>
#include <QTextCodec>
#include <QStringList>
#include <QFile>
#include <QProcess>

class DapUpdateVersionController : public QObject
{
    Q_OBJECT
public:
    explicit DapUpdateVersionController(QObject *parent = nullptr);

    void checkUpdate();
    void downloadPack();
    void installPack();

public:
    bool s_hasUpdate;

private:
    QString s_urlPath;
    QString s_suffix;
    QVariant s_lastVersion;
    QNetworkAccessManager* s_netManager;
    QFile* m_file;
    QFile* m_installScript;

private:
    bool compareVersion();
    void createInstallScript();

private slots:
    void rcvVersion();
    void downloadFinish();


};

#endif // DAPUPDATEVERSIONCONTROLLER_H
