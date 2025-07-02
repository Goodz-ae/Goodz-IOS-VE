//
//  LanguageHelper.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation
import CoreData

struct CDKey {
    static let key : String = "key"
    static let value : String = "value"
    static let valueEs : String = "value_es"
    static let email : String = "email"
    static let password : String = "password"
    static let access: String = "access"
    static let countryCode: String = "country_code"
    static let name: String = "name"
    static let phoneNumber: String = "phone_number"
    static let profileImage: String = "profile_image"
    static let refresh: String = "refresh"
    static let role: String = "role"
    static let roleName: String = "role_name"
    static let userId: String = "user_id"
    
}

struct LBL : Codable {
    
    var key: String
    var value: String
    
    init(key: String, value: String, valueEs: String) {
        self.key = key
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
    }
}

struct LabelModel : Codable {
    
    var code: String?
    var message: String?
    var updatedDate: String? = "updated_date"
    var result: [LBL]?
}

enum CurrentLang: Int {
    case english = 1
}

let appLANG = LanguageHelper.shared
class LanguageHelper {
    
    private init() { }
    static let shared = LanguageHelper()
    
    // MARK: - Core Data stack
    private var dbLanguage: NSPersistentContainer = {
        
        let db = NSPersistentContainer(name: "LanguageHelper")
        db.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return db
    }()
    
    private var dbContext: NSManagedObjectContext {
        return dbLanguage.viewContext
    }
    
    
    
    // MARK: - Tabels
    
    private var tblLanguage : NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Language", in: dbContext)!
    }
    
    
    
    
    // MARK: - Core Data Saving support
    private func saveContext() {
        let context = dbLanguage.viewContext
        if context.hasChanges {
            
            do {
                
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save() {
        self.saveContext()
    }
    
    func manageLabelList(list: [LBL]) {
        
        for lbl in list {
            
            if self.isExist(label: lbl.key) {
                self.update(label: lbl)
            } else {
                self.insert(label: lbl)
            }
        }
    }
    
    
    
    private func insert(label: LBL) {
        
        let lbl = Language(entity: tblLanguage, insertInto: dbContext)
        lbl.key = label.key
        lbl.value = label.value

        print("CD LANG:INSERT: \(label.key) => DONE")
        self.saveContext()
    }
    
    private func update(label: LBL) {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CDKey.key) = %@", "\(label.key)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                
                let lbl = language[0]
                lbl.value = label.value
                
                print("CD LANG:UPDATE: \(label.key) => DONE")
                self.saveContext()
            }
        } catch {
            
        }
    }
    
    
    private func isExist(label: String) -> Bool {
        
        var isExist = false
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CDKey.key) = %@", "\(label)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                isExist = true
            }
        } catch {
            
        }
        return isExist
    }
    
    func retrive(label: String) -> String {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CDKey.key) = %@", "\(label)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                return language[0].value ?? self.prepareExceptionLabel(label: label)
            }
        } catch {
            
        }
        return self.prepareExceptionLabel(label: label)
    }
    
    private func prepareExceptionLabel(label: String) -> String {
        
        let lb = label.replacingOccurrences(of: "_", with: " ")
        return lb.capitalizingFirstLetter()
    }
    
    private func retriveAll() -> [Language] {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        
        do {
            let arrLanguage = try dbContext.fetch(req)
            return arrLanguage
            
        } catch {
            
        }
        
        return []
    }
    
    private func delete(label: String) {
        
        let req: NSFetchRequest<Language> = Language.fetchRequest()
        req.predicate = NSPredicate(format: "\(CDKey.key) = %@", "\(label)")
        
        do {
            let language = try dbContext.fetch(req)
            if language.count > 0 {
                print("CD LANG:DELETE: \(label) => DONE")
                self.dbContext.delete(language[0])
                self.saveContext()
            }
        } catch {
            
        }
    }
    
    private func deleteAll() {
        
        let reqFetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.tblLanguage.name!)
        let reqDelete: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: reqFetch)

        do {
            try self.dbContext.execute(reqDelete)
            print("CD LANG:DELETE ALL DONE")
            self.saveContext()
        } catch {

        }
    }
    
    func setLanguageID(langID: Int, updatedDate: String) {
        appUserDefaults.setValue(.currentLanguage, to: langID)
        appUserDefaults.setValue(.updatedAt, to: updatedDate)
    }
    
    func getLanguageInfo() -> (langID: Int, updatedAt: String) {
        
        let lanId: Int = appUserDefaults.getValue(.currentLanguage) ?? CurrentLang.english.rawValue
        let updateDate: String = appUserDefaults.getValue(.updatedAt) ?? ""
        
        return (langID: lanId, updatedAt: updateDate)
    }
    
    func clearLanguageInfo(langID: Int? = nil) {
        appUserDefaults.removeValue(.currentLanguage)
        appUserDefaults.removeValue(.updatedAt)
        
        if langID != nil {
            appUserDefaults.setValue(.currentLanguage, to: langID!)
        }
    }
    
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: Date())
    }
    
}
