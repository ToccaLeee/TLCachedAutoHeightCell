//
//  TLTableViewCellPositionBasedHeightCache.h
//
//  Created by ToccaLee on 25/8/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTableViewCellPositionBasedHeightCache : NSObject

@property (nonatomic, strong, readonly, nonnull) NSMutableArray<NSMutableArray<NSNumber *> *> *rowHeightCacheData;

/**
 *  @brief build inital cell height cache for indexPaths if needed
 *
 *  @param indexPaths The indexPaths whose cache will be initialed
 *
 */

- (void)buildHeightCacheAtIndexPathsIfNeeded:(nullable NSArray<NSIndexPath *> *)indexPaths;

/**
 *  @brief Check the cache has cell's height at indexPath
 *
 *  @param indexPath The indexPath the the cache height at
 *
 */

- (BOOL)hasCachedHeightAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 *  @brief Cache cell height by indexPath
 *
 *  @param indexPath The indexPath the the cache height at
 *
 *  @param height The cell's height that will be cached
 *
 */

- (void)cacheHeightForIndexPath:(nonnull NSIndexPath *)indexPath height:(CGFloat)height;

/**
 *  @brief Get the cached cell height by indexPath
 *
 *  @param indexPath The indexPath the the cache height at
 *
 */

- (CGFloat)cachedHeightAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end



