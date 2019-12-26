//
//  AimyboxButtonsCell.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 22.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit

class AimyboxUIButton: UIButton {
    
    public static var onInit: ((AimyboxUIButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        type(of: self).onInit?(self)
        addTarget(self, action:#selector(self.buttonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        type(of: self).onInit?(self)
        addTarget(self, action:#selector(self.buttonTap), for: .touchUpInside)
    }
    
    public var onButtonTap: (()->())?
    
    @objc func buttonTap() {
        onButtonTap?()
    }
}

var _next: [Int:UIColor] = [
    0:UIColor.green, 1:UIColor.red, 2:UIColor.blue, 3:UIColor.gray, 4:UIColor.purple
]

class AimyboxButtonsCell: UITableViewCell {
    /**
     Button height.
     */
    public var stackViewHeight: CGFloat = 44.0
    /**
     Distance between button rows.
     */
    public var stackVerticalSpacing: CGFloat = 0.0
    /**
     Max count of buttons in a row.
     */
    public var maxButtonCountInStackView: Int = 2
    /**
     Use this method to customize appearance of this cell.
     */
    public static var onAwakeFromNib: ((AimyboxButtonsCell) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        type(of: self).onAwakeFromNib?(self)
    }
    
    public var item: AimyboxViewModelItem? {
        didSet {
            guard let _item = item as? AimyboxViewModel.ButtonsItem else {
                return
            }
            
            var currentStackView: UIStackView = mainStackView
            var tmp = 0
            var limit = 0
            _item.buttons.forEach { button in
                if limit == maxButtonCountInStackView {
                    // Create new stack view
                    let oldStackView = currentStackView
                    currentStackView = newStackView(below: oldStackView)
                    createdStackViews.append(currentStackView)
                    limit = 0
                }
                
                let uiButton = AimyboxUIButton()
                uiButton.setTitle(button.text, for: .normal)
                uiButton.backgroundColor = _next[tmp]!
                uiButton.onButtonTap = {
                    _item.onButtonTap(button)
                }
                currentStackView.addArrangedSubview(uiButton)
                
                limit += 1
                tmp += 1
            }
            currentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }
    /**
     Stack view in which buttons are injected.
     */
    @IBOutlet weak var mainStackView: UIStackView!

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
    
    private var createdStackViews = [UIStackView]()
    
    private func newStackView(below view: UIView) -> UIStackView {
        let stackView = UIStackView(frame: mainStackView.bounds)
        stackView.alignment = mainStackView.alignment
        stackView.distribution = mainStackView.distribution
        stackView.axis = mainStackView.axis
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let topConstraint = stackView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: stackVerticalSpacing)
        topConstraint.priority = UILayoutPriority(rawValue: 750)
        topConstraint.isActive = true
        let heightConstraint = stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        heightConstraint.priority = UILayoutPriority(rawValue: 750)
        heightConstraint.isActive = true
        return stackView
    }
    
    override func prepareForReuse() {
        
        mainStackView.arrangedSubviews.forEach {
            mainStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let stackView = UIStackView()
        stackView.alignment = mainStackView.alignment
        stackView.distribution = mainStackView.distribution
        stackView.axis = mainStackView.axis
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        let constraint = stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        constraint.priority = UILayoutPriority(rawValue: 750)
        constraint.isActive = true
        
        mainStackView.removeFromSuperview()
        mainStackView = stackView
        
        createdStackViews.forEach { view in
            view.arrangedSubviews.forEach {
                view.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
        createdStackViews.removeAll()
        
        contentView.layoutIfNeeded()
    }
}
