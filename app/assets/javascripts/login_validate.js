function login_validate(){
    if($.trim($("#username").val()) == ""){
        alert("用户名不能为空!");
        return false;
    }
    else if($.trim($("#password").val()) == ""){
        alert("密码不能为空!");
        return false;
    }
    else{
        return true;
    }
}