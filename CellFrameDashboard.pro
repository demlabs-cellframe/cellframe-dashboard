TEMPLATE = subdirs
SUBDIRS = CellFrameDashboardGUI CellFrameDashboardService

CellFrameDashboardGUI.subdir = CellFrameDashboardGUI
CellFrameDashboardService.subdir = CellFrameDashboardService
CellFrameDashboardGUI.depends = CellFrameDashboardService

!defined(BRAND, var)
{
    BRAND = Cellframe-Dashboard
}

unix: !mac : !android {
    share_target.files = debian/share/*
    share_target.path = /opt/cellframe-dashboard/share/
    INSTALLS += share_target
}
