# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.3.2+1 - 2021-09-23
### Changed
- upgrade to Fluter 2.5.1

## 0.3.2 - 2021-07-12
### Added
- Allow scroll-to animation curve and duration to be specified

## 0.3.1 - 2021-04-21
### Added
- Added `draggedItemBuilder` allowing you to build the widget that's being dragged

## 0.3.0 - 2021-04-08
### Added
- #### BREAKING

    `maxNumberItems` can be used to limit the number of items in a carousel (this used to be implicitly set to 10). If not set you can add unlimited number of items.


### Changed
- addItemAt can now return a bool. Returning true or null indicates that an item was added and that the selected item should be updated. Returning false means that the item ended up not being added, and thus selected item shouldn't be updated.

    Seeing as null is an appropriate return value, this won't be a breaking change.


## 0.2.0 - 2021-03-31
### Changed
- addItemAt can now be used async. Meaning that onItemSelected won't be called until it completes

## 0.2.0-nullsafety - 2021-03-24
### Changed
- Null safety

## 0.1.1 - 2021-03-24
### Added
- Add parameter `itemWidthFraction` to control how item width is calculated

### Changed
- Change scroll calculation to accommodate non-fixed item fraction

### Fixed
- Scroll to item getting used on wrong gesture

## 0.1.0+2 - 2021-03-23
### Fixed
- Fix clicking on item not scrolling to said item

## 0.1.0+1 - 2021-03-23
### Changed
- Fix image url in readme
- Update pubspec description

## 0.1.0 - 2021-03-23
### Added
- Initial release of package