import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Control {
    id:control
    property alias backgroundRectangle : back
    property alias comboBox: comboBox
    background: Rectangle{
        id:back
        radius: 5
        border.width:comboBox.popup.visible ? 1:0
        border.color:  comboBox.popup.visible ? "#0fa37f":"#dfdfdf"
        color: comboBox.popup.visible ?"#fff":"#f2f3f5"
        Behavior on border.color {
            ColorAnimation{}
        }
    }

    contentItem: RowLayout{


        ComboBox{
            id:comboBox
            Layout.fillWidth: true
            model: ["gpt-3.5-turbo","gpt-3.5-turbo-0301","gpt-3.5-turbo-0613","gpt-3.5-turbo-16k","gpt-3.5-turbo-16k-0613","gpt-4","gpt-4-0314","gpt-4-0613"]
            background: Item{

            }
            contentItem: Label{
                leftPadding: 6
                text: comboBox.currentText
                font.family: "微软雅黑"

            }

            indicator:Item {

            }
            delegate: ItemDelegate{
                width: ListView.view.width
                background: Rectangle{
                    radius:5
                    color: hovered? "#f1f2f3":"#fff"
                }
                padding: 6
                contentItem: Text {
                    text:modelData
                    font.family: "微软雅黑"
                    font.pixelSize: 14
                }

            }
            popup:Popup{
                background: Rectangle{
                    radius: 5
                    border.width: 1
                    border.color: "#dfdfdf"
                }
                y: control.height+3
                width: comboBox.width
                topMargin: 6
                bottomMargin: 6
                padding: 6
                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: comboBox.delegateModel
                    currentIndex: comboBox.highlightedIndex
                    highlightMoveDuration: 0
                    ScrollIndicator.vertical: ScrollIndicator { }
                }
            }

            font.family: "微软雅黑"
            padding: 6
            font.pixelSize: 14
        }
    }
}
