//= require modal_filter

function setModalUrlToPurchaseSolicitation() {
    var selector_licitation_process_id = '#supply_order_licitation_process_id'
    var selector_purchase_solicitation_modal = '#supply_order_purchase_solicitation'

    setModalUrlToPurchaseSolicitationByLicitationProcess(selector_licitation_process_id, selector_purchase_solicitation_modal)
}

function setModalUrlToPurchaseForm() {
    var urlModal = Routes.modal_purchase_forms,
        params = {
            by_purchase_solicitation: $('#supply_order_purchase_solicitation_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#supply_order_purchase_form').data('modal-url', urlModal);
}

function setModalUrlToCreditor() {
    var urlModal = Routes.modal_creditors,
        params = {
            by_ratification_and_licitation_process_id: $('#supply_order_licitation_process_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#supply_order_creditor').data('modal-url', urlModal);
}

function setPledgeSource() {
    var url = Routes.pledges,
        params = {
            by_purchase_process_id: $('#supply_order_licitation_process_id').val()
        };

    url += "?" + $.param(params);
    $('#supply_order_pledge').data('source', url);
}

function getPledgeItems(pledgeId) {
    var pledgeItemsUrl = Routes.pledge_items,
        params = {
            by_pledge_id: pledgeId
        };

    $.getIndex(pledgeItemsUrl, params, function (pledge_items) {
        fillSupplyOrderQuantities(pledge_items);
    });
}

function fillSupplyOrderQuantities(pledge_items) {
    var target = $('div#supply_order_items'),
        templateValue = $('#supply_order_items_value_template'),
        templateQuantity = $('#supply_order_items_quantity_template');

    target.empty();

    _.each(pledge_items, function (pledge_item) {
        var defaults = {uuid_item: _.uniqueId('fresh-')};
        var options = $.extend({}, defaults, pledge_item);

        if (pledge_item.service_without_quantity) {
            target.append(templateValue.mustache(options));
        } else {
            target.append(templateQuantity.mustache(options));
        }
    });
}

function setDepartment() {
    var purchase_solicitation_id = $('#supply_order_purchase_solicitation_id').val()

    if (purchase_solicitation_id) {
        $.ajax({
            url: Routes.purchase_solicitation_department,
            data: {purchase_solicitation_id: purchase_solicitation_id},
            dataType: 'json',
            type: 'GET',
            success: function (data) {
                $('#purchase_solicitation_department').val(data["description"]);
            }
        });
    }
}

function setMaterialTotalAndBalance() {
    var licitation_process_id = $('#supply_order_licitation_process_id').val()
    var material_id = $('#supply_order_material_id').val()
    var purchase_solicitation_id = $('#supply_order_purchase_solicitation_id').val()
    var contract_id = $('#supply_order_contract_id').val()
    var supply_order_id = $(window.location.href.split("/")).get(-2)
    var quantity = $('#supply_order_quantity').val()

    if (licitation_process_id && purchase_solicitation_id && material_id && quantity) {
        $.ajax({
            url: Routes.licitation_process_material_total_balance,
            data: {
                licitation_process_id: licitation_process_id,
                material_id: material_id,
                purchase_solicitation_id: purchase_solicitation_id,
                supply_order_id: supply_order_id,
                contract_id: contract_id,
                quantity: quantity
            },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $('#supply_order_balance').val(data["balance"]);
            }
        });
    }
}

function hasItemAlreadyAdded(item) {
    var added = false;
    $("table#items-records input.material-id").each(function () {
        if ($(this).val() == item.material_id) {
            added = true;
            return added;
        }
    });
    return added;
}

function mergeItem(item) {
    var record = $('tr#material-id-' + item.material_id);
    var quantity = record.find('input.quantity').val();
    var totalQuantity = parsePtBrFloat(quantity) + item.quantity;

    record.find("td.quantity").text(totalQuantity);
    record.find('input.quantity').val(totalQuantity);

}

function renderItem(item) {

    var itemBinds = {
        uuid: _.uniqueId('fresh-'),
        id: '',
        material_id: item.material_id,
        material: item.material.code + " - " + item.material.description,
        quantity: item.quantity

    };

    var data = $('#supply_order_items_template').mustache(itemBinds);

    $('#items-records tbody').append(data).trigger("nestedGrid:afterAdd");
}


$(document).ready(function () {
    setModalUrlToPurchaseForm();
    setModalUrlToCreditor();
    setPledgeSource();
    setModalUrlToPurchaseSolicitation();
    setMaterialTotalAndBalance();

    $('form.supply_order').on('change', '#supply_order_purchase_solicitation_id', function () {
        setDepartment();
        setModalUrlToPurchaseForm();
    });

    $('form.supply_order').on('change', '#supply_order_quantity', function () {
        setMaterialTotalAndBalance();
    });

    $('form.supply_order').on('change', '#supply_order_material_id', function () {
        setMaterialTotalAndBalance();
    });

    $('form.supply_order').on('change', '#supply_order_licitation_process_id', function () {
        setModalUrlToCreditor();
        setPledgeSource();
        setModalUrlToPurchaseSolicitation();
        setMaterialTotalAndBalance();
    });

    $('#supply_order_licitation_process').on('change', function (event, licitation_process) {
        if (licitation_process) {
            $("#supply_order_modality_or_type_of_removal").val(licitation_process.modality_or_type_of_removal);
            $("#supply_order_purchase_solicitation").attr('disabled', false);
        } else {
            $("#supply_order_modality_or_type_of_removal, #supply_order_creditor,#supply_order_purchase_solicitation_id").val('');
        }
    });

    $('#supply_order_pledge_id').on('change', function (event, pledge) {
        if (pledge) {
            getPledgeItems(pledge.id);
        }
    });

    if ($("#supply_order_updatabled").prop("checked")) {
        $(".edit-nested-record").attr('class', "edit-nested-record hidden")
        $(".remove-nested-record").attr('class', "remove-nested-record hidden")
    }

    $(".supply_order_submit_close").attr('data-disabled', "Desabilitado");

    $("#supply_order_contract_id").on("change", function (event, contract) {
        $("#supply_order_creditor").val(contract ? contract.creditor : '');
    });

    $(".supply_order_submit_close").click(function () {
        $("#supply_order_updatabled").prop('checked', true);
    });

    $("#supply_order_invoices_adicionar").on("click", function () {
        if (!$('#supply_order_updatabled').is(':checked')) {
            $(".supply_order_submit_close").removeAttr('data-disabled');
        }
    });

    $("#supply_order_requests_adicionar").on("click", function () {
        var supply_request_ids = []
        $("table#supply_order_requests-records input.supply_request-id").each(function () {
            supply_request_ids.push($(this).val())
        });

        $.ajax({
            url: Routes.supply_requests_api_show,
            data: {supply_request_ids: supply_request_ids},
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $.each(data, function (i, supply_request) {
                    $.each(supply_request.items, function (i, item) {
                        console.log(item)
                        if (hasItemAlreadyAdded(item)) {
                            mergeItem(item);
                        } else {
                            renderItem(item);
                        }
                    });
                });

            }
        });

    });

});
