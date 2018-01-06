//
//  InteractionViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/3.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "InteractionViewController.h"

@interface InteractionViewController()
//@property (weak, nonatomic) IBOutlet STTextView *textView;

@end

@implementation InteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _interactionView = [[InteractionView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    _interactionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_interactionView];
    
    [self setupSwitchUI:_interactionView];
    [self setupCheckBoxUI:_interactionView];
    [self setupTipView:_interactionView];
    [self setupContentTopView:_interactionView];
    [self setupContentTextView:_interactionView];
    [self setupSendBtnUI:_interactionView];
    
}
-(void)setupSwitchUI:(UIView *)superView
{
    _leftSwitchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    _leftSwitchView.image = [UIImage imageNamed:@"switch1"];
//    [_leftSwitchView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    _leftSwitchView.contentMode =  UIViewContentModeScaleAspectFill;
//    _leftSwitchView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _leftSwitchView.clipsToBounds  = YES;
    [superView addSubview:_leftSwitchView];
    
    _rightSwitchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    _rightSwitchView.image = [UIImage imageNamed:@"switch2"];
    [superView addSubview:_rightSwitchView];
    
    [_leftSwitchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superView.mas_top).offset(30);
        make.centerX.mas_equalTo(superView.mas_centerX).multipliedBy(0.6);
        make.width.equalTo(@120);
        make.height.equalTo(@120);
    }];
    
    [_rightSwitchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superView.mas_top).offset(30);
        make.centerX.mas_equalTo(superView.mas_centerX).multipliedBy(1.4);
        make.width.equalTo(@120);
        make.height.equalTo(@120);
    }];
}

-(void)setupCheckBoxUI:(UIView *)superView
{
    _leftCheckbox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_leftCheckbox setOn:YES animated:YES];
    _leftCheckbox.onTintColor = THEMECOLOR;
    _leftCheckbox.onCheckColor = THEMECOLOR;
    [superView addSubview:_leftCheckbox];
    
    _rightCheckbox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_rightCheckbox setOn:NO animated:YES];
    _rightCheckbox.onTintColor = THEMECOLOR;
    _rightCheckbox.onCheckColor = THEMECOLOR;
    [superView addSubview:_rightCheckbox];
    
    [_leftCheckbox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftSwitchView.mas_bottom).offset(25);
        make.centerX.mas_equalTo(_leftSwitchView.mas_centerX);
    }];
    
    [_rightCheckbox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rightSwitchView.mas_bottom).offset(25);
        make.centerX.mas_equalTo(_rightSwitchView.mas_centerX);
    }];
}

-(void)setupTipView:(UIView *)superView
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;//设置对齐方式
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                          NSParagraphStyleAttributeName : paragraph,
                          };
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"\n今天是您家人XXX的生日\n" attributes:ats];
    // 设置“XXX”为基础色
    [string addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK range:NSMakeRange(1, 6)];
    [string addAttribute:NSForegroundColorAttributeName value:THEMECOLOR range:NSMakeRange(7, 3)];
    [string addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK range:NSMakeRange(10, 3)];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"您可以把想说的话发送到家里的XX屏幕上！" attributes:ats];
    [string2 addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK range:NSMakeRange(0, 14)];
    [string2 addAttribute:NSForegroundColorAttributeName value:THEMECOLOR range:NSMakeRange(14, 2)];
    [string2 addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK range:NSMakeRange(16, 4)];
    
    [string appendAttributedString:string2];
    
    
    _tipTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 295, 90)];
    _tipTextView.editable = NO;
    _tipTextView.attributedText = string;
    _tipTextView.layer.borderWidth = 0.5f;
    _tipTextView.layer.borderColor = [COLOR_GRAY CGColor];
    [superView addSubview:_tipTextView];
    [_tipTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftCheckbox.mas_bottom).offset(50);
        make.centerX.mas_equalTo(superView.mas_centerX);
        make.left.mas_equalTo(superView.mas_left).offset(40);
        make.right.mas_equalTo(superView.mas_right).offset(-40);
        make.width.equalTo(@(superView.frame.size.width-80));
        make.height.equalTo(@90);
    }];
}

-(void)setupContentTopView:(UIView *)superView
{
    _topContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 295, 40)];
    [superView addSubview:_topContentView];
    [_topContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tipTextView.mas_bottom).offset(35);
        make.centerX.mas_equalTo(superView.mas_centerX);
        make.left.mas_equalTo(superView.mas_left).offset(40);
        make.right.mas_equalTo(superView.mas_right).offset(-40);
        make.width.equalTo(@(superView.frame.size.width-80));
        make.height.equalTo(@40);
    }];
    [self.view layoutIfNeeded];
    [self setBorderWithView:_topContentView top:YES left:YES bottom:NO right:YES borderColor:COLOR_GRAY borderWidth:0.5f];
    _photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_photoBtn setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    _emotionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_emotionBtn setBackgroundImage:[UIImage imageNamed:@"emotion"] forState:UIControlStateNormal];
    _leftAlignBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_leftAlignBtn setBackgroundImage:[UIImage imageNamed:@"左对齐"] forState:UIControlStateNormal];
    _centerAlignBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_centerAlignBtn setBackgroundImage:[UIImage imageNamed:@"居中对齐"] forState:UIControlStateNormal];
    _rightAlignBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_rightAlignBtn setBackgroundImage:[UIImage imageNamed:@"右对齐"] forState:UIControlStateNormal];
    [_topContentView addSubview:_photoBtn];
    [_topContentView addSubview:_emotionBtn];
    [_topContentView addSubview:_leftAlignBtn];
    [_topContentView addSubview:_centerAlignBtn];
    [_topContentView addSubview:_rightAlignBtn];
    [_photoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_topContentView.mas_centerY);
        make.left.mas_equalTo(_topContentView.mas_left).offset(5);
        make.width.equalTo(@30);
        make.height.equalTo(@26);
    }];
    [_emotionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_topContentView.mas_centerY);
        make.left.mas_equalTo(_photoBtn.mas_right).offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@26);
    }];
    [_leftAlignBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_topContentView.mas_centerY);
        make.left.mas_equalTo(_emotionBtn.mas_right).offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@26);
    }];
    [_centerAlignBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_topContentView.mas_centerY);
        make.left.mas_equalTo(_leftAlignBtn.mas_right).offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@26);
    }];
    [_rightAlignBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_topContentView.mas_centerY);
        make.left.mas_equalTo(_centerAlignBtn.mas_right).offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@26);
    }];
}

-(void)setupContentTextView:(UIView *)superView
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;//设置对齐方式
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                          NSParagraphStyleAttributeName : paragraph,
                          };
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"生日快乐！\nＯ(∩_∩)Ｏ" attributes:ats];
    //    STTextView * tv = [[STTextView alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 20)];
    //    tv.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    tv.layer.borderWidth = 1;
    //    [self.view addSubview:tv];
    //    tv.placeholder = @"我是占位符";
    //    tv.placeholderColor = [UIColor lightGrayColor];
    //    tv.verticalSpacing = 10;
    //    tv.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
    //    tv.textViewAutoHeight = ^(CGFloat height){
    //    };
    //    tv.maxHeight = 200;
    //    tv.minHeight = 35;
    //    tv.backgroundColor = [UIColor whiteColor];
    //    tv.text = @"";
    
    _contentTextView = [[STTextView alloc] initWithFrame:CGRectMake(0, 0, 295, 100)];
    _contentTextView.layer.borderWidth = 0.5f;
    _contentTextView.layer.borderColor = [COLOR_GRAY CGColor];
    _contentTextView.attributedText = string;
    _contentTextView.editable = YES;
    _contentTextView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    _contentTextView.editable = YES;        //是否允许编辑内容，默认为“YES”
//    _contentTextView.font=[UIFont fontWithName:@"Arial" size:18.0]; //设置字体名字和字体大小;
    _contentTextView.returnKeyType = UIReturnKeyDefault;//return键的类型
    _contentTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _contentTextView.textAlignment = NSTextAlignmentCenter; //文本显示的位置默认为居中
    _contentTextView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    _contentTextView.textColor = [UIColor blackColor];
//    _contentTextView.contentInset = UIEdgeInsetsMake(-11, -6, 0, 0);//添加滚动区域
    _contentTextView.delegate = self;    //设置代理方法的实现类
//    _interacionView.contentTextView.text = @"UITextView";//设置显示的文本内容
    _contentTextView.tag = 1001; //设置tag值
    
//    //获得焦点
//    [_interacionView.contentTextView becomeFirstResponder];
    [superView addSubview:_contentTextView];
    [_contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topContentView.mas_bottom);
        make.centerX.mas_equalTo(superView.mas_centerX);
        make.left.mas_equalTo(superView.mas_left).offset(40);
        make.right.mas_equalTo(superView.mas_right).offset(-40);
        make.width.equalTo(@(superView.frame.size.width-80));
        make.height.equalTo(@100);
    }];
    //添加键盘的监听事件
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)setupSendBtnUI:(UIView *)superView
{
    _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [superView addSubview:_sendBtn];
    [_sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(superView.mas_centerX);
        make.top.mas_equalTo(_contentTextView.mas_bottom).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@35);
    }];
}


#pragma mark 实现监听到键盘变化时的触发的方法

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
//    //获取键盘高度
//    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//
//    NSLog(@"%@",keyboardObject);
//
//    CGRect keyboardRect;
//
//    [keyboardObject getValue:&keyboardRect];
//
//    //得到键盘的高度
//    //CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
//
//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    NSLog(@"%f",duration);
//    //调整放置有textView的view的位置
//
//    //设置动画
//    [UIView beginAnimations:nil context:nil];
//
//    //定义动画时间
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationDelay:0];
//
//    //设置view的frame，往上平移
//    [(UIView *)[self.view viewWithTag:1001]setFrame:CGRectMake(0, [self.view viewWithTag:1001].frame.size.height-keyboardRect.size.height-100, 375, 100)];
//
//    //提交动画
//    [UIView commitAnimations];
    
//    [self.view bringSubviewToFront:self.interacionView.contentTextView];
    
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect =
    [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    NSLog(@"interacionView frame:%@",NSStringFromCGRect(self.view.frame));
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (keyboardHeight>0) {
        // 修改frame下边距距约束
        [_interactionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(-keyboardHeight);
            make.width.mas_equalTo(self.view.mas_width);
            make.height.mas_equalTo(self.view.mas_height);
        }];
//        NSLog(@"keyboardDidShow1 interactionView frame%@",_interactionView.frame);
        // 更新约束
        [UIView animateWithDuration:keyboardDuration animations:^{
            [self.view layoutIfNeeded];
        }];
//        NSLog(@"keyboardDidShow2 interactionView frame%@",_interactionView.frame);
    }
}

//键盘消失时
-(void)keyboardDidHidden:(NSNotification *)notification
{
//    //定义动画
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    
//    //设置view的frame，往下平移
//    [(UIView *) [self.view viewWithTag:1001] setFrame:CGRectMake(0, 567, 375, 100)];
//    [UIView commitAnimations];
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 修改为以前的约束（距下边距0）
    [_interactionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_height);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

//点击屏幕空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //回收键盘，两种方式
//    UITextView *textView = (UITextView*)[self.view viewWithTag:1001];
//    [textView resignFirstResponder];
//    [_interacionView.contentTextView becomeFirstResponder];
    [_contentTextView endEditing:YES];
//    NSLog(@"touch");
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
