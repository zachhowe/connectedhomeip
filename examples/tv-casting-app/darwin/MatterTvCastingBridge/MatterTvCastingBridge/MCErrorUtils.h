/**
 *
 *    Copyright (c) 2023 Project CHIP Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import "MatterError.h"
#include <lib/core/CHIPError.h>

#import <Foundation/Foundation.h>

/**
 * @brief - Conversion utilities to/from CHIP_ERROR (C++) / MatterError (Objective C) / NSError
 */
@interface MCErrorUtils : NSObject

+ (MatterError * _Nonnull)MatterErrorFromChipError:(CHIP_ERROR)chipError;

+ (NSError * _Nonnull)NSErrorFromChipError:(CHIP_ERROR)chipError;

+ (NSError * _Nonnull)NSErrorFromMatterError:(MatterError * _Nonnull)matterError;

+ (MatterError * _Nonnull)MatterErrorFromNsError:(NSError * _Nonnull)nsError;

@end
