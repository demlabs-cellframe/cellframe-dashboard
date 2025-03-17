#ifndef DAPWALLETLISTMODEL_H
#define DAPWALLETLISTMODEL_H


/* INCLUDES */
#include <QAbstractTableModel>
#include "qjsonarray.h"
#include "qjsonobject.h"
#include "qjsondocument.h"
#include <QtMath>
#include <QDateTime>


#include "AbstractModels/DapAbstractWalletList.h"

class DapWalletListModel : public DapAbstractWalletList
{
    Q_OBJECT

    /****************************************//**
    * @name PROPERTIES
    *******************************************/
    /// @{
    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)
    /// @}

    /****************************************//**
    * @name CONSTRUCT/DESTRUCT
    *******************************************/
    /// @{
public:
    explicit DapWalletListModel (QObject *a_parent = nullptr);
    /// @}

    /****************************************//**
     * @name METHODS
     *******************************************/
    /// @{

    void setModel(QJsonDocument* doc);

private:
    Item getItem(QJsonObject obj);
    /// @}
};

#endif // DAPWALLETLISTMODEL_H
