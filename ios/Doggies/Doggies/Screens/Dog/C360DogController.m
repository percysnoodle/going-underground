//
// C360DogController.m.h
// 
// Created on 2015-06-09 using NibFree
// 

#import "C360DogController.h"
#import "C360DogView.h"

#import "C360EditDogController.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface C360DogController () <C360DogViewDataSource, C360DogViewDelegate, C360EditDogControllerDelegate>

@property (nonatomic, strong, readonly) C360DogView *dogView;

@property (nonatomic, strong, readonly) UIBarButtonItem *composeButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *deleteButton;

@property (nonatomic, strong, readwrite) C360DogWhisperer *dogWhisperer;
@property (nonatomic, strong) NSError *error;

@end

@implementation C360DogController

- (id)initWithAPIClient:(C360APIClient *)apiClient dog:(C360Dog *)dog
{
    self = [self initWithAPIClient:apiClient dogId:dog.dogId];
    if (self)
    {
        if (dog.isFullObject.boolValue)
        {
            _dogWhisperer = [C360DogWhisperer dogWhispererWithDog:dog];
        }
    }
    return self;
}

- (id)initWithAPIClient:(C360APIClient *)apiClient dogId:(NSNumber *)dogId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _apiClient = apiClient;
        _dogId = dogId;
        
        _deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonTapped:)];
        
        _composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped:)];
        
        self.navigationItem.rightBarButtonItems = @[ _deleteButton, _composeButton ];
    }
    return self;
}

- (C360Dog *)dog
{
    return self.dogWhisperer.dog;
}

- (void)deleteButtonTapped:(id)sender
{
    [self deleteDog];
}

- (void)composeButtonTapped:(id)sender
{
    [self showEditDogController];
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[C360DogView  alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.dogView.dataSource = self;
    self.dogView.delegate = self;
    [self.dogView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dogView flashScrollIndicators];
}

#pragma mark - View and delegate

- (C360DogView *)dogView
{
    return (C360DogView *)self.view;
}

- (NSString *)dogViewErrorMessage:(C360DogView *)dogView
{
    return self.error.localizedDescription;
}

- (C360DogWhisperer *)dogViewDogWhisperer:(C360DogView *)dogView
{
    return self.dogWhisperer;
}

- (void)dogViewDidRequestReload:(C360DogView *)dogView
{
    [self reloadData:YES];
}

#pragma mark - Loading data

- (void)reloadData:(BOOL)forceLoadFromServer
{
    if (self.dog && !self.dogId)
    {
        [self didReloadData];
        return;
    }
    
    if (!self.dog.isFullObject.boolValue)
    {
        forceLoadFromServer = YES;
    }
    
    C360ObjectSource source = C360CoreDataSource;
    if (forceLoadFromServer)
    {
        source = C360AnySource;
    }
    
    self.composeButton.enabled = NO;
    self.deleteButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.dogView animated:YES];
    
    [C360Dog fetchDogWithId:self.dogId fromSource:source usingAPIClient:self.apiClient successHandler:^(C360Dog *dog) {
        
        self.dogWhisperer = [C360DogWhisperer dogWhispererWithDog:dog];
        self.error = nil;
        
        [self didReloadData];
        
    } failureHandler:^(NSError *error) {
        
        self.dogWhisperer = nil;
        self.error = error;
        
        [self didReloadData];
        
    }];
}

- (void)didReloadData
{
    if (self.dogWhisperer)
    {
        self.title = self.dogWhisperer.name;
        
        self.composeButton.enabled = YES;
        self.deleteButton.enabled = YES;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.dogView animated:YES];
    
    [self.dogView reloadData];
}

#pragma mark - Deleting

- (void)deleteDog
{
    self.composeButton.enabled = NO;
    self.deleteButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.dogView animated:YES];
    
    [self.dog deleteUsingAPIClient:self.apiClient successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        if (submittedToServer)
        {
            [self.delegate dogControllerDidDeleteDog:self];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your change has been saved locally and will be synchronised with the server as soon as possible." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self.delegate dogControllerDidDeleteDog:self];
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } failureHandler:^(NSError *error) {
       
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        self.composeButton.enabled = YES;
        self.deleteButton.enabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.dogView animated:YES];
        
        [self.dogView reloadData];
        
    }];
}

#pragma mark - Edit dog controller and delegate

- (void)showEditDogController
{
    C360EditDogController *editDogController = [[C360EditDogController alloc] initWithAPIClient:self.apiClient dog:self.dog];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

