// This file is intentionally minimal.
// It exists only to satisfy SPM's requirement for a target to have source files.
//
// The purpose of the KycOnboardingSDKDependencies target is to:
// 1. Declare dependencies on Amplify, Veriff, and FaceLiveness
// 2. Make these dependencies available to consumers of KycOnboardingSDK.xcframework
// 3. Ensure automatic dependency resolution through SPM
//
// The actual SDK implementation is in the binary KycOnboardingSDK.xcframework,
// which is distributed separately through GitHub Releases.

import Foundation
