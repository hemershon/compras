//= require big
//= require underscore
//= require jquery
//= require jquery.ui
//= require jquery.masked_input
//= require jquery.mustache
//= require jquery.price_format
//= require simple_form.datepicker_input
//= require simple_form.decimal_input
//= require simple_form.masked_input
//= require simple_form.modal_input
//= require simple_form.nested_form
//= require rails
//= require tributario
//= require filter
//= require currency_manipulation
//= require date
//= require modal_info_link
//= require only_numbers

$(':input[data-property-id]').live('change', function() {
  var property = $(this);
  $(':input[data-dependency-id=' + property.data('property-id') + ']').each(function() {
    dependency = $(this);

    // Verify when dependecy is an collection
    if (dependency.data('dependency') != property.data('property-id') && dependency.data('dependency') == property.val()) {
      dependency.attr("disabled", false);
    } else {
      // Verify when dependency is not an collection
      if (dependency.data('dependency') == dependency.data('dependency-id') && dependency.data('dependency') == property.data('property-id') && property.val() != "") {
        dependency.attr("disabled", false);
      } else {
        dependency.attr("disabled", true);
      }
    }
  });
});

$(".clear").live('click', function() {
  $(this).closest(".modal-finder").find("input.modal").val("");
})

$(".modal-finder-remove").live("click", function () {
  $(this).closest("tr").remove();
});

$(".modal-finder .modal input.modal").live("change", function(event, data) {
  var id = $(this).attr("id");
  var template = "#" + id + "_template";
  var record = data.record;
  var defaults = {
    index: _.uniqueId('fresh-'),
    uuid: _.uniqueId('fresh-')
  }

  var options = $.extend({}, defaults, record.data());

  if ($("#" + id + "_record_" + record.data("id") + '_id').length == 0 ) {
    $("." + id + "_records").append($(template).mustache(options)).trigger('append.mustache');
  }

  $(this).val('');
});

$(".included").live('click', function() {
  if ($(this).attr("checked")) {
    $(".destroy").val("false");
  } else {
    $(".destroy").val("true");
  }
});

$(function(){
  $('.tabs').tabs({
    create: function () {
      var tabWithError = $('.ui-tabs-panel:has(.error)', this).attr('id');

      if (tabWithError) {
        $(this).tabs('select', tabWithError);
      }
    }
  });
});
