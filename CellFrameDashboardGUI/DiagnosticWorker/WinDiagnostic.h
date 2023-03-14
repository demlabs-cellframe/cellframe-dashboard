#ifndef WINDIAGNOSTIC_H
#define WINDIAGNOSTIC_H


#include <QObject>
#include <QDebug>
#include <QTimer>
#include <QDesktopServices>
#include <QUrl>
#include <QFileInfo>
#include <QProcess>
#include <QString>
#include <QRegularExpression>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDir>
#include <QNetworkInterface>

class WinDiagnostic: public QObject
{
    Q_OBJECT
public:
    explicit WinDiagnostic(QObject * parent = nullptr);
    ~WinDiagnostic();

private:
    QTimer * s_timer_update;
    int s_timeout{1000};

private slots:
    void info_update();

signals:
    void data_updated(QJsonDocument);

public:
    QString get_uptime_string(int sec);

public:
    void start_diagnostic();
    void stop_diagnostic();
    void set_timeout(int timeout);
};

#endif // WINDIAGNOSTIC_H
