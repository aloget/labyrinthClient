//
//  UIViewController+ShowAlertView.h
//  DetiBela
//
//  Created by Женя Михайлова on 16.02.15.
//  Copyright (c) 2015 Mobigear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowAlertView)

-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message andAction:(UIAlertAction*)action;

@end
