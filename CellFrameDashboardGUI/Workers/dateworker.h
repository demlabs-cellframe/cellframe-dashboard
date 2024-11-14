#ifndef DATEWORKER_H
#define DATEWORKER_H

#include <QObject>
#include <QDateTime>
#include <QDate>

class DateWorker : public QObject
{
    Q_OBJECT
public:
    explicit DateWorker(QObject *parent = nullptr);

    Q_INVOKABLE QString getCurrentDate(QString format);
    Q_INVOKABLE QString getDate(const QString &date, QString format);
    Q_INVOKABLE QString getDateString(const QString &date);

signals:

};

#endif // DATEWORKER_H
