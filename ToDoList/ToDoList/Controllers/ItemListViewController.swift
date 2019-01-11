//
//  ViewController.swift
//  ToDoList
//
//  Created by Alex Paul on 1/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    print(DataPersistenceManager.documentsDirectory())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // NOT BEST PRACTICES
    // Custom delegation would be best use case here .....
    tableView.reloadData()
  }
}

extension ItemListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ItemModel.getItems().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let item = ItemModel.getItems()[indexPath.row]
    cell.textLabel?.text = item.title
    cell.detailTextLabel?.text = item.dateFormattedString
    return cell
  }
}

extension ItemListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let item = ItemModel.getItems()[indexPath.row]
    ItemModel.delete(item: item, atIndex: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .fade)
  }
}

