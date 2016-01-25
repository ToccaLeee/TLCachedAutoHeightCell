//
//  UITableViewCell+TLAutoHeight.h
//
//  Created by ToccaLee on 19/9/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (TLAutoHeight)

// Whether the cell is fixed height. if YES, the cell height is only calculated once

@property (nonatomic, assign) BOOL TL_isFixedHeight;

// Whether the cell is enforced frame layout.

@property (nonatomic, assign) BOOL TL_isEnforceFrameLayout;

@end
