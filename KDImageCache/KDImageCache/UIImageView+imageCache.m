//
//  UIImageView+imageCache.m
//  KDImageCache
//
//  Created by laikidi on 17/3/22.
//  Copyright © 2017年 KiDiL. All rights reserved.
//

#import "UIImageView+imageCache.h"
#import <objc/runtime.h>

static char imageDicKey;
static char operationQueueKey;
static char operationDicKey;

typedef NSMutableDictionary<NSString *,id> KDImageDic;
typedef NSMutableDictionary<NSString *,id> KDOperationDic;
typedef NSOperationQueue KDOperationQueue;

@implementation UIImageView (imageCache)


- (NSMutableDictionary *)KDOperationDic
{
    KDOperationDic *operationDic = objc_getAssociatedObject(self, &operationDicKey);
    if (operationDic) {
        return operationDic;
    }
    operationDic = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &operationDicKey, operationDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operationDic;
}

- (NSOperationQueue *)KDOperationQueue
{
    KDOperationQueue *operationQueue = objc_getAssociatedObject(self, &operationQueueKey);
    if (operationQueue) {
         return operationQueue;
    }
    operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 4;
    objc_setAssociatedObject(self, &operationQueueKey, operationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operationQueue;
}

- (NSMutableDictionary *)KDImageDic
{
    KDImageDic *ImageDic = objc_getAssociatedObject(self, &imageDicKey);
    if (ImageDic) {
        return ImageDic;
    }
    ImageDic = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &imageDicKey, ImageDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return ImageDic;
}

- (void)kd_setImageWithURLString:(NSString *)urlString
{
    NSString *imageName = [urlString lastPathComponent];
    UIImage *image = [[self KDImageDic] objectForKey:imageName];
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *imageCache = [cachePath stringByAppendingPathComponent:@"imageCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isdirectioy;
    if (![fileManager fileExistsAtPath:imageCache isDirectory:&isdirectioy]) {
        [fileManager createDirectoryAtPath:imageCache withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imageCachePath = [imageCache stringByAppendingPathComponent:imageName];
    if (image) {
        self.image = image;
    }else{
        NSData *cacheImageData = [NSData dataWithContentsOfFile:imageCachePath];
        if (cacheImageData) {
            UIImage *cacheImage = [UIImage imageWithData:cacheImageData];
            [[self KDImageDic] setObject:cacheImage forKey:imageName];
            self.image = cacheImage;
        }else{
            NSBlockOperation *loadImageOperation = [[self KDOperationDic] objectForKey:imageName];
            if (!loadImageOperation) {
                loadImageOperation = [NSBlockOperation blockOperationWithBlock:^{
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                    if (!imageData) {
                        [[self KDOperationDic] removeObjectForKey:imageName];
                        return;
                    }
                    UIImage *image = [UIImage imageWithData:imageData];
                    [[self KDImageDic] setObject:image forKey:imageName];
                    [imageData writeToFile:imageCachePath atomically:YES];
                    [[self KDOperationDic] removeObjectForKey:imageName];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        [self setNeedsLayout];
//                        [self layoutIfNeeded];
                        NSLog(@"%@",self);
                         [self setNeedsLayout];
                        self.image = image;
//                        [self sizeToFit];
                        [self layoutIfNeeded];
                        NSLog(@"%@",self);
                    }];
                }];
                [[self KDOperationQueue] addOperation:loadImageOperation];
                [[self KDOperationDic] setObject:loadImageOperation forKey:imageName];
            }
        }
    }
}

- (void)cleanCache
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *imageCache = [cachePath stringByAppendingPathComponent:@"imageCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imageCache isDirectory:nil]) {
        NSError *error = nil;
         [[NSFileManager defaultManager] removeItemAtPath:imageCache error:&error];
    }
}

- (void)didReceiveMemoryWarning
{
    [[self KDOperationDic] removeAllObjects];
    [[self KDImageDic] removeAllObjects];;
}




@end

