#include "DapUiQmlWidgetModel.h"

DapUiQmlWidgetModel::DapUiQmlWidgetModel(QObject *parent) : QAbstractListModel(parent)
{
    m_dapUiQmlWidgets.append(new DapUiQmlWidget("Blockchain explorer", "DapUiQmlWidgetChainBlockExplorer.ui.qml", "qrc:/Resources/Icons/add.png"));
    m_dapUiQmlWidgets.append(new DapUiQmlWidget( "Exchanges", "DapUiQmlWidgetChainExchanges.ui.qml", "qrc:/Resources/Icons/add.png"));
    m_dapUiQmlWidgets.append(new DapUiQmlWidget( "Services client", "DapUiQmlWidgetChainServicesClient.ui.qml", "qrc:/Resources/Icons/add.png"));
    m_dapUiQmlWidgets.append(new DapUiQmlWidget( "Services share control", "DapUiQmlWidgetChainServicesShareControl.ui.qml", "qrc:/Resources/Icons/add.png"));
    m_dapUiQmlWidgets.append(new DapUiQmlWidget( "Settings", "DapUiQmlWidgetChainSettings.ui.qml", "qrc:/Resources/Icons/add.png"));
    m_dapUiQmlWidgets.append(new DapUiQmlWidget( "Wallet", "DapUiQmlWidgetChainWallet.ui.qml", "qrc:/Resources/Icons/add.png"));
}

DapUiQmlWidgetModel &DapUiQmlWidgetModel::getInstance()
{
    static DapUiQmlWidgetModel instance;
    return instance;
}

int DapUiQmlWidgetModel::rowCount(const QModelIndex &) const
{
    return m_dapUiQmlWidgets.count();
}

QVariant DapUiQmlWidgetModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < rowCount())
            switch (role) {
            case NameRole: return m_dapUiQmlWidgets.at(index.row())->getName();
            case URLPageRole: return m_dapUiQmlWidgets.at(index.row())->getURLpage();
            case ImageRole: return m_dapUiQmlWidgets.at(index.row())->getImage();
            case VisibleRole: return m_dapUiQmlWidgets.at(index.row())->getVisible();
            default: 
                return QVariant();
        }
    return QVariant();
}

QHash<int, QByteArray> DapUiQmlWidgetModel::roleNames() const
{
    static const QHash<int, QByteArray> roles {
            { NameRole, "name" },
            { URLPageRole, "URLpage" },
            { ImageRole, "image" },
            { VisibleRole, "visible" }
        };
    
    return roles;
}

QVariantMap DapUiQmlWidgetModel::get(int row) const
{
    const DapUiQmlWidget *widget = m_dapUiQmlWidgets.value(row);
    return { {"name", widget->getName()}, {"URLpage", widget->getURLpage()}, {"image", widget->getImage()}, {"visible", widget->getVisible()} };
}

void DapUiQmlWidgetModel::append(const QString &name, const QString &URLpage, const QString &image, const bool &visible)
{
    int row = 0;
    while (row < m_dapUiQmlWidgets.count() && name > m_dapUiQmlWidgets.at(row)->getName())
        ++row;
    beginInsertRows(QModelIndex(), row, row);
    m_dapUiQmlWidgets.insert(row, new DapUiQmlWidget(name, URLpage, image, visible));
    endInsertRows();
}

void DapUiQmlWidgetModel::set(int row, const QString &name, const QString &URLpage, const QString &image, const bool &visible)
{
    if (row < 0 || row >= m_dapUiQmlWidgets.count())
            return;
    
        DapUiQmlWidget *widget = m_dapUiQmlWidgets.value(row);
        widget->setName(name);
        widget->setURLpage(URLpage);
        widget->setImage(image);
        widget->setVisible(visible);
        dataChanged(index(row, 0), index(row, 0), { NameRole, URLPageRole, ImageRole, VisibleRole });
}

void DapUiQmlWidgetModel::remove(int row)
{
    if (row < 0 || row >= m_dapUiQmlWidgets.count())
            return;
    
        beginRemoveRows(QModelIndex(), row, row);
        m_dapUiQmlWidgets.removeAt(row);
        endRemoveRows();
}

/// Method that implements the singleton pattern for the qml layer.
/// @param engine QML application.
/// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
QObject *DapUiQmlWidgetModel::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    
    return &getInstance();
}
