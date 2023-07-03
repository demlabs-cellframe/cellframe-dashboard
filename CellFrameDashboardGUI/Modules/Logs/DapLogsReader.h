#ifndef DAPLOGSREADER_H
#define DAPLOGSREADER_H

#include <QObject>
#include <QTimer>

class DapLogsReader : public QObject
{
    Q_OBJECT
public:
    explicit DapLogsReader(QObject *parent = nullptr);

// params
public:
    QString m_path;

    void setStatusUpdate(bool status);

private:
    int m_bufferSize{1000};
    QStringList m_logList;
    QTimer *m_timerLogUpdate;

//functions
public:
    QStringList getLogList(){return m_logList;};
    void setLogType(QString path);

private:
    void updateLogList();

signals:
    void sigLogUpdated();
};

#endif // DAPLOGSREADER_H
