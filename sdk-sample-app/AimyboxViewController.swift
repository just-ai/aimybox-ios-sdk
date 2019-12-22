//
//  AimyboxViewController.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 22.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit
import AimyboxCore
import AimyboxDialogAPI

public class AimyboxViewController: UIViewController {
    
    @IBOutlet public var tableView: UITableView!
    
    var viewModel = AimyboxViewModel()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.dataSource = viewModel
        tableView?.estimatedRowHeight = 600
        tableView?.rowHeight = UITableView.automaticDimension
        tableView.register(AimyboxTextCell.nib, forCellReuseIdentifier: AimyboxTextCell.identifier)
        tableView.register(AimyboxButtonsCell.nib, forCellReuseIdentifier: AimyboxButtonsCell.identifier)
        tableView.register(AimyboxImageCell.nib, forCellReuseIdentifier: AimyboxImageCell.identifier)
        tableView.register(AimyboxQueryCell.nib, forCellReuseIdentifier: AimyboxQueryCell.identifier)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.items.append(AimyboxViewModel.QueryItem(text: "Pivet"))
            self.tableView.reloadData()
        }
    }
}

public enum AimyboxViewModelItemType {
    case text
    case query
    case buttons
    case image
}

public protocol AimyboxViewModelItem {
    var type: AimyboxViewModelItemType { get }
    var rowCount: Int { get }
}

public class AimyboxViewModel: NSObject {
    
    public var items: [AimyboxViewModelItem] = [
        AimyboxViewModel.TextItem(
            text: AimyboxTextReply(text: "Text #1", tts: nil, language: nil)
        ),
        AimyboxViewModel.ButtonsItem(
            buttons: AimyboxButtonsReply(buttons: [AimyboxButton(text: "blaaaa #1", url: nil),
                                                   AimyboxButton(text: "blaaaa #2", url: nil),
                                                   AimyboxButton(text: "blaaaa #3", url: nil),
                                                   AimyboxButton(text: "blaaaa #4", url: nil),
                                                   AimyboxButton(text: "blaaaa #5", url: nil)]
            )
        ),
        AimyboxViewModel.ImageItem(
            image: AimyboxImageReply(url: URL(string: "https://248305.selcdn.ru/zfl_prod/348909/348912/xjK2scB5dorpSjPf.jpg")!)
        ),
        AimyboxViewModel.TextItem(
            text: AimyboxTextReply(text: "Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2", tts: nil, language: nil)
        ),
        AimyboxViewModel.ButtonsItem(
            buttons: AimyboxButtonsReply(buttons: [AimyboxButton(text: "blaaaa #1", url: nil),
                                                   AimyboxButton(text: "blaaaa #2", url: nil),
                                                   AimyboxButton(text: "blaaaa #3", url: nil)]
            )
        ),
        AimyboxViewModel.TextItem(
            text: AimyboxTextReply(text: "Text #3 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2Text #3 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2Text #3 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2Text #3 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2 Text #2", tts: nil, language: nil)
        ),
        AimyboxViewModel.ButtonsItem(
            buttons: AimyboxButtonsReply(buttons: [AimyboxButton(text: "blaaaa #1", url: nil),
                                                   AimyboxButton(text: "blaaaa #2", url: nil),
                                                   AimyboxButton(text: "blaaaa #3", url: nil),
                                                   AimyboxButton(text: "blaaaa #4", url: nil)]
            )
        ),
        AimyboxViewModel.ButtonsItem(
            buttons: AimyboxButtonsReply(buttons: [AimyboxButton(text: "blaaaa #1", url: nil),
                                                   AimyboxButton(text: "blaaaa #2", url: nil)]
            )
        ),
        AimyboxViewModel.ImageItem(
            image: AimyboxImageReply(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg")!)
        )
    ]
}

extension AimyboxViewModel: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .text:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxTextCell.identifier, for: indexPath) as? AimyboxTextCell {
                cell.item = item
                return cell
            }
        case .buttons:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxButtonsCell.identifier, for: indexPath) as? AimyboxButtonsCell {
                cell.item = item
                return cell
            }
        case .image:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxImageCell.identifier, for: indexPath) as? AimyboxImageCell {
                cell.item = item
                return cell
            }
        case .query:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxQueryCell.identifier, for: indexPath) as? AimyboxQueryCell {
                cell.item = item
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

public extension AimyboxViewModel {

    class TextItem: AimyboxViewModelItem {
        
        public let type: AimyboxViewModelItemType
        
        public let rowCount: Int
        
        public let text: String
        
        public init(text reply: TextReply) {
            self.rowCount = 1
            self.type = .text
            self.text = reply.text
        }
    }
    
    class ButtonsItem: AimyboxViewModelItem {
        
        public let type: AimyboxViewModelItemType
        
        public let rowCount: Int
        
        public let buttons: [Button]
        
        public let onButtonTap: (Button)->()
        
        public init(buttons reply: ButtonsReply, onButtonTap: @escaping (Button)->() = { button in print(String(describing: button.text)) }) {
            self.rowCount = 1
            self.type = .buttons
            self.buttons = reply.buttons
            self.onButtonTap = onButtonTap
        }
    }
    
    class ImageItem: AimyboxViewModelItem {
        
        public let type: AimyboxViewModelItemType
        
        public let rowCount: Int
        
        public let image: URL
        
        public init(image reply: ImageReply) {
            self.type = .image
            self.rowCount = 1
            self.image = reply.url
        }
    }
    
    class QueryItem: AimyboxViewModelItem {
        
        public let type: AimyboxViewModelItemType
        
        public let rowCount: Int
        
        public let text: String
        
        public init(text query: String) {
            self.rowCount = 1
            self.type = .query
            self.text = query
        }
    }
}
