#import "BonfireAppDelegate.h"
#import "MainViewController.h"
#import "RootViewController.h"	

@implementation BonfireAppDelegate

@synthesize window, rootViewController;

//extern void GSEventSetBacklightLevel(float); 

- (IBAction) toggleLight
{
	ledOn ? [self setLed:NO] : [self setLed:YES];
	[(MainViewController *)rootViewController.mainViewController toggleImage];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	// set status bar style
	application.statusBarStyle = UIStatusBarStyleBlackOpaque;
	
	NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	captDevice = nil;
	
	for(AVCaptureDevice* device in devices)
	{
		if([device hasTorch])
		{
			NSLog(@"device has a torch");
			captDevice = device;
			[captDevice retain];
			break;
		}
	}
	
	//add view controller for icon
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
	
	if(captDevice)
	{
		[self initWithCaptureDevice];
	}
	else
	{
		//[self initWithScreen];		
		NSLog(@"device does not have torch");
	}
}

- (void) initWithCaptureDevice
{
	screenInit = NO;
	Strobing = NO;
	ledOn = YES;
	
	//window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]]; 
	//window.backgroundColor = [UIColor blackColor];
	
	/*UIButton* strobeButton = [[UIButton alloc] initWithFrame:CGRectMake((window.frame.size.width - 100.0f) / 2.0f,
																		window.frame.size.height - 50.0f,
																		100.0f,
																		40.0f)];*/
	
	/*UILabel* Message = [[UILabel alloc] initWithFrame:CGRectMake((window.frame.size.width - 300.0f) / 2.0f,
																 (window.frame.size.height - 100.0f) / 2.0f,
																 300.0f,
																 100.0f)];
	Message.text = @"bonfire! _XX_";
	Message.textAlignment = UITextAlignmentCenter;
	Message.textColor = [UIColor whiteColor];
	Message.backgroundColor = [UIColor blackColor];
	
	UIApplication* theApp = [UIApplication sharedApplication];
	theApp.statusBarStyle = UIStatusBarStyleBlackOpaque;
	theApp.statusBarHidden = NO;
	
	[window addSubview:Message];
	[Message release];*/
	
	/*[strobeButton addTarget:self action:@selector(StrobeTappedLed) forControlEvents:UIControlEventTouchUpInside];
	strobeButton.backgroundColor = [UIColor grayColor];
	[strobeButton setTitle:@"Strobe" forState:UIControlStateNormal];
	[window addSubview:strobeButton];*/
	
    // Override point for customization after application launch
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
	
	NSError* error = nil;
	NSLog(@"Setting up LED");
	
	if([captDevice hasTorch] == NO)
	{
		NSLog(@"Error: This device doesnt have a torch");
	}
	else if([captDevice isTorchModeSupported:AVCaptureTorchModeOn] == NO)
	{
		NSLog(@"Error: This device doesnt support AVCaptureTorchModeOn");
	}
	else 
	{
		captureSession = [[AVCaptureSession alloc] init];
		AVCaptureDeviceInput* videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:captDevice error:&error];
		AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
		
		if (videoInput && videoOutput) 
		{
			[captureSession addInput:videoInput];
			[captureSession addOutput:videoOutput];
			[self setLed:YES];
			[captureSession startRunning];
		}
		else 
		{
			NSLog(@"Error: %@", error);
		}	
	}
}

- (void) setLed:(BOOL) state
{
	NSError* error = nil;
	
	if(captDevice != nil && [captDevice lockForConfiguration:&error])
	{
		if (state) {
			captDevice.torchMode = AVCaptureTorchModeOn;
			ledOn = YES;
		} else {
			captDevice.torchMode = AVCaptureTorchModeOff;
			ledOn = NO;
		}

		[captDevice unlockForConfiguration];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	if(screenInit == YES)
	{
		//GSEventSetBacklightLevel(0.9999f);
	}
	else
	{
		//ensure we start with image on
		[(MainViewController *)rootViewController.mainViewController setImage:YES];
		//turn on the light
		if(captureSession != nil) [captureSession startRunning];
			[self setLed:YES];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	if(screenInit == YES)
	{
		//GSEventSetBacklightLevel(BacklightValue);
	}
	else
	{
		//image off
		[(MainViewController *)rootViewController.mainViewController setImage:NO];
		//turn off the light
		if(captureSession != nil) [captureSession stopRunning];
		[self setLed:NO];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	if(screenInit == YES)
	{
		//GSEventSetBacklightLevel(BacklightValue);
	}
	else
	{
		if(captureSession != nil) [captureSession stopRunning];
		[self setLed:NO];
	}
}

/*
- (void) StrobeTappedLed
{
	if(Strobing == YES)
	{
		Strobing = NO;
	}
	else
	{
		Strobing = YES;
		[NSTimer scheduledTimerWithTimeInterval:0.10f target:self  selector:@selector(StrobeTimerLed:) userInfo:nil repeats:YES]; 
	}
}

- (void) StrobeTapped
{
	if(Strobing == YES)
	{
		Strobing = NO;
	}
	else
	{
		Strobing = YES;
		[NSTimer scheduledTimerWithTimeInterval:0.10f target:self  selector:@selector(StrobeTimer:) userInfo:nil repeats:YES]; 
	}
}

- (void) StrobeTimerLed: (NSTimer*) Timer
{
	static BOOL currentState = YES;
	
	if(Strobing == NO)
	{
		[Timer invalidate];
		[self setLed:YES];
	}
	else
	{
		currentState = (currentState) ? NO : YES;
		[self setLed:currentState];
	}
}

- (void) StrobeTimer: (NSTimer*) Timer
{
	static float TimerBacklightValue = 0.9999f;
	
	if(Strobing == NO)
	{
		[Timer invalidate];
		TimerBacklightValue = 0.9999f;
	}
	else
	{
		if(TimerBacklightValue == 0.9999f)
		{
			TimerBacklightValue = 0.1000f;
		}
		else
		{
			TimerBacklightValue = 0.9999f;
		}
	}
	//GSEventSetBacklightLevel(TimerBacklightValue);
}*/

/*- (void) initWithScreen
 {
 screenInit = YES;
 NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
 float userBacklightLevel1 = [[prefs objectForKey:@"SBBacklightLevel"] floatValue];
 float userBacklightLevel2 = [[prefs objectForKey:@"SBBacklightLevel2"] floatValue];
 float defaultBacklightLevel = 0.5;
 [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
 
 if	(userBacklightLevel2 > 0) BacklightValue = userBacklightLevel2;
 else if (userBacklightLevel1 > 0) BacklightValue = userBacklightLevel1;
 else	BacklightValue = defaultBacklightLevel;
 
 //GSEventSetBacklightLevel(0.9999f);
 Strobing = NO;
 
 window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]]; 
 window.backgroundColor = [UIColor whiteColor];
 
 UIButton* strobeButton = [[UIButton alloc] initWithFrame:CGRectMake((window.frame.size.width - 100) / 2,
 window.frame.size.height - 40 - 10,
 100,
 40)];
 [strobeButton addTarget:self action:@selector(StrobeTapped) forControlEvents:UIControlEventTouchUpInside];
 strobeButton.backgroundColor = [UIColor grayColor];
 [strobeButton setTitle:@"Strobe" forState:UIControlStateNormal];
 
 [window addSubview:strobeButton];
 
 // Override point for customization after application launch
 [window makeKeyAndVisible];
 }*/

- (void)dealloc {
	[rootViewController release];
	[window release];
	
	//XXX: (jft) for camera
	if(captureSession != nil) [captureSession release];
	if(captDevice != nil) [captDevice release];
	
	[super dealloc];
}

@end
