//
//  UITableViewCell+CHECExtension.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/19.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "UITableViewCell+CHECExtension.h"

@implementation UITableViewCell (CHECExtension)

#pragma mark - Public

+ (void)registerWithTableView:(UITableView *)tableView cellClass:(id)cellClass reuseIdentifier:(NSString *)reuseIdentifier
{
    [tableView registerClass:cellClass forCellReuseIdentifier:reuseIdentifier];
}

#pragma mark --
#pragma mark - Rewrite these func in SubClass !

- (void)configureWithTableCell:(id)tableCell customObject:(id)customObject indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    
}

@end
