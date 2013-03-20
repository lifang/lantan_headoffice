$(document).ready(function(){
     $("#add_role_a").click(function(){  //添加角色按钮
    popup($("#add_role_form"));
  })
  $("#add_role_btn").click(function(){    //添加角色验证
    if($("input[name='role_name']").val() == ""){
      alert("角色名不能为空!");
      return false;
    }
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
            alert("删除成功!");
            location.href = "/authorities";
          }else{
            alert("删除失败!");
          }
        }
      })
    }
  })

 $("a[name='edit_role']").click(function(){  //编辑按钮
     var obj = $(this).parent().parent().find($("input[name='role_new_name']"));
     obj.attr("style", "display:block");
     obj.next().attr("style", "display:none");
     obj.focus();
  })

  $("input[name='role_new_name']").blur(function(){ //编辑更新
    var obj = $(this);
    if(obj.val() == ""){
      alert("角色名不能为空!");
      obj.val(obj.next().text());
      obj.attr("style", "display:none");
      obj.next().attr("style", "display:block");
    }else{
      var rid = obj.prev().val();
      var rname = obj.val();
      $.ajax({
        type: "post",
        url: "/authorities/update_role",
        data: {r_id : rid, r_name : rname},
        success: function(data){
          if(data == 1){
            alert("更新成功!");
            location.href = "/authorities";
          }else{
           alert("更新失败,该角色名已存在！");
           obj.val(obj.next().text());
           obj.attr("style", "display:none");
           obj.next().attr("style", "display:block");
          }
        }
      })
    }
  })

  $("a[name='set_auth']").click(function(){   //设置权限按钮
   var rid = $(this).parent().parent().find($("input[name='hid_id']")).val();
   $.ajax({
     type: "get",
     url: "/authorities/set_auth",
     data: {r_id : rid}
   })
  })

   $("#cancel_set_auth_form").live("click",function(){  //取消设置权限按钮
      $("#set_auth_form").remove();
  })

  $("a[name='set_staff_role']").click(function(){
      var sid = $(this).prev().val();
      $.ajax({
          type: "get",
          url: "/authorities/set_staff_role",
          data: {s_id : sid}
      })
  })
})