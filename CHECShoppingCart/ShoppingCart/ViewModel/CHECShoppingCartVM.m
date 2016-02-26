//
//  CHECShoppingCartVM.m
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import "CHECShoppingCartVM.h"
#import "CHECShoppingCartModel.h"
#import "CHECGoodsTableCell.h"
#import "CHECSuitTableCell.h"
#import "CHECShoppingCartVC.h"
#import "CHECStoreHeaderView.h"
#import "CHECShoppingCartFooterView.h"

@implementation CHECShoppingCartVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self vmAddObserver:self selector:@selector(handleNotification:) name:kSCUpdateSelectNotification object:nil];
        [self vmAddObserver:self selector:@selector(handleNotification:) name:kSCUpdateTotalAmountNotification object:nil];
        [self vmAddObserver:self selector:@selector(handleNotification:) name:kSCDeleteItemNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self vmRemoveObserver:self name:kSCUpdateSelectNotification object:nil];
    [self vmRemoveObserver:self name:kSCUpdateTotalAmountNotification object:nil];
    [self vmRemoveObserver:self name:kSCDeleteItemNotification object:nil];
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kSCUpdateSelectNotification]) {
        if ([notification.object isKindOfClass:[CHECGoodsTableCell class]]) {
            CHECGoodsTableCell *object = (CHECGoodsTableCell *)notification.object;
            ((CHECShoppingCartModel *)((NSArray *)self.dataArray[object.indexPath.section])[object.indexPath.row]).selected = object.selectButton.selected;
            
            if ([self.viewController isKindOfClass:[CHECShoppingCartVC class]]) {
                [((CHECShoppingCartVC *)self.viewController).tableView reloadSections:[NSIndexSet indexSetWithIndex:object.indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else if ([notification.object isKindOfClass:[CHECSuitTableCell class]])
        {
            CHECSuitTableCell *object = (CHECSuitTableCell *)notification.object;
            ((CHECShoppingCartModel *)((NSArray *)self.dataArray[object.indexPath.section])[object.indexPath.row]).selected = object.selectButton.selected;
            
            if ([self.viewController isKindOfClass:[CHECShoppingCartVC class]]) {
                [((CHECShoppingCartVC *)self.viewController).tableView reloadSections:[NSIndexSet indexSetWithIndex:object.indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else if ([notification.object isKindOfClass:[CHECStoreHeaderView class]])
        {
            CHECStoreHeaderView *object = (CHECStoreHeaderView *)notification.object;
            [(NSArray *)self.dataArray[object.tag] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (((CHECShoppingCartModel *)obj).canSelect) {
                    ((CHECShoppingCartModel *)obj).selected = object.selectButton.selected;
                }
            }];
            
            if ([self.viewController isKindOfClass:[CHECShoppingCartVC class]]) {
                [((CHECShoppingCartVC *)self.viewController).tableView reloadSections:[NSIndexSet indexSetWithIndex:object.tag] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else if ([notification.object isKindOfClass:[CHECShoppingCartFooterView class]]) {
            CHECShoppingCartFooterView *object = (CHECShoppingCartFooterView *)notification.object;
            [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (((CHECShoppingCartModel *)obj).canSelect) {
                        ((CHECShoppingCartModel *)obj).selected = object.selectButton.selected;
                    }
                }];
            }];
            
            if ([self.viewController isKindOfClass:[CHECShoppingCartVC class]]) {
                [((CHECShoppingCartVC *)self.viewController).tableView reloadData];
            }
        }
        
        [self refreshSCFooterView:notification];
    }
    else if ([notification.name isEqualToString:kSCUpdateTotalAmountNotification])
    {
        [self refreshSCFooterView:notification];
    }
    else if ([notification.name isEqualToString:kSCDeleteItemNotification])
    {
        [self handleDeleteItem:notification];
        [self refreshSCFooterView:notification];
    }
}

- (void)handleDeleteItem:(NSNotification *)notification
{
    if (notification.userInfo) {
        // 单个删除
        NSIndexPath *indexPath = notification.userInfo[@"indexPath"];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
        [indexSet addIndex:indexPath.row];
        for (NSInteger i = (indexPath.row + 1); i < ((NSArray *)self.dataArray[indexPath.section]).count; ++i) {
            if (!(((CHECShoppingCartModel *)((NSArray *)self.dataArray[indexPath.section])[i]).canSelect)) {
                [indexSet addIndex:i];
            }
            else
            {
                break;
            }
        }
        [(NSMutableArray *)(self.dataArray[indexPath.section]) removeObjectsAtIndexes:indexSet];
        if ([(NSMutableArray *)(self.dataArray[indexPath.section]) count] == 0) {
            [self.dataArray removeObjectAtIndex:indexPath.section];
        }
    }
    else
    {
        // 批量删除
        @weakify(self);
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            
            __block NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
            __block BOOL deleteFlagForCannotSelect = NO;
            
            [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (((CHECShoppingCartModel *)obj).canSelect) {
                    deleteFlagForCannotSelect = NO;
                    if (((CHECShoppingCartModel *)obj).selected) {
                        [indexSet addIndex:idx];
                        deleteFlagForCannotSelect = YES;
                    }
                }
                else
                {
                    if (deleteFlagForCannotSelect) {
                        [indexSet addIndex:idx];
                    }
                }
            }];
            
            [(NSMutableArray *)(self.dataArray[idx]) removeObjectsAtIndexes:indexSet];
            if ([(NSMutableArray *)(self.dataArray[idx]) count] == 0) {
                [self.dataArray removeObjectAtIndex:idx];
            }
        }];
    }
    
    if ([self.viewController isKindOfClass:[CHECShoppingCartVC class]]) {
        [((CHECShoppingCartVC *)self.viewController).tableView reloadData];
    }
}

- (void)refreshSCFooterView:(NSNotification *)notification
{
    __block BOOL allSelected = self.dataArray.count>0;
    __block NSInteger selectedNumber = 0;
    __block CGFloat totalAmount = 0.00;
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (((CHECShoppingCartModel *)obj).canSelect && !((CHECShoppingCartModel *)obj).selected) {
                allSelected = NO;
            }
            else if (((CHECShoppingCartModel *)obj).canSelect && ((CHECShoppingCartModel *)obj).selected) {
                selectedNumber += ((CHECShoppingCartModel *)obj).goodsQuantity;
                totalAmount += [((CHECShoppingCartModel *)obj).goodsPrice floatValue] * ((CHECShoppingCartModel *)obj).goodsQuantity;
            }
        }];
    }];
    
    
    if ([self.viewController isKindOfClass:[CHECShoppingCartVC class]]) {
        [((CHECShoppingCartVC *)self.viewController).footerView.selectButton setSelected:allSelected];
        [((CHECShoppingCartVC *)self.viewController).footerView setSelectedNumber:selectedNumber];
        [((CHECShoppingCartVC *)self.viewController).footerView setTotalAmount:[NSString stringWithFormat:@"%.2f", totalAmount]];
    }
}

- (NSInteger)numberOfSections
{
    return self.dataArray.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.dataArray[section]).count;
}

- (void)getDataSuccessHandler:(void (^)())successHandler
{
    self.dataArray = [NSMutableArray arrayWithObjects:[self createVirtualData], [self createVirtualData], nil];
    
    if (successHandler) {
        successHandler();
    }
}

- (NSMutableArray *)createVirtualData
{
    NSMutableArray *sectionData = [NSMutableArray new];
    for (int i = 0; i < 7; ++i) {
        CHECShoppingCartModel *item = [CHECShoppingCartModel new];
        item.storeName = @"购食汇";
        item.goodsImageUrl = @"AppleLogo";
        
        if (i % 7 == 0) {
            item.goodsName = @"苹果iPhone";
            item.goodsPrice = @"6088.00";
            item.goodsQuantity = 1;
            item.goodsType = @"0";
            item.selected = YES;
            item.canSelect = YES;
        }
        else if (i % 7 == 1)
        {
            item.goodsName = @"苹果iPhone苹果iPhone苹果iPhone苹果iPhone苹果iPhone";
            item.goodsPrice = @"5288.00";
            item.goodsQuantity = 2;
            item.goodsType = @"1";
            item.selected = YES;
            item.canSelect = YES;
        }
        else if (i % 7 == 2)
        {
            item.goodsName = @"苹果iPhone苹果iPhone苹果iPhone赠品";
            item.goodsPrice = @"5288.00";
            item.goodsQuantity = 2;
            item.goodsType = @"2";
            item.selected = NO;
            item.canSelect = NO;
        }
        else if (i % 7 == 3)
        {
            item.goodsName = @"套装";
            item.goodsPrice = @"18288.00";
            item.goodsQuantity = 3;
            item.goodsType = @"3";
            item.selected = YES;
            item.canSelect = YES;
        }
        else if (i % 7 == 4)
        {
            item.goodsName = @"套装苹果iPhone";
            item.goodsPrice = @"8288.00";
            item.goodsQuantity = 3;
            item.goodsType = @"4";
            item.selected = NO;
            item.canSelect = NO;
        }
        else if (i % 7 == 5)
        {
            item.goodsName = @"套装苹果iPhone套装苹果iPhone套装苹果iPhone套装苹果iPhone套装苹果iPhone套装苹果iPhone";
            item.goodsPrice = @"5000.00";
            item.goodsQuantity = 3;
            item.goodsType = @"4";
            item.selected = NO;
            item.canSelect = NO;
        }
        else if (i % 7 == 6)
        {
            item.goodsName = @"套装苹果iPhone";
            item.goodsPrice = @"5000.00";
            item.goodsQuantity = 3;
            item.goodsType = @"4";
            item.selected = NO;
            item.canSelect = NO;
        }
        
        [sectionData addObject:item];
    }
    
    return sectionData;
}

@end
