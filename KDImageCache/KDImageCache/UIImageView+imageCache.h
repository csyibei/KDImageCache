//
//  UIImageView+imageCache.h
//  KDImageCache
//
//  Created by laikidi on 17/3/22.
//  Copyright © 2017年 KiDiL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (imageCache)
- (void)kd_setImageWithURLString:(NSString *)urlString;
- (void)cleanCache;
@end
