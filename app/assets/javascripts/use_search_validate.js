$(document).ready(function(){
     $("#started_time").click(function(){
        WdatePicker();
});
$("#ended_time").click(function(){
       WdatePicker();
});
$("#use_search").click(function(){
    if(new Date($("#ended_time").val()) > 0 && new Date($("#ended_time").val()) < new Date($("#started_time").val())){
        tishi_alert("结束时间必须在开始时间之后!");
        return false;
    }
});
})