import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../Com"
Control {
    property alias listview : listView
    background: Rectangle{
        color: "#f2f3f5"
    }
    padding: 15
    bottomPadding: 6
    contentItem: ListView{
        id:listView
        clip: true
        spacing: 10
        onContentHeightChanged: {
            if(!hovered)contentY =Math.max( listView.contentHeight - listView.height,0)
        }
        //        ScrollBar.vertical: ScrollBar {

        //        }
        //        contentY:hovered?contentY: Math.max( listView.contentHeight - listView.height,0)

        Behavior on contentY {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        model: ListModel{
            id:listModel
        }
        delegate:Control{
            id:listDelegate
            property string _role: role
            property string _msg: msgText
            implicitWidth: listView.width
            padding: 0
            contentItem:  RowLayout{
                spacing: 6

                layoutDirection:role === "user" ? Qt.RightToLeft:Qt.LeftToRight
                Layout.alignment: Qt.AlignRight
                Image {
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    fillMode: Image.PreserveAspectFit
                    source: role === "user" ? "qrc:/img/my": urlImg==="" ?"qrc:/img/logo2":urlImg
                    layer.enabled: true
                    layer.effect:OpacityMask{
                        Layout.alignment: Qt.AlignTop
                        maskSource: Rectangle{
                            implicitHeight: 30
                            implicitWidth: 30
                            radius: 15
                        }
                    }
                }
                ColumnLayout{

                    Text {
                        Layout.alignment:  role === "user" ? Qt.AlignRight:Qt.AlignLeft
                        font.family: "微软雅黑"
                        text: role === "user" ? "我":chat._nickName
                        color: "#86909c"
                    }
                    Control{
                        Control{
                            padding: 6
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset:  role === "user" ? 0: parent.width < 300? 50:0
                            anchors.top: parent.top
                            anchors.topMargin: -25
                            visible: listDelegate.hovered
                            background :Rectangle{
                                radius: 5
                                border.width: 1
                                border.color: "#dfdfdf"
                            }
                            contentItem: RowLayout{
                                Control{
                                    background: Rectangle{
                                        radius: width/2
                                        color: parent.hovered ? "#f1f2f3": "#fff"
                                    }
                                    padding: 3
                                    implicitHeight: 25
                                    implicitWidth: 25
                                    contentItem: Image {

                                        fillMode: Image.PreserveAspectFit
                                        source: "qrc:/img/shuaxin"
                                        smooth: true
                                    }
                                    TapHandler{
                                        onTapped: chatInput.reMake()
                                    }
                                }

                                Control{
                                    TapHandler{
                                        onTapped:{ listModel.remove(index);appendData()}
                                    }
                                    background: Rectangle{
                                        radius: width/2
                                        color: parent.hovered ? "#f1f2f3": "#fff"
                                    }
                                    padding: 3
                                    implicitHeight: 25
                                    implicitWidth: 25
                                    contentItem:  Image {
                                        fillMode: Image.PreserveAspectFit
                                        source: "qrc:/img/delete"
                                    }
                                }
                                Rectangle{
                                    implicitHeight: 20
                                    implicitWidth: 1
                                    color: "#c1c2c3"
                                    visible: role !== "user"
                                }

                                Text {
                                    font.family: "微软雅黑"
                                    text: "TOKENS:"
                                    color: "#b1b2b3"
                                    visible: role !== "user"
                                }

                                Label {
                                    background: Rectangle{
                                        radius:5
                                        color: "#f1f2f3"
                                    }
                                    visible: role !== "user"
                                    padding:6
                                    color: "#b2b3b4"
                                    font.family: "微软雅黑"
                                    text: "输入:"+prompt_tokens
                                }
                                Label {
                                    background: Rectangle{
                                        radius:5
                                        color: "#f1f2f3"
                                    }
                                    padding:6
                                    visible: role !== "user"
                                    color: "#b2b3b4"
                                    font.family: "微软雅黑"
                                    text: "输出:"+completion_tokens
                                }
                                Label {
                                    background: Rectangle{
                                        radius:5
                                        color: "#f1f2f3"
                                    }
                                    visible: role !== "user"
                                    padding:6
                                    color: "#b2b3b4"
                                    font.family: "微软雅黑"
                                    text: "总计:"+total_tokens
                                }
                            }

                        }

                        Layout.maximumWidth: listView.width - 70
                        padding: 10
                        background: Rectangle{
                            radius: 5
                            color: role === "user" ? "#d1e8ff":"#fff"
                        }
                        //                        Layout.fillWidth: true
                        contentItem:TextEdit{
                            id:textEdit
                            textFormat:TextEdit.MarkdownText
                            font.family: "微软雅黑"
                            font.pixelSize: 13
                            color: "#374151"
                            selectByMouse: true
                            wrapMode: TextEdit.Wrap
                            text: isLast? msgText:""

                        }
                        Timer{
                            property string text: msgText
                            interval: 10
                            running: text.length >0 && !isLast
                            onTriggered: {
                                //                                textEdit.text += text.substring(0,1)
                                textEdit.insert(textEdit.length, text.substring(0,1))
                                text = text.slice(1)
                            }
//                            Component.onCompleted: {
//                                var regex = /```([\s\S]*)```/g;
//                                var matches = [];
//                                var match;
//                                match = text.match(/```([\s\S]*)```/g)
//                                for(let i of match){
//                                    text = text.replace(i,  `<pre><code style=\"color: #FF0000\">"${i}"</code></pre>`)
//                                }

//                            }
                        }
                    }


                }
                Item{Layout.fillWidth: true}
            }
        }

    }
    function appendText(role, msg, prompt_tokens, completion_tokens, total_tokens){
        listModel.append({"role":role,"msgText":msg, "urlImg":"","isLast":false,"prompt_tokens":prompt_tokens,"completion_tokens":completion_tokens,"total_tokens":total_tokens})
        appendData()
    }
    function appendData(){
        let ret = []
        for(let i=0;i<listView.count;i++){
            ret.push(listModel.get(i))
        }
        let retDict = {"datas":ret}



        mclass.exec(`update data${chat._id} set data = '${JSON.stringify(retDict)}' where id=${currentIndex}`)

    }
    Connections{
        target: chatCheck
        function onCurrentItem(){
            getRecords()
        }
    }
    function getAllMsg(){
        let ret = [{"role": "system", "content": `${chat._settingInfo}`}]
        let start = chatTool.getContextNum()
        if(start > listView.count) start = 1 ;
        else start = listView.count - start;
        print("start:"+start)
        for(let i=start-1;i<listView.count;i++){
            ret.push({"role":listModel.get(i).role, "content":listModel.get(i).msgText})
        }
        return ret;
    }

    function getRecords(){
        let _data = mclass.search(`select data from data${chat._id} where id=${currentIndex}`)[0][0]
        listModel.clear()
        if(_data!==""){
            let _obj = JSON.parse(_data)
            for(let i of _obj["datas"]){
                i["isLast"] = true
                listModel.append(i)
            }
        }

    }

}
