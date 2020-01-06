import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import Synchro.Core 1.0
import "../synchrostyle"

Item {
    property var clientListModel: []

    id: synchronyPanel
    anchors.right: parent.right
    height: parent.height
    width: parent.width/4


    StackView {
        id: stack
        initialItem: connectScreen
        anchors.fill: parent
    }

    function connectToServer(ip) {
        let stringList = ip.split(":");
        if (stringList.length > 1)
        {
            synchronyController.connectToServer(stringList[0], stringList[1]);
        }
        synchronyController.sendCommand(4, [settings.name]);
        stack.push(connectedScreen);
    }

    Component {
        id: connectScreen

        ColumnLayout {
            ListView {
                id: serverList

                Layout.fillHeight: true
                Layout.fillWidth: true

                model: ServerListModel {}

                delegate: Item {
                    height: 32
                    width: parent.width

                    property var ipAddress: ip

                    Text {
                        id: nametext
                        color: "white"
                        font.pointSize: 12
                        text: name
                    }

                    Text {
                        id: iptext
                        topPadding: 16
                        color: "gray"
                        text: ip
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: serverList.currentIndex = index
                        onDoubleClicked: connectToServer(parent.ipAddress)
                    }

                }

                header: Item {
                    height: 30
                    width: parent.width
                    Text {
                        color: "white"
                        text: "Servers"
                        font.pointSize: 20
                    }
                }

                highlight: Component {
                    id: highlight
                    Rectangle {
                        width: 180; height: 40
                        color: Style.accentColorMiddle
                        radius: 1
                        y: serverList.currentItem.y
                        Behavior on y {
                            NumberAnimation {
                                duration: 250
                                easing.type: Easing.OutExpo
                            }
                        }
                    }
                }
            }
            Row {
                height: 40
                Layout.fillWidth: true
                Button {
                    id: directConnectButton
                    text: "Direct Connect"
                    width: parent.width/2
                    onPressed: stack.push(directConnectScreen)
                }
                Button {
                    id: connectButton
                    text: "Connect"
                    width: parent.width/2
                    onPressed: connectToServer(serverList.currentItem.ipAddress)
                }
            }
        }
    }
    
    Component {
        id: directConnectScreen
        Item {
            ColumnLayout {
                width: parent.width
                anchors.bottom: parent.bottom

                Text {
                    color: "white"
                    text: "Direct Connect"
                    font.pointSize: 20
                }

                TextField {
                    id: ipField
                    Layout.fillWidth: true
                    text: "0.0.0.0:32019"
                }
                Row {
                    Layout.fillWidth: true
                    Button {
                        id: directConnectButton
                        width: parent.width/2
                        text: "Back"
                        onPressed: stack.pop();
                    }

                    Button {
                        id: connectButton
                        width: parent.width/2
                        text: "Connect"
                        onPressed: connectToServer(ipField.text)
                    }
                }
            }
        }
    }

    Component {
        id: connectedScreen

        ColumnLayout {
            ListView {
                id: listOfClients
                
                Layout.fillHeight: true
                Layout.fillWidth: true

                model: clientListModel

                delegate: Item {
                    height: 20
                    width: parent.width
                    Text {
                        color: "white"
                        text: modelData
                    }
                }

                header: Item {
                    height: 30
                    width: parent.width
                    Text {
                        color: "white"
                        text: "Users: " + listOfClients.model.length
                        font.pointSize: 20
                    }
                }
            }
            
            Row {
                height: 40
                Layout.fillWidth: true
                Button {
                    text: "Disconnect"
                    width: parent.width
                    onPressed: {
                        stack.pop();
                        synchronyController.disconnect();
                        clientListModel = [];
                    }
                }
            }
        }
    }

}
