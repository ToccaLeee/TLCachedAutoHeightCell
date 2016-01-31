# TLCachedAutoHeightCell

[![CI Status](http://img.shields.io/travis/ToccaLee/TLCachedAutoHeightCell.svg?style=flat)](https://travis-ci.org/ToccaLee/TLCachedAutoHeightCell)
[![Version](https://img.shields.io/cocoapods/v/TLCachedAutoHeightCell.svg?style=flat)](http://cocoapods.org/pods/TLCachedAutoHeightCell)
[![License](https://img.shields.io/cocoapods/l/TLCachedAutoHeightCell.svg?style=flat)](http://cocoapods.org/pods/TLCachedAutoHeightCell)
[![Platform](https://img.shields.io/cocoapods/p/TLCachedAutoHeightCell.svg?style=flat)](http://cocoapods.org/pods/TLCachedAutoHeightCell)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The pod project can be divided into two parts, cell height calculation and cache. You can use both or one of them as your requirements.

1. Height Cache usage:

   1.1 Position based height cache
    ```ruby
   	- (void)buildHeightCacheAtIndexPathsIfNeeded:(nullable NSArray<NSIndexPath *> *)indexPaths;

		- (BOOL)hasCachedHeightAtIndexPath:(nonnull NSIndexPath *)indexPath;

		- (void)cacheHeightForIndexPath:(nonnull NSIndexPath *)indexPath height:(CGFloat)height;

		- (CGFloat)cachedHeightAtIndexPath:(nonnull NSIndexPath *)indexPath;
	```

   1.2 Content based height cache
   ```ruby
  		- (CGFloat)cachedHeightWithReuseIdentifier:(nonnull NSString *)reuseIdentifer
                          		          modelKey:(nonnull id)modelKey
            		        heightAffectedProperties:(nullable NSArray<id> *)properties;

      - (void)cacheHeightForReuseIdentifier:(nonnull NSString *)reuseIdentifer
                      		         modelKey:(nonnull id)modelKey
       		         heightAffectedProperties:(nullable NSArray<id> *)properties
                      	             height:(CGFloat)height;

      - (BOOL)hasCachedHeightForReuseIdentifier:(nonnull NSString *)reuseIdentifer
                                       modelKey:(nonnull id)modelKey
                       heightAffectedProperties:(nullable NSArray<id> *)properties;
   ```

2. Height calculation usage:

	2.1 None-Cache Auto Height (never cache cell height):

	```ruby
	- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	    return [tableView TL_autoHeightForCellWithReuseIdentifer:NSStringFromClass([TestTableViewCell class])                     configuration:^(TestTableViewCell *cell) {
	        cell.model = self.models[indexPath.row];
	    }];
	}
	```

	2.2 Position Based Cache Auto Height (cache cell height by the indexpath):

	```ruby
	- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	    return [tableView TL_autoHeightForCellWithReuseIdentifer:NSStringFromClass([TestTableViewCell class])
	                                                   indexPath:indexPath
	                                               configuration:^(TestTableViewCell * cell) {
	                                                    cell.model = self.models[indexPath.row];
	                                               }];
	}
	```

	2.3 Content Based Cache Auto Height (cache cell height by the modelkey and heightAffectedProperties provided):
	```ruby
	- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	    return [tableView TL_autoHeightForCellWithReuseIdentifer:NSStringFromClass([TestTableViewCell class])
	                                                    modelKey:@(self.models[indexPath.row].modelId)
	                                    heightAffectedProperties:@[self.models[indexPath.row].title, self.models[indexPath.row].content]
	                                               configuration:^(TestTableViewCell  *cell) {
	                                                    cell.model = self.models[indexPath.row];
	                                               }];
	}
	```

  2.4 fixedHeight cell height(Calculate cell height, and the cell height only be calculated once).
  ```ruby
  - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      return [tableView TL_fixedHeightForCellWithReuseIdentifer:NSStringFromClass([TestTableViewCell class])
                                                  configuration:^(TestTableViewCell  *cell) {
                                                       cell.model = self.models[indexPath.row];
                                                  }];
  }
  ```
## Note

For auto calculate cell height, the UITableViewCell should use autolayout or override the UIView method  ``` - (CGSize)sizeThatFits:(CGSize)size ``` .
The identifier provided should the same as the cell reusableIdentifer (can not be nil).

## Requirements
* iOS 7.0+

## Installation

TLCachedAutoHeightCell is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TLCachedAutoHeightCell"
```

## Author

ToccaLee, xiaoliu.li@ele.me

## License

TLCachedAutoHeightCell is available under the MIT license. See the LICENSE file for more info.
