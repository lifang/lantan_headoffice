function edit_store(id){
    $.ajax({
      type: "GET",
      url: "/stores/" + id + "/edit",
      data: {store_id : id}
    })
  }

  function show_store(id){
    $.ajax({
      type: "GET",
      url: "/stores/" + id,
      data: {store_id : id}
    })
  }
  function new_store(){
      $.ajax({
          type: "GET",
          url: "/stores/new"
      })
  }
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

  $(document).ready(function(){
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