$(document).ready(function(){
     $("#started_time").datepicker({
    inline: true
});
$("#ended_time").datepicker({
    inline: true
});
$("#use_search").click(function(){
    if(new Date($("#ended_time").val()) > 0 && new Date($("#ended_time").val()) < new Date($("#started_time").val())){
        alert("结束时间必须在开始时间之后!");
        return false;
    }
});
})