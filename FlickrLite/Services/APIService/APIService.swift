import Alamofire
import ObjectMapper


class APIService: NSObject {

    private static let apiKey = "edd1764201fc402e4ab9ec131c16c37f"
    private static let baseURLString = "https://api.flickr.com/services/rest/"
    private static let dataFormat = "json"
    private static let nojsoncallback = 1 // Need to force the api to return a raw JSON, with no function wrapper
    
    private func performTask<ResponseType>(_ apiTask: APITask<ResponseType>) -> DataRequest {
        
        APIService.decorateParametersForTask(apiTask)
        
        let request = Alamofire.request(APIService.baseURLString, method: apiTask.httpMethod, parameters: apiTask.parameters).responseJSON
            { response in
                print(response)
                switch response.result {
                    case .success(let value):
                        if let apiResponse = Mapper<APIResponse>().map(JSONObject: value) {
                            switch apiResponse.status {
                                case .ok:
                                    if let mappedResponse = Mapper<ResponseType>().map(JSONObject: value) {
                                        apiTask.success?(mappedResponse)
                                    }
                                    else {
                                        apiTask.failure?(APIService.mappingError())
                                    }
                                case .fail:
                                    apiTask.failure?(APIService.logicError(apiResponse: apiResponse))
                            }
                        }
                        else {
                            apiTask.failure?(APIService.mappingError())
                        }
                    case .failure(let networkError):
                        apiTask.failure?(networkError)
                }
            }
        
        return request
    }

    private static func decorateParametersForTask<T>(_ apiTask: APITask<T>) {
        apiTask.parameters["api_key"] = APIService.apiKey
        apiTask.parameters["format"] = APIService.dataFormat
        apiTask.parameters["nojsoncallback"] = APIService.nojsoncallback
        apiTask.parameters["method"] = apiTask.apiMethod
    }
    
    private static func mappingError() -> NSError {
        let mappingError = NSError(domain:"FlickrLite.mapping", code:-100, userInfo:nil)
        return mappingError
    }
    
    private static func logicError(apiResponse: APIResponse) -> NSError {
        let logicError = NSError(domain:"FlickrLite.logic", code:apiResponse.code ?? 0, userInfo:["localizedDescription": apiResponse.message ?? ""])
        return logicError
    }

    func searchPhotos(query: String, pageIndex: Int? = nil, success: ((SearchPhotosResponse) -> ())?, failure: ((Error) -> ())? = nil) -> DataRequest {
        
        var parameters: [String: Any] = [
                "text": query,
            ]
        if pageIndex != nil {
            parameters["page"] = pageIndex!
        }
        
        let apiTask = APITask<SearchPhotosResponse>()
        apiTask.apiMethod = "flickr.photos.search"
        apiTask.parameters = parameters
        apiTask.success = success
        apiTask.failure = failure
    
        let request = self.performTask(apiTask)
        
        return request
    }

}
