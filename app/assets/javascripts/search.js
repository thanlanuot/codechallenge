$(document).ready(function() {
  if($("#search_result").length){
    // initialize datatable
    search_list = $('#search_result').DataTable( {
      "searching":   false,
      "ordering": false,
      "info":     false,
      "processing": true,
      "ajax": "/searchs/call",
      columns: [
        { data: 'images' },
        { data: 'user.full_name' },
        { data: 'caption' }
      ],
      columnDefs: [{
        "targets" : 0 ,
        "render" : function ( data, type, row, meta) {
          return '<img height="'+ data.thumbnail.height + '" width="'+ data.thumbnail.width + '" src="'+data.thumbnail.url+'"/><input type="hidden" value="'+ data.standard_resolution.url + '" />';
        }
      }],
      ajax:{
        url: "/searchs/call", 
        type: "GET",
        data: function(d) {
          var address = $("#address").val();
          var lat = "";
          var lng = "";
          if(address != ""){
            var tmp = address.split(",");
            lat = tmp[0].trim();
            lng = tmp[1].trim();
          }
          d.lat = lat;
          d.lng = lng;
          d.distance = $("#distance").val();
        },
        error: function(xhr, textStatus, error){
          alert(error);
        }
      }
    });
    
    // handle search button
    $("#search").on("click", function(e){
      search_list.ajax.reload();
    });
    
    // show images in a gallery
    $("#show_gallery").on("click", function(e){
      var links = [];
      search_list.rows().iterator('row', function(context, index){
        var node = $(this.row(index).node()); 
        var a = $('input[type=hidden]', $(node.context)).val();
        links.push(a);
      });
      $('#instagram_gallery').modal('show');
      
      // initialize blueimp gallery carousel
      if(links.length != 0){
        gallery = blueimp.Gallery(links, {
          container: '#blueimp-gallery-carousel',
          carousel: true
        });
      }
    });
    
    // Choose pick location from map
    $("#pick_map").on("click", function(e){
      var address = $("#address").val();
      var lat = "";
      var lng = "";
      
      if(address != ""){
        var tmp = address.split(",");
        lat = tmp[0].trim();
        lng = tmp[1].trim();
      }else{
        get_default_location();
      }
      map_init(lat, lng);
    });
    
    // Handle entering address on Map modal
    $("#map_address").on("keydown", function(e){
      if(e.keyCode == 13){
        var address = $(this).val();
        if(address == "") return;
        
        geocoder.geocode( { 'address' : address }, function( results, status ) {
          if( status == google.maps.GeocoderStatus.OK ) {
              //In this case it creates a marker, but you can get the lat and lng from the location.LatLng
              map.setCenter( results[0].geometry.location );
              deleteMarkers();
              addMarker(results[0].geometry.location)
          } else {
              alert( 'Geocode was not successful for the following reason: ' + status );
          }
        });
      }
    });
  }
  
  // get default current location of user using html5 navigator
  function get_default_location(){
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        map.setCenter(pos);
        deleteMarkers();
        addMarker(pos);
      });
    }
  }
  
  // Initialize map when show map modal
  function map_init(lat, lng) {
    var modal_elm = $('#map_modal');
    var my_lat_lng = new google.maps.LatLng(lat, lng);
    var my_options = {
      zoom: 12,
      center: my_lat_lng
    };
    // Initialize map and relative info
    map = new google.maps.Map($('#map-canvas')[0], my_options);
    geocoder = new google.maps.Geocoder();
    markers = [];

    addMarker(my_lat_lng);
    
    // This event listener will call addMarker() when the map is clicked.
    map.addListener('click', function(event) {
      $("#map_address").val("");
      deleteMarkers();
      addMarker(event.latLng);
    });

    modal_elm.modal('show');
    
    // Handle show map modal event
    modal_elm.on('shown.bs.modal', function() {
      google.maps.event.trigger(map, 'resize');
      map.setCenter(my_lat_lng);
    });
  
    // Handle close map modal event
    modal_elm.on('hide.bs.modal', function() {
      var address = markers[0].position.lat() + "," + markers[0].position.lng();
      console.log("hide modal", address);
      $("#address").val(address);
  		$('#map-canvas').html('');
    })
  }
  
  // Adds a marker to the map and push to the array.
  function addMarker(location) {
    var marker = new google.maps.Marker({
      position: location,
      map: map
    });
    markers.push(marker);
  }

  // Sets the map on all markers in the array.
  function setMapOnAll(map) {
    for (var i = 0; i < markers.length; i++) {
      markers[i].setMap(map);
    }
  }
  
  // Deletes all markers in the array by removing references to them.
  function deleteMarkers() {
    setMapOnAll(null);
    markers = [];
  }
});