//
//  CHECGoodsTableCell.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECGoodsTableCell.h"
#import "UITableViewCell+CHECExtension.h"

@implementation CHECGoodsTableCell

// Initializer.
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self initCellView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)dealloc
{
    [self.model removeObserver:self forKeyPath:@"goodsQuantity"];
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
        make.top.equalTo(self.contentView.top).with.offset(10);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(@44);
        make.height.equalTo(@80);
    }];
    
    [self.goodsThumbnail makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.selectButton);
        make.left.equalTo(self.selectButton.right);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.goodsTitle makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.selectButton);
        make.left.equalTo(self.goodsThumbnail.right).with.offset(10);
        make.right.equalTo(self.contentView.right).with.offset(-10);
        make.height.greaterThanOrEqualTo(@17);
        make.height.lessThanOrEqualTo(@40);
    }];
    
    [self.goodsPrice makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.selectButton).with.offset(80 - 17);
        make.left.right.equalTo(self.goodsTitle);
        make.height.equalTo(@17);
    }];
    
    [self.goodsNumberTF makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.goodsThumbnail.bottom).with.offset(10);
        make.left.right.equalTo(self.goodsThumbnail);
        make.height.equalTo(@24);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)initCellView
{
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"GoodsUnselectedImage"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"GoodsSelectedImage"] forState:UIControlStateSelected];
    [self.selectButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton setTag:1001];
    [self.contentView addSubview:self.selectButton];
    
    self.goodsThumbnail = [UIImageView new];
    [self.contentView addSubview:self.goodsThumbnail];
    
    self.goodsTitle = [UILabel new];
    [self.goodsTitle setNumberOfLines:0];
    [self.goodsTitle setFont:[UIFont systemFontOfSize:14.0]];
    [self.goodsTitle setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:self.goodsTitle];
    
    self.goodsPrice = [UILabel new];
    [self.goodsPrice setFont:[UIFont systemFontOfSize:14.0]];
    [self.goodsPrice setTextColor:[UIColor redColor]];
    [self.contentView addSubview:self.goodsPrice];
    
    self.goodsNumberTF = [UITextField new];
    self.goodsNumberTF.textAlignment = NSTextAlignmentCenter;
    self.goodsNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsNumberTF.font = [UIFont systemFontOfSize:14.0];
    self.goodsNumberTF.textColor = [UIColor darkGrayColor];
    self.goodsNumberTF.clipsToBounds = YES;
    self.goodsNumberTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.goodsNumberTF.layer.borderWidth = 0.5;
    
    UIButton *subButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 24)];
    [subButton setBackgroundImage:[UIImage imageNamed:@"GoodsNumberSubNormalImage"] forState:UIControlStateNormal];
    [subButton setBackgroundImage:[UIImage imageNamed:@"GoodsNumberSubDisableImage"] forState:UIControlStateDisabled];
    [subButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subButton setTag:1002];
    [subButton setExclusiveTouch:YES];
    self.goodsNumberTF.leftView = subButton;
    self.goodsNumberTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 24)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"GoodsNumberAddNormalImage"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"GoodsNumberAddDisableImage"] forState:UIControlStateDisabled];
    [addButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTag:1003];
    [addButton setExclusiveTouch:YES];
    self.goodsNumberTF.rightView = addButton;
    self.goodsNumberTF.rightViewMode = UITextFieldViewModeAlways;
    
    [self.goodsNumberTF setDelegate:self];
    [self.contentView addSubview:self.goodsNumberTF];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.goodsNumberTF];
}

- (void)buttonClicked:(UIButton *)sender
{
    if (sender.tag == 1001) {
        [sender setSelected:!sender.isSelected];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCUpdateSelectNotification object:self];
    }
    else if (sender.tag == 1002)
    {
        if (self.model.goodsQuantity > 1) {
            --self.model.goodsQuantity;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCUpdateTotalAmountNotification object:nil];
    }
    else if (sender.tag == 1003)
    {
        ++self.model.goodsQuantity;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSCUpdateTotalAmountNotification object:nil];
    }
}

- (void)textFieldDidChange:(NSNotification *)notification
{
    if (self.goodsNumberTF.text && self.goodsNumberTF.text.length > 0 && [self.goodsNumberTF.text integerValue] > 0) {
        self.model.goodsQuantity = [self.goodsNumberTF.text integerValue];
    }
}

- (void)configureWithTableCell:(id)tableCell customObject:(id)customObject indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    if (self.model) {
        [self.model removeObserver:self forKeyPath:@"goodsQuantity"];
    }
    self.model = (CHECShoppingCartModel *)customObject;
    [self.model addObserver:self forKeyPath:@"goodsQuantity" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    [self.selectButton setHidden:!(self.model.canSelect)];
    [self.selectButton setSelected:self.model.selected];
    [self.goodsThumbnail setImage:[UIImage imageNamed:self.model.goodsImageUrl]];
    [self.goodsTitle setText:self.model.goodsName];
    [self.goodsTitle sizeToFit];
    [self.goodsPrice setText:[NSString stringWithFormat:@"¥%@", self.model.goodsPrice]];
    [self.goodsNumberTF setHidden:!(self.model.canSelect)];
    [self.goodsNumberTF setText:[NSString stringWithFormat:@"%ld", self.model.goodsQuantity]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"goodsQuantity"]) {
        [self.goodsNumberTF setText:[NSString stringWithFormat:@"%ld", self.model.goodsQuantity]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.goodsNumberTF setText:[NSString stringWithFormat:@"%ld", self.model.goodsQuantity]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSCUpdateTotalAmountNotification object:nil];
}

@end
