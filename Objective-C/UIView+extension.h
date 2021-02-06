//
//  UIView+Extension.h
//  EEOClassroom
//
//  Created by 周位杰 on 2020/9/2.
//  Copyright © 2020 jiangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)
@property (nonatomic, assign) CGSize customIntrinsicContentSize;
@property (nonatomic, copy) void (^didLayoutSubviewsBlock)(void);
@end

NS_ASSUME_NONNULL_END
