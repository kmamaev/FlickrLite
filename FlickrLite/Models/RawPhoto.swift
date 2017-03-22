import ObjectMapper


struct RawPhoto : Mappable {

    var id: String!
    var farm: Int?
    var isFamily: String?
    var isPublic: String?
    var owner: String?
    var secret: String?
    var server: String?
    var title: String?

    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        farm <- map["farm"]
        isFamily <- map["isFamily"]
        isPublic <- map["isPublic"]
        owner <- map["owner"]
        secret <- map["secret"]
        server <- map["server"]
        title <- map["title"]
    }

}
