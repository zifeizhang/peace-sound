//
//  SoundViewController.m
//  peacesound
//
//  Created by zhangzifei on 15/12/25.
//  Copyright © 2015年 com.gohoc. All rights reserved.
//

#import "SoundViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SoundFooterView.h"
#import "TimeViewController.h"
#import "GDTMobBannerView.h"
#import "SVProgressHUD.h"
#define kMainWidth  ([UIScreen mainScreen].bounds.size.width - 2)/2
#define kMainHeight  [UIScreen mainScreen].bounds.size.height
#define bannerW  [UIScreen mainScreen].bounds.size.width
#define bannerH  [UIScreen mainScreen].bounds.size.height
@interface SoundViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    NSArray *imageArr;
    UILabel *timeLabel;
    NSTimer *stopTime;
    int seconds;
    int miao;
    
    UIView *backView;
    
    GDTMobBannerView *_bannerView;
    
}
@property(nonatomic,strong)UICollectionView *userCollectionView;
@property(nonatomic,strong) UISlider *mySlider;
@end

@implementation SoundViewController

-(instancetype)init{
    
    if (self = [super init]) {
        
        imageArr = [NSArray array];
        timeLabel = [[UILabel alloc]init];
        /*
         * 创建Banner广告View
         * "appkey" 指在 http://e.qq.com/dev/ 能看到的app唯一字符串
         * "placementId" 指在 http://e.qq.com/dev/ 生成的数字串，广告位id
         *
         * banner条的宽度开发者可以进行手动设置，用以满足开发场景需求或是适配最新版本的iphone，最佳显示效果为320
         * banner条的高度广点通侧强烈建议开发者采用推荐的高度50，否则显示效果会有影响
         */
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, kMainHeight-114,
                                                                         bannerW,
                                                                         bannerH)
                                                       appkey:@"1104962231"
                                                  placementId:@"1000404727559159"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:146/255.0 green:222/255.0 blue:50/255.0 alpha:1];
    self.title = @"Sound";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //_bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = NO; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载广告并展示
    
    
    imageArr = [NSArray arrayWithObjects:@"wave.png",@"wind.png",@"rain.png",@"thunder.png",@"clock.png",@"bird.png", nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    float height = self.view.frame.size.height;
    if(height < 568){
        
        layout.itemSize = CGSizeMake(kMainWidth, 75);
    }
    else{
        layout.itemSize = CGSizeMake(kMainWidth, 100);
        
    }
    
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    self.userCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:layout];
    self.userCollectionView.dataSource = self;
    self.userCollectionView.delegate = self;
    self.userCollectionView.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    [self.userCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"SoundFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SoundFooterView"];
    [self.view addSubview:self.userCollectionView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setStopTime:) name:@"NSNotificationSetStopTime" object:nil];
    
    [self volumeView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapView{

    backView.hidden = YES;
    //_mySlider.value = 0.5;
}
#pragma mark - userCollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return imageArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    float height = self.view.frame.size.height;
    if(height < 568){
        
        soundBtn.frame = CGRectMake((cell.frame.size.width-75)/2, 0, 75, 75);
    }
    else{
        
        soundBtn.frame = CGRectMake((cell.frame.size.width-75)/2, 12, 75, 75);
    }
    
    
    [soundBtn setImage:[UIImage imageNamed:imageArr[indexPath.item]] forState:UIControlStateNormal];
    [cell addSubview:soundBtn];
    soundBtn.tag = indexPath.item;
    [soundBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [soundBtn addTarget:self action:@selector(btnRepeatClick:) forControlEvents:UIControlEventTouchDownRepeat];
    
    
    return cell;
}
-(void)btnClick:(UIButton*)btn{
    [self performSelector:@selector(tabButtonTap:) withObject:btn afterDelay:0.2];
}
//单击
-(void)tabButtonTap:(UIButton*)btn{
    UICollectionViewCell *cell = [self.userCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:0]];
    UIButton *Btn = (UIButton*)[self.view viewWithTag:10];
    switch (btn.tag) {
        case 0:
        {
            if (Btn.selected == YES) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"当前处于静音模式，不能播放"];
                return;
            }
            cell.backgroundColor = [UIColor colorWithRed:44/255.0 green:167/255.0 blue:254/255.0 alpha:1];
            if (!_wavePlayer) {
                _wavePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"waves" ofType:@"mp3"]] error:nil];
                _wavePlayer.volume = 0.5;
                _wavePlayer.numberOfLoops = -1;
                [_wavePlayer prepareToPlay];
                [_wavePlayer play];
            }
            _mySlider.value = _wavePlayer.volume;
            backView.hidden = NO;
            _mySlider.tag = btn.tag;
            
        }
            break;
        case 1:
        {
            if (Btn.selected == YES) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"当前处于静音模式，不能播放"];
                return;
            }
            cell.backgroundColor = [UIColor colorWithRed:254/255.0 green:201/255.0 blue:86/255.0 alpha:1];
            if (!_windPlayer) {
                _windPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"wind" ofType:@"mp3"]] error:nil];
                _windPlayer.volume = 0.5;
                _windPlayer.numberOfLoops = -1;
                [_windPlayer prepareToPlay];
                [_windPlayer play];
            }
            _mySlider.value = _windPlayer.volume;
            backView.hidden = NO;
            _mySlider.tag = btn.tag;
            
        }
            break;
        case 2:
        {
            if (Btn.selected == YES) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"当前处于静音模式，不能播放"];
                return;
            }
            cell.backgroundColor = [UIColor colorWithRed:115/255.0 green:255/255.0 blue:8/255.0 alpha:1];
            if (!_rainPlayer) {
                _rainPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"rain" ofType:@"mp3"]] error:nil];
                _rainPlayer.volume = 0.5;
                _rainPlayer.numberOfLoops = -1;
                [_rainPlayer prepareToPlay];
                [_rainPlayer play];
            }
            _mySlider.value = _rainPlayer.volume;
            backView.hidden = NO;
            _mySlider.tag = btn.tag;
            
        }
            break;
        case 3:
        {
            if (Btn.selected == YES) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"当前处于静音模式，不能播放"];
                return;
            }
            cell.backgroundColor = [UIColor colorWithRed:224/255.0 green:74/255.0 blue:14/255.0 alpha:1];
            if (!_thunderPlayer) {
                _thunderPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"thunder" ofType:@"mp3"]] error:nil];
                _thunderPlayer.volume = 0.5;
                _thunderPlayer.numberOfLoops = -1;
                [_thunderPlayer prepareToPlay];
                [_thunderPlayer play];
            }
            _mySlider.value = _thunderPlayer.volume;
            backView.hidden = NO;
            _mySlider.tag = btn.tag;
            
        }
            break;
        case 4:
        {
            if (Btn.selected == YES) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"当前处于静音模式，不能播放"];
                return;
            }
            cell.backgroundColor = [UIColor colorWithRed:251/255.0 green:200/255.0 blue:104/255.0 alpha:1];
            if (!_clockPlayer) {
                _clockPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"quick_clock" ofType:@"mp3"]] error:nil];
                _clockPlayer.volume = 0.5;
                _clockPlayer.numberOfLoops = -1;
                [_clockPlayer prepareToPlay];
                [_clockPlayer play];
            }
            _mySlider.value = _clockPlayer.volume;
            backView.hidden = NO;
            _mySlider.tag = btn.tag;
        }
            break;
        case 5:
        {
            if (Btn.selected == YES) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"当前处于静音模式，不能播放"];
                return;
            }
            cell.backgroundColor = [UIColor colorWithRed:90/255.0 green:255/255.0 blue:193/255.0 alpha:1];
            if (!_birdsPlayer) {
                _birdsPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"birds" ofType:@"mp3"]] error:nil];
                _birdsPlayer.volume = 0.5;
                _birdsPlayer.numberOfLoops = -1;
                [_birdsPlayer prepareToPlay];
                [_birdsPlayer play];
            }
            _mySlider.value = _birdsPlayer.volume;
            backView.hidden = NO;
            _mySlider.tag = btn.tag;
            
        }
            break;
        default:
            break;
    }
}
-(void)volumeView{

    backView = [[UIView alloc]initWithFrame:CGRectMake(15, (self.view.frame.size.height-60)/2, self.view.frame.size.width-30, 60)];
    backView.backgroundColor = [UIColor grayColor];
    backView.hidden = YES;
    backView.layer.cornerRadius = 5;
    [self.view addSubview:backView];
    [self.view bringSubviewToFront:backView];
    
    _mySlider = [[UISlider alloc] initWithFrame:CGRectMake((backView.frame.size.width-260)/2+60, (backView.frame.size.height-23)/2, 200.0f, 23.0f)];
    _mySlider.minimumValue = 0.0f;//滑动条的最小值
    _mySlider.maximumValue = 1.0f;//滑动条的最大值
    _mySlider.value = _mySlider.maximumValue/2;//滑动条的当前值
    [_mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];//添加滑动事件
    _mySlider.continuous = NO;//设置只有在离开滑动条的最后时刻才触发滑动事件
    [backView addSubview:_mySlider];//添加视图

    UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake((backView.frame.size.width-260)/2, (backView.frame.size.height-30)/2, 30, 30)];
    imag.image = [UIImage imageNamed:@"Banner_Icon@3x"];
    [backView addSubview:imag];
}
//添加滑动事件
-(void)sliderValueChanged:(UISlider *)paramSender{
    
    switch (paramSender.tag) {
        case 0:
        {
            _wavePlayer.volume = paramSender.value;
            
        }
            break;
        case 1:
        {
            _windPlayer.volume = paramSender.value;
            
        }
            break;
        case 2:
        {
            _rainPlayer.volume = paramSender.value;;
            
        }
            break;
        case 3:
        {
            _thunderPlayer.volume = paramSender.value;
            
        }
            break;
        case 4:
        {
            _clockPlayer.volume = paramSender.value;
            
        }
            break;
        case 5:
        {
            _birdsPlayer.volume = paramSender.value;
            
        }
            break;
        default:
            break;
    }
    
}
//双击
-(void)btnRepeatClick:(UIButton*)btn{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tabButtonTap:) object:btn];
    UICollectionViewCell *cell = [self.userCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:0]];
    UIButton *Btn = (UIButton*)[self.view viewWithTag:10];
    switch (btn.tag) {
        case 0:
        {
            backView.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            if (Btn.selected == YES) {
                return;
            }
            [_wavePlayer stop];
            _wavePlayer = nil;
        }
            break;
        case 1:
        {
            backView.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            if (Btn.selected == YES) {
                return;
            }
            [_windPlayer stop];
            _windPlayer = nil;
        }
            break;
        case 2:
        {
            backView.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            if (Btn.selected == YES) {
                return;
            }
            [_rainPlayer stop];
            _rainPlayer = nil;
        }
            break;
        case 3:
        {
            backView.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            if (Btn.selected == YES) {
                return;
            }
            [_thunderPlayer stop];
            _thunderPlayer = nil;
        }
            break;
        case 4:
        {
            backView.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            if (Btn.selected == YES) {
                return;
            }
            [_clockPlayer stop];
            _clockPlayer = nil;
        }
            break;
        case 5:
        {
            backView.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            if (Btn.selected == YES) {
                return;
            }
            [_birdsPlayer stop];
            _birdsPlayer = nil;
        }
            break;
        default:
            break;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

//    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];sysVer < 9
    float height = self.view.frame.size.height;
    if(height < 568){
        
        CGSize size = {self.view.frame.size.width,self.view.frame.size.height-227-64};
        return size;
    }
    else{
        
        CGSize size = {self.view.frame.size.width,self.view.frame.size.height-302-64};
        return size;
    }
    
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    SoundFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SoundFooterView" forIndexPath:indexPath];
    footer.backgroundColor = [UIColor whiteColor];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    [footer addSubview:line];
    
    UIButton *calmBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-110)/4, 45, 55, 55)];
    calmBtn.tag = 10;
    [calmBtn setImage:[UIImage imageNamed:@"btn_sound_disable"] forState:UIControlStateNormal];
    [calmBtn addTarget:self action:@selector(calmClick:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:calmBtn];
    UIButton *setTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-110)/4*3+55, 45, 55, 55)];
    [setTimeBtn setImage:[UIImage imageNamed:@"btn_time_disable"] forState:UIControlStateNormal];
    [setTimeBtn setImage:[UIImage imageNamed:@"btn_time"] forState:UIControlStateHighlighted];
    [setTimeBtn addTarget:self action:@selector(setTimeClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:setTimeBtn];
    
    timeLabel.frame = CGRectMake((self.view.frame.size.width-60)/2, 45, 60, 30);
    timeLabel.textColor = [UIColor redColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:timeLabel];
    
    return footer;
}
-(void)setStopTime:(NSNotification*)notification{

    NSString *time = [notification.userInfo objectForKey:@"time"];
    seconds = [time intValue] * 60;
    miao = 59;
    if ([time isEqualToString:@"0"]) {
        timeLabel.text = @"";
    }else{
    
        if ([time isEqualToString:@"5"]) {
            timeLabel.text = [NSString stringWithFormat:@"0%@:%@",time,@"00"];
        }else{
        
            timeLabel.text = [NSString stringWithFormat:@"%@:%@",time,@"00"];
        }
        stopTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOver) userInfo:nil repeats:YES];
        
    }
    
    
}
-(void)timeOver{
    
    seconds--;
    
    if (seconds < 0) {
        [stopTime invalidate];
        stopTime = nil;
        if ([_wavePlayer isPlaying] && _wavePlayer != nil) {
            [_wavePlayer stop];
        }
        if ([_windPlayer isPlaying] && _windPlayer != nil) {
            [_windPlayer stop];
        }
        if ([_rainPlayer isPlaying] && _rainPlayer != nil) {
            [_rainPlayer stop];
        }
        if ([_thunderPlayer isPlaying] && _thunderPlayer != nil) {
            [_thunderPlayer stop];
        }
        if ([_clockPlayer isPlaying] && _clockPlayer != nil) {
            [_clockPlayer stop];
        }
        if ([_birdsPlayer isPlaying] && _birdsPlayer != nil) {
            [_birdsPlayer stop];
        }
        timeLabel.text = @"";
        return;
    }
    
    NSString *minutes = [NSString stringWithFormat:@"%d",seconds/60];
    
    if (minutes.length == 1) {
        if (seconds%60 != 0) {
            
            if (miao < 10) {
                timeLabel.text = [NSString stringWithFormat:@"0%@:0%d",minutes,miao];
            }else{
            
                timeLabel.text = [NSString stringWithFormat:@"0%@:%d",minutes,miao];
            }
            
            miao--;
            if (miao == 0) {
                miao = 59;
            }
        }else{
        
            timeLabel.text = [NSString stringWithFormat:@"0%@:%@",minutes,@"00"];
        }
        
    }else{
    
        if (seconds%60 != 0) {
            if (miao < 10) {
                timeLabel.text = [NSString stringWithFormat:@"%@:0%d",minutes,miao];
            }else{
            
                timeLabel.text = [NSString stringWithFormat:@"%@:%d",minutes,miao];
            }
            
            miao--;
            if (miao == 0) {
                miao = 59;
            }
        }else{
            
            timeLabel.text = [NSString stringWithFormat:@"%@:%@",minutes,@"00"];
        }

    }
    
    
}
-(void)calmClick:(UIButton*)btn{
    
    if (btn.selected == YES) {
        [btn setImage:[UIImage imageNamed:@"btn_sound_disable"] forState:UIControlStateNormal];
        
        if (![_wavePlayer isPlaying] && _wavePlayer != nil) {
            [_wavePlayer play];
        }
        if (![_windPlayer isPlaying] && _windPlayer != nil) {
            [_windPlayer play];
        }
        if (![_rainPlayer isPlaying] && _rainPlayer != nil) {
            [_rainPlayer play];
        }
        if (![_thunderPlayer isPlaying] && _thunderPlayer != nil) {
            [_thunderPlayer play];
        }
        if (![_clockPlayer isPlaying] && _clockPlayer != nil) {
            [_clockPlayer play];
        }
        if (![_birdsPlayer isPlaying] && _birdsPlayer != nil) {
            [_birdsPlayer play];
        }
    }else{
    
        [btn setImage:[UIImage imageNamed:@"btn_sound"] forState:UIControlStateSelected];
        if ([_wavePlayer isPlaying] && _wavePlayer != nil) {
            [_wavePlayer stop];
        }
        if ([_windPlayer isPlaying] && _windPlayer != nil) {
            [_windPlayer stop];
        }
        if ([_rainPlayer isPlaying] && _rainPlayer != nil) {
            [_rainPlayer stop];
        }
        if ([_thunderPlayer isPlaying] && _thunderPlayer != nil) {
            [_thunderPlayer stop];
        }
        if ([_clockPlayer isPlaying] && _clockPlayer != nil) {
            [_clockPlayer stop];
        }
        if ([_birdsPlayer isPlaying] && _birdsPlayer != nil) {
            [_birdsPlayer stop];
        }
        
    }
    btn.selected = !btn.selected;
}

-(void)setTimeClick{
    
    [stopTime invalidate];
    stopTime = nil;
    TimeViewController *timeVC = [[TimeViewController alloc]init];
    [self.navigationController pushViewController:timeVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    backView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
