<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isELIgnored="false" %>
<%@ page session="false" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; UTF-8">
    <title>Welcome page</title>
    <link href="<c:url value='/static/css/style.css'/>" rel="stylesheet"/>
    <script src="<c:url value='/static/js/jquery-3.3.1.min.js'/>"></script>
</head>
<body style="background-image: url(/static/imgs/logo.png); background-size: 60%; background-repeat: no-repeat; background-position: 50% 50%">
<div class="flip form-container">

    <input id="flip-form-id" type="checkbox">
    <div class="flip__side front">

        <c:url var="loginUrl" value="/login" />
        <form:form action="${loginUrl}" method="post" class="form form--sign-in" name="form--sign-in" autocomplete="off">
            <h4 class="form__title">login</h4>

            <label class="field">
                <span class="caption"><i class="fa fa-user">&nbsp;</i>ID</span>
                <input class="field_input" type="text" required="required" title="Enter your username or e-mail" name="ssoId" autofocus/>
            </label>

            <label class="field">
                <span class="caption"><i class="fa fa-lock">&nbsp;</i>Password</span>
                <input class="field_input" type="password" required="required" title="Enter your password" name="password"/>
            </label>

            <label class="field checkbox">
                <input type="checkbox" name="remember-me"> Remember me
            </label>

            <c:if test="${param.logout != null}">
                <div class="logout-success">
                    <p>Logged out successfully</p>
                </div>
            </c:if>

            <c:if test="${param.error != null}">
                <div class="login-failed">
                    <p>Invalid username or password</p>
                </div>
            </c:if>

            <input type="hidden" name="${_csrf.parameterName}"  value="${_csrf.token}" />

            <div class="form__buttons">
                <div class="options-block">
                    <label for="flip-form-id">No account yet?</label>
                </div>
                <div class="buttons-block">
                    <input type="submit" value="Login">
                    <input type="reset" value="Reset">
                </div>
            </div>
        </form:form>
    </div>

    <div class="flip__side back">
            <form:form  method="POST" action="/newuser" class="form form--sign-up" modelAttribute="user" name="form--sign-up" autocomplete="off">

                <form:input type="hidden" path="id" id="id"/>

                <h4 class="form__title">registration</h4>

            <label class="field">
                <form:input type="text" path="firstName" placeholder="First name" required="required" class="field_input"/>
            </label>

            <label class="field">
                <form:input type="text" path="lastName" id="lastName" placeholder="Last name" required="required" class="field_input"/>
            </label>

            <label class="field">
                <form:input type="text" path="ssoId" id="ssoId" placeholder="ID" required="required" class="field_input" />
            </label>

            <label class="field">
                <form:input type="password" path="password" id="password" placeholder="password" required="required" class="field_input"/>
            </label>

            <label class="field">
                <form:input type="email" path="email" id="email" placeholder="user@company.com" required="required" class="field_input" />
            </label>
            <label class="field">
                <div class="row">
                    <div class="form-group col-md-12">
                        <div class="col-md-7">
                            <span style="padding-right: 10px">ROLES:</span>
                            <form:radiobutton  items="${roles}" path="userProfiles" required="required" label="USER" value="1"/>&nbsp;
                            <form:radiobutton  items="${roles}" path="userProfiles" label="ADMIN" value="2"/>
                        </div>
                    </div>
                </div>
            </label>
            <div class="form__buttons">
                <div class="options-block">
                    <label for="flip-form-id">Already registered?</label>
                </div>
                <div class="buttons-block">
                    <input type="submit" value="Register">
                    <input type="reset" value="Reset">
                </div>
            </div>
        </form:form>
    </div>
</div>
<%-----------Ajax ID check script----------------------%>
<script type="text/javascript">
    $(function() {
        $('#ssoId').blur(function() {
            $.ajax({
                url : 'checkId',
                data : ({text: $("#ssoId").val()}),
                success : function(response) {
                    var result = response.text;
                    if (result == null) {
                        alert('ID' + ' "'+ $("#ssoId").val() + '" ' + 'already exist. Please fill in different value.');
                        $("#ssoId").focus();
                        $('#ssoId').val('');
                    }
                }
            });
        });
    });
</script>
</body>
</html>