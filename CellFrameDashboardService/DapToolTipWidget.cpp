#include "DapToolTipWidget.h"

DapToolTipWidget::DapToolTipWidget(QWidget *parent) : QWidget(parent)
{
    setWindowFlags(Qt::FramelessWindowHint);
    setFixedSize(140, 45);

    m_pLabel = new QLabel(this);
    QFont font("Times", 28, QFont::Bold);
    m_pLabel->setFont(font);
    m_pLabel->setText(QTime::currentTime().toString("hh:mm:ss"));

    m_pTimer = new QTimer(this);
    connect(m_pTimer, SIGNAL(timeout()), this, SLOT(slotTimerAlarm()));
    m_pTimer->start(1000);
}

void DapToolTipWidget::slotTimerAlarm()
{
    m_pLabel->setText(QTime::currentTime().toString("hh:mm:ss"));
}
