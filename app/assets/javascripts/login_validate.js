
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

