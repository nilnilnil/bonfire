#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController {
	BOOL imageOn;
    BOOL imaHugeIphone;
	UIImageView* campFireView;
}
- (void) setImage:(BOOL) state;
- (IBAction) toggleImage;
@end