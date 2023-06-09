#ifndef DAPMODULELOGS_H
#define DAPMODULELOGS_H

#include <QObject>
#include <QQmlContext>
#include "../DapAbstractModule.h"
#include "logreader.h"
#include "logmodel.h"

class DapModuleLog : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleLog(QQmlContext *context, QObject *parent);

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

private:
    LogModel::Item parseLine(const QString &line);

    void updateModel();

    QQmlContext *s_context;

    LogModel model;

    LogReader nodeLog;
    LogReader guiLog;
    LogReader serviceLog;

    LogReader *currentLog;

    qint64 bufferSize {20};

    qint64 currentIndex {0};
};

#endif // DAPMODULELOGS_H
