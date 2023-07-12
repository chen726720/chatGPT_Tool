import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Com"
Popup {
    padding: 10
    implicitWidth: 250
    //    implicitHeight:  230
    //    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle{
        radius: 5
        border.width: 1
        border.color: "#bdbdbd"

    }
    contentItem:ColumnLayout{

        Repeater{
            id:repeater
            model:ListModel{
                id:listModel
            }

            Component.onCompleted: {
                listModel.append({"name":"上下文数", "sliderValue":  settings.setting[0]})
                listModel.append({"name":"最大回复", "sliderValue": settings.setting[1]})
                listModel.append({"name":"随机属性", "sliderValue": settings.setting[2]})
                listModel.append({"name":"词汇属性", "sliderValue": settings.setting[3]})
                listModel.append({"name":"话题属性", "sliderValue": settings.setting[4]})
                listModel.append({"name":"重复属性", "sliderValue": settings.setting[5]})
            }
            Component.onDestruction: {
                let _data= []
                for(let i =0; i<6 ;i++){
                    _data.push(listModel.get(i)["sliderValue"])

                }
                settings.settingJSON = JSON.stringify({"data":_data})
            }

            RowLayout{

                Text {
                    font.family: "微软雅黑"
                    text: name
                    color: "#374151"
                }

                MSlider{
                    id:mslider
                    stepSize:name === "上下文数" ? 1:name === "最大回复" ? 50:0.1
                    from: name === "上下文数" ? 1:name === "最大回复" ? 50:0.0
                    to: name === "上下文数" ? 100:name === "最大回复" ? 2500:1
                    Layout.fillWidth: true
                    value: sliderValue
                    onValueChanged: sliderValue = value
                }

                MTextField{
                    horizontalAlignment: TextField.AlignHCenter
                    Layout.preferredWidth: 50
                    text:name === "上下文数" || name === "最大回复" ? mslider.value.toFixed(0): mslider.value.toFixed(2)
                    Keys.onReturnPressed: {
                        sliderValue = Number(text)
                    }
                }
            }

        }
    }
    function getContextNum(){
        return listModel.get(0).sliderValue
    }
}
