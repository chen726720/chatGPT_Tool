import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Juc 1.0
import "../Com"
Control {

    property bool isWaiting: false
    padding: 10
    contentItem: RowLayout{
        spacing: 10
        Label{
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            HoverHandler{
                id:labelHover1
            }
            CTooltip{
                visible: labelHover1.hovered
                text: "单:询问模式 发送一次性内容\n多:聊天模式 上下文发送"
            }

            background: Rectangle{
                radius: width/2
                color: "#e4fbf1"
            }
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            font.family: "微软雅黑"
            text: "多"
            color: "#4ab273"
            font.pixelSize: 13

        }
        Rectangle{implicitWidth: 1;implicitHeight: 20;color:"#bdbdbd"}
        TextButton{
            tooptipText: "创建新的记录"
            text: "新"
            TapHandler{
                onTapped: chat.addNewWin()
            }
        }
        Rectangle{implicitWidth: 1;implicitHeight: 20;color:"#bdbdbd"}

        TextButton{
            tooptipText: "打开所有记录"
            text: "记"
            TapHandler{
                onTapped: chatList.open()
            }
        }
        Rectangle{implicitWidth: 1;implicitHeight: 20;color:"#bdbdbd"}
        Control{
            ApiKey{
                id:apikeyPopup
                x:parent.x - width+ parent.width
                y:parent.y - height - 10
            }

            TapHandler{
                onTapped: apikeyPopup.open()
            }

            background: Rectangle{
                radius:5

                color: parent.hovered ? "#f1f2f3":"#fff"
            }
            padding: 3
            contentItem: Label {
                background:  Rectangle{
                    radius:5
                    border.width: 1
                    border.color: "#b1b2b3"
                }
                padding: 3
                color: "#b1b2b3"
                font.family: "微软雅黑"
                text: "API"
                font.pixelSize: 11
                font.bold: true
            }
            CTooltip{
                visible: parent.hovered
                text: "设置API KEY"
            }
        }
        Item{
            Layout.fillWidth: true
        }
        Control{
            id:waiting
            property int sec: 0
            visible: isWaiting
            onVisibleChanged: {
                if(visible)timer.running=true;
                else{
                    timer.running = false;
                    waiting.sec = 0;
                }
            }

            contentItem: Text {
                text: `正在等待回应(${30-waiting.sec}s)`
                font.family: "微软雅黑"
                font.pixelSize: 13
                padding: 6
                color: "#9b9c9c"
            }
            background:Rectangle {
                radius: 5
                color: "#f1f2f3"
            }
            Timer{
                id:timer
                running:false
                repeat: true
                onTriggered: waiting.sec++
            }
        }

        Item{
            Layout.fillWidth: true
        }
        TextButton{
            tooptipText: "修改设置"
            text: "设"
            TapHandler{
                onTapped: settingPopup.open()
            }

            SettingPopup{
                id:settingPopup

                x:- width/2 + parent.width/2
                y:parent.y - height - 20
            }
        }

        Control{
            CTooltip{
                visible: parent.hovered
                text: "当前模型"
            }
            contentItem: Text {
                text: chat._modelType
                font.family: "微软雅黑"
                font.pixelSize: 13
                padding: 6
                color: "#9b9c9c"
            }
            background:Rectangle {
                radius: 5
                color: "#f1f2f3"
            }
        }
    }
    function getContextNum(){
        return settingPopup.getContextNum()
    }
}
