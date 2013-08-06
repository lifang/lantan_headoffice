$(document).ready(function(){
    $("#ugm_div_close").click(function(){
        $("#ugm_div").remove();
    })
});

/*在线QQ*/
$(function(){
    $('.online_qq').mouseover(function(){
  $(this).stop().animate( { right: '0px' } , 500 );
 })
 $('.online_qq').mouseout(function(){
  $(this).stop().animate( { right: '-100px' } , 500 );
 })
});
