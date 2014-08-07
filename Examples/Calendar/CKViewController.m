#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"

@interface CKViewController () <CKCalendarDelegate>

@property (nonatomic, strong) CKCalendarView *calendar;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSArray *disabledDates;

@end

@implementation CKViewController

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor whiteColor];

    self.calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar.frame = CGRectMake(0, 20, 320, 320);
    self.calendar.delegate = self;

    [self.calendar setBackgroundColor:[UIColor whiteColor]];
    [self.calendar setTitleColor:[UIColor blackColor]];
    [self.calendar setDayOfWeekBackgroundColor:[UIColor darkGrayColor]];
    [self.calendar setDateBorderColor:[UIColor whiteColor]];
    [self.calendar setMonthButtonColor:[UIColor orangeColor]];

    self.calendar.titleFont = [UIFont fontWithName:@"GillSans-Bold" size:16.0f];
    self.calendar.dayOfWeekFont = [UIFont fontWithName:@"GillSans-Bold" size:12.0f];
    self.calendar.dateFont = [UIFont fontWithName:@"GillSans" size:16.0f];

    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;

    [self.view addSubview:self.calendar];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];

    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];

    NSDate *today = [NSDate date];
    self.disabledDates = @[
                           [today dateByAddingTimeInterval:86400],
                           [today dateByAddingTimeInterval:86400 * 2],
                           [today dateByAddingTimeInterval:86400 * 3]
                           ];

    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendar.frame) + 50, self.view.bounds.size.width, 50)];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.font = [UIFont fontWithName:@"GillSans" size:60.0f];
    [self.view addSubview:self.dateLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

    [self.calendar selectDate:[NSDate date] makeVisible:YES];
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
        if ([self.calendar date:disabledDate isSameDayAsDate:date]) {
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
