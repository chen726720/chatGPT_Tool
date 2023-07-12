import QtQuick 2.15
import QtQuick.Controls 2.15
import Juc 1.0
Slider {
    id:control


    stepSize:0.01
    handle:Rectangle{
//        CTooltip{
//            visible: control.activeFocus
//            text: control.value.toFixed(2)
//        }
        width: 15
        height: 15
        radius:width/2
        border.width: 2
        border.color: "#0ca47f"
        x:control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
    }
    background: Rectangle{
        id:back
        radius: height/2
        height: 5
        color: "#e5e6eb"
        width: control.availableWidth
        x:control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y:control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        Rectangle{
            radius: width
            height: 5
            width: control.visualPosition * parent.width
            color: "#0ca47f"
        }
    }


}
