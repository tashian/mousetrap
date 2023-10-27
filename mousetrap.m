/*
Consume mouse events for apps where I'm learning the keyboard shortcuts.

    clang -o mouseblind mouseblind.m -framework Cocoa
    sudo ./mouseblind
*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#import <ApplicationServices/ApplicationServices.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

static bool locked = false;
static CFMachPortRef eventTap;

static CGEventRef mouseClickCB(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    CGEventRef returnEvent = locked ? NULL : event;
    
    if(type == kCGEventLeftMouseDown) {
       // printf("mouse!\n");
    }

    // if(type == kCGEventTapDisabledByTimeout) {
    //     printf("kCGEventTapDisabledByTimeout\n");
    //     CGEventTapEnable(eventTap, true);
    // }
    return returnEvent;
}

int main(int argc, const char * argv[]) {
    CGEventMask eventMask = CGEventMaskBit(kCGEventLeftMouseDown);
    NSArray *blockedApps = @[@"Linear", @"Notion"];

    eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, eventMask, mouseClickCB, NULL);
    if(!eventTap) {
        fprintf(stderr, "Failed to create event tap.\n");
        fprintf(stderr, "Run this via sudo and give your Terminal app Accessibility privileges\n");
        return 1;
    }

    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);

    printf("The following apps are blocked: ");
    for (NSString *string in blockedApps) {
        printf("%s ", [string UTF8String]);
    }
    printf("\n");

    @autoreleasepool {
        // Create a workspace object to observe application activations
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        NSNotificationCenter *center = [workspace notificationCenter];

        // Register for the notification
        [center addObserverForName:NSWorkspaceDidActivateApplicationNotification
                            object:nil
                            queue:[NSOperationQueue mainQueue]
                        usingBlock:^(NSNotification *note) {
            NSRunningApplication *activeApp = [note.userInfo valueForKey:NSWorkspaceApplicationKey];
            NSString *appName = [activeApp localizedName];
            //printf("Active application: '%s'\n", [appName UTF8String]);
            
            if ([blockedApps containsObject:appName]) {
                locked = true;
                //printf("Locked.");
            } else if (locked) {
                locked = false;
                //printf("Unlocked.");
            }

        }];

    }

    [NSApplication sharedApplication];
    [NSApp run];
    return 0;
}

