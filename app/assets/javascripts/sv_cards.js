$(document).ready(function(){
     $("#new_card").click(function(){      //显示新建优惠卡弹出层
    popup($("#new_card_detail"));
    $("new_card_detail").attr("style", "display:block")
  })

  $("#card_type").change(function(){    //根据卡类型加载不同表格
    if ($("#card_type").val() == 0){
      $.ajax({
        type: "GET",
        url: "/sv_cards/select_discount_card"
      })
       $("#discount_value").removeAttr("disabled");
    }
    else if ($("#card_type").val() == 1){
      $.ajax({
        type: "GET",
        url: "/sv_cards/select_storeage_card"
      })
      $("#discount_value").attr("disabled","disabled");
    }
  })

  $("#cancel").click(function(){      //X按钮
    location.href="/sv_cards"
  })

  $("#cancel1").click(function(){     //取消按钮
    location.href="/sv_cards"
  })

  $("#search_button").live("click",function(){ //确定提交按钮
    var type = parseInt($("#card_type").val());
    if(type == 1){
      if($("#card_name").val() == ""){
        alert("优惠卡名称不能为空!");
        return false;
      }else if($("#card_img").val() == ""){
        alert("请上传卡的图片!");
        return false;
      }else if($("#card_description").val() == ""){
        alert("请描述该卡!");
        return false;
      }else if($("#started_money").val() == ""){
        alert("请输入充值金额!");
        return false;
      }else if($("#ended_money").val() == ""){
        alert("请输入赠送金额!");
        return false;
      }
    }else if(type == 0){
      if($("#card_name").val() == ""){
        alert("优惠卡名称不能为空!");
        return false;
      }else if($("#card_img").val() == ""){
        alert("请上传卡的图片!");
        return false;
      }else if($("#card_description").val() == ""){
        alert("请描述该卡!");
        return false;
      }else if($("input[name='product_hidden_id[]']").length <= 0){
        alert("请至少选择一个项目!");
        return false;
      }
    }
  })
   $("#search_products_all").live("click",function(){     //单选框全部
      $("#product_type").attr("disabled", "disabled");
      $("#product_name").attr("disabled", "disabled");
      $("#product_search").attr("disabled", "disabled");
      $.ajax({
        type: "GET",
        url: "/sv_cards/search_products_all"
      })
  })
  $("#search_products_part").live("click",function(){    //单选框部分
      $("#product_type").removeAttr("disabled");
      $("#product_name").removeAttr("disabled");
      $("#product_search").removeAttr("disabled");
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
  $("a[name='add_p_button']").live("click", function(){     //加号按钮
    $(this).next().find("input").val(parseInt($(this).next().find("input").val())+1);
  })
  $("a[name='del_p_button']").live("click", function(){     //减号按钮
    var a = parseInt($(this).prev().find("input").val());
    if(a<=1){
      alert("至少1个!");
    }else{
      $(this).prev().find("input").val(a-1);
    }
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
             alert("操作成功!");
          }else{
            alert("操作失败!")
          }
        }
      })
    })
})
