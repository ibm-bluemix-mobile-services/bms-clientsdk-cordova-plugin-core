#import "IMFCore/IMFClient.h"

@interface IMFClient (InitializeException)

-(NSString*) tryInitializeWithBackendRoute: (NSString*)backendRoute backendGUID:(NSString*)backendGUID;

@end