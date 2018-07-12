$(document)
    .ready(
        function() {
            /* ap dung voi input, datalist  
          function isProducerID(txtProducerID) {
                var listProducer = document.getElementById("listProducer");
                var i;
                for (i = listProducer.options.length - 1; i >= 0; i--) {
                    if (listProducer.options[i].value == txtProducerID) {
                        return true;
                    }
                }
                return false;
            }
*/



            function validateNumber(txtNumber) {
                var filter = /^[0-9]+$/;
                if (filter.test(txtNumber + "") && txtNumber.length > 0) {
                    return true;
                } else {
                    return false;
                }
            }


            $("#addProductForm")
                .bind({
                    'submit': function() {


                        if ($('#productName').val() == '') {
                            $('#error_productName')
                                .html(
                                    '<font color="red">Bạn không được bỏ trống trường này!</font>');
                            return false;
                        }

                        if (!validateNumber($('#price').val())) {
                            $('#error_price').html('<font color="red">Giá bạn nhập vào không phù hợp!</font>');
                            return false;
                        }

                        /*if chi ap dung voi input 
                        ($('#producerID').val() == '') {
                            $('#error_producerID')
                                .html(
                                    '<font color="red">Bạn không được bỏ trống trường này!</font>');
                            return false;
                        }*/
                        if ($('select[name=producerID]')
                            .val() == null) {
                            $('#error_producerID')
                                .html(
                                    '<font color="red">Bạn chưa chọn nhà cung cấp!</font>');
                            return false;
                        }
                        /*   if (!isProducerID($("#producerID").val())) {
                               $('#error_producerID').html(
                                   '<font color="red">Không tồn tại nhà cung cấp này.</font>');
                               return false;
                           }*/


                        return true;
                    },
                    'keydown': function() {

                        $('#productName').on('input', function() {
                            $('#error_productName').html(
                                '');
                        });
                        $('#price').on('input', function() {
                            $('#error_price').html(
                                '');
                        });
                        $('#producerID').on('input', function() {
                            $('#error_producerID').html(
                                '');
                        });



                    }
                });
        });