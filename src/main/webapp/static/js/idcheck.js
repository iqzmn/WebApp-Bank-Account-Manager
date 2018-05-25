$(function() {
    $('#ssoIdd').blur(function () {
        $.ajax({
            url: 'checkId',
            data: ({text: $('#ssoIdd').val()}),
            success: function (response) {
                var result = response.text;
                if (result == null) {
                    alert('ID' + ' "' + $('#ssoIdd').val() + '" ' + 'already exist. Please fill in different value.');
                    $('#ssoIdd').focus();
                    $('#ssoIdd').val('');
                }
            }
        });
    });

    $('#ssoId').blur(function () {
        $.ajax({
            url: 'checkId',
            data: ({text: $('#ssoId').val()}),
            success: function (response) {
                var result = response.text;
                if (result == null) {
                    alert('ID' + ' "' + $('#ssoId').val() + '" ' + 'already exist. Please fill in different value.');
                    $('#ssoId').focus();
                    $('#ssoId').val('');
                }
            }
        });
    })
});