//
//  ViewController.m
//  CABasicAnimationTest
//
//  Created by change009 on 16/4/21.
//  Copyright © 2016年 change009. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self animationOfUIKit];
    
    
}

/**
 *  CABasicAnimation
 */
- (void)addCABasicAnimation{
    
    CALayer *myLayer = [CALayer layer];
    myLayer.backgroundColor = [UIColor purpleColor].CGColor;
    myLayer.frame = CGRectMake(50, 100, 120, 120);
    myLayer.cornerRadius = 10;
    [self.view.layer addSublayer:myLayer];
    
    //移动
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:myLayer.position];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(myLayer.position.x+100, 100)];
    
    //以X轴旋转
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:6.0*M_PI];
    
    //放大缩小
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2];
    
    //组合动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = YES;       //完成动画后同样反向也执行动画
    group.duration = 2.0;           //动画时间
    group.animations = [NSArray arrayWithObjects:animation,rotationAnimation,scaleAnimation, nil];
    group.repeatCount = 3;
    
    /**
     *  PS:动画结束以后，他会返回到自己原来的frame，如果想保持动画结束时的状态
     *  添加下面属性，并且此时要保证autoreverses属性为NO,另外组合动画的属性设
     *  置同样也适用于单个动画的设置
     *  group.removedOnCompletion = NO;
     *  group.fillMode = kCAFillModeForwards;
     */
    
    //添加动画
    [myLayer addAnimation:group forKey:@"MyLayerAnimation"];
    
}


//values方式
-(void)animationValues
{
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(120, 350, 50, 50)];
    myView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:myView];
    
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"position";
    
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(100, 200)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    
    
    keyAnimation.values = @[value1,value2,value3,value4,value5];
    keyAnimation.repeatCount = MAXFLOAT;      //循环次数
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.duration = 4.0;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    keyAnimation.delegate = self;
    [myView.layer addAnimation:keyAnimation forKey:nil];

}

//path方式
-(void)animationPath
{
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(120, 350, 50, 50)];
    myView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:myView];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(50, 100, 220, 180));
    
    animation.path=path;
    CGPathRelease(path);
    animation.repeatCount=MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 4.0f;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate=self;
    [myView.layer addAnimation:animation forKey:nil];
}

/**
 *  动画组
 */
-(void)animationGroup
{
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(120, 350, 50, 50)];
    myView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:myView];
    
    //贝塞尔曲线路径
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:CGPointMake(50.0, 50.0)];
    [movePath addQuadCurveToPoint:CGPointMake(130, 350) controlPoint:CGPointMake(300, 100)];
    
    //关键帧动画（位置）
    CAKeyframeAnimation * posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnim.path = movePath.CGPath;
    posAnim.removedOnCompletion = YES;
    
    //缩放动画
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.removedOnCompletion = YES;
    
    //透明动画
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnim.removedOnCompletion = YES;
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:posAnim, scaleAnim, opacityAnim, nil];
    animGroup.duration = 5;
    animGroup.autoreverses = NO;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeRemoved;
    
    [myView.layer addAnimation:animGroup forKey:nil];
}

/**
 *  转场动画
 */

//从下往上运动
-(void)animationTransition
{
    //y点就是当要运动后到的Y值
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250)];
    myView.backgroundColor = [UIColor redColor];
    [self.view addSubview:myView];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    //添加动画
    [myView.layer addAnimation:animation forKey:nil];
}

//从上往下运动
-(void)animationPushTransition
{
    //y点就是当要运动后到的Y值
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250)];
    myView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:myView];
    
    
    CATransition *animation = [CATransition animation];
    animation.duration = 4.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    
    //添加动画
    [myView.layer addAnimation:animation forKey:nil];
    
}

/**
 *  UIKit动画
 */
-(void)animationOfUIKit
{
    UIView *redView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    redView.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:redView];
    //开始动画
    [UIView beginAnimations:@"test" context:nil];
    //动画时长
    [UIView setAnimationDuration:1];
    
    
    /*
     *要进行动画设置的地方
     */
    redView.backgroundColor=[UIColor blueColor];
    redView.frame=CGRectMake(50, 50, 200, 200);
    redView.alpha=0.5;
    
    //动画结束
    [UIView commitAnimations];
}






-(void)animationOfBlock
{
    //初始化一个View，用来显示动画
    UIView *redView=[[UIView alloc]initWithFrame:CGRectMake(10, 80, 100, 100)];
    redView.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:redView];
    
    [UIView animateWithDuration:2.0 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionFlipFromLeft//动画效果
                     animations:^{
                         //动画设置区域
                         redView.backgroundColor=[UIColor blueColor];
                         redView.frame=CGRectMake(50, 100, 200, 200);
                         redView.alpha=0.5;
                         
                     } completion:^(BOOL finish){
                         //动画结束时调用
                         NSLog(@"结束动画");
                     }];
}

@end
