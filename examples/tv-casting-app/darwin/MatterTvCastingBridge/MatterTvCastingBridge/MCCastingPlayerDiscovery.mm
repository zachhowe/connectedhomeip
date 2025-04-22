/**
 *
 *    Copyright (c) 2020-2023 Project CHIP Authors
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

#import "MCCastingPlayerDiscovery.h"

#import "MCCastingApp.h"

#import "MCCastingPlayer_Internal.h"
#import "MCErrorUtils.h"

#include "core/CastingPlayer.h"
#include "core/CastingPlayerDiscovery.h"
#include "core/Types.h"

#include <platform/CHIPDeviceLayer.h>

#import <Foundation/Foundation.h>

using namespace matter::casting;

/**
 * @brief Singleton that reacts to CastingPlayer discovery results
 */
class MCDiscoveryDelegateImpl : public matter::casting::core::DiscoveryDelegate {
private:
    MCDiscoveryDelegateImpl() {};
    static MCDiscoveryDelegateImpl * _discoveryDelegateImpl;

public:
    static MCDiscoveryDelegateImpl * GetInstance();
    void HandleOnAdded(matter::casting::memory::Strong<matter::casting::core::CastingPlayer> player) override;
    void HandleOnUpdated(matter::casting::memory::Strong<matter::casting::core::CastingPlayer> player) override;
};

@implementation MCCastingPlayerDiscovery

NSNotificationName const MCCastingPlayerDiscoveryAddCastingPlayerNotification = @"MCCastingPlayerDiscoveryAddCastingPlayerNotification";
NSNotificationName const MCCastingPlayerDiscoveryRemoveCastingPlayerNotification = @"MCCastingPlayerDiscoveryRemoveCastingPlayerNotification";
NSNotificationName const MCCastingPlayerDiscoveryUpdateCastingPlayer = @"MCCastingPlayerDiscoveryUpdateCastingPlayer";
NSString * const MCCastingPlayerDiscoveryCastingPlayerKey = @"castingPlayer";

- (instancetype) init
{
    self = [super init];
    if (self) {
        dispatch_queue_t workQueue = [[MCCastingApp getSharedInstance] getWorkQueue];
        dispatch_sync(workQueue, ^{
            core::CastingPlayerDiscovery::GetInstance()->SetDelegate(MCDiscoveryDelegateImpl::GetInstance());
        });
    }
    return self;
}

+ (MCCastingPlayerDiscovery *)sharedInstance
{
    static MCCastingPlayerDiscovery * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)start:(NSError **)error
{
    return [self start:0 error:error]; // default to filterBydeviceType: 0
}

- (BOOL)start:(const uint32_t)filterByDeviceType error:(NSError **)error
{
    ChipLogProgress(AppServer, "MCCastingPlayerDiscovery.start called");
    if (![[MCCastingApp getSharedInstance] isRunning]) {
        if (error) { *error = [MCErrorUtils NSErrorFromChipError:CHIP_ERROR_INCORRECT_STATE]; }
        return NO;
    }

    dispatch_queue_t workQueue = [[MCCastingApp getSharedInstance] getWorkQueue];
    __block CHIP_ERROR err = CHIP_NO_ERROR;
    dispatch_sync(workQueue, ^{
        err = core::CastingPlayerDiscovery::GetInstance()->StartDiscovery(filterByDeviceType);
    });
    
    NSError *actualError = [MCErrorUtils NSErrorFromChipError:err];
    if (error) { *error = actualError; }
    return actualError == nil;
}

- (BOOL)stop:(NSError**)error
{
    ChipLogProgress(AppServer, "MCCastingPlayerDiscovery.stop called");
    if (![[MCCastingApp getSharedInstance] isRunning]) {
        if (error) { *error = [MCErrorUtils NSErrorFromChipError:CHIP_ERROR_INCORRECT_STATE]; }
        return NO;
    }

    dispatch_queue_t workQueue = [[MCCastingApp getSharedInstance] getWorkQueue];
    __block CHIP_ERROR err = CHIP_NO_ERROR;
    dispatch_sync(workQueue, ^{
        err = core::CastingPlayerDiscovery::GetInstance()->StopDiscovery();
    });

    NSError *actualError = [MCErrorUtils NSErrorFromChipError:err];
    if (error) { *error = actualError; }
    return actualError == nil;
}

@end

MCDiscoveryDelegateImpl * MCDiscoveryDelegateImpl::_discoveryDelegateImpl = nullptr;

MCDiscoveryDelegateImpl * MCDiscoveryDelegateImpl::GetInstance()
{
    if (_discoveryDelegateImpl == nullptr) {
        _discoveryDelegateImpl = new MCDiscoveryDelegateImpl();
    }
    return _discoveryDelegateImpl;
}

void MCDiscoveryDelegateImpl::HandleOnAdded(matter::casting::memory::Strong<matter::casting::core::CastingPlayer> castingPlayer)
{
    ChipLogProgress(AppServer, "MCDiscoveryDelegateImpl::HandleOnAdded called with CastingPlayer ID: %s", castingPlayer->GetId());
    dispatch_queue_t clientQueue = [[MCCastingApp getSharedInstance] getClientQueue];
    VerifyOrReturn(clientQueue != nil, ChipLogError(AppServer, "MCDiscoveryDelegateImpl::HandleOnAdded ClientQueue was nil"));
    VerifyOrReturn(castingPlayer != nil, ChipLogError(AppServer, "MCDiscoveryDelegateImpl::HandleOnAdded Cpp CastingPlayer was nil"));
    dispatch_async(clientQueue, ^{
        NSDictionary * dictionary = @ { MCCastingPlayerDiscoveryCastingPlayerKey : [[MCCastingPlayer alloc] initWithCppCastingPlayer:castingPlayer] };
        [[NSNotificationCenter defaultCenter] postNotificationName:MCCastingPlayerDiscoveryAddCastingPlayerNotification object:nil userInfo:dictionary];
    });
}

void MCDiscoveryDelegateImpl::HandleOnUpdated(matter::casting::memory::Strong<matter::casting::core::CastingPlayer> castingPlayer)
{
    ChipLogProgress(AppServer, "MCDiscoveryDelegateImpl::HandleOnUpdated called with CastingPlayer ID: %s", castingPlayer->GetId());
    dispatch_queue_t clientQueue = [[MCCastingApp getSharedInstance] getClientQueue];
    VerifyOrReturn(clientQueue != nil);
    dispatch_async(clientQueue, ^{
        NSDictionary * dictionary = @ { MCCastingPlayerDiscoveryCastingPlayerKey : [[MCCastingPlayer alloc] initWithCppCastingPlayer:castingPlayer] };
        [[NSNotificationCenter defaultCenter] postNotificationName:MCCastingPlayerDiscoveryUpdateCastingPlayer object:nil userInfo:dictionary];
    });
}
