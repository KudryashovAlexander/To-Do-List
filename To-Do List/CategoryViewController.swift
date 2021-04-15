//
//  CategoryViewController.swift
//  To-Do List
//
//  Created by Александр Кудряшов on 11.04.2021.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var categoryNameTextField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func savePressedButton(_ sender: UIBarButtonItem) {
        if let text = categoryNameTextField.text {
            let newCategory = Category(context: self.context)
            newCategory.name = text
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
