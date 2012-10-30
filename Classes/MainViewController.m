#import "MainViewController.h"
#import "MainView.h"

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	}
	return self;
}

- (void)viewDidLoad {
	
	campFireView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog (@"screenHeight: %d", (int)screenHeight);

    if ((int)screenHeight == 568) {
        imaHugeIphone = YES;
    } else {
        imaHugeIphone = NO;
    }
    
	[self setImage:YES];
	[self.view addSubview:campFireView];
	
    [campFireView release];
}

- (void)setImage:(BOOL) state
{
	if (state) {
        NSString *imgOn = imaHugeIphone ? @"bonfire_on_4inch.png" : @"bonfire_on.png";
		campFireView.image = [UIImage imageNamed:imgOn];
		imageOn = YES;
	} else {
        NSString *imgOff = imaHugeIphone ? @"bonfire_off_4inch.png" : @"bonfire_off.png";
		campFireView.image = [UIImage imageNamed:imgOff];
		imageOn = NO;
	}
}

- (IBAction)toggleImage
{
	// just deal with image
	//campFireView.image = (imageOn) ? [UIImage imageNamed:@"bonfire_off.png"] :
	//								 [UIImage imageNamed:@"bonfire_on.png"];
	//imageOn = !imageOn;
	imageOn ? [self setImage:NO] : [self setImage:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[super dealloc];
}


@end
