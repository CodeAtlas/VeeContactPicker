@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol VeePostalAddressProt <NSObject>

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull street;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull city;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull state;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull postal;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull country;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull unifiedAddress;

@end

NS_ASSUME_NONNULL_END
