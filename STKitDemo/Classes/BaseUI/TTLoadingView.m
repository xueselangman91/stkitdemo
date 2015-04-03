//
//  TTLoadingView.m
//  STKitDemo
//
//  Created by SunJiangting on 15-4-2.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "TTLoadingView.h"
#import <STKit/STKit.h>

@interface TTLoadingView ()

@property(nonatomic, strong) CAShapeLayer    *shapeLayer;
@property(nonatomic, strong) UIImageView     *imageView;

@end

@implementation TTLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInitialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _commonInitialize];
}

- (void)_commonInitialize {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor colorWithRGB:0xFF7300].CGColor;
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:8];
    for (NSInteger i = 1; i <= 8; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"%02ld", (long)i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [images addObject:image];
        }
    }
    self.imageView.image = [images firstObject];
    self.imageView.animationImages = images;
    self.imageView.animationDuration = 0.5;
    self.imageView.hidden = YES;
    [self addSubview:self.imageView];
    
    self.completion = 0;
}

- (void)setCompletion:(CGFloat)completion {
    _completion = completion;
    if (completion < 1 && !self.imageView.isAnimating) {
        [self _drawBerizerPathWithCompletion:completion];
        self.imageView.hidden = YES;
    } else {
        [self _drawBerizerPathWithCompletion:1];
        self.imageView.frame = CGRectMake(self.inCenterX - 30, self.height - 60, 60, 60);
        self.imageView.hidden = NO;
    }
}

- (void)stopAnimating {
    self.imageView.hidden = YES;
    [self.imageView stopAnimating];
}

- (void)startAnimating {
    if (!self.imageView.isAnimating) {
        [self.imageView startAnimating];
    }
}

- (BOOL)isAnimating {
    return self.imageView.isAnimating;
}

- (void)_drawBerizerPathWithCompletion:(CGFloat)completion {
    UIBezierPath *berizierPath = [self _bezierPathWithCompletion:completion];
    self.shapeLayer.path = berizierPath.CGPath;
}

- (UIBezierPath *)_bezierPathWithCompletion:(CGFloat)completion {
    CGFloat width = 0, height = 0;
    // 先从5到20----然后从20----40------>40
    if (completion < 0.3) {
        CGFloat phaseCompletion = completion / 0.3;
        width = 3 + phaseCompletion * 12;
        height = width;
    } else if (completion < 0.7) {
        CGFloat phaseCompletion = (completion - 0.3) / 0.4;
        width = 15 + phaseCompletion * 5;
        height = 15 + phaseCompletion * 30;
    } else if (completion < 0.8) {
        CGFloat phaseCompletion = (completion - 0.7) / 0.1;
        width = 20 + phaseCompletion * 10;
        height = 45 - phaseCompletion * 20;
    } else {
        CGFloat phaseCompletion = (completion - 0.8) / 0.2;
        width = 30 + phaseCompletion * 40;
        height = 25 + phaseCompletion * 40;
    }
    
    CGFloat x = (CGRectGetWidth(self.bounds) - width ) / 2;
    CGFloat y = CGRectGetHeight(self.bounds) - height;
    CGRect rect = CGRectMake(x, y, width, height);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    return bezierPath;
}
@end