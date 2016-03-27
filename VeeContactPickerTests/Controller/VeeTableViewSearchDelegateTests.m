//
//  Created by Andrea Cipriani on 25/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeTableViewSearchDelegate.h"
#import "OCMock.h"
#import "VeeSectionableForTesting.h"

@interface VeeTableViewSearchDelegateTests : XCTestCase

@property (nonatomic,strong) VeeTableViewSearchDelegate* veeTableViewSearchDelegate;

@property (nonatomic,strong) id searchDisplayControllerMock;
@property (nonatomic,strong) id searchTableViewMock;
@property (nonatomic,strong) NSArray* dataToFiler;
@property (nonatomic,strong) id searchResultDelegateMock;


@end

@implementation VeeTableViewSearchDelegateTests

- (void)setUp
{
    [super setUp];
    
    [self loadVeeTableViewSearchDelegateWithMocks];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testShouldReloadTableForSearchStringAndCallDelegate
{
    BOOL shouldReload = [_veeTableViewSearchDelegate searchDisplayController:_searchDisplayControllerMock shouldReloadTableForSearchString:@"foo"];
    NSAssert(shouldReload,@"Should reload table view");
    OCMExpect([_searchResultDelegateMock handleSearchResults:[OCMArg isNotNil] forSearchTableView:_searchTableViewMock]);
    OCMVerify([_searchResultDelegateMock handleSearchResults:[OCMArg isNotNil] forSearchTableView:_searchTableViewMock]);
}

#pragma mark - Private utils

-(void)loadVeeTableViewSearchDelegateWithMocks
{
    _searchDisplayControllerMock = OCMClassMock([UISearchDisplayController class]);
    VeeSectionableForTesting* veeSectionableForTesting1 = [[VeeSectionableForTesting alloc] initWithSectionIdentifier:@"foo"];
    VeeSectionableForTesting* veeSectionableForTesting2 = [[VeeSectionableForTesting alloc] initWithSectionIdentifier:@"bar"];
    _dataToFiler = @[veeSectionableForTesting1,veeSectionableForTesting2];
    _searchTableViewMock = OCMClassMock([UITableView class]);
    NSPredicate* predicateToFilterData = [NSPredicate predicateWithFormat:@"sectionIdentifier contains[c] $searchString"];
    _searchResultDelegateMock = OCMProtocolMock(@protocol(VeeSearchResultsDelegate));
    _veeTableViewSearchDelegate =[[VeeTableViewSearchDelegate alloc] initWithSearchDisplayController:_searchDisplayControllerMock dataToFiler:_dataToFiler withPredicate:predicateToFilterData andSearchResultsDelegate:_searchResultDelegateMock];
}

@end
