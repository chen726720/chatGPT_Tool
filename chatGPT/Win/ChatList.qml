import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Com"
Popup {
    id:popup

    implicitHeight: root.height
    implicitWidth:  200
    modal: true
    padding: 20
    background: Rectangle{

    }

    enter:Transition{

        NumberAnimation {
            target: popup
            property: "x"
            from: root.width
            to: root.width- popup.implicitWidth
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
    exit:Transition {
        NumberAnimation {
            target: popup
            property: "x"
            from:root.width- popup.implicitWidth
            to: root.width
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    Behavior on implicitWidth {

        NumberAnimation {

            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    contentItem: ListView{
        id:listView
        model: ListModel{
            id:listModel

        }
        delegate: Control{
            implicitWidth: listView.width
            background: Rectangle{
                radius: 5
                color:chat.currentIndex === RecordsID ? "#f1f2f3" : "#fff"
            }
            padding:10
            TapHandler{
                onTapped: {chat.currentIndex = RecordsID; popup.close()}
            }

            contentItem:  RowLayout{
                Text{
                    font.family: "微软雅黑"
                    color: "#8690a5"
                    text: RecordsName === "" ? `第${RecordsID}次对话`: RecordsName
                }
                Item{
                    Layout.fillWidth: true
                }

                Control{
                    background: Rectangle{
                        radius: width/2
                        color: parent.hovered ? "#fff":"#f1f2f3"
                    }
                    padding: 6
                    leftPadding: 8
                    rightPadding: 8
                    contentItem: Text {
                        font.family: "微软雅黑"
                        color: "#8690a5"
                        text: "删"
                    }
                }
            }

        }
    }

    function refresh(){
        let _data = mclass.search(`select id, name from data${chat._id}`)
        listModel.clear()
        for(let i of _data){
            listModel.append({"RecordsID":i[0],"RecordsName":i[1]})
        }
    }
    onOpened: refresh()
    onClosed: listModel.clear()
}
