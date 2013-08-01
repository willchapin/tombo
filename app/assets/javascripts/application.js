// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){

  // Header dropdown menu ------------------------------------
  $(".dropdown-toggle").click(function(event){
    $("ul.dropdown").toggleClass("show");
    event.stopPropagation();
  });


  $('html').click(function(){
    $("ul.dropdown").removeClass("show"); 
  });


  // Audio player -------------------------------------
  
	var tracks = $('audio');		
  
  $(".play").click(function(){
    pauseAll(tracks);
    $(this).parent("li.track").addClass("playing");
    $(this).siblings("audio").get(0).play();
    $(this).siblings(".pause").show();
    $(this).hide();
 	});

  $(".pause").click(function(){
    $(this).siblings("audio").get(0).pause();
    $(this).siblings(".play").show();
    $(this).hide();
  });

  $("audio").on('timeupdate', function() {	
    var progressRatio = this.currentTime/this.duration;
    var progressBar = $(this).siblings(".progress-bar");
    var progress = progressBar.children(".progress");
    progress.width(progressBar.width() * progressRatio);
    updateThisTimer($(this));
  });

  $(".progress-bar").click(function(event){ 
    var offset = $(this).offset().left;
    var progressWidth = event.pageX - offset;
    var fullWidth = $(this).width()
    $(this).children(".progress").width(progressWidth);
    var track = $(this).siblings("audio").get(0);
    setTrackTime(track, progressWidth/fullWidth);
  });

  function setTrackTime(track, progress) {
    track.currentTime = track.duration * progress;
  }

  // takes jQuery object eg: $('track')
  function pauseAll(tracks) {
    for(i = 0; i < tracks.length; i++) {
      $(tracks.get(i)).parent("li.track").removeClass("playing");
      tracks.get(i).pause();
    }
    $(".pause").hide();
    $(".play").show();
  }

  function updateThisTimer(audio) {
    var timer = audio.siblings(".timer");
    var elapsedTime = audio.get(0).currentTime;
    var duration = audio.get(0).duration;
    timer.html(prettyTime(elapsedTime) + " / " + prettyTime(duration));
  }

  function prettyTime(totalSeconds) {
    var minutes = Math.floor(totalSeconds/60);
    var remainingSeconds = ("0" + Math.floor(totalSeconds % 60)).slice(-2);
    return "" + minutes + ":" + remainingSeconds;
  }

  function initializeTimers() {
    $('audio').each(function() {
      updateThisTimer($(this));
    })
  }

  //initializeTimers();



});
