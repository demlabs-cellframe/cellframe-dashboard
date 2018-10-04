#include "DapUiQmlWidget.h"

bool DapUiQmlWidget::getVisible() const
{
    return m_visible;
}

void DapUiQmlWidget::setVisible(bool visible)
{
    m_visible = visible;
}

DapUiQmlWidget::DapUiQmlWidget(const QString &name, const QString &URLpage, const QString &image, const bool &visible, QObject *parent) : QObject(parent)
{
    setName(name);
    setURLpage(URLpage);
    setImage(image);
    setVisible(visible);
}

QString DapUiQmlWidget::getName() const
{
    return m_name;
}

void DapUiQmlWidget::setName(const QString &name)
{
    m_name = name;
}

QString DapUiQmlWidget::getURLpage() const
{
    return m_URLpage;
}

void DapUiQmlWidget::setURLpage(const QString &URLpage)
{
    m_URLpage = URLpage;
}

QString DapUiQmlWidget::getImage() const
{
    return m_image;
}

void DapUiQmlWidget::setImage(const QString &image)
{
    m_image = image;
}
