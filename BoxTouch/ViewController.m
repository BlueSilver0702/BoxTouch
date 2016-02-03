//
//  ViewController.m
//  NotifDemo
//
//  Created by Kent Franks on 10/15/14.
//  Copyright (c) 2014 TheAppCodeLLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customMessage;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *frequencySegmentedControl;
@end

@implementation ViewController

bool allowNotif;
bool allowsSound;
bool allowsBadge;
bool allowsAlert;

- (IBAction)saveNotif:(id)sender
{
    // New for iOS 8 - Register the notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [self setNotificationTypesAllowed];
    if (notification)
    {
        if (allowNotif)
        {
            notification.fireDate = _datePicker.date;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            switch (_frequencySegmentedControl.selectedSegmentIndex) {
                case 0:
                    notification.repeatInterval = NSCalendarUnitDay;
                    break;
                case 1:
                    notification.repeatInterval = NSCalendarUnitWeekOfYear;
                    break;
                case 2:
                    notification.repeatInterval = NSCalendarUnitYear;
                    break;
                default:
                    notification.repeatInterval = 0;
                    break;
            }
        }
        if (allowsAlert)
        {
            notification.alertBody = @"hahaha";
        }
        if (allowsBadge)
        {
            notification.applicationIconBadgeNumber = 1;
        }
        if (allowsSound)
        {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        
        // this will schedule the notification to fire at the fire date
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        // this will fire the notification right away, it will still also fire at the date we set
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }

    // we're creating a string of the date so we can log the time the notif is supposed to fire
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString *notifDate = [formatter stringFromDate:_datePicker.date];
    NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate);
}

- (void)setNotificationTypesAllowed
{
    NSLog(@"%s:", __PRETTY_FUNCTION__);
    // get the current notification settings
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    allowNotif = (currentSettings.types != UIUserNotificationTypeNone);
    allowsSound = (currentSettings.types & UIUserNotificationTypeSound) != 0;
    allowsBadge = (currentSettings.types & UIUserNotificationTypeBadge) != 0;
    allowsAlert = (currentSettings.types & UIUserNotificationTypeAlert) != 0;
}

@end
