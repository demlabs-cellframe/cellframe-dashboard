#ifndef DAPMODULEDEXLIGHTPANEL_H
#define DAPMODULEDEXLIGHTPANEL_H

#include "DapModuleDex.h"
#include "DapRegularTokenType.h"

class DapModuleDexLightPanel : public DapModuleDex
{
    Q_OBJECT
public:
    DapModuleDexLightPanel(DapModulesController *parent = nullptr);

private:

    DapRegularTokenType* m_regularToken = nullptr;
};

#endif // DAPMODULEDEXLIGHTPANEL_H
