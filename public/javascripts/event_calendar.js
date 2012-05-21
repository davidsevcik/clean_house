/*
 * Smart event highlighting
 * Handles when events span rows, or don't have a background color
 */
jQuery(document).ready(function($) {
  // highlight events that have a background color
  $(".ec-event-bg").live("mouseover", function() {
    event_id = $(this).attr("data-event-id");
		event_class_name = $(this).attr("data-event-class");
    $(".ec-"+event_class_name+"-"+event_id).addClass("ec-hover");
  });
  $(".ec-event-bg").live("mouseout", function() {
    event_id = $(this).attr("data-event-id");
		event_class_name = $(this).attr("data-event-class");
    event_color = $(this).attr("data-color");
    $(".ec-"+event_class_name+"-"+event_id).removeClass("ec-hover");
  });
});