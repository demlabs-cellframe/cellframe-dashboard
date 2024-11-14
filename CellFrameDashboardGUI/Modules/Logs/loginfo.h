#ifndef LOGINFO_H
#define LOGINFO_H

#include <QGuiApplication>

struct LogInfo
{
    Q_GADGET
    Q_PROPERTY(QString type MEMBER type)
    Q_PROPERTY(QString info MEMBER info)
    Q_PROPERTY(QString file MEMBER file)
    Q_PROPERTY(QString time MEMBER time)
    Q_PROPERTY(QString date MEMBER date)
    Q_PROPERTY(QString momentTime MEMBER momentTime)

public:
    QString type;
    QString info;
    QString file;
    QString time;
    QString date;
    QString momentTime;

    LogInfo(const QString &type = "",
         const QString &info = "",
         const QString &file = "",
         const QString &time = "",
         const QString &date = "",
         const QString &momentTime = "")
    {
        this->type = type;
        this->info = info;
        this->file = file;
        this->time = time;
        this->date = date;
        this->momentTime = momentTime;
    }
};
Q_DECLARE_METATYPE(LogInfo)

#endif // LOGINFO_H
