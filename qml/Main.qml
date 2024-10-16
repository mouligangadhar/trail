/*
 * Copyright (C) 2024  mouli
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * smartxpenses is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import io.thp.pyotherside 1.4
import QtQuick.Controls 2.7

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'smartxpenses.mouli'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    PageStack {
        id: pageStack

        // First Page: For adding items and viewing the list
        Page {
            id: firstPage
            anchors.fill: parent

            header: PageHeader {
                id: header
                title: i18n.tr('Expenses Reporting App')
               
            }
            
            // Center the Column in the Page
            Column {
                anchors.centerIn: parent  // Center the entire Column within the Page
                spacing: units.gu(2)

                // Input for item name
                TextField {
                    id: itemNameInput
                    placeholderText: i18n.tr("Item Name")
                    color: "black"
                    width: units.gu(30)  // Set a width for better appearance
                }

                // Input for item amount
                TextField {
                    id: itemAmountInput
                    placeholderText: i18n.tr("Item Amount (in ₹)")
                    color: "black"
                    inputMethodHints: Qt.ImhDigitsOnly
                    width: units.gu(30)  // Set a width for better appearance
                }

                // Warning Label for missing input
                Label {
                    id: warningLabel
                    text: ""
                    color: "red"
                    visible: false
                }

                // Row for Add and Save buttons
                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter  // Center the row

                    // Add Button
                    Button {
                        text: i18n.tr("Add")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5  // Rounded corners
                        }
                        onClicked: {
                            if (itemNameInput.text === "" || itemAmountInput.text === "") {
                                warningLabel.text = i18n.tr("Please fill in both the Item Name and Item Amount.")
                                warningLabel.visible = true
                            } else {
                                python.call('example.addItem', [itemNameInput.text, itemAmountInput.text], function() {
                                    itemNameInput.text = ""
                                    itemAmountInput.text = ""
                                    warningLabel.visible = false

                                    // Refresh items model after adding an item
                                    python.call('example.getItemsModel', [], function(result) {
                                        itemsModel = result;
                                    })
                                })
                            }
                        }
                    }

                    // Save Button
                    Button {
                        text: i18n.tr("Save")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5  // Rounded corners
                        }
                        onClicked: {
                            python.call('example.saveToCSV', [], function() {
                                console.log("Data saved to CSV.");
                            })
                        }
                    }
                }

                // Row for Total and Share buttons
                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter  // Center the row

                    // Total Button
                    Button {
                        id: totalButton
                        text: i18n.tr("Total: ₹ 0.00")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5  // Rounded corners
                        }
                        onClicked: {
                            python.call('example.calculateTotal', [], function(result) {
                                totalButton.text = i18n.tr("Total: ₹ ") + result.toFixed(2);
                            })
                        }
                    }
                }
                Row {
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter
                    // Navigation Button to go to the Item Table Page
                    Button {
                        text: i18n.tr("View Table")
                        background: Rectangle {
                            color: "skyblue"
                            radius: 5  // Rounded corners
                        }
                        onClicked: {
                            pageStack.push(itemTablePage)
                        }
                    }
                }
            }
        }

        // Table view page for items
        Component {
            id: itemTablePage
            ItemTablePage {
                id: tablePage
            }
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src/'));

            importModule('example', function() {
                console.log("Python module loaded");
            });

            python.call('example.getItemsModel', [], function(model) {
                itemsModel = model;
            });
        }

        onError: {
            console.log("Python error: " + traceback);
        }
    }

    // Global property for the item model
    property var itemsModel: null

    Connections {
        target: python
        onTotalAmountChanged: function(value) {
            totalButton.text = i18n.tr("Total: ₹ ") + value.toFixed(2);
        }
    }
}


