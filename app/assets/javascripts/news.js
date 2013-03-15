$(document).ready(function(){
   $("a[name='del_new']").click(function(){    //删除新闻按钮
      var flag = confirm("确定删除该新闻？");
      var nid = $(this).parent().find("input").val();
      if(flag){
        $.ajax({
          type: "delete",
          url: "/news/destroy",
          data: {n_id : nid},
          success: function(data){
            if(data == 0){
              alert("删除失败!");
            }else{
              alert("删除成功!");
              location.href="/news"
            }
          }
        })
      }
  })

   $("a[name='rel_new']").click(function(){  //发布新闻按钮
     var flag = confirm("确定发布该新闻？");
     var nid = $(this).parent().find("input").val();
     if(flag){
       $.ajax({
         type: "get",
         url: "/news/release",
         data: {n_id : nid},
         success: function(data){
           if(data == 0){
              alert("发布失败!");
            }else{
              alert("发布成功!");
              location.href="/news"
            }
         }
       })
     }
  })

   $("a[name='edit_new']").click(function(){ //修改新闻按钮
    var nid = $(this).parent().find("input").val();
    $.ajax({
      type: "get",
      url: "/news/detail",
      data: {n_id : nid}
    })
  })

   $("#edit_submit_btn").live("click",function(){ //编辑时确定按钮验证
    if($("#edit_new_title").val() == ""){
      alert("标题不能为空!");
      return false;
    }else if($("#edit_new_content").val() == ""){
      alert("内容不能为空!");
      return false;
    }
  })

  $("#edit_cancel_btn").live("click",function(){
    location.href="/news";
  })

   $("#create_new_btn").click(function(){ //创建时确定按钮验证
    if($("#create_new_title").val() == ""){
      alert("标题不能为空!");
      return false;
    }else if($("#create_new_content").val() == ""){
      alert("内容不能为空!");
      return false;
    }
  })
  $("#cancel_new_btn").click(function(){
    location.href="/news";
  })
})
