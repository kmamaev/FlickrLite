import Alamofire


class PhotosService {
    
    let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func searchPhotos(query: String, success: (([Photo]) -> ())?, failure: ((Error) -> ())? = nil) -> DataRequest? {
        
        func serverRequestSuccessHandler(response: SearchPhotosResponse) -> () {
            if let rawPhotos = response.rawPhotos {
                var photos: [Photo] = []
                for rawPhoto in rawPhotos {
                    let photo = Photo(rawPhoto: rawPhoto)
                    photos.append(photo)
                }
                success?(photos)
            }
        }
        
        return self.apiService.searchPhotos(query: query, success: serverRequestSuccessHandler, failure: failure)
        
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
