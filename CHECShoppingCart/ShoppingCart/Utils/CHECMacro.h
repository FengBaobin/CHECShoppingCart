//
//  CHECMacro.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/22.
//  Copyright © 2016年 CH. All rights reserved.
//

#ifndef CHECMacro_h
#define CHECMacro_h

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kNavigationBarHeight 44
#define kStatusBarHeight 20

#define kSCSectionHeaderViewHeight 50
#define kSCFooterViewHeight 60

#define kSCNormalCellHeight 134
#define kSCUnselectedCellHeight 100

#define kSCUpdateSelectNotification @"SCUpdateSelectNotification"
#define kSCUpdateTotalAmountNotification @"SCUpdateTotalAmountNotification"
#define kSCDeleteItemNotification @"SCDeleteItemNotification"

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* CHECMacro_h */
