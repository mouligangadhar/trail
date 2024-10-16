import QtQuick 2.7
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.3
import io.thp.pyotherside 1.4

Page {
    id: itemTablePage
    width: parent.width
    height: parent.height
    anchors.fill: parent

    // Header for the table
    Text {
        id: header
        text: "Items Table"
        font.bold: true
        font.pointSize: 20
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 10
    }

    Column {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        spacing: 10
        padding: 10

        // Table header with Item Name, Item Amount, and Action labels
        GridLayout {
            columns: 3
            rowSpacing: 10
            columnSpacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9  // Use 90% of the parent's width

            Label { 
                text: "Item Name"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter  // Center horizontally
            }
            Label { 
                text: "Item Amount"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter  // Center horizontally
            }
            Label { 
                text: "Action"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter  // Center horizontally
            }
        }

        // Repeater to display the list of items from the itemsModel
        Repeater {
            model: itemsModel

            GridLayout {
                columns: 3
                rowSpacing: 10
                columnSpacing: 20
                width: parent.width * 0.9  // Use 90% of the parent's width

                // Item Name
                Text { 
                    text: modelData.itemName
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter  // Center both horizontally and vertically
                }

                // Item Amount
                Text { 
                    text: "₹ " + modelData.itemAmount 
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter  // Center both horizontally and vertically
                }

                // Delete button with bin image
                Button {
                    background: Rectangle {
                        color: "transparent"  // No background for the button itself
                    }
                    padding: 8
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter  // Center both horizontally and vertically
                    Image {
                        source: "/home/vboxuser/smartxpenses/assets/delete.png"  // Path to your delete bin image
                        width: 24
                        height: 24
                    }
                    onClicked: {
                        python.call('example.removeItem', [index], function() {
                            // Refresh the model after deletion
                            python.call('example.getItemsModel', [], function(result) {
                                itemsModel = result;  // Update itemsModel after deleting an item
                            });
                        });
                    }
                }
            }
        }

        Row {
            spacing: units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter

            // Custom styled Back button
            Button {
                text: "Back"
                background: Rectangle {
                    color: "#87CEFA"
                    radius: 10  // Rounded corners
                }
                font.bold: true
                font.pixelSize: 16
                padding: 10
                onClicked: {
                    pageStack.pop();
                }
            }

            // Custom styled Share button
            Button {
                text: "Share"
                background: Rectangle {
                    color: "green"
                    radius: 10  // Rounded corners
                }
                font.bold: true
                font.pixelSize: 16
                padding: 10
                onClicked: {
                    console.log("Share functionality to be implemented");
                }
            }
        }
    }
}
