//
//  ColorsVM.swift
//  Goodz
//
//  Created by Akruti on 19/01/24.
//

import Foundation
class ColorsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ColorRepo()
    var arrColor : [ColorModel] = [ColorModel]()
    var arrMaterial : [ColorModel] = []
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchColors(completion: @escaping((Bool) -> Void)) {
        self.repo.getColorsAPI {  status, data, error in
            if status, let colors = data {
                self.arrColor = [ColorModel(id: "", title: "Select All")]
                self.arrColor.append(contentsOf: colors)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfColors() -> Int {
        self.arrColor.count
    }
     
    // --------------------------------------------
    
    func setColor(row: Int) -> ColorModel {
        self.arrColor[row]
    }
    
    // --------------------------------------------
    
    func fetchMaterials(completion: @escaping((Bool) -> Void)) {
        self.repo.getMaterial {  status, data, error in
            if status, let materials = data {
                self.arrMaterial = [ColorModel(id: "", title: "Select All")]
                self.arrMaterial.append(contentsOf: materials)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfMaterial() -> Int {
        self.arrMaterial.count
    }
     
    // --------------------------------------------
    
    func setMaterial(row: Int) -> ColorModel {
        self.arrMaterial[row]
    }
    
    // --------------------------------------------
    
}
