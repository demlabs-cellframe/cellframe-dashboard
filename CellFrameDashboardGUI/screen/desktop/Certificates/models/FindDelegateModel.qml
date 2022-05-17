import QtQuick 2.9
import QtQml.Models 2.3


/*

  need move to common module


*/



DelegateModel {
    id: root
    items.includeByDefault: false
    property var predicate: function(obj) { return true; }

    function clear() {       //move from visible and pending group to unusable group
//        console.log("FindDelegateModel.clear()", items.count, pendingItems.count)
        if (items.count > 0)
            items.setGroups(0, items.count, "unusable")
        if (pendingItems.count > 0)
            pendingItems.setGroups(0, pendingItems.count, "unusable")
    }

    function renew() {        //find in base model
        if (items.count > 0)
            items.setGroups(0, items.count, "pending")
        if (unusableItems.count > 0)
            unusableItems.setGroups(0, unusableItems.count, "pending")
    }

    groups: [
        DelegateModelGroup {           //item wait for find
            id: pendingItems
            name: "pending"

            includeByDefault: true
            onChanged: {
                while (pendingItems.count > 0) {
                    var item = pendingItems.get(0)

                    if (predicate(item.model))
                        item.groups = "items"
                    else
                        item.groups = "unusable"
                }
            }
        },   //pending group end
        DelegateModelGroup {           //item no equal by find predicate
            id: unusableItems
            name: "unusable"
            includeByDefault: false
        }
    ]
}  //root

