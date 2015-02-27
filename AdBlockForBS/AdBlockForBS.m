//
//  AdBlockForBS.m
//  AdBlockForBS
//
//  Created by Hori,Masaki on 2015/02/26.
//  Copyright (c) 2015年 Hori,Masaki. All rights reserved.
//

#import "AdBlockForBS.h"

#import "CustomHTTPProtocol.h"


static NSArray *sSystemBlockHosts = nil;


@interface AdBlockForBS () <CustomHTTPProtocolDelegate>
@end

@implementation AdBlockForBS
+ (void)load
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		NSURL *url = [bundle URLForResource:@"SystemBlockHost" withExtension:@"plist"];
		NSArray *array = [[NSArray alloc] initWithContentsOfURL:url];
		if(!array) {
			NSLog(@"Can not load SystemBlockHost.plist.");
		}
		sSystemBlockHosts = [array copy];
	});
}
- (id)initWithPreferences:(AppDefaults *)prefs
{
	self = [super init];
	if(self) {
		[CustomHTTPProtocol setDelegate:self];
	}
	return self;
}

- (void)customHTTPProtocolDidFinishLoading:(CustomHTTPProtocol *)protocol
{
	NSURL *url = protocol.request.URL;
	NSLog(@"Did Finish Loading. URL %@", url);
}

- (NSURLResponse *)customHTTPProtocol:(CustomHTTPProtocol *)protocol replaceResponse:(NSURLResponse *)response
{
	NSString *hostName = response.URL.host;
	for(NSString *s in sSystemBlockHosts) {
		if([s hasSuffix:hostName]) {
			NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
			id headers = httpResponse.allHeaderFields;
			response = [[NSHTTPURLResponse alloc] initWithURL:response.URL
												   statusCode:404
												  HTTPVersion:@"HTTP/1.1"
												 headerFields:headers];
			
			break;
		}
	}
	
	return response;
}


- (BOOL)previewLink:(NSURL *)url { return NO; }
- (BOOL)validateLink:(NSURL *)url { return NO; }
- (BOOL)previewLinks:(NSArray *)urls { return NO; }
@end
