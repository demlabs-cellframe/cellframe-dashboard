#include "DapScreenLogin.h"

DapScreenLogin::DapScreenLogin(QObject *parent) : QObject(parent)
{
    connect(this, &DapScreenLogin::passwordChanged, this, &DapScreenLogin::autorization);
}

QString DapScreenLogin::getPassword() const
{
    return m_password;
}

void DapScreenLogin::setPassword(const QString &password)
{
    qDebug() << "Set password: " << password << endl;
    m_password = password;
}

bool DapScreenLogin::autorization(const QString &password)
{
    
}
