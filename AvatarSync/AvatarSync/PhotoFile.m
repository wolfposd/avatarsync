//
// AvatarSync
// Copyright (C) 2014-2015  Wolf Posdorfer
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//

#import "PhotoFile.h"


@implementation PhotoFile


-(UIImage *)image
{
    if([self.fullFilePath rangeOfString:@"/"].location == NSNotFound)
    {
        return [UIImage imageNamed:self.fullFilePath];
    }
    else
    {
        return [UIImage imageWithContentsOfFile:self.fullFilePath];
    }
}

+(PhotoFile*) photoFile:(NSString*) filename filepath:(NSString*) fullfilepath
{
    PhotoFile* f = [PhotoFile new];
    f.fullFilePath = fullfilepath;
    f.filename = filename;
    return f;
}


@end
