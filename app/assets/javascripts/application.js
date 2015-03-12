// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap/dist/js/bootstrap
//= require leaflet.markercluster/dist/leaflet.markercluster
//= require handlebars/handlebars
//= require uri.js/src/URI
//= require_tree .

function startMapbox(mapEl) {
  // Provide your access token
  L.mapbox.accessToken = 'pk.eyJ1IjoiZ2luYS1hbGFza2EiLCJhIjoiN0lJVnk5QSJ9.CsQYpUUXtdCpnUdwurAYcQ';
  // Create a map in the div #map
  var map = L.mapbox.map(mapEl.data('target'), 'gina-alaska.k1844km2');

  mapEl.find('wms').each(function(index, wmsEl) {
    var url = $(wmsEl).data('url');
    var layers = $(wmsEl).data('layers');

    var layer = new L.TileLayer.WMS(url,{ layers: layers });

    layer.addTo(map);
  });

  mapEl.find('geojson').each(function(index, geojsonEl) {
    var url = $(geojsonEl).data('url');
    var layer = L.mapbox.featureLayer(url);
    layer.addTo(map);

    if ($(geojsonEl).data('fit')) {
      layer.on('ready', function() {
        map.fitBounds(layer.getBounds());
      });
    }
  });
}

$(document).on('ready', function() {
  var mapEl = $('jsmap');
  if (mapEl.length > 0) {
    startMapbox(mapEl);
  }
})
