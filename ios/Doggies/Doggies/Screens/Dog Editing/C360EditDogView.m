//
// C360EditDogView.m.h
// 
// Created on 2015-08-24 using NibFree
// 

#import "C360EditDogView.h"

@interface C360EditDogView () <UITextFieldDelegate>

@property (nonatomic, strong, readonly) UIScrollView *contentView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UITextField *nameTextField;
@property (nonatomic, strong, readonly) UILabel *breedNameLabel;
@property (nonatomic, strong, readonly) UITextField *breedNameTextField;
@property (nonatomic, strong, readonly) UIButton *breedNameButton;
@property (nonatomic, strong, readonly) UILabel *numberOfBottomsSniffedLabel;
@property (nonatomic, strong, readonly) UITextField *numberOfBottomsSniffedTextField;
@property (nonatomic, strong, readonly) UIStepper *numberOfBottomsSniffedStepper;
@property (nonatomic, strong, readonly) UILabel *numberOfCatsChasedLabel;
@property (nonatomic, strong, readonly) UITextField *numberOfCatsChasedTextField;
@property (nonatomic, strong, readonly) UIStepper *numberOfCatsChasedStepper;
@property (nonatomic, strong, readonly) UILabel *numberOfFacesLickedLabel;
@property (nonatomic, strong, readonly) UITextField *numberOfFacesLickedTextField;
@property (nonatomic, strong, readonly) UIStepper *numberOfFacesLickedStepper;

@end

@implementation C360EditDogView

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_contentView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Name:";
        _nameLabel.textColor = [UIColor grayColor];
        [_contentView addSubview:_nameLabel];
        
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        [_nameTextField addTarget:self action:@selector(nameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_contentView addSubview:_nameTextField];
        
        _breedNameLabel = [[UILabel alloc] init];
        _breedNameLabel.text = @"Breed:";
        _breedNameLabel.textColor = [UIColor grayColor];
        [_contentView addSubview:_breedNameLabel];
        
        _breedNameTextField = [[UITextField alloc] init];
        _breedNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _breedNameTextField.delegate = self;
        [_contentView addSubview:_breedNameTextField];
        
        _breedNameButton = [[UIButton alloc] init];
        [_breedNameButton addTarget:self action:@selector(breedNameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_breedNameButton];
        
        _numberOfBottomsSniffedLabel = [[UILabel alloc] init];
        _numberOfBottomsSniffedLabel.text = @"Bums Sniffed:";
        _numberOfBottomsSniffedLabel.textColor = [UIColor grayColor];
        [_contentView addSubview:_numberOfBottomsSniffedLabel];
        
        _numberOfBottomsSniffedTextField = [[UITextField alloc] init];
        _numberOfBottomsSniffedTextField.borderStyle = UITextBorderStyleRoundedRect;
        _numberOfBottomsSniffedTextField.delegate = self;
        _numberOfBottomsSniffedTextField.textColor = [UIColor darkGrayColor];
        [_contentView addSubview:_numberOfBottomsSniffedTextField];
        
        _numberOfBottomsSniffedStepper = [[UIStepper alloc] init];
        [_numberOfBottomsSniffedStepper addTarget:self action:@selector(numberOfBottomsSniffedStepperChanged:) forControlEvents:UIControlEventValueChanged];
        [_contentView addSubview:_numberOfBottomsSniffedStepper];
        
        _numberOfCatsChasedLabel = [[UILabel alloc] init];
        _numberOfCatsChasedLabel.text = @"Cats Chased:";
        _numberOfCatsChasedLabel.textColor = [UIColor grayColor];
        [_contentView addSubview:_numberOfCatsChasedLabel];
        
        _numberOfCatsChasedTextField = [[UITextField alloc] init];
        _numberOfCatsChasedTextField.borderStyle = UITextBorderStyleRoundedRect;
        _numberOfCatsChasedTextField.delegate = self;
        _numberOfCatsChasedTextField.textColor = [UIColor darkGrayColor];
        [_contentView addSubview:_numberOfCatsChasedTextField];
        
        _numberOfCatsChasedStepper = [[UIStepper alloc] init];
        [_numberOfCatsChasedStepper addTarget:self action:@selector(numberOfCatsChasedStepperChanged:) forControlEvents:UIControlEventValueChanged];
        [_contentView addSubview:_numberOfCatsChasedStepper];
        
        _numberOfFacesLickedLabel = [[UILabel alloc] init];
        _numberOfFacesLickedLabel.text = @"Faces Licked:";
        _numberOfFacesLickedLabel.textColor = [UIColor grayColor];
        [_contentView addSubview:_numberOfFacesLickedLabel];
        
        _numberOfFacesLickedTextField = [[UITextField alloc] init];
        _numberOfFacesLickedTextField.borderStyle = UITextBorderStyleRoundedRect;
        _numberOfFacesLickedTextField.delegate = self;
        _numberOfFacesLickedTextField.textColor = [UIColor darkGrayColor];
        [_contentView addSubview:_numberOfFacesLickedTextField];
        
        _numberOfFacesLickedStepper = [[UIStepper alloc] init];
        [_numberOfFacesLickedStepper addTarget:self action:@selector(numberOfFacesLickedStepperChanged:) forControlEvents:UIControlEventValueChanged];
        [_contentView addSubview:_numberOfFacesLickedStepper];
    }
    return self;
}

- (void)reloadData
{
    self.nameTextField.text = [self.dataSource editDogViewDogName:self];
    
    self.breedNameTextField.text = [self.dataSource editDogViewBreedName:self];
    
    NSInteger numberOfBottomsSniffed = [self.dataSource editDogViewNumberOfBottomsSniffed:self];
    self.numberOfBottomsSniffedTextField.text = [@(numberOfBottomsSniffed) stringValue];
    self.numberOfBottomsSniffedStepper.value = numberOfBottomsSniffed;
    
    NSInteger numberOfCatsChased = [self.dataSource editDogViewNumberOfCatsChased:self];
    self.numberOfCatsChasedTextField.text = [@(numberOfCatsChased) stringValue];
    self.numberOfCatsChasedStepper.value = numberOfCatsChased;
    
    NSInteger numberOfFacesLicked = [self.dataSource editDogViewNumberOfFacesLicked:self];
    self.numberOfFacesLickedTextField.text = [@(numberOfFacesLicked) stringValue];
    self.numberOfFacesLickedStepper.value = numberOfFacesLicked;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    
    UIEdgeInsets contentInset = self.contentInset;
    if (!CGRectIsNull(self.keyboardFrameInWindow))
    {
        CGRect keyboardFrameInSelf = [self convertRect:self.keyboardFrameInWindow fromView:nil];
        CGRect intersection = CGRectIntersection(self.bounds, keyboardFrameInSelf);
        contentInset.bottom = MAX(contentInset.bottom, intersection.size.height);
    }
    self.contentView.contentInset = self.contentView.scrollIndicatorInsets = contentInset;
    
    CGFloat top = 10, left = 10, width = self.bounds.size.width - 20;

    CGSize nameLabelSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                                           
        NSFontAttributeName : self.nameLabel.font
        
    } context:nil].size;
    self.nameLabel.frame = CGRectMake(left, top, width, nameLabelSize.height);
    top += ceil(nameLabelSize.height + 5);
    
    CGSize nameTextFieldSize = [self.nameTextField sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.nameTextField.frame = CGRectMake(left, top, width, nameTextFieldSize.height);
    top += ceil(nameTextFieldSize.height + 15);

    CGSize breedNameLabelSize = [self.breedNameLabel.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                                           
        NSFontAttributeName : self.breedNameLabel.font
        
    } context:nil].size;
    self.breedNameLabel.frame = CGRectMake(left, top, width, breedNameLabelSize.height);
    top += ceil(breedNameLabelSize.height + 5);
    
    CGSize breedNameTextFieldSize = [self.breedNameTextField sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    CGRect breedNameFrame = CGRectMake(left, top, width, breedNameTextFieldSize.height);
    self.breedNameTextField.frame = breedNameFrame;
    self.breedNameButton.frame = breedNameFrame;
    top += ceil(breedNameTextFieldSize.height + 15);

    CGSize numberOfBottomsSniffedLabelSize = [self.numberOfBottomsSniffedLabel.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                                           
        NSFontAttributeName : self.numberOfBottomsSniffedLabel.font
        
    } context:nil].size;
    self.numberOfBottomsSniffedLabel.frame = CGRectMake(left, top, width, numberOfBottomsSniffedLabelSize.height);
    top += ceil(numberOfBottomsSniffedLabelSize.height + 5);
    
    CGSize numberOfBottomsSniffedStepperSize = [self.numberOfBottomsSniffedStepper sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat numberOfBottomsSniffedStepperWidth = numberOfBottomsSniffedStepperSize.width;
    CGFloat numberOfBottomsSniffedTextFieldWidth = width - (10 + numberOfBottomsSniffedStepperWidth);
    CGSize numberOfBottomsSniffedTextFieldSize = [self.numberOfBottomsSniffedTextField sizeThatFits:CGSizeMake(numberOfBottomsSniffedTextFieldWidth, CGFLOAT_MAX)];
    
    CGFloat numberOfBottomsSniffedRowHeight = ceil(MAX(numberOfBottomsSniffedTextFieldSize.height, numberOfBottomsSniffedStepperSize.height));
    
    self.numberOfBottomsSniffedTextField.frame = CGRectMake(left, top, numberOfBottomsSniffedTextFieldWidth, numberOfBottomsSniffedRowHeight);
    self.numberOfBottomsSniffedStepper.frame = CGRectMake(left + width - numberOfBottomsSniffedStepperWidth, top, numberOfBottomsSniffedStepperWidth, numberOfBottomsSniffedRowHeight);
    top += numberOfBottomsSniffedRowHeight + 15;
    
    CGSize numberOfCatsChasedLabelSize = [self.numberOfCatsChasedLabel.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                                           
        NSFontAttributeName : self.numberOfCatsChasedLabel.font
        
    } context:nil].size;
    self.numberOfCatsChasedLabel.frame = CGRectMake(left, top, width, numberOfCatsChasedLabelSize.height);
    top += ceil(numberOfCatsChasedLabelSize.height + 5);
    
    CGSize numberOfCatsChasedStepperSize = [self.numberOfCatsChasedStepper sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat numberOfCatsChasedStepperWidth = numberOfCatsChasedStepperSize.width;
    CGFloat numberOfCatsChasedTextFieldWidth = width - (10 + numberOfCatsChasedStepperWidth);
    CGSize numberOfCatsChasedTextFieldSize = [self.numberOfCatsChasedTextField sizeThatFits:CGSizeMake(numberOfCatsChasedTextFieldWidth, CGFLOAT_MAX)];
    
    CGFloat numberOfCatsChasedRowHeight = ceil(MAX(numberOfCatsChasedTextFieldSize.height, numberOfCatsChasedStepperSize.height));
    
    self.numberOfCatsChasedTextField.frame = CGRectMake(left, top, numberOfCatsChasedTextFieldWidth, numberOfCatsChasedRowHeight);
    self.numberOfCatsChasedStepper.frame = CGRectMake(left + width - numberOfCatsChasedStepperWidth, top, numberOfCatsChasedStepperWidth, numberOfCatsChasedRowHeight);
    top += numberOfCatsChasedRowHeight + 15;
    
    CGSize numberOfFacesLickedLabelSize = [self.numberOfFacesLickedLabel.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                                           
        NSFontAttributeName : self.numberOfFacesLickedLabel.font
        
    } context:nil].size;
    self.numberOfFacesLickedLabel.frame = CGRectMake(left, top, width, numberOfFacesLickedLabelSize.height);
    top += ceil(numberOfFacesLickedLabelSize.height + 5);
    
    CGSize numberOfFacesLickedStepperSize = [self.numberOfFacesLickedStepper sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat numberOfFacesLickedStepperWidth = numberOfFacesLickedStepperSize.width;
    CGFloat numberOfFacesLickedTextFieldWidth = width - (10 + numberOfFacesLickedStepperWidth);
    CGSize numberOfFacesLickedTextFieldSize = [self.numberOfFacesLickedTextField sizeThatFits:CGSizeMake(numberOfFacesLickedTextFieldWidth, CGFLOAT_MAX)];
    
    CGFloat numberOfFacesLickedRowHeight = ceil(MAX(numberOfFacesLickedTextFieldSize.height, numberOfFacesLickedStepperSize.height));
    
    self.numberOfFacesLickedTextField.frame = CGRectMake(left, top, numberOfFacesLickedTextFieldWidth, numberOfFacesLickedRowHeight);
    self.numberOfFacesLickedStepper.frame = CGRectMake(left + width - numberOfFacesLickedStepperWidth, top, numberOfFacesLickedStepperWidth, numberOfFacesLickedRowHeight);
    top += numberOfFacesLickedRowHeight + 15;
    
    self.contentView.contentSize = CGSizeMake(width, top);
}

- (void)focusNameField
{
    [self.nameTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return (textField == self.nameTextField);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTextField)
    {
        if ([string isEqual:@"\n"])
        {
            [self endEditing:YES];
            return NO;
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)nameTextFieldDidChange:(id)sender
{
    [self.delegate editDogView:self didChangeDogName:self.nameTextField.text];
}

- (void)breedNameButtonTapped:(id)sender
{
    [self.delegate editDogView:self didTapBreedButton:sender];
}

- (void)numberOfBottomsSniffedStepperChanged:(id)sender
{
    [self.delegate editDogView:self didChangeNumberOfBottomsSniffed:self.numberOfBottomsSniffedStepper.value];
    [self reloadData];
}

- (void)numberOfCatsChasedStepperChanged:(id)sender
{
    [self.delegate editDogView:self didChangeNumberOfCatsChased:self.numberOfCatsChasedStepper.value];
    [self reloadData];
}

- (void)numberOfFacesLickedStepperChanged:(id)sender
{
    [self.delegate editDogView:self didChangeNumberOfFacesLicked:self.numberOfFacesLickedStepper.value];
    [self reloadData];
}

@end

