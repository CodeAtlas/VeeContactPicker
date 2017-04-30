@import Foundation;

@protocol VeeABDelegate <NSObject>
- (void)abPermissionsGranted;
- (void)abPermissionsNotGranted;
@end
