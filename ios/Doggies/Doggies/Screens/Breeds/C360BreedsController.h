//
// C360BreedsController.h.h
// 
// Created on 2015-05-31 using NibFree
// 

#import <UIKit/UIKit.h>
#import "C360APIClient.h"

@class C360Breed;
@class C360BreedsController;

@protocol C360BreedsControllerDelegate <NSObject>

- (BOOL)breedsController:(C360BreedsController *)breedsController isBreedSelected:(C360Breed *)breed;

- (void)breedsControllerDidCancel:(C360BreedsController *)breedsController;
- (void)breedsController:(C360BreedsController *)breedsController didSelectBreed:(C360Breed *)breed;

@end

@interface C360BreedsController : UIViewController

@property (nonatomic, strong, readonly) C360APIClient *apiClient;
- (instancetype)initWithAPIClient:(C360APIClient *)apiClient;

@property (nonatomic, weak) id<C360BreedsControllerDelegate> delegate;

@end
