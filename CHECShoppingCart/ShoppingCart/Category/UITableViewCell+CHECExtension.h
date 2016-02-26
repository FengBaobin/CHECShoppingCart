//
//  UITableViewCell+CHECExtension.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/19.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (CHECExtension)

/**
 *  根据重用标识符注册TableViewCell
 */
+ (void)registerWithTableView:(UITableView *)tableView
                    cellClass:(id)cellClass
              reuseIdentifier:(NSString *)reuseIdentifier;
/**
 *  配置TableViewCell，设置TableViewCell内容
 */
- (void)configureWithTableCell:(id)tableCell
                  customObject:(id)customObject
                     indexPath:(NSIndexPath *)indexPath;

@end
