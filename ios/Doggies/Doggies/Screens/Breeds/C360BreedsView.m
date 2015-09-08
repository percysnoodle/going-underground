//
// C360BreedsView.m.h
// 
// Created on 2015-05-31 using NibFree
// 

#import "C360BreedsView.h"

@interface C360BreedsView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) UIButton *errorButton;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;

@end

@implementation C360BreedsView

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
    [self.delegate breedsViewDidRequestReload:self];
}

- (void)reloadData
{
    NSString *errorMessage = [self.dataSource breedsViewErrorMessage:self];
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
        self.errorButton.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

- (void)tintColorDidChange
{
    [self reloadData];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource breedsViewNumberOfBreeds:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    C360Breed *breed = [self.dataSource breedsView:self breedAtIndex:indexPath.row];
    cell.textLabel.text = breed.name;
    
    if ([self.dataSource breedsView:self isBreedSelectedAtIndex:indexPath.row])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate breedsView:self didSelectBreedAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

