//
//  TabContainerController.swift
//  iOS
//
//  Created by Chris Li on 1/10/18.
//  Copyright © 2018 Chris Li. All rights reserved.
//

import UIKit

class TabContainerController: UIViewController {
    private(set) var webController: (UIViewController & WebViewControls)? = nil
    private let welcomeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeController") as! WelcomeController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChildController(controller: welcomeController)
    }
    
    private func configureChildController(controller: UIViewController) {
        view.subviews.forEach({ $0.removeFromSuperview() })
        childViewControllers.forEach({ $0.removeFromParentViewController() })
        
        view.addSubview(controller.view)
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: controller.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: controller.view.rightAnchor),
            view.topAnchor.constraint(equalTo: controller.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)])
        controller.didMove(toParentViewController: self)
    }
    
    func load(url: URL) {
        if let controller = webController {
            controller.load(url: url)
        } else {
            let controller: (UIViewController & WebViewControls) = {
                if #available(iOS 11.0, *) {
                    return WebKitWebController()
                } else {
                    return LegacyWebController()
                }
            }()
            webController = controller
            configureChildController(controller: controller)
            load(url: url)
        }
    }
}

protocol WebViewControls {
    var canGoBack: Bool {get}
    var canGoForward: Bool {get}
    
    func goBack()
    func goForward()
    func load(url: URL)
}

protocol TabControllerDelegate: class {
    func webViewDidFinishLoad(controller: WebViewControls)
}
