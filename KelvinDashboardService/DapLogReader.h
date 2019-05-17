#ifndef DAPLOGREADER_H
#define DAPLOGREADER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <QDebug>

class DapLogReader : public QObject
{
    Q_OBJECT

public:
    explicit DapLogReader(QObject *parent = nullptr);

signals:

public slots:

    QList<QString> request(int aiTimeStamp, int aiRowCount);
};

#endif // DAPLOGREADER_H
