#ifndef STRUCTCONTENT_H
#define STRUCTCONTENT_H

#include <QDebug>
#include <QString>
#include <QVariant>

namespace cellframe {

struct StructItem{
    QVariant valueItem;
    QVariant hashItem;
    QVariant creator;
    QVariant investor;
};

struct headTable
{
    QString role;
    QString title;
    int width;
};

struct StructTable
{
//    QList<QVariant> role;
     QList<QList<StructItem>> roleForTable;

//     QVariant& getCreator(int column)
//     {
//         return roleForTable[column][0].creator;
//     }

     QVariant& getHash(int column)
     {
         return roleForTable[column][0].hashItem;
     }

//     QVariant& getInvestor(int column)
//     {
//         return roleForTable[column][0].investor;
//     }

    int getCount(){
        //qDebug()<<"[StructTable] getCount";
        return roleForTable.count();
    }

    void newColumn(){
        QList<StructItem> tmp;
        roleForTable.push_back(tmp);
        tmp.~QList();
    }

    ///Returns the value for the table (last result)
    QVariant getMainValueCell(int role)
    {
        if(role<getCount())
        {
            StructItem tmpStruct = roleForTable[role][0];
            return tmpStruct.valueItem;
        }
        else qDebug()<<"[StructTable] invalid value for main cell";
        return false;
    }

    void setItem(int num,StructItem data){
        if (num<getCount())
        {
            roleForTable[num].push_back(data);
        }
        else qDebug()<<"[StructTable] invalid value";
    }

    bool editValue(int num,StructItem newValue)
    {
         //qDebug()<<"[StructTable] edit";
         if(num<getCount())
              {
             if(newValue.valueItem != roleForTable[num][0].valueItem && newValue.hashItem != roleForTable[num][0].hashItem)
             {
                 roleForTable[num][0] = newValue;
                 qDebug()<<"[StructTable] Cell edited";
                 return true;
             }
            }else qDebug()<<"[StructTable] invalid value for edit";
        return false;
    }

    void insertItem(int num,StructItem newItem)
    {
            roleForTable[num].push_front(newItem);
     //       qDebug()<<roleForTable[num][0].valueItem;
    }

    bool deleteValue(int num)
    {
       if(num<getCount())
            {
                roleForTable[num][0].creator.clear();
                roleForTable[num][0].hashItem.clear();
                roleForTable[num][0].investor.clear();
                roleForTable[num][0].valueItem.clear();
                return true;
            }
            else qDebug()<<"[StructTable] invalid value for delete";
            return false;
        }

};

}//end namespase
#endif // STRUCTCONTENT_H
