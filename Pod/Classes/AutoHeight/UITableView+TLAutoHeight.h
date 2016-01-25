//
//  UITableView+TLAutoHeight.h
//
//  Created by ToccaLee on 10/10/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TLAutoHeight)

/**
 *  @brief Calculate cell height without cache
 *
 *  @param identifier Cell reusable identifier
 *
 *  @param completion Configuration block which config cell's model data
 *
 */

- (CGFloat)TL_autoHeightForCellWithIdentifer:(nonnull NSString *)identifer
                               configuration:(void(^ _Nullable)(id _Nonnull cell))configuration;

@end
