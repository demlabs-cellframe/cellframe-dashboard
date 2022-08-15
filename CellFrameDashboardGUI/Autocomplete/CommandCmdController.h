#ifndef COMMANDCMDCONTROLLER_H
#define COMMANDCMDCONTROLLER_H

#include <QObject>
#include "DapServiceController.h"
#include <QTimer>

class CommandCmdController : public QObject
{
    Q_OBJECT

    DapServiceController *dapServiceController;

    QVariantList buffer;
    bool rcvDataBuffer;

    QTimer *updateValuesTimer;
public:
    explicit CommandCmdController(QObject *parent = nullptr);

public slots:
    void dapServiceControllerInit(DapServiceController *_dapServiceController);
    QVariantList getTreeWords(QString value);

};

#endif // COMMANDCMDCONTROLLER_H
