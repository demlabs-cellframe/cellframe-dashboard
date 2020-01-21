#ifndef DAPTOOLTIPWIDGET_H
#define DAPTOOLTIPWIDGET_H

#include <QWidget>
#include <QTimer>
#include <QTime>
#include <QLabel>

class DapToolTipWidget : public QWidget
{
    Q_OBJECT

    QTimer  * m_pTimer {nullptr};
    QLabel  * m_pLabel {nullptr};

public:
    explicit DapToolTipWidget(QWidget *parent = nullptr);

signals:

private slots:
    void slotTimerAlarm();
};

#endif // DAPTOOLTIPWIDGET_H
