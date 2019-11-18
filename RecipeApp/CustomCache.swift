//
//  customCache.swift
//  RecipeApp
//
//  Created by Saajith Zain on 11/11/19.
//  Copyright © 2019 Saajith Zain. All rights reserved.
//

import Foundation
private let ExpiringCacheObjectKey = "..."
private let ExpiringCacheDefaultTimeout: TimeInterval = 60

class CustomCache : NSCache<NSString, AnyObject>{
    func setObject(obj: AnyObject, forKey key: AnyObject, timeout: TimeInterval) {
        super.setObject(obj, forKey: key as! NSString)
        Timer.scheduledTimer(timeInterval: timeout, target: self, selector: "timerExpires:", userInfo: [ExpiringCacheObjectKey : key], repeats: false)
       }

       // Override default `setObject` to use some default timeout interval

       override func setObject(obj: AnyObject, forKey key: AnyObject) {
        setObject(obj: obj, forKey: key, timeout: ExpiringCacheDefaultTimeout)
       }

       // method to remove item from cache

    func timerExpires(timer: Timer) {
           removeObjectForKey(timer.userInfo![ExpiringCacheObjectKey] as! String)
       }
}
