#include "dateworker.h"
#include "qdebug.h"
#include <QTimeZone>

static QString m_defaultFormat = "yyyy-MM-dd";

DateWorker::DateWorker(QObject *parent)
    : QObject{parent}
{
//    QString test;
//    test = getCurrentDate("");
//    test = getCurrentDate("yyyy:MM:dd");
//    test = getCurrentDate("yyyy:MM:dd_hh-mm");

//    test = getDateString("2023-06-02");
//    test = getDateString("2023-06-01");
//    test = getDateString("2023-05-31");
//    test = getDateString("2022-01-01");
//    test = getDateString("2008-03-22");

//    qDebug()<<"";
}

QString DateWorker::getCurrentDate(QString format)
{
    if(format.isEmpty())
        format = m_defaultFormat;

    return QDateTime::currentDateTime().toString(format);
}

QString DateWorker::getDate(const QString &date, QString format)
{
    QLocale locale(QLocale("en_US"));
    return locale.toString(QDateTime::fromString(date, m_defaultFormat), format);
}

QString DateWorker::getDateString(const QString &dateString)
{
    QDate today = QDate::currentDate();
    QDate date(QDateTime::fromString(dateString, m_defaultFormat).date());
    qint32 difference = today.daysTo(date);

    QString result;
    switch(difference)
    {
    case -1:
         result = QString("Yesterday");
         break;
    case 0:
         result = QString("Today");
         break;
    default:
         result = getDate(dateString, "MMMM, d, yyyy");
        break;
    };

    return result;
}

