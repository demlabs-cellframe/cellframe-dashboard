/****************************************************************************
**
** This file is part of the CellFrameDashboardService application.
**
** The class implements a toolTip popup message widget that appears
** when you hover over the CellFrameDashboardService icon in the tray.
**
****************************************************************************/

#ifndef DAPTOOLTIPWIDGET_H
#define DAPTOOLTIPWIDGET_H

#include <QWidget>
#include <QTimer>
#include <QTime>
#include <QLabel>

class DapToolTipWidget : public QWidget
{
    Q_OBJECT

    /// Display update timer.
    QTimer  * m_pTimer {nullptr};
    /// Central widget.
    QLabel  * m_pLabel {nullptr};

public:
    /// Standart constructor.
    /// @param parent Parent.
    explicit DapToolTipWidget(QWidget *parent = nullptr);

private slots:
    /// Update displayed time in tooltip.
    void slotTimerAlarm();
};

#endif // DAPTOOLTIPWIDGET_H
