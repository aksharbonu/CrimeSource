//
//  SafetySpectSettingsViewController.m
//  SafetySpect
//
//  Created by Akshar Bonu  on 11/2/13.
//  Copyright (c) 2013 Buffalo&Akshar&Mark. All rights reserved.
//

#import "SafetySpectSettingsViewController.h"

@interface SafetySpectSettingsViewController ()

@end

@implementation SafetySpectSettingsViewController

- (NSArray*) types
{
    // TODO: @"Twitter", @"Instagram"
    if (!_types)
    {
        self.types = @[@"Police", @"User"];
    }
    return _types;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.types[indexPath.row];
    if ([cell.textLabel.text isEqualToString: @"Police"])
    {
        if (self.police)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else if ([cell.textLabel.text isEqualToString: @"User"])
    {
        if (self.user)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else if ([cell.textLabel.text isEqualToString: @"Twitter"])
    {
        if (self.twitter)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.types.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone) {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        
    }
    else {
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if ([self.types[indexPath.row] isEqualToString: @"Police"])
    {
        self.police = !self.police;
    }
    else if ([self.types[indexPath.row] isEqualToString: @"User"])
    {
        self.user = !self.user;
    }
    else if ([self.types[indexPath.row] isEqualToString: @"Twitter"])
    {
        self.twitter = !self.twitter;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


@end
