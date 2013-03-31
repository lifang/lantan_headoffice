$(document).ready(function(){
  $("#new_card").click(function(){       //显示新建优惠卡弹出层
    popup($("#new_card_detail"));
    $.ajax({
        type: "get",
        url: "/sv_cards/new_card"
    })
  })

  $("img[name='edit_card']").click(function(){  //编辑优惠卡
    var cid = $(this).parent().prev().val();
    popup($("#new_card_detail"));
    $.ajax({
        type: "get",
        url: "/sv_cards/edit_card",
        data: {c_id : cid}
    })
  })
  $("#card_type").live("change", function(){    //新建时根据卡类型加载不同表格
    if ($("#card_type").val() == 0){
      $("#discount_value").removeAttr("disabled");
      $.ajax({
        type: "GET",
        url: "/sv_cards/select_discount_card"
      })    
    }
    else if ($("#card_type").val() == 1){
      $("#discount_value").attr("disabled","disabled");
      $.ajax({
        type: "GET",
        url: "/sv_cards/select_storeage_card"
      })    
    }
  })

  $("#cancel").live("click",function(){      //X按钮
    $("#new_card_detail").empty();
  })

  $("#cancel1").live("click",function(){     //取消按钮
     $("#new_card_detail").empty();
  })
 $("#edit_cancel").live("click",function(){      //编辑时X按钮
    $("#new_card_detail").empty();
  })

  $("#edit_cancel1").live("click",function(){     //编辑时取消按钮
     $("#new_card_detail").empty();
  })
  $("#search_button").live("click",function(){ //确定提交按钮
    var type = parseInt($("#card_type").val());
    if(type == 1){
      if($("#card_name").val() == ""){
        tishi_alert("优惠卡名称不能为空!");
        return false;
      }else if($("#card_img").val() == ""){
        tishi_alert("请上传卡的图片!");
        return false;
      }else if($("#card_description").val() == ""){
        tishi_alert("请描述该卡!");
        return false;
      }else if($("#started_money").val() == ""){
        tishi_alert("请输入充值金额!");
        return false;
      }else if($("#ended_money").val() == ""){
        tishi_alert("请输入赠送金额!");
        return false;
      }
    }else if(type == 0){
      if($("#card_name").val() == ""){
        tishi_alert("优惠卡名称不能为空!");
        return false;
      }else if($("#card_img").val() == ""){
        tishi_alert("请上传卡的图片!");
        return false;
      }else if($("#discount_value").val()== ""){
          tishi_alert("请输入折扣!");
          return false;
      }else if(parseFloat($("#discount_value").val()) > 10 || parseFloat($("#discount_value").val()) < 1){
          tishi_alert("折扣必须在1~10之间!");
          return false;
      }
      else if($("#card_description").val() == ""){
        tishi_alert("请描述该卡!");
        return false;
      }else if($("input[name='product_hidden_id[]']").length <= 0){
        tishi_alert("请至少选择一个项目!");
        return false;
      }
    }
    //alert(parseFloat($("#discount_value").val()));
    //return false;
  })
    $("#edit_search_button").live("click",function(){ //编辑时确定提交按钮
    var type = parseInt($("#edit_card_type").val());
    if(type == 1){
      if($("#edit_card_name").val() == ""){
        tishi_alert("优惠卡名称不能为空!");
        return false;
      }else if($("#edit_card_description").val() == ""){
        tishi_alert("请描述该卡!");
        return false;
      }else if($("#edit_started_money").val() == ""){
        tishi_alert("请输入充值金额!");
        return false;
      }else if($("#edit_ended_money").val() == ""){
        tishi_alert("请输入赠送金额!");
        return false;
      }
    }else if(type == 0){
      if($("#edit_card_name").val() == ""){
        tishi_alert("优惠卡名称不能为空!");
        return false;
      }else if($("#edit_discount_value").val()== ""){
          tishi_alert("请输入折扣!");
          return false;
      }else if(parseFloat($("#edit_discount_value").val()) > 10 || parseFloat($("#edit_discount_value").val()) < 1){
       tishi_alert("折扣必须在1~10之间!");
          return false;
      }
      else if($("#edit_card_description").val() == ""){
        tishi_alert("请描述该卡!");
        return false;
      }else if($("input[name='edit_product_hidden_id[]']").length <= 0){
        tishi_alert("请至少选择一个项目!");
        return false;
      }
    }
    //alert(parseFloat($("#discount_value").val()));
    //return false;
  })
   $("#search_products_all").live("click",function(){     //新建时单选框全部
      $("#product_type").attr("disabled", "disabled");
      $("#product_name").attr("disabled", "disabled");
      $("#product_search").attr("disabled", "disabled");
      $.ajax({
        type: "GET",
        url: "/sv_cards/search_products_all"
      })
  })
  $("#search_products_part").live("click",function(){    //新建时单选框部分
      $("#product_type").removeAttr("disabled");
      $("#product_name").removeAttr("disabled");
      $("#product_search").removeAttr("disabled");
  })

   $("#edit_search_products_all").live("click",function(){     //编辑时单选框全部
      $("#edit_product_type").attr("disabled", "disabled");
      $("#edit_product_name").attr("disabled", "disabled");
      $("#edit_product_search").attr("disabled", "disabled");
      $.ajax({
        type: "GET",
        url: "/sv_cards/edit_search_products_all"
      })
  })
   $("#edit_search_products_part").live("click",function(){    //编辑时单选框部分
      $("#edit_product_type").removeAttr("disabled");
      $("#edit_product_name").removeAttr("disabled");
      $("#edit_product_search").removeAttr("disabled");
  })
  $('input[name="show_product[]"]').live("click" ,function(){   //在已选择里显示已选择的项目
    var id = parseInt($(this).val());
    var name = $(this).next().text();
    if($(this).attr("checked")=="checked"){
      $("#has_selected_result").append("<div id='pro"+id+"'"+"><em>"+name+"</em><a id="+"'procountadd"+id+"'"+" href='JavaScript:void(0)' name='add_p_button' class='addre_a'>+</a>\n\
      <span><input id='procount"+id+"'"+" name='product_count[]' type='text' class='addre_input' value='1' /></span><a id='procountdel"+id+"'"+" href='JavaScript:void(0)'\n\
      class='addre_a' name='del_p_button'>-</a><a name='del_p_a' href='JavaScript:void(0)' class='remove_a'>删除</a><input name='product_hidden_id[]' type='hidden' value='"+id+"'"+"/></div>"
    )
    }else{
      $("#pro"+id).remove();
    };
  })

  $("input[name='edit_show_product[]']").live("click",function(){   //编辑时在已选择里显示已选择的项目
      var id = parseInt($(this).val());
      var name = $(this).next().text();
      if($(this).attr("checked")=="checked"){
           $("#edit_has_selected_result").append("<div id='edpro"+id+"'"+"><em>"+name+"</em><a id="+"'edprocountadd"+id+"'"+" href='JavaScript:void(0)' name='add_p_button' class='addre_a'>+</a>\n\
      <span><input id='edprocount"+id+"'"+" name='edit_product_count[]' type='text' class='addre_input' value='1' /></span><a id='edprocountdel"+id+"'"+" href='JavaScript:void(0)'\n\
      class='addre_a' name='del_p_button'>-</a><a name='edit_del_p_a' href='JavaScript:void(0)' class='remove_a'>删除</a><input name='edit_product_hidden_id[]' type='hidden' value='"+id+"'"+"/></div>"
    )
      }else{
          $("#edpro"+id).remove();
      }
  })
  $("a[name='add_p_button']").live("click", function(){     //加号按钮
    $(this).next().find("input").val(parseInt($(this).next().find("input").val())+1);
  })
  $("a[name='del_p_button']").live("click", function(){     //减号按钮
    var a = parseInt($(this).prev().find("input").val());
    if(a<=1){
      tishi_alert("至少1个!");
    }else{
      $(this).prev().find("input").val(a-1);
    }
  })
   $("a[name='edit_add_p_button']").live("click", function(){     //编辑时加号按钮
    $(this).next().find("input").val(parseInt($(this).next().find("input").val())+1);
  })
   $("a[name='edit_del_p_button']").live("click", function(){     //编辑时减号按钮
    var a = parseInt($(this).prev().find("input").val());
    if(a<=1){
      tishi_alert("至少1个!");
    }else{
      $(this).prev().find("input").val(a-1);
    }
  })
   $("a[name='edit_del_p_a']").live("click", function(){     //编辑时删除按钮
    $(this).parent().remove();
    var this_id = parseInt($(this).next().val());
    $("input[name='edit_show_product[]']").each(function(){
      if(parseInt($(this).val())==this_id){
        $(this).attr("checked", false);
      }
    })
  })
  $("a[name='del_p_a']").live("click", function(){     //删除按钮
    $(this).parent().remove();
    var this_id = parseInt($(this).next().val());
    $("input[name='show_product[]']").each(function(){
      if(parseInt($(this).val())==this_id){
        $(this).attr("checked", false);
      }
    })
  })
  $("#product_search").live("click",function(){    //查询按钮
    var type = $("#product_type").val();
    var name = $("#product_name").val();
    $.ajax({
      type: "POST",
      url: "/sv_cards/search_products_part",
      data: {
        product_type : type,
        product_name : name
      }
    })
    return false;
  })
   $("#edit_product_search").live("click",function(){    //编辑时查询按钮
    var type = $("#edit_product_type").val();
    var name = $("#edit_product_name").val();
    $.ajax({
      type: "POST",
      url: "/sv_cards/edit_search_products_part",
      data: {
        product_type : type,
        product_name : name
      }
    })
    return false;
  })
   $("a[name='make_billing']").click(function(){    //开具发票按钮
      var relation_id = $(this).next().val()
      var prev_td =  $(this).parent()
      $.ajax({
        type: "POST",
        url: "/sv_cards/make_billing",
        data: {id : relation_id},
       success:function(data){
          if(data == 1){
             prev_td.prev().text("是");
             prev_td.html("-----");
             tishi_alert("操作成功!");
          }else{
            tishi_alert("操作失败!")
          }
        }
      })
    })
})
