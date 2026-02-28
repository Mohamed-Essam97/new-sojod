#!/bin/bash

# ============================================
# Quick Deploy Script - نشر سريع
# ============================================
# استخدام سريع بدون أسئلة
# ============================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Wird App - Quick Deploy${NC}"
echo ""

# Check Firebase CLI
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found. Install: npm install -g firebase-tools"
    exit 1
fi

# Build Android APK
echo "📱 Building Android APK..."
flutter build apk --release

# Deploy to Firebase
echo "☁️  Deploying to Firebase..."
firebase appdistribution:distribute \
    build/app/outputs/flutter-apk/app-release.apk \
    --app 1:405620285471:android:ab37420b030207df03b52a \
    --groups testers \
    --release-notes "Quick deploy - $(date '+%Y-%m-%d %H:%M')"

echo ""
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo "Check: https://console.firebase.google.com/project/wird-islamic-app/appdistribution"
