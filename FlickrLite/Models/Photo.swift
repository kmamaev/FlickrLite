import Foundation
import NYTPhotoViewer


class Photo: NSObject, NYTPhoto {

    var url: URL?
    var title: String?

    var image: UIImage?
    var imageData: Data?
    let placeholderImage: UIImage? = nil
    var attributedCaptionTitle: NSAttributedString? {
        return NSAttributedString(string: self.title ?? "", attributes: [NSForegroundColorAttributeName: UIColor.gray])
    }
    let attributedCaptionSummary: NSAttributedString? = nil
    let attributedCaptionCredit: NSAttributedString? = nil
    
    init(rawPhoto: RawPhoto) {
        self.url = PhotosRoutines.url(id: rawPhoto.id, serverId: rawPhoto.server, farm: rawPhoto.farm, secret: rawPhoto.secret)
        self.title = rawPhoto.title
    }
    
    init(realmPhoto: RealmPhoto) {
        if realmPhoto.urlString != nil {
            self.url = URL(string: realmPhoto.urlString!)
        }
        self.title = realmPhoto.title
    }

}
