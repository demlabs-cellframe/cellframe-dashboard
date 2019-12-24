#include "ChainTable.h"
using namespace cellframe;

ChainTable::ChainTable(QQmlApplicationEngine *proc,QObject *parent ):
    QObject(parent),mainProc(proc)/*,_cellFramePlugin("/home/kostya/MyProject/demlabs/dapwms-dev/ChainPlugin.zip",
                                                    "/home/kostya/MyProject/demlabs/")*/,_model(),_settingModel()
{
    _cellFramePlugin = new LoadPlugin("/home/kostya/MyProject/demlabs/dapwms-dev/ChainPlugin.zip",
                                      "/home/kostya/MyProject/demlabs/");
//_cellFramePlugin = new LoadPlugin()
//    LoadPlugin cellFramePlugin("/home/kostya/MyProject/demlabs/dapwms-dev/ChainPlugin.zip",
//                                                "/home/kostya/MyProject/demlabs/");

//    _cellFramePlugin.setFileOrDirectory("/home/kostya/MyProject/demlabs/dapwms-dev/ChainPlugin.zip",
//                                                 "/home/kostya/MyProject/demlabs/");

    _pluginFolder = _cellFramePlugin->getPathPlugin();//"/home/kostya/MyProject/demlabs/dapwms-dev/ChainPlugin/";

    qDebug() << "[ChainTable] Plugin is located: " << _pluginFolder;

    _loadConfigFile();

    _generateNetwork();
    mainProc->rootContext()->setContextProperty("SettingModel",&this->_settingModel);

    mainProc->rootContext()->setContextProperty("TableModel",&this->_model);

    //mainProc->load(getPathQml("tableWidget"));

}

//ChainTable::ChainTable(QQmlApplicationEngine *proc,QString *fileName,QObject *parent): QObject(parent)
//{

//}
ChainTable::~ChainTable()
{
    qDebug()<<"ChainTable distruct";
    delete mainProc;
    delete _cellFramePlugin;

}

void ChainTable::showTable(){
    mainProc->load(getPathQml("TableWidget"));
}

//get content JSON file "config" _pluginFolder+config
void ChainTable::_loadConfigFile()
{
    QFile loadSettingsFile(_pluginFolder+"config");
    if(!loadSettingsFile.open(QIODevice::ReadOnly))
    {
        qWarning("[ChainTable] Not open file config.");
        return;
    }

    QByteArray loadDateJSON = loadSettingsFile.readAll();
    QJsonDocument loadDoc = QJsonDocument::fromJson(loadDateJSON);
    QJsonObject settingsFromConfig = loadDoc.object();

    loadSettingsFile.close();

    _namePlugin     = settingsFromConfig.find("plugin_name").value().toString();
    _aboutPlugin    = settingsFromConfig.find("about_plugin").value().toString();
    _networkList    = settingsFromConfig.find("network_list")->toObject().toVariantMap();
    _qmlWidjetList  = settingsFromConfig.find("widget_list")->toObject().toVariantMap();
    _eventList      = settingsFromConfig.find("event_list")->toObject().toVariantMap();

    qDebug()<<"[ChainTable] Config loaded";
}

QString ChainTable::getPathQml(QString nameWidget)
{
 return _pluginFolder+_qmlWidjetList.find(nameWidget).value().toString();
}

void ChainTable::setHeadTable(int column,QStringList *list,QList<int> *width)
{
    _model.setNumberColumn(column);
///first column
    _model.setPropertyHeadList(" "," ",50);

    for(int columnNumber(0);columnNumber<column;columnNumber++)
    {
         QString tmpRole;
         QString tmpTitle;
         int tmpWidth;

         if(columnNumber<26)
         {
             tmpRole = QChar(65+columnNumber);
         }
         else
         {
              int factor = static_cast<int>(columnNumber/26);
              tmpRole = QChar(65+columnNumber-factor*26)+QString("%1").arg(factor);
         }

         if(width!=nullptr)
         {
             tmpWidth = width->at(columnNumber);
         }
         else tmpWidth = WIDTH_COLUMN;

         if(list!=nullptr)
            tmpTitle=list->at(columnNumber);
         else
            tmpTitle=tmpRole;

            _model.setPropertyHeadList(tmpRole,tmpTitle,tmpWidth);
    }
}

///Fills a table with data row by row based on another table by structure StructTable
void ChainTable::setDataTable(QList<StructTable> *fullTable)
{
    if(fullTable!=nullptr)
    {
        if(fullTable->count()>0)
            for(int count(0);count<fullTable->count();count++)
            {
                _model.setRowToTable(fullTable->at(count));
            }
    }
}

//==============================Временные генераторы

void ChainTable::_generateNetwork()
{
    structNetwork tmpStr;
    for(int i(0);i<6;i++)
         {
        tmpStr.rows[0] = QString("name%1").arg(i);
        for(int o(1);o<6;o++)
        {
            tmpStr.rows[o]=qrand()%256;
        }
        _settingModel.insertOneRowInList(tmpStr);

    }
}
//=====================================

void ChainTable::messageThis()
{
    qDebug()<<"SLOT Destroid";
}
