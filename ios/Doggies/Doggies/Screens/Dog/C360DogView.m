//
// C360DogView.m.h
// 
// Created on 2015-06-09 using NibFree
// 

#import "C360DogView.h"

typedef NS_ENUM(NSInteger, C360DogViewDetailsRow)
{
    C360DogViewDetailsRowStatus,
    C360DogViewDetailsRowBreed,
    C360DogViewDetailsRowBottomsSniffed,
    C360DogViewDetailsRowCatsChased,
    C360DogViewDetailsRowFacesLicked,
    
    C360DogViewLastDetailsRow = C360DogViewDetailsRowFacesLicked
};

@interface C360DogView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) UIButton *errorButton;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;

@end

@implementation C360DogView

@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _errorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _errorButton.titleLabel.numberOfLines = 0;
        _errorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _errorButton.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_errorButton addTarget:self action:@selector(didRequestReload) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_errorButton];
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_tableView];
        
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(didRequestReload) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:_refreshControl];
    }
    return self;
}

- (void)layoutSubviews
{
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = self.tableView.scrollIndicatorInsets = self.contentInset;
    
    self.errorButton.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
}

- (void)didRequestReload
{
    [self.refreshControl endRefreshing];
    [self.delegate dogViewDidRequestReload:self];
}

- (void)reloadData
{
    NSString *errorMessage = [self.dataSource dogViewErrorMessage:self];
    if (errorMessage)
    {
        self.tableView.hidden = YES;
        self.errorButton.hidden = NO;
        
        NSMutableAttributedString *buttonTitle = [[NSMutableAttributedString alloc] init];
        
        [buttonTitle appendAttributedString:[[NSAttributedString alloc] initWithString:errorMessage attributes:@{ NSForegroundColorAttributeName : [UIColor darkTextColor] }]];
        [buttonTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" attributes:nil]];
        [buttonTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"Tap to retry." attributes:@{
            NSForegroundColorAttributeName : self.tintColor,
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
        }]];
        
        [self.errorButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    }
    else
    {
        C360DogWhisperer *dogWhisperer = [self.dataSource dogViewDogWhisperer:self];
        
        if (dogWhisperer)
        {
            self.errorButton.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        else
        {
            self.errorButton.hidden = YES;
            self.tableView.hidden = YES;
        }
    }
}

- (void)tintColorDidChange
{
    [self reloadData];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return C360DogViewLastDetailsRow + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"detailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor = self.tintColor;
    
    C360DogWhisperer *dogWhisperer = [self.dataSource dogViewDogWhisperer:self];
    
    switch ((C360DogViewDetailsRow)indexPath.row)
    {
        case C360DogViewDetailsRowStatus:
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = dogWhisperer.status;
            break;
            
        case C360DogViewDetailsRowBreed:
            cell.textLabel.text = @"Breed";
            cell.detailTextLabel.text = dogWhisperer.breedName;
            break;
            
        case C360DogViewDetailsRowCatsChased:
            cell.textLabel.text = @"Cats Chased";
            cell.detailTextLabel.text = dogWhisperer.numberOfCatsChased.stringValue;
            break;
            
        case C360DogViewDetailsRowFacesLicked:
            cell.textLabel.text = @"Faces Licked";
            cell.detailTextLabel.text = dogWhisperer.numberOfFacesLicked.stringValue;
            break;
            
        case C360DogViewDetailsRowBottomsSniffed:
            cell.textLabel.text = @"Bums Sniffed";
            cell.detailTextLabel.text = dogWhisperer.numberOfBottomsSniffed.stringValue;
            break;
    }
    
    return cell;
}

@end
