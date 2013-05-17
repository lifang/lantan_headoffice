$(document).ready(function(){
     $("#add_role_a").click(function(){  //添加角色按钮
    popup("#add_role_form");
  })
  $("#add_role_btn").click(function(){    //添加角色验证
      var button = $(this);
    if($.trim($("input[name='role_name']").val()) == null || $.trim($("input[name='role_name']").val()) == ""){
      tishi_alert("角色名不能为空!");
      return false;
    }
    button.click(function(){
        return false;
    })
  })
  $("a[name='del_role_a']").click(function(){ //删除角色按钮
    var rid = $(this).parent().find($("input[name='hid_id']")).val();
    var flag = confirm("确定删除该角色?");
    if(flag){
      $.ajax({
        type: "get",
        url: "/authorities/del_role",
        data: {r_id : rid},
        success: function(data){
          if (data == 1){
            tishi_alert("删除成功!");
            setTimeout(function(){
                location.href = "/authorities";
            }, 1500);
          }else{
            tishi_alert("删除失败!");
          }
        }
      })
    }
  })

 $("a[name='edit_role']").click(function(){  //编辑按钮
     var obj = $(this).parent().parent().find($("input[name='role_new_name']"));
     obj.prev().attr("style", "display:none");
     obj.attr("style", "display:inline");
     obj.focus();
  })

  $("input[name='role_new_name']").blur(function(){ //编辑更新
    var obj = $(this);
    if($.trim(obj.val()) == null || $.trim(obj.val()) == ""){
      tishi_alert("角色名不能为空!");
      obj.val(obj.prev().text());
      obj.attr("style", "display:none");
      obj.prev().attr("style", "display:block");
    }else{
      var rid = obj.prev().prev().val();
      var rname = obj.val();
      $.ajax({
        type: "post",
        url: "/authorities/update_role",
        data: {r_id : rid, r_name : rname},
        success: function(data){
          if(data == 1){  
            tishi_alert("更新成功!");
            setTimeout(function(){
                location.href = "/authorities";
            }, 1500);
          }else{
           obj.val(obj.prev().text());
           obj.attr("style", "display:none");
           obj.prev().attr("style", "display:block");
           tishi_alert("更新失败，已有同名角色!");
          }
        }
      })
    }
  })

  $("a[name='set_auth']").click(function(){   //设置权限按钮
   var rid = $(this).parent().parent().find($("input[name='hid_id']")).val();
   $(this).parent().parent().siblings().css( "backgroundColor", "#ffffff" );
   $(this).parent().parent().css("background-color", "#ebebeb");
   $.ajax({
     type: "get",
     url: "/authorities/set_auth",
     data: {r_id : rid}
   })
  })

   $("#cancel_set_auth_form").live("click",function(){  //取消设置权限按钮
      $("#set_auth_form").remove();
      $("a[name='set_auth']").parent().parent().css("backgroundColor", "#ffffff");
  })

  $("a[name='set_staff_role']").click(function(){
      var sid = $(this).prev().val();
      $.ajax({
          type: "get",
          url: "/authorities/set_staff_role",
          data: {s_id : sid}
      })
  });

 });
function selectAll(obj){
    if($(obj).attr("checked")=="checked"){
        $(obj).parent().next().find("input[type='checkbox']").attr("checked", "checked")
    }else{
        $(obj).parent().next().find("input[type='checkbox']").attr("checked", false)
    }
}
var pic_types = ['gif', 'jpg', 'jpeg', 'png', 'bmp'];

function checkStaff(obj){
     //var button = $(this);
       if($(obj).parents('form').find("#staff_name").val() == ''){
           tishi_alert("名称不能为空!");
           return false;
       }
       if($(obj).parents('form').find("#staff_phone").val() == ''){
           tishi_alert("联系方式不能为空!");
           return false;
       }
       if($(obj).parents('form').find("#staff_id_card").val() == ''){
           tishi_alert("身份证不能为空!");
           return false;
       }
       if($(obj).parents('form').find("#staff_address").val() == ''){
           tishi_alert("地址不能为空!");
           return false;
       }
       if($(obj).parents('form').find("#staff_photo").val() == ''){
           tishi_alert("照片不能为空!");
           return false;
       }else{
           var img_val = $(obj).parents('form').find("#staff_photo").val();
               var pattern_str = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]");
               var img_name_val = img_val.substring(img_val.lastIndexOf("\\")).toLowerCase();
               var g_name_val = img_name_val.substring(1,img_name_val.length);
               if(pattern_str.test(g_name_val.split(".")[0])){
                  tishi_alert(g_name_val+"不能包含特殊字符!");
                  return false;
               }
           var photo = $("#staff_photo").val().split(".")
           var photo_type = photo[photo.length -1].toLowerCase();
           if(pic_types.indexOf(photo_type)<0){
              tishi_alert("照片格式不对！正确格式是："+pic_types);
              return false;
           }
       }
       $('#new_staff_btn').attr('disabled','disabled');
       $('#new_staff_btn').parents('form').submit();
}
