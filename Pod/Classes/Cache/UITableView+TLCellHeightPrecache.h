//
//  UITableView+TLCellHeightPrecache.h
//
//  Created by ToccaLee on 15/9/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TLCellHeightPrecache)

/**
 *  @brief Start precache cell height if needed
 *
 */

- (void)TL_precacheIfNeeded;

@end
