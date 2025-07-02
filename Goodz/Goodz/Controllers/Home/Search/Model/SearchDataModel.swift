////
////  SearchDataModel.swift
////  Goodz
////
////  Created by Priyanka Poojara on 12/12/23.
////
//
//import UIKit
//
//struct TypesOfProduct {
//    var data: [FurnitureInfo]
//    
//    //    static func typesOfProduct() -> [TypesOfProduct] {
//    //        return [
//    //            TypesOfProduct(data: FurnitureInfo.listOfRecentSearch()),
//    //            TypesOfProduct(data: FurnitureInfo.listOfGoodsDeal()),
//    //            TypesOfProduct(data: FurnitureInfo.listOfSuperCategory())
//    //        ]
//    //    }
//    
//}
//
//struct FurnitureInfo {
//    let image: UIImage?
//    var title: String
//    let forwardArrow: Bool?
//    
//    static func listOfRecentSearch() -> [FurnitureInfo] {
//        return [
//            FurnitureInfo(image: nil, title: "Black chair", forwardArrow: nil),
//            FurnitureInfo(image: nil, title: "Lighting products", forwardArrow: nil),
//            FurnitureInfo(image: nil, title: "Store name", forwardArrow: nil),
//            FurnitureInfo(image: nil, title: "Lighting products", forwardArrow: nil)
//        ]
//    }
//    
//    static func listOfGoodsDeal() -> [FurnitureInfo] {
//        return [
//            FurnitureInfo(image: .iconGoodz, title: Labels.goodzDeals, forwardArrow: false)
//        ]
//    }
//
//    static func listOfStore() -> [OtherUserModel] {
//        return [
//            OtherUserModel(userName: "Carol Amon", rate: "3.0", date: "08/31/23", description: "", profileImage: .profile),
//            OtherUserModel(userName: "Alva Mendiola", rate: "3.0", date: "08/31/23", description: "", profileImage: .profile),
//            OtherUserModel(userName: "Amon Carol", rate: "3.0", date: "08/31/23", description: "", profileImage: .profile),
//            OtherUserModel(userName: "Alva Mendiola", rate: "3.0", date: "08/03/23", description: "", profileImage: .profile),
//            OtherUserModel(userName: "Carol Amon", rate: "3.0", date: "08/31/23", description: "", profileImage: .profile),
//            OtherUserModel(userName: "Alva Mendiola", rate: "3.0", date: "08/31/23", description: "", profileImage: .profile),
//            OtherUserModel(userName: "Amon Carol", rate: "3.0", date: "08/31/23", description: "", profileImage: .profile),
//            OtherUserModel(userName: "Alva Mendiola", rate: "3.0", date: "08/03/23", description: "", profileImage: .profile)
//        ]
//    }
//}
