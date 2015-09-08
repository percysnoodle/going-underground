//
//  CNCBaseView.m
//  Ciphers
//
//  Created by Simon Booth on 23/07/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import "C360BaseView.h"

@interface C360BaseView ()

@property (nonatomic, assign, readwrite) CGRect keyboardFrameInWindow;

@end

@implementation C360BaseView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _keyboardFrameInWindow = CGRectNull;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self transitionToKeyboardFrame:keyboardFrame curve:curve duration:duration];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self transitionToKeyboardFrame:keyboardFrame curve:curve duration:duration];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self transitionToKeyboardFrame:CGRectNull curve:curve duration:duration];
}

- (void)transitionToKeyboardFrame:(CGRect)keyboardFrame curve:(UIViewAnimationCurve)curve duration:(NSTimeInterval)duration
{
    NSInteger options = 0;
    
    switch (curve)
    {
        case UIViewAnimationCurveEaseIn:
            options = UIViewAnimationOptionCurveEaseIn;
            break;
            
        case UIViewAnimationCurveEaseInOut:
            options = UIViewAnimationOptionCurveEaseInOut;
            break;
            
        case UIViewAnimationCurveEaseOut:
            options = UIViewAnimationOptionCurveEaseOut;
            break;
            
        case UIViewAnimationCurveLinear:
            options = UIViewAnimationOptionCurveLinear;
            break;
    }
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        
        self.keyboardFrameInWindow = keyboardFrame;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
    } completion:nil];
}

@end
