#include "DapPluginsController.h"

DapPluginsController::DapPluginsController(QString pathPluginsConfigFile, QObject *parent) : QObject(parent)
{
    m_pathPluginsConfigFile = pathPluginsConfigFile;

    readPluginsFile(&m_pathPluginsConfigFile);
}

void DapPluginsController::readPluginsFile(QString *path)
{

}

//void DapPluginsController::getListPlugins()
//{
//    QStringList str;

//}
