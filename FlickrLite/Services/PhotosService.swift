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
    
    
    
}
