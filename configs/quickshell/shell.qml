import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts


PanelWindow{
    id:root 

    anchors.top:true
    anchors.left:true
    anchors.right:true
    implicitHeight: 40

    color: "#1e1e2e"

    RowLayout{
        anchors.fill: parent
        anchors.margins: 0

        Repeater{
            model:10

            Text{
                property var worksp: Hyprland.workspaces.values.find(w =>w.id === index + 1)
                property bool act_worksp: Hyprland.focusedWorkspace?.id === ( index + 1 )
                text: act_worksp? "¤ " : (worksp ? "• " : "◦ ")
                color: act_worksp? "#cba6f7" : (worksp ? "#cdd6f4" : "#6c7086")
                font{ 
                    pixelSize: 30 
                    bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }
        Item { Layout.fillWidth: true}
    }



}
