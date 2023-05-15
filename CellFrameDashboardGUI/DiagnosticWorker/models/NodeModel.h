#ifndef NODEMODEL_H
#define NODEMODEL_H


/* INCLUDES */
#include <QAbstractTableModel>
#include "qjsonarray.h"
#include "qjsonobject.h"
#include "qjsondocument.h"
#include <QtMath>
#include <QDateTime>

#include "AbstractNodeModel.h"

/****************************************//**
 * @brief users model demo
 *
 * Same as UserModel, except fills globatl
 * instance with objects
 *******************************************/

class NodeModel : public AbstractNodeModel
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
    explicit NodeModel (QObject *a_parent = nullptr);
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

#endif // NODEMODEL_H
