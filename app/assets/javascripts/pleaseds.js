$(document).ready(function(){
    $("#search_province").change(function(){
    var p_id = $(this).val();
    if(p_id == 0){
      $("#search_city").html("<option value='0'>------</option>");
    }else{
      $.ajax({
        type: "get",
        url: "/pleaseds/search_cities",
        data: {pid : p_id}
      })
    }
  })
})

function search_validate(){
    if($("#search_city").length>0 && $("#search_city").val()==0){
        tishi_alert("请选择城市!");
         return false;
    }else if($("#search_store_name").length>0 && $("#search_store_name").val()==0){
        tishi_alert("请选择门店!");
        return false;
    }
   
}