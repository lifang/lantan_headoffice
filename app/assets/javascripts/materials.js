$(document).ready(function(){
    $("#materials_tab_table").tablesorter({
        headers:
        {
            0: {
                sorter: false
            },
            3: {
                sorter: false
            },
            4: {
                sorter: false
            },
            5: {
                sorter: false
            },
            6: {
                sorter: false
            },
            7: {
                sorter: false
            }
        }
    });

    //after sort
        $("#materials_tab_table").bind("sortEnd",function() {
            $("#materials_tab_table tbody").find('tr').each(function(i){
            if(i%2==0){
              $(this).removeClass('tbg');
            }else{
              $(this).addClass('tbg');
            }
            })
         });

    $("#mat_out_tab_table").tablesorter({
        headers:
        {
            0: {
                sorter: false
            },
            1: {
                sorter: false
            },
            4: {
                sorter: false
            }
        }
    });
        //after sort
        $("#mat_out_tab_table").bind("sortEnd",function() {
            $("#mat_out_tab_table tbody").find('tr').each(function(i){
            if(i%2==0){
              $(this).removeClass('tbg');
            }else{
              $(this).addClass('tbg');
            }
            })
         });

    $("#mat_in_tab_table").tablesorter({
        headers:
        {
            0: {
                sorter: false
            },
            3: {
                sorter: false
            },
            4: {
                sorter: false
            },
            5: {
                sorter: false
            }
        }
    });
    //after sort
        $("#mat_in_tab_table").bind("sortEnd",function() {
            $("#mat_in_tab_table tbody").find('tr').each(function(i){
            if(i%2==0){
              $(this).removeClass('tbg');
            }else{
              $(this).addClass('tbg');
            }
            })
         });

    $("#materials_list_table").tablesorter({
        headers:
        {
            0: {
                sorter: false
            },
            3: {
                sorter: false
            },
            4: {
                sorter: false
            },
            5: {
                sorter: false
            }
        }
    })
    //after sort
        $("#materials_list_table").bind("sortEnd",function() {
            $("#materials_list_table tbody").find('tr').each(function(i){
            if(i%2==0){
              $(this).removeClass('tbg');
            }else{
              $(this).addClass('tbg');
            }
            })
         });

    $("#started_time").click(function(){
        WdatePicker();
    });
    $("#ended_time").click(function(){
        WdatePicker();
    });

  $("#search_materials_button").click(function(){           //查询物料
      var mat_code = $.trim($("#search_material_code").val());
      var mat_name = $.trim($("#search_material_name").val());
      var mat_type = $("#search_material_type").val();
      $.ajax({
          async:true,
          type:"get",
          dataType:"script",
          url: "/materials",
          data: {
              mat_code : mat_code,
              mat_name : mat_name,
              mat_type : mat_type,
              tab : "materials_tab"
          }
      })
  })
  $("#table_show .pageTurn a").live("click", function(){   //分页AJAX
       var url = $(this).attr("href");
       var tab = $(this).parents('.pageTurn').parent().attr("id");
        $.ajax({
            async:true,
            type : 'get',
            dataType : 'script',
            url : url,
            data : {tab:tab}
        });
        return false;
    });
    $("a[name='material_beizhu']").live("click", function(){ //库存备注
        var mid = $(this).parent().find("input").val();
        $.ajax({
            type: "get",
            url: "/materials/show_material_beizhu",
            data: {
                m_id : mid
            }
        })
    });
    
    $("a[name='material_check']").live("click", function(){ //库存核实
        var obj = $(this);
        var mid = $(this).parent().find("input").val();
        var mat_storage = parseInt($(this).parent().siblings(".mat_stor").text());
        var count = $(this).parent().prev().find("input").val();
        if(isNaN(parseInt(count))){
            tishi_alert("请输入正确的盘点实数!");
        }else if(parseInt(count) < 0){
            tishi_alert("数量至少为零!");
        }else if($.trim(count)== null || $.trim(count)== ""){
            tishi_alert("请在核实数目中输入具体的盘点实数!")
        }else if(mat_storage==count){
            tishi_alert("已核实过!");
        }else{
            $.ajax({
                dataType: "json",
                type: "post",
                url: "/materials/material_check",
                data: {
                    m_id : mid,
                    storage : count
                },
                success: function(data){
                    if(data == 1){
                        obj.parent().prev().prev().prev().text(count);
                        tishi_alert("操作成功！");
                        obj.parent().prev().find("input").val("");
                        if(parseInt(count)<=0){
                            $("#"+mid+"storage").attr("class","data_table_error");
                            $("#"+mid+"status").text("缺货");
                        }else{
                            $("#"+mid+"storage").removeAttr("class");
                            $("#"+mid+"status").text("存货");
                        }                      
                    }else if(data == 0){
                          tishi_alert("操作失败!");        
                    }
                }
            })
        }
    })
    $("a[name='mat_order_beizhu']").live("click", function(){ //门店订货备注
        var moid = $(this).parent().find("input").val();
        $.ajax({
            type: "get",
            url: "/materials/show_material_order_beizhu",
            data: {
                mo_id : moid
            }
        })
    });
    $("#beizhu_cancel_btn").live("click", function(){  //备注取消按钮
        $("#beizhu_area").empty();
        return false;
    })
    $("a[name='beizhu_cancel_x']").live("click", function(){  //备注X按钮
        $("#beizhu_area").empty();
    })
    $("a[name='mat_order_detail']").live("click", function(){ //订单详情
        var moid = $(this).parent().find("input").val();
        $.ajax({
            type: "get",
            url: "/materials/mat_order_detail",
            data: {
                mo_id : moid
            }
        })
    })
    $("a[name='order_detail_cancel_x']").live("click", function(){ //订单X关闭按钮
        $("#order_detail").empty();
    })
    $("#deliver_good").live("click", function(){  //发货按钮
        var moid = $(this).parent().find("input").val();
        $("#order_detail_and_deliver").append("<div class='item'><label>预计到货时间:</label><input type='text' id='arrive_time' class='Wdate' readonly/></div>\n\
                                            <div class='item'><label>运单号:</label><input type='text' id='logistic_code'/></div>\n\
                                              <div class='item'><label>运单人:</label><input type='text' id='carrier'/></div>");
        $('#arrive_time').click(function(){
            WdatePicker();
        }); //加上时间插件
        $("#order_detail_btn_box").html("<input type='hidden' value='"+moid+"'/><button id='deliver_submit_btn' class='confirm_btn'>确定</button>\n\
      <button id='deliver_cancel_btn'class='cancel_btn'>返回</button>");
    })

    $("#deliver_cancel_btn").live("click", function(){  //发货返回
        $("#order_detail").empty();
    })
    $("#deliver_submit_btn").live("click", function(){  //发货确定按钮
        var moid = $(this).parent().find("input").val();
        var arrive_time = $("#arrive_time").val();
        var logistic_code = $("#logistic_code").val();
        var carrier = $("#carrier").val();
        if($.trim(arrive_time) == null || $.trim(arrive_time) == ""){
            tishi_alert("输入到货时间!")
        }else if($.trim(logistic_code) == null || $.trim(logistic_code) == ""){
            tishi_alert("输入运单号码");
        }else if($.trim(carrier) == null || $.trim(carrier) == ""){
            tishi_alert("输入运单人姓名");
        }else{
            $.ajax({
                type: "post",
                url: "/materials/deliver_good",
                data: {
                    m_o_id : moid,
                    arrive_time : arrive_time,
                    logistic_code : logistic_code,
                    carrier : carrier
                },
                success : function(data){
                    if (data == 0){
                        tishi_alert("发货失败!");                       
                    }else if (data == 1){
                        tishi_alert("发货成功！");
                        $("#order_detail").hide();
                        $(".mask").hide();
                        $("#order_detail").empty();
                        $("#arrival_at"+moid).text(arrive_time);
                        $("#mo_status"+moid).text("已发货");
                        $("#logi_info"+moid).html("物流单号:"+logistic_code+"<br/>承运人:"+carrier);
                        $.ajax({
                            type : 'get',
                            dataType : 'script',
                            url : "/materials",
                            data : {tab:"mat_out_tab"}
                        });
                        $.ajax({
                            type: "get",
                            dataType: "script",
                            url: "/materials",
                            data: {tab:"materials_tab"}
                        })
                    }else if(data == 2){
                        tishi_alert("订单所需的物料数量库存不足,请核实!");
                    }
                }
            })
        }
    })
    $("#urge_payment").live("click", function(){    //催款按钮
        var moid = $(this).parent().find("input").val();
        $.ajax({
            get: "get",
            url: "/materials/urge_payment",
            dataType: "json",
            data: {
                mo_id : moid
            },
            success: function(data){
                if(data == 0){
                    tishi_alert("操作失败！");
                }else{
                    tishi_alert("操作成功！");
                    $("#order_detail").hide();
                    $(".mask").hide();
                    $("#order_detail").empty();
                }
            }
        })
    })
    $("#mo_search_button").click(function(){   //门店订货记录查询
        var status = $("#select_mo_status").val();
        var started_time = $("#started_time").val();
        var ended_time = $("#ended_time").val();
        if(new Date(started_time) > 0 && new Date(ended_time) > 0 && new Date(ended_time) < new Date(started_time)){
            tishi_alert("结束时间必须在开始时间之后!")
        }else{
            $.ajax({
                type: "get",
                dataType : 'script',
                url:"/materials",
                data: {
                    tab : "mat_orders_tab",
                    status : status,
                    started_time : started_time,
                    ended_time : ended_time
                }
            })
        }
    })
    $("#ruku_a").click(function(){ //入库按钮
        popup("#ruku");
    })
    $("#ruku_cancel_x").click(function(){ //入库取消按钮
        $("#m_name").val("");
        $("#m_type").val(1);
        $("#m_o_code").val("");
        $("#m_code").val("");
        $("#m_price").val("");
        $("#m_num").val("");
    })
    $("#ruku_btn").click(function(){  //入库
        var button = $(this);
        var num_flag = (new RegExp(/^\d+$/)).test($.trim($("#m_num").val()));
        var price_flag = (new RegExp("^[0-9]+\.[0-9]+$")).test($("#m_price").val()) || (new RegExp(/^\d+$/)).test( $("#m_price").val());
        if($.trim($("#m_name").val()) == null || $.trim($("#m_name").val()) == ""){
            tishi_alert("物料名不能为空!");
        }else if($.trim($("#m_code").val()) == null || $.trim($("#m_code").val()) == ""){
            tishi_alert("请输入条形码");
        }else if($.trim($("#m_price").val()) == null || $.trim($("#m_price").val()) == ""){
            tishi_alert("请输入单价");
        }else if(price_flag == false){
            tishi_alert("请输入正确的价格");
        }else if($.trim($("#m_num").val()) == null || $.trim($("#m_num").val()) == ""){
            tishi_alert("请输入数量");
        }else if(num_flag == false){
            tishi_alert("数量必须是大于等于零的整数");
        }else{
            $.ajax({
                type: "post",
                url: "/materials/ruku",
                data: {
                    m_name : $("#m_name").val(),
                    m_type : $("#m_type").val(),
                    m_code : $("#m_code").val(),
                    m_o_code : $("#m_o_code").val(),
                    m_num : $("#m_num").val(),
                    m_price : $("#m_price").val()
                }
            })
        }
        button.click(function(){
            return false;
        })
    })   
})

function toggle_notice(obj){
    if($(obj).text()=="点击查看"){
       $(obj).text(" 隐藏");
    }else{$(obj).text("点击查看")}
    $(obj).next().toggle();
}
function invalNotice(obj){
    var mo_id = $(obj).attr('alt');
    var mesNum = $(obj).parents(".message").find("span.red");
    $.ajax({
        url:'/materials/inval_notice',
        type:'get',
        data:{mo_id : mo_id},
        success:function(data){
          if(data=="1"){
              tishi_alert("处理成功！");
              $(obj).parents("tr").hide();
              $(mesNum).text(parseInt($(mesNum).text())-1)
          }else{
              tishi_alert("处理失败！");
          }
        }
    })
}
   //排序切换箭头
function sort_change(obj){
    if($(obj).attr("class") == "sort_u"){
        $(obj).attr("class", "sort_d");
    }else if($(obj).attr("class") == "sort_d"){
        $(obj).attr("class", "sort_u");
    }
}