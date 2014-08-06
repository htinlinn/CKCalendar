#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"

@interface CKViewController () <CKCalendarDelegate>

@property (nonatomic, weak) CKCalendarView *calendar;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSArray *disabledDates;

@end

@implementation CKViewController

- (id)init {
	self = [super init];
	if (self) {
		CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
		self.calendar = calendar;
		calendar.delegate = self;

        calendar.backgroundColor = [UIColor whiteColor];
		calendar.titleColor = [UIColor blackColor];
        calendar.titleFont = [UIFont fontWithName:@"GillSans-Bold" size:16.0f];
        calendar.dayOfWeekFont = [UIFont fontWithName:@"GillSans-Bold" size:12.0f];
        calendar.dateFont = [UIFont fontWithName:@"GillSans" size:16.0f];

        [calendar setDayOfWeekBackgroundColor:[UIColor darkGrayColor]];
        [calendar setDateBorderColor:[UIColor whiteColor]];
        [calendar setMonthButtonColor:[UIColor orangeColor]];

		self.dateFormatter = [[NSDateFormatter alloc] init];
		[self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
		self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];

		self.disabledDates = @[
                               [self.dateFormatter dateFromString:@"08/08/2014"],
                               [self.dateFormatter dateFromString:@"09/08/2014"],
                               [self.dateFormatter dateFromString:@"07/08/2014"]
                               ];

		calendar.onlyShowCurrentMonth = NO;
		calendar.adaptHeightToNumberOfWeeksInMonth = YES;

		calendar.frame = CGRectMake(0, 50, 320, 320);
		[self.view addSubview:calendar];

		self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
		[self.view addSubview:self.dateLabel];

		self.view.backgroundColor = [UIColor whiteColor];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}
	else {
		return YES;
	}
}

- (void)localeDidChange {
	[self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
	for (NSDate *disabledDate in self.disabledDates) {
		if ([disabledDate isEqualToDate:date]) {
			return YES;
		}
	}
	return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
	// TODO: play with the coloring if we want to...
	if ([self dateIsDisabled:date]) {
		dateItem.backgroundColor = [UIColor lightGrayColor];
        dateItem.textColor = [UIColor whiteColor];
	} else {
        dateItem.backgroundColor = [UIColor whiteColor];
        dateItem.selectedBackgroundColor = [UIColor darkGrayColor];

        if ([self.calendar dateIsInCurrentMonth:date]) {
            dateItem.textColor = [UIColor darkGrayColor];
            dateItem.selectedTextColor = [UIColor whiteColor];
        } else {
            dateItem.textColor = [UIColor lightGrayColor];
            dateItem.selectedTextColor = [UIColor whiteColor];
        }
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
	return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
	self.dateLabel.text = [self.dateFormatter stringFromDate:date];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
	NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

@end
