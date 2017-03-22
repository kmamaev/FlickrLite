import UIKit
import AlamofireImage
import Alamofire


class PhotosBrowserCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!

    var photo: Photo?
    
    var loadImageRequest: DataRequest?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(photo: Photo, photosService: PhotosService) {
        self.photo = photo
        
        self.loadImageRequest = photosService.loadImage(photo: photo, success: {
            [weak self] () -> () in
            self?.imageView.image = photo.image
        })
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.loadImageRequest?.cancel()
        self.loadImageRequest = nil
        self.imageView.image = nil
    }

}
