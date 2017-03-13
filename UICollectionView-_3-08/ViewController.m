//
//  ViewController.m
//  UICollectionView-_3-08
//
//  Created by 鑫方迅 on 2017/3/8.
//  Copyright © 2017年 xfunsun. All rights reserved.
//

#import "ViewController.h"
#import "SCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    BOOL _editState;
    UIBarButtonItem *rightBtn;
}
@property(strong,nonatomic)UICollectionView *collectionView,*dCollectionView;
@property(copy,nonatomic)NSMutableArray *selectDataArray,*unselectDataArray;
@property(strong,nonatomic)UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"编辑"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(editView)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
 
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _scrollView.backgroundColor = [UIColor blueColor];
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height*0.4) collectionViewLayout:flowLayout];
    _collectionView.tag = 999;
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.clipsToBounds = NO;
    _collectionView.scrollEnabled = NO;
    [_scrollView addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"SCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELLID"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collectionView addGestureRecognizer:longGesture];
    
    UICollectionViewFlowLayout *flowLayoutd = [[UICollectionViewFlowLayout alloc]init];
    _dCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height*0.5, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height*0.6) collectionViewLayout:flowLayoutd];
    _dCollectionView.tag = 100;
    _dCollectionView.delegate   = self;
    _dCollectionView.dataSource = self;
    _dCollectionView.scrollEnabled = NO;
    _dCollectionView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_dCollectionView];
    [_dCollectionView registerNib:[UINib nibWithNibName:@"SCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DCELLID"];
    [_dCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"dheadView"];
    [_dCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"dfootView"];
    
   
}
-(void)editView
{
    _editState = !_editState;
    if (_editState) {
        [rightBtn setTitle:@"完成"];
    }else{
        [rightBtn setTitle:@"编辑"];

    }
    [_collectionView reloadData];
    [_dCollectionView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewDidLayoutSubviews
{
    
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
             [_scrollView insertSubview:_collectionView aboveSubview:_dCollectionView];
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            [_scrollView insertSubview:_collectionView atIndex:0];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 999) {
        NSLog(@"==== %@",_selectDataArray);
        //demo
        return self.selectDataArray.count;
    }
    else
    {
        return self.unselectDataArray.count;
    }
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    
    if (collectionView.tag == 999) {
        SCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
        
            cell.celltitle.text = _selectDataArray[indexPath.row];
               cell.cellimage.image = [UIImage imageNamed:@"1"];
        
        cell.backgroundColor = [UIColor grayColor];
        if (!_editState) {
            cell.cellFlageImageView.hidden = YES;
        }else{
            cell.cellFlageImageView.hidden = NO;

            cell.cellFlageImageView.backgroundColor = [UIColor redColor];
        }
        return cell;

    }else
    {
        SCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DCELLID" forIndexPath:indexPath];
        
        cell.celltitle.text = _unselectDataArray[indexPath.row];
        cell.cellimage.image = [UIImage imageNamed:@"1"];
        
        cell.backgroundColor = [UIColor greenColor];
        
        if (!_editState) {
            cell.cellFlageImageView.hidden = YES;
        }else{
            cell.cellFlageImageView.hidden = NO;
            
            cell.cellFlageImageView.backgroundColor = [UIColor yellowColor];
        }

        return cell;

    }
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 20, 10, 20);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width*0.25, [[UIScreen mainScreen] bounds].size.width*0.25);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(365, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(365, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if (collectionView.tag == 999) {
        if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
            reuseIdentifier = @"footView";
        }else{
            
            reuseIdentifier = @"headView";
        }

    }else{
        if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
            reuseIdentifier = @"dfootView";
        }else{
            
            reuseIdentifier = @"dheadView";
        }

    }
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
   
    view.backgroundColor = [UIColor greenColor];
       label.textAlignment = 0;
    [view addSubview:label];
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editState) {
        if (collectionView.tag == 999) {
            id objc = [_selectDataArray objectAtIndex:indexPath.item];
            [_selectDataArray removeObject:objc];
            [_unselectDataArray addObject:objc];
            [_collectionView reloadData];
            [_dCollectionView reloadData];
            
        }
        else
        {
            id objc = [_unselectDataArray objectAtIndex:indexPath.item];
            [_unselectDataArray removeObject:objc];
            [_selectDataArray addObject:objc];
            
            [_collectionView reloadData];
            [_dCollectionView reloadData];
        }
        CGRect upRect = _collectionView.frame;
        NSInteger upCount;
        NSInteger downCount;
        if (_selectDataArray.count %3 == 0) {
            upCount = _selectDataArray.count/3+1;
        }else{
            upCount = _selectDataArray.count/3 +2;
        }
        if (_unselectDataArray.count %3 == 0) {
            downCount = _unselectDataArray.count/3+1;
        }else{
            downCount = _unselectDataArray.count/3 +2;
        }
        
        upRect.size.height = [[UIScreen mainScreen] bounds].size.width*0.25*upCount;
        _collectionView.frame = upRect;
        
        CGRect downRect = _dCollectionView.frame;
        downRect.size.height = [[UIScreen mainScreen] bounds].size.width*0.25*downCount;
        downRect.origin.y = upRect.origin.y+upRect.size.height;
        _dCollectionView.frame = downRect;
        
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, downRect.size.height + downRect.origin.y);

    }

}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 999) {
        return YES;

    }else{
        return NO;

    }
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    if (collectionView.tag == 999) {
        //取出源item数据
        id objc = [_selectDataArray objectAtIndex:sourceIndexPath.item];
        //从资源数组中移除该数据
        [_selectDataArray removeObject:objc];
        //将数据插入到资源数组中的目标位置上
        [_selectDataArray insertObject:objc atIndex:destinationIndexPath.item];

    }
   }
-(NSMutableArray *)selectDataArray
{
    if (!_selectDataArray) {
        _selectDataArray = [[NSMutableArray alloc]initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25", nil];
    }
    return _selectDataArray;
}
-(NSMutableArray *)unselectDataArray
{
    if (!_unselectDataArray) {
        _unselectDataArray = [[NSMutableArray alloc]initWithObjects:@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75", nil];
    }
    return _unselectDataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
