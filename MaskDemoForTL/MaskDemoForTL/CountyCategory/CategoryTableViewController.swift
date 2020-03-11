//
//  CategoryTableViewController.swift
//  StrayAnimals
//
//  Created by Hank Lu on 2019/12/2.
//  Copyright © 2019 Minhan Ru. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var currentSelectedIndexPaths: [Int: IndexPath] =
        [0: IndexPath(item: 0, section: 0),
         1: IndexPath(item: 0, section: 1),
         2: IndexPath(item: 0, section: 2),
         3: IndexPath(item: 0, section: 3)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "分類"
        tableView.register(CategoryTableCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.bounces = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return CategoryInfo.shared.categoryInfos.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryInfo.shared.categoryInfos[section].count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CategoryInfo.shared.didChangeCategory.value = indexPath.row
        let preSelectedIndexPath = currentSelectedIndexPaths[indexPath.section]!
        currentSelectedIndexPaths.updateValue(indexPath, forKey: indexPath.section)
        tableView.reloadRows(at: [preSelectedIndexPath], with: .none)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableCell
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = CategoryInfo.shared.categoryInfos[indexPath.section][indexPath.row]
        default:
            break
        }
        
        if indexPath == currentSelectedIndexPaths[indexPath.section] {
            cell.accessoryType = .checkmark
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor.systemGray6
            } else {
                cell.backgroundColor = UIColor(white: 0.9, alpha: 1)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let sectionHeaderView = view as? UITableViewHeaderFooterView else {
            return
        }
        sectionHeaderView.textLabel?.font = UIFont(name: "Futura", size: 19)
        sectionHeaderView.textLabel?.textColor = UIColor.white
        sectionHeaderView.backgroundView?.backgroundColor = UIColor.darkGray
        switch section {
        case 0:
            sectionHeaderView.textLabel?.text = "地區分類"
        default:
            sectionHeaderView.textLabel?.text = ""
        }
    }
}
