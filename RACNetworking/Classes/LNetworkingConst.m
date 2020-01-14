//
//  LNetworkingConst.m
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/6.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import "LNetworkingConst.h"

@implementation LNetworkingConst

NSString * LStringFromHttpMethod(LHTTPMethod method){
    switch (method) {
        case LHTTPGET:
            return @"GET";
            break;
        case LHTTPPOST:
            return @"POST";
            break;
        case LHTTPPUT:
            return @"PUT";
            break;
        case LHTTPDELETE:
            return @"DELETE";
            break;
        default:
            return @"GET";
            break;
    }
    return @"GET";
}

NSString * LStringFromLFileMimeType(LFileMimeType method){
    switch (method) {
        case LFileMimeTypeJpeg:
            return @"image/jpeg";
            break;
        case LFileMimeTypePng:
            return @"image/png";
            break;
        case LFileMimeTypeVideo:
            return @"video/quicktime";
            break;
        case LFileMimeTypeAudio:
            return @"audio/wav";
            break;
        case LFileMimeTypeText:
            return @"text/plain";
            break;
        default:
            return @"";
            break;
    }
    return @"";
}
@end
