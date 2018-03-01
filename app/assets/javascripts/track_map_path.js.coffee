#= require 'moment'

map = undefined
info_window = undefined

display_marker = (marker) ->
  marker.object.setMap map
  map.setZoom 18
  map.setCenter marker.object.getPosition()
  info_window.setContent(marker.info)
  info_window.open(map, marker.object)

App.initialize_map = () ->
  UNIVERSITY_PARK = { latitude: 40.7982133, longitude: -77.8599084 }

  google.maps.Polyline::getBounds = ->
    bounds = new (google.maps.LatLngBounds)
    @getPath().forEach (item, index) ->
      bounds.extend new (google.maps.LatLng)(item.lat(), item.lng())
      return
    bounds

  default_map_center = new (google.maps.LatLng)(UNIVERSITY_PARK.latitude, UNIVERSITY_PARK.longitude)

  map_options =
    center: default_map_center
    zoom: 15
    mapTypeId: 'terrain',
    fullscreenControl: false
    mapTypeControlOptions:
      position: google.maps.ControlPosition.TOP_RIGHT


  map = new (google.maps.Map)(document.getElementById('g-map'), map_options)
  info_window = new (google.maps.InfoWindow)(map: map)

  track_id = $('#track-show-container').data('track-id')
  data = $.ajax('/user/tracks/' + track_id + '.json',
    async: false
    dataType: 'json'
    success: (data) ->
      # console.log data
  )

  path = google.maps.geometry.encoding.decodePath(data.responseJSON.polyline)
  path_options =
    path: path
    strokeColor: '#1c67e3'
    strokeWeight: 5
    strokeOpacity: 0.8
    geodesic: true
    map: map
  polyline = new (google.maps.Polyline)(path_options)
  map.fitBounds(polyline.getBounds(), 0)
  polyline.setMap(map)

  markers = []
  data.responseJSON.points.forEach (point, index) ->
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(point.latitude, point.longitude)
      label:
        text: String(index + 1)
        color: 'white'
        fontSize: '10px'
    )
    recorded_date = moment(point.recorded_at)
    formatted_date_time = '<h3 class="date">' + recorded_date.format("MMMM Do, Y") + '</h3><p class="time">' + recorded_date.format("h:mm:ss a") + '</p>'
    content = '<div class="point-info-window">' + formatted_date_time + '<table class="table table-striped attributes-table"><tbody><tr><th scope="row">Lat, Lng</th><td>' + point.latitude + ', ' + point.longitude + '</td></tr><tr><th scope="row">Elevation (m)</th><td>' + point.elevation_in_meters + '</td></tr></tbody></table></div>'
    markers[point.id] = { object: marker, info: content}
    marker.addListener 'click', (event) ->
      display_marker(markers[point.id])

  $('.map-point').on 'click', (event) ->
    event.preventDefault()

    markers.forEach (m) ->
      m.object.setMap null

    id = parseInt($(this).data('id'))
    display_marker(markers[id])

