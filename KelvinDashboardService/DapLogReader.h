#ifndef DAPLOGREADER_H
#define DAPLOGREADER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <QDebug>

class DapLogReader : public QObject
{
    Q_OBJECT
protected:
    virtual QStringList parse(const QByteArray& aLogMessages);
public:
    explicit DapLogReader(QObject *parent = nullptr);

signals:

public slots:

    QStringList request(int aiTimeStamp, int aiRowCount);
};

#endif // DAPLOGREADER_H
