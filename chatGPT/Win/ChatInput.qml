import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Control {
    Layout.fillHeight: true
    Layout.fillWidth: true
    contentItem: ColumnLayout{
        TextArea{
            id:textArea
            Layout.fillHeight: true
            Layout.fillWidth: true
            selectByMouse: true
            font.family: "微软雅黑"
            Keys.onPressed:{
                if((event.key === Qt.Key_Return||event.key === Qt.Key_Enter)&& event.modifiers!==Qt.ShiftModifier )
                {
                    if(settings.currentAPI){
                        let _sendData = {}, _msgList = []
                        _sendData['model'] = chat._modelType
                        chatWin.appendText("user", textArea.text, 0, 0, 0)
                        _sendData["messages"]= chatWin.getAllMsg()
                        textArea.clear()
                        let ret = mclass.getMsg(settings.currentAPI, _sendData)
                        if(ret!==""){
                            let _obj = JSON.parse(ret)
                            chatWin.appendText(_obj["choices"][0]["message"]["role"], _obj["choices"][0]["message"]["content"], _obj["usage"]["prompt_tokens"], _obj["usage"]["completion_tokens"],  _obj["usage"]["total_tokens"])
                        }
                    }
                    else{
                        msgBox.text = "请先选择API!!!"
                        msgBox.open()
                    }
                }
            }
            onTextChanged: {
                if(text === "\n")textArea.clear()
            }
        }

    }
    function reMake(){
        if(settings.currentAPI){
            let _sendData = {}, _msgList = []
            _sendData['model'] = chat._modelType
            _sendData["messages"]= chatWin.getAllMsg()
            let ret = mclass.getMsg(settings.currentAPI, _sendData)

            if(ret!==""){
                let _obj = JSON.parse(ret)
                chatWin.appendText(_obj["choices"][0]["message"]["role"], _obj["choices"][0]["message"]["content"], _obj["usage"]["prompt_tokens"], _obj["usage"]["completion_tokens"],  _obj["usage"]["total_tokens"])
            }
        }
        else{
            msgBox.text = "请先选择API!!!"
            msgBox.open()
        }
    }

    Connections{
        target: mclass
        function onAcceptChanged(){
            textArea.readOnly = false
            chatTool.isWaiting = false
        }
        function onWaitData(){
            textArea.readOnly = true
            chatTool.isWaiting = true
        }
    }

}
