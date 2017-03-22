import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        let apiService = APIService()
        let photosService = PhotosService(apiService: apiService)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let photosBrowserNC = mainStoryboard.instantiateInitialViewController() as! UINavigationController
        let photosBrowserVC = photosBrowserNC.topViewController as! PhotosBrowserVC
        photosBrowserVC.photosService = photosService
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.rootViewController = photosBrowserNC
        
        self.window?.makeKeyAndVisible()
    
        return true
    }

}
