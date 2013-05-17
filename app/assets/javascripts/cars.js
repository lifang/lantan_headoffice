$(document).ready(function(){
     $("#add_btn").click(function(){     //添加汽车品牌按钮
     popup("#new_brand");
  });
  $("#new_brands").click(function(){    //添加品牌验证
      var button = $(this);
    if($.trim($("#brand_name").val()) == null || $.trim($("#brand_name").val()) == ""){
      tishi_alert("请输入车牌名!");
      return false;
    }
    button.click(function(){
        return false;
    })
  });
  $("a[name='check_model']").click(function(){  //查看汽车型号按钮
    var cid = $(this).attr("alt");
    $.ajax({
      type: "GET",
      url: "/cars/check_model",
      data: {id : cid}
    })
  });
  $("a[name='del_brands']").click(function(){   //删除品牌
    var cid = $(this).attr("alt");
    var flag = confirm("确定删除该品牌吗？");
    if(flag){
      $.ajax({
      type: "GET",
      url: "/cars/del_brand",
      data: {id : cid},
      success: function(data){
        if(data == 1){
          tishi_alert("删除成功!");
          setTimeout(function(){
                location.href = "/cars";
            }, 1500);
        
        }else{
          tishi_alert("删除失败!");
        }
      }
    })
    }
  })
  $("a[name='edit_model']").live("click",function(){ //点击型号名字以编辑
    var model_text = $(this).next().next();
    $(this).attr("style", "display:none");
    model_text.attr("style", "dispaly:block");
    model_text.focus();
  })

  $("input[name='model_name']").live("blur",function(){   //编辑型号时
    var cid = $(this).prev().val();
    var obj = $(this);
    if($.trim(obj.val())== null || $.trim(obj.val())== ""){
      tishi_alert("型号不能为空");
      obj.val(obj.prev().prev().text());
      obj.attr("style", "display:none");
      obj.prev().prev().attr("style", "display:block");
    }else{
      var cname = obj.val();
      $.ajax({
        type: "POST",
        url: "/cars/update_model",
        data: {id : cid, name : cname},
        success: function(data){
          if(data == 1){
            obj.attr("style", "display:none");
            obj.prev().prev().text(obj.val());
            obj.prev().prev().attr("style", "display:block");
            tishi_alert("更新成功!");
          }else{
            obj.val(obj.prev().prev().text());
            obj.attr("style", "display:none");
            obj.prev().prev().attr("style", "display:block");
            tishi_alert("更新失败，已有该型号!")
          }
        }
      })
    }
  })

  $("a[name='del_model']").live("click",function(){    //删除型号
     var cid = $(this).prev().prev().val();
     var obj = $(this);
     var flag = confirm("确定删除该型号吗？");
     if(flag){
       $.ajax({
         type: "GET",
         url: "/cars/del_model",
         data: {mid : cid},
         success: function(data){
           if (data == 1){
             obj.parent().remove();
             tishi_alert("删除成功!");
           }else{
             tishi_alert("删除失败!");
           }
         }
       })
     }
  })

  $("a[name='add_model']").live("click",function(){      //+号按钮
    $(this).parent().attr("style", "display:none");
    $(this).parent().prev().attr("style", "display:block");
    $(this).parent().prev().find("input")[0].focus();
  })

  $("input[name='add_model_name']").live("blur",function(){  //新建型号文本框
    var mname = $(this).val();
    var mid = $(this).next().val();
    var obj = $(this);
    if($.trim(mname) == null || $.trim(mname) == ""){
      tishi_alert("创建失败,型号不能为空!");
      obj.parent().attr("style", "display:none");
      obj.parent().next().attr("style", "display:block");
    }else{
      $.ajax({
        type: "POST",
        url: "/cars/new_model",
        data: {model_name : mname, brand_id : mid},
        success: function(data){
          if(data == 0){
            tishi_alert("创建失败,该型号已存在!");
             obj.removeAttr("value");
             obj.parent().attr("style", "display:none");
             obj.parent().next().attr("style", "display:block");
          }else{
            tishi_alert("创建成功!");
            if($(".car_models li.saved_model").length > 0)
               {$(".car_models li.saved_model:last").after(data);}
            else{
                $(".car_models").prepend(data);
               }
            obj.removeAttr("value");
            obj.parent().attr("style", "display:none");
            obj.parent().next().attr("style", "display:block");
          }
        }
      })
    }
  })
})


