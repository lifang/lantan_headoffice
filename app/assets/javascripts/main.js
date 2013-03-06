// JavaScript Document
//登录默认值
function focusBlur(e){
	$(e).focus(function(){
		var thisVal = $(this).val();
		if(thisVal == this.defaultValue){
			$(this).val('');
		}	
	})	
	$(e).blur(function(){
		var thisVal = $(this).val();
		if(thisVal == ''){
			$(this).val(this.defaultValue);
		}	
	})	
}

$(function(){
	focusBlur('.login_box input');//用户信息input默认值
	focusBlur('.item input');//用户信息input默认值
})

//切换
 $(function() {
	 $('div.tab_head li').bind('click',function(){
	   		$(this).addClass('hover').siblings().removeClass('hover');
			var index = $('div.tab_head li').index(this);
			$('div.data_body > div').eq(index).show().siblings().hide();
	});
 })
 
 //基础数据权限配置 切换
 $(function() {
	 $('.groupFunc_h li').bind('click',function(){
	   		$(this).addClass('hover').siblings().removeClass('hover');
			var index = $('.groupFunc_h li').index(this);
			$('.groupFunc_b > div').eq(index).show().siblings().hide();
	});
 })
 
 
//偶数行变色
$(function(){
  $(".data_table > tbody > tr:odd").addClass("tbg");
  $(".data_tab_table > tbody > tr:odd").addClass("tbg");
});

//弹出层
function popup(t){
    var doc_height = $(document).height();
    var doc_width = $(document).width();
    var layer_width = $(t).width();
    $(".mask").css({
        display:'block',
        height:doc_height
    });
    $(t).css('top',"80px");
    $(t).css('left',(doc_width-layer_width)/2);
    $(t).css('display','block');

    $(" .close").click(function(){
        $(t).css('display','none');
        $(".mask").css('display','none');
    })
    $(".cancel_btn").click(function(){
        $(t).css('display','none');
        $(".mask").css('display','none');
    })
}



//现场施工
$(function(){
	var sitePayHeight = $(".site_pay").height();	
	$(".site_pay > h1").css("height",sitePayHeight);
	
	var siteWorkHeight = $(".site_work").height();	
	$(".site_work > h1").css("height",siteWorkHeight);
	
	var siteInfoHeight = $(".site_info").height();	
	$(".site_info > h1").css("height",siteInfoHeight);
})

//car_group car_x
$(function(){
	$(".car_group li").hover(
		function(){$(this).find(".group_x").css("display","block");},
		function(){$(this).find(".group_x").css("display","none");}
	)	
	$(".people_group li").hover(
		function(){
			$(this).find(".group_func").css("display","block");
			$(this).find(".group_x").css("display","block");
		},
		function(){
			$(this).find(".group_func").css("display","none");
			$(this).find(".group_x").css("display","none");
		}
	)	
})