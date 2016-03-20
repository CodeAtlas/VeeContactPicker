//
//  Created by Andrea Cipriani on 18/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VeeSectionedArrayDataSource.h"
#import "OCMock.h"
#import "VeeSectionable.h"
#import "VeeSectionableForTesting.h"

@interface VeeSectionedArrayDataSourceTests : XCTestCase

@property (nonatomic,strong) VeeSectionedArrayDataSource* veeSectionedArrayDataSource;
@end

static NSArray<id<VeeSectionable>>* randomVeesectionableObjects;

@implementation VeeSectionedArrayDataSourceTests

#pragma mark - Class setup

+(void)setUp
{
    randomVeesectionableObjects = [self randomVeeSectionableObjects:100];
}

#pragma mark -

- (void)setUp
{
    [super setUp];
    _veeSectionedArrayDataSource = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:randomVeesectionableObjects];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Init

-(void)testInitShouldSetIVars
{
    BOOL areItemsNotNil = [_veeSectionedArrayDataSource valueForKey:@"sectionedItems"];
    BOOL areSectionIdentifiersNotNil = [_veeSectionedArrayDataSource valueForKey:@"allowedSectionIdentifiers"];
    BOOL isCellIdentifierNotNil = [_veeSectionedArrayDataSource valueForKey:@"cellIdentifier"];
    BOOL isSectionIdentifierWildcardNotNil = [_veeSectionedArrayDataSource valueForKey:@"sectionIdentifierWildcard"];
    BOOL isConfigureCellBlockNotNil = [_veeSectionedArrayDataSource valueForKey:@"configureCellBlock"];

    NSAssert(areItemsNotNil,@"Sectioned items shouldn't be nil");
    NSAssert(areSectionIdentifiersNotNil,@"Sectioned identifiers shouldn't be nil");
    NSAssert(isCellIdentifierNotNil,@"cellIdentifier shouldn't be nil");
    NSAssert(isSectionIdentifierWildcardNotNil,@"sectionIdentifierWildcard shouldn't be nil");
    NSAssert(isConfigureCellBlockNotNil,@"configureCellBlock shouldn't be nil");
}

#pragma mark - UITableViewDataSource Tests

- (void)testNumberOfSectionsInTableView
{
    NSMutableSet* sectionIdentifiers = [NSMutableSet new];
    for (id<VeeSectionable> veeSectionable in randomVeesectionableObjects){
        [sectionIdentifiers addObject:[veeSectionable sectionIdentifier]];
    }
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger numberOfSections = [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView];
    BOOL isNumberOfSectionCorrect = [sectionIdentifiers count] == numberOfSections;
    NSAssert(isNumberOfSectionCorrect, @"number of sections is %zd but should be %zd",numberOfSections,[sectionIdentifiers count]);
}

- (void)testNumberOfSectionsInTableViewForOneContact
{
    VeeSectionedArrayDataSource * veeSectionedArrayDataSourceWithOneObject = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:[VeeSectionedArrayDataSourceTests randomVeeSectionableObjects:1]];

    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger numberOfSections = [veeSectionedArrayDataSourceWithOneObject numberOfSectionsInTableView:mockedTableView];
    BOOL isNumberOfSectionCorrect = 1 == numberOfSections;
    NSAssert(isNumberOfSectionCorrect, @"number of sections is %zd but should be 1",numberOfSections);
}

-(void)testTotalNumberOfRowsInAllSections
{
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger totalNumberOfRows = 0;
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView]; section++){
        NSUInteger numberOfRowsInSection = [_veeSectionedArrayDataSource tableView:mockedTableView numberOfRowsInSection:section];
        totalNumberOfRows += numberOfRowsInSection;
    }
    
    BOOL isTotalNumberOfRowsCorrect = totalNumberOfRows == [randomVeesectionableObjects count];
    NSAssert(isTotalNumberOfRowsCorrect, @"Total number of rows is %zd but should be %zd",[randomVeesectionableObjects count],totalNumberOfRows);
}

-(void)testNumberOfRowsInSectionsWithRandomObjs
{
    NSDictionary* sectionedObjs = [self sectionedObjects:randomVeesectionableObjects];

    id mockedTableView = OCMClassMock([UITableView class]);
    for (int section = 0; section < [_veeSectionedArrayDataSource numberOfSectionsInTableView:mockedTableView]; section++){
        NSUInteger numberOfRowsInSection = [_veeSectionedArrayDataSource tableView:mockedTableView numberOfRowsInSection:section];
        NSString* sectionIdentifier = [[sectionedObjs allKeys] objectAtIndex:section];
        NSUInteger numberOfObjsForThisSection = [[sectionedObjs objectForKey:sectionIdentifier] count];
        BOOL isNumberOfRowsCorrect = numberOfRowsInSection == numberOfObjsForThisSection;
        NSAssert(isNumberOfRowsCorrect, @"Number of rows for section %zd is %zd but should be %zd",section,numberOfRowsInSection,numberOfObjsForThisSection);
    }
}
-(void)testNumberOfRowsInSectionWithOneObjectShouldBeOne
{
    VeeSectionedArrayDataSource * veeSectionedArrayDataSourceWithOneObject = [VeeSectionedArrayDataSourceTests veeSectionedArrayDataSourceWithVeeSectionables:[VeeSectionedArrayDataSourceTests randomVeeSectionableObjects:1]];
    id mockedTableView = OCMClassMock([UITableView class]);
    NSUInteger numberOfRows = [veeSectionedArrayDataSourceWithOneObject tableView:mockedTableView numberOfRowsInSection:0];
    BOOL isNumberOfRowCorrect = 1 == numberOfRows;
    NSAssert(isNumberOfRowCorrect, @"Section 0 should have une row but it has %zd",numberOfRows);
}

/*
 UITableViewCell *cell = [UITableViewCell new];
 NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
 OCMStub([mockedTableView dequeueReusableCellWithIdentifier:@"FakeCellIdentifier" forIndexPath:indexPath]).andReturn(cell);
 */

#pragma mark - Public methods

#pragma mark - Private utils

+(NSArray<id<VeeSectionable>>*)randomVeeSectionableObjects:(NSUInteger)numberOfObjects
{
    NSArray* allowedSectionIdentifiers = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    NSMutableArray* veeSectionableObjectsMutable = [NSMutableArray new];
    for (int i = 0; i < numberOfObjects; i++){
        VeeSectionableForTesting *veeSectionableObj = [VeeSectionableForTesting new];
        [veeSectionableObj setSectionIdentifier:[allowedSectionIdentifiers objectAtIndex:arc4random() % [allowedSectionIdentifiers count]]];
        [veeSectionableObjectsMutable addObject:veeSectionableObj];
    }
    return [NSArray arrayWithArray:veeSectionableObjectsMutable];
}

+(VeeSectionedArrayDataSource*)veeSectionedArrayDataSourceWithVeeSectionables:(NSArray<id<VeeSectionable>>*)veeSectionable
{
    VeeSectionedArrayDataSource* veeSectionedArrayDataSource = [[VeeSectionedArrayDataSource alloc] initWithItems:veeSectionable cellIdentifier:@"FakeCellIdentifier" allowedSectionIdentifiers:    [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] sectionIdentifierWildcard:@"#" configurationCellBlock:^(UITableViewCell* cell, id item) {
        cell.textLabel.text = [item displayName];
    }];
    return veeSectionedArrayDataSource;
}

-(NSDictionary*)sectionedObjects:(NSArray<id<VeeSectionable>>*)veeSectionableObjs
{
    NSMutableDictionary* objsForSectionIdentifiers = [NSMutableDictionary new];
    for (id<VeeSectionable> veeSectionable in veeSectionableObjs){
        NSMutableArray* objsForThisSection = [objsForSectionIdentifiers objectForKey:[veeSectionable sectionIdentifier]];
        if (objsForThisSection == nil){
            [objsForSectionIdentifiers setObject:[[NSMutableArray alloc] initWithObjects:veeSectionable, nil] forKey:[veeSectionable sectionIdentifier]];
        }
        else{
            [objsForSectionIdentifiers setObject:[objsForThisSection arrayByAddingObject:veeSectionable] forKey:[veeSectionable sectionIdentifier]];
        }
    }
    return [NSDictionary dictionaryWithDictionary:objsForSectionIdentifiers];
}

@end
