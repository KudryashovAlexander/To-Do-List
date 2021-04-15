//
//  ViewController.swift
//  To-Do List
//
//  Created by Александр Кудряшов on 10.04.2021.
//

import UIKit

class TaskViewController: UIViewController {
    
    
    @IBOutlet weak var taskNameTextField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func savePressedButton(_ sender: UIBarButtonItem) {
        if let text = taskNameTextField.text {
            let newItem = Item(context: self.context)
            newItem.text = text
            newItem.done = false
            newItem.parentCategory = selectedCategory
            
            saveCategory()
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    //Сохранение данных
    func saveCategory() {
        do {
            try context.save()
        } catch  {
            print("Error save contex\(error)")
        }
    }
}

