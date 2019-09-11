#include "DapUiQmlWidgetConsole.h"

DapUiQmlWidgetConsole::DapUiQmlWidgetConsole(QObject *parent) : QObject(parent)
{

}

DapUiQmlWidgetConsole& DapUiQmlWidgetConsole::getInstance()
{
    static DapUiQmlWidgetConsole instance;
    return instance;
}

void DapUiQmlWidgetConsole::receiveResponse(const QString& aResponse)
{
    emit sendResponse(aResponse);
}

QString DapUiQmlWidgetConsole::getCommandUp() const
{
    if(m_CommandIterator -1 != m_CommandList.begin()) return QString::fromStdString(m_CommandIterator->toStdString());
    return QString::fromStdString(m_CommandIterator->toStdString());
}

QString DapUiQmlWidgetConsole::getCommandDown() const
{
    return QString();
}

void DapUiQmlWidgetConsole::receiveRequest(const QString& aCommand)
{
    m_CommandList.append(aCommand);
    m_CommandIterator = m_CommandList.end();
    emit sendResponse(aCommand);
}
