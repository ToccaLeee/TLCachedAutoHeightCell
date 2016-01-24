//
//  UITableViewCell+TLAutoHeight.m
//
//  Created by ToccaLee on 19/9/2015.
//  Copyright © 2015 ToccaLee. All rights reserved.
//

#import "UITableViewCell+TLAutoHeight.h"
#import "TLAutoHeightMacroDefine.h"

static char *const kCellCellIsEnforceFrameLayoutKey = "TLCellIsEnforceFrameLayoutKey";
static char *const kCellCellIsFixedHeightKey        = "TLCellCellIsFixedHeightKey";

@implementation UITableViewCell (TLAutoHeight)

TL_BOOL_ASSOCIATE(TL_isEnforceFrameLayout, setTL_isEnforceFrameLayout, false, kCellCellIsEnforceFrameLayoutKey)
TL_BOOL_ASSOCIATE(TL_isFixedHeight, setTL_isFixedHeight, false, kCellCellIsFixedHeightKey)

@end
