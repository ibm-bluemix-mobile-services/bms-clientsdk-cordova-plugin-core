#import <IMFClient+initializeException.h>

@implementation IMFClient (InitializeException)

-(void) tryInitializeWithBackendRoute: (NSString*)backendRoute backendGUID:(NSString*)backendGUID {
    NSString *result;
    @try {
        [IMFClient initializeWithBackendRoute: backendRoute backendGUID:backendGUID];
    }
    @catch (NSException *exception) {
        result = exception.name;
    }
    return result;
}

@end