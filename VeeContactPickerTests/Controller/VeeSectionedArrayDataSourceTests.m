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

@interface VeeSectionedArrayDataSourceTests : XCTestCase

@property (nonatomic, strong) VeeSectionedArrayDataSource* veeSectionedArrayDataSource;
@property (nonatomic, strong) NSDictionary* sectionedRandomObjects;
@property (nonatomic, strong) NSArray* nonEmptyRandomObjectsSectionIdentifiers;

@end

static NSArray<id<VeeSectionable> >* randomVeesectionableObjects;
static NSArray<NSString*>* allowedSectionIdentifiers;

@implementation VeeSectionedArrayDataSourceTests

#pragma mark - Class setup

+ (void)setUp
{
    allowedSectionIdentifiers = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    randomVeesectionableObjects = [self randomVeeSectionableObjects:100];
}

#pragma mark -

- (void)setUp
{
    [super setUp];
    _veeSectionedArrayDataSource = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:randomVeesectionableObjects andConfigurationCellBlock:nil];
    _sectionedRandomObjects = [self sectionedObjects:randomVeesectionableObjects];
    _nonEmptyRandomObjectsSectionIdentifiers = [self nonEmptySortedSectionIdentifiers:_sectionedRandomObjects];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init

- (void)testInitShouldSetIVars
{
    BOOL areItemsNotNil = [_veeSectionedArrayDataSource valueForKey:@"sectionedItems"];
    BOOL areSectionIdentifiersNotNil = [_veeSectionedArrayDataSource valueForKey:@"allowedSortedSectionIdentifiers"];
    BOOL isCellIdentifierNotNil = [_veeSectionedArrayDataSource valueForKey:@"cellIdentifier"];
    BOOL isSectionIdentifierWildcardNotNil = [_veeSectionedArrayDataSource valueForKey:@"sectionIdentifierWildcard"];
    BOOL isConfigureCellBlockNotNil = [_veeSectionedArrayDataSource valueForKey:@"configureCellBlock"];

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
    for (id<VeeSectionable> veeSectionable in randomVeesectionableObjects) {
        [sectionIdentifiers addObject:[veeSectionable sectionIdentifier]];
    }
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger numberOfSections = [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView];
    BOOL isNumberOfSectionCorrect = [sectionIdentifiers count] == numberOfSections;
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

    BOOL isTotalNumberOfRowsCorrect = totalNumberOfRows == [randomVeesectionableObjects count];
    NSAssert(isTotalNumberOfRowsCorrect, @"Total number of rows is %zd but should be %zd", [randomVeesectionableObjects count], totalNumberOfRows);
}

- (void)testNumberOfRowsInSectionsWithRandomObjs
{
    id mockedTableView = OCMClassMock([UITableView class]);
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView]; section++) {

        NSUInteger numberOfRowsInSection = [_veeSectionedArrayDataSource tableView:mockedTableView numberOfRowsInSection:section];
        NSString* sectionIdenfierOfSection = [_nonEmptyRandomObjectsSectionIdentifiers objectAtIndex:section];
        NSUInteger numberOfObjsForThisSection = [[_sectionedRandomObjects objectForKey:sectionIdenfierOfSection] count];
        BOOL isNumberOfRowsCorrect = numberOfRowsInSection == numberOfObjsForThisSection;
        NSAssert(isNumberOfRowsCorrect, @"Number of rows for section %zd is %zd but should be %zd", section, numberOfRowsInSection, numberOfObjsForThisSection);
    }
}

- (void)testNumberOfRowsInSectionWithOneObjectShouldBeOne
{
    VeeSectionedArrayDataSource* veeSectionedArrayDataSourceWithOneObject = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:[VeeSectionedArrayDataSourceTests randomVeeSectionableObjects:1] andConfigurationCellBlock:nil];
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger numberOfRows = [veeSectionedArrayDataSourceWithOneObject tableView:mockedTableView numberOfRowsInSection:0];
    BOOL isNumberOfRowCorrect = 1 == numberOfRows;
    NSAssert(isNumberOfRowCorrect, @"Section 0 should have une row but it has %zd", numberOfRows);
}

-(void)testTitleForHeaderInSections
{
    id mockedTableView = OCMClassMock([UITableView class]);
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView]; section++) {
        NSString* sectionIdenfierOfSection = [_nonEmptyRandomObjectsSectionIdentifiers objectAtIndex:section];
        NSString* titleForHeaderInSection = [_veeSectionedArrayDataSource tableView:mockedTableView titleForHeaderInSection:section];
        BOOL isTitleForSectionCorrect = [titleForHeaderInSection isEqualToString:sectionIdenfierOfSection];
        NSAssert(isTitleForSectionCorrect, @"Title for header in section %zd is %@ but should be %@", section, titleForHeaderInSection, sectionIdenfierOfSection);
    }
}

-(void)testSectionIndexTitlesCount
{
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger sectionIndexTitlesCount = [[_veeSectionedArrayDataSource sectionIndexTitlesForTableView:mockedTableView] count];
    BOOL isSectionIndexTitlesCountCorrect = sectionIndexTitlesCount == [allowedSectionIdentifiers count];
    NSAssert(isSectionIndexTitlesCountCorrect, @"Section index titles are %zd but they should be %zd",sectionIndexTitlesCount,[allowedSectionIdentifiers count]);
}

-(void)testCellReuseIdentifier
{
    id mockedTableView = OCMClassMock([UITableView class]);
    UITableViewCell *mockCell = [UITableViewCell new];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    OCMStub([mockedTableView dequeueReusableCellWithIdentifier:TEST_CELL_IDENTIFIER forIndexPath:indexPath]).andReturn(mockCell);
    UITableViewCell *cellAtIndexPath = [_veeSectionedArrayDataSource tableView:mockedTableView cellForRowAtIndexPath:indexPath];
    BOOL shouldReturnMockCell = [cellAtIndexPath isEqual:mockCell];
    NSAssert(shouldReturnMockCell, @"Returned cell is not the mocked one");
}

-(void)testCellConfigurationBlock
{
    ConfigureCellBlock configureCellBlock = ^(UITableViewCell* cell, id item) {
        cell.textLabel.text = @"Foo";
    };
    
    VeeSectionedArrayDataSource * veeSectionedArrayDataSource = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:randomVeesectionableObjects andConfigurationCellBlock:configureCellBlock];
    
    id mockedTableView = OCMClassMock([UITableView class]);
    UITableViewCell *mockCell = [UITableViewCell new];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    OCMStub([mockedTableView dequeueReusableCellWithIdentifier:TEST_CELL_IDENTIFIER forIndexPath:indexPath]).andReturn(mockCell);
    UITableViewCell *cellAtIndexPath = [veeSectionedArrayDataSource tableView:mockedTableView cellForRowAtIndexPath:indexPath];
    BOOL configureBlockHasWorked = [cellAtIndexPath.textLabel.text isEqualToString:@"Foo"];
    NSAssert(configureBlockHasWorked, @"Configured block has had no effect");
}

/*
 id result = [dataSource tableView:mockTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
 STAssertEquals(configuredCell, cell, @"This should have been passed to the block.");
 STAssertEqualObjects(configuredObject, @"a", @"This should have been passed to the block.");
 */

#pragma mark - Public methods

#pragma mark - Private utils

+ (NSArray<id<VeeSectionable> >*)randomVeeSectionableObjects:(NSUInteger)numberOfObjects
{
    NSMutableArray* veeSectionableObjectsMutable = [NSMutableArray new];
    for (int i = 0; i < numberOfObjects; i++) {
        VeeSectionableForTesting* veeSectionableObj = [VeeSectionableForTesting new];
        [veeSectionableObj setSectionIdentifier:[allowedSectionIdentifiers objectAtIndex:arc4random() % [allowedSectionIdentifiers count]]];
        [veeSectionableObjectsMutable addObject:veeSectionableObj];
    }
    return [NSArray arrayWithArray:veeSectionableObjectsMutable];
}

- (NSDictionary*)sectionedObjects:(NSArray<id<VeeSectionable> >*)veeSectionableObjs
{
    NSMutableDictionary* objsForSectionIdentifiers = [NSMutableDictionary new];
    for (NSString* sectionIdentifer in allowedSectionIdentifiers) {
        [objsForSectionIdentifiers setObject:[NSMutableArray new] forKey:sectionIdentifer];
    }
    for (id<VeeSectionable> veeSectionable in veeSectionableObjs) {
        NSMutableArray* objsForThisSection = [objsForSectionIdentifiers objectForKey:[veeSectionable sectionIdentifier]];
        [objsForThisSection addObject:veeSectionable];
        [objsForSectionIdentifiers setObject:objsForThisSection forKey:[veeSectionable sectionIdentifier]];
    }
    return [NSDictionary dictionaryWithDictionary:objsForSectionIdentifiers];
}

- (NSArray*)nonEmptySortedSectionIdentifiers:(NSDictionary*)sectionedObjs
{
    NSMutableArray* nonEmptySortedSectionIdentifiersMutable = [NSMutableArray new];
    for (NSString* sectionIdentifier in allowedSectionIdentifiers) {
        if ([[sectionedObjs objectForKey:sectionIdentifier] count] > 0) {
            [nonEmptySortedSectionIdentifiersMutable addObject:sectionIdentifier];
        }
    }
    return [NSArray arrayWithArray:nonEmptySortedSectionIdentifiersMutable];
}

+ (VeeSectionedArrayDataSource*)veeSectionedArrayDataSourceWithVeeSectionables:(NSArray<id<VeeSectionable> >*)veeSectionable andConfigurationCellBlock:(ConfigureCellBlock)configurationCellBlock
{
    if (configurationCellBlock == nil){
        configurationCellBlock = ^(UITableViewCell* cell, id item) {
        };
    }
    
    VeeSectionedArrayDataSource* veeSectionedArrayDataSource = [[VeeSectionedArrayDataSource alloc] initWithItems:veeSectionable cellIdentifier:TEST_CELL_IDENTIFIER allowedSortedSectionIdentifiers:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] sectionIdentifierWildcard:@"#" configurationCellBlock:configurationCellBlock];
    return veeSectionedArrayDataSource;
}

@end
