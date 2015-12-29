//
//  TimeViewController.m
//  peacesound
//
//  Created by zhangzifei on 15/12/26.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "TimeViewController.h"
#import "SoundFooterView.h"
#import "GDTMobBannerView.h"
#define kMainWidth  ([UIScreen mainScreen].bounds.size.width - 2)/2
#define kMainHeight  [UIScreen mainScreen].bounds.size.height
#define bannerW  [UIScreen mainScreen].bounds.size.width
#define bannerH  [UIScreen mainScreen].bounds.size.height
@interface TimeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *timeArr;
    NSDictionary *userInfo;
    GDTMobBannerView *_bannerView;
}
@property(nonatomic,strong)UICollectionView *userCollectionView;
@end

@implementation TimeViewController
-(instancetype)init{

    if (self = [super init]) {
        timeArr = [NSArray array];
        /*
         * 创建Banner广告View
         * "appkey" 指在 http://e.qq.com/dev/ 能看到的app唯一字符串
         * "placementId" 指在 http://e.qq.com/dev/ 生成的数字串，广告位id
         *
         * banner条的宽度开发者可以进行手动设置，用以满足开发场景需求或是适配最新版本的iphone，最佳显示效果为320
         * banner条的高度广点通侧强烈建议开发者采用推荐的高度50，否则显示效果会有影响
         */
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, kMainHeight-50,
                                                                         bannerW,
                                                                         bannerH)
                                                       appkey:@"1104962231"
                                                  placementId:@"1000404727559159"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Sound off after";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    timeArr = [NSArray arrayWithObjects:@"5",@"10", @"15",@"20",@"25",@"30",@"60",@"Cancel",nil];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kMainWidth, 60);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    self.userCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:layout];
    self.userCollectionView.dataSource = self;
    self.userCollectionView.delegate = self;
    self.userCollectionView.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    [self.userCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"SoundFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SoundFooterView"];
    [self.view addSubview:self.userCollectionView];
    
    [self initWithBackButton];
    
    //_bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = NO; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载广告并展示
}
-(void)initWithBackButton{
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    [btn setImage:[UIImage imageNamed:@"ico_back"]];
    [btn setTitle:@""];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btn;
}
-(void)backClick{
    return;
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - userCollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return timeArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kMainWidth-120)/2, 10, 120, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:20];
    if (indexPath.item == 7) {
        label.text = [NSString stringWithFormat:@"%@",timeArr[indexPath.item]];
        label.textColor = [UIColor redColor];
    }else{
    
        label.text = [NSString stringWithFormat:@"%@ minutes",timeArr[indexPath.item]];
    }
    
    [cell addSubview:label];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.item != 7) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:timeArr[indexPath.item],@"time", nil];
    }else{
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"time", nil];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationSetStopTime" object:nil userInfo:userInfo];
    [self.navigationController popViewControllerAnimated:YES];
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGSize size = {self.view.frame.size.width,self.view.frame.size.height-243-64};
    return size;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SoundFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SoundFooterView" forIndexPath:indexPath];
    footer.backgroundColor = [UIColor whiteColor];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    [footer addSubview:line];
    for (UIView*subView in footer.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    UIImageView *clockImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-56)/2, 25, 56, 56)];
    clockImage.image = [UIImage imageNamed:@"icon_alarm_clock@2x"];
    [footer addSubview:clockImage];
    
    return footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
