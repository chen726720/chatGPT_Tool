import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
Control {
    id:control
    property alias backgroundRectangle : back
    property alias title: label
    property alias textField: textField
    background: Rectangle{
        id:back
        radius: 5
        border.width: 1
        border.color:  control.hovered||textField.activeFocus  ? "#0fa37f":"#dfdfdf"
        Behavior on border.color {
            ColorAnimation{}
        }
    }
    contentItem: RowLayout{
        spacing: 0
        Label{
            id:label
            padding: 6
            font.family: "微软雅黑"
            font.pixelSize: 14
            color:"#6b7280"
        }
        Rectangle{
            Layout.fillHeight: true
            implicitWidth: back.border.width
            color: back.border.color
        }

        TextField{
            id:textField
            Layout.fillWidth: true
            selectByMouse: true
            background: Item {

            }
            font.family: "微软雅黑"
            padding: 6
            font.pixelSize: 14
            color: "#6b7280"
        }
    }
}
