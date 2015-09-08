//
// C360EditDogView.h.h
// 
// Created on 2015-08-24 using NibFree
// 

#import "C360BaseView.h"

@class C360EditDogView;

@protocol C360EditDogViewDataSource <NSObject>

- (NSString *)editDogViewDogName:(C360EditDogView *)editDogView;
- (NSString *)editDogViewBreedName:(C360EditDogView *)editDogView;
- (NSInteger)editDogViewNumberOfBottomsSniffed:(C360EditDogView *)editDogView;
- (NSInteger)editDogViewNumberOfCatsChased:(C360EditDogView *)editDogView;
- (NSInteger)editDogViewNumberOfFacesLicked:(C360EditDogView *)editDogView;

@end

@protocol C360EditDogViewDelegate <NSObject, C360BaseViewDelegate>

- (void)editDogView:(C360EditDogView *)editDogView didChangeDogName:(NSString *)dogName;
- (void)editDogView:(C360EditDogView *)editDogView didTapBreedButton:(id)sender;
- (void)editDogView:(C360EditDogView *)editDogView didChangeNumberOfBottomsSniffed:(NSInteger)numberOfBottomsSniffed;
- (void)editDogView:(C360EditDogView *)editDogView didChangeNumberOfCatsChased:(NSInteger)numberOfCatsChased;
- (void)editDogView:(C360EditDogView *)editDogView didChangeNumberOfFacesLicked:(NSInteger)numberOfFacesLicked;

@end

@interface C360EditDogView : C360BaseView

@property (nonatomic, weak) id<C360EditDogViewDataSource> dataSource;
@property (nonatomic, weak) id<C360EditDogViewDelegate> delegate;

- (void)reloadData;
- (void)focusNameField;

@end
