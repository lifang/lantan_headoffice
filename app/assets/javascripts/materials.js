$(document).ready(function(){
     $("#started_time").datepicker({
    inline: true
  });
  $("#ended_time").datepicker({
    inline: true
  });
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
        data: {m_id : mid}
      })
    });
    $("a[name='material_check']").live("click", function(){ //库存核实
      var obj = $(this);
      var mid = $(this).parent().find("input").val();
      var count = $(this).parent().prev().find("input").val();
       if(isNaN(parseInt(count))){
         alert("请输入有效的数字!");
       }else{
         $.ajax({
        dataType: "json",
        type: "post",
        url: "/materials/material_check",
        data: {m_id : mid, storage : count},
        success: function(data){
          if(data == 0){
            alert("操作失败!");
          }else{
            obj.parent().prev().prev().prev().text(count);
            alert("操作成功！");
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
        data: {mo_id : moid}
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
         data: {mo_id : moid}
       })
    })
    $("a[name='order_detail_cancel_x']").live("click", function(){ //订单X关闭按钮
      $("#order_detail").empty();
    })
    $("#deliver_good").live("click", function(){  //发货按钮
      var moid = $(this).parent().find("input").val();
      $("#order_detail_and_deliver").append("<div class='item'><label>预计到货时间:</label><input type='text' id='arrive_time'></div>\n\
                                            <div class='item'><label>运单号:</label><input type='text' id='logistic_code'></div>\n\
                                              <div class='item'><label>运单人:</label><input type='text' id='carrier'/></div>");
      $('#arrive_time').datepicker({inline: true}); //加上时间插件
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
      if(arrive_time == ""){
        alert("输入到货时间!")
      }else if(logistic_code == ""){
        alert("输入运单号码");
      }else if(carrier == ""){
        alert("输入运单人姓名");
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
              alert("发货失败!");
              $("#order_detail").hide();
              $(".mask").hide();
              $("#order_detail").empty();
            }else if (data == 1){
              alert("发货成功！");
              $("#order_detail").hide();
              $(".mask").hide();
              $("#order_detail").empty();
              $("#arrival_at"+moid).text(arrive_time);
              $("#mo_status"+moid).text("已发货");
              $("#logi_info"+moid).html("物流单号:"+logistic_code+"<br/>承运人:"+carrier);
            }
          }
        })
      }
    })
    $("#mo_search_button").click(function(){   //门店订货记录查询
      var status = $("#select_mo_status").val();
      var started_time = $("#started_time").val();
      var ended_time = $("#ended_time").val();
      if(new Date(started_time) > 0 && new Date(ended_time) > 0 && new Date(ended_time) < new Date(started_time)){
        alert("结束时间必须在开始时间之后!")
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
        popup($("#ruku"));
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
      var num_flag = (new RegExp(/^\d+$/)).test( $("#m_num").val());
      var price_flag = (new RegExp("^[1-9][0-9]*\.[0-9]+$")).test($("#m_price").val()) || (new RegExp(/^\d+$/)).test( $("#m_price").val());
      if($("#m_name").val() == ""){
        alert("物料名不能为空!");
      }else if( $("#m_o_code").val() == ""){
        alert("订货单号不能为空!");
      }else if($("#m_code").val() == ""){
        alert("请输入条形码");
      }else if( $("#m_price").val() == ""){
        alert("请输入单价");
      }else if(price_flag == false){
        alert("请输入正确的价格");
      }else if( $("#m_num").val() == ""){
        alert("请输入数量");
      }else if(num_flag == false){
        alert("数量必须是大于等于零的整数");
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
    })
})