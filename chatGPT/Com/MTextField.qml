import QtQuick 2.15
import QtQuick.Controls 2.15
TextField {
    background: Rectangle{
        radius:5
        border.width: parent.activeFocus ? 1:0
        border.color: "#0ca47f"
        color: parent.activeFocus? "#fff":"#f2f3f5"
        Behavior on color {
            ColorAnimation{}
        }
    }
    selectByMouse: true
    font.family: "微软雅黑"
    padding: 6
}
