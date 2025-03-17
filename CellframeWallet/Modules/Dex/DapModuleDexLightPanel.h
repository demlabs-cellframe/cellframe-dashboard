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

    Q_PROPERTY(bool isRegularTypePanel READ isRegularTypePanel NOTIFY typePanelChanged)
    bool isRegularTypePanel();

    //                                              sell/buy
    Q_INVOKABLE void setTypeListToken(const QString& type);
    //                                          regular/advanced
    Q_PROPERTY(QString typePanel READ getTypePanel WRITE setTypePanel NOTIFY typePanelChanged)
    Q_INVOKABLE void setTypePanel(const QString& type);
    QString getTypePanel() {return m_typePanel;}

    Q_INVOKABLE void setCurrentTokenSell(const QString& token);
    Q_INVOKABLE void setCurrentTokenBuy(const QString& token);

    Q_INVOKABLE void swapTokens();

    Q_PROPERTY(bool isSwapTokens READ getIsSwapTokens WRITE setIsSwapTokens NOTIFY isSwapTokensChanged)
    bool getIsSwapTokens() const { return m_isSwapTokens; }
    void setIsSwapTokens(bool value);
    
    Q_INVOKABLE QString tryCreateOrderRegular(const QString& price, const QString& amount, const QString& fee);

    Q_INVOKABLE QString getDeltaRatePercent(const QString& rateValue);
public slots:
    void setNetworkFilterText(const QString &network) override;

    
signals:
    void sellValueFieldChanged();
    void orderTypeChanged();
    void isSwapTokensChanged();
    void typePanelChanged();
protected:
    bool setCurrentTokenPairVariable(const QString& namePair, const QString &network) override;
    void updateTokenModels() override;
    void workersUpdate() override;
private:
    void updateRegularModels();

private:
    DapTokensModel* m_tokensModel = nullptr;
    TokensProxyModel* m_tokenProxyModel = nullptr;

    DapTokenPairModel* m_regTokenPairsModel = nullptr;

    QString m_typeListToken = "sell";

//    QString m_typePanel = "regular";
    QString m_typePanel = "advanced";

    QString m_orderType = "Limit";
    QString m_sellValueField = "1.0";

    bool m_isSwapTokens = false;
};

#endif // DAPMODULEDEXLIGHTPANEL_H
