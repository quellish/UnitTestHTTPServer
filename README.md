UnitTestHTTPServer
==================
Embed an HTTP server in your iOS unit tests. This repackages CocoaHTTPServer to make it very easy to create self contained unit tests that exercise HTTP functionality.

Using UnitTestHTTPServer
-----------------------



Getting the code
----------------
After you clone this git project, inside the UnitTestHTTPServer directory run:
	git submodule init
	git submodule update
To pull in the CocoaHTTPServer code this depends on.

This project creates a CocoaHTTPServer library that can be embedded in iPhone projects for unit tests.
Include it in your test target as you would any other library dependancy (see below for detailed instructions).

Setting up your project
-----------------------

1. Drag the XCode project file into your test target.
2. In the **Build Phases** pane of your test target's settings, add *UnitTestHTTPServer* as a dependancy. To do this, click the **+** symbol at the bottom of the **Target Dependancies** section of that screen. Select *UnitTestHTTPServer* from the list that comes up.
3. In the **Link Binary With Libraries** section of that screen, add *libUnitTestHTTPServer*. Do this by clicking the **+** symbol in that section and selecting *UnitTestHTTPServer* from that list.
4. In XCode's **File** menu, select **Project Settings...** . In the dialog that pops up, click **Advanced...** and in the next screen make sure that **Unique** is selected.

Your test target also needs to link against the following:

	libxml2.2.7.3.dylib
	Security.framework
	CFNetwork.framework
	Foundation.framework

Writing your tests
------------------

In your test, implement set up and tear down as follows:


	- (void)setUp {
	    NSError *error  = nil;
    
	    [super setUp];
    
	    // Set up the internal HTTP server
	    httpServer = [[HTTPServer alloc] init];
	    [httpServer setType:@"_http._tcp."];
    
	    // This can point to anything you want to use as the web root for these tests, as long as it exists in the test
		// Here it is the folder 'Web' inside the Supporting Files group
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

At this point you're ready to write your tests. Since the HTTP server's port can change (it is unlikely to be port 80), make sure your URLs use the port the server is listening on:
`urlString = [[NSString alloc] initWithFormat:@"http://127.0.0.1:%d/index.html", [[self httpServer] listeningPort] ];`

There is a very simple example test project in the **Example Test** directory. Run that to see the simplest possible test I could think of. All of the project settings outlined above are illustrated in that project. 