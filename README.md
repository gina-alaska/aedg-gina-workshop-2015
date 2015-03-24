# AEDG, GINA, AEDI Workshop 2015

This is a very basic web map that provides a static snapshot of Locations from the AEDG and some PCE information.

# Thanks

To everyone who participated in the workshop!

# Clarifications of this demo:

The live demo hosted on Heroku.

http://aedg-gina-workshop-2015.gina.alaska.edu/

Notes about the demo:

* Any site with PCE data loaded will have the marker show up as a red circle.  More details could be added if gnis_feature_id details are provied. There is still plenty of space available in the database for more sites.

A random set of communities, in red, have a fuller import of data for it. Not all locations can be loaded because of limitations from the free tier of heroku.Changing the colors for the points is pretty easy just need to modify the color code in the public/aedg.geojson file

Github even does some basic previews of geojson files
https://github.com/gina-alaska/aedg-gina-workshop-2015/blob/master/public/aedg.geojson
