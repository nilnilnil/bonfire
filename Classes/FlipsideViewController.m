#import "FlipsideViewController.h"


@implementation FlipsideViewController
- (IBAction)launchSiteClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://blog.opensesame.st"]];
}

- (IBAction)contactClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:contact@opensesame.st"]];
}

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];		
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
