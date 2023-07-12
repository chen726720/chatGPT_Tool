import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Juc 1.0
Control{
    id:control
    property string text: ""
    property string tooptipText: ""
    background: Rectangle{
        width: 30
        height: 30
        radius: 15
        anchors.centerIn: parent
        color: parent.hovered ? "#f1f2f3":"#fff"
    }

    implicitHeight: 20
    implicitWidth: 20
    CTooltip{
        visible: parent.hovered
        text:tooptipText
    }

    contentItem:Label{
        background: Rectangle{
            radius: width/3
            border.width: 1
            border.color: parent.color
        }
        horizontalAlignment: Label.AlignHCenter
        verticalAlignment: Label.AlignVCenter
        font.family: "微软雅黑"
        color: "#b2b3b4"
        font.pixelSize: 12
        font.bold: true
        text: control.text
    }
}
