//
//  CHECStoreHeaderView.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/23.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECStoreHeaderView.h"

@implementation CHECStoreHeaderView

// Initializer.
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
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
        make.top.equalTo(self.top).with.offset(5);
        make.left.equalTo(self.left);
        make.width.equalTo(@44);
        make.height.equalTo(@40);
    }];
    
    [self.storeTitle makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.selectButton);
        make.left.equalTo(self.selectButton.right).with.offset(10);
        make.right.equalTo(self.right).with.offset(-10);
        make.height.equalTo(self.selectButton.height);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)initView
{
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"GoodsUnselectedImage"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"GoodsSelectedImage"] forState:UIControlStateSelected];
    [self.selectButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton setTag:1001];
    [self addSubview:self.selectButton];
    
    self.storeTitle = [UILabel new];
    [self.storeTitle setNumberOfLines:1];
    [self.storeTitle setFont:[UIFont systemFontOfSize:14.0]];
    [self.storeTitle setTextColor:[UIColor blackColor]];
    [self addSubview:self.storeTitle];
}

- (void)buttonClicked:(UIButton *)sender
{
    if (sender.tag == 1001) {
        [sender setSelected:!sender.isSelected];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCUpdateSelectNotification object:self];
    }
}

@end
