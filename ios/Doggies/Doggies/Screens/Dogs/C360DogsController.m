//
// C360DogsController.m.h
// 
// Created on 2015-05-31 using NibFree
// 

#import "C360DogsController.h"
#import "C360DogsView.h"

#import "C360DogController.h"
#import "C360EditDogController.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface C360DogsController () <C360DogsViewDataSource, C360DogsViewDelegate, C360DogControllerDelegate, C360EditDogControllerDelegate>

@property (nonatomic, strong, readonly) C360DogsView *dogsView;

@property (nonatomic, strong, readonly) UIBarButtonItem *composeButton;

@property (nonatomic, strong) NSArray *dogs;
@property (nonatomic, strong) NSError *error;

@end

@implementation C360DogsController

- (id)initWithAPIClient:(C360APIClient *)apiClient
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _apiClient = apiClient;
        
        self.title = @"Doggies";
        
        _composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped:)];
        self.navigationItem.rightBarButtonItem = _composeButton;
    }
    return self;
}

- (void)composeButtonTapped:(id)sender
{
    [self showEditDogController];
}

- (void)loadView
{
    self.view = [[C360DogsView  alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.dogsView.dataSource = self;
    self.dogsView.delegate = self;
    [self.dogsView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dogsView flashScrollIndicators];
}

#pragma mark - View

- (C360DogsView *)dogsView
{
    return (C360DogsView *)self.view;
}

- (NSString *)dogsViewErrorMessage:(C360DogsView *)dogsView
{
    if (self.error)
    {
        return self.error.localizedDescription;
    }
    else if (self.dogs.count == 0)
    {
        return @"No dogs found";
    }
    else
    {
        return nil;
    }
}

- (NSInteger)dogsViewNumberOfDogs:(C360DogsView *)dogsView
{
    return self.dogs.count;
}

- (C360DogWhisperer *)dogsView:(C360DogsView *)dogsView dogWhispererAtIndex:(NSInteger)index
{
    C360Dog *dog = self.dogs[index];
    return [C360DogWhisperer dogWhispererWithDog:dog];
}

- (void)dogsView:(C360DogsView *)dogsView didSelectDogAtIndex:(NSInteger)index
{
    C360Dog *dog = self.dogs[index];
    [self showDogControllerForDog:dog];
}

- (void)dogsView:(C360DogsView *)dogsView didDeleteDogAtIndex:(NSInteger)index
{
    C360Dog *dog = self.dogs[index];
    [self deleteDog:dog];
}

- (void)dogsViewDidRequestReload:(C360DogsView *)dogsView
{
    [self reloadData:YES];
}

#pragma mark - Loading data

- (void)reloadData:(BOOL)forceLoadFromServer
{
    if (!self.dogs)
    {
        forceLoadFromServer = YES;
    }
    
    C360ObjectSource source = C360CoreDataSource;
    if (forceLoadFromServer)
    {
        source = C360AnySource;
    }
    
    [MBProgressHUD showHUDAddedTo:self.dogsView animated:YES];
    
    [C360Dog fetchDogsFromSource:source usingAPIClient:self.apiClient successHandler:^(NSArray *array) {
        
        self.dogs = array;
        self.error = nil;
        
        [self didReloadData];
        
    } failureHandler:^(NSError *error) {
        
        self.dogs = nil;
        self.error = error;
        
        [self didReloadData];
        
    }];
}

- (void)didReloadData
{
    [MBProgressHUD hideAllHUDsForView:self.dogsView animated:YES];
    [self.dogsView reloadData];
}

#pragma mark - Deleting

- (void)deleteDog:(C360Dog *)dog
{
    self.composeButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.dogsView animated:YES];
    
    [dog deleteUsingAPIClient:self.apiClient successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        if (submittedToServer)
        {
            [self didDeleteDog];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your change has been saved locally and will be synchronised with the server as soon as possible." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self didDeleteDog];
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } failureHandler:^(NSError *error) {
       
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self didDeleteDog];
        
    }];
}

- (void)didDeleteDog
{
    self.composeButton.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.dogsView animated:YES];
    
    [self reloadData:NO];
}

#pragma mark - Dog controller delegate

- (void)showDogControllerForDog:(C360Dog *)dog
{
    C360DogController *dogController = [[C360DogController alloc] initWithAPIClient:self.apiClient dog:dog];
    dogController.delegate = self;
    [self showViewController:dogController sender:nil];
}

- (void)dogControllerDidDeleteDog:(C360DogController *)dogController
{
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - Edit dog controller and delegate

- (void)showEditDogController
{
    C360EditDogController *editDogController = [[C360EditDogController alloc] initWithAPIClient:self.apiClient];
    editDogController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editDogController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)editDogControllerDidCancel:(C360EditDogController *)editDogController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editDogController:(C360EditDogController *)editDogController didSaveDog:(C360Dog *)dog
{
    [self reloadData:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        [self showDogControllerForDog:dog];
    }];
}

@end

