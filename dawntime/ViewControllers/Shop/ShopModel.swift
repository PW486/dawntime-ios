
import Foundation

protocol Detailable {}
extension String : Detailable {}

final class ShopModel {
    var categories: [String : [String]] = [
        "CATEGORY" : ["BDSM", "PARTY 용품", "딜도", "러브젤", "바이브레이터", "애널케겔", "커플토이", "콘돔"],
        "BRAND" : ["바른생각", "식스티 원", "은하선 토이즈", "플레저 랩"]]
    var sortList = ["최신순", "인기순", "높은가격순", "낮은가격순"]
    
    static let sharedInstance = ShopModel()
    private init() {}
    
    var goodsItems = [GoodsItem]()
    
    enum Sort: Int {
        case recent = 1
        case pop = 2
        case high = 3
        case row = 4
    }
    enum Board: String {
        case New = "new"
        case Best = "best"
    }
    enum CellMode {
        case CategoryMode
        case GoodsMode
    }
    enum Category: String {
        case category = "category"
        case brand = "brand"
    }
    
    var sort: Sort = .recent
    var board: Board = .New
    var mode: CellMode = .GoodsMode
    var category: Category = .category
    
    var largeCategory: [String] {
        get{
            if (board == .New)  {
                return ["NEW","CATEGORY","BRAND"]
            } else {
                return ["BEST"]
            }
        }
    }
    
    //아래 카테고리 가져오기
    var externalCategory: [String] {
        get{
            if (internalCategory.count == 0) {
                return largeCategory
            }
            else{
                return internalCategory
            }
        }
    }
    
    //아래 카테고리
    var internalCategory: [String] = []
    
    var keyword: String = "NEW" {
        willSet{
            if(newValue == "CATEGORY") {
                internalCategory = categories[newValue] ?? [""]
                mode = .CategoryMode
                category = .category
            } else if(newValue == "BRAND") {
                internalCategory = categories[newValue] ?? [""]
                mode = .CategoryMode
                category = .brand
            } else if(newValue == "NEW" || newValue == "BEST"){
                mode = .GoodsMode
                internalCategory = largeCategory
                selectedIndex = IndexPath(item: 0, section: 0)
            }else{
                mode = .GoodsMode
            }
        }
    }
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
}
