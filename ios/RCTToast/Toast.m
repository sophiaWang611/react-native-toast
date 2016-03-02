#import <UIKit/UIKit.h>
#import "RCTLog.h"
#import "RCTBridgeModule.h"
#import "Toast+UIView.h"


@interface Toast : NSObject <RCTBridgeModule>
@end

@implementation Toast

RCT_EXPORT_MODULE(Toast)


RCT_EXPORT_METHOD(show:(NSDictionary *)options) {
    NSString *message  = [options objectForKey:@"message"];
    NSString *duration = [options objectForKey:@"duration"];
    NSString *position = [options objectForKey:@"position"];
    NSNumber *addPixelsY = [options objectForKey:@"addPixelsY"];
    NSString *imageStr = [options objectForKey:@"image"];
    
    if (!message || [message length] == 0) return;
    
    if (![position isEqual: @"top"] && ![position isEqual: @"center"] && ![position isEqual: @"bottom"]) {
        RCTLogError(@"invalid position. valid options are 'top', 'center' and 'bottom'");
        return;
    }
    
    NSInteger durationInt;
    if ([duration isEqual: @"short"]) {
        durationInt = 2;
    } else if ([duration isEqual: @"long"]) {
        durationInt = 5;
    } else {
        RCTLogError(@"invalid duration. valid options are 'short' and 'long'");
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (imageStr == nil) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSString *imagePath = [path stringByAppendingPathComponent:imageStr];
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            UIImage *image = [UIImage imageWithData:imageData];
            [[[[UIApplication sharedApplication]windows]firstObject] makeToast:message duration:durationInt position:position image:image];
        } else {
            [[[[UIApplication sharedApplication]windows]firstObject] makeToast:message duration:durationInt position:position addPixelsY:addPixelsY == nil ? 0 : [addPixelsY intValue]];
        }
    });
}

RCT_EXPORT_METHOD(hide) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication]windows]firstObject] hideToast];
    });
}

@end