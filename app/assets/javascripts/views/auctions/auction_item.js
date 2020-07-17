(function () {
  var Views = Compras.Views;

  Views.AuctionItem = Backbone.View.extend({
    events: {
      "change input[id$='purchase_solicitation_id']"  : "setMaterials",
      "change select[id$='purchase_solicitation_kind']" : "setMaterials",

    },

    initialize: function () {
      this.setElement($('form.auction'));

      this.eventName = 'auction';
    },

    setup: function () {
      this.$purchase_id   = this.$("input[id$='purchase_solicitation_id']");
      this.$purchase_kind = this.$("select[id$='purchase_solicitation_kind']");
      this.$material_id = this.$(".auction_material");

      this.$material_id
        .append("<a id='add_new_material' style='float:right' target='_blank' href='"+Routes.new_material+"'>Cadastrar Material</a>");
    },

    setMaterials: function () {
      if(this.$purchase_id.val() && this.$purchase_kind.val()){
        $.ajax({
          url: Routes.purchase_solicitations_api_show,
          data: {purchase_solicitation_id: this.$purchase_id.val(), by_kind: this.$purchase_kind.val()},
          dataType: 'json',
          type: 'GET',
          success: function (data) {
            var data_mustache = {
              uuid: _.uniqueId('fresh-')
            };
            var auction_id = $("#auction_id").val();
            $.each(data.items, function( index, el ){
              data_mustache['code'] =  el.material.code;
              data_mustache['material'] =  el.material.description;
              data_mustache['material_id'] =  el.material.id;
              data_mustache['detailed_description'] =  el.material.detailed_description;
              data_mustache['material_class'] =  el.material.material_class ? el.material.material_class.description : '';
              data_mustache['material_class_id'] =  el.material.material_class_id;
              data_mustache['reference_unit'] =  el.material.reference_unit ? el.material.reference_unit.acronym : '';
              data_mustache['quantity'] =  el.quantity;
              data_mustache['lot'] =  el.lot;
              data_mustache['purchase_solicitation_id'] =  el.purchase_solicitation_id;
              data_mustache['estimated_value'] =  '';
              data_mustache['max_value'] =  '';
              data_mustache['auction_id'] =  auction_id;

              $('#items-records tbody')
                .append($('#auction_items_template').mustache(data_mustache))
                .find('tr.total_summary').remove();
            });
          }
        });
      }},

  })
})();
