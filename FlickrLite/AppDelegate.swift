import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
#if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL!)
#endif
    
        let apiService = APIService()
        let storageService = StorageService()
        let photosService = PhotosService(apiService: apiService, storageService: storageService)
        
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
