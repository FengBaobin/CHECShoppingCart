//
//  CHECShoppingCartVC.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHECShoppingCartFooterView.h"

@interface CHECShoppingCartVC : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CHECShoppingCartFooterView *footerView;

@end
