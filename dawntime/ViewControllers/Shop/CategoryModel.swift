
import Foundation

protocol Detailable {}
extension String : Detailable{}

final class ShopModel{
    var categorys: [String : [String]] = [
        "CATEGORY" : ["바이레이터","커플토이", "하네스 벨트", "딜도","에널 게겔", "PARTY용품", "코스튬", "BDSM", "속옷","콘돔", "러브젤"] ,
        "BRAND" : ["플레저랩","은하선 토파즈","레드 컨테이너"]]
    static let sharedInstance = ShopModel()
    private init() {}
    var contents: [String] = ["플레저1", "플레저2", "플레저3"]
    enum Board: String  {
        case New
        case Hot
    }
    enum  CellMode {
        case CategoryMode
        case GoodsMode
    }
    var board: Board = .New
    var beforeMode: CellMode = .GoodsMode
    var mode: CellMode = .GoodsMode{
        
        didSet{
            beforeMode = oldValue
        }
    }
    
    var largeCategory: [String]{
        
        get{
            if (board == .New)  {
              return  ["NEW","CATEGORY","BRAND"]
            }else{
             return   ["HOT"]
            }
        }
        
    }
    //아래  카테고리 가져오기
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
  private  var internalCategory: [String] = []
    
    var keyword: String = "" {
        
        willSet{
            if(newValue == "CATEGORY"){
                
                internalCategory = categorys[newValue] ?? [""]
                mode = .CategoryMode
            } else if(newValue == "BRAND"){
                internalCategory = categorys[newValue] ?? [""]
                mode = .CategoryMode
            } else{
                mode = .GoodsMode
                //네트워크되면 largeCategory다른걸로 바꾸기
                //  internalCategory = largeCategory
            }
        }
    }
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
   
   
}



