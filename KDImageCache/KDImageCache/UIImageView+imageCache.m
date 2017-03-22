//
//  UIImageView+imageCache.m
//  KDImageCache
//
//  Created by laikidi on 17/3/22.
//  Copyright © 2017年 KiDiL. All rights reserved.
//

#import "UIImageView+imageCache.h"
#import <objc/message.h>

#define dicKey @"dic"

@implementation UIImageView (imageCache)

- (void)setImageUrlDic:(NSDictionary *)imageUrlDic
{
    objc_setAssociatedObject(self, @"imageUrlDic",dicKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)imageUrlDic
{
    return objc_getAssociatedObject(self, dicKey);
}

- (void)kd_setImageWithURL:(NSURL *)url
{
    
}



@end

