//
//  CollectionViewCell.m
//  UICollectionViewSelector
//
//  Created by Han Mingjie on 2020/7/8.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell(){
    UIImageView *img;
    UILabel *label;
    
    UIImageView * selectingImageView;
}

@end

@implementation CollectionViewCell
@synthesize name;
@synthesize selecting;


-(void)refreshView{
    [selectingImageView setCenter:CGPointMake(self.frame.size.width/2.f,self.frame.size.height/2.f)];
    if (selecting){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        selectingImageView.alpha = 1.0;
        if (self.selected){
            selectingImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"selected" ofType:@"png"]];
            [self bringSubviewToFront:selectingImageView];
        }else{
            selectingImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"unselected" ofType:@"png"]];
        }
        [UIView commitAnimations];
    }else{
        selectingImageView.alpha = 0.f;
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self refreshView];
}

-(void)setSelecting:(BOOL)_selecting{
    if (selecting == _selecting){
        return;
    }
    selecting = _selecting;
    [self refreshView];
}

-(void)setName:(NSString *)_name{
    name = _name;
    label.text = name;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 167, 167)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.masksToBounds = YES;
        [img.layer setCornerRadius:5];
        [self.contentView addSubview:img];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 5.f, 160.f, 100.f)];
        label.numberOfLines = 4;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:label];
        
        selectingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6.f, 8.5, 40.f, 40.f)];
        [self addSubview:selectingImageView];

    }
    return self;
}

- (void)loadWithModel:(NSDictionary *)model{
    img.backgroundColor = model[@"color"];
}
@end
