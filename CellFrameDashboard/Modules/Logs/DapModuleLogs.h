#ifndef DAPMODULELOGS_H
#define DAPMODULELOGS_H

#include <QObject>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "logreader.h"
#include "logmodel.h"

#include "DapLogsReader.h"

class DapModuleLog : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleLog(DapModulesController *parent);
    ~DapModuleLog();

    enum LogType{
        NodeLog = 0,
        ServiceLog = 1,
        GuiLog = 2
    };

    Q_PROPERTY(int currentType READ currentType NOTIFY currentTypeChanged)
    Q_INVOKABLE int currentType(){return m_configLog.first;};

    Q_PROPERTY(bool flagLogUpdate READ flagLogUpdate WRITE setFlagLogUpdate NOTIFY flagLogUpdateChanged)
    Q_INVOKABLE bool flagLogUpdate();
    Q_INVOKABLE void setFlagLogUpdate(bool flag);

    Q_INVOKABLE void exportLog(QString path, int type, QString period);
//    Q_PROPERTY(qiunt64 posList READ posList WRITE setPosList NOTIFY posListChanged)
//    Q_INVOKABLE quint64 posList(){return currentPos;};
//    Q_INVOKABLE quint64 setPosList(quint64 pos){currentPos = pos;};

    Q_INVOKABLE void fullUpdate();

    Q_INVOKABLE void selectLog(const QString &name);

    Q_INVOKABLE void setPosition(double pos);

    Q_INVOKABLE void changePosition(double step);

    Q_INVOKABLE double getPosition();

    Q_INVOKABLE double getScrollSize();

    Q_INVOKABLE QString getLineText(qint64 index);

    Q_INVOKABLE void updateLog();

    static QString getNodeLogPath();

    static QString getBrandLogPath();

    QString getLogPath(LogType type);

signals:
    void currentTypeChanged();
    void flagLogUpdateChanged();
    void logsExported(bool status);

private slots:
    void checkLogFiles();
private:
    void updateModel();
    void readLog();

    QString getLogFileName(QString folder, LogType type);

private:
    DapLogsReader * m_logReader;
    QTimer *m_timerCheckLogFile = nullptr;

    bool m_flagLogUpdate{true};

    LogModel::Item parseLine(const QString &line);

    LogModel model;

//    LogReader nodeLog;
//    LogReader guiLog;
//    LogReader serviceLog;

//    LogReader *currentLog;

    qint64 bufferSize {1000};

    qint64 currentIndex {0};

    QPair<LogType, QString> m_configLog;

//    quint64 currentPos{0};

    QString m_lastPath;

    const int TIMEOUT_CHECK_FILE = 30000;
};

#endif // DAPMODULELOGS_H
