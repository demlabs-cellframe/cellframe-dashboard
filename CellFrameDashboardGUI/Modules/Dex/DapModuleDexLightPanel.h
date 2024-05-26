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

    //                                              sell/buy
    Q_INVOKABLE void setTypeListToken(const QString& type);
    //                                          regular/advanced
    Q_INVOKABLE void setTypePanel(const QString& type);

    Q_INVOKABLE void setCurrentTokenSell(const QString& token);
    Q_INVOKABLE void setCurrentTokenBuy(const QString& token);

protected:
    void updateTokenModels() override;
    void workersUpdate() override;
private:
    void setLightCurrentTokenPair(const DEX::InfoTokenPair& pair);
    void regularTokensUpdate();
    void updateRegularModels();
    bool isRegularTypeMode();
private:
    DapTokensModel* m_tokensModel = nullptr;
    TokensProxyModel* m_tokenProxyModel = nullptr;

    QString m_typeListToken = "sell";
    QString m_typePanel = "";
};

#endif // DAPMODULEDEXLIGHTPANEL_H
