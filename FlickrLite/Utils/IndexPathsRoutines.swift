import UIKit


extension IndexPath {

    static func indexPaths(range: CountableRange<Int>, section: Int = 0) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for index in range {
            let indexPath = IndexPath(row: index, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }

}
