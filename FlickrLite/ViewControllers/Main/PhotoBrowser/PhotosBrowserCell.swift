import UIKit
import AlamofireImage


class PhotosBrowserCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!

    var photo: Photo?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(photo: Photo) {
        self.photo = photo
        if let imageURL = photo.url {
            self.imageView.af_setImage(withURL: imageURL)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.af_cancelImageRequest()
        self.imageView.image = nil
    }

}
