//
//  ViewController.swift
//  Hello Shared Kotlin
//
//  Created by Evan Tatarka on 12/20/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import UIKit
import KotlinHello

class ViewController: UIViewController, KotlinHelloSimpleStoreListener, UIAlertViewDelegate {
    @IBOutlet var todos: UITableView!
    @IBOutlet var add: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func add(_ sender: Any) {
        appStore.dispatch(action: KotlinHelloActionAdd(text: "new todo"))
    }
    
    var dataSource: TodosDataSource!
    var appStore: KotlinHelloAppStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appStore = KotlinHelloAppStore(db: AppDatabase())
        dataSource = TodosDataSource(store: appStore)
        todos.dataSource = dataSource
        todos.delegate = dataSource

        // Initialize Alert View
        let alertView = UIAlertView(title: "Alert", message: KotlinHelloHello().greet(name: "SHARED"), delegate: self, cancelButtonTitle: "Bah", otherButtonTitles: "Cool")

        // Configure Alert View
        alertView.tag = 1

        // Show Alert View
        alertView.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appStore.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        appStore.removeListener(listener: self)
    }
    
    func invoke(state: Any?) {
        invokeStore(state: (state as? KotlinHelloAppState)!)
    }
    
    func invokeStore(state: KotlinHelloAppState) {
        dataSource.set(state: state)
        countLabel.text = "\(state.undoneTodoCount)"
        todos.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class TodosDataSource : NSObject, UITableViewDataSource {
    let store: KotlinHelloAppStore
    var state: KotlinHelloAppState
    
    init(store: KotlinHelloAppStore) {
        self.store = store
        self.state = store.state
    }
    
    func set(state: KotlinHelloAppState) {
        self.state = state
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TodoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoTableViewCell
        cell.bind(store: store, state: state,index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.todos.count + 1
    }
}

extension TodosDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            [unowned self] (_, indexPath) in
                self.store.dispatch(action: KotlinHelloActionRemove(index: Int32(indexPath.row)))
        }
        
        return [deleteAction]
    }
}


