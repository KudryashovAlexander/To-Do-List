//
//  ViewController.swift
//  To-Do List
//
//  Created by Александр Кудряшов on 10.04.2021.
//

import UIKit

class TaskViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var taskNotesTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//MARK: - Methods
    @IBAction func savePressedButton(_ sender: UIBarButtonItem) {
        if let text = taskNameTextField.text {
            let newItem = Item(context: self.context)
            newItem.text = text
            newItem.done = false
            if let notes = taskNotesTextField.text {
                newItem.notes = notes
            }
            newItem.parentCategory = selectedCategory
            
            saveItem()
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    //Сохранение данных
    func saveItem() {
        do {
            try context.save()
        } catch  {
            print("Error save contex\(error)")
        }
    }
}

