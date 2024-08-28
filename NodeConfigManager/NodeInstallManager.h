#ifndef NODEINSTALLMANAGER_H
#define NODEINSTALLMANAGER_H

#include <QObject>
#include <QDebug>
#include <QTextCodec>
#include <QFile>
#include <QRegularExpression>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTimer>
#include <QFileInfo>
#include <QSysInfo>

class NodeInstallManager: public QObject
{
    Q_OBJECT
public:
    explicit NodeInstallManager(bool flag_RK, QObject *parent = nullptr);
    ~NodeInstallManager();

    void checkUpdateNode(const QString &link);
    QString getUrlForDownload();
    QString getUrl(const QString& ver);

private slots:
    void onGetFileName(QNetworkReply *reply);

signals:
    void singnalReadyUpdateToNode(bool ready);
private:
    QNetworkAccessManager * m_networkManager;

    QUrl m_url;
    QString m_baseUrl;
    QString m_labelUrlFile;

    //#ifdef __x86_64__
    //    QString m_latest{"latest-amd64"};
    //#else
    //    QString m_latest{"latest-arm64"};
    //#endif

    QString m_fileName, m_suffix;
};

#endif // NODEINSTALLMANAGER_H
