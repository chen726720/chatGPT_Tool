import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import Juc 1.0
Control {
    property int _id: 0
    property int currentIndex: 0
    property string _nickName:""
    property string _modelType:""
    property string _settingInfo:""

    Msg{
        id:msgBox
    }
    onCurrentIndexChanged: {
        chatWin.getRecords()
    }

    contentItem: SplitView{
        orientation: Qt.Vertical
        handle:Item{

            implicitHeight: 2
            implicitWidth: parent.width
            Rectangle{
                color: "#e7e8e9"
                width: parent.width
                height: 1
            }

        }

        ChatWin{
            id:chatWin
            SplitView.fillWidth: true
            SplitView.minimumHeight: 150
            SplitView.preferredHeight: parent.height*0.7
        }
//        Rectangle{SplitView.fillWidth: true;SplitView.preferredHeight: 1;color: "#f1f2f3"}
        ColumnLayout{
            spacing: 0
            SplitView.fillWidth: true
            SplitView.minimumHeight: 150
            SplitView.preferredHeight: parent.height*0.3
            ChatTool{
                id:chatTool
                Layout.fillWidth: true

            }
            ChatInput{
                id:chatInput
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
    function addNewWin(){
        mclass.exec(`insert into data${_id} (data)values ('')`)
        let __num = mclass.search(" select last_insert_rowid();")[0][0]
        currentIndex = __num
        chatWin.getRecords()
    }
}
//Button{
//    text: "测试"
//    onClicked: {
//        let t = {}
//        t['model'] = "gpt-3.5-turbo"
//        t["messages"]= [{"role": "system", "content": "你叫小明"}, {"role": "user", "content": "你好小明!"}]
//        let ret = mclass.getMsg("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", t)
//        print(ret)
//        print(JSON.parse(ret))
//    }
//}
