$(document)
    .ready(
        function() {
      



            function validatePhone(txtPhone) {
                var filter = /^[0-9-+]+$/;
                if (filter.test(txtPhone + "") && txtPhone.length >= 10 &&
                    txtPhone.length < 12) {
                    return true;
                } else {
                    return false;
                }
            }

       

            $("#addCustomerForm")
                .bind({
                    'submit': function() {

                        if ($('#customerName').val() == '') {
                            $('#error_customerName')
                                .html(
                                    '<font color="red">Bạn không được bỏ trống trường này!</font>');
                            return false;
                        }

                        if ($('#userName').val() == '') {
                            $('#error_userName')
                                .html(
                                    '<font color="red">Bạn không được bỏ trống trường này!</font>');
                            return false;
                        }
                        if ($('#password').val() == '') {
                            $('#error_passWord')
                                .html(
                                    '<font color="red">Bạn không được bỏ trống trường này!</font>');
                            return false;
                        }

                        if (!validatePhone($('#phoneNumber')
                                .val())) {
                            $('#error_phoneNumber')
                                .html(
                                    '<font color="red">Số điện thoại bạn nhập vào không phù hợp!</font>');
                            return false;
                        }

                        return true;
                    },
                    'keydown': function() {
                        /*delay 1 keydown  
                        if ($('#customerName').val().length > 0) {
                              $('#error_customerName').html(
                                  '');
                          }*/
                        $('#customerName').on('input', function() {
                            $('#error_customerName').html(
                                '');
                        });

                        $('#userName').on('input', function() {
                            $('#error_userName').html(
                                '');
                        });

                        $('#password').on('input', function() {
                            $('#error_passWord').html(
                                '');
                        });

                        $('#phoneNumber').on('input', function() {
                            $('#error_phoneNumber').html(
                                '');
                        });



                    }
                });
           
        });