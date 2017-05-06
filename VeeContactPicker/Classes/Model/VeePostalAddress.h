@import Foundation;
#import "VeePostalAddressProt.h"

NS_ASSUME_NONNULL_BEGIN

@interface VeePostalAddress : NSObject <VeePostalAddressProt>

- (instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithStreet:(nullable NSString*)street city:(nullable NSString*)city state:(nullable NSString*)state postal:(nullable NSString*)postal country:(nullable NSString*)country;

@property (nonatomic, copy) NSString * street;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * postal;
@property (nonatomic, copy) NSString * country;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull unifiedAddress;

@end

NS_ASSUME_NONNULL_END
