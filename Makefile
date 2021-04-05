generate:
	swift package generate-xcodeproj
	open ./KhaleeesiBot.xcodeproj

release:
	swift build -c release
