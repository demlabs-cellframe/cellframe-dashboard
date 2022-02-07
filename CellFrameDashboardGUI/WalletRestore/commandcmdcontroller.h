#ifndef COMMANDCMDCONTROLLER_H
#define COMMANDCMDCONTROLLER_H

#include <QObject>
#include "DapServiceController.h"

class CommandCmdController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(DapServiceController *dapServiceController MEMBER dapServiceController)

    DapServiceController *dapServiceController;
public:
    explicit CommandCmdController(QObject *parent = nullptr);

public slots:
    void dapServiceControllerInit(DapServiceController *_dapServiceController);
    void parseAllCommands(const QVariant& asAnswer);

signals:

};

#endif // COMMANDCMDCONTROLLER_H
