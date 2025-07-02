//
//  UserDefaults.swift
//  Blue-ELD
//
//  Created by Dipesh Sisodiya on 03/02/25.
//
 






 
import Foundation
let appUserDefaults = UserDefaults.standard

class DefaultsKeys {}

final class DefaultsKey<T>: DefaultsKeys {
    let value: String

    init(_ value: String) {
        self.value = value
    }
}

extension DefaultsKeys {
    static let seqIDUserSession = DefaultsKey<SeqIDUserSessionModel>("SeqIDUserSession")
    
}

extension UserDefaults {
    
    func getValue<T>(_ key: DefaultsKey<T>) -> T? {
        return object(forKey: key.value) as? T
    }
    
    func setValue<T>(_ key: DefaultsKey<T>, to value: T) {
        set(value, forKey: key.value)
        synchronize()
    }
    
    func removeValue<T>(_ key: DefaultsKey<T>) {
        removeObject(forKey: key.value)
        synchronize()
    }
    
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: DefaultsKey<T>) {
        // appUserDefaults.setCodableObject(firstResponse.result?.first!, forKey: .currentUser)
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName.value)
    }
    
    func codableObject<T : Codable>(dataType: T.Type, key: DefaultsKey<T>) -> T? {
        // appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
        guard let userDefaultData = data(forKey: key.value) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
    func removeCodableObject<T>(_ key: DefaultsKey<T>) {
        removeObject(forKey: key.value)
        synchronize()
    }
}


/// - Note: Write down project keys below
private enum UserDefaultKeys: String {
    
    case Location_lat = "Location-lat"
    case Location_long = "Location-long"
     
}

extension UserDefaults {
    
    /*var locationLatitudeDefaults : Double {
        get {
            UserDefaults.standard.value(forKey: UserDefaultKeys.Location_lat.rawValue) as? Double ?? 0.0
        }
        set{
            UserDefaults.standard.setValue(Double(newValue), forKey: UserDefaultKeys.Location_lat.rawValue)
        }
    }
    
    
    var locationLatitudeDefaults : Double {
        get {
            UserDefaults.standard.value(forKey: UserDefaultKeys.Location_lat.rawValue) as? Double ?? 0.0
        }
        set{
            UserDefaults.standard.setValue(Double(newValue), forKey: UserDefaultKeys.Location_lat.rawValue)
        }
    }
    
    var locationLongitudeDefaults : Double {
        get {
            UserDefaults.standard.value(forKey: UserDefaultKeys.Location_long.rawValue) as? Double ?? 0.0
        }
        set{
            UserDefaults.standard.setValue(Double(newValue), forKey: UserDefaultKeys.Location_long.rawValue)
        }
    }
   */
}
 
