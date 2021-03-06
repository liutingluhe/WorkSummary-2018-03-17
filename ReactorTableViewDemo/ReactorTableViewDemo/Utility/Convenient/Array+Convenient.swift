//
//  Array+Convenient.swift
//  ReactorCollectionViewDemo
//
//  Created by luhe liu on 2018/6/21.
//  Copyright © 2018年 luhe liu. All rights reserved.
//

import UIKit

public extension Array {
    
    /// 安全取数组元素
    public func safeIndex(_ i: Int) -> Array.Iterator.Element? {
        guard !isEmpty && i >= 0 && i < count else { return nil }
        return self[i]
    }
    
    /// 从前面取 N 个数组元素
    public func limit(_ limitCount: Int) -> [Array.Iterator.Element] {
        let maxCount = self.count
        var resultCount: Int = limitCount
        if maxCount < limitCount {
            resultCount = maxCount
        }
        if resultCount <= 0 {
            return []
        }
        return self[0..<resultCount].map { $0 }
    }
    
    /// 填充数组数量到 N
    public func full(_ fullCount: Int) -> [Array.Iterator.Element] {
        var items = self
        while items.count > 0 && items.count < fullCount {
            items = (items + items).limit(fullCount)
        }
        return items.limit(fullCount)
    }
    
    /// 带索引遍历
    public func forEachWithIndex(_ handler: (Int, Array.Iterator.Element) -> Void) {
        self.bilateralEnumerated(0, handler: handler)
    }
    
    /// 双边遍历，从中间向两边进行遍历
    public func bilateralEnumerated(_ beginIndex: Int, handler: (Int, Array.Iterator.Element) -> Void) {
        let arrayCount: Int = self.count
        var leftIndex: Int = Swift.max(0, Swift.min(beginIndex, arrayCount - 1))
        var rightIndex: Int = leftIndex + 1
        var currentIndex: Int = leftIndex
        var isLeftEnable: Bool = leftIndex >= 0 && leftIndex < arrayCount
        var isRightEnable: Bool = rightIndex >= 0 && rightIndex < arrayCount
        var isLeft: Bool = isLeftEnable ? true : isRightEnable
        while isLeftEnable || isRightEnable {
            currentIndex = isLeft ? leftIndex : rightIndex
            if let element = self.safeIndex(currentIndex) {
                handler(currentIndex, element)
            }
            if isLeft {
                leftIndex -= 1
            } else {
                rightIndex += 1
            }
            isLeftEnable = leftIndex >= 0 && leftIndex < arrayCount
            isRightEnable = rightIndex >= 0 && rightIndex < arrayCount
            if isLeftEnable && !isRightEnable {
                isLeft = true
            } else  if !isLeftEnable && isRightEnable {
                isLeft = false
            } else if isLeftEnable && isRightEnable {
                isLeft = !isLeft
            }
        }
    }
    
    /// 转成字符串参数
    public func convertToParamsStr(_ separator: String = ",") -> String {
        let paramsStrList: [String] = self.flatMap({ return "\($0)" })
        return paramsStrList.joined(separator: separator)
    }
}
