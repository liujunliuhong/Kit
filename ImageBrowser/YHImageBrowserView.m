//
//  YHImageBrowserView.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserView.h"
#import "YHImageBrowserViewDataSource.h"
#import "YHImageBrowserCellProtocol.h"
#import "YHImageBrowserCollectionViewFlowLayout.h"

#define kPreloadCount         2
#define kCacheCountLimit      8

@interface YHImageBrowserView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) CGSize containerSize;
@property (nonatomic, strong) NSCache *dataCache;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, assign) YHImageBrowserLayoutDirection layoutDirection;
@property (nonatomic, strong) NSMutableSet *reuseIdentifierSet;

@end

@implementation YHImageBrowserView

- (void)dealloc
{
    self.dataCache = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[YHImageBrowserCollectionViewFlowLayout new]];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.reuseIdentifierSet = [NSMutableSet set];
        self.currentIndex = -1;
        
        self.delegate = self;
        self.dataSource = self;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor orangeColor];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

/**
 * 根据屏幕旋转方向更新布局
 */
- (void)updateLayoutWithDirection:(YHImageBrowserLayoutDirection)direction containerSize:(CGSize)containerSize{
    self.containerSize = containerSize;
    self.layoutDirection = direction;
    self.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
    
    if (self.superview) {
        NSArray<UICollectionViewCell<YHImageBrowserCellProtocol> *> *cells = [self visibleCells];
        [cells enumerateObjectsUsingBlock:^(UICollectionViewCell<YHImageBrowserCellProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(yh_browserLayoutDirectionChanged:containerSize:)]) {
                [obj yh_browserLayoutDirectionChanged:self.layoutDirection containerSize:self.containerSize];
            }
        }];
        [self scrollToPageIndex:self.currentIndex];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

/**
 * 滑动到指定索引
 */
- (void)scrollToPageIndex:(NSInteger)index{
    if (index >= [self.yh_dataSource yh_numberOfCellForImageBrowserView:self]) {
        self.currentIndex = [self.yh_dataSource yh_numberOfCellForImageBrowserView:self] - 1;
        self.contentOffset = CGPointMake(self.bounds.size.width * self.currentIndex, 0);
    } else {
        CGPoint targetPoint = CGPointMake(self.bounds.size.width * index, 0);
        if (CGPointEqualToPoint(self.contentOffset, targetPoint)) {
            [self scrollViewDidScroll:self];
        } else {
            self.contentOffset = targetPoint; // 会走didScroll代理
        }
    }
}

/**
 * 获取指定索引的data
 */
- (id<YHImageBrowserCellDataProtocol>)dataAtIndex:(NSUInteger)index {
    if (index < 0 || index >= [self.yh_dataSource yh_numberOfCellForImageBrowserView:self]) return nil;
    
    id<YHImageBrowserCellDataProtocol> data;
    if (self.dataCache && [self.dataCache objectForKey:@(index)]) {
        data = [self.dataCache objectForKey:@(index)];
    } else {
        data = [self.yh_dataSource yh_imageBrowserView:self dataForCellAtIndex:index];
        [self.dataCache setObject:data forKey:@(index)];
    }
    return data;
}


#pragma mark ------------------ UICollectionViewDataSource ------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.yh_dataSource yh_numberOfCellForImageBrowserView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    id<YHImageBrowserCellDataProtocol> data = [self dataAtIndex:indexPath.item];
    
    Class cellClass = [data yh_cellClass];
    
    NSString *identifier = NSStringFromClass(cellClass);
    
    
    if (![self.reuseIdentifierSet containsObject:identifier]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"];
        if (path) {
            [collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        } else {
            [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        }
        [self.reuseIdentifierSet addObject:identifier];
    }
    
    UICollectionViewCell<YHImageBrowserCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSLog(@"😆%@", cell);
    
    
    [cell yh_browserSetInitialCellData:data layoutDirection:self.layoutDirection containerSize:self.containerSize];
    
    
    return cell;
}

#pragma mark ------------------ UIScrollViewDelegate ------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat indexF = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSUInteger index = (NSUInteger)(indexF + 0.5);
    
    if (index >= [self.yh_dataSource yh_numberOfCellForImageBrowserView:self] || index < 0) {
        return;
    }
    if (self.currentIndex != index) {
        self.currentIndex = index;
        
        if (self.yh_delegate && [self.yh_delegate respondsToSelector:@selector(yh_imageBrowserView:pageIndexChanged:)]) {
            [self.yh_delegate yh_imageBrowserView:self pageIndexChanged:self.currentIndex];
        }
    }
}


#pragma mark ------------------ Getter ------------------
- (NSCache *)dataCache{
    if (!_dataCache) {
        _dataCache = [[NSCache alloc] init];
        _dataCache.countLimit = kCacheCountLimit;
    }
    return _dataCache;
}

- (id<YHImageBrowserCellDataProtocol>)currentData{
    return [self dataAtIndex:self.currentIndex];
}

@end
