$('<div><%= j render('budget_allocations/show', :resource => resource.localized) %></div>').dialog({
    modal: true,
    width: 1024,
    height: 450,
    title: "Informações de:  <%= resource.description %>"
});
