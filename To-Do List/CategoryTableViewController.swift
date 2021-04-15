//
//  CategoryTableViewController.swift
//  To-Do List
//
//  Created by Александр Кудряшов on 10.04.2021.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var categoryArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
//расположение файла сохранения базы данных
//        print(print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)))
        loadCategory()
        navigationController?.delegate = self

    }

    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        //Создание новой категории
        let vc = storyboard?.instantiateViewController(identifier: "newCategoryVC") as! CategoryViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Data Sourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            let category = categoryArray[indexPath.row]
            cell.textLabel?.text = category.name
            return cell
        }
    
    //Удаление категории
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            self.saveCategory()
            tableView.reloadData()
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func loadCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error request load Category \(error)")
        }
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch  {
            print("Error save contex\(error)")
        }
    }
    //MARK: - TableView Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ToDoVC") as! ToDoTableViewController
        vc.selectedCategory = categoryArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    //MARK: NavigationController Delegate
    func navigationController(_: UINavigationController, didShow: UIViewController, animated: Bool){
        loadCategory()
        tableView.reloadData()
    }
    




    
    
}

    
