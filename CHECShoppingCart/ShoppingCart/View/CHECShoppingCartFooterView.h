//
//  CHECShoppingCartFooterView.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/23.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHECShoppingCartFooterView : UIView

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIButton *settlementButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic, strong) NSString *totalAmount;

@end
