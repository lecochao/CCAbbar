//
//  LNetworkingConst.h
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/6.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LHTTPMethod) {
    LHTTPPOST = 0,
    LHTTPGET = 1,
    LHTTPPUT = 2,
    LHTTPDELETE = 3
};

typedef NS_ENUM(NSUInteger, LSignalValueType) {
    LSignalValueTypeResponseObj,
    LSignalValueTypeError,
    LSignalValueTypeUploadProgress,
    LSignalValueTypeDownloadProgress,
};

typedef NS_ENUM(NSUInteger, LFileMimeType) {
    LFileMimeTypeJpeg,//image/jpeg
    LFileMimeTypePng,//image/png
    LFileMimeTypeVideo,//video/quicktime
    LFileMimeTypeAudio,//audio/wav
    LFileMimeTypeText,//text/plain
};
//For example, the MIME type for a JPEG image is image/jpeg.

NS_ASSUME_NONNULL_BEGIN

extern NSString * LStringFromHttpMethod(LHTTPMethod state);
extern NSString * LStringFromLFileMimeType(LFileMimeType state);
@interface LNetworkingConst : NSObject

@end

NS_ASSUME_NONNULL_END
