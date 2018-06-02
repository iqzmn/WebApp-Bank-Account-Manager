<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page isELIgnored="false" %>

<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <script src="<c:url value='/static/js/jquery-3.3.1.min.js'/>"></script>
    <link href="<c:url value='/static/css/bs/bootstrap.css'/>" rel="stylesheet"/>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous">
    <title>Admin Management</title>
    <style type="text/css">
        .form-control {
            width: 350px;
        }
    </style>
</head>
<body style="background-color: #484848; color: #CEC8D0">
<nav class="navbar navbar-expand-md navbar-dark bg-dark">
    <span class="navbar-brand">Admin area</span>
    <div class="navbar-collapse collapse justify-content-stretch">
        <ul class="navbar-nav" style="position: absolute; left: 50%; transform: translateX(-50%)">
            <li class="nav-item"><span>${success}</span></li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <span class="ml-auto navbar-text">${loggedinuser}</span>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle mr-3 mr-lg-0" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="far fa-user" style="color:orange"></i><span class="caret"></span>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                    <a class="dropdown-item"  href="<c:url value='/logout' />">Logout</a>
                </div>
            </li>
        </ul>
    </div>
</nav>

<div align="center" style="margin: 5% auto">
    <table class="table table-striped table-dark" style="width: auto;">
        <thead>
            <tr style="background-color: #b4b5b454">
                <th colspan="7">
                    <div class="row">
                        <div class="col col-md-8 text-left">
                            <span class="panel-heading">Users list</span>
                        </div>
                        <div class="col col-md-4 text-right">
                            <div class="dropleft">
                                <button type="button" class="btn btn-secondary btn-sm dropdown-toggle"
                                   data-toggle="dropdown"
                                   aria-haspopup="true"
                                   aria-expanded="false"
                                >New User</button>
                                <div class="dropdown-menu dropdown-menu-left">
                                    <form:form action="/saveUser" method="post" modelAttribute="user" class="px-4 py-3" autocomplete="off">
                                        <form:input type="hidden" path="id"/>
                                        <div class="form-group">
                                            <label>
                                                <form:input type="text" path="firstName" class="form-control" placeholder="First name" required="required"/>
                                            </label>
                                        </div>
                                        <div class="form-group">
                                            <label>
                                                <form:input type="text" path="lastName" class="form-control" placeholder="Last name" required="required"/>
                                            </label>
                                        </div>
                                        <div class="form-group">
                                            <label>
                                            <form:input type="text" path="ssoId" class="form-control" id="ssoId" placeholder="ID" required="required"/>
                                            </label>
                                        </div>
                                        <div class="form-group">
                                            <label>
                                            <form:input type="password" path="password" class="form-control" placeholder="**pass**" required="required"/>
                                            </label>
                                        </div>

                                        <div class="form-group">
                                            <label>
                                            <form:input type="email" path="email" id="email" class="form-control" placeholder="email@example.com" required="required" />
                                            </label>
                                        </div>
                                        <div class="input-group">
                                            <label class="field">
                                                <span>ROLES:&nbsp;</span>
                                                <form:radiobutton items="${roles}" path="userProfiles" checked="checked" label="USER" value="1"/>&nbsp;
                                                <form:radiobutton items="${roles}" path="userProfiles" label="ADMIN" value="2"/>
                                            </label>
                                        </div>
                                        <div class="container">
                                            <div class="row">
                                                <div class="col-md-offset-0">
                                                    <button type="submit" class="btn btn-primary">Register</button>
                                                </div>
                                                <div class="col-md-6">
                                                    <button style="width: 78px;" type="reset" class="btn btn-primary">Reset</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form:form>
                                </div>
                            </div>
                        </div>
                    </div>
                </th>
            </tr>
            <tr>
                <th scope="col">#</th>
                <th scope="col">ID</th>
                <th scope="col">First name</th>
                <th scope="col">Last name</th>
                <th scope="col">Email</th>
                <th scope="col">Role</th>
                <th scope="col" style="text-align: center">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}" varStatus="counter">
                <tr>
                    <td>${counter.index + 1}</td>
                    <td>${user.ssoId}</td>
                    <td>${user.firstName}</td>
                    <td>${user.lastName}</td>
                    <td>${user.email}</td>
                    <td>${user.userProfiles}</td>
                    <td style="text-align: center">
                        <div class="row">
                            <div class="col col-md-5">
                                <div class="dropdown">
                                    <button type="button" class="btn btn-outline-success btn-sm dropdown-toggle"
                                        style="width:60px"
                                        data-toggle="dropdown"
                                        aria-haspopup="true"
                                        aria-expanded="false"
                                        >Edit</button>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <form:form action="/edit-user-${user.ssoId}" modelAttribute="user" method="post" class="px-4 py-3" autocomplete="off">
                                                <form:input type="hidden" path="id" value="${user.id}" />
                                                <form:input type="hidden" path="password" value="${user.password}"/>
                                                <div class="form-group">
                                                    <label for="FirstName">First Name</label>
                                                    <form:input type="text" path="firstName" class="form-control" id="FirstName" value="${user.firstName}" required="required"/>
                                                </div>
                                                <div class="form-group">
                                                    <label for="LastName">Last Name</label>
                                                    <form:input type="text" path="lastName" class="form-control" id="LastName" value="${user.lastName}" required="required"/>
                                                </div>
                                                <div class="form-group">
                                                    <label for="ssoId">ID</label>
                                                    <form:input type="text" path="ssoId" class="form-control" id="ssoId" value="${user.ssoId}"  disabled="true" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="email">Email address</label>
                                                    <form:input type="email" path="email" class="form-control" id="email" value="${user.email}" required="required"/>
                                                </div>
                                                <div class="input-group">
                                                    <label class="field">
                                                        <span>ROLES:&nbsp;</span>
                                                        <form:radiobutton items="${roles}" path="userProfiles" label="USER" value="1" checked="checked"/>&nbsp;
                                                        <form:radiobutton items="${roles}" path="userProfiles" label="ADMIN" value="2"/>
                                                    </label>
                                                </div>
                                                <div class="container">
                                                    <div class="row">
                                                        <div class="col-md-offset-0">
                                                            <button type="submit" class="btn btn-primary">Update</button>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <button style="width: 78px;" type="reset" class="btn btn-primary">Reset </button>
                                                        </div>
                                                    </div>
                                                </div>
                                        </form:form>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-md-4">
                                <a style="width:60px" class="btn btn-outline-danger btn-sm" href="<c:url value='/delete-admin-${user.ssoId}' />">Delete</a>
                            </div>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script src="<c:url value='/static/js/idcheck.js'/>"></script>
<script src="<c:url value='/static/js/emailcheck.js'/>"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="<c:url value='/static/js/bootstrap.min.js'/>"></script>

</body>
</html>
