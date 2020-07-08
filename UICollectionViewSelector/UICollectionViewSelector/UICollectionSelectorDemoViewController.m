//
//  ViewController.m
//  UICollectionViewSelector
//
//  Created by Han Mingjie on 2020/7/8.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "UICollectionSelectorDemoViewController.h"
#import "CollectionViewCell.h"

@interface UICollectionSelectorDemoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView *myCollectionView;
    NSMutableArray * colorArray;
    NSMutableArray <NSString *>* sources_array;
    BOOL selecting;
    
    NSMutableArray <NSIndexPath *> *selectedArray;
    UIToolbar *toolBar;
    UIBarButtonItem *remove_item;
    UIBarButtonItem *export_item;
}

@end

@implementation UICollectionSelectorDemoViewController
-(void)remove_action{
    NSString *message = [NSString stringWithFormat:@"Remove %lu item?",selectedArray.count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}


-(void)export_action{
    NSString *message = [NSString stringWithFormat:@"Export %lu item?",selectedArray.count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Export" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}


-(void)select_all_action{
    for (NSInteger i=0;i<colorArray.count;i++){
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        [selectedArray addObject:index];
    }
    [myCollectionView reloadData];
}


-(void)end_select{
    selecting = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(start_select)];
    self.navigationItem.leftBarButtonItem = nil;
    [myCollectionView setAllowsMultipleSelection:NO];
    [myCollectionView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view bringSubviewToFront:self->myCollectionView];
        [self->toolBar setFrame:CGRectMake(self->toolBar.frame.origin.x, self->toolBar.frame.origin.y+self->toolBar.frame.size.height, self->toolBar.frame.size.width, self->toolBar.frame.size.height)];
    }];
}

-(void)start_select{
    [selectedArray removeAllObjects];
    selecting = YES;
    [myCollectionView setAllowsMultipleSelection:YES];
    [myCollectionView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(end_select)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(select_all_action)];
    
    if (nil == toolBar){
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, self.view.frame.size.height, self.view.frame.size.width, 50.f)];
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        remove_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(remove_action)];
        export_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(export_action)];
        UIBarButtonItem *space_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolBar.items = @[space_item,remove_item,space_item,export_item,space_item];
        [self.view addSubview:toolBar];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view bringSubviewToFront:self->toolBar];
        [self->toolBar setFrame:CGRectMake(self->toolBar.frame.origin.x, self->toolBar.frame.origin.y-self->toolBar.frame.size.height, self->toolBar.frame.size.width, self->toolBar.frame.size.height)];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self end_select];
    selectedArray = [[NSMutableArray alloc] init];
    
    self.title = @"UICollectionView Selector Demo";
    colorArray = [[NSMutableArray alloc] init];
    sources_array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i ++) {
        int R = (arc4random() % 256);
        int G = (arc4random() % 256);
        int B = (arc4random() % 256) ;
        NSDictionary *dic = @{@"color":[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]};
        [colorArray addObject:dic];
        [sources_array addObject:[NSString stringWithFormat:@"Block %d\nRed:%d\nGreen:%d\nBlue:%d",i,R,G,B]];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (nil == myCollectionView){
        UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:collectionFlowLayout];
        myCollectionView.backgroundColor = [UIColor whiteColor];
        [myCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        myCollectionView.dataSource = self;
        myCollectionView.delegate = self;
        myCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:myCollectionView];
    }
}

-(void)refresh{
    if (selecting){
        if (selectedArray.count > 1){
            self.title = [NSString stringWithFormat:@"selected %lu items",selectedArray.count];
            remove_item.enabled = YES;
            export_item.enabled = YES;
        }else if (0 == selectedArray.count){
            self.title = @"Press for select item";
            remove_item.enabled = NO;
            export_item.enabled = NO;
        }else{
            self.title = [NSString stringWithFormat:@"selected 1 item"];
            remove_item.enabled = YES;
            export_item.enabled = YES;
        }
    }else{
        self.title = @"UICollectionView Selector Demo";
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id objc = [colorArray objectAtIndex:sourceIndexPath.item];
    [colorArray removeObject:objc];
    [colorArray insertObject:objc atIndex:destinationIndexPath.item];
    
    objc = [sources_array objectAtIndex:sourceIndexPath.item];
    [sources_array removeObject:objc];
    [sources_array insertObject:objc atIndex:destinationIndexPath.item];
}

//配置item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(167, 167);
}

//配置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

//配置每组上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 13, 15, 13);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//配置每个组里面有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return colorArray.count;
}

//配置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadWithModel:colorArray[indexPath.row]];
    cell.name = [sources_array objectAtIndex:indexPath.row];
    cell.selecting = selecting;
    if ([selectedArray containsObject:indexPath]){
        [cell setSelected:YES];
        [myCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }else{
        [cell setSelected:NO];
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedArray containsObject:indexPath]){
        [selectedArray removeObject:indexPath];
        
        //remove file from selected animals
        UICollectionViewCell *cell = [myCollectionView cellForItemAtIndexPath:indexPath];
        UIImageView *shadomView = [[UIImageView alloc] initWithFrame:cell.frame];
        [shadomView setCenter:collectionView.center];
        
        UIGraphicsBeginImageContext(shadomView.frame.size);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [shadomView setImage:image];
        [self.view addSubview:shadomView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [shadomView setCenter:CGPointMake(shadomView.center.x, shadomView.center.y - 100.f)];
        shadomView.alpha = 0.f;
        [UIView commitAnimations];
    }
    [self refresh];
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (selecting){
        //add this cell to selected array
        [selectedArray addObject:indexPath];
        
        //for add selected file animals
        UICollectionViewCell *cell = [myCollectionView cellForItemAtIndexPath:indexPath];
        UIImageView *shadomView = [[UIImageView alloc] initWithFrame:cell.frame];
        
        UIGraphicsBeginImageContext(shadomView.frame.size);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [shadomView setImage:image];
        
        [shadomView setFrame:[self.view convertRect:shadomView.frame fromView:myCollectionView]];
        [self.view addSubview:shadomView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:shadomView];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        [shadomView setCenter:collectionView.center];
        shadomView.alpha = 0.0f;
        [UIView commitAnimations];
    }else{
        //open item.
    }
    [self refresh];
    return YES;
}

@end
