import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

import Juc 1.0
Control {
    id:control
    property alias listview: listView
    signal currentItem()
    clip: true
    property bool unfold: true
    Behavior on implicitWidth {
        NumberAnimation{duration: 100; easing.type: Easing.InOutQuad}
    }

    contentItem: ColumnLayout{
        Label{
            HoverHandler{
                id:labelHover
                onHoveredChanged: cTooltip.visible = hovered
            }
            CTooltipLeft{
                id:cTooltip
                text: "添加AI"
            }

            Layout.margins: 10
            Layout.bottomMargin: 3
            Layout.fillWidth: true

            background: Rectangle{
                radius: 15
                color: labelHover.hovered ? "#f1f2f3": "#f7f8f9"
                Behavior on color {
                    ColorAnimation{}
                }
            }
            TapHandler{
                id:tapHandler
                onTapped: {addPage.open();cTooltip.visible=false}
            }

            horizontalAlignment: Label.AlignHCenter
            text: "+"
            color: "#6b7280"
            font.family: "微软雅黑"
            font.pixelSize: 16

        }

        ListView{
            id:listView
            model:ListModel{
                id:listModel
            }
            implicitWidth: unfold? 140:64
            Layout.fillHeight: true
            delegate: Control{
//                id:control
                property int __id: _id
                property string __nickName: nickName
                property string __remarks: remarks
                property string __modelType: modelType
                property string __settingInfo: settingInfo
                implicitWidth: 140
                background: Rectangle{
                    color: parent.ListView.isCurrentItem ? "#f1f2f3":"#fff"
                    Behavior on color {ColorAnimation {}}
                }
                padding: 15
                contentItem: RowLayout{
                    Image {
                        CTooltipLeft{
                            visible: controlHover.hovered&!unfold
                            text: nickName

                        }
                        Layout.preferredWidth: 35
                        Layout.preferredHeight: 35
                        fillMode: Image.PreserveAspectFit
                        source: urlImg==="" ?"qrc:/img/logo2":urlImg
                        layer.enabled: true
                        layer.effect:OpacityMask{

                            maskSource: Rectangle{
                                implicitHeight: 35
                                implicitWidth: 35
                                radius: 15
                            }
                        }
                    }

                    ColumnLayout{
                        visible: unfold
                        spacing: 3
                        Layout.fillWidth: true
                        Text {
                            font.family: "微软雅黑"
                            text: nickName
                        }
                        Text {
                            font.family: "微软雅黑"
                            color:"#9b9c9d"
                            text: remarks
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                }
                TapHandler {
                    acceptedButtons:Qt.LeftButton | Qt.RightButton
                    onTapped: {
                        listView.currentIndex = index;
                        chat._modelType = modelType
                        chat._nickName = nickName
                        chat._settingInfo = settingInfo
                        chat._id = _id
                        if(eventPoint.event.button == 2){
                            menu.y = eventPoint.scenePosition.y // listView.currentItem.y + eventPoint.scenePosition.y
                            menu.x = eventPoint.scenePosition.x //listView.currentItem.x + eventPoint.scenePosition.x
                            menu._id = _id
                            menu._nickName = nickName
                            menu._remarks = remarks
                            menu._modelType = modelType
                            menu._settingInfo = settingInfo
                            menu._urlImg = urlImg
                            menu.open()
                        }
                    }
                }


                HoverHandler {
                    id:controlHover

                }

            }
            onCurrentItemChanged: {
                chat._nickName = currentItem.__nickName
                chat._id = currentItem.__id
                chat._modelType = currentItem.__modelType
                chat._settingInfo = currentItem.__settingInfo
                chat.currentIndex = Number(mclass.search(`select max(id) from data${currentItem.__id}`)[0][0])
                if(chat.currentIndex===0){
                    mclass.exec(`insert into data${currentItem.__id} (name, data) VALUES ('','')`)
                    chat.currentIndex = Number(mclass.search(`select max(id) from data${currentItem.__id}`)[0][0])
                }
                control.currentItem()
            }
        }
        Text{
            Layout.fillWidth: true
            font.pixelSize: 16
            horizontalAlignment: Label.AlignHCenter
            font.family: "微软雅黑"
            font.bold: true
            color: "#9b9c9d"
            text: unfold? "<":">"
            HoverHandler{
                id:hover
            }

            CTooltip{
                text: "缩进"
                visible: hover.hovered
            }
            TapHandler{
                onTapped: unfold = !unfold
            }
        }
        Component.onCompleted:{
            refresh()
        }
    }
    Menu {
        id: menu
        property int _id
        property string _nickName
        property string _remarks
        property string _modelType
        property string _settingInfo
        property string _urlImg
        background: Rectangle{
            radius: 5
            implicitWidth: 100
            implicitHeight: 40

            border.width: 1
            border.color: "#dfdfdf"

        }
        contentItem:ListView{
            model: menu.contentModel
            clip: true
            currentIndex: menu.currentIndex
            implicitHeight: contentHeight
        }

        padding: 6
        MenuItem {
            background: Rectangle{
                radius:5
                color: parent.hovered ? "#f6f6f6":"#fff"
            }

            font.family: "微软雅黑"
            text: "修改"
            contentItem: Text {
                font:parent.font
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
            }
            onTriggered: {
                addPage.updata(menu._id,menu._nickName, menu._remarks, menu._modelType, menu._settingInfo)
            }
        }

        MenuItem {
            font.family: "微软雅黑"
            text: "删除"
            onTriggered: {
                messageBox._id = menu._id
                messageBox.open()
            }
            contentItem: Text {
                font:parent.font
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
            }
            background: Rectangle{
                radius:5
                color: parent.hovered ? "#f6f6f6":"#fff"
            }
        }
    }
    function refresh(){
        let __list = mclass.search("select * from ChatList")
        listModel.clear()
        for(let i of __list){
            listModel.append({"_id":i[0],"nickName":i[1],"remarks":i[2],"modelType":i[3], "settingInfo":i[4],"urlImg":i[5]})

        }
    }

}
