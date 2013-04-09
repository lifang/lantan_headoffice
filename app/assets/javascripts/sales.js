$(document).ready(function(){
     $("a[name='del']").click(function(){     //删除按钮
   var flag = confirm("确定删除吗？");
   var sid = $(this).parent().find("input").val();
   if(flag){
    $.ajax({
      type: "POST",
      url: "/sales/del_sale",
      data: {id : sid},
      success: function(data){
        if (data == 1){
          tishi_alert("删除成功!");
          location.href = "/sales";
        }else{
          tishi_alert("删除失败！");
        }
      }
    })
   }
 })

 $("a[name='release']").click(function(){   //发布按钮
  var sid =  $(this).parent().find("input").val();
  $.ajax({
    type: "POST",
    url: "/sales/rel_sale",
    data: {id : sid},
    success: function(data){
      if(data == 1){
        tishi_alert("发布成功!");
        location.href = "/sales";
      }else{
        tishi_alert("发布失败!");
      }
    }
  })
 })

 $("a[name='edit']").click(function(){      //修改按钮
    var sid = $(this).parent().find("input").val();
    $.ajax({
        type: "get",
        url: "/sales/edit",
        data: {s_id : sid}
    })
 })
 $("#sale_search_btn").click(function(){           //查询按钮
    var p_types = $("#sale_product_types").val();
    var p_name = $("#sale_product_name").val();
    $.ajax({
      type: "POST",
      url: "/sales/search_product",
      data: {type : p_types, name : p_name}
    })
    return false;
  })
  $("#edit_sale_search_btn").live("click",function(){           //编辑时查询按钮
    var p_types = $("#edit_sale_product_types").val();
    var p_name = $("#edit_sale_product_name").val();
    $.ajax({
      type: "POST",
      url: "/sales/edit_search_product",
      data: {type : p_types, name : p_name}
    })
    return false;
  })
  $("input[name='product_name']").live("click", function(){   //在已选择里显示已选择的项目
    var pid = $(this).val();
    var pname = $(this).next().text();
    if($(this).attr("checked")=="checked"){
      $("#selected_product_div").append("<div id='pro"+pid+"'><em>"+pname+"</em><a name='add_button' href='JavaScript:void(0)' class='addre_a'>+</a><span><input name='selected_product_count[]'\n\
      type='text' class='addre_input' value='1'/></span><a name='del_button' href='JavaScript:void(0)' class='addre_a'>-</a><a name='del_a' href='JavaScript:void(0)' class='remove_a'>删除</a>\n\
      <input name='selected_product_id[]' type='hidden' value='"+pid+"'</div>")
    }else{
      $("#pro"+pid).remove();
    }
  })
  $("input[name='edit_product_name']").live("click", function(){ //修改活动时在已选择里显示已选择的项目
       var pid = $(this).val();
       var pname = $(this).next().text();
        if($(this).attr("checked")=="checked"){
            $("#edit_selected_product_div").append("<div id='edpro"+pid+"'><em>"+pname+"</em><a name='edit_add_button' href='JavaScript:void(0)' class='addre_a'>+</a><span><input name='edit_selected_product_count[]'\n\
      type='text' class='addre_input' value='1'/></span><a name='edit_del_button' href='JavaScript:void(0)' class='addre_a'>-</a><a name='edit_del_a' href='JavaScript:void(0)' class='remove_a'>删除</a>\n\
      <input name='edit_selected_product_id[]' type='hidden' value='"+pid+"'</div>")
        }else{
            $("#edpro"+pid).remove();
        }
  })
  $("a[name='edit_add_button']").live("click", function(){ //编辑时加号按钮
     var a = parseInt($(this).next().find("input").val())
    $(this).next().find("input").val(a+1)
  })
   $("a[name='add_button']").live("click", function(){     //加号按钮
    var a = parseInt($(this).next().find("input").val())
    $(this).next().find("input").val(a+1)
  })
  $("a[name='edit_del_button']").live("click", function(){  //编辑时减号按钮
        var a = parseInt($(this).prev().find("input").val());
        if(a<=1){
      tishi_alert("至少1个!");
    }else{
      $(this).prev().find("input").val(a-1);
    }
  })
   $("a[name='del_button']").live("click", function(){     //减号按钮
    var a = parseInt($(this).prev().find("input").val());
    if(a<=1){
      tishi_alert("至少1个!");
    }else{
      $(this).prev().find("input").val(a-1);
    }
  })
  $("a[name='edit_del_a']").live("click", function(){       //编辑时复选框删除按钮
      var this_id = parseInt($(this).next().val());
      $(this).parent().remove();
       $("input[name='edit_product_name']").each(function(){
      if(parseInt($(this).val())==this_id){
        $(this).attr("checked", false);
      }
    })
  })
   $("a[name='del_a']").live("click", function(){     //复选框删除按钮
    var this_id = parseInt($(this).next().val());
    $(this).parent().remove();
    $("input[name='product_name']").each(function(){
      if(parseInt($(this).val())==this_id){
        $(this).attr("checked", false);
      }
    })
  })
  $("input[name='sale_disc_types']").click(function(){    //优惠单选框
    var a = parseInt($(this).val());
    if(a == 1){
      $("#disc_discount").val("");
      $("#disc_discount").attr("disabled", "disabled");
      $("#disc_money").removeAttr("disabled");
    }
    else{
      $("#disc_money").val("");
      $("#disc_discount").removeAttr("disabled");
      $("#disc_money").attr("disabled", "disabled");
    }
  })
   $("input[name='edit_sale_disc_types']").live("click",function(){    //编辑时优惠单选框
    var a = parseInt($(this).val());
    if(a == 1){
      $("#edit_disc_discount").val("");
      $("#edit_disc_discount").attr("disabled", "disabled");
      $("#edit_disc_money").removeAttr("disabled");
    }
    else{
      $("#edit_disc_money").val("");
      $("#edit_disc_discount").removeAttr("disabled");
      $("#edit_disc_money").attr("disabled", "disabled");
    }
  })
  $("input[name='sale_disc_time_types']").click(function(){  //优惠时间单选框
    var a = parseInt($(this).val());
    if(a == 0){
      $("#started_time").removeAttr("disabled");
      $("#ended_time").removeAttr("disabled");
    }else{
      $("#started_time").val("");
      $("#ended_time").val("");
      $("#started_time").attr("disabled", "disabled");
      $("#ended_time").attr("disabled", "disabled");
    }
  })
  $("input[name='edit_sale_disc_time_types']").live("click",function(){  //编辑时优惠时间单选框
    var a = parseInt($(this).val());
    if(a == 0){
      $("#edit_started_time").removeAttr("disabled");
      $("#edit_ended_time").removeAttr("disabled");
    }else{
      $("#edit_started_time").val("");
      $("#edit_ended_time").val("");
      $("#edit_started_time").attr("disabled", "disabled");
      $("#edit_ended_time").attr("disabled", "disabled");
    }
  })
  $("input[name='sale_is_subsidy']").click(function(){  //是否总店补贴按钮
    var a = parseInt($(this).val());
    if(a == 1){
      $("#sale_subsidy_money").removeAttr("disabled");
    }else{
      $("#sale_subsidy_money").val("");
      $("#sale_subsidy_money").attr("disabled", "disabled");
    }
  })
   $("input[name='edit_sale_is_subsidy']").live("click",function(){  //编辑时是否总店补贴按钮
    var a = parseInt($(this).val());
    if(a == 1){
      $("#edit_sale_subsidy_money").removeAttr("disabled");
    }else{
      $("#edit_sale_subsidy_money").val("");
      $("#edit_sale_subsidy_money").attr("disabled", "disabled");
    }
  })

$("#cancel_button").click(function(){   //取消按钮
  location.href="/sales"
})
$("#edit_cancel_button").live("click",function(){   //编辑时取消按钮
  location.href="/sales"
})
 $("#started_time").datepicker({        //开始时间选择插件
    inline: true
});
 
$("#ended_time").datepicker({       //结束时间选择插件
    inline: true
});

$("#create_button").click(function(){  //创建验证
   if($("#sale_name").val() == ""){
       tishi_alert("活动标题不能为空!");
       return false;
    }else if($("input[name='selected_product_id[]']").length <= 0){
        tishi_alert("请至少选择一个项目!");
        return false;
    }else if($("#disc_money").val() == "" && $("#disc_discount").val() == ""){
        tishi_alert("请选择优惠方式及数额!");
        return false;
    }else if(parseInt($("input[name='sale_disc_time_types']:checked").val()) == 0 && $("#started_time").val() == "" && $("#ended_time").val() == ""){
        tishi_alert("请选择优惠时间段!");
        return false;
    }else if($("#sale_everycar_times").val() == "" || parseInt($("#sale_everycar_times").val()) <= 0){
        tishi_alert("请输入有效的优惠次数!");
        return false;
    }else if($("#sale_car_num").val() == "" || parseInt($("#sale_car_num").val()) <= 0){
         tishi_alert("请输入有效的车辆总数!");
        return false;
    }else if($("#sale_img").val() == ""){
        tishi_alert("请选择一张图片!");
        return false;
    }else if(new Date($("#ended_time").val()) > 0 && new Date($("#ended_time").val()) < new Date($("#started_time").val())){
        tishi_alert("结束时间必须在开始时间之后!");
        return false;
    }
});
$("#edit_create_button").live("click",function(){
    if($("#edit_sale_name").val() == ""){
       tishi_alert("活动标题不能为空!");
       return false;
    }else if($("input[name='edit_selected_product_id[]']").length <= 0){
        tishi_alert("请至少选择一个项目!");
        return false;
    }else if($("#edit_disc_money").val() == "" && $("#edit_disc_discount").val() == ""){
        tishi_alert("请选择优惠方式及数额!");
        return false;
    }else if(parseInt($("input[name='edit_sale_disc_time_types']:checked").val()) == 0 && $("#edit_started_time").val() == "" && $("#edit_ended_time").val() == ""){
        tishi_alert("请选择优惠时间段!");
        return false;
    }else if($("#edit_sale_everycar_times").val() == "" || parseInt($("#edit_sale_everycar_times").val()) <= 0){
        tishi_alert("请输入有效的优惠次数!");
        return false;
    }else if($("#edit_sale_car_num").val() == "" || parseInt($("#edit_sale_car_num").val()) <= 0){
         tishi_alert("请输入有效的车辆总数!");
        return false;
    }else if($("#edit_sale_img").val() == ""){
        tishi_alert("请选择一张图片!");
        return false;
    }else if(new Date($("#edit_ended_time").val()) > 0 && new Date($("#edit_ended_time").val()) < new Date($("#edit_started_time").val())){
        tishi_alert("结束时间必须在开始时间之后!");
        return false;
    }
});
})