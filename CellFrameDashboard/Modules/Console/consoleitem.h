#ifndef CONSOLEITEM_H
#define CONSOLEITEM_H

#include <QGuiApplication>

struct ConsoleInfo
{
    Q_GADGET
    Q_PROPERTY(QString query MEMBER query)
    Q_PROPERTY(QString response MEMBER response)

public:
    QString query;
    QString response;

    ConsoleInfo(const QString &query = "",
         const QString &response = "")
    {
        this->query = query;
        this->response = response;
    }
};
Q_DECLARE_METATYPE(ConsoleInfo)

#endif // CONSOLEITEM_H
