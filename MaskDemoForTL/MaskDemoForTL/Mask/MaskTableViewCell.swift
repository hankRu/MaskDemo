//
//  MaskTableViewCell.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import UIKit

class MaskTableViewCell: UITableViewCell, CellConfigurable {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var maskAdultLabel: UILabel!
    
    func setup(viewModel: RowViewModel) {
        guard let viewModel = viewModel as? Feature else { return }
        self.nameLabel.text = "藥局: " + viewModel.properties.name
        self.addressLabel.text = "地址: " + viewModel.properties.address
        self.phoneLabel.text = "電話: " + viewModel.properties.phone
        self.maskAdultLabel.text = "成人口罩數量: " + "\(viewModel.properties.maskAdult)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderView.layer.cornerRadius = 4
        self.borderView.layer.borderColor = UIColor.black.cgColor
        self.borderView.layer.borderWidth = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
