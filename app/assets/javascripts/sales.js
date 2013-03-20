$(document).ready(function(){
     $("a[name='del']").click(function(){     //删除按钮
   var flag = confirm("确定删除吗？");
   sid = $(this).next().attr("value");
   if(flag){
    $.ajax({
      type: "POST",
      url: "/sales/del_sale",
      data: {id : sid},
      success: function(data){
        if (data == 1){
          alert("删除成功!");
          location.href = "/sales";
        }else{
          alert("删除失败！");
        }
      }
    })
   }
 })

 $("a[name='release']").click(function(){   //发布按钮
  sid = $(this).next().next().attr("value");
  $.ajax({
    type: "POST",
    url: "/sales/rel_sale",
    data: {id : sid},
    success: function(data){
      if(data == 1){
        alert("发布成功!");
        location.href = "/sales";
      }else{
        alert("发布失败!");
      }
    }
  })
 })

 $("#sale_search_btn").click(function(){           //查询按钮
    p_types = $("#sale_product_types").val();
    p_name = $("#sale_product_name").val();
    $.ajax({
      type: "POST",
      url: "/sales/search_product",
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
   $("a[name='add_button']").live("click", function(){     //加号按钮
    var a = parseInt($(this).next().find("input").val())
    $(this).next().find("input").val(a+1)
  })
   $("a[name='del_button']").live("click", function(){     //减号按钮
    var a = parseInt($(this).prev().find("input").val());
    if(a<=1){
      alert("至少1个!");
    }else{
      $(this).prev().find("input").val(a-1);
    }
  })
   $("a[name='del_a']").live("click", function(){     //复选框删除按钮
    $(this).parent().remove();
    var this_id = parseInt($(this).next().val());
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
  $("input[name='sale_is_subsidy']").click(function(){  //是否总店补贴按钮
    var a = parseInt($(this).val());
    if(a == 1){
      $("#sale_subsidy_money").removeAttr("disabled");
    }else{
      $("#sale_subsidy_money").val("");
      $("#sale_subsidy_money").attr("disabled", "disabled");
    }
  })
$("#cancel_button").click(function(){   //取消按钮
  location.href="/sales"
})
 $("#started_time").datepicker({        //开始时间选择插件
    inline: true
});
$("#ended_time").datepicker({       //结束时间选择插件
    inline: true
});
$("#create_button").click(function(){
    if(new Date($("#ended_time").val()) > 0 && new Date($("#ended_time").val()) < new Date($("#started_time").val())){
        alert("结束时间必须在开始时间之后!");
        return false;
    }
});
})