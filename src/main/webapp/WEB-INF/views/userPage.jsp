<%--<jsp:useBean id="user" scope="request" type="com.exchange.model.User"/>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>My accounts</title>
    <link href="<c:url value='/static/css/bs/bootstrap.css'/>" rel="stylesheet"/>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous">
    <script src="<c:url value='/static/js/jquery-3.3.1.min.js'/>"></script>
</head>
</head>
<body style="background-color:#484848; color: #CEC8D0">
<nav class="navbar navbar-expand-md navbar-dark bg-dark">
    <span class="navbar-brand">My accounts</span>
    <div class="navbar-collapse collapse justify-content-stretch">
        <ul class="navbar-nav" style="position: absolute; left: 50%; transform: translateX(-50%)">
            <li class="nav-item"><span class="navbar-brand">${success}</span></li>
            <li class="nav-item"><span class="navbar-brand">Total Balance: <span style="color: rgb(23,137,0)">$${sum}</span></span></li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <span class="ml-auto navbar-brand">${user.firstName}&nbsp;${user.lastName}</span>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle mr-3 mr-lg-0" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="far fa-user" style="color:rgb(23,137,0)"></i><span class="caret"></span>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                    <a class="dropdown-item" href="<c:url value='/user-profile-${user.ssoId}'/>">Profile</a>
                    <a class="dropdown-item" href="<c:url value='/logout' />">Logout</a>
                </div>
            </li>
        </ul>
    </div>
</nav>
<div align="center" style="margin: 5% 25%">
    <table class="table table-striped table-dark">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Account Number</th>
            <th scope="col">Balance, $</th>
            <th scope="col">Date/Time created</th>
            <th scope="col" style="text-align: center">Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${allAccounts}" var="account" varStatus="counter">
        <tr>
            <td scope="row">${counter.index + 1}</td>
            <td>${account.accountNumber}</td>
            <td>${account.amount}</td>
            <td>${account.timestamp}</td>
            <td>
                <div class="container">
                    <div class="row justify-content-md-center">
                        <div class="row">
                        <a class="btn btn-outline-secondary btn-sm" href="<c:url value='/accountManager-${user.id}-${account.id}'/>" style="margin-right: 10px">Handle</a>
                        <a class="btn btn-outline-danger btn-sm" href="<c:url value='/delete-${account.id}'/>" style="margin-right: 15px; width: 61px">Close</a>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="dropdown">
        <button type="button" class="btn btn-outline-success btn-block dropdown-toggle" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">New Account</button>
        <div class="dropdown-menu" style="width: -webkit-fill-available">
            <form:form action="/deposit-${user.id}" method="post" modelAttribute="userAccount" class="px-4 py-3" id="deposit">
                <div class="input-group mb-3">
                    <div class="input-group-prepend">
                        <span class="input-group-text" id="inputGroup-sizing-default">Preferred Deposit</span>
                    </div>
                        <form:input type="text" class="form-control" path="amount" required="required" aria-label="Default" id="amount" placeholder="min 0 max 9999999" aria-describedby="inputGroup-sizing-default"/>
                    <div class="input-group-append">
                        <span class="input-group-text">$</span>
                    </div>
                    <button id="add" value="" style="margin-left: 5%" type="submit" class="btn btn-success">Deposit</button>
                </div>
                <div>
                    <label for="amount" class="error" style="color: red"></label>
                </div>
            </form:form>
        </div>
    </div>
</div>
<script>
    $(function()
    {
        $("#deposit").validate({
             rules:{
                amount:
                    {
                    range:[0,9999999]
                }
            }
        });
    });
</script>
<script src="<c:url value='/static/js/jquery.validate.min.js'/>"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="<c:url value='/static/js/bootstrap.min.js'/>"></script>
</body>
</html>
