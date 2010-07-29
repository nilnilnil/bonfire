#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>

@class RootViewController;
@class MainViewController;

@interface BonfireAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow* window;
	IBOutlet RootViewController* rootViewController;
	//XXX: (jft) added
	float BacklightValue;
	BOOL Strobing; 
	BOOL screenInit;
	BOOL ledOn; //XXX: for the button
	AVCaptureDevice* captDevice;
	AVCaptureSession* captureSession;
}

@property (nonatomic, retain) UIWindow* window;
@property (nonatomic, retain) RootViewController* rootViewController;

- (IBAction) toggleLight;
- (void) initWithCaptureDevice;
- (void) setLed:(BOOL) state;
//- (void) StrobeTapped;
//- (void) StrobeTimer: (NSTimer*) Timer;
//- (void) initWithScreen;
//- (void) StrobeTappedLed;
//- (void) StrobeTimerLed: (NSTimer*) Timer;

@end

