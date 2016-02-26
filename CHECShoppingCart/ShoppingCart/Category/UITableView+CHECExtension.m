//
//  UITableView+CHECExtension.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/19.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "UITableView+CHECExtension.h"
#import "CHECTableDataSourceDelegate.h"
#import <objc/runtime.h>

@implementation UITableView (CHECExtension)

@dynamic tableHandler;

- (CHECTableDataSourceDelegate *)tableHandler
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTableHandler:(CHECTableDataSourceDelegate *)tableHandler
{
    if (tableHandler) {
        [tableHandler handleDataSourceAndDelegateWithTableView:self];
    }
    objc_setAssociatedObject(self, @selector(tableHandler), tableHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
