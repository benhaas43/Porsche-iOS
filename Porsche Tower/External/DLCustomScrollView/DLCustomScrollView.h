//
//  ViewController.h
//  Porsche Tower
//
//  Created by Daniel on 5/7/15. (infinitecustomscrollview reference)
//  Copyright (c) 2015 Daniel Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum ScrollDirection {
    ScrollDirectionRight,
    ScrollDirectionLeft,
} ScrollDirection;

@class DLCustomScrollView;

@protocol DLCustomScrollViewDelegate <NSObject>
-(void)scrollView:(DLCustomScrollView *)scrollView updateView:(UIView *)view withDistanceToCenter:(CGFloat)distance scrollDirection:(ScrollDirection)direction;
@optional
- (void)scrollView:(DLCustomScrollView *)scrollView didScrollToOffset:(CGPoint)offset;
@end

@protocol DLCustomScrollViewDataSource <NSObject>

- (UIView *)scrollView:(DLCustomScrollView *)scrollView viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
- (NSInteger)numberOfViews:(DLCustomScrollView *)scrollView;
- (CGFloat)widthOfView:(DLCustomScrollView *)scrollView;
@end

@interface DLCustomScrollView : UIView
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, weak) id<DLCustomScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<DLCustomScrollViewDelegate> delegate;
@property (nonatomic) BOOL scrollEnabled;
@property (nonatomic) BOOL pagingEnabled;
@property (nonatomic) NSInteger maxScrollDistance;

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToOffset:(CGPoint)offset animated:(BOOL)animated;
- (CGSize)contentSize;
- (UIView *)viewAtIndex:(NSInteger)index;
- (NSArray *)allViews;
@end
