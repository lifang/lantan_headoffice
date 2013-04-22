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