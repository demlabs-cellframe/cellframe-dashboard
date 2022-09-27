#ifndef COMMANDCMDCONTROLLER_H
#define COMMANDCMDCONTROLLER_H

#include <QObject>
#include "DapServiceController.h"
#include <QTimer>

class CommandCmdController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool StatusPage MEMBER isOpenPage WRITE setStatus)
    void setStatus(bool status){isOpenPage = status;};

    DapServiceController *dapServiceController;

    QVariantList buffer;
    bool rcvDataBuffer;
    bool isOpenPage;

    QTimer *updateValuesTimer;
public:
    explicit CommandCmdController(QObject *parent = nullptr);

public slots:
    void dapServiceControllerInit(DapServiceController *_dapServiceController);

    int maxLengthText(QVariantList list);
    QVariantList getTreeWords(QString value);

};

#endif // COMMANDCMDCONTROLLER_H
