//
// C360EditDogController.h.h
// 
// Created on 2015-08-24 using NibFree
// 

#import <UIKit/UIKit.h>
#import "C360Dog.h"

@class C360EditDogController;

@protocol C360EditDogControllerDelegate <NSObject>

- (void)editDogControllerDidCancel:(C360EditDogController *)editDogController;
- (void)editDogController:(C360EditDogController *)editDogController didSaveDog:(C360Dog *)dog;

@end

@interface C360EditDogController : UIViewController

@property (nonatomic, strong, readonly) C360APIClient *apiClient;
- (instancetype)initWithAPIClient:(C360APIClient *)apiClient;

@property (nonatomic, strong, readonly) C360Dog *dog;
- (instancetype)initWithAPIClient:(C360APIClient *)apiClient dog:(C360Dog *)dog;

@property (nonatomic, weak) id<C360EditDogControllerDelegate> delegate;

@end
