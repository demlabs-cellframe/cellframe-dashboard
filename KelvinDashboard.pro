TEMPLATE = subdirs
SUBDIRS = KelvinDashboardGUI KelvinDashboardService

KelvinDashboardGUI.subdir = KelvinDashboardGUI
KelvinDashboardService.subdir = KelvinDashboardService
KelvinDashboardGUI.depends = KelvinDashboardService

!defined(BRAND, var)
{
    BRAND = KelvinDashboard
}
