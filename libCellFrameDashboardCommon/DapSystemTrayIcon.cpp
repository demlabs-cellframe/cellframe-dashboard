#include "DapSystemTrayIcon.h"

DapSystemTrayIcon::DapSystemTrayIcon(QObject *parent) : QSystemTrayIcon(parent)
{
    installEventFilter(this);

    connect(this, SIGNAL(iconPosChaged(QRect)), this, SLOT(determinePosIcon(QRect)));
    connect(&m_timer, SIGNAL(timeout()), SLOT(getMousePosition()));
    connect(this, SIGNAL(mousePosChanged(QPoint)), this, SLOT(checkRange(QPoint)));
}

void DapSystemTrayIcon::setToolTipWidget(QWidget *apToolTip)
{
    Q_ASSERT(apToolTip);

    m_pToolTipWidget = apToolTip;
}

const QWidget *DapSystemTrayIcon::getToolTipWidget() const
{
    return m_pToolTipWidget;
}

bool DapSystemTrayIcon::eventFilter(QObject *watched, QEvent *event)
{
    if (event->type() == QHelpEvent::ToolTip)
    {
        QSystemTrayIcon *icon = static_cast<QSystemTrayIcon *>(watched);
        emit iconPosChaged(icon->geometry());
        return true;
    }
    else
    {
        return QObject::eventFilter(watched, event);
    }
}

void DapSystemTrayIcon::determinePosIcon(const QRect &aPos)
{
    m_rectIcon = aPos;
    if(m_pToolTipWidget != nullptr)
    {
        m_timer.start(1000);
        m_pToolTipWidget->move(QPoint(aPos.x(), aPos.y()));
        m_pToolTipWidget->show();
    }
}

void DapSystemTrayIcon::getMousePosition()
{
    QPoint mousePos = QCursor::pos();

    emit mousePosChanged(mousePos);
}

void DapSystemTrayIcon::checkRange(const QPoint &aPos)
{
    if(!m_rectIcon.contains(aPos))
    {
        m_timer.stop();
        m_pToolTipWidget->hide();
    }
}
