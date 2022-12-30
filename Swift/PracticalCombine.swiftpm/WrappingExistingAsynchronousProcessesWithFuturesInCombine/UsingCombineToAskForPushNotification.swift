//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/24.
//

import Foundation
import Combine
import UserNotifications

func askForPushNotificationWithoutCombine() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .denied:
            DispatchQueue.main.async {
                // update UI to point user to settings
            }
        case .notDetermined:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
                if result == true && error == nil {
                    // We have notification permissions
                } else {
                    DispatchQueue.main.async {
                        // Something went wrong / we don't have permission.
                        // update UI to point user to settings
                    }
                }
            }
        default:
            // assume permissions are fine and proceed
            break
        }
    }
}

// example below show the way to set push notification using and without Coombine
extension UNUserNotificationCenter {
    func getNotificationSettings() -> Future<UNNotificationSettings, Never> {
        return Future { promise in
            self.getNotificationSettings { settings in
                promise(.success(settings))
            }
        }
    }
    func requestAuthorization(options: UNAuthorizationOptions) -> Future<Bool, Error> {
        return Future { promise in
            self.requestAuthorization(options: options) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(result))
                }
            }
        }
    }
}
