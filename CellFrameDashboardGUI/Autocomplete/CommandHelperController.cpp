#include "CommandHelperController.h"
#include <QJsonDocument>
#include <QJsonObject>

CommandHelperController::CommandHelperController(QObject *parent)
    : QObject{parent}
    , s_serviceCtrl(&DapServiceController::getInstance())
    , m_helpController(new HelpDictionaryController())

{
    loadDictionary();
    connect(s_serviceCtrl, &DapServiceController::rcvDictionary, [this] (const QVariant& rcvData)
    {
        QJsonDocument data;
        QByteArray byteData = QByteArray::fromHex(rcvData.toByteArray());
        QDataStream streamer(&byteData, QIODevice::ReadOnly);
        streamer >> data;

        //QJsonDocument obj_result = rcvData.toJsonDocument();
        if(!data.isEmpty())
        {
            m_helpController->setDictionary(std::move(data.object()));
        }
        else
        {
            qWarning() << "An unexpected response was received";
        }
    });
}

void CommandHelperController::loadNewDictionary()
{
    s_serviceCtrl->requestToService("DapDictionaryCommand", "getNewDictionary");
}

void CommandHelperController::loadDictionary()
{
    s_serviceCtrl->requestToService("DapDictionaryCommand", "getDictionary");
}

CommandHelperController::~CommandHelperController()
{
    delete m_helpController;
}

QStringList CommandHelperController::getHelpList(const QString& text, int cursorPosition)
{
    return m_helpController->getHelpList(text, cursorPosition);
}

bool CommandHelperController::isDictionary()
{
    return m_helpController->isDictionary();
}
