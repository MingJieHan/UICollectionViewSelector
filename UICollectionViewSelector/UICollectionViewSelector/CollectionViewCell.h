//
//  CollectionViewCell.h
//  UICollectionViewSelector
//
//  Created by Han Mingjie on 2020/7/8.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell{
    NSString *name;
    BOOL selecting;
}
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL selecting;
- (void)loadWithModel:(NSDictionary *)model;
@end

NS_ASSUME_NONNULL_END
