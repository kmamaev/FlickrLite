import UIKit


class PhotosBrowserVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private static let reuseId = "reuseId"

    @IBOutlet var collectionView: UICollectionView!

    var photosService: PhotosService?
    
    var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        let nibName = NSStringFromClass(PhotosBrowserCell.self).characters.split(separator: ".").map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: PhotosBrowserVC.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assert(self.photosService != nil)
        
        let successHandler = {
            [weak self] (photos: [Photo]) -> () in
            self?.photos = photos
            self?.collectionView.reloadData()
        }
        
        let failureHandler = {
            (error: Error) -> () in
            print(error)
            // TODO: handle error
        }
        
        _ = self.photosService?.searchPhotos(query: "cats", success: successHandler, failure: failureHandler)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosBrowserVC.reuseId, for: indexPath) as! PhotosBrowserCell
        
        let photo = self.photos[indexPath.row]
        cell.configure(photo: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let leftRightInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let numberOfColumns = 3
        let totalCellsSpacing = cellSpacing * CGFloat(numberOfColumns - 1)
        let collectionViewWidth = self.collectionView.bounds.width
        
        let cellWidth = (collectionViewWidth - leftRightInsets - totalCellsSpacing) / CGFloat(numberOfColumns)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}
