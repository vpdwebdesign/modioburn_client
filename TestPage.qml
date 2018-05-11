import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ModioBurn.Tools 1.0

Pane {
    property string titlePage: "Testing combobox custom style"

    ParentModel {
        id: parentModel
    }

    ComboBox {
        id: cb
        anchors.centerIn: parent
        model: parentModel.itemPricesModel
        textRole: "price_per_unit"
    }
}
