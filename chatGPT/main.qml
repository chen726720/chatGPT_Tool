import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Juc 1.0
import MTool 1.0
import Qt.labs.settings 1.0
import "Win"
import "Com"
ApplicationWindow {
    id:root
    width: 900
    height: 600
    minimumHeight: 600
    minimumWidth: 900
    visible: true
    title: qsTr("Hello World")
    Pane {
               anchors.fill: parent
               focusPolicy: Qt.ClickFocus
           }
    MClass{
        id:mclass

    }
//    Button{
//        onClicked: print(mclass. calculateHash("nihao"))//mclass.getModelList("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")
//    }
    Control{
        anchors.fill: parent
        contentItem: RowLayout{
            spacing: 0
            ChatCheck{
                id:chatCheck
                Layout.fillHeight: true
            }
            Rectangle{
                Layout.fillHeight: true
                implicitWidth: 1
                color: "#e7e8e9"
            }

            Chat{
                id:chat
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            ChatList{
                id:chatList
            }
        }
    }
    MessageBox{
        id:messageBox
        property int _id
        title: "删除"
        text: "删除后将会把聊天记录也删除且不可逆!你确定要删除吗?"
        onNo: messageBox.close()
        onYes: {
            let delItem = `delete from ChatList where id = ${_id}`
            let delTabel = `drop table  main.data${_id}`
            mclass.exec(delItem)
            mclass.exec(delTabel)
            chatCheck.refresh()
        }
    }

    AddPage{
        id:addPage
        anchors.centerIn: parent

    }
    Settings{
        id:settings
        property string apiJSON
        property string settingJSON
        property string currentAPI
        property var setting //: [16, 1500, 0.5, 1, 0, 0]
        Component.onCompleted: {
            if(settingJSON) setting  = JSON.parse(settingJSON)["data"]
        }

//        Component.onDestruction: apiList.push("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")
    }

}
