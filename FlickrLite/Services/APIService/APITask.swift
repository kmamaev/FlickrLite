import Alamofire
import ObjectMapper


class APITask<ResponseType: APIResponse> {

    var httpMethod: HTTPMethod = .get
    var apiMethod: NSString?
    var parameters: [String: Any] = [:]
    var success: ((ResponseType) -> ())?
    var failure: ((Error) -> ())?

}
