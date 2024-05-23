#include "DapModuleDexLightPanel.h"

DapModuleDexLightPanel::DapModuleDexLightPanel(DapModulesController *parent)
    : DapModuleDex(parent)
    , m_regularToken(new DapRegularTokenType(m_tokensPair))
{
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("regularToken", m_regularToken);
}
