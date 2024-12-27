#ifndef DAPLOGSREADER_H
#define DAPLOGSREADER_H

#include <QObject>
#include <QTimer>

class DapLogsReader : public QObject
{
    Q_OBJECT
public:
    explicit DapLogsReader(QObject *parent = nullptr);

    QString getPath() const {return m_path;}
    void setPath(const QString& path){m_path = path;}

    void setStatusUpdate(bool status);

private:
    QString m_path;
    int m_bufferSize{1000};
    QStringList m_logList;
    QTimer *m_timerLogUpdate;

//functions
public:
    QStringList getLogList(){return m_logList;}
    void setLogType(QString path);

private:
    void updateLogList();

signals:
    void sigLogUpdated();
};

#endif // DAPLOGSREADER_H
