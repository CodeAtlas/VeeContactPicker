#import <Foundation/Foundation.h>

@protocol VeePostalAddressProt <NSObject>

- (NSString*)street;
- (NSString*)city;
- (NSString*)state;
- (NSString*)postal;
- (NSString*)country;
- (NSString*)unifiedAddress;

@end
