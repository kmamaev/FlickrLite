import Foundation


class PhotosRoutines {

    private static let hostName = "staticflickr.com"

/// The URL takes the following format:
///
/// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
/// 	or
/// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
/// 	or
/// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
///
/// Example
///
/// https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
///
/// farm-id: 1
/// server-id: 2
/// photo-id: 1418878
/// secret: 1e92283336
/// size: m
///
/// Size Suffixes
///
/// The letter suffixes are as follows:
///
/// s	small square 75x75
/// q	large square 150x150
/// t	thumbnail, 100 on longest side
/// m	small, 240 on longest side
/// n	small, 320 on longest side
/// -	medium, 500 on longest side
/// z	medium 640, 640 on longest side
/// c	medium 800, 800 on longest side†
/// b	large, 1024 on longest side*
/// h	large 1600, 1600 on longest side†
/// k	large 2048, 2048 on longest side†
/// o	original image, either a jpg, gif or png, depending on source format

    static func url(id: String?, serverId: String?, farm: Int?, secret: String?) -> URL? {
        guard (id != nil) && (serverId != nil) && (farm != nil) && (secret != nil) else {
            return nil
        }
        
        let urlString = "https://farm\(farm!).\(PhotosRoutines.hostName)/\(serverId!)/\(id!)_\(secret!)_z.jpg"
        let url = URL(string: urlString)
        // TODO: choose proper scale
        
        return url
    }

}
