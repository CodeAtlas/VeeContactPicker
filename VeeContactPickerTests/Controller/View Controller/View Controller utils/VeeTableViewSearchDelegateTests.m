//
//  Created by Andrea Cipriani on 25/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeTableViewSearchDelegate.h"
#import "OCMock.h"
#import "VeeSectionableForTesting.h"
#import "VeeSearchResultsDelegateForTesting.h"
#import "XCTest+VeeCommons.h"

@interface VeeTableViewSearchDelegateTests : XCTestCase

@property (nonatomic,strong) VeeTableViewSearchDelegate* veeTableViewSearchDelegate;

@property (nonatomic,strong) id searchDisplayControllerMock;
@property (nonatomic,strong) id searchTableViewMock;
@property (nonatomic,strong) NSArray* dataToFiler;
@property (nonatomic,strong) NSArray* filteredDataForF;
@property (nonatomic,strong) NSArray* filteredDataForB;
@property (nonatomic,strong) NSArray* filteredDataForAr;
@property (nonatomic,strong) VeeSearchResultsDelegateForTesting* searchResultDelegateForTesting;

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

- (void)testShouldReloadTableForFooSearchString
{
    BOOL shouldReload = [_veeTableViewSearchDelegate searchDisplayController:_searchDisplayControllerMock shouldReloadTableForSearchString:@"foo"];
    NSAssert(shouldReload,@"Should reload table view");
}

-(void)testFilterContentForEmptyStringShouldReturnInitialValue
{
    [_veeTableViewSearchDelegate filterContentForSearchText:@"" scope:nil];
    BOOL isFilteredDataCorrect = [[_searchResultDelegateForTesting searchResults] isEqual:_dataToFiler];
    NSAssert(isFilteredDataCorrect, @"Filtered data is %@ but should be %@ for search for empty string",[_searchResultDelegateForTesting searchResults],_dataToFiler);
}

-(void)testFilterContentForF
{
    NSString* searchForF = @"f";
    [_veeTableViewSearchDelegate filterContentForSearchText:searchForF scope:nil];
    BOOL isFilteredDataCorrect = [[_searchResultDelegateForTesting searchResults] isEqual:_filteredDataForF];
    NSAssert(isFilteredDataCorrect, @"Filtered data is %@ but should be %@ for search f",[_searchResultDelegateForTesting searchResults],_filteredDataForF);
}

-(void)testFilterContentForB
{
    NSString* searchForB = @"b";
    [_veeTableViewSearchDelegate filterContentForSearchText:searchForB scope:nil];
    BOOL isFilteredDataCorrect = [[_searchResultDelegateForTesting searchResults] isEqual:_filteredDataForB];
    NSAssert(isFilteredDataCorrect, @"Filtered data is %@ but should be %@ for search b",[_searchResultDelegateForTesting searchResults],_filteredDataForB);
}

-(void)testFilterContentForAr
{
    NSString* searchForAr = @"ar";
    [_veeTableViewSearchDelegate filterContentForSearchText:searchForAr scope:nil];
    BOOL isFilteredDataCorrect = [[_searchResultDelegateForTesting searchResults] isEqual:_filteredDataForAr];
    NSAssert(isFilteredDataCorrect, @"Filtered data is %@ but should be %@ for search ar",[_searchResultDelegateForTesting searchResults],_filteredDataForAr);
}

-(void)testFilterContentForVattelapescaShouldBeEmpty
{
    NSString* searchForVattelapesca = @"Vattelapesca";
    [_veeTableViewSearchDelegate filterContentForSearchText:searchForVattelapesca scope:nil];
    BOOL isFilteredDataCorrect = [[_searchResultDelegateForTesting searchResults] isEqual:@[]];
    NSAssert(isFilteredDataCorrect, @"Filtered data is %@ but should be empty",[_searchResultDelegateForTesting searchResults]);
}

-(void)testFilterContentForNilDataToFilterShouldBeEmpty
{
    [self nullifyIvarWithName:@"dataToFilter" ofObject:_veeTableViewSearchDelegate];
    [_veeTableViewSearchDelegate filterContentForSearchText:@"doesn't matter" scope:nil];
    BOOL isFilteredDataCorrect = [[_searchResultDelegateForTesting searchResults] isEqual:@[]];
    NSAssert(isFilteredDataCorrect, @"Filtered data is %@ but should be empty",[_searchResultDelegateForTesting searchResults]);
}


#pragma mark - Private utils

-(void)loadVeeTableViewSearchDelegateWithMocks
{
    _searchDisplayControllerMock = OCMClassMock([UISearchDisplayController class]);
    VeeSectionableForTesting* veeSectionableFoo = [[VeeSectionableForTesting alloc] initWithSectionIdentifier:@"foo"];
    VeeSectionableForTesting* veeSectionableBar = [[VeeSectionableForTesting alloc] initWithSectionIdentifier:@"bar"];
    VeeSectionableForTesting* veeSectionableCar = [[VeeSectionableForTesting alloc] initWithSectionIdentifier:@"car"];

    _dataToFiler = @[veeSectionableFoo,veeSectionableBar,veeSectionableCar];
    _filteredDataForF = @[veeSectionableFoo];
    _filteredDataForB = @[veeSectionableBar];
    _filteredDataForAr = @[veeSectionableBar,veeSectionableCar];
    
    _searchTableViewMock = OCMClassMock([UITableView class]);
    NSPredicate* predicateToFilterData = [NSPredicate predicateWithFormat:@"sectionIdentifier contains[c] $searchString"];
    _searchResultDelegateForTesting = [[VeeSearchResultsDelegateForTesting alloc] initWithSearchResults:nil];
    _veeTableViewSearchDelegate =[[VeeTableViewSearchDelegate alloc] initWithSearchDisplayController:_searchDisplayControllerMock dataToFiler:_dataToFiler withPredicate:predicateToFilterData andSearchResultsDelegate:_searchResultDelegateForTesting];
}

@end
