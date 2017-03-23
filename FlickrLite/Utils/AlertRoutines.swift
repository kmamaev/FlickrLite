import UIKit


class AlertRoutines {
    
    static func showAlert(title: String, message: String, onViewController vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
}
