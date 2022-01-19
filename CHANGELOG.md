## 0.0.7

* Add `imageHeight` and `imageWidth` attributes if you know exactly the real height and real width of the background map image
* Add `backgroundImageWidget` attributes if you need to pass the background as widget (Ex. if you need to use your own image widget instead of Image.asset)
* Fix some responsiveness issues on small phones

## 0.0.6

* Add compatibility for `Linux` and `MacOS`
* Add 'isCurrent' attribute to PointModel which make the scorlling map scroll to a specific point like the current level in games

## 0.0.5

* Add compatibility for `Web` and `Windows`

## 0.0.4

* Add 2 optional parameters `pointsPositionDeltaX` and `pointsPositionDeltaY` to manually adjust the points in case of the points is shifted in `x` or `y` axis

## 0.0.3

* Game levels map like candy crush with the following features :
  - Option to make it horizontal map or vertical
  - Option to reverse the scrolling start direction
  - Option to add the x,y points positions
  - Option to extract the x,y points positions from asset SVG file or online SVG file