//
//  Created by Andrea Cipriani on 18/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "OCMock.h"
#import "VeeSectionable.h"
#import "VeeSectionableForTesting.h"
#import "VeeSectionedArrayDataSource.h"
#import <XCTest/XCTest.h>

#define TEST_CELL_IDENTIFIER @"FakeCellIdentifier"
#define RANDOM_OBJECTS_COUNT 100
#define SEARCH_RESULTS_RANDOM_OBJECTS_COUNT 5

@interface VeeSectionedArrayDataSourceTests : XCTestCase

@property (nonatomic, strong) VeeSectionedArrayDataSource* veeSectionedArrayDataSource;
@property (nonatomic, strong) NSDictionary* sectionedRandomObjects;
@property (nonatomic, strong) NSArray* nonEmptyRandomObjectsSectionIdentifiers;

@property (nonatomic, strong) NSIndexPath* indexPathForTestCell;
@property (nonatomic, strong) UITableViewCell* testCell;
@property (nonatomic, strong) id mockedTableViewWithTestCellIdentifier;

@end

static NSArray<id<VeeSectionableProt> >* randomVeesectionableObjects;
static NSArray<NSString*>* allowedSectionIdentifiers;

@implementation VeeSectionedArrayDataSourceTests

#pragma mark - Class setup

+ (void)setUp
{
    allowedSectionIdentifiers = [UILocalizedIndexedCollation currentCollation].sectionIndexTitles;
    randomVeesectionableObjects = [self randomVeeSectionableObjects:RANDOM_OBJECTS_COUNT];
}

#pragma mark -

- (void)setUp
{
    [super setUp];
    _veeSectionedArrayDataSource = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:randomVeesectionableObjects andConfigurationCellBlock:nil];
    _sectionedRandomObjects = [self sectionedObjects:randomVeesectionableObjects];
    _nonEmptyRandomObjectsSectionIdentifiers = [self nonEmptySortedSectionIdentifiers:_sectionedRandomObjects];
    _indexPathForTestCell = [NSIndexPath indexPathForRow:0 inSection:0];
    _mockedTableViewWithTestCellIdentifier = self.mockedTableViewWithTestCellIdentifier;
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init

- (void)testInitShouldSetIVars
{
    BOOL areItemsNotNil = [_veeSectionedArrayDataSource valueForKey:@"sectionedItems"] != nil;
    BOOL areSectionIdentifiersNotNil = [_veeSectionedArrayDataSource valueForKey:@"allowedSortedSectionIdentifiers"] != nil;
    BOOL isCellIdentifierNotNil = [_veeSectionedArrayDataSource valueForKey:@"cellIdentifier"] != nil;
    BOOL isSectionIdentifierWildcardNotNil = [_veeSectionedArrayDataSource valueForKey:@"sectionIdentifierWildcard"] != nil;
    BOOL isConfigureCellBlockNotNil = [_veeSectionedArrayDataSource valueForKey:@"configureCellBlock"] != nil;

    NSAssert(areItemsNotNil, @"Sectioned items shouldn't be nil");
    NSAssert(areSectionIdentifiersNotNil, @"Sectioned identifiers shouldn't be nil");
    NSAssert(isCellIdentifierNotNil, @"cellIdentifier shouldn't be nil");
    NSAssert(isSectionIdentifierWildcardNotNil, @"sectionIdentifierWildcard shouldn't be nil");
    NSAssert(isConfigureCellBlockNotNil, @"configureCellBlock shouldn't be nil");
}

#pragma mark - UITableViewDataSource Tests

- (void)testNumberOfSectionsInTableView
{
    NSMutableSet* sectionIdentifiers = [NSMutableSet new];
    for (id<VeeSectionableProt> veeSectionable in randomVeesectionableObjects) {
        [sectionIdentifiers addObject:[veeSectionable sectionIdentifier]];
    }
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger numberOfSections = [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView];
    BOOL isNumberOfSectionCorrect = sectionIdentifiers.count == numberOfSections;
    NSAssert(isNumberOfSectionCorrect, @"number of sections is %zd but should be %zd", numberOfSections, [sectionIdentifiers count]);
}

- (void)testNumberOfSectionsInTableViewForOneContact
{
    VeeSectionedArrayDataSource* veeSectionedArrayDataSourceWithOneObject = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:[VeeSectionedArrayDataSourceTests randomVeeSectionableObjects:1] andConfigurationCellBlock:nil];

    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger numberOfSections = [veeSectionedArrayDataSourceWithOneObject numberOfSectionsInTableView:mockedTableView];
    BOOL isNumberOfSectionCorrect = 1 == numberOfSections;
    NSAssert(isNumberOfSectionCorrect, @"number of sections is %zd but should be 1", numberOfSections);
}

- (void)testTotalNumberOfRowsInAllSections
{
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger totalNumberOfRows = 0;
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView]; section++) {
        NSUInteger numberOfRowsInSection = [_veeSectionedArrayDataSource tableView:mockedTableView numberOfRowsInSection:section];
        totalNumberOfRows += numberOfRowsInSection;
    }

    BOOL isTotalNumberOfRowsCorrect = totalNumberOfRows == randomVeesectionableObjects.count;
    NSAssert(isTotalNumberOfRowsCorrect, @"Total number of rows is %zd but should be %zd", [randomVeesectionableObjects count], totalNumberOfRows);
}

- (void)testNumberOfRowsInSectionsWithRandomObjs
{
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:_mockedTableViewWithTestCellIdentifier]; section++) {
        NSUInteger numberOfRowsInSection = [_veeSectionedArrayDataSource tableView:_mockedTableViewWithTestCellIdentifier numberOfRowsInSection:section];
        NSString* sectionIdenfierOfSection = _nonEmptyRandomObjectsSectionIdentifiers[section];
        NSUInteger numberOfObjsForThisSection = [_sectionedRandomObjects[sectionIdenfierOfSection] count];
        BOOL isNumberOfRowsCorrect = numberOfRowsInSection == numberOfObjsForThisSection;
        NSAssert(isNumberOfRowsCorrect, @"Number of rows for section %zd is %zd but should be %zd", section, numberOfRowsInSection, numberOfObjsForThisSection);
    }
}

- (void)testNumberOfRowsInSectionWithOneObjectShouldBeOne
{
    VeeSectionedArrayDataSource* veeSectionedArrayDataSourceWithOneObject = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:[VeeSectionedArrayDataSourceTests randomVeeSectionableObjects:1] andConfigurationCellBlock:nil];
    NSUInteger numberOfRows = [veeSectionedArrayDataSourceWithOneObject tableView:_mockedTableViewWithTestCellIdentifier numberOfRowsInSection:0];
    BOOL isNumberOfRowCorrect = 1 == numberOfRows;
    NSAssert(isNumberOfRowCorrect, @"Section 0 should have une row but it has %zd", numberOfRows);
}

-(void)testTitleForHeaderInSections
{
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:_mockedTableViewWithTestCellIdentifier]; section++) {
        NSString* sectionIdenfierOfSection = _nonEmptyRandomObjectsSectionIdentifiers[section];
        NSString* titleForHeaderInSection = [_veeSectionedArrayDataSource tableView:_mockedTableViewWithTestCellIdentifier titleForHeaderInSection:section];
        BOOL isTitleForSectionCorrect = [titleForHeaderInSection isEqualToString:sectionIdenfierOfSection];
        NSAssert(isTitleForSectionCorrect, @"Title for header in section %zd is %@ but should be %@", section, titleForHeaderInSection, sectionIdenfierOfSection);
    }
}

-(void)testSectionIndexTitlesCount
{
    NSUInteger sectionIndexTitlesCount = [_veeSectionedArrayDataSource sectionIndexTitlesForTableView:_mockedTableViewWithTestCellIdentifier].count;
    BOOL isSectionIndexTitlesCountCorrect = sectionIndexTitlesCount == allowedSectionIdentifiers.count;
    NSAssert(isSectionIndexTitlesCountCorrect, @"Section index titles are %zd but they should be %zd",sectionIndexTitlesCount,[allowedSectionIdentifiers count]);
}

-(void)testCellReuseIdentifier
{
    UITableViewCell *cellAtIndexPath = [_veeSectionedArrayDataSource tableView:_mockedTableViewWithTestCellIdentifier cellForRowAtIndexPath:_indexPathForTestCell];
    BOOL shouldReturnMockCell = [cellAtIndexPath isEqual:_testCell];
    NSAssert(shouldReturnMockCell, @"Returned cell is not the mocked one");
}

-(void)testCellConfigurationBlock
{
    __block UITableViewCell *configuredCell;
    NSString* customText = @"foo";
    ConfigureCellBlock configureCellBlock = ^(UITableViewCell* cell, id item) {
        configuredCell = cell;
        cell.textLabel.text = customText;
    };
    
    VeeSectionedArrayDataSource * veeSectionedArrayDataSource = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:randomVeesectionableObjects andConfigurationCellBlock:configureCellBlock];
    
    UITableViewCell *cellAtIndexPath = [veeSectionedArrayDataSource tableView:_mockedTableViewWithTestCellIdentifier cellForRowAtIndexPath:_indexPathForTestCell];
    NSAssert([configuredCell isEqual:_testCell], @"Configured block hasn't passed the cell arg properly");
    BOOL configureBlockHasWorked = [cellAtIndexPath.textLabel.text isEqualToString:customText];
    NSAssert(configureBlockHasWorked, @"Configured block has had no effect");
}

#pragma mark - Public methods

-(void)testItemAtIndexPath
{
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:_mockedTableViewWithTestCellIdentifier]; section++) {
        for (int row = 0; row < [_veeSectionedArrayDataSource tableView:_mockedTableViewWithTestCellIdentifier numberOfRowsInSection:section]; row++){
            id itemAtIndexPath = [_veeSectionedArrayDataSource tableView:_mockedTableViewWithTestCellIdentifier itemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            NSString* sectionIdenfierOfSection = _nonEmptyRandomObjectsSectionIdentifiers[section];
            NSMutableArray* objsForSection = _sectionedRandomObjects[sectionIdenfierOfSection];
            id obj = objsForSection[row];
            BOOL isItemCorrect = [itemAtIndexPath isEqual:obj];
            NSAssert(isItemCorrect, @"Item at section %zd row %zd is %@ but should be %@",section,row,itemAtIndexPath,obj);
        }
    }
}

-(void)testSectionIdentifierForItemNilShouldBeWildcard
{
    NSString* sectionIdentifierForNil = [_veeSectionedArrayDataSource sectionIdentifierForItem:nil];
    BOOL isWildcard = [sectionIdentifierForNil isEqualToString:[_veeSectionedArrayDataSource valueForKey:@"sectionIdentifierWildcard"]];
    NSAssert(isWildcard, @"Section identifier for nil item should be wildcard but is %@",sectionIdentifierForNil);
}

-(void)testSectionIdentifierNotAllowedShouldBeWildcard
{
    VeeSectionableForTesting * veeSectionable = [VeeSectionableForTesting new];
    NSString* notAllowedSectionIdentifier = @"ò";
    NSAssert([[_veeSectionedArrayDataSource valueForKey:@"allowedSortedSectionIdentifiers"] containsObject:notAllowedSectionIdentifier] == NO,@"%@ is allowed",notAllowedSectionIdentifier);
    veeSectionable.sectionIdentifier = notAllowedSectionIdentifier;
    NSString* sectionIdentifierNotAllowed = [_veeSectionedArrayDataSource sectionIdentifierForItem:veeSectionable];
    BOOL isWildcard = [sectionIdentifierNotAllowed isEqualToString:[_veeSectionedArrayDataSource valueForKey:@"sectionIdentifierWildcard"]];
    NSAssert(isWildcard, @"Section identifier for not allowed item should be wildcard but is %@",sectionIdentifierNotAllowed);
}

-(void)testSectionIdentifier
{
    VeeSectionableForTesting * veeSectionable = [VeeSectionableForTesting new];
    NSArray* allowedSectionIdentifiers = [_veeSectionedArrayDataSource valueForKey:@"allowedSortedSectionIdentifiers"];
    for (int numberOfTests = 0; numberOfTests < 10; numberOfTests++){
        NSString* randomSectionIdentifier = allowedSectionIdentifiers[(arc4random() % allowedSectionIdentifiers.count)];
        veeSectionable.sectionIdentifier = randomSectionIdentifier;
        NSString* sectionIdentifierForItem = [_veeSectionedArrayDataSource sectionIdentifierForItem:veeSectionable];
        BOOL isSectionIdentifierCorrect = [sectionIdentifierForItem isEqualToString:randomSectionIdentifier];
        NSAssert(isSectionIdentifierCorrect,@"Section identifier for %@ is %@ but should be %@",veeSectionable,sectionIdentifierForItem,randomSectionIdentifier);
    }
}

#pragma mark - Search table view

-(void)testShouldNotUseSearchTableViewIfSearchResultIsNil
{
    [_veeSectionedArrayDataSource setSearchResults:nil forSearchTableView:nil];
    BOOL isNotUsingSearchTableView = [_veeSectionedArrayDataSource numberOfSectionsInTableView:_mockedTableViewWithTestCellIdentifier] > 0;
    NSAssert(isNotUsingSearchTableView, @"When search results are nil, should not use search table view");
}

-(void)testSearchTableViewRowsCount
{
    UITableView* searchTableViewMock = self.mockedTableViewWithTestCellIdentifier;
    
    [_veeSectionedArrayDataSource setSearchResults:[VeeSectionedArrayDataSourceTests randomVeeSectionableObjects:SEARCH_RESULTS_RANDOM_OBJECTS_COUNT] forSearchTableView:searchTableViewMock];
    
    NSUInteger totalNumberOfRows = 0;
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:searchTableViewMock]; section++) {
        NSUInteger numberOfRowsInSection = [_veeSectionedArrayDataSource tableView:searchTableViewMock numberOfRowsInSection:section];
        totalNumberOfRows += numberOfRowsInSection;
    }
    
    BOOL isNumberOfRowsCorrect = SEARCH_RESULTS_RANDOM_OBJECTS_COUNT == totalNumberOfRows;
    NSAssert(isNumberOfRowsCorrect, @"Number of rows in search table view is %zd but should be %zd", totalNumberOfRows, SEARCH_RESULTS_RANDOM_OBJECTS_COUNT);
}

#pragma mark - Private utils

+ (NSArray<id<VeeSectionableProt> >*)randomVeeSectionableObjects:(NSUInteger)numberOfObjects
{
    NSMutableArray* veeSectionableObjectsMutable = [NSMutableArray new];
    for (int i = 0; i < numberOfObjects; i++) {
        VeeSectionableForTesting* veeSectionableObj = [VeeSectionableForTesting new];
        veeSectionableObj.sectionIdentifier = allowedSectionIdentifiers[arc4random() % allowedSectionIdentifiers.count];
        [veeSectionableObjectsMutable addObject:veeSectionableObj];
    }
    return [NSArray arrayWithArray:veeSectionableObjectsMutable];
}

- (NSDictionary*)sectionedObjects:(NSArray<id<VeeSectionableProt> >*)veeSectionableObjs
{
    NSMutableDictionary* objsForSectionIdentifiers = [NSMutableDictionary new];
    for (NSString* sectionIdentifer in allowedSectionIdentifiers) {
        objsForSectionIdentifiers[sectionIdentifer] = [NSMutableArray new];
    }
    for (id<VeeSectionableProt> veeSectionable in veeSectionableObjs) {
        NSMutableArray* objsForThisSection = objsForSectionIdentifiers[[veeSectionable sectionIdentifier]];
        [objsForThisSection addObject:veeSectionable];
        objsForSectionIdentifiers[[veeSectionable sectionIdentifier]] = objsForThisSection;
    }
    return [NSDictionary dictionaryWithDictionary:objsForSectionIdentifiers];
}

- (NSArray*)nonEmptySortedSectionIdentifiers:(NSDictionary*)sectionedObjs
{
    NSMutableArray* nonEmptySortedSectionIdentifiersMutable = [NSMutableArray new];
    for (NSString* sectionIdentifier in allowedSectionIdentifiers) {
        if ([sectionedObjs[sectionIdentifier] count] > 0) {
            [nonEmptySortedSectionIdentifiersMutable addObject:sectionIdentifier];
        }
    }
    return [NSArray arrayWithArray:nonEmptySortedSectionIdentifiersMutable];
}

+ (VeeSectionedArrayDataSource*)veeSectionedArrayDataSourceWithVeeSectionables:(NSArray<id<VeeSectionableProt> >*)veeSectionable andConfigurationCellBlock:(ConfigureCellBlock)configurationCellBlock
{
    if (configurationCellBlock == nil){
        configurationCellBlock = ^(UITableViewCell* cell, id item) {
        };
    }
    VeeSectionedArrayDataSource* veeSectionedArrayDataSource = [[VeeSectionedArrayDataSource alloc] initWithItems:veeSectionable cellIdentifier:TEST_CELL_IDENTIFIER allowedSortedSectionIdentifiers:[UILocalizedIndexedCollation currentCollation].sectionIndexTitles sectionIdentifierWildcard:@"#" configurationCellBlock:configurationCellBlock];
    return veeSectionedArrayDataSource;
}

-(id)mockedTableViewWithTestCellIdentifier
{
    id mockedTableView = OCMClassMock([UITableView class]);
    _testCell = [UITableViewCell new];
    OCMStub([mockedTableView dequeueReusableCellWithIdentifier:TEST_CELL_IDENTIFIER forIndexPath:_indexPathForTestCell]).andReturn(_testCell);
    return mockedTableView;
}

@end
