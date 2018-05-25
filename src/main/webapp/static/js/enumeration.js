$('.table tbody tr').each(function(i) {
    var number = i + 1;
    $(this).find('td:first').text(number);
});