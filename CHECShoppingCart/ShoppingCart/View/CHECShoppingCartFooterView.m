//
//  CHECShoppingCartFooterView.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/23.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECShoppingCartFooterView.h"

@implementation CHECShoppingCartFooterView

// Initializer.
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5;
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.6];
        
        self.editing = NO;
        self.selectedNumber = 0;
        self.totalAmount = @"0.00";
        
        [self initView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints
{
    // --- remake/update constraints here
    @weakify(self);
    [self.selectButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.top).with.offset(10);
        make.left.equalTo(self.left);
        make.width.equalTo(@68);
        make.height.equalTo(@40);
    }];
    
    [self.amountLabel makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.selectButton);
        make.left.equalTo(self.selectButton.right);
        make.right.equalTo(self.right).with.offset(-120);
        make.height.equalTo(self.selectButton.height);
    }];
    
    [self.settlementButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.top);
        make.right.equalTo(self.right);
        make.width.equalTo(@120);
        make.height.equalTo(self.height);
    }];
    
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.selectButton);
        make.right.equalTo(self.right).with.offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(self.selectButton);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)initView
{
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"GoodsUnselectedImage"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"GoodsSelectedImage"] forState:UIControlStateSelected];
    [self.selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.selectButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton setTag:1001];
    [self addSubview:self.selectButton];
    
    self.amountLabel = [UILabel new];
    [self.amountLabel setNumberOfLines:1];
    [self.amountLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.amountLabel setTextColor:[UIColor whiteColor]];
    [self.amountLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:self.amountLabel];
    
    self.settlementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settlementButton setBackgroundColor:[UIColor redColor]];
    [self.settlementButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.settlementButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.settlementButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.settlementButton setTag:1002];
    [self addSubview:self.settlementButton];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setBackgroundColor:[UIColor redColor]];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton setTag:1003];
    [self.deleteButton.layer setCornerRadius:5.0];
    [self addSubview:self.deleteButton];
    
    [self updateView];
}

- (void)updateView
{
    if (self.editing) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:1.0];
        [self.selectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self.amountLabel setHidden:YES];
        [self.settlementButton setHidden:YES];
        [self.deleteButton setHidden:NO];
    }
    else
    {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.8];
        [self.selectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [self.amountLabel setHidden:NO];
        [self.settlementButton setHidden:NO];
        [self.deleteButton setHidden:YES];
    }
    
    [self.amountLabel setText:[NSString stringWithFormat:@"合计：¥%@", self.totalAmount]];
    [self.settlementButton setTitle:[NSString stringWithFormat:@"去结算(%ld)", self.selectedNumber] forState:UIControlStateNormal];
}

- (void)buttonClicked:(UIButton *)sender
{
    if (sender.tag == 1001) {
        [sender setSelected:!sender.isSelected];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCUpdateSelectNotification object:self];
    }
    else if (sender.tag == 1002)
    {
    }
    else if (sender.tag == 1003)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCDeleteItemNotification object:self];
    }
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    [self updateView];
}

- (void)setTotalAmount:(NSString *)totalAmount
{
    _totalAmount = totalAmount;
    [self updateView];
}

- (void)setSelectedNumber:(NSInteger)selectedNumber
{
    _selectedNumber = selectedNumber;
    [self updateView];
}

@end
