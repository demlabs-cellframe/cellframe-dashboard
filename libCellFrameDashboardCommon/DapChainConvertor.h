#ifndef DAPCHAINCONVERTOR_H
#define DAPCHAINCONVERTOR_H

#include <QObject>

class DapChainConvertor : public QObject
{
    Q_OBJECT

public:
    explicit DapChainConvertor(QObject *parent = nullptr);
    /// Get instance of this class
    /// @param instance of this class
    static DapChainConvertor &getInstance();

public slots:
    Q_INVOKABLE QString toConvertCurrency(const QString& aMoney);
};

#endif // DAPCHAINCONVERTOR_H
