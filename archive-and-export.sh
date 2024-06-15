# For your convenience
alias PlistBuddy=/usr/libexec/PlistBuddy

USAGE="Usage: ./archive-and-export.sh [CAT | DOG]\n
    CAT - archives and exports an app with a list of cats\n
    DOG - archives and exports an app with a list of dogs"

# IMPLEMENT: 
# Read script input parameter and add it to your Info.plist. Values can either be CATS or DOGS

if [[ $1 == DOG || $1 == CAT ]]; then
  INFO_PLIST="./CatsAndModules_SofiiaBudilova/CatsAndModules-SofiiaBudilova-Info.plist"
  PlistBuddy -c "set :CatOrDog $1" $INFO_PLIST

else
  echo $USAGE
  exit 1
fi


# IMPLEMENT: 
# Write values to exportOptionsPlist

cp exportOptionsTemplate.plist exportOptionsTemplate_temp.plist

EXPORT_OPTIONS_PLIST="exportOptionsTemplate_temp.plist"
PlistBuddy -c "set :destination export" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :method development" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :signingStyle manual" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :teamID D85QWSUNYA" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "set :signingCertificate iPhone Developer: Sofiia Budilova (P4TRV9PV5G)" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "delete provisioningProfiles:%BUNDLE_ID%" $EXPORT_OPTIONS_PLIST
PlistBuddy -c "add :provisioningProfiles:ua.edu.ukma.apple-env.budilova.CatsAndModules-SofiiaBudilova string 1d613491-c747-433a-81d3-283fb4aa46f4" $EXPORT_OPTIONS_PLIST

# IMPLEMENT:
# Clean build folder
WORKSPACE=CatsAndModules_SofiiaBudilova.xcworkspace
SCHEME=CatsAndModules_SofiiaBudilova
CONFIG=Debug
DEST="generic/platform=iOS"

xcodebuild clean -workspace "${WORKSPACE}" -scheme "${SCHEME}" -configuration "${CONFIG}"

# IMPLEMENT:
# Create archive
VERSION="v1.0.0"
ARCHIVE_FOLDER="./Archives"
ARCHIVE_PATH="${ARCHIVE_FOLDER}/${VERSION}.xcarchive"

xcodebuild archive \
-archivePath "${ARCHIVE_PATH}" \
-workspace "${WORKSPACE}" \
-scheme "${SCHEME}" \
-configuration "${CONFIG}" \
-destination "${DEST}"

# IMPLEMENT:
# Export archive
if [ "$1" == "CAT" ]; then
    EXPORT_PATH="Exported_CATS"
elif [ "$1" == "DOG" ]; then
    EXPORT_PATH="Exported_DOGS"
else
    echo $USAGE
    exit 1
fi

xcodebuild -exportArchive \
-archivePath "${ARCHIVE_PATH}" \
-exportPath "${EXPORT_PATH}" \
-exportOptionsPlist "${EXPORT_OPTIONS_PLIST}"

# IMPLEMENT:
# Delete temporary files and folders
rm -r $ARCHIVE_FOLDER
rm $EXPORT_OPTIONS_PLIST

echo "End of script"
