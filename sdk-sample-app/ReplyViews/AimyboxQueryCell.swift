//
//  AimyboxQueryCell.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 22.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit

class AimyboxQueryCell: UITableViewCell {
    /**
     Use this method to customize appearance of this cell.
     */
    public static var onAwakeFromNib: ((AimyboxQueryCell) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        type(of: self).onAwakeFromNib?(self)
    }
    
    public var item: AimyboxViewModelItem? {
        didSet {
            guard let _item = item as? AimyboxViewModel.QueryItem else {
                return
            }
            _textLabel.text = _item.text
        }
    }

    @IBOutlet weak var _textLabel: UILabel!
    
    // MARK: - Internals
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
}
