//
//  TLTableViewCellPositionBasedHeightCache.h
//
//  Created by ToccaLee on 25/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTableViewCellPositionBasedHeightCache : NSObject

@property (nonatomic, strong, readonly, nonnull) NSMutableArray<NSMutableArray<NSNumber *> *> *rowHeightCacheData;

- (void)buildHeightCacheAtIndexPathsIfNeeded:(nullable NSArray<NSIndexPath *> *)indexPaths;
- (BOOL)hasCachedHeightAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)cacheHeightForIndexPath:(nonnull NSIndexPath *)indexPath height:(CGFloat)height;
- (CGFloat)cachedHeightAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end



