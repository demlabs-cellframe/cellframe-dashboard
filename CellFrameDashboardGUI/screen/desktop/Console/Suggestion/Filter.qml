import QtQuick 2.0

Item {
    id: component
    property alias model: filterModel

    property QtObject sourceModel: undefined
    property string filter: ""
    property string property: ""

    onPropertyChanged: property = "name"

    Connections {
        onFilterChanged: invalidateFilter()
        onPropertyChanged: invalidateFilter()
        onSourceModelChanged: invalidateFilter()
    }

    Component.onCompleted: invalidateFilter()

    ListModel {
        id: filterModel
    }


    // filters out all items of source model that does not match filter
    function invalidateFilter() {
        if (sourceModel === undefined)
            return;

        filterModel.clear();

        if (!isFilteringPropertyOk())
            return

        var length = sourceModel.count
        for (var i = 0; i < length; ++i) {
            var item = sourceModel.get(i);
            if (isAcceptedItem(item)) {
                filterModel.append(item)
            }
        }
    }


    // returns true if item is accepted by filter
    function isAcceptedItem(item) {
        if (item[this.property] === undefined)
            return false

        if (item[this.property].match(this.filter) === null) {
            return false
        }

        return true
    }

    // checks if it has any sence to process invalidating based on property
    function isFilteringPropertyOk() {
        if(this.property === undefined || this.property === "") {
            return false
        }
        return true
    }
}
