import ObjectMapper


struct RawPhoto : Mappable {

    var id: Int?
    var farm: Int?
    var isFamily: Int?
    var isPublic: Int?
    var owner: String?
    var secret: String?
    var server: Int?
    var title: String?

    init?(map: Map) {

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
