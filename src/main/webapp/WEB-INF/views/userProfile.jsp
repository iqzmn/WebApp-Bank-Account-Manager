<%--<jsp:useBean id="avatar" scope="request" type="com.exchange.model.UserAvatar"/>--%>
<jsp:useBean id="user" scope="request" type="com.exchange.model.User"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>Profile</title>
    <script src="<c:url value='/static/js/jquery-3.3.1.min.js'/>"></script>
    <link href="<c:url value='/static/css/bs/bootstrap.css'/>" rel="stylesheet"/>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous">

    <%--Show profile picture--%>
    <script>
        $(function(){
            function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        $('#ava').attr('src', e.target.result);
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            };
            $("#avainp").change(function() {
                readURL(this);
            });
        });
    </script>
</head>
<body style="background-color:#484848; color: #CEC8D0">
<nav class="navbar navbar-expand-md navbar-dark bg-dark">
    <span class="navbar-brand">Profile</span>
    <div class="navbar-collapse collapse justify-content-stretch">
        <ul class="navbar-nav" style="position: absolute; left: 50%; transform: translateX(-50%)">
            <li class="nav-item"><span class="navbar-brand">Total Balance: <span style="color: rgb(23,137,0)">$${sum}</span></span></li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <span class="ml-auto navbar-brand">${user.firstName}&nbsp;${user.lastName}</span>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle mr-3 mr-lg-0" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="far fa-user" style="color:rgb(23,137,0)"></i><span class="caret"></span>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                    <a class="dropdown-item" href="<c:url value='/userPage'/>">My accounts</a>
                    <a class="dropdown-item"  href="<c:url value='/logout' />">Logout</a>
                </div>
            </li>
        </ul>
    </div>
</nav>
<br>
<div class="container">
    <div class="row">
        <div class="col-md-4">
            <br>
            <div>
                <img src="data:image/jpeg;base64,${base64code}" alt="profile_picture" id="ava" class="img-rounded img-responsive" width="250px" height="250px"/>
            </div>
            <div><br></div>
            <div>
                <%--@elvariable id="fileBucket" type="com.exchange.model.FileBucket"--%>
                <form:form method="POST" action="/add-avatar-${user.id}" modelAttribute="fileBucket" enctype="multipart/form-data">
                    <c:set var = "avatar" scope = "session" value = "${user.userAvatar.id}"/>
                    <label class="btn btn-outline-primary btn-sm">Browse&hellip;
                        <form:input type="file" path="file" id="avainp" style="display:none"/>
                    </label>

                    <input type="submit" value="Save" class="btn btn-outline-success btn-sm" style="vertical-align: top; width: 72px; margin-left: 11px">

                    <c:if test = "${avatar != null}">
                        <a style="vertical-align: top; width: 72px; margin-left: 11px" class="btn btn-outline-danger btn-sm" href="<c:url value='/delete-avatar-${user.id}'/>">Delete</a>
                    </c:if>
                    <div class="has-error">
                        <form:errors path="file" class="help-inline"/>
                    </div>
                </form:form>
            </div>
        </div>

        <div class="col-md-8">
            <div class="col-md-9">
            <form:form modelAttribute="user" action="/user-edit-${user.ssoId}" method="post" autocomplete="off">
                <form:input type="hidden" path="id" id="id" value="${user.id}" />
                    <form:input type="hidden" path="password" value="${user.password}"/>
                    <form:input type="hidden" items="${roles}" path="userProfiles" label="USER" value="1" checked="checked"/>
                <div class="form-group">
                    <label for="FirstName">First Name</label>
                    <form:input type="text" path="firstName" class="form-control" id="FirstName" value="${user.firstName}"/>
                </div>
                <div class="form-group">
                    <label for="LastName">Last Name</label>
                    <form:input type="text" path="lastName" class="form-control" id="LastName" value="${user.lastName}"/>
                </div>
                <div class="form-group">
                    <label for="ssoId">ID</label>
                    <form:input type="text" path="ssoId" class="form-control" id="ssoId" value="${user.ssoId}"/>
                </div>
                <div class="form-group">
                    <label for="email">Email address</label>
                    <form:input type="email" path="email" class="form-control" id="email" value="${user.email}"/>
                </div>
                <br>
                <div>
                    <button type="submit" class="btn btn-outline-warning">Update</button>
                    <a style="width:78px; margin-left: 20px" class="btn btn-outline-danger" href="<c:url value='/user-delete-${user.ssoId}' />">Delete</a>
                </div>
            </form:form>
            </div>
        </div>
    </div>
</div>
<%-----------ID check----------------------%>
<script type="text/javascript">
    $(function() {
        var id1 = $('#ssoId').val();
        $('#ssoId').blur(function() {
            var id2 = $('#ssoId').val();
            if(id1 !== id2) {
                $.ajax({
                    url: 'checkId',
                    data: ({text: $("#ssoId").val()}),
                    success: function (response) {
                        var result = response.text;
                        if (result == null) {
                            alert('ID' + ' "' + $("#ssoId").val() + '" ' + 'already exist. Please fill in different value.');
                            $("#ssoId").focus();
                            $('#ssoId').val(id1);
                        }
                    }
                });
            }
        });
    });
</script>
<script src="<c:url value='/static/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/static/js/emailcheck.js'/>"></script>
</body>
</html>
