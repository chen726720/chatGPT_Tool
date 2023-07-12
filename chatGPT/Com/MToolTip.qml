import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
ToolTip {
//    timeout:1
    property bool hovered: hoverHandler.hovered
    signal refreshBtn()
    signal deleteBtn()
    HoverHandler{
        id:hoverHandler
    }

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
                onTapped: refreshBtn()
            }
        }

        Control{
            TapHandler{
                onTapped:deleteBtn()
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
    }
}
