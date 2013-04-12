$(document).ready(function(){
   $("a[name='order_detail']").click(function(){
       var o_id = $(this).parent().find("input").val();
       $.ajax({
           type: "post",
           url: "complaints/show_order_detail",
           data: {oid : o_id}
       })
   })
})
