//
//  MBRunLoopDistribution.swift
//  RunLoop
//
//  Created by user on 17/1/9.
//  Copyright © 2017年 mobin. All rights reserved.
//

import UIKit
class MBRunLoopDitribution {

    lazy var tasks: NSMutableArray = NSMutableArray()
    lazy var tasksKey: NSMutableArray = NSMutableArray()
    var timer: Timer!
    
    typealias MBRunLoopWorkUnit = () -> Bool
    let maximumQueueLength: Int = 30
    
    
    static let share = MBRunLoopDitribution()
    private init(){
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(_timerFiredMethod(timer:)), userInfo: nil, repeats: true)
        _registerRunLoopWork(observer: .share)
    }
    
    
    /// TimerScheduledMethod
    @objc private func _timerFiredMethod(timer: Timer){
        
        /// Do nothing
    
    
    }
    private func _registerRunLoopWork(observer distributionAsMainRunloopObserver : MBRunLoopDitribution){
    
        
        var info = distributionAsMainRunloopObserver
        
        _registerObserver(activities: CFRunLoopActivity.beforeWaiting.rawValue, order: 0, mode: CFRunLoopMode.defaultMode, info: &info, callback: _observerCallbackFunc())
    }
    
    
    private func _registerObserver(activities: CFOptionFlags, order: CFIndex, mode: CFRunLoopMode,info: UnsafeMutableRawPointer,callback: @escaping CFRunLoopObserverCallBack){
    
    let runLoop = CFRunLoopGetCurrent()
    
    var context = CFRunLoopObserverContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
        
    let observer = CFRunLoopObserverCreate(nil, activities, true, order, callback, &context)

        CFRunLoopAddObserver(runLoop, observer, mode)
        
    }
    
    
    /* 
     
     
     switch(activity) {
     
     case CFRunLoopActivity.entry:
     print("Run Loop已经启动")
     break
     case CFRunLoopActivity.beforeTimers:
     print("Run Loop分配定时任务前")
     break
     case CFRunLoopActivity.beforeSources:
     print("Run Loop分配输入事件源前")
     break
     case CFRunLoopActivity.beforeWaiting:
     print("Run Loop休眠前")
     break
     case CFRunLoopActivity.afterWaiting:
     print("Run Loop休眠后")
     break
     case CFRunLoopActivity.exit:
     print("Run Loop退出后")
     break
     default:
     break
     
     }

     */
    /// beforeWaiting 回调
    func _observerCallbackFunc() -> CFRunLoopObserverCallBack {
        
        return {(observer, activity, info) -> Void in
        
                let runLoopWorkDistribution = info?.load(as: MBRunLoopDitribution.self)
            if runLoopWorkDistribution?.tasks.count == 0 { return }
            
            
            var result = false
            while result == false && ((runLoopWorkDistribution?.tasks.count) != nil) {
             
                let unit = runLoopWorkDistribution?.tasks.firstObject as? MBRunLoopWorkUnit
                guard unit != nil else { return}
                result = unit!()
                runLoopWorkDistribution?.tasks .removeObject(at: 0)
                runLoopWorkDistribution?.tasksKey.removeObject(at: 0)
                
                
            }
            
            
        }
    }

}





// MARK: - Interface Mathods
extension MBRunLoopDitribution {



    public func addTask(unit: MBRunLoopWorkUnit, key:Any){
    
        self.tasks.add(unit)
        self.tasksKey.add(key)
    
        if self.tasks.count > self.maximumQueueLength{
        
            self.tasks.removeObject(at: 0)
            self.tasksKey.removeObject(at: 0)
        }
    }
    
    public func removeAllTask(){
    
        self.tasks.removeAllObjects()
        self.tasksKey.removeAllObjects()
    }

}







// MARK: - Add store properties with Runtime
extension UITableViewCell{
    

    static let key = UnsafeRawPointer.init(bitPattern: "currentIndexPath".hashValue)

    var currentIndexPath:IndexPath?{
    
        get{
            return objc_getAssociatedObject(self, UITableViewCell.key) as? IndexPath
        }
        
        set{
        
            objc_setAssociatedObject(self, UITableViewCell.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }




}
