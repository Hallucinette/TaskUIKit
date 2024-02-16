//
//  Presenter.swift
//  TodoTaskUIKit
//
//  Created by Amelie Pocchiolo on 15/02/2024.
//

import Foundation

class Presenter {
    let presenterProtocol: PresenterProtocol?
    let service = TaskService()
    
    init(presenterProtocol: PresenterProtocol?) {
        self.presenterProtocol = presenterProtocol
    }
    
    func getTasks() {
        service.getRecords { tasks, error in
            guard let tasks = tasks else {
                return
            }
            self.presenterProtocol?.getAllTask(tasks: tasks)
        }
    }
    
    func deleteTask(with indexPath: IndexPath, recordId: String) {
        service.deleteTask(withID: recordId) { [weak self] error in
            guard self != nil else { return }
        }
        self.presenterProtocol?.deleteTask(at: indexPath, recordId: recordId)
    }
}

protocol PresenterProtocol {
    func getAllTask(tasks: [RecordTask])
    func deleteTask(at indexPath: IndexPath, recordId: String)
}
