TEMPLATE = subdirs
SUBDIRS = KelvinDashboardGUI KelvinDashboardService

KelvinDashboardGUI.subdir = KelvinDashboardGUI
KelvinDashboardService.subdir = KelvinDashboardService
KelvinDashboardGUI.depends = KelvinDashboardService

!defined(BRAND, var)
{
    BRAND = KelvinDashboard
}

unix: !mac : !android {
    share_target.files = debian/share/*
    share_target.path = /opt/KelvinDashboard/share/
    INSTALLS += share_target
}
