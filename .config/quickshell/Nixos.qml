import QtQuick 6.6
import Quickshell
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: nixosRoot
    width: logoRow.width
    height: 24

    property string nixVersion: ""
    property string nixGen: ""
    property string nixProfile: ""

    Process {
        command: ["sh", Qt.resolvedUrl("./scripts/nix_version.sh").toString().replace("file://", "")]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const json = JSON.parse(data);
                nixVersion = json.version;
                nixGen = json.gen;
                nixProfile = json.profile;
            }
        }
    }

    Row {
        id: logoRow
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: "" 
            font.pixelSize: 18
            color: accent
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: versionLabel.visible = true
                onExited: versionLabel.visible = false
                onClicked: nixMenu.open()
            }
        }

        Text {
            id: versionLabel
            visible: false
            // Exemplo de saída: 24.11 (gen 152 - main)
            text: nixVersion + " (gen " + nixGen + " - " + nixProfile + ")"
            color: accent
            font.family: "Noto Sans"
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    // Menu mantido conforme anterior, usando Kitty
    Menu {
        id: nixMenu
        y: parent.height + 10
        background: Rectangle {
            implicitWidth: 180
            color: bg
            border.color: accent
            radius: 5
        }

        delegate: MenuItem {
            id: menuItem
            contentItem: Text {
                text: menuItem.text
                font.family: "Noto Sans"
                font.bold: true
                color: menuItem.highlighted ? bg : accent
            }
            background: Rectangle {
                color: menuItem.highlighted ? accent : "transparent"
            }
        }

        Action { text: "Switch"; onTriggered: switcher.run("sudo nixos-rebuild switch") }
        Action { text: "Switch Profile"; onTriggered: switcher.run("sudo nixos-rebuild switch --profile-name main") }
        Action { text: "Collect Garbage"; onTriggered: switcher.run("sudo nix-collect-garbage -d") }
    }

    Process {
        id: switcher
        function run(cmd) {
            command = ["kitty", "sh", "-c", cmd + "; echo 'Processo finalizado. Pressione Enter para fechar.'; read"];
            running = true;
        }
    }
}
