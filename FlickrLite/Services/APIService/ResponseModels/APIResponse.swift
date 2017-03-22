import ObjectMapper


class APIResponse: Mappable {

    enum Status: String {
        case ok = "ok"
        case fail = "fail"
    }

    var stat: String!
    var message: String?
    var code: Int?
    var status: Status {
        return Status(rawValue: self.stat) ?? .fail
    }

    required init?(map: Map) {
        if map.JSON["stat"] == nil {
            return nil
        }
    }

    func mapping(map: Map) {
        stat <- map["stat"]
        message <- map["message"]
        code <- map["code"]
    }

}
