//
//  DefaultsKey.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
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
    static let currentUser = DefaultsKey<CurrentUserModel>("currentUser")
    static let initialLanguage = DefaultsKey<Int>("initialLanguage")
    static let currentLanguage = DefaultsKey<Int>("CurrentLanguage")
    static let updatedAt = DefaultsKey<String>("UpdatedAt")
    static let updatedDate = DefaultsKey<String>("updated_date")
    static let forceLogoutMessageKey = DefaultsKey<String>("forceLogoutMessageKey")
    static let isAppFirstTime = DefaultsKey<String>("isAppFirstTime")
    static let accessToken = DefaultsKey<[String : Any]>("accessToken")
    static let isLogin = DefaultsKey<Int>("isLogin")
    static let mobileNumber = DefaultsKey<Int>("mobileNumber")
    static let currency = DefaultsKey<String>("currency")
    static let isGuestUser = DefaultsKey<Bool>("isGuestUser")
    static let isProUser = DefaultsKey<Bool>("isProUser")
    static let appUpdateVersion = DefaultsKey<String>("appUpdateVersion")
    static let forceUpdate = DefaultsKey<String>("forceUpdate")
    
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
