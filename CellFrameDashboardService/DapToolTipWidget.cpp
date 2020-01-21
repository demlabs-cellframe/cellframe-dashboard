#include "DapToolTipWidget.h"

/// Standart constructor.
/// @param parent Parent.
DapToolTipWidget::DapToolTipWidget(QWidget *parent) : QWidget(parent)
{
    // Turn off the border of the standard window
    setWindowFlags(Qt::FramelessWindowHint);
    // Set tooltip message size
    setFixedSize(140, 45);
    m_pLabel = new QLabel(this);
    QFont font("Times", 28, QFont::Bold);
    m_pLabel->setFont(font);
    m_pLabel->setText(QTime::currentTime().toString("hh:mm:ss"));
    // We initialize and start the timer for updating information in tooltip
    m_pTimer = new QTimer(this);
    // Signal-slot connection updating information in tooltip
    connect(m_pTimer, SIGNAL(timeout()), this, SLOT(slotTimerAlarm()));
    m_pTimer->start(1000);
}

/// Update displayed time in tooltip.
void DapToolTipWidget::slotTimerAlarm()
{
    m_pLabel->setText(QTime::currentTime().toString("hh:mm:ss"));
}
