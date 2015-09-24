#import "IMFClient+initializeException.h"

@implementation IMFClient (InitializeException)

-(NSString*) tryInitializeWithBackendRoute: (NSString*)backendRoute backendGUID:(NSString*)backendGUID {
    NSString *result = @"";
    @try {
        IMFClient *imfClient = [IMFClient sharedInstance];
        [imfClient initializeWithBackendRoute: backendRoute backendGUID:backendGUID];
    }
    @catch (NSException *exception) {
        result = [NSString stringWithFormat:@"%@ %@", exception.name, exception.reason];
    }
    return result;
}

@end