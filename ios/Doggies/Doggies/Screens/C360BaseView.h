//
//  CNCBaseView.h
//  Ciphers
//
//  Created by Simon Booth on 23/07/2015.
//  Copyright (c) 2015 agbooth.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol C360BaseViewDelegate <NSObject, UIScrollViewDelegate>

@end

@interface C360BaseView : UIScrollView

@property (nonatomic, assign, readonly) CGRect keyboardFrameInWindow;
@property (nonatomic, weak) id<C360BaseViewDelegate> delegate;

@end
