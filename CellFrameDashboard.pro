TEMPLATE = subdirs
#SUBDIRS = CellFrameDashboardGUI CellFrameDashboardService
#CellFrameDashboardGUI.depends = CellFrameDashboardService
SUBDIRS = CellFrameNode CellFrameDashboardGUI CellFrameDashboardService
CellFrameDashboardGUI.depends = CellFrameDashboardService
CellFrameDashboardService.depends = CellFrameNode

