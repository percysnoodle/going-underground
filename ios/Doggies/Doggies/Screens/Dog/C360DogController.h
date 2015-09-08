//
// C360DogController.h.h
// 
// Created on 2015-06-09 using NibFree
// 

#import <UIKit/UIKit.h>
#import "C360APIClient.h"
#import "C360DogWhisperer.h"

@class C360DogController;

@protocol C360DogControllerDelegate <NSObject>

- (void)dogControllerDidDeleteDog:(C360DogController *)dogController;

@end

@interface C360DogController : UIViewController

@property (nonatomic, strong, readonly) C360APIClient *apiClient;
@property (nonatomic, strong, readonly) C360DogWhisperer *dogWhisperer;

@property (nonatomic, strong, readonly) NSNumber *dogId;
- (instancetype)initWithAPIClient:(C360APIClient *)apiClient dogId:(NSNumber *)dogId;

@property (nonatomic, strong, readonly) C360Dog *dog;
- (instancetype)initWithAPIClient:(C360APIClient *)apiClient dog:(C360Dog *)dog;

@property (nonatomic, weak) id<C360DogControllerDelegate> delegate;

@end
