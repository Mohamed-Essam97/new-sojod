#!/bin/bash

# ============================================
# Firebase App Distribution Deploy Script
# ============================================
# يقوم بـبناء ورفع APK و IPA إلى Firebase App Distribution
# ============================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_ID_ANDROID="1:405620285471:android:ab37420b030207df03b52a"
APP_ID_IOS="1:405620285471:ios:42a935e75e6b167003b52a"
GROUPS="testers"  # Firebase distribution group name
VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}')

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

# Check if Firebase CLI is installed
check_firebase_cli() {
    if ! command -v firebase &> /dev/null; then
        print_error "Firebase CLI not installed!"
        print_info "Install with: npm install -g firebase-tools"
        exit 1
    fi
    print_success "Firebase CLI found"
}

# Clean previous builds
clean_build() {
    print_header "Cleaning previous builds"
    flutter clean
    flutter pub get
    print_success "Clean complete"
}

# Build Android APK
build_android() {
    print_header "Building Android APK"
    print_info "Building release APK..."
    
    flutter build apk --release
    
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        print_success "Android APK built successfully"
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        print_info "APK Size: $APK_SIZE"
        return 0
    else
        print_error "APK build failed"
        return 1
    fi
}

# Build iOS IPA
build_ios() {
    print_header "Building iOS IPA"
    print_info "Building release IPA..."
    
    # Clean iOS build
    cd ios
    rm -rf build
    pod install --repo-update
    cd ..
    
    # Build iOS
    flutter build ios --release --no-codesign
    
    # Archive and export IPA
    cd ios
    xcodebuild -workspace Runner.xcworkspace \
               -scheme Runner \
               -configuration Release \
               -archivePath build/Runner.xcarchive \
               archive
    
    xcodebuild -exportArchive \
               -archivePath build/Runner.xcarchive \
               -exportPath build \
               -exportOptionsPlist ExportOptions.plist
    
    cd ..
    
    if [ -f "ios/build/Runner.ipa" ]; then
        print_success "iOS IPA built successfully"
        IPA_PATH="ios/build/Runner.ipa"
        IPA_SIZE=$(du -h "$IPA_PATH" | cut -f1)
        print_info "IPA Size: $IPA_SIZE"
        return 0
    else
        print_error "IPA build failed"
        return 1
    fi
}

# Deploy to Firebase App Distribution
deploy_android() {
    print_header "Deploying Android to Firebase"
    
    RELEASE_NOTES="Version $VERSION
    
🚀 New Features:
• Daily Wird tracking (Quran, Adhkar, Tasbeeh)
• Groups & Invite system
• Firebase Authentication (Google)
• Skip login option
• Real-time progress updates

🐛 Bug Fixes:
• Improved stability
• UI enhancements

📅 Build Date: $(date '+%Y-%m-%d %H:%M')"
    
    firebase appdistribution:distribute "$APK_PATH" \
        --app "$APP_ID_ANDROID" \
        --groups "$GROUPS" \
        --release-notes "$RELEASE_NOTES"
    
    print_success "Android APK deployed to Firebase"
}

deploy_ios() {
    print_header "Deploying iOS to Firebase"
    
    RELEASE_NOTES="Version $VERSION
    
🚀 New Features:
• Daily Wird tracking (Quran, Adhkar, Tasbeeh)
• Groups & Invite system
• Firebase Authentication (Google)
• Skip login option
• Real-time progress updates

🐛 Bug Fixes:
• Improved stability
• UI enhancements

📅 Build Date: $(date '+%Y-%m-%d %H:%M')"
    
    firebase appdistribution:distribute "$IPA_PATH" \
        --app "$APP_ID_IOS" \
        --groups "$GROUPS" \
        --release-notes "$RELEASE_NOTES"
    
    print_success "iOS IPA deployed to Firebase"
}

# Main script
main() {
    print_header "Wird App - Firebase Distribution Deploy"
    print_info "Version: $VERSION"
    echo ""
    
    # Check prerequisites
    check_firebase_cli
    
    # Ask what to build
    echo ""
    echo "What would you like to deploy?"
    echo "1) Android only"
    echo "2) iOS only"
    echo "3) Both Android and iOS"
    echo "4) Clean and build both"
    read -p "Enter choice [1-4]: " choice
    
    case $choice in
        1)
            build_android && deploy_android
            ;;
        2)
            build_ios && deploy_ios
            ;;
        3)
            build_android && deploy_android
            build_ios && deploy_ios
            ;;
        4)
            clean_build
            build_android && deploy_android
            build_ios && deploy_ios
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    print_header "Deployment Complete! 🎉"
    print_success "Check Firebase Console for distribution status"
    print_info "URL: https://console.firebase.google.com/project/wird-islamic-app/appdistribution"
}

# Run main
main
