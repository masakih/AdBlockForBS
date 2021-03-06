// encoding=utf-8
PRODUCT_NAME=AdBlockForBS
PRODUCT_EXTENSION=bundle
BUILD_PATH=./build
DEPLOYMENT=Release
APP_BUNDLE=$(PRODUCT_NAME).$(PRODUCT_EXTENSION)
APP=$(BUILD_PATH)/$(DEPLOYMENT)/$(APP_BUNDLE)
APP_NAME=$(BUILD_PATH)/$(DEPLOYMENT)/$(PRODUCT_NAME)
SCHEME=AdBlockForBS
INFO_PLIST=AdBlockForBS/Info.plist

LOCALIZE_FILES=

VER_CMD=grep -A1 'CFBundleShortVersionString' $(INFO_PLIST) | tail -1 | tr -d "'\t</string>" 
VERSION=$(shell $(VER_CMD))

all: package

Localizable: $(LOCALIZE_FILES)
	genstrings -o KCD/ja.lproj $^
	(cd KCD/ja.lproj; ${MAKE} $@;)
#	genstrings -o KCD/en.lproj $^
#	(cd KCD/en.lproj; ${MAKE} $@;)

checkLocalizable:
#	(cd KCD/en.lproj; ${MAKE} $@;)
	(cd KCD/ja.lproj; ${MAKE} $@;)

deploy:
	test -z "`git status --porcelain`"

release: updateRevision
	xcodebuild -derivedDataPath=build -configuration $(DEPLOYMENT)
	$(MAKE) restoreInfoPlist

package: deploy release
	REV=`git show | head -1 | awk '{printf("%.7s\n", $$2)}'`;	\
	ditto -ck -rsrc --keepParent $(APP) $(APP_NAME)-$(VERSION)-$${REV}.zip

updateRevision:
	if [ ! -f $(INFO_PLIST).bak ] ; then cp $(INFO_PLIST) $(INFO_PLIST).bak ; fi ;	\
	REV=`git show | head -1 | awk '{printf("%.7s\n", $$2)}'` ;	\
	sed -e "s/%%%%REVISION%%%%/$${REV}/" $(INFO_PLIST) > $(INFO_PLIST).r ;	\
	mv -f $(INFO_PLIST).r $(INFO_PLIST) ;	\

restoreInfoPlist:
	if [ -f $(INFO_PLIST).bak ] ; then mv -f $(INFO_PLIST).bak $(INFO_PLIST) ; fi


