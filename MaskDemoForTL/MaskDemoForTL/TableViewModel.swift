//
//  TableViewModel.swift
//  ZXFast_iOS
//
//  Created by Hank Lu on 2019/10/8.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import UIKit

protocol RowViewModel {
    
}

protocol CellConfigurable {
    func setup(viewModel: RowViewModel)
}
