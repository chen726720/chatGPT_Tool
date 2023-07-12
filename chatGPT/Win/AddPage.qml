import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import Juc 1.0
import "../Com"
Popup {
    id:popup
    width: parent.width*0.6
    property int _id
    background:Pane {
        background: Rectangle{
            radius: 10
        }

        focusPolicy: Qt.ClickFocus
    }
    padding: 40
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    contentItem: ColumnLayout{
        spacing: 10
        Image {
            id:img
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            source: "qrc:/img/logo2"
            fillMode: Image.PreserveAspectFit
            smooth: true
            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: Rectangle{
                    width: 50
                    height: 50
                    radius: width/2
                }
            }
            Layout.bottomMargin: 10
        }
        GridLayout{
            columns: 2
            Text {
                font.family: "微软雅黑"
                color:"#6b7280"
                text: "选择模型"
                font.pixelSize: 15
            }

            MComboBox{
                id:modelTypes

                Layout.fillWidth: true
            }
            Text {
                font.family: "微软雅黑"
                color:"#6b7280"
                text: "昵称"
                font.pixelSize: 15
            }
            MTextField{
                 id:nickName
                 placeholderText: "请输入昵称(必填)"
                 Layout.fillWidth: true
            }
            Text {
                font.family: "微软雅黑"
                color:"#6b7280"
                text:  "备注"
                font.pixelSize: 15
            }
            MTextField{
                 id:remarks
                 placeholderText: "备注"
                 Layout.fillWidth: true
            }
            Text {
                font.family: "微软雅黑"
                color:"#6b7280"
                text:  "设定"
                font.pixelSize: 15
                Layout.alignment: Qt.AlignTop
            }
            ScrollView{
                Layout.fillWidth: true
                implicitHeight: 150
                background: Rectangle{
                    radius: 5
                    color: "#f9fafb"
                }
                CTooltip{
                    y:-40
                    visible: settingInfo.activeFocus && settingInfo.text===""
                    text: "在此处设定AI的性格、命令、设定等等。"
                }
                padding:6
                TextArea{
                    id:settingInfo
                    clip: true
                    wrapMode: TextArea.WrapAnywhere
                    selectByMouse: true
                    font.family: "微软雅黑"
                    color: "#6b7280"
                }

            }

        }



        RowLayout{
            spacing: 10
            Layout.alignment: Qt.AlignHCenter
            Button{
                id:btn1
                background: Rectangle{
                    radius: 5
                    color: parent.hovered ? "#1dd1a1":"#10ac84"
                }
                font.family: "微软雅黑"
                text: "修改"
                visible: false
                contentItem: Text {
                    font.family: "微软雅黑"
                    color:"#fff"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 15
                }
                onClicked: {
                    let _updata = `update ChatList set Name = '${nickName.text}', remarks = '${remarks.text}' , model = '${modelTypes.comboBox.currentText}', settingInfo='${settingInfo.text}' , imgUrl = '' where id = ${popup._id}`
                    mclass.exec(_updata)
                    chatCheck.refresh()
                    print(_updata)
                    popup.close()
                }
                padding: 20
                topPadding: 6
                bottomPadding: 6
            }
            Button{
                id:btn2
                background: Rectangle{
                    radius: 5
                    color: parent.hovered ? "#1dd1a1":"#10ac84"
                }
                font.family: "微软雅黑"
                text: "保存"
                contentItem: Text {
                    font.family: "微软雅黑"
                    color:"#fff"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 15
                }
                onClicked: {
                    let _addStr = `insert into ChatList (Name, remarks, model, settingInfo, imgUrl)  values('${nickName.text}','${remarks.text}','${modelTypes.comboBox.currentText}','${settingInfo.text}','');
                   `
                    mclass.exec(_addStr)
                    let __num = mclass.search(" select last_insert_rowid();")[0]
                    let _execStr = `create table main.data${__num}
                    (
                        id   integer PRIMARY KEY AUTOINCREMENT,
                        name text,
                        data text
                    );`

                    mclass.exec(_execStr)

                    chatCheck.refresh()
                    popup.close()
                }
                padding: 20
                topPadding: 6
                bottomPadding: 6
            }
            Button{
                background: Rectangle{
                    radius: 5
                    color: parent.hovered ? "#8395a7":"#f2f3f5"
                }

                font.family: "微软雅黑"
                text: "取消"
                contentItem: Text {
                    font.family: "微软雅黑"
                    color:parent.hovered ? "#fff":"#6b7280"
                    text: parent.text
                    font.pixelSize: 15
                    horizontalAlignment: Text.AlignHCenter
                }
                onClicked: popup.close()
                padding: 20
                topPadding: 6
                bottomPadding: 6
            }
        }
    }
    onClosed : {btn1.visible = false; btn2.visible = true}

    function updata(_id, _nickName, _remarks, _modelTypes, _settingInfo, _urlImg){
        modelTypes.comboBox.currentIndex = modelTypes.comboBox.find(_modelTypes)
        nickName.text = _nickName
        remarks.text = _remarks
        settingInfo.text = _settingInfo
        if(_urlImg)img.source = _urlImg
        btn1.visible = true
        btn2.visible = false
        popup._id = _id
        popup.open()
    }
}
