//
//  ViewController.swift
//  TodoTaskUIKit
//
//  Created by Amelie Pocchiolo on 15/02/2024.
//

import UIKit

class ViewController: UIViewController, PresenterProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var presenter = Presenter(presenterProtocol: self)
    var tasks: [RecordTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        presenter.getTasks()
    }
    
    func getAllTask(tasks: [RecordTask]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func deleteTask(at indexPath: IndexPath, recordId: String) {
        DispatchQueue.main.async {
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.label.text = tasks[indexPath.row].fields.task
        cell.priorityLabel.text = tasks[indexPath.row].fields.priority.rawValue
        
        if let isDone = tasks[indexPath.row].fields.done {
            cell.isDone.isOn = isDone
        } else {
            // valeur par défaut
            cell.isDone.isOn = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recordId = tasks[indexPath.row].id
            presenter.deleteTask(with: indexPath, recordId: recordId)
        }
    }
}
