//
//  ToDoTableViewController.swift
//  To-Do List
//
//  Created by Александр Кудряшов on 10.04.2021.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        title = selectedCategory?.name
        navigationController?.delegate = self
    }

    //MARK: - Pressed save button
    @IBAction func addPressedButton(_ sender: UIBarButtonItem) {
        if let category = self.selectedCategory {
        let vc = storyboard?.instantiateViewController(identifier: "TaskVC") as! TaskViewController
           vc.selectedCategory = category
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Error let category")
        }
    }
    
    // MARK: - Data Sourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.text
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    
    //MARK: - Data Sourse methods
    //сохранение в память
    func saveItem() {
        do{
            try context.save()
        } catch {
            print("Error save Item \(error)")
        }
    }
    
    //3.4 Загружаем данные из памяти Persistant Container
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error request context")
        }
        tableView.reloadData()
    }
}

//MARK:- Extension SearchBar
extension ToDoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //Используем NSPredicete - как данные должны быть извечены или отфильтрованы
        let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        
        //Отфильтруем параметры запроса
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        
        //Обновляем табличное представление
       loadItems(with: request, predicate: predicate)
        
    }
    
    //Метод возврата табличного представления
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
//MARK: - NavigationController Delegate
extension ToDoTableViewController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController, didShow: UIViewController, animated: Bool){
        loadItems()
        tableView.reloadData()
    }
}
