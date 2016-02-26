//
//  CHECSuitTableCell.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECBaseTableCell.h"
#import "CHECShoppingCartModel.h"

@interface CHECSuitTableCell : CHECBaseTableCell <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *goodsTitle;
@property (nonatomic, strong) UILabel *goodsPrice;
@property (nonatomic, strong) UITextField *goodsNumberTF;
@property (nonatomic, strong) CHECShoppingCartModel *model;

@end
