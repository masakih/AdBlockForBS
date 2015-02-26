//
//  AdBlockForBS.m
//  AdBlockForBS
//
//  Created by Hori,Masaki on 2015/02/26.
//  Copyright (c) 2015年 Hori,Masaki. All rights reserved.
//

#import "AdBlockForBS.h"

#import "CustomHTTPProtocol.h"


@interface AdBlockForBS () <CustomHTTPProtocolDelegate>
@end

@implementation AdBlockForBS

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


- (BOOL)previewLink:(NSURL *)url { return NO; }
- (BOOL)validateLink:(NSURL *)url { return NO; }
- (BOOL)previewLinks:(NSArray *)urls { return NO; }
@end
