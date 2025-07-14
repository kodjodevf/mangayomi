#!/bin/bash

# Go build script for Mangayomi
# It supports Linux, macOS, Windows, Android, and iOS builds.
# to build, run:
# ./build_go.sh [linux|macos|windows|android|ios] [--all]

set -e  # Stop on error

# Colors for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Colored message functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Go
    if ! command -v go &> /dev/null; then
        log_error "Go is not installed. Please install Go 1.22 or newer."
        exit 1
    fi
    
    GO_VERSION=$(go version | grep -o 'go[0-9]\+\.[0-9]\+' | sed 's/go//')
    log_info "Detected Go version: $GO_VERSION"
    
    # Check if we're in the go directory
    if [ ! -f "go.mod" ]; then
        log_error "go.mod not found. Run this script from the 'go' directory of the Mangayomi project."
        exit 1
    fi
}

# Build for Linux
build_linux() {
    log_info "Building for Linux..."
    mkdir -p ../linux/bundle/lib
    go build -buildmode=c-shared -ldflags="-s -w" -trimpath -o ../linux/bundle/lib/libmtorrentserver.so ./binding/desktop
    log_success "Linux build completed: ../linux/bundle/lib/libmtorrentserver.so"
}

# Build for macOS
build_macos() {
    log_info "Building for macOS..."
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_warning "macOS build requested but you're not on macOS. Build might fail."
    fi
    
    mkdir -p ../macos/Frameworks
    
    # Build ARM64
    log_info "Building macOS ARM64..."
    CGO_ENABLED=1 GOARCH=arm64 go build -buildmode=c-shared -ldflags="-s -w" -trimpath -o libmtorrentserver_arm64.dylib ./binding/desktop
    
    # Build AMD64
    log_info "Building macOS AMD64..."
    CGO_ENABLED=1 GOARCH=amd64 go build -buildmode=c-shared -ldflags="-s -w" -trimpath -o libmtorrentserver_amd64.dylib ./binding/desktop
    
    # Create universal binary
    if command -v lipo &> /dev/null; then
        log_info "Creating universal binary..."
        lipo -create -output ../macos/Frameworks/libmtorrentserver.dylib libmtorrentserver_arm64.dylib libmtorrentserver_amd64.dylib
        
        # Clean up intermediate binaries
        log_info "Cleaning up intermediate binaries..."
        rm -f libmtorrentserver_arm64.dylib libmtorrentserver_amd64.dylib
        rm -f libmtorrentserver_arm64.h libmtorrentserver_amd64.h
        
        log_success "macOS build completed: ../macos/Frameworks/libmtorrentserver.dylib (universal)"
    else
        log_warning "lipo not available. Separate binaries are available."
    fi
}

# Build for Windows
build_windows() {
    log_info "Building for Windows..."
    
    mkdir -p ../windows
    
    # Configure environment for Windows
    export CGO_ENABLED=1
    export CC=gcc
    export GOARCH=amd64
    
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Native Windows
        go build -buildmode=c-shared -ldflags="-s -w -extldflags=-static" -trimpath -o ../windows/libmtorrentserver.dll ./binding/desktop
    else
        # Cross-compilation from Unix
        if command -v x86_64-w64-mingw32-gcc &> /dev/null; then
            export CC=x86_64-w64-mingw32-gcc
            export GOOS=windows
            go build -buildmode=c-shared -ldflags="-s -w -extldflags=-static" -trimpath -o ../windows/libmtorrentserver.dll ./binding/desktop
        else
            log_error "Windows cross-compiler not found. Install mingw-w64."
            return 1
        fi
    fi
    
    log_success "Windows build completed: ../windows/libmtorrentserver.dll"
}

# Build for Android
build_android() {
    log_info "Building for Android..."
    
    # Check gomobile
    if ! command -v gomobile &> /dev/null; then
        log_info "Installing gomobile..."
        go install golang.org/x/mobile/cmd/gomobile@latest
        go install golang.org/x/mobile/cmd/gobind@latest
        
        # Add GOPATH/bin to PATH if necessary
        export PATH=$PATH:$(go env GOPATH)/bin
        
        # Initialize gomobile
        log_info "Initializing gomobile..."
        gomobile init -v
    fi
    
    # Check Android NDK
    if [ -z "$ANDROID_NDK_HOME" ] && [ -z "$ANDROID_NDK_ROOT" ]; then
        log_warning "ANDROID_NDK_HOME or ANDROID_NDK_ROOT not defined. Android build might fail."
        log_warning "Install Android Studio and NDK, then set the environment variable."
        log_warning "Example: export ANDROID_NDK_HOME=/path/to/android/sdk/ndk/25.2.9519653"
    fi
    
    # Check Java JDK
    if ! javac -version &> /dev/null; then
        log_warning "javac (Java Development Kit) not working. Android build might fail."
        log_warning "Install Oracle JDK or OpenJDK and configure JAVA_HOME."
        log_warning "On macOS: brew install openjdk@11"
        log_warning "Then: export JAVA_HOME=\$(brew --prefix openjdk@11)"
    fi
    
    go get -u golang.org/x/mobile
    
    log_info "Building Android AAR..."
    
    mkdir -p ../android/app/libs
    
    # Try Android build with enhanced error handling
    # Uses -checklinkname=0 and -tags to allow anet v0.0.5 usage (solution inspired by Gopeed)
    if ! gomobile bind -v -tags mobile -target=android/arm,android/arm64,android/amd64,android/386 -androidapi 21 -ldflags="-s -w -checklinkname=0" -trimpath -o ../android/app/libs/libmtorrentserver.aar ./binding/mobile; then
        log_error "Android build failed."
        log_error "Common error: 'invalid reference to net.zoneCache'"
        log_error ""
        log_error "Possible solutions:"
        log_error "1. Install and configure Android NDK correctly:"
        log_error "   - Download Android Studio"
        log_error "   - Install Android NDK via SDK Manager"
        log_error "   - Set ANDROID_NDK_HOME"
        log_error ""
        log_error "2. Update Go to latest version:"
        log_error "   - current go version: $(go version)"
        log_error "   - Recommended: Go 1.21 or newer"
        log_error ""
        log_error "3. Known issue with github.com/wlynxg/anet:"
        log_error "   - This package uses internal Go APIs"
        log_error "   - Applied solution: replace directive in go.mod"
        log_error ""
        log_error "4. Check Java JDK installation:"
        log_error "   - Install JDK: brew install openjdk@11"
        log_error "   - Set JAVA_HOME: export JAVA_HOME=\$(brew --prefix openjdk@11)"
        log_error ""
        log_error "5. Alternative - Desktop build only:"
        log_error "   ./build_go.sh linux macos windows"
        
        return 1
    fi
    
    rm -f ../android/app/libs/libmtorrentserver-sources.jar
    log_success "Android build completed: ../android/app/libs/libmtorrentserver.aar"
}


# Build for iOS
build_ios() {
    log_info "Building for iOS..."
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "iOS build is only possible on macOS."
        return 1
    fi
    
    # Check Xcode
    if ! command -v xcodebuild &> /dev/null; then
        log_error "Xcode is not installed."
        return 1
    fi
    
    # Check gomobile
    if ! command -v gomobile &> /dev/null; then
        log_info "Installing gomobile..."
        go install golang.org/x/mobile/cmd/gomobile@latest
        go install golang.org/x/mobile/cmd/gobind@latest
        
        # Add GOPATH/bin to PATH if necessary
        export PATH=$PATH:$(go env GOPATH)/bin
        
        # Initialize gomobile
        log_info "Initializing gomobile..."
        gomobile init -v
    fi
    
    go get -u golang.org/x/mobile
    
    log_info "Building iOS XCFramework..."
    
    mkdir -p ../ios/Frameworks
    
    # Uses same optimizations as Android for anet v0.0.5 compatibility
    gomobile bind -v -tags mobile -target=ios,iossimulator -ldflags="-s -w -checklinkname=0" -trimpath -o ../ios/Frameworks/libmtorrentserver.xcframework ./binding/mobile
    
    log_success "iOS build completed: ../ios/Frameworks/libmtorrentserver.xcframework"
}


# Show help
show_help() {
    echo "Usage: $0 [OPTIONS] [TARGETS]"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help     Show this help"
    echo "  -a, --all      Build for all supported platforms"
    echo ""
    echo "TARGETS:"
    echo "  linux          Build for Linux"
    echo "  macos          Build for macOS"
    echo "  windows        Build for Windows"
    echo "  android        Build for Android"
    echo "  ios            Build for iOS"
    echo ""
    echo "Examples:"
    echo "  $0 linux macos        # Build for Linux and macOS"
}

# Variables
BUILD_ALL=false
TARGETS=()

# Parser les arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -a|--all)
            BUILD_ALL=true
            shift
            ;;
        linux|macos|windows|android|ios)
            TARGETS+=("$1")
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main
main() {
    log_info "Starting Go build for Mangayomi"
    
    check_prerequisites
    
    if [ "$BUILD_ALL" = true ]; then
        TARGETS=("linux" "macos" "windows" "android" "ios")
    fi
    
    if [ ${#TARGETS[@]} -eq 0 ]; then
        log_warning "No target specified. Building for current platform..."
        case "$OSTYPE" in
            linux*)   TARGETS=("linux") ;;
            darwin*)  TARGETS=("macos") ;;
            msys*|win32*) TARGETS=("windows") ;;
            *)        
                log_error "Unsupported platform: $OSTYPE"
                show_help
                exit 1
                ;;
        esac
    fi
    
    # Build for each target
    for target in "${TARGETS[@]}"; do
        log_info "--- Building for: $target ---"
        case $target in
            linux)   
                if build_linux; then
                    log_success "✅ Build $target successful"
                else
                    log_error "❌ Build $target failed"
                fi
                ;;
            macos)   
                if build_macos; then
                    log_success "✅ Build $target successful"
                else
                    log_error "❌ Build $target failed"
                fi
                ;;
            windows) 
                if build_windows; then
                    log_success "✅ Build $target successful"
                else
                    log_error "❌ Build $target failed"
                fi
                ;;
            android) 
                if build_android; then
                    log_success "✅ Build $target successful"
                else
                    log_error "❌ Build $target failed"
                    log_warning "Android build may fail due to compatibility issues"
                    log_warning "Other platforms should work normally"
                fi
                ;;
            ios)     
                if build_ios; then
                    log_success "✅ Build $target successful"
                else
                    log_error "❌ Build $target failed"
                fi
                ;;
            *)       
                log_error "Unknown target: $target" 
                ;;
        esac
        echo "" # Empty line for readability
    done
    
}

# Execute main script
main "$@"
