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

class NodeInstallManager: public QObject
{
    Q_OBJECT
public:
    explicit NodeInstallManager(bool flag_RK, QObject *parent = nullptr);
    ~NodeInstallManager();

    void checkUpdateNode(QString currentNodeVersion);
    QString getUrlForDownload();

private:
    QNetworkAccessManager * m_networkManager;

    QUrl m_url;
    QString m_latest{"latest"};
    QString m_fileName, m_suffix;


private slots:
    void onGetFileName();

signals:
    void singnalReadyUpdateToNode(bool ready);

};

#endif // NODEINSTALLMANAGER_H
