//
//  CHECTableDataSourceDelegate.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/19.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableView+CHECExtension.h"

/**
 *  选中TableViewCell的Block
 */
typedef void(^DidSelectCellBlock)(NSIndexPath *indexPath, id item);

@class CHECBaseViewModel;

@interface CHECTableDataSourceDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

/**
 *  初始化方法
 */
- (id)initWithViewModel:(CHECBaseViewModel *)viewModel
   cellIdentifiersArray:(NSArray *)cellIdentifiersArray
         didSelectBlock:(DidSelectCellBlock)didselectBlock ;

/**
 *  设置UITableView的DataSource和Delegate为self
 */
- (void)handleDataSourceAndDelegateWithTableView:(UITableView *)tableView;

/**
 *  获取UITableView中Item所在的indexPath
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
