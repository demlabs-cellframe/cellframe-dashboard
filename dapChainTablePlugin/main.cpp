#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "ChainTable.h"
#include "TableModel.h"


//QList<StructTable> *generateContentTable()
//{

//    QList<StructTable> *tmp = new QList<StructTable>();
//for (int i(0);i<100;i++)
//{
//    StructTable tmpRow;
//    tmpRow.setNewItem(QString("name%1").arg(i));
//    tmpRow.setNewItem(rand()*121);
//    tmpRow.setNewItem(QString("hash%1hhs%2asldj%3").arg(rand()*3).arg(rand()+15).arg(i));
//    tmpRow.setNewItem(QString("SomeTh"));
//    tmpRow.setNewItem(QString("jejfqwej"));
//    tmp->push_back(tmpRow);
//}
//return tmp;
//}

QList<cellframe::StructTable> *generateContentNewTable(int column)
{

    QList<cellframe::StructTable> *tmp = new QList<cellframe::StructTable>();

for (int countRow=0;countRow<15;countRow++)
{
    cellframe::StructTable tmpRow;
    for(int countColumn = 0;countColumn<column;countColumn++)
    {
        tmpRow.newColumn();

        for (int i(0);i<5/*qrand()*10*/;i++)
        {
            cellframe::StructItem tmpItem;
            tmpItem.creator = QString("name%1").arg(i);
            tmpItem.hashItem = QString("hash%1hhs%2asldj%3").arg(rand()*3).arg(rand()+15).arg(i);
            tmpItem.investor = QString("nameInv%1").arg(i);
            tmpItem.valueItem = qrand()*125125125;
            tmpRow.insertItem(countColumn,tmpItem);
        }
    }
    tmp->push_back(tmpRow);
}
return tmp;
}


int main(int argc, char *argv[])
{
   // JlCompress::extractDir("/home/kostya/Downloads/zlib1211.zip","/home/kostya/Downloads/ups");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
//    qDebug()<<QChar(66);

    QList<cellframe::StructTable> tableChain;
   // generateTable(tableChain);
    //qmlRegisterType<TableModel>("TableModel", 0, 1, "TableModel");
    QQmlApplicationEngine engine;
    cellframe::ChainTable *table = new cellframe::ChainTable(&engine);

int column=15;
table->setHeadTable(column);
table->setDataTable(generateContentNewTable(column));

    //const QUrl url(table->getPathQml("tableWidget"));
//    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
//                     &app, [url](QObject *obj, const QUrl &objUrl) {
//        if (!obj && url == objUrl)
//            QCoreApplication::exit(-1);
//    }, Qt::QueuedConnection);

    //TransitCtoQml factory;
    //factory.setMaps();
    //engine.load(url);

    //engine.rootContext()->setContextProperty("TableModel", &table->model);
    table->showTable();

    return app.exec();
}
