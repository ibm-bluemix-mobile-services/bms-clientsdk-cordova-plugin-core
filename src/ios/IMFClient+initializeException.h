#import IMFCore/IMFClient.h

@interface IMFClient (InitializeException)

-(void) tryInitializeWithBackendRoute: (NSString*)backendRoute backendGUID:(NSString*)backendGUID;

@end