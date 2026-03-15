import QtQuick 6.6
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
    readonly property color accent: "#ded1ec" 
    readonly property color bg: "#151515"
    readonly property color fg: "#5b5e5c"
    readonly property color alert: "#eb5e5c"

    PanelWindow {
        id: bar
        color: "transparent"
        anchors { top: true; left: true; right: true }
        margins { top: 9; left: 9; right: 9 }
        implicitHeight: 30

        Rectangle {
            anchors.fill: parent
            color: bg
            radius: 5

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                spacing: 12

                RowLayout {
                    id: leftGroup
                    spacing: 5
                    Layout.alignment: Qt.AlignLeft
                    
                    Nixos {
                        id: nixosModule
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Rectangle {
                        width: wsModule.width + 16
                        height: 24
                        radius: 12
                        color: bg
                        Layout.alignment: Qt.AlignVCenter
                        Ws { id: wsModule; anchors.centerIn: parent }
                    }
                }

                Item { Layout.fillWidth: true }

                Spotify {
                    id: spotifyModule
                    Layout.alignment: Qt.AlignVCenter
                }

		Item { Layout.fillWidth: true }

		SystemStats { Layout.alignment: Qt.AlignVCenter }

                Text {
		    id: dateTimeText
		    text: Qt.formatDateTime(new Date(), "MMM d  h:mm AP")
		    color: accent
		    font.family: "open sans"
		    font.pixelSize: 14
		    font.bold: true

		    Timer {
			interval: 10000
			running: true
			repeat: true
			onTriggered: {
			    dateTimeText.text = Qt.formatDateTime(new Date(), "MMM d  h:mm AP")
			}
		    }
		}
            }
        }
    }
}
