$(document).ready(function(){
  $("#new_card").click(function(){       //显示新建优惠卡弹出层
   
    $.ajax({
        type: "get",
        url: "/sv_cards/new_card"
    })
  })

  $("img[name='edit_card']").click(function(){  //编辑优惠卡
    var cid = $(this).parent().prev().val();
    $.ajax({
        type: "get",
        url: "/sv_cards/edit_card",
        data: {c_id : cid}
    })
  })
  $("#card_type").live("change", function(){    //新建时根据卡类型加载不同表格
    if ($("#card_type").val() == 0){
      $("#discount_value").removeAttr("disabled");
      $("#discount_price").removeAttr("disabled");
      $.ajax({
        type: "GET",
        url: "/sv_cards/select_discount_card"
      })    
    }
    else if ($("#card_type").val() == 1){
      $("#discount_value").attr("disabled","disabled");
      $("#discount_price").attr("disabled","disabled");
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
      }else if($("#card_url").val() == ""){
        tishi_alert("请上传卡的图片!");
        return false;
      }else if($("#card_description").val() == ""){
        tishi_alert("请描述该卡!");
        return false;
      }else if($("#started_money").val() == "" || isNaN($("#started_money").val())){
        tishi_alert("请输入充值金额!");
        return false;
      }else if($("#ended_money").val() == "" || isNaN($("#ended_money").val())){
        tishi_alert("请输入赠送金额!");
        return false;
      }
    }else if(type == 0){
      if($("#card_name").val() == ""){
        tishi_alert("优惠卡名称不能为空!");
        return false;
      }else if($("#card_url").val() == ""){
        tishi_alert("请上传卡的图片!");
        return false;
      }else if($("#discount_value").val()== ""){
          tishi_alert("请输入折扣!");
          return false;
      }else if(isNaN($("#discount_value").val()) || parseFloat($("#discount_value").val()) > 10 || parseFloat($("#discount_value").val()) < 1){
          tishi_alert("折扣必须在1~10之间的数字!");
          return false;
      }else if($("#discount_price").val() == "" || isNaN($("#discount_price").val())){
          tishi_alert("请输入有效的打折卡金额!");
          return false;
      }
      else if($("#card_description").val() == ""){
        tishi_alert("请描述该卡!");
        return false;
      }
    }
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
      }else if($("#edit_started_money").val() == "" || isNaN($("#edit_started_money").val())){
        tishi_alert("请输入充值金额!");
        return false;
      }else if($("#edit_ended_money").val() == "" || isNaN($("#edit_ended_money").val())){
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
      }else if(isNaN($("#edit_discount_value").val()) || parseFloat($("#edit_discount_value").val()) > 10 || parseFloat($("#edit_discount_value").val()) < 1){
       tishi_alert("折扣必须在1~10之间的数字!");
          return false;
      }else if($("#edit_discount_price").val() == "" || isNaN($("#edit_discount_price").val())){
          tishi_alert("请输入有效的打折卡金额!");
          return false;
      }
      else if($("#edit_card_description").val() == ""){
        tishi_alert("请描述该卡!");
        return false;
      }
    }
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
