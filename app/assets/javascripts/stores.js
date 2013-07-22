$(document).ready(function(){
    $("#search_button").click(function(){               //搜索门店
        var select_province = $("#select_province").val();
        var select_city = $("#select_city").val();
        var store_name = $.trim($("#store_name").val());
        $.ajax({
            type: "get",
            url: "/stores",
            dataType: "script",
            data: {
                select_province : select_province,
                select_city : select_city,
                store_name : store_name,
                div_name : "stores_div"
            }
        })
    })
    $("#new_chain_a").click(function(){                       //新建连锁店
         $.ajax({
            type: "GET",
            url: "/stores/new_chain",
            dataType: "script"
        })
    })
    $("a[name='edit_button']").live("click",function(){       //编辑门店
        var sid = parseInt($(this).attr("sid"));
        $.ajax({
            type: "GET",
            url: "/stores/" + sid + "/edit",
            data: {
                store_id : sid
            }
        })
    })

    $("a[name='show_button']").live("click",function(){       //门店详情
        var sid = parseInt($(this).attr("sid"));
        $.ajax({
            type: "GET",
            url: "/stores/" + sid,
            data: {
                store_id : sid
            }
        })
    })
    $("#new_store_a").click(function(){            //新建门店
        $.ajax({
            type: "GET",
            url: "/stores/new"
        })
    })    
   

    $("#select_province").change(function(){    //查询门店时选择省份
        var sid = $("#select_province").attr("value");
        $.ajax({
            type: "POST",
            url: "/stores/province_change",
            data: {
                province_id : sid
            }
        })
    });

    $("#new_store_select_province").live("change",function(){    //新建门店时选择省份
        var sid = $("#new_store_select_province").attr("value")
        $.ajax({
            type: "POST",
            url: "/stores/new_store_select_province",
            data: {
                province_id : sid
            }
        })
    })

     $("#edit_store_select_province").live("change",function(){    //编辑门店时选择省份
        var sid = $("#edit_store_select_province").attr("value")
        $.ajax({
            type: "POST",
            url: "/stores/edit_store_select_province",
            data: {
                province_id : sid
            }
        })
    })

    $(".pageTurn a").live("click", function(){              //异步分页
        var div_name = $(this).parents('.pageTurn').parent().attr("id");
        var url = $(this).attr("href");
        $.ajax({
            type: "get",
            dataType: "script",
            url: url,
            data: {div_name : div_name}
        })
        return false;
    })
})


function new_store_validate(obj){   //新建门店验证
        var flag = true;
        if($("#new_store_select_province").val() == 0){
            tishi_alert("请选择门店所在的省市!");
            flag = false;
        };
        if($("#new_store_select_city").val() == 0){
            tishi_alert("请选择门店所在的省市!");
            flag = false;
        };
        if($.trim($("#new_store_name").val()) == ""){
            tishi_alert("请输入门店名称");
            flag = false;
        };
        if($.trim($("#new_store_contact").val()) == ""){
            tishi_alert("请输入负责人姓名");
            flag = false;
        };
        if($.trim($("#new_store_phone").val()) == ""){
            tishi_alert("至少有个联系电话");
            flag = false;
        };
        if($.trim($("#new_store_address").val()) == ""){
            tishi_alert("请输入门店地址");
            flag = false;
        };
        if($("#new_store_open_time").val() == ""){
            tishi_alert("请确定门店创建时间");
            flag = false;
        };
        if($.trim($("#new_store_location_x").val()) == ""){
            tishi_alert("请输入门店X坐标");
            flag = false;
        }else if(isNaN($.trim($("#new_store_location_x").val())) || parseFloat($.trim($("#new_store_location_x").val()))<=0){
            tishi_alert("请输入正确的门店X坐标");
            flag = false;
        };
        if($.trim($("#new_store_location_y").val()) == ""){
            tishi_alert("请输入门店Y坐标");
            flag = false;
        }else if(isNaN($.trim($("#new_store_location_y").val())) || parseFloat($.trim($("#new_store_location_y").val()))<=0){
            tishi_alert("请输入正确的门店Y坐标");
            flag = false;
        };
        if($.trim($("#new_store_img").val()) == ""){
            tishi_alert("请上传门店的图片");
            flag = false;
        }else{
            var img = $("#new_store_img").val();
            var img_suff = img.substring(img.lastIndexOf('.')+1).toLowerCase();
            if(img_suff != "jpg" && img_suff != "png" && img_suff != "bmp" && img_suff != "gif"){
                tishi_alert("请上传格式正确的图片!");
                flag = false;
            }
        };
        if($.trim($("#new_store_staff_name").val()) == ""){
            tishi_alert("请输入管理员账号!")
            flag = false;
        };
        if($.trim($("#new_store_staff_password").val()) == ""){
            tishi_alert("请输入管理员密码!")
            flag = false;
        };
        if(flag){
         var staff_name = $("#new_store_staff_name").val();
         $.ajax({
          async: false,
          type: "post",
          url: "/stores/s_staff_validate",
          dataType: "json",
          data: {staff_name : staff_name},
          success: function(data){
              if(data.status==0){
                  tishi_alert("管理员账号已存在!");
                  flag = false;
              }
          }
        })
        };
       if(flag){
           var store_province = $("#s_store_province").val();
           var store_city = $("#s_store_city").val();
           var store_name = $("#s_store_name").val();
           var store_page = $("#s_store_page").val();
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_province' value='"+store_province+"'/>");
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_city' value='"+store_city+"'/>");
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_name' value='"+store_name+"'/>");
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_page' value='"+store_page+"'/>");
           $(obj).parents("form").submit();
           $(obj).removeAttr("onclick");
       }
    }

    function edit_store_validate(obj){   //编辑门店验证
      var flag = true;
        if($("#edit_store_select_province").val() == 0){
            tishi_alert("请选择门店所在的省份!");
            flag = false;
        };
        if($("#edit_store_select_city").val() == 0){
            tishi_alert("请选择门店所在的城市!");
            flag = false;
        };
        if($.trim($("#edit_store_name").val()) == ""){
            tishi_alert("请输入门店名称");
            flag = false;
        };
        if($.trim($("#edit_store_contact").val()) == ""){
            tishi_alert("请输入负责人姓名");
            flag = false;
        };
        if($.trim($("#edit_store_phone").val()) == ""){
            tishi_alert("至少有个联系电话");
            flag = false;
        };
        if($.trim($("#edit_store_address").val()) == ""){
            tishi_alert("请输入门店地址");
            flag = false;
        };
        if($("#edit_store_open_time").val() == ""){
            tishi_alert("请确定门店创建时间");
            flag = false;
        };
        if($.trim($("#edit_store_location_x").val()) == ""){
            tishi_alert("请输入门店X坐标");
            flag = false;
        }else if(isNaN($.trim($("#edit_store_location_x").val())) || parseFloat($.trim($("#edit_store_location_x").val()))<=0){
            tishi_alert("请输入正确的门店X坐标");
            flag = false;
        };
         if($.trim($("#edit_store_location_y").val()) == ""){
            tishi_alert("请输入门店Y坐标");
            flag = false;
        }else if(isNaN($.trim($("#edit_store_location_y").val())) || parseFloat($.trim($("#edit_store_location_y").val()))<=0){
            tishi_alert("请输入正确的门店Y坐标");
            flag = false;
        };
        if($("#edit_store_img").val() != ""){
           var img = $("#edit_store_img").val();
           var img_suff = img.substring(img.lastIndexOf('.')+1).toLowerCase();
           if(img_suff != "jpg" && img_suff != "png" && img_suff != "bmp" && img_suff != "gif"){
               tishi_alert("请上传格式正确的图片!");
               flag = false;
           }
        };
       if(flag){
           var store_province = $("#s_store_province").val();
           var store_city = $("#s_store_city").val();
           var store_name = $("#s_store_name").val();
           var store_page = $("#s_store_page").val();
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_province' value='"+store_province+"'/>");
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_city' value='"+store_city+"'/>");
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_name' value='"+store_name+"'/>");
           $(obj).parents("form").prepend("<input type='hidden' name='s_store_page' value='"+store_page+"'/>");
           $(obj).parents("form").submit();
           $(obj).removeAttr("onclick");
       }
    }

function new_chain_select_province(pid){            //新建连锁店时选择省份
  var pid = pid;
  if(pid==0){
      $("#new_chain_select_city").html("<option value='0'>------</option>");
  }else{
       $.ajax({
      type: "post",
      url: "/stores/new_chain_select_province",
      dataType: "script",
      data: {pid : pid, type : "new"}
  })
  }
}

function new_chain_search_stores(){             //新建连锁店时查询门店
    var province = $("#new_chain_select_province").val();
    var city = $("#new_chain_select_city").val();
    var name = $.trim($("#new_chain_select_name").val());
    var a = new Array();
    $("input[name='selected_stores[]']").each(function(index,obj){
        a[index] = $(obj).val();
    })
    $.ajax({
        type: "post",
        dataType: "script",
        url: "/stores/new_chain_search_stores",
        data: {
            province : province,
            city : city,
            name : name,
            stores : a,
            type : "new"
        }
    })
}

function new_chain_store_change(obj){       //选择连锁店关联的门店
    var id = $(obj).val();
    var name = $(obj).next().text();
    var flag = $("#new_chain_selected_stores_list ul").find("#new_chain_selected_store_"+id).length<=0; //判断是否已选中
    if($(obj).attr("checked")=="checked"){
        if(flag){           //如果下面没选中...
            $("#new_chain_selected_stores_list ul").append("<li><input type='checkbox' name='selected_stores[]' id='new_chain_selected_store_"+id+"' value='"+id+"' onclick='new_chain_cancel_select_store(this)' checked/><span>"+name+"</span></li>")
        }
    }else{
        if(!flag){
            $("#new_chain_selected_stores_list ul").find("#new_chain_selected_store_"+id).parent().remove();
        }
    }
}

function new_chain_cancel_select_store(obj){          //取消已选中的门店
    var id = $(obj).val();
    if($(obj).attr("checked") != "checked"){
        var flag = $("#new_chain_list_store_"+id).attr("checked") == "checked"
        if(flag){
            $("#new_chain_list_store_"+id).removeAttr("checked");
        }
        $(obj).parent().remove();
    }
}

function new_chain_validate(obj){    //创建连锁店验证
    var name = $.trim($("#new_chain_name").val());
    var staff_name = $.trim($("#new_chain_staff_name").val());
    var staff_password = $.trim($("#new_chain_staff_password").val());
    var l = $("#new_chain_selected_stores_list ul").find("input").length;
    var flag = true;
    if(name==""){
        tishi_alert("连锁店名称不能为空!");
        flag = false;
    }else if(staff_name==""){
        tishi_alert("管理员用户名不能为空!");
        flag = false;
    }else if(staff_password==""){
        tishi_alert("管理员密码不能为空!");
        flag = false;
    }else if(l<=0){
        if(!confirm("您没有为该连锁店关联任何门店,需要继续创建吗？")){
            flag = false;
        }
    }
    if(flag){
         $.ajax({
            type: "get",
            url: "/stores/chain_validate",
            dataType: "json",
            data: {name : name, staff_name : staff_name, type : "new"},
            success: function(data){
                if(data.status==0){
                    tishi_alert("创建失败,已有同名的连锁店!");
                }else if(data.status==2){
                    tishi_alert("创建失败,已有同名的管理员!")
                }else{
                    $("#new_chain_selected_stores_list").find("form").prepend("<input type='hidden' name='chain_name' value='"+name+"'/>");
                    $("#new_chain_selected_stores_list").find("form").prepend("<input type='hidden' name='staff_name' value='"+staff_name+"'/>");
                    $("#new_chain_selected_stores_list").find("form").prepend("<input type='hidden' name='staff_password' value='"+staff_password+"'/>");
                    $("#new_chain_selected_stores_list").find("form").submit();
                    $(obj).removeAttr("onclick");
                }
            }
        })
    }
}
function del_chain(obj){
    var chain_id = $(obj).parents("tr").find("td:first input").val();
    if(confirm("确定删除该连锁店?")){
        $.ajax({
            type: "post",
            url: "/stores/del_chain",
            dataType: "json",
            data: {chain_id : chain_id},
            success: function(data){
                if(data.status==0){
                    tishi_alert("删除失败!");
                }else{
                    tishi_alert("删除成功!");
                    $.ajax({
                        type: "get",
                        url: "/stores",
                        dataType: "script",
                        data: {div_name : "chains_div"}
                    })
                }
            }
        })
    }
}

function edit_chain(obj){               //编辑连锁店
     var chain_id = $(obj).parents("tr").find("td:first input").val();
     $.ajax({
         type: "get",
         url: "/stores/edit_chain",
         dataType: "script",
         data: {chain_id : chain_id}
     })
}

function edit_chain_select_province(pid){           //编辑连锁店时选择省份
    var pid = pid;
    if(pid==0){
      $("#edit_chain_select_city").html("<option value='0'>------</option>");
  }else{
       $.ajax({
      type: "post",
      url: "/stores/new_chain_select_province",
      dataType: "script",
      data: {pid : pid, type : "edit"}
  })
  }
}

function edit_chain_search_stores(){             //编辑连锁店时查询门店
    var province = $("#edit_chain_select_province").val();
    var city = $("#edit_chain_select_city").val();
    var name = $.trim($("#edit_chain_select_name").val());
    var a = new Array();
    $("input[name='edit_selected_stores[]']").each(function(index,obj){
        a[index] = $(obj).val();       
    });
    $.ajax({
        type: "post",
        dataType: "script",
        url: "/stores/new_chain_search_stores",
        data: {
            province : province,
            city : city,
            name : name,
            stores : a,
            type : "edit"
        }
    })
}

function edit_chain_store_change(obj){       //编辑连锁店时选择连锁店关联的门店
    var id = $(obj).val();
    var name = $(obj).next().text();
    var flag = $("#edit_chain_selected_stores_list ul").find("#edit_chain_selected_store_"+id).length<=0; //判断是否已选中
    if($(obj).attr("checked")=="checked"){
        if(flag){           //如果下面没选中...
            $("#edit_chain_selected_stores_list ul").append("<li><input type='checkbox' name='edit_selected_stores[]' id='edit_chain_selected_store_"+id+"' value='"+id+"' onclick='edit_chain_cancel_select_store(this)' checked/><span>"+name+"</span></li>")
        }
    }else{
        if(!flag){
            $("#edit_chain_selected_stores_list ul").find("#edit_chain_selected_store_"+id).parent().remove();
        }
    }
}

function edit_chain_cancel_select_store(obj){          //编辑连锁店时取消已选中的门店
    var id = $(obj).val();
    if($(obj).attr("checked") != "checked"){
        var flag = $("#edit_chain_list_store_"+id).attr("checked") == "checked"
        if(flag){
            $("#edit_chain_list_store_"+id).removeAttr("checked");
        }
        $(obj).parent().remove();
    }
}

function edit_chain_validate(obj){    //编辑连锁店验证
    var name = $.trim($("#edit_chain_name").val());
    var id = $("#edit_chain_select_id").val();
    var l = $("#edit_chain_selected_stores_list ul").find("input").length;
    var flag = true;
    if(name==""){
        tishi_alert("连锁店名称不能为空!");
        flag = false;
    }else if(l<=0){
        if(!confirm("您没有为该连锁店关联任何门店,需要继续创建吗？")){
            flag = false;
        }
    }
    if(flag){
         $.ajax({
            type: "get",
            url: "/stores/chain_validate",
            dataType: "json",
            data: {name : name, id : id, type : "edit"},
            success: function(data){
                if(data.status==0){
                    tishi_alert("创建失败,已有同名的连锁店!");
                }else{
                    $("#edit_chain_selected_stores_list").find("form").prepend("<input type='hidden' name='chain_name' value='"+name+"'/>");
                    $("#edit_chain_selected_stores_list").find("form").prepend("<input type='hidden' name='chain_id' value='"+id+"'/>");
                    $("#edit_chain_selected_stores_list").find("form").submit();
                    $(obj).removeAttr("onclick");
                }
            }
        })
    }
}
function del_store(store_id){
     var store_province = $("#s_store_province").val();
     var store_city = $("#s_store_city").val();
     var store_name = $("#s_store_name").val();
     var store_page = $("#s_store_page").val();
     if(confirm("确定删除?")){
         $.ajax({
             type: "delete",
             url: "/stores/"+store_id,
             dataType: "script",
             data: {store_province : store_province, store_city : store_city,
                    store_name : store_name, store_page : store_page}
         })
     }
}

