//
// C360DogsController.h.h
// 
// Created on 2015-05-31 using NibFree
// 

#import <UIKit/UIKit.h>
#import "C360APIClient.h"

@interface C360DogsController : UIViewController

@property (nonatomic, strong, readonly) C360APIClient *apiClient;
- (instancetype)initWithAPIClient:(C360APIClient *)apiClient;

@end
