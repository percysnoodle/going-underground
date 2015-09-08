//
// C360DogsView.m.h
// 
// Created on 2015-05-31 using NibFree
// 

#import "C360DogsView.h"

@interface C360DogsView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) UIButton *errorButton;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;

@end

@implementation C360DogsView

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
    [self.delegate dogsViewDidRequestReload:self];
}

- (void)reloadData
{
    NSString *errorMessage = [self.dataSource dogsViewErrorMessage:self];
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
    return [self.dataSource dogsViewNumberOfDogs:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    C360DogWhisperer *dogWhisperer = [self.dataSource dogsView:self dogWhispererAtIndex:indexPath.row];
    cell.textLabel.text = dogWhisperer.name;
    cell.detailTextLabel.text = dogWhisperer.breedName;
    
    if (dogWhisperer.isPendingDeletion)
    {
        cell.textLabel.alpha = cell.detailTextLabel.alpha = 0.5;
    }
    else
    {
        cell.textLabel.alpha = cell.detailTextLabel.alpha = 1.0;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate dogsView:self didSelectDogAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate dogsView:self didDeleteDogAtIndex:indexPath.row];
    [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end

