$(document).ready(function(){
$("a[name='edit_button']").click(function(){       //编辑门店
    var sid = parseInt($(this).attr("sid"));
     $.ajax({
      type: "GET",
      url: "/stores/" + sid + "/edit",
      data: {store_id : sid}
    })
})

$("a[name='show_button']").click(function(){       //门店详情
    var sid = parseInt($(this).attr("sid"));
    $.ajax({
      type: "GET",
      url: "/stores/" + sid,
      data: {store_id : sid}
    })
})
  $("#new_store_a").click(function(){            //新建门店
       $.ajax({
          type: "GET",
          url: "/stores/new"
      })
  })
  
function new_store_validate(){
  if($("#new_store_select_province").val() == 0){
    alert("请选择门店所在的省市!")
    return false;
  }
  else if($("#new_store_select_city").val() == 0){
    alert("请选择门店所在的省市!")
    return false;
  }
  else if($("#new_store_name").val() == ""){
    alert("请输入门店名称")
    return false;
  }
  else if($("#new_store_contact").val() == ""){
    alert("请输入负责人姓名")
    return false
  }
  else if($("#new_store_phone").val() == ""){
    alert("至少有个联系电话")
    return false
  }
  else if($("#new_store_address").val() == ""){
    alert("请输入门店地址")
    return false
  }
  else if($("#new_store_open_time").val() == ""){
    alert("请确定门店创建时间")
    return false
  }
  else{
    return true
  }
}

    $( "#new_store_open_time" ).datepicker({
        inline: true
    });

    $("#select_province").change(function(){
    $.ajax({
      type: "POST",
      url: "/operate_manages/province_change",
      data:"province_id="+$("#select_province").attr("value")
    })
  });

  $("#new_store_select_province").change(function(){
    $.ajax({
      type: "POST",
      url: "/operate_manages/new_store_select_province",
      data: "province_id="+$("#new_store_select_province").attr("value")
    })
  });
})