//
//  UITableView+CHECExtension.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/19.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHECTableDataSourceDelegate;

@interface UITableView (CHECExtension)

@property (nonatomic, strong) CHECTableDataSourceDelegate *tableHandler;

@end
