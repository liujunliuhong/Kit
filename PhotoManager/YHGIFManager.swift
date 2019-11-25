//
//  YHGIFManager.swift
//  TMM
//
//  Created by apple on 2019/11/25.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import ImageIO

class YHGIFManager: NSObject {
    /// 同步压缩图片到指定文件大小
    ///
    /// - Parameters:
    ///   - rawData: 原始图片数据
    ///   - limitDataSize: 限制文件大小，单位字节
    /// - Returns: 处理后数据
    @objc public static func compressGIFImageData(_ rawData:Data, limitDataSize:Int) -> Data? {
        guard rawData.count > limitDataSize else {
            return rawData
        }
        
        var resultData = rawData
        
        let sampleCount = resultData.yh_fitSampleCount
        if let data = compressImageData(resultData, sampleCount: sampleCount){
            resultData = data
        } else {
            return nil
        }
        if resultData.count <= limitDataSize {
            return resultData
        }
        
        
        var longSideWidth = max(resultData.yh_imageSize.height, resultData.yh_imageSize.width)
        // 图片尺寸按比率缩小，比率按字节比例逼近
        while resultData.count > limitDataSize{
            let ratio = sqrt(CGFloat(limitDataSize) / CGFloat(resultData.count))
            longSideWidth *= ratio
            if let data = compressImageData(resultData, limitLongWidth: longSideWidth) {
                resultData = data
            } else {
                return nil
            }
        }
        return resultData
    }
    
    /// 同步压缩图片抽取帧数，仅支持 GIF
    ///
    /// - Parameters:
    ///   - rawData: 原始图片数据
    ///   - sampleCount: 采样频率，比如 3 则每三张用第一张，然后延长时间
    /// - Returns: 处理后数据
    static func compressImageData(_ rawData:Data, sampleCount:Int) -> Data?{
        guard let imageSource = CGImageSourceCreateWithData(rawData as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let writeData = CFDataCreateMutable(nil, 0),
            let imageType = CGImageSourceGetType(imageSource) else {
                return nil
        }
        
        // 计算帧的间隔
        let frameDurations = imageSource.yh_frameDurations
        
        // 合并帧的时间,最长不可高于 200ms
        let mergeFrameDurations = (0..<frameDurations.count).filter{ $0 % sampleCount == 0 }.map{ min(frameDurations[$0..<min($0 + sampleCount, frameDurations.count)].reduce(0.0) { $0 + $1 }, 0.2) }
        
        // 抽取帧 每 n 帧使用 1 帧
        let sampleImageFrames = (0..<frameDurations.count).filter{ $0 % sampleCount == 0 }.compactMap{ CGImageSourceCreateImageAtIndex(imageSource, $0, nil) }
        
        guard let imageDestination = CGImageDestinationCreateWithData(writeData, imageType, sampleImageFrames.count, nil) else{
            return nil
        }
        
        // 每一帧图片都进行重新编码
        zip(sampleImageFrames, mergeFrameDurations).forEach{
            // 设置帧间隔
            let frameProperties = [kCGImagePropertyGIFDictionary : [kCGImagePropertyGIFDelayTime: $1, kCGImagePropertyGIFUnclampedDelayTime: $1]]
            CGImageDestinationAddImage(imageDestination, $0, frameProperties as CFDictionary)
        }
        
        guard CGImageDestinationFinalize(imageDestination) else {
            return nil
        }
        
        return writeData as Data
    }
    
    
    /// 同步压缩图片数据长边到指定数值
    ///
    /// - Parameters:
    ///   - rawData: 原始图片数据
    ///   - limitLongWidth: 长边限制
    /// - Returns: 处理后数据
    public static func compressImageData(_ rawData:Data, limitLongWidth:CGFloat) -> Data?{
        guard max(rawData.yh_imageSize.height, rawData.yh_imageSize.width) > limitLongWidth else {
            return rawData
        }
        
        guard let imageSource = CGImageSourceCreateWithData(rawData as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let writeData = CFDataCreateMutable(nil, 0),
            let imageType = CGImageSourceGetType(imageSource) else {
                return nil
        }
        
        
        let frameCount = CGImageSourceGetCount(imageSource)
        
        guard let imageDestination = CGImageDestinationCreateWithData(writeData, imageType, frameCount, nil) else{
            return nil
        }
        
        // 设置缩略图参数，kCGImageSourceThumbnailMaxPixelSize 为生成缩略图的大小。当设置为 800，如果图片本身大于 800*600，则生成后图片大小为 800*600，如果源图片为 700*500，则生成图片为 800*500
        let options = [kCGImageSourceThumbnailMaxPixelSize: limitLongWidth, kCGImageSourceCreateThumbnailWithTransform:true, kCGImageSourceCreateThumbnailFromImageIfAbsent:true] as CFDictionary
        
        if frameCount > 1 {
            // 计算帧的间隔
            let frameDurations = imageSource.yh_frameDurations
            
            // 每一帧都进行缩放
            let resizedImageFrames = (0..<frameCount).compactMap{ CGImageSourceCreateThumbnailAtIndex(imageSource, $0, options) }
            
            // 每一帧都进行重新编码
            zip(resizedImageFrames, frameDurations).forEach {
                // 设置帧间隔
                let frameProperties = [kCGImagePropertyGIFDictionary : [kCGImagePropertyGIFDelayTime: $1, kCGImagePropertyGIFUnclampedDelayTime: $1]]
                CGImageDestinationAddImage(imageDestination, $0, frameProperties as CFDictionary)
            }
        } else {
            guard let resizedImageFrame = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {
                return nil
            }
            CGImageDestinationAddImage(imageDestination, resizedImageFrame, nil)
        }
        
        guard CGImageDestinationFinalize(imageDestination) else {
            return nil
        }
        
        return writeData as Data
    }
}


extension Data {
    var yh_fitSampleCount:Int{
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, [kCGImageSourceShouldCache: false] as CFDictionary) else {
            return 1
        }
        
        let frameCount = CGImageSourceGetCount(imageSource)
        var sampleCount = 1
        switch frameCount {
        case 2..<8:
            sampleCount = 2
        case 8..<20:
            sampleCount = 3
        case 20..<30:
            sampleCount = 4
        case 30..<40:
            sampleCount = 5
        case 40..<Int.max:
            sampleCount = 6
        default:break
        }
        
        return sampleCount
    }
    
    var yh_imageSize:CGSize{
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any],
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat,
            let imageWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat else {
                return .zero
        }
        return CGSize(width: imageWidth, height: imageHeight)
    }
}

extension CGImageSource {
    func yh_frameDurationAtIndex(_ index: Int) -> Double{
        var frameDuration = Double(0.1)
        guard let frameProperties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) as? [AnyHashable:Any], let gifProperties = frameProperties[kCGImagePropertyGIFDictionary] as? [AnyHashable:Any] else {
            return frameDuration
        }
        
        if let unclampedDuration = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? NSNumber {
            frameDuration = unclampedDuration.doubleValue
        } else {
            if let clampedDuration = gifProperties[kCGImagePropertyGIFDelayTime] as? NSNumber {
                frameDuration = clampedDuration.doubleValue
            }
        }
        
        if frameDuration < 0.011 {
            frameDuration = 0.1
        }
        
        return frameDuration
    }
    
    var yh_frameDurations:[Double]{
        let frameCount = CGImageSourceGetCount(self)
        return (0..<frameCount).map{ self.yh_frameDurationAtIndex($0) }
    }
}
