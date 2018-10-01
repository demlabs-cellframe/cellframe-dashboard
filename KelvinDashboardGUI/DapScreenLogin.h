#ifndef DAPSCREENLOGIN_H
#define DAPSCREENLOGIN_H

#include <QObject>
#include <QDebug>

class DapScreenLogin : public QObject
{
    Q_OBJECT
    
    QString     m_password;
public:
    explicit DapScreenLogin(QObject *parent = nullptr);
    
    Q_PROPERTY(QString Password MEMBER m_password READ getPassword WRITE setPassword NOTIFY passwordChanged)

    QString getPassword() const;
    
    void setPassword(const QString &password);
    
    Q_INVOKABLE bool autorization(const QString& password);
signals:
    
    void passwordChanged(const QString& password);
public slots:
};

#endif // DAPSCREENLOGIN_H
