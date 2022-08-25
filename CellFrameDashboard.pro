TEMPLATE = subdirs
SUBDIRS = CellFrameDashboardGUI CellFrameDashboardService

win32 {
    CellFrameDashboardGUI.depends = CellFrameDashboardService
}

unix: !mac : !android {
    share_target.files = debian/share/*
    share_target.path = /opt/cellframe-dashboard/share/
    node_share_target.files = cellframe-node/dist/share/* cellframe-node/dist.linux/share/*
    node_share_target.path = /opt/cellframe-node/share/
    node_network_target.files = cellframe-node/dist/etc/*
    node_network_target.path = /opt/cellframe-node/etc/
    node_bin_target.files = cellframe-node/build/cellframe-node
    node_bin_target.path = /opt/cellframe-node/bin/
    cli_bin_target.files = cellframe-node/build/cellframe-node-cli
    cli_bin_target.path = /opt/cellframe-node/bin/
    tool_bin_target.files = cellframe-node/build/cellframe-node-tool
    tool_bin_target.path = /opt/cellframe-node/bin/

    INSTALLS += share_target node_share_target node_network_target node_bin_target cli_bin_target tool_bin_target
}
