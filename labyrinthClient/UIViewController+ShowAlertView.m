//
//  UIViewController+ShowAlertView.m
//  DetiBela
//
//  Created by Женя Михайлова on 16.02.15.
//  Copyright (c) 2015 Mobigear. All rights reserved.
//

#import "UIViewController+ShowAlertView.h"

@implementation UIViewController (ShowAlertView)

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    if ( NSClassFromString(@"UIAlertController") != nil ) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:title
                                  message:message
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message andAction:(UIAlertAction*)action {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];

}

@end
