import ObjectMapper


class SearchPhotosResponse: APIResponse {

    var rawPhotos: [RawPhoto]?
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    
    required init?(map: Map) {
        super.init(map: map)
        if map.JSON["photos"] == nil {
            return nil
        }
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        rawPhotos <- map["photos.photo"]
        page <- map["photos.page"]
        pages <- map["photos.pages"]
        perpage <- map["photos.perpage"]
        total <- map["photos.total"]
    }

}
