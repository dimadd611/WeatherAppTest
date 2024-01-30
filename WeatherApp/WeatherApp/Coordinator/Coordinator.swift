
import Foundation
import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func showViewController()
}

class CoordinatorImp: Coordinator {
    
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showViewController() {
        let navigationController = UIStoryboard.instantiateViewController(WeatherViewController1.self,
                                                                          from: String(describing: WeatherViewController1.self))
        let viewModel = WeatherViewModelImp(coordinator: self)
        navigationController.viewModel = viewModel
        self.navigationController.pushViewController(navigationController, animated: false)
    }
    

    
}

