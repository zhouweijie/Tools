//
//  UIView+Extension.m
//  EEOClassroom
//
//  Created by 周位杰 on 2020/9/2.
//  Copyright © 2020 jiangmin. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)
+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeSel:@selector(intrinsicContentSize) swizSel:@selector(EEO_intrisicContentSize)];
        [self exchangeSel:@selector(layoutSubviews) swizSel:@selector(EEO_layoutSubviews)];
    });
}

+ (void)exchangeSel:(SEL)originSel swizSel:(SEL)swizSel {
    Method originMethod = class_getInstanceMethod(self, originSel);
    Method swizMethod = class_getInstanceMethod(self, swizSel);
    BOOL didAddMethod = class_addMethod(self, originSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(self, swizSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizMethod);
    }
}

#pragma mark - hook intrisicContentSize
- (void)setCustomIntrinsicContentSize:(CGSize)customIntrinsicContentSize {
    objc_setAssociatedObject(self, @selector(customIntrinsicContentSize), @(customIntrinsicContentSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
    
- (CGSize)customIntrinsicContentSize {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number.CGSizeValue;
}

- (CGSize)EEO_intrisicContentSize {
    if (CGSizeEqualToSize(self.customIntrinsicContentSize, CGSizeZero)) {
        return [self EEO_intrisicContentSize];
    } else {
        return [self customIntrinsicContentSize];
    }
}

#pragma mark - hook layoutSubViews
- (void (^)(void))didLayoutSubviewsBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDidLayoutSubviewsBlock:(void (^)(void))didLayoutSubviewsBlock {
    objc_setAssociatedObject(self, @selector(didLayoutSubviewsBlock), didLayoutSubviewsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)EEO_layoutSubviews {
    [self EEO_layoutSubviews];
    if (self.didLayoutSubviewsBlock) {
        self.didLayoutSubviewsBlock();
    }
}
@end
