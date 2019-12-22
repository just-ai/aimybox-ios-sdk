//
//  AimyboxImageCell.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 22.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit

class AimyboxImageCell: UITableViewCell {
    /**
     Use this method to customize appearance of this cell.
     */
    public static var onAwakeFromNib: ((AimyboxImageCell) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        type(of: self).onAwakeFromNib?(self)
    }
    
    public var item: AimyboxViewModelItem? {
        didSet {
            guard let _item = item as? AimyboxViewModel.ImageItem else {
                return
            }
            
            let image = UIImage(data: try! Data(contentsOf: _item.image))!
            _imageView.image = image
            let ratio = image.size.width / image.size.height
            let newHeight = _imageView.frame.width / ratio
            
            _imageView.translatesAutoresizingMaskIntoConstraints = false
            let constraint = _imageView.heightAnchor.constraint(equalToConstant: newHeight)
            constraint.priority = UILayoutPriority(rawValue: 750)
            constraint.isActive = true
            _imageView.superview?.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var _imageView: UIImageView!
    
    // MARK: - Internals
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
