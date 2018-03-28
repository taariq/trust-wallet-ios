// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import UIKit

protocol AddCustomNetworkCoordinatorDelegate: class {
    func didAddNetwork(network: CustomRPC, in coordinator: AddCustomNetworkCoordinator)
    func didCancel(in coordinator: AddCustomNetworkCoordinator)
}

class AddCustomNetworkCoordinator: Coordinator {
    let navigationController: UINavigationController
    var coordinators: [Coordinator] = []
    weak var delegate: AddCustomNetworkCoordinatorDelegate?

    lazy var addNetworkItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(addNetwork)
        )
    }()

    lazy var cancelItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel)
        )
    }()

    lazy var addCustomNetworkController: AddCustomNetworkViewController = {
        let controller = AddCustomNetworkViewController()
        controller.navigationItem.rightBarButtonItem = addNetworkItem
        controller.navigationItem.leftBarButtonItem = cancelItem
        return controller
    }()

    let rpcStore: RPCStore

    init(
        navigationController: UINavigationController = NavigationController(),
        rpcStore: RPCStore
    ) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.rpcStore = rpcStore
    }

    func start() {
        navigationController.viewControllers = [addCustomNetworkController]
    }

    @objc func addNetwork() {
        addCustomNetworkController.addNetwork { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let network):
                self.delegate?.didAddNetwork(network: network, in: self)
            case .failure: break
            }
        }
    }

    @objc func cancel() {
        self.delegate?.didCancel(in: self)
    }
}
