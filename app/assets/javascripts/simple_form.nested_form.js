(function ($) {
  /**
   * Nested forms v0.0.2
   *
   * Example:
   *
   *   $("selector-of-template").nestedForm({
   *     add: "selector-of-add-button",
   *     remove: "selector-of-remove-button",
   *     target: "selector-of-target",
   *     uuid: "uuid_name"
   *   });
   */
  $.fn.nestedForm = function (options) {
    var template = $(this);
    var defaults = {
      add: '.add',
      remove: '.remove',
      fieldToRemove: 'fieldset',
      hiddenDestroyInput: 'input.hidden.destroy',
      target: '#targe',
      uuid: 'uuid',
      right: false
    };
    var options = $.extend({}, defaults, options);

    var displayFirstLabel = function() {
      $('.nested input:visible:first').closest('.nested').find('label').show();
      $('.nested input:visible:first').closest('.nested').find('.nested-remove').css('padding-top', '30px');
    }

    var hideLabel = function(label) {
      $(label).hide();
      $(label).closest('.nested').find('.nested-remove').css('padding-top', '4px');
    }

    if (options.right) {
      hideLabel($('.nested label'));
      displayFirstLabel();
    }

    $('body').delegate(options.add, 'click', function () {
      var binds = {};
      binds[options.uuid] = _.uniqueId('fresh-');

      $(options.target).append(template.mustache(binds));
      if (options.right) {
        displayFirstLabel();
        var labels = $('.nested label:visible');
        if (labels.length > 0) {
          $.each(labels, function(index, value) {
            if ( index != 0) {
              hideLabel(this);
            }
          });
        }
      }
    });

    $(options.target).delegate(options.remove, 'click', function () {
      if (options.right) {
        displayFirstLabel();
      }
      $(this).closest(options.fieldToRemove).hide().find(options.hiddenDestroyInput).val('true');
    });
  };
})(jQuery);
