function hasItemAlreadyAdded(item) {
    var added = false;
    $("table#authorized_areas-records input.department-id").each(function () {
        console.log(item)

        if ($(this).val() == item.id) {
            added = true;
            return added;
        }
    });
    return added;
}

function mergeItem(item) {
    var record = $('tr#department-id-' + item.id);
    var department = record.find('input.department').val();

    record.find("td.department").text(department);
    record.find('input.department').val(department);
}

function renderItem(item) {
    console.log()
    var itemBinds = {
        uuid: _.uniqueId('fresh-'),
        id: '',
        department_id: item.id,
        department: item.value
    };

    var data = $('#contract_departments_template').mustache(itemBinds);
    $('#authorized_areas-records tbody').append(data).trigger("nestedGrid:afterAdd");
}

$(document).ready(function () {
    $("#add_all_departments").on("click", function () {
        var secretary_id = $("#contract_secretary_id").val()
        if (secretary_id) {
            $.ajax({
                    url: Routes.departments,
                    data: {by_secretary: secretary_id},
                    dataType: 'json',
                    type: 'GET',
                    success: function (data) {
                        $.each(data, function (i, supply_request) {
                            if (hasItemAlreadyAdded(supply_request)) {
                                mergeItem(supply_request);
                            } else {
                                renderItem(supply_request);
                            }
                        });
                    }
                }
            );
        }
    });

  $("#contract_secretary_id2").change(function(){
    var params = {},
      url = Routes.expenses;

    params = {
      by_secretary: $(this).val()
    };

    url += "?" + $.param(params);

    $("#contract_expense").attr('data-source', url);
  });

  $('#creditor-dialog').on('click', '.creditor-choosed', function(){
    var creditor_id = $(this).data('creditor');
    var creditor_name = $(this).find('td').html();
    fillCreditorField(creditor_name, creditor_id);
    $('#creditor-dialog').dialog('close');
  });

  $('form').on('change', '#contract_licitation_process_id', function (event, licitationProcess) {
    if (licitationProcess) {
      $('#contract_content').val(licitationProcess.description);
      $('#contract_modality_humanize').val(licitationProcess.modality_humanize);
      $('#contract_execution_type').val(licitationProcess.execution_type);
      $('#contract_contract_guarantees').val(licitationProcess.contract_guarantees);

      if(licitationProcess.creditors){
        if(licitationProcess.creditors.length > 1){
          setUrlToCreditor(licitationProcess.id);
          showToChooseCreditor(licitationProcess.creditors);
        }else{
          setUrlToCreditor(licitationProcess.id);
          fillCreditorField(licitationProcess.creditors[0].name, licitationProcess.creditors[0].id);
        }
      }

    } else {
      clearModalityExecutionType();
      var url = Routes.creditors + "?";

      $('#contract_creditor').data("source", url);
    }
  });

  function showToChooseCreditor(creditors){
    var body = '';
    $.each(creditors, function(index, creditor){
      body += "<tr class='creditor-choosed' data-creditor='"+ creditor.id +"' > <td> "+creditor.name+" </td> </tr>";
    });

    $("#choose-creditor tbody").html(body);
    $("#creditor-dialog").dialog("open");
  }


  function fillCreditorField(name, id){
    $('#contract_creditor')
      .val(name)
      .trigger("change");

    $('#contract_creditor_id').val(id).trigger("change");
  }

  function setUrlToCreditor(licitation_process_id){
    var url = Routes.creditors + "?",
      params = {by_ratification_and_licitation_process_id: licitation_process_id};
    url += jQuery.param(params);

    $('#contract_creditor').data("source", url);
  }

  $( "#creditor-dialog" ).dialog({
    autoOpen: false,
    height: 400,
    width: 500,
    modal: true,
  });

  $("#contract_contract_number").focus(function(){
    if($("#contract_type_contract option:selected").val() === 'minute'){
      if($(this).val() === '')
        $(this).val('ATA - ')
    }
  })
});
