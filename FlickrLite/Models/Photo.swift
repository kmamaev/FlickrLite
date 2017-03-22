import Foundation


class Photo {

    var url: URL?

    init(rawPhoto: RawPhoto) {
        self.url = PhotosRoutines.url(id: rawPhoto.id, serverId: rawPhoto.server, farm: rawPhoto.farm, secret: rawPhoto.secret)
    }

}
