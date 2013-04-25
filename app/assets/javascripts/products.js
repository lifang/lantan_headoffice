//添加产品
function add_prod(){
    $.ajax({
        async:true,
        type : "POST",
        dataType : 'script',
        url : "/products/add_prod"
    });
}

//编辑产品
function edit_prod(id){
    $.ajax({
        async:true,
        type : "POST",
        dataType : 'script',
        url : "/products/"+ id+"/edit_prod"
    });
}

//显示产品
function show_prod(id){
    $.ajax({
        async:true,
        type : "POST",
        dataType : 'script',
        url : "/products/"+ id+"/show_prod"
    });
}

//添加或者编辑产品
function add_product(e){
    var name=$("#name").val();
    var base=$("#base_price").val();
    var sale=$("#sale_price").val();
    var standard =$("#standard").val();
    var pic_format =["png","gif","jpg","bmp"];
    if (name=="" || name.length==0){
        tishi_alert("请输入产品的名称");
        return false;
    }
    if(base == "" || base.length==0 || isNaN(parseFloat(base))){
        tishi_alert("请输入产品的零售价格");
        return false;
    }
    if(sale == "" || sale.length==0 || isNaN(parseFloat(sale))){
        tishi_alert("请输入产品的促销价格");
        return false;
    }
    if (standard=="" || standard.length==0){
        tishi_alert("请输入产品的规格");
        return false;
    }
    var img_f  = false
    $(".add_img #img_div input[name$='img_url']").each(function (){
        if (this.value!="" || this.value.length!=0){
            var pic_type =this.value.substring(this.value.lastIndexOf(".")).toLowerCase()
            if (pic_format.indexOf(pic_type.substring(1,pic_type.length))== -1){
                img_f = true
            }else{
                $(this).attr("name","img_url["+this.id+"]");
            }
        }
    })
    if(img_f){
        tishi_alert("请选择正确格式的图片,正确格式是："+pic_format );
        return false
    }
    $("#desc").val(serv_editor.html());
    $("#add_prod").submit();
    $(e).removeAttr("onclick");
}


//显示服务
function show_service(id){
    $.ajax({
        async:true,
        type : "POST",
        dataType : 'script',
        url : "/products/"+ id+"/show_serv"
    });
}

// 添加服务
function add_service(){
    $.ajax({
        async:true,
        type : "POST",
        dataType : 'script',
        url : "/products/add_serv"
    });
}

//编辑服务
function edit_service(id){
    $.ajax({
        async:true,
        type : "POST",
        dataType : 'script',
        url : "/products/"+ id+"/edit_serv"
    });
}

//添加或者编辑服务
function edit_serv(e){
    var name=$("#name").val();
    var base=$("#base_price").val();
    var sale=$("#sale_price").val();
    var time=$("#cost_time").val();
    var deduct =$("#deduct_percent").val();
    var pic_format =["png","gif","jpg","bmp"];
    if (name=="" || name.length==0){
        tishi_alert("请输入服务的名称");
        return false;
    }
    if(base == "" || base.length==0 || isNaN(parseFloat(base))){
        tishi_alert("请输入服务的零售价格");
        return false;
    }
    if(sale == "" || sale.length==0 || isNaN(parseFloat(sale))){
        tishi_alert("请输入服务的促销价格");
        return false;
    }
    if(deduct == "" || deduct.length==0 || isNaN(parseFloat(deduct))){
        tishi_alert("请输入技师提成百分点");
        return false;
    }
    if(time== "" || time.length==0 || isNaN(parseInt(time))){
        tishi_alert("请输入服务的施工时间");
        return false;
    }
    var img_f  = false
    $(".add_img #img_div input[name$='img_url']").each(function (){
        if (this.value!="" || this.value.length!=0){
            var pic_type =this.value.substring(this.value.lastIndexOf(".")).toLowerCase()
            if (pic_format.indexOf(pic_type.substring(1,pic_type.length))== -1){
                img_f = true
            }else{
                $(this).attr("name","img_url["+this.id+"]");
            }
        }
    })
    if(img_f){
        tishi_alert("请选择正确格式的图片,正确格式是："+pic_format );
        return false
    }
    $("#desc").val(serv_editor.html());
    $(e).removeAttr("onclick");
    $("#edit_serv").submit();
}

//请求加载产品或服务类别
function load_material(store_id){
    var types=$("#sale_types option:checked").val();
    var name=$("#sale_name").val();
    if (types != "" || name != ""){
        $.ajax({
            async:true,
            type : "POST",
            dataType : 'script',
            url : "/products/load_material",
            data : {
                mat_types : types,
                mat_name : name
            }
        });
    }else{
        tishi_alert("请选择类型或填写名称！");
    }
}


function show_mat(){
    var mats=""
    $("#add_products div").each(function(index,div){
        mats += "<li>"+$("#"+div.id+" em").html()+"<span>/"+$("#add_p"+div.id).val()+"</span></li>"
    })
    $(".seeProDiv_rWidth .srw_ul").html(mats);
    $('.mat_tab').css('display','none');
}
//向选择框添加产品服务
function add_this(e,name){
    var child="<div id='"+e.value+"'><em>"+name +"</em><a href='javascript:void(0)' class='addre_a' \n\
    onclick=\"add_one(\'"+e.value +"\')\" id='add_one"+e.value +"'>+</a><span><input name='sale_prod["+e.value +"]' \n\
    type='text' class='addre_input' value='1' id='add_p"+e.value +"' /></span><a href='javascript:void(0)' class='addre_a' \n\
    id='delete_one"+e.value+"'>-</a><a href='javascript:void(0)' class='remove_a' \n\
    onclick='$(this).parent().remove();if($(\"#prod_"+ e.value+"\").length!=0){$(\"#prod_"+ e.value+"\")[0].checked=false;}'>删除</a></div></div>";
    if ($(e)[0].checked){
        if ($("#add_products #"+e.value).length==0){
            $(".popup_body_fieldset #add_products").append(child);
        }else{
            var num=parseInt($("#add_products #add_p"+e.value).val())+1;
            $("#add_products #add_p"+e.value).val(num);
            $("#add_products #delete_one"+e.value).attr("onclick","delete_one('"+ e.value+"')");
        }
    }else{
        $("#add_products #"+e.value).remove();
    }
}



function add_one(id){
    var num=parseInt($("#add_products #add_p"+id).val())+1;
    $("#add_products #add_p"+id).val(num);
    if (num>=2)
        $("#add_products #delete_one"+id).attr("onclick","delete_one('"+ id+"')");
}

function delete_one(id){
    var num=parseInt($("#add_products #add_p"+id).val())-1;
    if (num==1){
        $("#add_products #delete_one"+id).attr("onclick","");
    }
    $("#add_products #add_p"+id).val(num);
}

function show_center(t){
    var doc_height = $(document).height();
    var doc_width = $(document).width();
    var layer_height = $(t).height();
    var layer_width = $(t).width();
    $(".mask").css({
        display:'block',
        height:($(t).height()+50)> doc_height?　$(t).height()+220 : doc_height
    });
    $(t).css('top',"50px");
    $(t).css('left',(doc_width-layer_width)/2);
    $(t).css('display','block');
    $(t + " .close").click(function(){
        $(t).css('display','none');
        $(".mask").css('display','none');
    });
}
function before_center(t){
    var doc_height = $(document).height();
    var doc_width = $(document).width();
    var layer_height = $(t).height();
    var layer_width = $(t).width();
    $(".maskOne").css({
        display:'block',
        height:($(t).height()+50)>doc_height?　$(t).height()+220 : doc_height
    });
    $(t).css('top',"50px");
    $(t).css('left',(doc_width-layer_width)/2);
    $(t).css('display','block');
    $(t + " .close").click(function(){
        $(t).css('display','none');
        $(".maskOne").css('display','none');
    });
}
//弹出层
function popup(t){
    var doc_height = $(document).height();
    var doc_width = $(document).width();
    var layer_width = $(t).width();
    $(".mask").css({
        display:'block',
        height:doc_height
    });
    $(t).css('top',"50px");
    $(t).css('left',(doc_width-layer_width)/2);
    $(t).css('display','block');

    $(t + " a.close").click(function(){
        $(t).css('display','none');
        $(".mask").css('display','none');
    })
}

function prod_delete(id){
    if (confirm("确定删除该产品吗？")){
        $.ajax({
            async:true,
            type : 'post',
            dataType : 'script',
            url : "/products/"+ id+"/prod_delete"
        });
    }
}

function serve_delete(id){
    if (confirm("确定删除该服务吗？")){
        $.ajax({
            async:true,
            type : 'post',
            dataType : 'script',
            url : "/products/"+ id+"/serve_delete"
        });
    }
}