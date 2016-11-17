// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
$(document).on('turbolinks:load', function() {
    $('#show-measurements').on('click', showMeasurements);
    $('#show-goals').on('click', showGoals);
    $('.wobtn').on('click', markComplete);
    $('#show-progress').on('click', showProgress);
    $('.day-button').on('click', showDay)
});

var showMeasurements = function(event){
  event.preventDefault();
  console.log("Meas");
  $('#graphs-div').hide();
  $('#mlist').show();  
  $('#glist').hide();
};

var showGoals = function(event){
  event.preventDefault();
  console.log("Goal");
  $('#graphs-div').hide();
  $('#mlist').hide();  
  $('#glist').show();
};

var showProgress = function(event){
  event.preventDefault();
  console.log("progress");
  $('#graphs-div').show();
  $('#mlist').hide();  
  $('#glist').hide();
};

var markComplete = function(event){
  event.preventDefault();
  console.log(this);
  var that = $(this).find('.complete-check');
  var userId = $(this).find('.complete-check').attr('name');
  var id = $(this).find('.complete-check').attr('id');
  var url = '/users/' + userId + '/workouts/' + id
  console.log(url);
  $.ajax({
    url: url,
    method: "PATCH",
    context: that
  }).success(function(data){
    console.log(data);
    if (data) {
      this.prop('checked', true);
    } else {
      this.removeAttr('checked');
    }
    // $(this).hide();
    // $(this).parent().css('class', 'list-group-item list-group-item-success');
  }).fail(function(data){
    console.log(data);
  });
};

var showDay = function(event){
  event.preventDefault();
  var dayContainer = $(this).parent();
  dayContainer.find(".workout-info").toggle();
}
