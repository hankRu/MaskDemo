//
//  MaskTableViewController.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import UIKit

class MaskTableViewController: UITableViewController {
    
    lazy var vm: MaskViewModel = {
        return MaskViewModel()
    }()
    
    deinit {
        CategoryInfo.shared.didChangeCategory.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        viewModelDataBinding()
        initTableView()
    }
    
    private func viewModelDataBinding() {
        vm.reloadData.addObserver { [unowned self] (value) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.backgroundView?.isHidden = self.vm.filterModels.count > 0
            }
        }
        
        vm.isLoading.addObserver { (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    FCLoadingDialog.shared.presentInWindow()
                } else {
                    FCLoadingDialog.shared.dismissSelf()
                }
            }
        }
        
        CategoryInfo.shared.didChangeCategory.addObserver(target: self) { [unowned self] (index) in
            self.vm.filterData(category: CategoryInfo.shared.areaPkidArray[index], completion: { (aera) in
                self.navigationItem.title = aera
            })
        }
        
        vm.initFetch()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.filterModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowViewModel = vm.filterModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MaskTableViewCell.className, for: indexPath)
        if let newsCell = cell as? CellConfigurable {
            newsCell.setup(viewModel: rowViewModel)
        }
        return cell
    }
}

extension MaskTableViewController {
    
    private func initUI() {
        navigationItem.title = "全台"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: MaskTableViewCell.className, bundle: nil), forCellReuseIdentifier: MaskTableViewCell.className)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.setEmptyMessage("很抱歉，目前無資料")
        tableView.backgroundView?.isHidden = true
    }
}
