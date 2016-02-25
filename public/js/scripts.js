console.log('foood');

$(function(){
  setSearchHandler();
  initMap(initMapOptions);
});

function getVenues(search){
  var center = getCenter();
  var url = 'search/' + search + '/' + center; 
  $.ajax({
    method: 'get',
    url: url, 
    success: function(response){
      var venues = response;
      var heatPoints = [];
      for (var i = 0, l = venues.length; i < l; i++) {
        var lat = venues[i].venue.location.lat;
        var lng = venues[i].venue.location.lng;
        heatPoints.push(new google.maps.LatLng(lat, lng));
      }
      console.log('heatpoints.length: ', heatPoints.length);
      newHeatmap(heatPoints);
    }
  });
}

function setSearchHandler(){
  $('#search').keydown(function(e){
    if(e.keyCode===13){
      e.preventDefault();
      search = $('#search').val();
      getVenues(search);
      $('#search').val('');
      $('#current-map').text(search);
    }
  });
}

var initMapOptions = {
  center: {               
    lat: 40.7164175,      
    lng: -73.9392051      
  },                      
  scrollwheel: true,      
  zoom: 11,               
  mapTypeControl: false
};

var map, heatmap;

// initial map options
function initMap(mapOptions) {

  map = new google.maps.Map(document.getElementById('map'), mapOptions);
  map.mapTypes.set(customMapTypeId, mapStyle);
  map.setMapTypeId(customMapTypeId);
}

function getCenter(){
    var center = map.getCenter();
    var lat = center.lat();
    var lng = center.lng();
    var mapCenter = lat + "," + lng;
    return mapCenter;
}
  

function newHeatmap(heatPoints){
  clearHeatMap();
  heatmap = new google.maps.visualization.HeatmapLayer({
    data: heatPoints,
    map: map
  });
}

function clearHeatMap(){
  if(heatmap){
    heatmap.setMap(null);
  }
}
