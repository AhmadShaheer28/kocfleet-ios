//
//  TimeInterval.swift
//

import Foundation

extension TimeInterval {
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        //let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        if hours != 0 {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        } else {
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }
        
    }
}
