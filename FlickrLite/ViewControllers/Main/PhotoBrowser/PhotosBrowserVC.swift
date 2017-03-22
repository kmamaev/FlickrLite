import UIKit
import NYTPhotoViewer


class PhotosBrowserVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NYTPhotosViewControllerDelegate {

    private static let reuseId = "reuseId"

    @IBOutlet var collectionView: UICollectionView!

    var query = "cats"

    var photosService: PhotosService?
    
    var photoDetailsVC: NYTPhotosViewController?
    
    var updatingCollection = false
    var previousContentHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.configureNavigationBar()
    }
    
    private func configureCollectionView() {
        let nibName = NSStringFromClass(PhotosBrowserCell.self).characters.split(separator: ".").map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: PhotosBrowserVC.reuseId)
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = self.query
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assert(self.photosService != nil)
        
        let successHandler = {
            [weak self] (_: CountableRange<Int>) -> () in
            self?.collectionView.reloadData()
        }
        
        let failureHandler = {
            (error: Error) -> () in
            print(error)
            // TODO: handle error
        }
        
        _ = self.photosService?.searchPhotos(query: query, success: successHandler, failure: failureHandler)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosService!.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosBrowserVC.reuseId, for: indexPath) as! PhotosBrowserCell
        
        let photo = self.photosService!.photos[indexPath.row]
        cell.configure(photo: photo, photosService: self.photosService!)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.photosService!.photos[indexPath.row]
        self.photoDetailsVC = NYTPhotosViewController(photos: self.photosService!.photos, initialPhoto: photo, delegate: self)
        self.present(self.photoDetailsVC!, animated: true, completion: nil)
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateTo photo: NYTPhoto, at photoIndex: UInt) {
        if photo.image == nil {
            _ = self.photosService?.loadImage(photo: photo as! Photo, success: {
                [weak self] () -> () in
                self?.photoDetailsVC?.updateImage(for: photo)
            })
        }
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        if let index = self.photosService!.photos.index(of: photo as! Photo) {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = self.collectionView.cellForItem(at: indexPath) as? PhotosBrowserCell
            return cell?.imageView
        }
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.updatingCollection == true {
            if scrollView.contentSize.height > self.previousContentHeight {
                self.updatingCollection = false
            }
        }
    
        let distanceToEndOfList = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.bounds.height
        
        if (distanceToEndOfList < 200) && (self.updatingCollection == false) {
            self.updatingCollection = true
            self.previousContentHeight = scrollView.contentSize.height
            self.loadNextPage()
        }
    }
    
    private func loadNextPage() {
        let successHandler = {
            [weak self] (range: CountableRange<Int>) -> () in
            self?.collectionView.insertItems(at: IndexPath.indexPaths(range: range))
        }
        
        let failureHandler = {
            (error: Error) -> () in
            print(error)
            // TODO: handle error
        }
        
        _ = self.photosService?.loadNextPageIfNeeded(success: successHandler, failure: failureHandler)
    }
    
}
