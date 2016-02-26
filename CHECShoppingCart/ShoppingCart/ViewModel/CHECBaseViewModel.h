//
//  CHECBaseViewModel.h
//  CHECShoppingCart
//
//  Created by CH on 16/2/18.
//  Copyright © 2016年 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHECBaseViewModel : NSObject

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  Initializer.
 *
 *  @param viewController vc binding.
 *
 *  @return view mdoel.
 */
+ (instancetype)viewModelWithViewController:(UIViewController *)viewController;

/**
 *  Section number for table view.
 *
 *  @return section number.
 */
- (NSInteger)numberOfSections;

/**
 *  Row number for section.
 *
 *  @param section section index in table view.
 *
 *  @return row number.
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/**
 *  Get data and handle block.
 *
 *  @param successHandler handle block.
 */
- (void)getDataSuccessHandler:(void (^)())successHandler;

// 注册通知
- (void)vmAddObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
// 移除注册
- (void)vmRemoveObserver:(id)observer name:(NSString *)aName object:(id)anObject;

@end
