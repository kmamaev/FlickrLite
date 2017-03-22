import RealmSwift


class StorageService {

    lazy var application: RealmApplication = {
        let realm = try! Realm()
        var realmApplication = realm.objects(RealmApplication.self).first
        if realmApplication == nil {
            realmApplication = RealmApplication()
            try! realm.write {
                realm.add(realmApplication!)
            }
        }
        return realmApplication!
    }()
    
    let realm = {
        try! Realm()
    }

    func storedPhotos() -> [Photo] {
        
        var photos: [Photo] = []
        for realmPhoto in self.application.photos {
            let photo = Photo(realmPhoto: realmPhoto)
            photos.append(photo)
        }
        
        return photos
    }
    
    func savePhotos(_ photos: [Photo]) {
        
        var realmPhotos: [RealmPhoto] = []
        for photo in photos {
            let realmPhoto = RealmPhoto()
            realmPhoto.urlString = photo.url?.absoluteString
            realmPhoto.title = photo.title
            realmPhotos.append(realmPhoto)
        }
        
        try! self.realm().write {
            self.application.photos.append(objectsIn: realmPhotos)
        }
    }
    
    func clearPhotos() {
        try! self.realm().write {
            self.application.photos.removeAll()
        }
    }

}
