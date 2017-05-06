//
//  Created by Andrea Cipriani on 16/03/16.
//  Copyright © 2016 Code Atlas SRL. All rights reserved.
//

#import "VeeContact.h"
#import "VeeContactsForTestingFactory.h"
#import "VeeAddressBookForTestingConstants.h"

@implementation VeeContactsForTestingFactory

#pragma mark - Public method

+ (VeeContact*)veeContactComplete
{
    NSArray* kCompleteVeeContactEmails = @[@"complete@home.it",@"complete@work.org",@"complete@icloud.com",@"duplicate@gmail.com"];
    NSArray* kCompleteVeeContactPhoneNumbers = @[@"+39 02 9387441",@"+1 333 2458774",@"+33 333 2580089",@"+7 331 4458726",@"+39 02 9387441"];
    UIImage* image = [self veeTestImage];
    VeeContact* veeContactComplete = [[VeeContact alloc] initWithFirstName:kCompleteVeeContactFirstName middleName:kCompleteVeeContactMiddleName lastName:kCompleteVeeContactLastName nickName:kCompleteVeeContactNickname organizationName:kCompleteVeeContactOrganizationName compositeName:kCompleteVeeContactCompositeName thubnailImage:image phoneNumbers:kCompleteVeeContactPhoneNumbers emails:kCompleteVeeContactEmails];
    return veeContactComplete;
}

+ (NSArray<id<VeeContactProt>>*)createRandomVeeContacts:(NSUInteger)numberOfVeeContacts
{
    NSMutableArray* randomVeeContactsMutable = [NSMutableArray new];
    for (int i = 0; i < numberOfVeeContacts; i++){
        VeeContact* randomVeeContact;
        NSString* randomFirstName = [self randomFirstName];
        NSString* randomLastName = [self randomLastName];
        NSString* randomMiddleName = [self randomMiddleName];
        NSString* randomCompositeName = [NSString stringWithFormat:@"%@ %@ %@",randomFirstName,randomMiddleName,randomLastName];
        NSArray* randomPhoneNumbers = @[[self randomPhoneNumber],[self randomPhoneNumber],[self randomPhoneNumber]];
        UIImage* thumbnailImage;
        NSUInteger setImageEveryNVeeContacts = 10;
        if (arc4random() % setImageEveryNVeeContacts == 0){
            thumbnailImage = [self veeTestImage];
        }
        NSArray* randomEmails = @[[self randomEmailWithFirstName:randomFirstName andLastName:randomLastName],[self randomEmailWithFirstName:randomFirstName andLastName:randomLastName],[self randomEmailWithFirstName:randomFirstName andLastName:randomLastName]];
        randomVeeContact = [[VeeContact alloc] initWithFirstName:randomFirstName middleName:randomMiddleName lastName:randomLastName nickName:[self randomNickname] organizationName:[self randomOrganizationName] compositeName:randomCompositeName thubnailImage:thumbnailImage phoneNumbers:randomPhoneNumbers emails:randomEmails];
        [randomVeeContactsMutable addObject:randomVeeContact];
    }
    return [[NSArray alloc] initWithArray:randomVeeContactsMutable];
}

+(NSString*)randomFirstName
{
    return [self randomEntryInTxtFileNamed:@"FirstNames"];
}

+(NSString*)randomMiddleName
{
    return [self randomEntryInTxtFileNamed:@"MiddleNames"];
}

+(NSString*)randomLastName
{
    return [self randomEntryInTxtFileNamed:@"LastNames"];
}

+(NSString*)randomEmailWithFirstName:(NSString*)firstName andLastName:(NSString*)lastName
{
    NSString* randomEmailDomain= [self randomEntryInTxtFileNamed:@"EmailDomains"];
    return [NSString stringWithFormat:@"%@.%@@%@",firstName,lastName,randomEmailDomain];
}

+(NSString*)randomPhoneNumber
{
    return [self randomEntryInTxtFileNamed:@"FakePhoneNumbers"];
}

+(NSString*)randomNickname
{
    return [self randomEntryInTxtFileNamed:@"Nicknames"];
}

+(NSString*)randomOrganizationName
{
   return [self randomEntryInTxtFileNamed:@"OrganizationNames"];
}

+(NSString*)randomEntryInTxtFileNamed:(NSString*)fileName
{
    NSArray* randomEntries = [self linesOfTxtFileNamed:fileName];
    return randomEntries[arc4random() % randomEntries.count];
}

+(NSArray<NSString*>*)linesOfTxtFileNamed:(NSString*)fileName
{
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:[self filePathForFileName:fileName withType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    if (error){
        NSLog(@"Error reading file: %@", error.localizedDescription);
    }
    return [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

+(NSString*)filePathForFileName:(NSString*)fileName withType:(NSString*)fileType
{
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:fileName ofType:fileType];
    return filePath;
}

+(UIImage*)veeTestImage
{
    NSString *imageName = @"vee_test_image.png";
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:imageName.stringByDeletingPathExtension ofType:imageName.pathExtension];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    NSAssert(image, @"Can't load vee_test_image.png");
    return image;
}

@end
