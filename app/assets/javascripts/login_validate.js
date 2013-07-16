function login_validate(){
    if($.trim($("#username").val()) == ""){
        tishi_alert("用户名不能为空!");
        return false;
    }
    else if($.trim($("#password").val()) == ""){
        tishi_alert("密码不能为空!");
        return false;
    }
}
function manage_login_validate(){
    if($.trim($("#manager_name").val()) == ""){
        tishi_alert("用户名不能为空!");
        return false;
    }
    else if($.trim($("#manager_password").val()) == ""){
        tishi_alert("密码不能为空!");
        return false;
    }
}

