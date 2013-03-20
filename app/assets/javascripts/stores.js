$(document).ready(function(){
    $("a[name='edit_button']").click(function(){       //编辑门店
        var sid = parseInt($(this).attr("sid"));
        $.ajax({
            type: "GET",
            url: "/stores/" + sid + "/edit",
            data: {
                store_id : sid
            }
        })
    })

    $("a[name='show_button']").click(function(){       //门店详情
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

    $("#new_store_btn").live("click", function(){   //新建门店验证
        if($("#new_store_select_province").val() == 0){
            alert("请选择门店所在的省市!");
            return false;
        }
        else if($("#new_store_select_city").val() == 0){
            alert("请选择门店所在的省市!");
            return false;
        }
        else if($("#new_store_name").val() == ""){
            alert("请输入门店名称");
            return false;
        }
        else if($("#new_store_contact").val() == ""){
            alert("请输入负责人姓名");
            return false;
        }
        else if($("#new_store_phone").val() == ""){
            alert("至少有个联系电话");
            return false;
        }
        else if($("#new_store_address").val() == ""){
            alert("请输入门店地址");
            return false;
        }
        else if($("#new_store_open_time").val() == ""){
            alert("请确定门店创建时间");
            return false;
        }
    })

    $("#edit_store_btn").live("click", function(){   //编辑门店验证
        if($("#edit_store_select_province").val() == 0){
            alert("请选择门店所在的省份!");
            return false;
        }
        else if($("#edit_store_select_city").val() == 0){
            alert("请选择门店所在的城市!");
            return false;
        }
        else if($("#edit_store_name").val() == ""){
            alert("请输入门店名称");
            return false;
        }
        else if($("#edit_store_contact").val() == ""){
            alert("请输入负责人姓名");
            return false;
        }
        else if($("#edit_store_phone").val() == ""){
            alert("至少有个联系电话");
            return false;
        }
        else if($("#edit_store_address").val() == ""){
            alert("请输入门店地址");
            return false;
        }
        else if($("#edit_store_open_time").val() == ""){
            alert("请确定门店创建时间");
            return false;
        }
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
})