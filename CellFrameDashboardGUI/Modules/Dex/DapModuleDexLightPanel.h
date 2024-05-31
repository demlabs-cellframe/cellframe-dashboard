#ifndef DAPMODULEDEXLIGHTPANEL_H
#define DAPMODULEDEXLIGHTPANEL_H

#include "DapModuleDex.h"
#include "DapRegularTokenType.h"
#include "Models/DEXModel/DapTokensModel.h"
#include "Models/DEXModel/TokensProxyModel.h"

class DapModuleDexLightPanel : public DapModuleDex
{
    Q_OBJECT
public:
    DapModuleDexLightPanel(DapModulesController *parent = nullptr);
    ~DapModuleDexLightPanel();

    Q_PROPERTY(QString orderType READ getOrderType WRITE setOrderType NOTIFY orderTypeChanged)
    QString getOrderType() const { return m_orderType; }
    void setOrderType(const QString& type);

    Q_PROPERTY(QString sellValueField READ getSellValueField WRITE setSellValueField NOTIFY sellValueFieldChanged)
    QString getSellValueField() const { return m_sellValueField; }
    void setSellValueField(const QString& value);

    Q_PROPERTY(bool isMarketType READ isMarketType NOTIFY orderTypeChanged)
    bool isMarketType() const { return m_orderType == "Market"; }

    //                                              sell/buy
    Q_INVOKABLE void setTypeListToken(const QString& type);
    //                                          regular/advanced
    Q_INVOKABLE void setTypePanel(const QString& type);
    Q_INVOKABLE bool isRegularTypeMode();

    Q_INVOKABLE void setCurrentTokenSell(const QString& token);
    Q_INVOKABLE void setCurrentTokenBuy(const QString& token);
signals:
    void sellValueFieldChanged();
    void orderTypeChanged();
protected:
    void updateTokenModels() override;
    void workersUpdate() override;
private:
    void setLightCurrentTokenPair(const DEX::InfoTokenPair& pair);
    void regularTokensUpdate();
    void updateRegularModels();
    //bool isRegularTypeMode();
private:
    DapTokensModel* m_tokensModel = nullptr;
    TokensProxyModel* m_tokenProxyModel = nullptr;

    DapTokenPairModel* m_regTokenPairsModel = nullptr;

    QString m_typeListToken = "sell";
    QString m_typePanel = "";

    QString m_orderType = "Limit";
    QString m_sellValueField = "1.0";
};

#endif // DAPMODULEDEXLIGHTPANEL_H
