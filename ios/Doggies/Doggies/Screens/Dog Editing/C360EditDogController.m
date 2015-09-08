//
// C360EditDogController.m.h
// 
// Created on 2015-08-24 using NibFree
// 

#import "C360EditDogController.h"
#import "C360EditDogView.h"

#import "C360Breed.h"
#import "C360BreedsController.h"

#import "C360DogWhisperer.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface C360EditDogController () <C360EditDogViewDataSource, C360EditDogViewDelegate, C360BreedsControllerDelegate>

@property (nonatomic, strong, readonly) C360EditDogView *editDogView;

@property (nonatomic, strong, readonly) UIBarButtonItem *cancelButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *saveButton;

@property (nonatomic, copy) NSString *dogName;
@property (nonatomic, copy) NSNumber *breedId;
@property (nonatomic, copy) NSString *breedName;
@property (nonatomic, assign) NSInteger numberOfBottomsSniffed;
@property (nonatomic, assign) NSInteger numberOfCatsChased;
@property (nonatomic, assign) NSInteger numberOfFacesLicked;

@end

@implementation C360EditDogController

- (instancetype)initWithAPIClient:(C360APIClient *)apiClient
{
    return [self initWithAPIClient:apiClient dog:nil];
}

- (instancetype)initWithAPIClient:(C360APIClient *)apiClient dog:(C360Dog *)dog
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _apiClient = apiClient;
        
        if (dog)
        {
            self.title = @"Update Dog";
        
            _dog = dog;
            
            C360DogWhisperer *dogWhisperer = [C360DogWhisperer dogWhispererWithDog:dog];
            _dogName = dogWhisperer.name;
            _breedId = dogWhisperer.breedId;
            _breedName = dogWhisperer.breedName;
            _numberOfBottomsSniffed = dogWhisperer.numberOfBottomsSniffed.integerValue;
            _numberOfCatsChased = dogWhisperer.numberOfCatsChased.integerValue;
            _numberOfFacesLicked = dogWhisperer.numberOfFacesLicked.integerValue;
        }
        else
        {
            self.title = @"Create Dog";
            _dogName = @"New dog";
        }
        
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
        self.navigationItem.leftBarButtonItem = _cancelButton;
        
        _saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped:)];
        self.navigationItem.rightBarButtonItem = _saveButton;
    }
    return self;
}

- (void)cancelButtonTapped:(id)sender
{
    [self.delegate editDogControllerDidCancel:self];
}

- (void)saveButtonTapped:(id)sender
{
    [self saveDog];
}

- (void)loadView
{
    self.view = [[C360EditDogView  alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.editDogView.dataSource = self;
    self.editDogView.delegate = self;
    [self.editDogView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.editDogView focusNameField];
}

#pragma mark - View and delegate

- (C360EditDogView *)editDogView
{
    return (C360EditDogView *)self.view;
}

- (NSString *)editDogViewDogName:(C360EditDogView *)editDogView
{
    return self.dogName;
}

- (void)editDogView:(C360EditDogView *)editDogView didChangeDogName:(NSString *)dogName
{
    self.dogName = dogName;
}

- (NSString *)editDogViewBreedName:(C360EditDogView *)editDogView
{
    return self.breedName ?: @"Mongrel";
}

- (void)editDogView:(C360EditDogView *)editDogView didTapBreedButton:(id)sender
{
    [self showBreedsController:sender];
}

- (NSInteger)editDogViewNumberOfBottomsSniffed:(C360EditDogView *)editDogView
{
    return self.numberOfBottomsSniffed;
}

- (void)editDogView:(C360EditDogView *)editDogView didChangeNumberOfBottomsSniffed:(NSInteger)numberOfBottomsSniffed
{
    self.numberOfBottomsSniffed = numberOfBottomsSniffed;
}

- (NSInteger)editDogViewNumberOfCatsChased:(C360EditDogView *)editDogView
{
    return self.numberOfCatsChased;
}

- (void)editDogView:(C360EditDogView *)editDogView didChangeNumberOfCatsChased:(NSInteger)numberOfCatsChased
{
    self.numberOfCatsChased = numberOfCatsChased;
}

- (NSInteger)editDogViewNumberOfFacesLicked:(C360EditDogView *)editDogView
{
    return self.numberOfFacesLicked;
}

- (void)editDogView:(C360EditDogView *)editDogView didChangeNumberOfFacesLicked:(NSInteger)numberOfFacesLicked
{
    self.numberOfFacesLicked = numberOfFacesLicked;
}

#pragma mark - Breed controller and delegate

- (void)showBreedsController:(id)sender
{
    C360BreedsController *breedsController = [[C360BreedsController alloc] initWithAPIClient:self.apiClient];
    breedsController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:breedsController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (BOOL)breedsController:(C360BreedsController *)breedsController isBreedSelected:(C360Breed *)breed
{
    return [self.breedId isEqual:breed.breedId];
}

- (void)breedsControllerDidCancel:(C360BreedsController *)breedsController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)breedsController:(C360BreedsController *)breedsController didSelectBreed:(C360Breed *)breed
{
    self.breedId = breed.breedId;
    self.breedName = breed.name;
    [self.editDogView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Saving

- (void)saveDog
{
    [self.view endEditing:YES];
    
    self.cancelButton.enabled = NO;
    self.saveButton.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.editDogView animated:YES];
    
    if (self.dog.dogId) [self updateDog];
    else [self createDog];
}

- (void)createDog
{
    NSManagedObjectContext *managedObjectContext = self.apiClient.objectManager.managedObjectStore.mainQueueManagedObjectContext;
    
    BOOL deleteDogOnFailure = NO;
    C360Dog *dog = self.dog;
    
    if (!dog)
    {
        dog = [C360Dog insertInManagedObjectContext:managedObjectContext];
        dog.isFullObject = @YES;
        
        deleteDogOnFailure = YES;
    }
    
    dog.name = self.dogName;
    dog.breedId = self.breedId;
    dog.breedName = self.breedName;
    dog.numberOfBottomsSniffed = @(self.numberOfBottomsSniffed);
    dog.numberOfCatsChased = @(self.numberOfCatsChased);
    dog.numberOfFacesLicked = @(self.numberOfFacesLicked);
    
    NSError *savingError = nil;
    if ([managedObjectContext saveToPersistentStore:&savingError])
    {
        [dog createUsingAPIClient:self.apiClient successHandler:^(C360Dog *createdDog, BOOL submittedToServer) {
            
            [self didSaveDog:createdDog submittedToServer:submittedToServer];
            
        } failureHandler:^(NSError *creationError) {
            
            [self didFailToSaveDog:dog withError:creationError deleteDog:deleteDogOnFailure];
            
        }];
    }
    else
    {
        [self didFailToSaveDog:dog withError:savingError deleteDog:deleteDogOnFailure];
    }
}

- (void)updateDog
{
    [self.dog updateUsingAPIClient:self.apiClient configurationBlock:^BOOL(C360DogUpdateSubmission *submission, NSError **outError) {
        
        submission.name = self.dogName;
        submission.breedId = self.breedId;
        submission.breedName = self.breedName;
        submission.numberOfBottomsSniffed = @(self.numberOfBottomsSniffed);
        submission.numberOfCatsChased = @(self.numberOfCatsChased);
        submission.numberOfFacesLicked = @(self.numberOfFacesLicked);
        
        return YES;
        
    } successHandler:^(C360Dog *dog, BOOL submittedToServer) {
        
        [self didSaveDog:dog submittedToServer:submittedToServer];
        
    } failureHandler:^(NSError *error) {
        
        [self didFailToSaveDog:self.dog withError:error deleteDog:NO];
        
    }];
}

- (void)didSaveDog:(C360Dog *)dog submittedToServer:(BOOL)submittedToServer
{
    self.cancelButton.enabled = YES;
    self.saveButton.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.editDogView animated:YES];
    
    if (submittedToServer)
    {
        [self.delegate editDogController:self didSaveDog:dog];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your change has been saved locally and will be synchronised with the server as soon as possible." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
            [self.delegate editDogController:self didSaveDog:dog];
        
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didFailToSaveDog:(C360Dog *)dog withError:(NSError *)error deleteDog:(BOOL)deleteDog
{
    self.cancelButton.enabled = YES;
    self.saveButton.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.editDogView animated:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    if (dog && deleteDog)
    {
        [dog.managedObjectContext deleteObject:dog];
        if ([dog.managedObjectContext saveToPersistentStore:&error])
        {
            NSLog(@"Error deleting temporary dog: %@", error);
        }
    }
}

@end

