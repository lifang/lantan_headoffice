$(document).ready(function(){
   $("#edit_submit_btn").live("click",function(){ //编辑时确定按钮验证
       var button = $(this);
    if($.trim($("#edit_new_title").val()) == null || $.trim($("#edit_new_title").val()) == ""){
      tishi_alert("标题不能为空!");
      return false;
    }else if($.trim(edit_news_detail.html()) == null || $.trim(edit_news_detail.html()) == ""){
      tishi_alert("内容不能为空!");
      return false;
    }
     $("#edit_new_content").val(edit_news_detail.html());
     button.click(function(){
         return false;
     })
  });

   $("#create_new_btn").click(function(){ //创建时确定按钮验证
       var button = $(this);
    if($.trim($("#create_new_title").val()) == null || $.trim($("#create_new_title").val()) == ""){
      tishi_alert("标题不能为空!");
      return false;
    }else if(news_detail.html() == ""){
      tishi_alert("内容不能为空!");
      return false;
    }
     $("#create_new_content").val(news_detail.html());
     button.click(function(){
         return false;
     })
  });
})

function cancel_edit_new(page){         //取消编辑
 window.location.href="/news?page="+page;
};
function cancel_new(){
    window.location.href="/news"
}
