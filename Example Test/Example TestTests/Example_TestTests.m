//
//  Example_TestTests.m
//  Example TestTests
//
//  Created by Dan Zinngrabe on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Example_TestTests.h"
#import <UnitTestHTTPServer/HTTPServer.h>

@interface Example_TestTests()
@property (nonatomic, retain) HTTPServer *httpServer;
@end

@implementation Example_TestTests
@synthesize httpServer;

- (void)setUp {
    NSError *error  = nil;
    
    [super setUp];
    
    // Set up the internal HTTP server
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    
    // This can point to anything you want to use as the web root for these tests, as long as it exists in the test
    // Here it is the folder 'Web' inside the Supporting Files group - note that it has to be a "folder reference" to get
    // copied correctly during the "Copy resources" build phase.
    NSString *webPath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"Web"];
    
    [httpServer setDocumentRoot:webPath];
    if([httpServer start:&error]) {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    } else {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

- (void)tearDown {
    // Tear-down code here.
    [httpServer stop];
    [httpServer release];
    [super tearDown];
}

- (void)testHttpExample {
    NSString            *urlString      = nil;
    NSURL               *url            = nil;
    NSData              *downloadResult = nil;
    
    urlString = [[NSString alloc] initWithFormat:@"http://127.0.0.1:%d/index.html", [[self httpServer] listeningPort] ];
    url = [NSURL URLWithString:urlString];
    
    downloadResult = [NSData dataWithContentsOfURL:url];
    [urlString release];
    
    STAssertNotNil(downloadResult, @"Did not get any data!");
}

@end
