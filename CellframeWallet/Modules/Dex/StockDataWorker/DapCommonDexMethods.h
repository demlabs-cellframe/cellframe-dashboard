#ifndef DAPCOMMONDEXMETHODS_H
#define DAPCOMMONDEXMETHODS_H

#include <QString>

class DapCommonDexMethods
{
public:
    DapCommonDexMethods() = default;

    static bool isCorrectAmount(const QString& value);
};

#endif // DAPCOMMONDEXMETHODS_H
