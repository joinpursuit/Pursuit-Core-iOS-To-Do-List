//
//  ItemDetailViewController.swift
//  ToDoList
//
//  Created by Alex Paul on 1/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

private enum EditMode: String {
  case edit = "Edit"
  case done = "Done"
  public func updateBarButtonTile() -> String {
    switch self {
    case .done:
      return "Edit"
    case .edit:
      return "Done"
    }
  }
}

class ItemDetailViewController: UIViewController {
  @IBOutlet weak var itemTitleTextView: UITextView!
  @IBOutlet weak var itemDescriptionTextView: UITextView!
  
  public var item: Item!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    updateTextViewEditingState(isEditingItem: false)
  }
  
  private func updateUI() {
    itemTitleTextView.text = item.title
    itemDescriptionTextView.text = item.description
  }
  
  @IBAction func editItem(_ sender: UIBarButtonItem) {
    updateRightBarItem(editMode:  EditMode.edit)
    updateTextViewEditingState(isEditingItem: true)
  }
  
  private func updateRightBarItem(editMode: EditMode) {
    switch editMode {
    case .edit:
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing))
    case .done:
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItem(_:)))
    }
  }
  
  @objc private func doneEditing() {
    updateRightBarItem(editMode:  EditMode.done)
    updateTextViewEditingState(isEditingItem: false)
    guard let itemTitle = itemTitleTextView.text,
      let itemDescription = itemDescriptionTextView.text else {
        print("itemTitle, itemDescription is nil")
        return
    }
    // modified date
    let date = Date()
    let isoDateFormatter = ISO8601DateFormatter()
    isoDateFormatter.formatOptions = [.withFullDate, .withInternetDateTime, .withTimeZone, .withDashSeparatorInDate]
    let modifiedTimestamp = isoDateFormatter.string(from: date)
    let updatedItem = Item.init(title: itemTitle, description: itemDescription, createdAt: modifiedTimestamp)
    
    // find item index and update to documents directory
    let index = ItemModel.getItems().firstIndex { $0 == item }
    if let itemIndex = index {
      ItemModel.updateItem(updatedItem: updatedItem, atIndex: itemIndex)
    }
  }
  
  private func updateTextViewEditingState(isEditingItem: Bool) {
    if isEditingItem {
      itemTitleTextView.isEditable = true
      itemDescriptionTextView.isEditable = true
      itemTitleTextView.becomeFirstResponder()
    } else {
      itemTitleTextView.isEditable = false
      itemDescriptionTextView.isEditable = false
    }
  }
}
