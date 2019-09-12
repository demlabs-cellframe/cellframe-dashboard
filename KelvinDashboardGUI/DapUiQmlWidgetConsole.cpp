#include "DapUiQmlWidgetConsole.h"

DapUiQmlWidgetConsoleModel::DapUiQmlWidgetConsoleModel(QObject *parent) : QObject(parent)
{

}

DapUiQmlWidgetConsoleModel& DapUiQmlWidgetConsoleModel::getInstance()
{
    static DapUiQmlWidgetConsoleModel instance;
    return instance;
}

void DapUiQmlWidgetConsoleModel::receiveResponse(const QString& aResponse)
{
    emit sendResponse(aResponse);
}

QString DapUiQmlWidgetConsoleModel::getCommandUp()
{
    if(m_CommandList.isEmpty()) return QString();
    if(m_CommandIndex > m_CommandList.begin()) m_CommandIndex--;
    return *m_CommandIndex;
}

QString DapUiQmlWidgetConsoleModel::getCommandDown()
{
    if(m_CommandList.isEmpty()) return QString();
    if(m_CommandIndex < m_CommandList.end() -1) m_CommandIndex++;
    else return QString();
    return *m_CommandIndex;
}

void DapUiQmlWidgetConsoleModel::receiveRequest(const QString& aCommand)
{
    m_CommandList.append(aCommand);
    m_CommandIndex = m_CommandList.end();
    emit sendRequest(aCommand);
}
