#include "CommandHelperController.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <DapApplication.h>

CommandHelperController::CommandHelperController(DapServiceController* serviceController, DapApplication *parent)
    : QObject{}
    , s_serviceCtrl(serviceController)
    , m_helpController(new HelpDictionaryController())
    , m_appManager(parent)
{
    loadDictionary();
    loadData();

    connect(s_serviceCtrl, &DapServiceController::rcvDictionary, [this] (const QVariant& rcvData)
            {
                QJsonDocument data;
                QByteArray byteData = QByteArray::fromHex(rcvData.toByteArray());
                QDataStream streamer(&byteData, QIODevice::ReadOnly);
                streamer >> data;

                if(!data.isEmpty())
                {
                    QJsonObject mainObject = data.object();
                    if(mainObject.contains("head") && mainObject.contains("data"))
                    {
                        if(mainObject["head"] == "dictionary")
                        {
                            QString version = mainObject["version"].toString();
                            if(version != m_helpController->getNodeVersion())
                            {
                                m_helpController->setNodeVersion(version);
                                m_helpController->setDictionary(std::move(mainObject["data"].toObject()));
                            }
                        }
                        else if(mainObject["head"] == "data")
                        {
                            m_helpController->setData(std::move(mainObject["data"].toObject()));
                        }
                        else
                        {
                            qWarning() << "The structure of the response from the service has changed, it is not possible to load the dictionary";
                        }
                    }
                }
                else
                {
                    qWarning() << "An unexpected response was received";
                }
            });
}

void CommandHelperController::tryListGetting(const QString& text, int cursorPosition)
{
    emit helpListGeted(m_helpController->getHelpList(text, cursorPosition));
}

void CommandHelperController::loadNewDictionary()
{
    m_appManager->requestToService("DapDictionaryCommand", "getNewDictionary");
}

void CommandHelperController::loadDictionary()
{
    m_appManager->requestToService("DapDictionaryCommand", "getDictionary");
}

void CommandHelperController::loadData()
{
    m_appManager->requestToService("DapDictionaryCommand", "getData");
}

// void CommandHelperController::tryDataUpdate()
// {
//     s_serviceCtrl->requestToService("DapDictionaryCommand", "updateData");
// }

CommandHelperController::~CommandHelperController()
{
    delete m_helpController;
}

bool CommandHelperController::isDictionary()
{
    return m_helpController->isDictionary();
}
