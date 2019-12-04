#include "DapClipboard.h"

DapClipboard::DapClipboard(QObject *parent) : QObject(parent)
{
    m_clipboard = QApplication::clipboard();
}

DapClipboard& DapClipboard::instance()
{
    static DapClipboard instance;
    return instance;
}

void DapClipboard::setText(const QString& aText)
{
    m_clipboard->setText(aText);
}
