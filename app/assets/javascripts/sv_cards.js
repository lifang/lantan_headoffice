$(document).ready(function(){
  $("#new_card").click(function(){       //显示新建优惠卡弹出层
    $.ajax({
        type: "get",
        url: "/sv_cards/new_card"
    })
  });
  $("img[name='edit_card']").click(function(){  //编辑优惠卡
    var cid = $(this).parent().prev().val();
    $.ajax({
        type: "get",
        url: "/sv_cards/edit_card",
        data: {c_id : cid}
    })
  });
  $("#card_type").live("change", function(){    //新建时根据卡类型加载不同表格
    if ($("#card_type").val() == 0){
      $("#discount_value").removeAttr("disabled");
      $("#discount_value").prev().prepend("<span class='red'>*</span>");
      $("#discount_price").removeAttr("disabled");
      $("#discount_price").prev().prepend("<span class='red'>*</span>");
      $("#setObj").remove();
    }else if ($("#card_type").val() == 1){
      $("#discount_value").attr("disabled","disabled");
      $("#discount_value").prev().html("折扣：");
      $("#discount_price").attr("disabled","disabled");
      $("#discount_price").prev().html("优惠卡金额：");
      $("#popup_body_area").append("<div id='setObj' class='setObj'><div class='setobj_name'><span class='red'>*</span>项目:</div><div class='setobj_box'>\n\
        <div class='seto_list'><span>充<input id='started_money' name='started_money' type='text' class='input_s'/>元</span>&nbsp;&nbsp;\n\
        <span>送<input id='ended_money' name='ended_money' type='text' class='input_s'/>元</span></div></div></div>")
    }
  });
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

function new_card_validate(obj){        //新建优惠卡验证
    var type = parseInt($("#card_type").val());
    var flag = true;
    if(type == 1){
        if($.trim($("#card_name").val()) == null || $.trim($("#card_name").val()) == ""){
            tishi_alert("优惠卡名称不能为空!");
            flag = false;
        };
        if($("#card_url").val() == ""){
            tishi_alert("请上传卡的图片!");
            flag = false;
        }else{
            var img = $("#card_url").val();
            var img_suff = img.substring(img.lastIndexOf('.')+1).toLowerCase();
            if(img_suff != "jpg" && img_suff != "png" && img_suff != "gif" && img_suff != "bmp"){
                tishi_alert("请上传格式正确的图片!");
                flag = false;
            }
        };
        if($.trim($("#card_description").val())== null || $.trim($("#card_description").val())== ""){
            tishi_alert("请描述该卡!");
            flag = false;
        };
        if($.trim($("#started_money").val()) == ""){
            tishi_alert("请输入充值金额!");
            flag = false;
        }else if(isNaN($.trim($("#started_money").val()))){
            tishi_alert("请输入正确的充值金额!");
            flag = false;
        }else if(parseFloat($.trim($("#started_money").val()))<0){
            tishi_alert("充值金额为大于等于零的数字!");
            flag = false;
        };
        if($.trim($("#ended_money").val()) == ""){
            tishi_alert("请输入赠送金额!");
            flag = false;
        }else if(isNaN($.trim($("#ended_money").val()))){
            tishi_alert("请输入正确的赠送金额!");
            flag = false;
        }else if(parseFloat($.trim($("#ended_money").val()))<0){
            tishi_alert("赠送金额为大于等于零的数字!");
            flag = false;
        };
    }else if(type == 0){
        if($.trim($("#card_name").val()) == null || $.trim($("#card_name").val()) == ""){
            tishi_alert("优惠卡名称不能为空!");
            flag = false;
        };
        if($("#card_url").val() == ""){
            tishi_alert("请上传卡的图片!");
            flag = false;
        }else{
            var img = $("#card_url").val();
            var img_suff = img.substring(img.lastIndexOf('.')+1).toLowerCase();
            if(img_suff != "jpg" && img_suff != "png" && img_suff != "gif" && img_suff != "bmp"){
                tishi_alert("请上传格式正确的图片!");
                flag = false;
            }
        };
        if($.trim($("#discount_value").val()) == ""){
            tishi_alert("请输入折扣!");
            flag = false;
        }else if($("#discount_value").val()=="" || isNaN($("#discount_value").val()) || parseFloat($("#discount_value").val()) > 10 || parseFloat($("#discount_value").val()) < 1){
            tishi_alert("折扣必须在1~10之间的数字!");
            flag = false;
        };
        if($.trim($("#discount_price").val()) == ""){
            tishi_alert("请输入优惠卡金额!");
            flag = false;
        }else if(isNaN($.trim($("#discount_price").val())) || parseFloat($.trim($("#discount_price").val()))<=0){
            tishi_alert("优惠卡金额至少大于零!");
            flag = false;
        };
        if($.trim($("#card_description").val()) == null || $.trim($("#card_description").val()) == ""){
            tishi_alert("请描述该卡!");
            flag = false;
        }
    };
    if(flag){
        $(obj).parents("form").submit();
        $(obj).removeAttr("onclick");
    }
};

function edit_card_validate(obj){       //编辑优惠卡验证
    var type = parseInt($("#edit_card_type").val());
    var flag = true;
    if(type == 1){
        if($.trim($("#edit_card_name").val()) == ""){
        tishi_alert("优惠卡名称不能为空!");
        flag = false;
      };
      if($.trim($("#edit_card_description").val()) == ""){
        tishi_alert("请描述该卡!");
        flag = false;
      };
      if($.trim($("#edit_started_money").val()) == ""){
        tishi_alert("请输入充值金额!");
        flag = false;
      }else if(isNaN($.trim($("#edit_started_money").val()))){
          tishi_alert("请输入正确的充值金额!");
          flag = false;
      }else if(parseFloat($.trim($("#edit_started_money").val()))<0){
          tishi_alert("充值金额为大于等于零的数!");
          flag = false;
      };
      if($.trim($("#edit_ended_money").val()) == ""){
        tishi_alert("请输入赠送金额!");
        flag = false;
      }else if(isNaN($.trim($("#edit_ended_money").val()))){
          tishi_alert("请输入正确的赠送金额!");
          flag = false;
      }else if(parseFloat($.trim($("#edit_ended_money").val()))<0){
          tishi_alert("赠送金额为大于等于零的数!");
          flag = false;
      }
      if($("#edit_card_url").val() != ""){
          var img = $("#edit_card_url").val();
          var img_suff = img.substring(img.lastIndexOf('.')+1).toLowerCase();
          if(img_suff != "jpg" && img_suff != "png" && img_suff != "gif" && img_suff != "bmp" ){
             tishi_alert("请上传格式正确的图片!");
             flag = false;
          }
      }
    }else if(type==0){
       if($.trim($("#edit_card_name").val()) == ""){
        tishi_alert("优惠卡名称不能为空!");
        flag = false;
      };
      if($.trim($("#edit_discount_value").val()) == ""){
          tishi_alert("请输入折扣!");
          flag = false;
      }else if(isNaN($.trim($("#edit_discount_value").val())) || parseFloat($("#edit_discount_value").val()) > 10 || parseFloat($("#edit_discount_value").val()) < 1){
       tishi_alert("折扣必须在1~10之间的数字!");
          flag = false;
      };
      if($.trim($("#edit_discount_price").val()) == ""){
          tishi_alert("请输入优惠卡金额!");
          flag = false;
      }else if(isNaN($.trim($("#edit_discount_price").val()))){
          tishi_alert("请输入有效的优惠卡金额!");
          flag = false;
      }else if(parseFloat($.trim($("#edit_discount_price").val()))<0){
          tishi_alert("优惠卡金额至少大于零!");
          flag = false;
      };
      if($.trim($("#edit_card_description").val()) == null || $.trim($("#edit_card_description").val()) == ""){
        tishi_alert("请描述该卡!");
        flag = false;
      };
      if($("#edit_card_url").val() != ""){
          var img = $("#edit_card_url").val();
          var img_suff = img.substring(img.lastIndexOf('.')+1).toLowerCase();
          if(img_suff != "jpg" && img_suff != "png" && img_suff != "gif" && img_suff != "bmp" ){
             tishi_alert("请上传格式正确的图片!");
             flag = false;
          }
      }
    }
    if(flag){
        $(obj).parents("form").submit();
        $(obj).removeAttr("onclick");
    }
}