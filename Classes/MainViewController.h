#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController {
	BOOL imageOn;
	UIImageView* campFireView;	
}
- (void) setImage:(BOOL) state;
- (IBAction) toggleImage;
@end