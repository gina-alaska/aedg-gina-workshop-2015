class BaseOptionsBuilder
  @build: (params = {}, opts = {}) ->
    opts.style = L.mapbox.simplestyle.style
    opts.attribution = params.attribution
    opts

class CustomPopup extends BaseOptionsBuilder
  @build: (params = {}, opts = {}) ->
    opts = super(params, opts)

    if params.popup?
      opts.onEachFeature = (feature, layer) ->
        layer.bindPopup(L.mapbox.template(params.popup, feature.properties))

    opts

class CustomMarker extends CustomPopup
  @build: (params = {}, opts = {})->
    opts = super(params, opts)

    params.markerLabelField ||= 'title'
    params.iconSize ||= [30,30]
    params.iconClass ||= 'circle-marker'

    opts.pointToLayer = (feature, ll) ->
      feature.properties['marker-color'] ||= '#555'
      params.color = feature.properties['marker-color'] || '#00f'
      if params.hideMarkerLabel or !feature.properties[params.markerLabelField]?
        label = ''
      else
        label = feature.properties[params.markerLabelField]

      L.marker(ll, {
        icon: L.divIcon({
          className: "",
          html: "
            <div class='marker_#{feature.properties['id']} #{params.iconClass}' style='background: #{params.color}'>
              <div class='marker-label'>#{label}</div>
            </div>",
          iconSize: params.iconSize
        })
      })
    opts

class CustomStyle extends CustomMarker
  @build: (params = {}, opts={}) ->
    opts = super(params, opts)

    opts.style = (feature) ->
      return { fillOpacity: 0, color: '#009933' }
    opts

class Layer
  @geojson_options: {
    'custom-marker': CustomMarker.build,
    'custom-popup': CustomPopup.build
    'custom-style': CustomStyle.build
  }

  @register_geojson_options_builder: (name, klass) ->
    Layer.geojson_options[name] = klass

  @fetch_geojson_options_builder: (name, options) ->
    Layer.geojson_options[name](options)

  @valid_geojson_options_builder: (name) ->
    Layer.geojson_options[name]?

  @next_page: (uri) ->
    url = new URI(uri)
    data = url.search(true)
    @url_defaults(uri, { page: parseInt(data.page) + 1 || 1 })

  @url_defaults: (uri, defaults = nil) ->
    url = new URI(uri)

    data = url.search(true)
    params = $.extend(data, defaults) if defaults?

    url.search(params)
    url.toString()


  @get_geojson_layer: (config = {}) ->
    featureLayer = L.mapbox.featureLayer(@url_defaults(config.url, { limit: 500 }))

    if config.paged?
      config.url = @next_page(config.url)

    if @valid_geojson_options_builder(config.geojsonOptions)
      geojson = L.geoJson(
        null,
        @fetch_geojson_options_builder(config.geojsonOptions, config)
      )
    else
      geojson = L.geoJson(
        null,
        @fetch_geojson_options_builder('custom-popup', config)
      )

    featureLayer.on 'ready', ->
      geojson.addData(this.getGeoJSON())
      geojson.fire('ready')

    geojson

  @load: (el, parent) ->
    config = @config_from_element(el)

    if config.cluster
      cluster = @cluster_layer(config)
      cluster.addTo(parent)
      @build_layer(config, cluster)
    else
      @build_layer(config, parent)


  @build_layer: (config, parent) ->
    layer = @get_geojson_layer(config)
    layer.on 'ready', =>
      layer.addTo(parent)
      if config.paged? && layer.getLayers().length > 0
        @build_layer(config, parent)


  @config_from_element: (el) ->
    config = $(el).data()
    config.attribution = $(el).find('attribution').html()

    if $(el).find('popup').length > 0
      config.popup = $(el).find('popup').html()

    config

  @cluster_layer: (config = {}) ->
    config = $.extend({ maxClusterRadius: 20 }, config)

    new L.MarkerClusterGroup(config)

  @zoomTo: (map, layer, max = 10) ->
    map.whenReady =>
      bounds = layer.getBounds()
      if bounds.isValid()
        map.fitBounds(layer.getBounds(), { padding: [30,30], maxZoom: max })


$(document).on 'ready page:load init_map', ->
  mapel = $('[data-behavior="map"]')

  if mapel.length > 0
    config = mapel.data()
    L.mapbox.accessToken = config.accessToken || 'pk.eyJ1IjoiZ2luYS1hbGFza2EiLCJhIjoiN0lJVnk5QSJ9.CsQYpUUXtdCpnUdwurAYcQ';
    @map = L.mapbox.map(mapel.data('target'), config.mapboxId, config);
    mapel.data('map', @map)

    attribution = mapel.find('attribution')
    if attribution.length > 0
      config.attribution = attribution.html()

    @map.attributionControl.addAttribution(config.attribution)

    if config.cluster
      @group = Layer.cluster_layer(config)
    else
      @group = L.featureGroup(config)

    @group.addTo(@map)

    for el in mapel.find('layer')
      layer = Layer.load(el, @group)
      if $(el).data('fit')
        layer.on 'ready', =>
          Layer.zoomTo(@map, layer, $(el).data('maxZoom'))

    setTimeout(=>
      Layer.zoomTo(@map, @group, config.maxZoom) if config.fitAll
    , 1000)
