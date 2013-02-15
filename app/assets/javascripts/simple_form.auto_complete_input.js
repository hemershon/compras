(function ($) {
  $("input[data-auto-complete]").live('focus', function () {
    var input = $(this),
        hiddenInput = $('#' + input.data("hidden-field-id"));

    input.autocomplete({
      source: input.data("source"),
      minLenght: 3,
      delay: 500,
      select: function (event, ui) {
        input.val(ui.item.label);
        hiddenInput.val(ui.item.id);
        input.trigger('change', ui.item);
      },

      response: function (event, ui) {
        $(this).removeClass("loading");
      }
    });

    input.keyup(function (event) {
      if ($(this).val() == "") {
        $(this).removeClass("loading");
      } else {
        var invalidKeys = [37, 39, 38, 40, 13, 27, 9, 16, 17, 18, 91];
        if (!_.contains(invalidKeys, event.which)){
          $(this).addClass("loading");
        }
      }
    });

    input.change(function (event, object) {
      $(this).removeClass("loading");
      if (object == null) {
        hiddenInput.val("");
      }
    });
  });
})(jQuery);
