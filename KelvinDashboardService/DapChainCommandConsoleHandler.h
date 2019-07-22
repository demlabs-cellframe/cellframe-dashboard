#pragma once
#include <QObject>

class DapChainCommandConsoleHandler : public QObject
{
    Q_OBJECT

public:
    explicit DapChainCommandConsoleHandler(QObject *parent = nullptr);

public slots:
    QString executeCommand(const QString& command);

};


