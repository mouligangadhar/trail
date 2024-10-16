'''
 Copyright (C) 2024  mouli

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 3.

 smartxpenses is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''

import csv
import pyotherside

class ItemModel:
    def __init__(self):
        self.items = []  # List to store expense items
        self.total_amount = 0.0  # Initialize total amount

    def add_item(self, item_name, item_amount):
        """Add a new item to the list."""
        try:
            item_amount = float(item_amount)  # Convert amount to float
            if item_name and item_amount > 0:
                self.items.append({'itemName': item_name, 'itemAmount': item_amount})
                self.calculate_total()  # Update total amount after adding
                return True  # Indicate successful addition
            else:
                return False  # Invalid data
        except ValueError:
            return False  # Error in conversion to float

    def remove_item(self, index):
        """Remove an item from the list by index."""
        if 0 <= index < len(self.items):
            del self.items[index]
            self.calculate_total()  # Update total amount after removing
            return True  # Indicate successful removal
        return False  # Invalid index

    def save_to_csv(self, filepath='expenses.csv'):
        """Save the items to a CSV file."""
        try:
            with open(filepath, mode='w', newline='') as csvfile:
                fieldnames = ['Item Name', 'Item Amount']
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()
                for item in self.items:
                    writer.writerow({'Item Name': item['itemName'], 'Item Amount': item['itemAmount']})
            return True  # Indicate successful save
        except IOError:
            return False  # Error during file write operation

    def calculate_total(self):
        """Calculate the total amount of items."""
        self.total_amount = sum(item['itemAmount'] for item in self.items)
        pyotherside.send('totalAmountChanged', self.total_amount)  # Emit signal to QML
        return self.total_amount  # Return total amount for UI update

    def get_total_amount(self):
        """Get the current total amount for UI binding."""
        return self.total_amount

    def get_items_model(self):
        """Return the list of items as a model for QML."""
        return self.items

    def get_item_count(self):
        """Return the number of items in the list."""
        return len(self.items)

# Create an instance of ItemModel
item_model = ItemModel()

# Expose methods to QML
def addItem(item_name, item_amount):
    if item_model.add_item(item_name, item_amount):
        pyotherside.send('itemAdded', True)
    else:
        pyotherside.send('itemAdded', False)

def removeItem(index):
    if item_model.remove_item(index):
        pyotherside.send('itemRemoved', True)
    else:
        pyotherside.send('itemRemoved', False)

def saveToCSV(filepath='expenses.csv'):
    if item_model.save_to_csv(filepath):
        pyotherside.send('csvSaved', True)
    else:
        pyotherside.send('csvSaved', False)

def calculateTotal():
    return item_model.calculate_total()

def getTotalAmount():
    return item_model.get_total_amount()

def getItemsModel():
    """Return the items model to be used in the QML ListView and TableView."""
    return item_model.get_items_model()

def getItemCount():
    """Return the number of items for the table view."""
    return item_model.get_item_count()

