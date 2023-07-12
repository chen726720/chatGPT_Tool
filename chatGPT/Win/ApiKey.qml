import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Com"
Popup {
    padding: 10
    implicitWidth: 300
    implicitHeight:  150
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle{
        radius: 5
        border.width: 1
        border.color: "#bdbdbd"
    }
    contentItem: ColumnLayout{
        RowLayout{
            Text {
                font.family: "微软雅黑"
                text: "绑定Apikey"
                font.bold: true

            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                font.family: "微软雅黑"
                color: "#0ca47f"
                text: "管理API"
                TapHandler{
                    onTapped: Qt.openUrlExternally("https://platform.openai.com/account/api-keys")
                }
            }

        }
        SwipeView{
            id:swipeView
            padding: 6
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            Control{
                padding: 10
                bottomPadding: 0
                contentItem: ColumnLayout{
                    ListView{
                        id:listView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 3
                        model: ListModel{
                            id:listModel

                        }

                        delegate:Control{
                            id:listControl
                            TapHandler{
                                onTapped: listView.currentIndex = index
                            }

                            background: Rectangle{
                                radius: 5
                                color: listControl.ListView.isCurrentItem ? "#e7faf6":parent.hovered? "#f1f2f3": "#fff"

                            }
                            padding: 6
                            implicitWidth: listView.width
                            contentItem: RowLayout{
                                spacing: 6
                                Rectangle{
                                    implicitHeight: 10
                                    implicitWidth: 10
                                    radius: 5
                                    color: listControl.ListView.isCurrentItem ? "#0ca47f" :"#86909c"
                                }
                                Text {
                                    font.family: "微软雅黑"
                                    text: apiName
                                }
                                Item{
                                    Layout.fillWidth: true
                                }
                                Text {
                                    font.family: "微软雅黑"
                                    text: apiKey
                                    Layout.maximumWidth: 100
                                    maximumLineCount:10
                                    elide:  Text.ElideRight
                                    color: "#8690a7"
                                }
                                Control{
                                    visible: false
                                    background: Rectangle{
                                        radius: width/2
                                        color: parent.hovered ? "#fff":"#00000000"
                                    }
                                    TapHandler{
                                        onTapped: {
                                            swipeView.currentIndex = 2
                                        }
                                    }

                                    padding: 4
                                    leftPadding: 6
                                    rightPadding: 6
                                    contentItem:  Text {
                                        font.family: "微软雅黑"
                                        text: "查"
                                        color: "#8690a7"

                                    }
                                }
                                Control{
                                    background: Rectangle{
                                        radius: width/2
                                        color: parent.hovered ? "#fff":"#00000000"
                                    }
                                    padding: 4
                                    leftPadding: 6
                                    rightPadding: 6
                                    contentItem:  Text {
                                        font.family: "微软雅黑"
                                        text: "删"
                                        color: "#8690a7"
                                    }
                                    TapHandler{
                                        onTapped: listModel.remove(index)
                                    }
                                }
                            }
                        }
                        onCurrentIndexChanged: {
                            settings.currentAPI = listModel.get(currentIndex)["apiKey"]
                        }

                        Component.onCompleted: {
                            let _api =  JSON.parse(settings.apiJSON)
                            if(_api){
                                for(let i of _api["data"])
                                    listModel.append(i)
                            }
                        }
                        Component.onDestruction: {
                            let ret =[]
                            for(let i=0;i< listModel.count;i++){
                                ret.push(listModel.get(i))
                            }
                            settings.apiJSON = JSON.stringify({"data":ret})

                        }
                    }
                    Button{
                        Layout.fillWidth: true
                        padding: 4
                        background: Rectangle{
                            radius: height/2
                            color: parent.hovered ?  "#1eb38f":"#0ca47f"
                        }
                        contentItem: Text {
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "微软雅黑"
                            font.pixelSize: 13

                            color: "#fff"
                            text: "添加API"
                        }
                        onClicked: swipeView.currentIndex = 1
                    }
                }
            }
            Control{
                padding: 10
                bottomPadding: 0
                contentItem:ColumnLayout{
                    GridLayout{
                        columns: 2
                        Text {
                            font.family: "微软雅黑"
                            text: "别名"
                        }
                        MTextField{
                            id:keyNameInput
                            Layout.fillWidth: true
                            placeholderText: "KEY的别名"
                        }
                        Text {
                            font.family: "微软雅黑"
                            text: "KEY"
                        }
                        MTextField{
                            id:keyInput
                            Layout.fillWidth: true
                            placeholderText: "请输入API KEY"
                        }

                    }
                    RowLayout{
                        Button{
                            Layout.fillWidth: true
                            padding: 4
                            background: Rectangle{
                                radius: height/2
                                color: parent.hovered ?  "#e5e6eb":"#f2f3f5"
                            }
                            contentItem: Text {
                                horizontalAlignment: Text.AlignHCenter
                                font.family: "微软雅黑"
                                font.pixelSize: 13

                                color: "#374151"
                                text: "取消"
                            }
                            onClicked: swipeView.currentIndex = 0
                        }
                        Button{
                            Layout.fillWidth: true
                            padding: 4
                            background: Rectangle{
                                radius: height/2
                                color: parent.hovered ?  "#1eb38f":"#0ca47f"
                            }
                            contentItem: Text {
                                horizontalAlignment: Text.AlignHCenter
                                font.family: "微软雅黑"
                                font.pixelSize: 13

                                color: "#fff"
                                text: "保存"

                            }
                            onClicked: {
                                if(keyNameInput.text!=="" && keyInput.text!== ""){
                                    listModel.append({"apiName" : keyNameInput.text, "apiKey":keyInput.text})
                                    keyNameInput.clear()
                                    keyInput.clear()
                                    swipeView.currentIndex = 0
                                }
                            }
                        }
                    }
                }
            }
            Control{
                padding: 10
                bottomPadding: 0
                contentItem: ColumnLayout{
                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/img/loading"
                        RotationAnimation on rotation{
                            duration: 2000
                            from: 0
                            to: 360
                            loops: Animation.Infinite
                        }
                    }
                    GridLayout{
                        Layout.alignment: Qt.AlignHCenter
                        columns: 3
                        columnSpacing: parent.width / 4
                        Repeater{
                            model: ["总额", "已用", "剩余"]
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                font.family: "微软雅黑"
                                text: modelData
                                font.bold: true
                                font.pixelSize: 12
                                color:"#8690a5"
                            }
                        }
                        Repeater{
                            model: [1.23,66.3,99]
                            Text {
                                font.family: "微软雅黑"
                                text: "$"+modelData
                                color:"#8690a5"
                            }
                        }
                    }
                    Button{
                        Layout.fillWidth: true
                        padding: 4
                        background: Rectangle{
                            radius: height/2
                            color: parent.hovered ?  "#1eb38f":"#0ca47f"
                        }
                        contentItem: Text {
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "微软雅黑"
                            font.pixelSize: 13

                            color: "#fff"
                            text: "返回"
                        }
                        onClicked: swipeView.currentIndex = 0
                    }
                }

            }
        }
    }
}
