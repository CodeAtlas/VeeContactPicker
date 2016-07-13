//
//  Created by Andrea Cipriani on 11/05/16.
//

#import "AGCDescription.h"
#import "AGCPropertiesExtractor.h"
#import "AGCProperty.h"
#import "AGCPropertyConstants.h"
#import "AGCPropertyDescription.h"

@interface AGCDescription ()

@property (nonatomic, strong) NSArray* propertyNamesToIgnore;
@property (nonatomic, strong) id targetObject;
@property (nonatomic, strong) NSString* targetObjectClassName;
@property (nonatomic, strong) NSString* targetObjectAddress;
@property (nonatomic, assign) BOOL isEmptyClass;
@property (nonatomic, strong) NSArray<AGCProperty*>* sortedProperties;
@property (nonatomic, strong) NSString* sortedPropertiesDescriptions;

@end

@implementation AGCDescription

- (instancetype)initWithTargetObject:(id)targetObject
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _targetObject = targetObject;
    _propertyNamesToIgnore = [[AGCPropertyConstants sharedInstance] defaultIgnoredPropertyNames];

    [self sharedInitializer];
    return self;
}

- (instancetype)initWithTargetObject:(id)targetObject andPropertyNamesToIgnore:(NSArray*)propertyNamesToIgnore
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _targetObject = targetObject;
    _propertyNamesToIgnore = propertyNamesToIgnore;
    [self sharedInitializer];
    return self;
}

- (void)sharedInitializer
{
    _targetObjectClassName = NSStringFromClass([_targetObject class]);
    _targetObjectAddress = [NSString stringWithFormat:@"%p", _targetObject];
    [self extractAndFilterProperties];
    [self loadAllPropertiesDescription];
}

#pragma mark - Private

- (void)extractAndFilterProperties
{
    AGCPropertiesExtractor* propertyExtractor = [[AGCPropertiesExtractor alloc] initWithTargetObject:_targetObject]; //TODO: dependecy injection

    NSArray<AGCProperty*>* sortedPropertyNames = [propertyExtractor extractSortedProperties];
    if ([sortedPropertyNames count] == 0) {
        _isEmptyClass = YES;
        return;
    }

    NSMutableArray<AGCProperty*>* filteredProperties = [NSMutableArray new];
    [sortedPropertyNames enumerateObjectsUsingBlock:^(AGCProperty * _Nonnull agcProperty, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self shouldSkipProperty:agcProperty] == NO) {
            [filteredProperties addObject:agcProperty];
        }
    }];

    _sortedProperties = [filteredProperties copy];
}

- (void)loadAllPropertiesDescription
{
    NSMutableString* agcDescriptionMutable = [[NSMutableString alloc] initWithString:@"{\n"];
    for (AGCProperty* property in _sortedProperties) {
        AGCPropertyDescription* propertyDescription = [[AGCPropertyDescription alloc] initWithProperty:property];
        [agcDescriptionMutable appendString:[NSString stringWithFormat:@"\t%@ = %@;\n", property.propertyName, [propertyDescription agcDescription]]];
    }
    [agcDescriptionMutable appendString:@"}"];
    _sortedPropertiesDescriptions = [agcDescriptionMutable copy];
}

- (BOOL)shouldSkipProperty:(AGCProperty*)agcProperty
{
    BOOL isPropertyToIgnore = [_propertyNamesToIgnore containsObject:agcProperty.propertyName];
    BOOL isPropertyObjectOrPrimitive = [agcProperty isObject] || [agcProperty isPrimitive];
    BOOL shouldSkipProperty = isPropertyObjectOrPrimitive == NO || agcProperty.propertyName == nil || isPropertyToIgnore;
    return shouldSkipProperty;
}

#pragma mark - NSObject

- (NSString*)description
{
    if (_isEmptyClass) {
        return [NSString stringWithFormat:@"<%@>", self.targetObjectClassName];
    }
    return [NSString stringWithFormat:@"<%@:\n%@>", self.targetObjectClassName, self.sortedPropertiesDescriptions];
}

- (NSString*)debugDescription
{
    if (_isEmptyClass) {
        return [NSString stringWithFormat:@"<%@, %@>", self.targetObjectClassName, self.targetObjectAddress];
    }
    return [NSString stringWithFormat:@"<%@, %@:\n%@>", self.targetObjectClassName, _targetObjectAddress, self.sortedPropertiesDescriptions];
}

@end
