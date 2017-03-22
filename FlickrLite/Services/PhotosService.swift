import Alamofire


class PhotosService {
    
    static let itemsPerPage = 100
    
    var isLoading = false
    var allPhotosLoaded = false
    var query: String?
    var pageIndex: Int?
    
    var photos: [Photo] = []
    
    private let apiService: APIService
    private let storageService: StorageService
    
    init(apiService: APIService, storageService: StorageService) {
        self.apiService = apiService
        self.storageService = storageService
        self.photos = self.storageService.storedPhotos()
    }
    
    func searchPhotos(query: String, pageIndex: Int? = nil, success: ((CountableRange<Int>) -> ())?, failure: ((Error) -> ())? = nil) -> DataRequest? {
        
        let isNewSearch = pageIndex == nil
        
        self.isLoading = true
        self.query = query
        self.pageIndex = pageIndex ?? 1
        if isNewSearch {
            self.allPhotosLoaded = false
        }
        
        let successHandler = { [unowned self] (response: SearchPhotosResponse) -> () in
            if let rawPhotos = response.rawPhotos {
                if isNewSearch {
                    self.storageService.clearPhotos()
                    self.photos.removeAll()
                }
            
                var loadedPhotos: [Photo] = []
                for rawPhoto in rawPhotos {
                    let photo = Photo(rawPhoto: rawPhoto)
                    loadedPhotos.append(photo)
                }
                let startIndex = self.photos.count
                let endIndex = startIndex + loadedPhotos.count
                let range = startIndex..<endIndex
                if loadedPhotos.count < PhotosService.itemsPerPage {
                    self.allPhotosLoaded = true
                }
                
                self.photos.append(contentsOf: loadedPhotos)
                self.storageService.savePhotos(loadedPhotos)
                
                success?(range)
            }
            self.isLoading = false
        }
        
        let failureHandler = { [unowned self] (error: Error) -> () in
            self.isLoading = false
            failure?(error)
        }
        
        return self.apiService.searchPhotos(query: query, pageIndex: self.pageIndex, success: successHandler, failure: failureHandler)
        
    }
    
    func loadNextPageIfNeeded(success: ((CountableRange<Int>) -> ())?, failure: ((Error) -> ())? = nil) -> DataRequest? {
        guard (self.isLoading == false) && (self.allPhotosLoaded == false) else {
            return nil
        }
    
        let nextPageIndex = self.pageIndex! + 1
        print("loading next page index \(nextPageIndex) ...")
        return self.searchPhotos(query: self.query!, pageIndex: nextPageIndex, success: success, failure: failure)
    }
    
    func loadImage(photo: Photo, success: (() -> ())?, failure: ((Error) -> ())? = nil) -> DataRequest? {
        guard photo.url != nil else {
            failure?(PhotosService.loadImageError())
            return nil
        }
        
        return Alamofire.request(photo.url!).responseImage { response in
            if let image = response.result.value {
                photo.image = image
                success?()
            }
            else {
                failure?(PhotosService.loadImageError())
            }
        }
        
    }
    
    private static func loadImageError() -> Error {
        let error = NSError(domain:"FlickrLite.images", code:-101, userInfo:nil)
        return error
    }
    
}
