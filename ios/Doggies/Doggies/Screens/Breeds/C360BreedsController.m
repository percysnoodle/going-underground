//
// C360BreedsController.m.h
// 
// Created on 2015-05-31 using NibFree
// 

#import "C360BreedsController.h"
#import "C360BreedsView.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface C360BreedsController () <C360BreedsViewDataSource, C360BreedsViewDelegate>

@property (nonatomic, strong, readonly) C360BreedsView *breedsView;

@property (nonatomic, strong) NSArray *breeds;
@property (nonatomic, strong) NSError *error;

@end

@implementation C360BreedsController

- (id)initWithAPIClient:(C360APIClient *)apiClient
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _apiClient = apiClient;
        
        self.title = @"Breeds";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    }
    return self;
}

- (void)cancelButtonTapped:(id)sender
{
    [self.delegate breedsControllerDidCancel:self];
}

- (void)loadView
{
    self.view = [[C360BreedsView  alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.breedsView.dataSource = self;
    self.breedsView.delegate = self;
    [self.breedsView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.breedsView flashScrollIndicators];
}

#pragma mark - View

- (C360BreedsView *)breedsView
{
    return (C360BreedsView *)self.view;
}

- (NSString *)breedsViewErrorMessage:(C360BreedsView *)breedsView
{
    if (self.error)
    {
        return self.error.localizedDescription;
    }
    else if (self.breeds.count == 0)
    {
        return @"No breeds found";
    }
    else
    {
        return nil;
    }
}

- (NSInteger)breedsViewNumberOfBreeds:(C360BreedsView *)breedsView
{
    return self.breeds.count;
}

- (C360Breed *)breedsView:(C360BreedsView *)breedsView breedAtIndex:(NSInteger)index
{
    return self.breeds[index];
}

- (BOOL)breedsView:(C360BreedsView *)breedsView isBreedSelectedAtIndex:(NSInteger)index
{
    C360Breed *breed = self.breeds[index];
    return [self.delegate breedsController:self isBreedSelected:breed];
}

- (void)breedsView:(C360BreedsView *)breedsView didSelectBreedAtIndex:(NSInteger)index
{
    C360Breed *breed = self.breeds[index];
    [self.delegate breedsController:self didSelectBreed:breed];
}

- (void)breedsViewDidRequestReload:(C360BreedsView *)breedsView
{
    [self reloadData:YES];
}

#pragma mark - Loading data

- (void)reloadData:(BOOL)forceLoadFromServer
{
    if (!self.breeds)
    {
        forceLoadFromServer = YES;
    }
    
    C360ObjectSource source = C360CoreDataSource;
    if (forceLoadFromServer)
    {
        source = C360AnySource;
    }
    
    [MBProgressHUD showHUDAddedTo:self.breedsView animated:YES];
    
    [C360Breed fetchBreedsFromSource:source usingAPIClient:self.apiClient successHandler:^(NSArray *array) {
        
        self.breeds = array;
        self.error = nil;
        
        [self didReloadData];
        
    } failureHandler:^(NSError *error) {
        
        self.breeds = nil;
        self.error = error;
        
        [self didReloadData];
        
    }];
}

- (void)didReloadData
{
    [MBProgressHUD hideAllHUDsForView:self.breedsView animated:YES];
    [self.breedsView reloadData];
}

@end

