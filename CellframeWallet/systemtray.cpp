#include "systemtray.h"
#include <QMenu>
#include <QSystemTrayIcon>

SystemTray::SystemTray(QObject *parent) : QObject(parent)
{
    QMenu *trayIconMenu = new QMenu();

    QAction * viewWindow = new QAction(tr("Show window"), this);
    QAction * quitAction = new QAction(tr("Exit"), this);

    connect(viewWindow, &QAction::triggered, this, &SystemTray::signalShow);
    connect(quitAction, &QAction::triggered, this, &SystemTray::signalQuit);

    trayIconMenu->addAction(viewWindow);
    trayIconMenu->addAction(quitAction);

    trayIcon = new QSystemTrayIcon();
    trayIcon->setContextMenu(trayIconMenu);
    trayIcon->setIcon(QIcon(":/resources/icons/icon.ico"));
    trayIcon->show();
    trayIcon->setToolTip(tr(DAP_BRAND));

    connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));
}

void SystemTray::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
    switch (reason){
    case QSystemTrayIcon::Trigger:
        emit signalIconActivated();
        break;
    default:
        break;
    }
}

void SystemTray::hideIconTray()
{
    if (trayIcon != nullptr)
    {
        trayIcon->hide();
        delete trayIcon;
        trayIcon = nullptr;
    }
//    this->deleteLater();
}
